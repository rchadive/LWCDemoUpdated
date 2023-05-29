/* importing the required modules */

import { LightningElement ,api} from 'lwc';

import { createRecord } from 'lightning/uiRecordApi';

import conObject from '@salesforce/schema/Contact';

import accObj from '@salesforce/schema/Account';

import accName from '@salesforce/schema/Account.Name';

import accWebsite from '@salesforce/schema/Account.Website';

import conFirstName from '@salesforce/schema/Contact.FirstName';

import conLastName from '@salesforce/schema/Contact.LastName';

import conEmail from '@salesforce/schema/Contact.Email';

import conPhone from '@salesforce/schema/Contact.Phone';

import conAccountId from '@salesforce/schema/Contact.accountId';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import {NavigationMixin} from 'lightning/navigation';

import uploadFile from '@salesforce/apex/FileUploaderClass.uploadFile'

export default class CreateAccWithRelContact extends NavigationMixin(LightningElement) {

 /* intialise the variables */  

    firstName;

    lastName ;

    emailId;

    phone;

    accountName;

    website ;  
    accountId;  
    conId;
    @api recordId;

    fileData;

    /* Assign form input element values to the variables */
    //formcontactfields={};
    contactChangeVal(Event) {

        if(Event.target.label=='First Name'){
            this.firstName = Event.target.value;
        }

        if(Event.target.label=='Last Name'){

            this.lastName = Event.target.value;

        }

        if(Event.target.label=='Email'){

            this.emailId = Event.target.value;

        }

        if(Event.target.label=='Phone'){

            this.phone = Event.target.value;

        }
        //const{name,value} = Event.target;
        //this.formcontactfields[name] = value;
    }
    //formfields={};
    handleNameChange(Event){  

        if(Event.target.label == 'Name'){

            this.accountName = Event.target.value;
           
        }    

        if(Event.target.label == 'Website'){

            this.website = Event.target.value;

        }  

       //const{name,value} = Event.target;
        //this.formfields[name] = value;
    }

     /*

    *   This method is used to create a new Account and related Contact in

        salesforce based on the values entered by the user and naviagtes to

        the contact detail page in View action

    */
        
       saveAction() {

        const fields_Account = {};

        fields_Account[accName.fieldApiName] = this.accountName;

        fields_Account[accWebsite.fieldApiName] = this.website;

        const accRecordInput = { apiName: accObj.objectApiName, fields:fields_Account};

      createRecord(accRecordInput)
        
        then(result=> {

            this.accountId = result.id;
             
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Account created',
                    variant: 'success',
                }),
            );
        
            
          const fields_Contact = {};

            fields_Contact[conFirstName.fieldApiName] = this.firstName;

            fields_Contact[conLastName.fieldApiName] = this.lastName;

            fields_Contact[conEmail.fieldApiName] = this.emailId;

            fields_Contact[conPhone.fieldApiName] = this.phone;

            fields_Contact[conAccountId.fieldApiName] = this.accountId;

          const conRecordInput = { apiName: conObject.objectApiName, fields:fields_Contact};
          createRecord(conRecordInput)

         .then(result=> {
           
            this.conId= result.Id;
           
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact created',
                    variant: 'success',
                }),
            );
          }
        });
    }
    
    showToast(title,message,variant){
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant:variant || 'Success'
        }))
    }
 

    /* This method clear the form elemnts */

    handleCancel(){

        //this.template.querySelector('form').reset();

        const inputFields = this.template.querySelectorAll(

            'lightning-input-field'

        );

        if (inputFields) {

            inputFields.forEach(field => {

                field.value = null;

            });

        }

      }

     

 /* This method performs Save and reset functionality */

      handleSaveandNew(){

        saveAction();

        handleCancel();

      }

 

    openfileUpload(event) {

        const file = event.target.files[0]

        var reader = new FileReader()

        reader.onload = () => {

            var base64 = reader.result.split(',')[1]

            this.fileData = {

                'filename': file.name,

                'base64': base64,

                'recordId': this.recordId

            }

            console.log(this.fileData)

        }

        reader.readAsDataURL(file)

    }

   

    handleClick(){

        const {base64, filename, recordId} = this.fileData

        uploadFile({ base64, filename, recordId }).then(result=>{

            this.fileData = null

            let title = "${filename} uploaded successfully!!"

            this.toast(title)

        })

    }

 

    toast(title){

        const toastEvent = new ShowToastEvent({

            title,

            variant:"success"

        })

        this.dispatchEvent(toastEvent)

    }

}