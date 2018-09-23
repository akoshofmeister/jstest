<template>
	<div class="center-align">
		<h4>A kosarad</h4>
		<div v-if="cart.balance > cart.limit" class="z-depth-1 red white-text error">
			Csak {{cart.limit}} Ft alatti rendelést tudunk feldolgozni.
		</div>
		<p>
			<div v-if="cart.balance > 0">
				<ul class="collection left-align">
					<li v-for="(id, key) in Object.keys(cart.items)" :key="key" class="collection-item avatar">
						<span class="badge transition pointer">
							<i class="material-icons hover" @click="addToCart(id)">add_shopping_cart</i><br>
							<i class="material-icons hover" @click="removeCart(id)">remove_shopping_cart</i>
						</span>
						<i class="material-icons circle green" style="vertical-align: middle" :title="getLang(productsById[id].category)">{{getIcon(productsById[id].category)}}</i>
						<span class="title">{{productsById[id].name}}</span>
						<p>
							{{cart.items[id]}} db<br>
							{{cart.items[id] * productsById[id].price}} Ft<br>
							<span v-if="productsById[id].vegetarian" class="green white-text productBadgeLittle">
								vegetáriánus
							</span>
							<span v-if="productsById[id].spicy" class="red white-text productBadgeLittle">
								csípős
							</span>
						</p>
					</li>
				</ul>
			</div>
			<span style="width: 100%;" class="center-align" v-if="cart.balance == 0">
				<i class="material-icons large">shopping_cart</i><br>
				A kosár üres.
			</span>
		</p>
	</div>
</template>
<script>
import eventBus from '../eventBus'
import data from '../data'
import _ from 'lodash'

export default {
	name: 'Cart',
	props: ['cart', 'productsById'],
	data() {
		return {
			
		}
	},
	methods: {
		addToCart (id) {
			eventBus.$emit('addToCart', id)
		},
		removeCart (id) {
			eventBus.$emit('removeCart', id)
		},
		getIcon(cat) {
			return data.icons[cat.toLowerCase()] || 'local_dining'
		},
		getLang(str) {
			return _.capitalize(data.lang[str.toLowerCase()] || str.toLowerCase())
		},
	}
}
</script>
<style scoped>
	.productBadgeLittle {
		margin-right: 5pt;
		font-size: .8rem;
		padding: 3pt;
		border-radius: 1pt;
		font-weight: 300;
	}

	.error {
		padding: 2pt;
		width: 350px;
		border-radius: 2pt;
		margin: 5pt auto;
	}

	.pointer {
		cursor: pointer;
	}

	.transition {
		transition: all .1s;
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

	.badge {
		user-select: none;
	}
</style>
