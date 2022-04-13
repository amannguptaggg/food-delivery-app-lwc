public class PayAllAtOnceMethod {

	@InvocableMethod(label='Donation ID' description='Get Donation Id and pay All Donations' category='Opportunity')    
    public static void payAllMehtod(List<ID> donationID){
       
        System.debug('donationID-->'+ donationID);
        List<OpportunityLineItem> installments = [SELECT Id, OpportunityId, Name, TotalPrice, Installment_Status__c FROM OpportunityLineItem WHERE
                                                Installment_Status__c = 'Open' AND  OpportunityId IN:donationID];
    	System.debug('istall'+ installments);
        
        List<OpportunityLineItem> updateIns = new List<OpportunityLineItem>();
        
        for(OpportunityLineItem insItems : installments){
            insItems.Installment_Status__c = 'Completed';
            updateIns.add(insItems);
        }

        try{
            update updateIns;
        }catch(Exception e ){
            System.debug('Error in upating-->'+ e.getMessage());
        }    
        
    }
}