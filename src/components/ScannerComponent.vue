<template xmlns:v-on="http://www.w3.org/1999/xhtml">
    <div>

        <!-- loading widget -->
        <loading-component v-if="loading"></loading-component>

        <!-- container -->
        <div v-if="!loading" class="scanner-container">
            <div class="form-group scanner-item-container">
                <label>Database</label>
                <select v-model="selectedApiDatabase">
                    <option value="bptf45pn2">Inventory Count Table</option>
                    <option value="bptf5kvbe">Inventory Count Details Table</option>
                </select>
            </div>
            <div class="form-group scanner-item-container">
                <label>Available Scanners</label>
                <select v-model="selectedScannerIndex" @change="barcodeScannerSelected">
                    <option v-for="(barcodeScanner, barcodeScannerIndex) in scanners" :value="barcodeScannerIndex" :key="barcodeScannerIndex">{{barcodeScanner.friendlyName}}</option>
                </select>
            </div>
            <div class="form-group scanner-item-container ">
                <label>Debug</label>
                <p>{{message}}</p>
            </div>
            <div class="scanner-item-container">
                <div class="form-group">
                    <label>Barcode Data</label>
                    <p>{{scanResult && scanResult.data ? scanResult.data : ' '}}</p>
                </div>
                <div class="form-group">
                    <label>Barcode Source</label>
                    <p>{{scanResult && scanResult.source ? scanResult.source : ' '}}</p>
                </div>
                <div class="form-group">
                    <label>Barcode Type</label>
                    <p>{{scanResult && scanResult.type ? scanResult.type : ' '}}</p>
                </div>
                <div class="form-group">
                    <label>Barcode Time</label>
                    <p>{{scanResult && scanResult.time ? scanResult.time : ' '}}</p>
                </div>
            </div>
            <div class="form-group scanner-item-container error" v-if="error">
                <label>Error</label>
                <p>{{error}}</p>
            </div>
            <div class="scanner-btn-container">
                <button class="btn-block scanner-btn" @click="sendScanResult">Send Result</button>
            </div>
        </div>
    </div>
</template>

<script>
import BaseComponent from './BaseComponent.vue'
import LoadingComponent from './LoadingComponent.vue'
export default {
    extends: BaseComponent,
    name: 'scanner-component',
    components: {
        LoadingComponent
    },
    data() {
        return {
            message: 'Please select a scanner.',
            scanners: [],
            selectedScannerIndex: null,
            selectedApiDatabase: 'bptf45pn2',
            scanResult: null
        }
    },
    methods: {

        /**
         * Uses EB library to detect all scanners, should only need to do so once.
         */
        enumerateScanners(){
            if(window.EB !== undefined){
                this.loading = true;
                window.EB.Barcode.enumerate((barcodeObjects) => {

                    // set scanners and select default
                    this.scanners = [];
                    this.selectedScannerIndex = null;
                    if(barcodeObjects != null && barcodeObjects.length > 0){

                        // debug
                        this.message = 'Found ' + this.scanners.length + ' scanners.';

                        // default to 2D
                        barcodeObjects.forEach((scanner) => {
                            if(scanner !== null && scanner !== undefined && scanner.friendlyName !== null && scanner.friendlyName !== undefined){
                                this.scanners.push(scanner);
                                if(scanner.friendlyName.includes('2D')){
                                    this.selectedScannerIndex = this.scanners.length - 1;
                                }
                            }
                        })

                        this.barcodeScannerSelected();
                    }else{
                        // debug
                        this.message = 'No scanners found.';
                    }
                    this.loading = false;
                });
            }
        },

        /**
         * Once the user selects a scanner let's enable it ready to scan.
         */
        barcodeScannerSelected(){
            if(this.scanners == null || this.scanners.length <= 0 || this.selectedScannerIndex == null) return;

            // reset
            this.scanResult = null;

            // debug
            this.message = 'Selected: ' + this.scanners[this.selectedScannerIndex].friendlyName;

            // enable
            let barcodeToEnable = this.scanners[this.selectedScannerIndex];
            barcodeToEnable.enable({}, (decodedBarcode)=> {
                this.scanResult = decodedBarcode;
                this.error = null;

                // TODO get record info of scanned ID for user prompting
                // this.apiGetRecordInfo(recordId);
            });
            this.message = 'Enabled: ' + this.scanners[this.selectedScannerIndex].friendlyName;
            this.loading = false;
            this.error = null;
        },

        /**
         * Query a DB for records.
         * @returns {Promise<void>}
         */
        async apiDoQuery(){

            // load
            this.loading = true;
            this.error = null;

            // send result
            const { data } = await this.axiosInstance.get('https://pies.quickbase.com/db/'+this.selectedApiDatabase+'?act=API_DoQuery&options=num-5'+'&apptoken='+this.appToken+'&usertoken='+this.userToken);
            this.message = 'Result: ' + JSON.stringify(data);

            // reset
            this.scanResult = null
            this.loading = false;
            this.error = null;
        },

        /**
         * Get DB info.
         * @returns {Promise<void>}
         */
        async apiGetDbInfo(){

            // load
            this.loading = true;
            this.error = null;

            // send result
            const { data } = await this.axiosInstance.get('https://pies.quickbase.com/db/'+this.selectedApiDatabase+'?act=API_GetDBInfo'+'&apptoken='+this.appToken+'&usertoken='+this.userToken);

            // debug
            this.message = 'Result: ' + JSON.stringify(data);

            // reset
            this.scanResult = null
            this.loading = false;
            this.error = null;
        },

        /**
         * Get an individual record info by ID
         * @param recordId
         * @returns {Promise<void>}
         */
        async apiGetRecordInfo(recordId){

            // load
            this.loading = true;
            this.error = null;

            // build field query
            let newRecordFields = '&rid='+recordId;

            // send result
            const { data } = await this.axiosInstance.get('https://pies.quickbase.com/db/'+this.selectedApiDatabase+'?act=API_GetRecordInfo'+newRecordFields+'&apptoken='+this.appToken+'&usertoken='+this.userToken);

            // debug
            this.message = 'Result: ' + JSON.stringify(data);

            // reset
            this.scanResult = null
            this.loading = false;
            this.error = null;
        },

        /**
         * Once the users hits the send result button.
         * @returns {Promise<void>}
         */
        async sendScanResult(){
            if(this.scanResult == null) {
                this.error = "No scan result found. Please scan a barcode.";
                return;
            }

            // load
            this.loading = true;
            this.error = null;

            // TODO update based on scan data and selected DB
            // build field query for adding record
            let newRecordFields = '';
            if(this.selectedApiDatabase === 'bptf45pn2'){
                newRecordFields = '&_fid_9=1';
            }else if(this.selectedApiDatabase === 'bptf5kvbe'){
                newRecordFields = '&_fid_7=1';
            }

            // send result
            const { data } = await this.axiosInstance.get('https://pies.quickbase.com/db/'+this.selectedApiDatabase+'?act=API_AddRecord'+newRecordFields+'&apptoken='+this.appToken+'&usertoken='+this.userToken);

            // debug
            this.message = 'Result: ' + JSON.stringify(data);

            // reset
            this.scanResult = null
            this.loading = false;
            this.error = null;
        },

        /**
         * This component extends the BaseComponent and this function is called after the BaseComponent is created.
         */
        onCreatedCallback(){
            // load scanners
            this.enumerateScanners();
        }
    }
}
</script>
