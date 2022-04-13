import {LightningElement,track, wire} from 'lwc';
import donName from '@salesforce/schema/Opportunity.Name';
import totalDonAmt from '@salesforce/schema/Opportunity.Total_Donation_Amount__c';
import payFreq from '@salesforce/schema/Opportunity.Payment_Frequency__c';
import payYear from '@salesforce/schema/Opportunity.Donation_For_Year__c';
import clDate from '@salesforce/schema/Opportunity.CloseDate';
import accId from '@salesforce/schema/Opportunity.AccountId';
import donerId from '@salesforce/schema/Opportunity.Doner__c';
import createDon from '@salesforce/apex/LwcCreateDonations.createDonation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


export default class Donate extends LightningElement {


    @track accIDD = '0015h00000krHs5AAE';
    @track donerID = '0035h00000XwI5JAAV';
    @track oppInsData;
    @track insData;

    
    @track insertDonationRecord = {
        Name: donName,
        Total_Donation_Amount__c : totalDonAmt,
        Payment_Frequency__c : payFreq,
        Donation_For_Year__c : payYear,
        CloseDate : clDate,
        AccountId : accId,
        Doner__c : donerId,
        StageName : 'Installment Started'
    }

    //     @wire(allDon,{donID : '$donationID'}) 
//     donList({data, error}){
//     if(data){
//         this.donationList = data;
//         console.log('data-->' + this.donationList);
//     } else if(error){
//         this.errorList = error;
//         console.log('data-->' + this.errorList);
//     }
// }

    nameChnaged(event){
        this.insertDonationRecord.Name = event.target.value;
        console.log('this.insertDonationRecord.Name'+ this.insertDonationRecord.Name);
    }

    totalAmt(event){
        this.insertDonationRecord.Total_Donation_Amount__c = event.target.value;

    }

    payfreq(event){
        this.insertDonationRecord.Payment_Frequency__c = event.target.value;
    }

    totalYear(event){
        this.insertDonationRecord.Donation_For_Year__c = event.target.value;
    }

    closeDateMethod(event){
        this.insertDonationRecord.CloseDate = event.target.value;
    }

    AccountIdMethod(event){
        this.insertDonationRecord.AccountId = this.accIDD;
    }

    donerIdMehtod(event){
        this.insertDonationRecord.Doner__c = this.donerID;
    }



    // submitDonationForm(event){
    //     const DELAY = 300;
    //     window.clearTimeout(this.delayTimeout);
    //     const data = this.insertDonationRecord;
    //     this.delayTimeout = setTimeout(() => {
    //         console.log('submitDonationForm -> '+ this.insertDonationRecord);
    //         this.insData = data;
    //     }, DELAY);
       
    // }

    // @wire(createDon,{oppDetails:'$insData'} )
    // oppInsData({data, error}){
    //     console.log('createDon wire called'+ JSON.stringify(this.insertDonationRecord));
    //     if(data){
    //         console.log('data --> ins '+ data);
    //     } else if(error){
    //         console.log('error ins don'+ JSON.stringify(error));
    //     }
    // }


    submitDonationForm(){
       this.insData = this.insertDonationRecord;
        createDon({oppDetails:this.insData})
        .then(result=>{
            console.log('result '+ JSON.stringify(result));
            console.log('result ID'+ result.Id);
           const event = new ShowToastEvent({
                title : 'Donation Successfully Created',
                message : 'Your Donation {0} is created. See It {1}',
                messageData : [
                    this.insertDonationRecord.Name,
                    {
                        url : 'https://wise-bear-cic7ha-dev-ed.lightning.force.com/'+result.Id,
                        label : 'here'
                    }
                ],
                variant: 'success',
                mode: 'dismissable'
           });
           this.dispatchEvent(event);
        })
        .catch(error=>{
           this.error=error.message;
           const event = new ShowToastEvent({
            title : 'Failed',
            message : 'Some Error occured in creating donation',
            variant: 'error',
            mode: 'dismissable'
       });
       this.dispatchEvent(event);
           window.console.log('Error in catch in SubmitDonationForm '+this.error);
        });
      }
 



//     @wire(allDon,{donID : '$donationID'}) 
//     donList({data, error}){
//     if(data){
//         this.donationList = data;
//         console.log('data-->' + this.donationList);
//     } else if(error){
//         this.errorList = error;
//         console.log('data-->' + this.errorList);
//     }
// }

}