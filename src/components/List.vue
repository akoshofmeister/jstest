<template>
	<div class="row">
		<div id="cartOrder" class="modal" :class="cart.balance > 0 && currentModal == 'Cart' ? 'modal-fixed-footer' : ''">
			<div class="modal-content">
				<component :is="currentModal" v-bind="modalProps"></component>
			</div>
			<div v-if="cart.balance > 0" class="modal-footer">
				<div class="sumBalance">
					ÖSSZESEN: <strong>{{cart.balance}} FT</strong>
				</div>
				<div>
					<div class="sumBalanceSmall">
						ÖSSZESEN: <strong>{{cart.balance}} FT</strong>
					</div>
					<a class="waves-effect waves-red btn-flat" @click="removeAll()">Rendelés törlése</a>
					<a class="waves-effect waves-green btn-flat" @click="order()" :disabled="cart.balance > cart.limit">Rendelés leadása</a>
				</div>
			</div>
		</div>
		<div class="fixed-action-btn modal-trigger" @click="openCart()">
			<div id="money" v-if="cart.balance > 0" class="transition money white-text z-depth-2" :class="cart.balance > cart.limit ? 'red' : 'green'">
			{{cart.balance}} Ft
			</div>
			<a class="btn-floating btn-large blue">
				<i class="large material-icons">shopping_cart</i>
			</a>
		</div>
		<div class="container">
			<div class="col s12">
				<div class="row s12">
					<div class="col input-field col transition" :class="searchText.length ? 's11' : 's12'">
						<input id="first_name" type="text" @input="search()" v-model="searchText">
						<label for="first_name">Keresés</label>
					</div>
					<div v-if="clearVisible" class="col s1" @click="resetSearch()" style="height: 65px; padding-top: 20px;">
						<a class="btn-flat btn-floating waves-effect waves-dark white"><i class="material-icons black-text">clear</i></a>
					</div>
				</div>
				<div class="row center-align">
					<a
						v-for="(cat, index) in categories"
						:key="index"
						class="btn waves-effect waves-dark category blue"
						:class="selectedCats.indexOf(cat) == -1 ? 'white black-text btn-flat': ''"
						@click="toggleCat(cat)"
					>
						{{getLang(cat)}}
					</a>
				</div>
			</div>
		</div>
		<top10 :productsById="productsById"></top10>
		<div class="container">
			<div class="col s12">
				<div class="row" :class="!products.length && searchText != '' ? 'center-align' : ''">
					<ul v-if="products.length" class="collapsible expandable">
						<li :id="'list_'+index" v-for="(product, index) in products" :key="index">
							<div class="collapsible-header">
								<span style="width: 100%; text-align: left;">
									<span class="badge hover transition" @click.stop="addToCart(product.id)">
										<i class="material-icons">add_shopping_cart</i>
									</span>
									<span v-if="cart.items[product.id]" data-badge-caption="" class="new badge blue productBadge">
										{{cart.items[product.id]}} db
									</span>
									<span v-if="product.vegetarian" data-badge-caption="" class="new badge green productBadge">
										vegetáriánus
									</span>
									<span v-if="product.spicy" data-badge-caption="" class="new badge red productBadge">
										csípős
									</span>
									<i class="material-icons" style="vertical-align: middle" :title="getLang(product.category)">{{getIcon(product.category)}}</i>{{product.name}}
								</span>
							</div>
							<div class="collapsible-body" style="text-align: left">
								<span>
									Ár: {{product.price}} Ft <br>
									{{product.description}}
								</span>
							</div>
						</li>
					</ul>
					<span v-if="!products.length && searchText != ''">
						<i class="large material-icons">
							sentiment_very_dissatisfied
						</i><br>
						Nincs a keresésnek megfelelő találat!
						<span v-if="selectedCats.length == 0"><br>Válassz ki kategóriát!</span>
					</span>
				</div>
			</div>
		</div>
	</div>
</template>
<script>
import data from '../data'
import _ from 'lodash'
import Vue from 'vue'
import eventBus from '../eventBus'
import axios from 'axios'

