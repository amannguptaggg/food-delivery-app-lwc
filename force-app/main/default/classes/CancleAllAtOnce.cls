public class CancleAllAtOnce {

    @InvocableMethod(label='Cancel Donation' description='Cancel The Donation Dues' category='Opportunity')
    public static void cancleDues(List<ID> cancleIds){
        System.debug('cancle Id--> '+ cancleIds);
        
        System.debug('cancleIds-->'+ cancleIds);
        List<OpportunityLineItem> installments = [SELECT Id, OpportunityId, Name, TotalPrice, Installment_Status__c FROM OpportunityLineItem WHERE OpportunityId IN:cancleIds];
    	System.debug('istall'+ installments);
        
        List<OpportunityLineItem> updateIns = new List<OpportunityLineItem>();
        
        for(OpportunityLineItem insItems : installments){
            insItems.Installment_Status__c = 'Cancelled';
            updateIns.add(insItems);
        }

        try{
            update updateIns;
        }catch(Exception e ){
            System.debug('Error in upating-->'+ e.getMessage());
        }    
        
        
    }
}