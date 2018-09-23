// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import Order from './components/Order'
import Cart from './components/Cart'
import Top10 from './components/Top10'
import DoneOrder from './components/DoneOrder'
import FailedOrder from './components/FailedOrder'
import router from './router'
import axios from 'axios'

import data from './data'

require('materialize-css/dist/css/materialize.css')
require('materialize-css/dist/js/materialize.js')

Vue.config.productionTip = false

Vue.component('Cart', Cart)
Vue.component('Order', Order)
Vue.component('Top10', Top10)
Vue.component('DoneOrder', DoneOrder)
Vue.component('FailedOrder', FailedOrder)

let promises = [];

(['products', 'stats']).forEach(url => {
  promises.push(new Promise((resolve, reject) => {
    axios.get('http://localhost:3000/' + url)
    .then(res => {
      if (res.data.type == 'done') {
        data[url] = res.data.data
        resolve()
      } else {
        reject()
      }
    })
    .catch(err => {
      console.log(err)
      reject()
    })
  }))
});

Promise.all(promises)
  .then(k => {
    console.log(data)
    new Vue({
      el: '#app',
      router,
      components: { App, Order, Cart },
      template: '<App/>'
    })
  })
  .catch(err => alert("Error loading data"))

/* eslint-disable no-new */

