public class CalculateInstallments {
    Integer noOfYears = 1;
    String paymentFrequency = 'one-time';
    Integer totalAmount = 0;


// 100 * 1 * 1
// 100/ 4 --> 25
// 100 * 2 = 200
// 200 /4 ---> 5 --> X
// 
// 200 ---> for 2 year ---> half yearly
// 200 /2 --> 100 per year
// 100 / 12 ----> monthly
// 
// 
// No of inst : paymentFrequency * noOfYears
// amnt per inst : totalamnt / year --> result % paymentFrequency
    

    
    public void getNoOfInstallmentsAndAmount(Integer noOfYears, String paymentFrequency, Integer totalPerYearAmount){
        
        Map<String, Integer> paymentFrequencyMap = new Map<String, Integer>();      
        paymentFrequencyMap.put('one-time', 1);
        paymentFrequencyMap.put('quarterly', 3);
        paymentFrequencyMap.put('half-yearly', 2);
        paymentFrequencyMap.put('monthly', 12);
        
        
        Integer noOfInst = paymentFrequencyMap.get(paymentFrequency) * noOfYears;
        Integer perInsAmnt = totalPerYearAmount / (noOfYears * paymentFrequencyMap.get(paymentFrequency));
        
    }
    
    
    
    
    
}