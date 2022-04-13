public with sharing class LwcCreateDonations {




    @AuraEnabled(cacheable=true)
    public static List<SObject> getAllDonations(String donID){
        
        List<OpportunityLineItem> donationOf = [SELECT Id, OpportunityId, Name, TotalPrice, ServiceDate, Installment_Status__c, Product2Id FROM OpportunityLineItem WHERE OpportunityId=:donID];
        
        try {
            System.debug('donations _'+ donationOf);
            return donationOf;   
        } catch (Exception e) {
           System.debug('Error'+ e.getMessage());
           return null;
        }

    }

//  create Donation
    
    @AuraEnabled
    public static Opportunity createDonation(Opportunity oppDetails){
        System.debug('oppDetails ins ' + oppDetails);
        try{
            insert oppDetails;
            System.debug('Inserted-> ' + oppDetails);
            return oppDetails;
        }catch(Exception e){
            System.debug('Error in don ins ->'+ e.getMessage());
            return null;
        }
    }
}
