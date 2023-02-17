// import vue
window.Vue = require('vue');

// axios for http requests
window.Axios = require('axios').default;

// create app with div id
import App from './App.vue'
window.Vue.createApp(App).mount('#app');
