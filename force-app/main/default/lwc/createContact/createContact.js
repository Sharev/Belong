/**
 * Helps user to create a Contact for the Account
 * Implemented on Related list of Account
 */
import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import conObject from '@salesforce/schema/Contact';
import conFirstName from '@salesforce/schema/Contact.FirstName';
import conLastName from '@salesforce/schema/Contact.LastName';
import conEmail from '@salesforce/schema/Contact.Email';
import conMobPhone from '@salesforce/schema/Contact.MobilePhone';
import conAccount from '@salesforce/schema/Contact.AccountId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateContact extends LightningElement {
    firstName = '';
    lastName = '';
    emailId='';
    mobileVal='';
    recIdVal='';

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
     * update values of field inputs in lwc
     */
    contactChangeVal(event) {
        if(event.target.label=='First Name'){
            this.firstName = event.target.value;
        }
        if(event.target.label=='Last Name'){
            this.lastName = event.target.value;
        }
        if(event.target.label=='Email'){
            this.emailId = event.target.value;
        }
        if(event.target.label=='Mobile Number'){
            this.mobileVal = event.target.value;
        }
    }

    /**
     * insert Contact when Create Contact button is clicked
     */
    insertContactAction() {
        const fields = {};
        fields[conFirstName.fieldApiName] = this.firstName;
        fields[conLastName.fieldApiName] = this.lastName;
        fields[conEmail.fieldApiName] = this.emailId;
        fields[conMobPhone.fieldApiName] = this.mobileVal;
        fields[conAccount.fieldApiName] = this.recordId;

        const recordInput = { apiName: conObject.objectApiName, fields };

        createRecord(recordInput)
            .then(contactobj=> {
                console.log(recordInput);
                this.contactId = contactobj.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact record has been created',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });  
                  
    }
}