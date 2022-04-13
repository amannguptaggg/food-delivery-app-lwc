trigger CalculateInsTrigger on Opportunity (before insert, after insert) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
           CalculateIns.calculateInsBefore(Trigger.new); 
        }
        
        if(Trigger.isAfter){
            CalculateIns.addOppProductAfter(Trigger.new);
        }
    }
}