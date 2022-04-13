@isTest
public class CalculateInsTestClass {    
    
    @isTest
    public static void checkInstallmentCalculationsTest(){
        
        
        Test.startTest();
        
        // create NGO
        Account ngo = new Account();
        ngo.Name = 'New NGO';
        ngo.AccountNumber = '232';
        ngo.Type = 'Community-based';
        ngo.Industry = 'Food & Beverage';
        ngo.AnnualRevenue = 434523;
        ngo.Rating = '5 Star';
        ngo.Phone = '3235432343';
        
        
        try{
            insert ngo;
        } catch(Exception e){
            System.debug('Error in setup NGO-> '+ e.getMessage());
        }
        
        
        // create doner 
        
        Contact doner = new Contact();
        doner.Salutation = 'Mr.';
        doner.FirstName = 'Aman';
        doner.LastName = 'Gupta';
        doner.MobilePhone = '837462364';
        doner.Email = 'amannguptaggg@gmail.com';
        doner.AccountId = ngo.Id;
        
        
        try{
            insert doner;
        } catch(Exception e){
            System.debug('Error in setup doner-> '+ e.getMessage());
        }
        
        
        
        // installment data insert prod2
        
        //SELECT Id, Name, Installment_Status__c, IsActive FROM Product2
        Product2 prod = new Product2();
        prod.Name = 'Half-Yearly';
        prod.ProductCode = 'HY12231';
        prod.IsActive = True;
        prod.Installment_Status__c = 'Open';
        
        try{
            insert prod;
        }catch(Exception e){
            System.debug('Error in setup Product'+ e.getMessage());
        }
        
        
        
        
        // price book2
        // SELECT Id, Name, IsActive, IsStandard FROM Pricebook2
        Pricebook2 priceBookStd = new Pricebook2();
        priceBookStd.Name = 'Standard';
        // priceBookStd.IsActive = True; 
        
        try{
            insert priceBookStd;
        }catch(Exception e){
            System.debug('Error in setup priceBookStd'+ e.getMessage());
        }
        
        
        Pricebook2 priceBk = new Pricebook2();
        priceBk.Name = 'Standard Price Book';
        priceBk.IsActive = True; 
        
        try{
            insert priceBk;
        }catch(Exception e){
            System.debug('Error in setup priceBk'+ e.getMessage());
        } 
        
        // pricebookEntry
        
        Id pricebookId = Test.getStandardPricebookId();
        System.debug('pricebookId ---> '+ pricebookId);
        
        // SELECT Id, Name, Pricebook2Id, Product2Id, IsActive, UnitPrice, ProductCode FROM PricebookEntry
        PricebookEntry priceBook = new PricebookEntry();
        priceBook.Pricebook2Id = pricebookId;
        priceBook.Product2Id = prod.Id;
        priceBook.IsActive = True;
        priceBook.UnitPrice = 10000;
        
        try{
            insert priceBook;
        }catch(Exception e){
            System.debug('Error in setup priceBook'+ e.getMessage());
        }
        
        
        // create donation
        
        Opportunity donation = new Opportunity();
        donation.Name = 'World Health Foundation';
        donation.AccountId = ngo.Id;
        System.debug('opp accc id'+ donation);
        donation.ContactId = doner.Id;
        donation.Donation_For_Year__c ='1';
        donation.Total_Donation_Amount__c = 100;
        System.debug('total donation amnt'+ donation);
        donation.CloseDate = Date.parse('3/26/2022');
        System.debug('close date'+ donation);
        donation.Payment_Frequency__c = 'Half-yearly';
        donation.StageName = 'Installment Started';
        
        
        System.debug('donation--->'+ donation+ '\n doner id-> '+ donation.ContactId);
        
        
        
        try{
            insert donation;
        }catch(Exception e){
            System.debug('Error in setup donation '+ e.getMessage());
        }
        
        List<Opportunity> donationList = new List<Opportunity>();
        donationList.add(donation);
        
        Test.stopTest();
        
        Opportunity testDonation = [SELECT Id, Name, AccountId, StageName, Amount, Number_of_Installment__c, Amount_Per_Installment__c, Total_Installemnt_Amount_Paid__c, Number_of_Insallment_Paid__c,HasOpportunityLineItem FROM Opportunity];
        System.debug('testDonation'+ testDonation);
        
        System.assertEquals(2, testDonation.Number_of_Installment__c );
        System.assertEquals(50.00, testDonation.Amount_Per_Installment__c);
        
        List<OpportunityLineItem> oppItem = [SELECT Id, OpportunityId, PricebookEntryId, Product2Id, Name, TotalPrice, Installment_Status__c FROM OpportunityLineItem WHERE OpportunityId=:testDonation.Id]; 
        
        System.assertEquals(2, oppItem.size());
        
        
        
        
        // testing calculateTotalInstallmentPaidDetails class and InstallmentStatusUpdate  Trigger-->
         // update statis 
        oppItem[0].Installment_Status__c = 'Completed';
        
        update oppItem;
		
        System.debug('Opp Updated Item--> '+ oppItem);
    }
    
}