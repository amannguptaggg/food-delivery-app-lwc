public class UpdatePendingInstallmentBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, ServiceDate FROM OpportunityLineItem WHERE Installment_Status__c != 'Pending']);
    }
    
    public void execute(Database.BatchableContext bc, List<OpportunityLineItem> oppLineList){
        for(OpportunityLineItem opp : oppLineList){
            if(opp.ServiceDate < Date.today()){
                System.debug('date end-> name'+ opp.Name + ' id-> '+ opp.ServiceDate);
                opp.Installment_Status__c = 'Pending';
            }
        }
        
        try{
           update oppLineList;
        }catch(Exception e){
            System.debug('Error in update Batch Apex Pending -> '+ e.getMessage());
        }
    }
    
    
    public void finish(Database.BatchableContext bc){}  
}