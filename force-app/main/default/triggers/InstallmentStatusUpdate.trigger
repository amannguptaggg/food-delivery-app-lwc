trigger InstallmentStatusUpdate on OpportunityLineItem (after update) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            CalculateIns.calculateTotalInstallmentPaidDetails(Trigger.new, Trigger.old);
        }
    }
}