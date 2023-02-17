<template xmlns:v-on="http://www.w3.org/1999/xhtml">
    <div class="navbar-container">
        <h4 class="navbar-title">{{title ? title : 'Scanner'}}</h4>
    </div>
</template>

<script>
export default {
    name: 'navbar-component',
    props: ['title'],
    data() {
        return {
        }
    },
    methods: {
    }
}
</script>
