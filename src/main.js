import Vue from 'vue'
import App from './App.vue'
import store from './vuex/store'

import './unit/const';
import './control';
import { subscribeRecord } from './unit';
subscribeRecord(store); 
Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#root',
  render: h => h(App),
  store: store
})