export default {
  	name: 'List',
  	data() {
    	return {
			data,
			searchText: '',
			clearVisible: false,
			selectedCats: [],
			list: null,
			cart: {
				balance: 0,
				items: {},
				limit: 20000
			},
			modal: '',
			currentModal: '',
			modalProps: {}
    	};
	},
	computed: {
		products() {
			return data.products.filter((product) => 
				this.selectedCats.indexOf(product.category) > -1 &&
				(!this.searchText.length || product.name.toLowerCase().indexOf(this.searchText.trim().toLowerCase()) > -1)
			)
		},
		productsById() {
			return data.products.reduce((acc, product) => { acc[product.id] = product; return acc; }, {})
		},
		categories() {
			return Object.keys(data.products).reduce((acc, key) => { 
				if (acc.indexOf(data.products[key].category) == -1)
					acc.push(data.products[key].category)
					 
				return acc
			}, []).sort()
		}
	},
	methods: {
		d_toggleClearButton: _.debounce(function () {
			this.clearVisible = this.searchText.length
		}, 200, {maxWait: 200}),
		search () {
			if (this.searchText.length)
				this.d_toggleClearButton()
			else 
				this.clearVisible = false

			this.initUI()
		},
		resetSearch () {
			this.searchText = ''
			this.search()
			this.initUI()
		},
		initUI () {
			Vue.nextTick(function () {
				let elem = document.querySelectorAll('.collapsible.expandable')
				M.Collapsible.init(elem, { accordion: false })

				M.updateTextFields();
			});
		},
		getIcon (cat) {
			return data.icons[cat.toLowerCase()] || 'local_dining'
		},
		getLang (str) {
			return _.capitalize(data.lang[str.toLowerCase()] || str.toLowerCase())
		},
		toggleCat (cat) {
			let index = this.selectedCats.indexOf(cat)

			if (index == -1) 
				this.selectedCats.push(cat)
			else
				this.selectedCats.splice(index, 1)
			
			this.initUI()
		},
		addToCart (id) {
			if (this.cart.balance > this.cart.limit) {
				this.animateBalance()
			} else {
				let product = this.productsById[id]

				if (!this.cart.items[product.id]) this.cart.items[product.id] = 0
				
				this.cart.items[product.id]++
				this.cart.balance += product.price

				this.animateBalance()
			}
		},
		removeCart (id) {
			if (!this.cart.items[id])
				return

			this.cart.items[id]--

			if (this.cart.items[id] <= 0)
				delete this.cart.items[id]

			this.cart.balance -= this.productsById[id].price

			this.animateBalance()
		},
		animateBalance: _.debounce(function () {
			setTimeout(function () { document.getElementById('money').classList.remove('add') });
			setTimeout(function () { document.getElementById('money').classList.add('add') }, 100);
		}, 100, {maxWait: 1000}),
		removeAll () {
			this.modal.close();

			setTimeout(() => {
				this.cart.balance = 0
				this.cart.items = {}

				this.currentModal = 'Cart'
				this.modalProps = {
					'cart': this.cart,
					'productsById': this.productsById
				}
				this.modal.open();
			}, 300)
		},
		order () {
			if (this.currentModal == 'Order') {
				eventBus.$emit('order')
			} else {
				let tm = 0

				if (this.modal.isOpen) {
					this.modal.close();
					tm = 300
				}

				setTimeout(() => {
					this.currentModal = 'Order'
					this.modalProps = {
						'balance': this.cart.balance
					}

					this.modal.open();
				}, tm)
			}
		},
		doneOrder (obj) {
			axios.post('http://localhost:3000/order', {
				firstname: obj.firstname,
				lastname: obj.lastname,
				number: obj.number,
				city: obj.city,
				street: obj.street,
				zip: obj.zip,
				products: Object.keys(this.cart.items).reduce((acc, id) => {
					acc.push({ id: parseInt(id), amount: this.cart.items[id]})
					return acc
				}, [])
			})
				.then((res) => {
					this.cart.balance = 0;
					this.cart.items = {};

					this.modal.close();

					setTimeout(() => {
						this.currentModal = 'DoneOrder'
						this.modalProps = {}
						this.modal.open();
					}, 300)
				})
				.catch((err) => {
					this.cart.balance = 0;
					this.cart.items = {};
					
					this.modal.close();

					setTimeout(() => {
						this.currentModal = 'FailedOrder'
						this.modalProps = {}
						this.modal.open();
					}, 300)
				})
		},
		openCart () {
			this.modal.isOpen && this.modal.close();

			this.currentModal = 'Cart'
			this.modalProps = {
				'cart': this.cart,
				'productsById': this.productsById
			}

			this.modal.open();
		}
	},
	mounted() {
		this.selectedCats = this.categories.filter(() => true)
		this.initUI()

		this.modal = M.Modal.init(document.querySelector('#cartOrder'));
		M.FloatingActionButton.init(document.querySelectorAll('.fixed-action-btn'));

		eventBus.$on('addToCart', this.addToCart)
		eventBus.$on('removeCart', this.removeCart)
		eventBus.$on('doneOrder', this.doneOrder)
	}
	 
};
</script>
<style scoped>
	@media screen and (max-width: 600px) {
		.sumBalanceSmall {
			display: block;
			margin: 15px;
		}

		.modal-footer {
			text-align: center;
		}

		.sumBalance {
			display: none;
		}
	}

	@media screen and (min-width: 600px) {
		.sumBalanceSmall {
			display: none;
		}
		.sumBalance {
			display: block;
		}
	}
	

	.transition {
		transition: all .1s;
	}

	.category {
		margin-right: 5pt;
		margin-bottom: 5pt;
	}

	.hover:hover {
		color: black;
		animation-name: cart;
    	animation-duration: .5s;
	}

	@keyframes cart {
		0%   {transform: scale(1)}
		50%  {transform: scale(1.1)}
		100% {transform: scale(1)}
	}

	.money {
		border-radius: 10pt;
		font-size: .9em;
		position: absolute;
		z-index: 10;
		padding: 3pt;
		left: -30px;
		top: 50px;
	}

	.money.add {
		animation-name: cart;
    	animation-duration: .5s;
	}

	.pointer {
		cursor: pointer;
	}

	.productBadge {
		margin-left: 5pt !important;
	}

	.sumBalance {
		float: left;
		margin: 6px 20px;
		font-size: 14px;
		line-height: 36px;
	}

	.badge {
		user-select: none;
	}
</style>
