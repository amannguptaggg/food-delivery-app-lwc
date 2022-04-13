global with sharing class ScheduleBatchPendingInstallment implements Schedulable {

    global void execute(SchedulableContext sc){
    	UpdatePendingInstallmentBatch btch = new UpdatePendingInstallmentBatch(); 
         Database.executeBatch(btch,100);
    }
    
    
    global static void runSchedule(){

           String CRON_EXP = '0 0 0 * * ?'; 
        	ScheduleBatchPendingInstallment schInstallment = new ScheduleBatchPendingInstallment();
        	System.schedule('Update Pending Ins', CRON_EXP, schInstallment);
     }
    
    
    
    

}