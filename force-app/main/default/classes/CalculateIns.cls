public class CalculateIns {
    
    public static Integer getPaymentFreq(String freqName){
        Map<String, Integer> paymentFrequencyMap = new Map<String, Integer>();      
        paymentFrequencyMap.put('One-time',1);
        paymentFrequencyMap.put('Quarterly',3);
        paymentFrequencyMap.put('Half-yearly',2);
        paymentFrequencyMap.put('Monthly',12);
        return paymentFrequencyMap.get(freqName);
    }
    
    
    
    // before insert
    public static void calculateInsBefore(List<Opportunity> newDonation ){
        System.debug('Method before called--> List -->'+ newDonation);

        for(Opportunity donation : newDonation){
            System.debug('Pay Frq==> '+getPaymentFreq(donation.Payment_Frequency__c) + 'Year ==> '+ donation.Donation_For_Year__c);
            
            Integer noPayIns = Integer.valueOf(getPaymentFreq(donation.Payment_Frequency__c)) * Integer.valueOf(donation.Donation_For_Year__c);
            Decimal amtPerIns =  donation.Total_Donation_Amount__c / noPayIns;
            Decimal roundAmt = amtPerIns.setScale(4);
            donation.Number_of_Installment__c = noPayIns;
            donation.Amount_Per_Installment__c = roundAmt;
            donation.Number_of_Insallment_Paid__c = 0;
            donation.Total_Installemnt_Amount_Paid__c = 0;
            System.debug('NO Pay Ins=> '+ noPayIns + 'amtPerIns --> '+ roundAmt);
        }
        
    }
    
    
    // after insert
    public static void addOppProductAfter(List<Opportunity> newDonation){
        
        Map<ID, String> paymentFrqMap = new Map<ID, String>();
        
        for(Opportunity donation : newDonation){           
            
            paymentFrqMap.put(donation.id,donation.Payment_Frequency__c);
        }
        
        //newDonation[0].Payment_Frequency__c
        List<Product2> installmentProduct = [SELECT Id, Name, ProductCode, Installment_Status__c FROM Product2 WHERE Name IN : paymentFrqMap.values()];
        List<OpportunityLineItem> oppLineItem = new List<OpportunityLineItem>();
        
        PricebookEntry priceBookEnty = [SELECT Id, Pricebook2Id FROM PricebookEntry WHERE IsActive = True LIMIT 1];
        
        for(Opportunity donation : newDonation){
            System.debug('1st For->'+ donation);
            for(Integer i=0; i < donation.Number_of_Installment__c; i++){
                System.debug('2nd For->'+ 'installmentProduct-> '+ installmentProduct);
                
                for(Product2 prod : installmentProduct){
                    System.debug('Pro_>' +prod.Name + '--> freq -->'+ donation.Payment_Frequency__c );
                    if(prod.Name == donation.Payment_Frequency__c ){
                        System.debug('Product '+ i + '\nInstallment Amount: '+ donation.Amount_Per_Installment__c + '\ninstallmentProduct: ' + prod.Installment_Status__c);
                        OpportunityLineItem oppItem = new OpportunityLineItem();
                        oppItem.OpportunityId = donation.Id;
                        oppItem.Product2Id = prod.id;
                        oppItem.Installment_Status__c = prod.Installment_Status__c;
                        oppItem.TotalPrice = donation.Amount_Per_Installment__c;
                        oppItem.Quantity = 1;
                        oppItem.PricebookEntryId  = priceBookEnty.id;
                        
                        oppItem.ServiceDate = calculateDateForEachInstallment(donation.Payment_Frequency__c,i, Integer.valueOf(donation.Number_of_Installment__c));
                        
                        System.debug('OppItem-> '+ oppItem);
                        oppLineItem.add(oppItem);                     
                    }
                }
            }
        }
        
        try{
            System.debug('oppLineItem-->'+ oppLineItem);
            insert oppLineItem;
        }catch(Exception e){
            System.debug('Error in Opp Line Item: '+ e.getMessage());
        }
    }
    
    
    // Calculate Pending Date 
    public static Date calculateDateForEachInstallment(String paymentFrequency,Integer counter ,Integer noOfIns){
        Integer paymentFrq =   getPaymentFreq(paymentFrequency);  
        // for one time
        if(paymentFrq == 1){
            return date.today();
        }
        
        // for Quarterly
        if(paymentFrq == 3){
            Date calDate = date.today();
            System.debug('Date After '+ paymentFrq * counter  + '->> '+calDate.addMonths(paymentFrq * counter));
            return calDate.addMonths(paymentFrq * counter);
        }
        
        // for Half Yearly 
        if(paymentFrq == 2){
            Date calDate = date.today();
            System.debug('Date After '+ (Integer.valueOf((12/paymentFrq)) * counter)  + '->> '+ calDate.addMonths((Integer.valueOf(12/paymentFrq)) * counter));
            return calDate.addMonths((Integer.valueOf(12/paymentFrq)) * counter);
        }
        
        // for 12 months
        if(paymentFrq == 12){
            Date calDate = date.today();
            System.debug('Date After '+ (Integer.valueOf((12/paymentFrq)) * counter)  + '->> '+ calDate.addMonths((Integer.valueOf(12/paymentFrq)) * counter));
            return calDate.addMonths((Integer.valueOf(12/paymentFrq)) * counter);
        }
        
        
        return null;
    }
    

    
    
    
    // Calculate Total closed installments paid details
    public static void calculateTotalInstallmentPaidDetails(List<OpportunityLineItem> installmentListNew,List<OpportunityLineItem> installmentListOld){
        
        System.debug('New List -->'+ installmentListNew);
        System.debug('old List -->'+ installmentListOld);
        List<ID> oppIds = new List<ID>();
        
        for(OpportunityLineItem op : installmentListNew){
            System.debug('opp->'+ op.OpportunityId);
            oppIds.add(op.OpportunityId);
        }
        
        System.debug('prodIds--> '+ oppIds);
        
        List<OpportunityLineItem> allProductRelated = [SELECT Id, OpportunityId, Product2Id, Installment_Status__c, TotalPrice, UnitPrice, ListPrice, Name FROM 
                                                       OpportunityLineItem WHERE Installment_Status__c ='Completed' AND OpportunityId IN:oppIds];
        System.debug('Prod'+ allProductRelated );
        
        Integer totalInstallmentPaid = allProductRelated.size();
        Decimal totalInstallmentPaidAmnt = 0;
        for(OpportunityLineItem oppItem : allProductRelated){
            totalInstallmentPaidAmnt = oppItem.TotalPrice + totalInstallmentPaidAmnt;
        }
        
        List<Opportunity> updateDonation = [SELECT Id, Total_Installemnt_Amount_Paid__c, Number_of_Insallment_Paid__c FROM Opportunity WHERE id IN:oppIds];
        
        for(Opportunity updateDon : updateDonation){
            updateDon.Total_Installemnt_Amount_Paid__c = totalInstallmentPaidAmnt;
            updateDon.Number_of_Insallment_Paid__c = totalInstallmentPaid;
        }
        
        try{
            update updateDonation;
            System.debug('updated updateDonation');
        }catch(Exception e){
            System.debug('Error in Update Opp Total Amount-->'+ e.getMessage());
        }
        
        System.debug('updateDonation-->'+ updateDonation);
        System.debug('totalInstallmentPaidAmnt --> '+ totalInstallmentPaidAmnt+ '\n size: ->'+ totalInstallmentPaid);
        
    }
    
    
    
    
}