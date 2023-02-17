<template xmlns:v-on="http://www.w3.org/1999/xhtml">
  <div>

    <!-- top navbar -->
    <navbar-component v-bind:title="title"></navbar-component>

    <!-- primary content -->
    <div class="app-content">

      <!-- scanner -->
      <scanner-component ></scanner-component>

    </div>
  </div>
</template>

<script>
import NavbarComponent from './components/NavbarComponent.vue'
import ScannerComponent from './components/ScannerComponent.vue'
import './main.scss'
export default {
  name: 'App',
  components: {
    NavbarComponent,
    ScannerComponent
  },
  data() {
    return {
      title:'Scanner App'
    }
  },
  methods: {
  }
}
</script>
