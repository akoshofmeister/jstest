<template>
	<div class="center-align">
		<h4>{{done ? 'Kész!' : 'Feldolgozás..'}}</h4>
		<i class="material-icons large">{{done ? 'done' : 'cached'}}</i><br>
		<span v-if="done">Rendelésed feldolgoztuk,<br>Köszönjük szépen!</span>
	</div>
</template>
<script>
import eventBus from '../eventBus'
import data from '../data'

export default {
	props: ['done']
}
</script>
<style scoped>

</style>
