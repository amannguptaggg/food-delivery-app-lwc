import { LightningElement, track,api, wire } from 'lwc';
import userLogin from '@salesforce/apex/JubilantFoodWorks.userLogin';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class Login extends LightningElement {

    @api openLogin;
    @track userData;



    // SELECT Id, Name__c, Email__c, Role__c, Password__c FROM Customer__c

    @track loginUser;
    @track _loginUserRef;
    @track sendUserData;
    @track userEmail;
    @track userPass;
    @track errorIdPass;

    @track loginData = {
        Email__c : '',
        Password__c : ''
    }

    connectedCallback(){
        this.errorIdPass = false;
    }
    // cancle login popup 
    cancleLoginPopup(){
        const evt = new CustomEvent('closelogin',{
            detail : false
        });
        this.dispatchEvent(evt);
    }



    chnageEmail(event){
        this.loginData.Email__c = event.currentTarget.value;
        console.log(this.loginData.Email__c);
    }

    chnagePassword(event){
        this.loginData.Password__c = event.currentTarget.value;
        console.log(this.loginData.Password__c);
    }

    loginUserFunction(){
        console.log('LoginUser Called');
        if(this.loginData.Email__c != '' && this.loginData.Password__c != ''){
            this.userEmail = this.loginData.Email__c;
            this.userPass = this.loginData.Password__c;
        }

        console.log('user send data' + this.userEmail + this.userPass);
    }

    @wire(userLogin,{userEmail : '$userEmail', userPassword : '$userPass'})
    userLoginData(user){
        this._loginUserRef = user;

        const {data, error} = user;

        if(data){
            console.log('user login data -> ' + JSON.stringify(data));
            this.userData = data;


            if(this.userData != [] && this.userData != null && this.userData != ''){
                const evt = new CustomEvent('userloggedin',{
                    detail : this.userData
                })
                this.dispatchEvent(evt);

                

                const event = new ShowToastEvent({
                    title : 'Logged In',
                    variant: 'success',
                    mode: 'dismissable'
               });
               this.dispatchEvent(event);

            } else {
                this.errorIdPass = true;
            }
        } else if(error) {
            console.log('Error in user login -> ' + JSON.stringify(error));
        }
    }


    focusFunction(event){
        this.errorIdPass = false;
    }
} 