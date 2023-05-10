import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import { getPicklistValues, getObjectInfo  } from 'lightning/uiObjectInfoApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
import AccountObject from '@salesforce/schema/Account'; 
import getTasks from '@salesforce/apex/AccountSingle.getTasks';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNTNUMBER_FIELD from '@salesforce/schema/Account.AccountNumber';
import ID_FIELD from '@salesforce/schema/Account.Id';

const FIELDS = [
    'Account.Name',
    'Account.AccountNumber',
    'Account.Type',
];

export default class LWC_FastEditField extends LightningElement {
    @api recordId;
    account;
    name;
    accountnumber;
    type;
    recordtypeid;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contact',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            console.log(data);
            console.log('done');
            this.account = data;
            this.name = this.account.fields.Name.value;
            this.accountnumber = this.account.fields.AccountNumber.value;
            this.type = this.account.fields.Type.value;
        }
    }
    
    @wire (getObjectInfo, {objectApiName: AccountObject})
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: TYPE_FIELD })
    wiredPicklistValues({ error, data }) {
        // reset values to handle eg data provisioned then error provisioned
        this.picklistValues = undefined;
        if (data) {
            this.picklistValues = data.values;
        } else if (error) {
            console.log(error);
        }
    }  

    changeHandlerName(event) {
        console.log('Change name');
        this.name = event.target.value;
    }
    changeHandlerAccountNumber(event) {
        console.log('Change account number');
        this.accountnumber = event.target.value;
    }

    handleChangeCombo(event) {
        this.Type = event.detail.value;
    }

    clickedButtonLabel;

    @wire(getTasks)
    account;
    updateContact() {
        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputFields) => {
                inputFields.reportValidity();
                return validSoFar && inputFields.checkValidity();
            }, true);

        if (allValid) {
            // Create the recordInput object
            console.log(allValid);

            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[TYPE_FIELD.fieldApiName] = this.Type;
            fields[NAME_FIELD.fieldApiName] = this.name;
            fields[ACCOUNTNUMBER_FIELD.fieldApiName] = this.accountnumber;
            console.log(this.template.querySelector("[data-field='TipoConta']").value);
            console.log(this.template.querySelector("[data-field='NomeConta']").value);
            console.log(this.template.querySelector("[data-field='NumConta']").value);
            console.log(this.recordId);
            

            const recordInput = { fields };
            
            updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Contact updated',
                            variant: 'success'
                        })
                    );
                    // Display fresh data in the form
                    return refreshApex(this.account);
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
            }
        else {
            // The form is not valid
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Something is wrong',
                    message: 'Check your input and try again.',
                    variant: 'error'
                })
             );
        }
    }

}