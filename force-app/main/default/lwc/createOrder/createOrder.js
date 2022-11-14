/**
 * Helps user to create an Order for the Account
 * Implemented on Related list of Account
 */
import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import ordObject from '@salesforce/schema/Order';
import ordStartDate from '@salesforce/schema/Order.EffectiveDate';
import ordStatus from '@salesforce/schema/Order.Status';
import ordContract from '@salesforce/schema/Order.ContractId';
import ordAccount from '@salesforce/schema/Order.AccountId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import Order_Field from '@salesforce/schema/Order.Status'; 
import OrderObject from '@salesforce/schema/Order'; 

export default class CreateOrder extends LightningElement {
    @track picklistValues;
    startDate = '';
    status = '';
    contract='';
    columns = [
        {
            apiName: 'Name',
            label: 'Contract Number',
            isSortable: true
        },
        {
            apiName: 'Id',
            label: 'Contract Id',
            isSortable: true
        }
    ];

    /**
     * Get record id from current page
     */
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.attributes.recordId;
        }
    }

    /**
     * Get object info for Order : used with getting picklist values
    */
    @wire (getObjectInfo, {objectApiName: OrderObject})
    objectInfo;

    /**
     * Get picklist values of Status field on Order Object
     */
    @wire (getPicklistValues, {recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Order_Field})
    wiredPicklistValues({ error, data }) {
        // reset values to handle eg data provisioned then error provisioned
        this.picklistValues = undefined;
        if (data) {
            this.picklistValues = data.values;
        } else if (error) {
            console.log(error);
        }
    }  
    
    /**
     * update values of field inputs in lwc
     */
    orderChangeVal(event) {
        if(event.target.label=='Order Start Date'){
            this.startDate = new Date(event.target.value).toISOString();
        }
        if(event.target.label=='Status'){
            this.status = event.detail.value;
        }
        if(event.detail.fieldName=='Contract Name'){
            this.contract = event.detail.record.Id;
        }
    }

    /**
     * insert order when Create Order button is clicked
     */
    insertOrderAction() {
        const fields = {};
        fields[ordStartDate.fieldApiName] = this.startDate;
        fields[ordStatus.fieldApiName] = this.status;
        fields[ordContract.fieldApiName] = this.contract;
        fields[ordAccount.fieldApiName] = this.recordId;

        if (this.contract !== '') {
            const recordInput = { apiName: ordObject.objectApiName, fields };
            createRecord(recordInput)
            .then(orderObj=> {
                console.log(recordInput);
                this.orderId = orderObj.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Order record has been created',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message + ' | ' + 'Also, make sure the order\'s account must match the contract\'s account.: Contract ID',
                        variant: 'error',
                    }),
                );
            });
        }
        else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Contract Number is a required field',
                    variant: 'error',
                }),
            );
        }
    }
}