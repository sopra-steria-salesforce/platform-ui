/**
 * Created by kjachowicz on 19.10.2023.
 */

import {api, LightningElement, track, wire} from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
export default class AccountPlanningContainer extends LightningElement {
    @track account
    @track accountRecordFields = {};
    @api recordId;
    @api objectApiName;
    @track editMode = false;
    get inputVariables() {
        return [
            {
                // Match with the input variable name declared in the flow.
                name: "recordId",
                type: "String",
                // Initial value to send to the flow input.
                value: this.recordId,
            }]
    }

    @wire(getRecord, { recordId: '$recordId', fields: '$fields' })
    fetchAccount(response) {
        if(response) {
            this.account = response
        }
    }


    handleClick(){
        this.editMode = true;
    }
}