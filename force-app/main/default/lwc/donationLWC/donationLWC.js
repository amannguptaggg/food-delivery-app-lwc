import { LightningElement,track, api, wire } from 'lwc';
import allDon from '@salesforce/apex/LwcCreateDonations.getAllDonations';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


export default class DonationLWC extends LightningElement {


filename = 'Donate';
@track home = true;
@track donate = false;
@track donation = false;
@track profile = false;
@track donList;
@track donationList;
@track errorList;
@track isModelOpen = false;

donationID = '0065h00000Ci1wYAAR';


@wire(allDon,{donID : '$donationID'}) 
donList({data, error}){
    if(data){
        this.donationList = data;
        console.log('data-->' + this.donationList);
    } else if(error){
        this.errorList = error;
        console.log('data-->' + this.errorList);
    }
}

loginSubmit(){
    console.log('is loggeSubmit called');
    this.isLoggedIn = true;

    const event = new ShowToastEvent({
        title : 'Successfully Logged In',
        variant: 'success',
        mode: 'dismissable'
   });
   this.dispatchEvent(event);
   this.isModelOpen = false;
}



handleNavigation(event){
    event.preventDefault();
    console.log('handleEvent Called'+ event.target.id);
    const elmId =  event.target.dataset.targetId;
    console.log('target Id -> ' + elmId);

    if(elmId == 'home'){
        this.home = true;
        this.donate = false;
        this.donation = false;
        this.profile = false;
    }

    if(elmId == 'donate'){
        if(!this.isModelOpen){
            this.isModelOpen = true;   
        }
        
        if(this.isLoggedIn){
            console.log('isLoggedIn in donate');
            this.home = false;
            this.donate = true;
            this.donation = false;
            this.profile = false; 
        }
    }


    if(elmId == 'donation'){
        this.isModelOpen = true;
        if(this.isLoggedIn){
            this.home = false;
            this.donate = false;
            this.donation = true;
            this.profile = false;
        }
    }


    if(elmId == 'profile'){
        this.isModelOpen = true;
        if(this.isLoggedIn){
            this.home = false;
            this.donate = false;
            this.donation = false;
            this.profile = true;
        }
    }






// how to use this for navigation in LWC app

//     this[NavigationMixin.Navigate]({
//         type : "standard_comopnent",
//         attributes : {
//             componentName : "c__donate"
//         },
//         state : {
//             myval : filename
//         }
//     });
}

// close model
cancleModel(){
    this.isModelOpen = false;
}
 
}