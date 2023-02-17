<script>
export default {
    data() {
        return {
            appToken: 'bqwmxxecukzezebgu2w3ebntrkjd',
            userToken: 'b6d543_jeym_0_838zxn2ajtg44ywt68d4kbyr6',
            axiosInstance: null,
            loading:false,
            error:null
        }
    },
    methods: {
        onCreatedCallback(){
            // this should be overridden in the child
        }
    },
    created() {

        // init axios with custom auth header
        this.axiosInstance = window.Axios.create();

        // define common error handler
        this.axiosInstance.interceptors.response.use(
            (response) => {return response;},
            (error) => {

                // stop loading
                this.loading = false;
                console.error(error);
                //get error message(s)
                this.error = "An unknown error occurred, please try again.";
                if(error !== undefined && error.response !== undefined && error.response.data !== undefined && error.response.data.errors !== undefined){
                    let errorMessage = '';
                    error.response.data.errors.forEach((msg) => {
                        errorMessage += msg + " ";
                    });
                    this.error = errorMessage;
                }else if(error !== undefined && error.message !== undefined){
                    this.error = error.message;
                }else if(error !== undefined){
                    this.error = JSON.stringify(error);
                }

                // reject
                return Promise.reject(error);
            });

        this.onCreatedCallback();
    }
}
</script>
