<template>
	<div class="col s12">
		<div class="row center-align pointer" @click="toggle()" >
			<h5>A 10 legtöbbet rendelt <i class="material-icons closeArrow" :class="closed ? 'closed' : ''">keyboard_arrow_down</i></h5>
		</div>
		<transition name="fade">
			<div class="row flex" v-if="!closed">
				<div v-for="(prod, key) in top" :key="key" class="col cardCol">
					<div class="card left-align">
						<div class="card-image">
							<a @click="addToCart(prod.id)" class="btn-floating halfway-fab waves-effect waves-light blue"><i class="material-icons">add_shopping_cart</i></a>
						</div>
						<div class="card-content">
							<h5>{{productsById[prod.id].name}}</h5>
							<p>
								{{productsById[prod.id].description}}
								<p style="margin-top: 10pt;">
									Ár: {{productsById[prod.id].price}} Ft
								</p>
								<p style="margin-top: 10pt;">
									<span v-if="productsById[prod.id].vegetarian" class="green white-text productBadgeLittle">
										vegetáriánus
									</span>
									<span v-if="productsById[prod.id].spicy" class="red white-text productBadgeLittle">
										csípős
									</span>
								</p>
							</p>
							<span class="btn-floating halfway-fab yellow darken-2 center-align" style="cursor: default;">#{{key + 1}}</span>
						</div>
					</div>
				</div>
			</div>
		</transition>
	</div>
</template>
<script>
import data from '../data'
import eventBus from '../eventBus'

export default {
	props: ['productsById'],
	data() {
		return {
			data,
			closed: false
		}
	},
	computed: {
		top () {
			if (data.stats.length == 10)
				return data.stats.map(stat => {
					return {id: stat.productId, amount: stat.amount}
				})
			else {
				let tmp = data.stats.map(stat => {
					return {id: stat.productId, amount: stat.amount}
				})

				let getRandom = () => {
					return data.products[Math.floor(Math.random() * data.products.length)]
				}

				for (let i = 0; i < 10 - data.stats.length; ++i) {
					let prod = getRandom()

					while (tmp.find((p => p.id == prod.id))) {
						prod = getRandom()
					}

					tmp.push({id: prod.id, amount: 1})
				}

				return tmp
			}
		}
	},
	methods: {
		addToCart (id) {
			eventBus.$emit('addToCart', id)
		},
		toggle () {
			this.closed = !this.closed
		}
	}
}
</script>
<style scoped>
	.fade-enter-active, .fade-leave-active {
		transition: opacity .5s;
	}
	.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
		opacity: 0;
	}

	.badge {
		user-select: none;
	}

	.pointer {
		cursor: pointer;
	}

	.closeArrow {
		transition: all .5s;
		user-select: none;
	}

	.closed {
		transform: scaleY(-1)
	}

	.productBadgeLittle {
		margin-right: 5pt;
		font-size: .8rem;
		padding: 3pt;
		border-radius: 1pt;
		font-weight: 300;
	}

	@media screen and (max-width: 600px) {
		.cardCol {
			width: 100% !important;
			margin-top: 20pt;
		}
	}

	@media screen and (max-width: 1200px) and (min-width: 601px) {
		.cardCol {
			width: 25% !important;
			margin-top: 20pt;
		}
	}

	@media screen and (min-width: 1201px) {
		.cardCol {
			width: 20% !important;
			margin-top: 20pt;
		}
	}

	@media screen and (min-width: 1900px) {
		.cardCol {
			width: 10% !important;
		}
	}

	.card-content {
		padding: 5pt !important;
		height: 250px;
		overflow: hidden;
	}

	.flex {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
	}
</style>


