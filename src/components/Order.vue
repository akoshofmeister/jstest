<template>
	<div class="center-align">
		<h4>Rendelés leadása</h4>
		<form class="col s12" id="order">
			<div class="row">
				<div class="input-field col s6">
				<input id="lastName" type="text" class="validate" v-model="lastname" required>
				<label for="lastName">Vezetéknév</label>
				<span class="helper-text" data-error="Kötelező"></span>
				</div>
				<div class="input-field col s6">
				<input id="firstName" type="text" class="validate" v-model="firstname" required>
				<label for="firstName">Keresztnév</label>
				<span class="helper-text" data-error="Kötelező"></span>
				</div>
			</div>
			<div class="row">
				<div class="input-field col s3">
					<input id="zip" type="text" class="validate" v-model="zip" required>
					<label for="zip">Irányítószám</label>
					<span class="helper-text" data-error="Kötelező"></span>
				</div>
				<div class="input-field col s3">
					<input id="city" type="text" class="validate" v-model="city" required>
					<label for="city">Város</label>
					<span class="helper-text" data-error="Kötelező"></span>
				</div>
				<div class="input-field col s3">
					<input id="street" type="text" class="validate" v-model="street" required>
					<label for="street">Utca</label>
					<span class="helper-text" data-error="Kötelező"></span>
				</div>
				<div class="input-field col s3">
					<input id="number" type="text" class="validate" v-model="number" required>
					<label for="number">Házszám</label>
					<span class="helper-text" data-error="Kötelező"></span>
				</div>
			</div>
		</form>
	</div>
</template>
<script>
import eventBus from '../eventBus'
import data from '../data'

export default {
	data() {
		return {
			firstname: '',
			lastname: '',
			zip: '',
			city: '',
			street: '',
			number: ''
		}
	},
	methods: {
		order () {
			let invalid = false

			if( this.firstname == '' ) {
				document.getElementById('firstName').classList.add('invalid')
				invalid = true
			}

			if( this.lastname == '' ) {
				document.getElementById('lastName').classList.add('invalid')
				invalid = true
			}

			if( this.zip == '' ) {
				document.getElementById('zip').classList.add('invalid')
				invalid = true
			}

			if( this.city == '' ) {
				document.getElementById('city').classList.add('invalid')
				invalid = true
			}

			if( this.street == '' ) {
				document.getElementById('street').classList.add('invalid')
				invalid = true
			}

			if( this.number == '' ) {
				document.getElementById('number').classList.add('invalid')
				invalid = true
			}

			if (invalid)
				return

			eventBus.$emit('doneOrder', {
				firstname: this.firstname,
				lastname: this.lastname,
				number: this.number,
				city: this.city,
				street: this.street,
				zip: this.zip
			})
			
			this.firstname = ''
			this.lastname = ''
			this.zip = ''
			this.city = ''
			this.street = ''
			this.number = ''
		}
	},
	mounted () {
		M.updateTextFields();
		eventBus.$on('order', this.order)
	}
}
</script>
<style scoped>

</style>
