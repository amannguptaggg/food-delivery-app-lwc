public with sharing class JubilantFoodWorks {


    // all food items
    @AuraEnabled(cacheable=true)
    public static List<Food_Item__c> allFoodItems(){
        List<Food_Item__c> allFoods = [SELECT Id, Food_Name__c, Unit_Price__c, Discount_Percentage__c, Discounted_Price__c, Food_Category__c, Veg_Non_Veg__c FROM Food_Item__c];
        System.debug('all foods' + allFoods);
        return allFoods;
    }


    // get single Item
    @AuraEnabled(cacheable=true)
    public static Food_Item__c getItemUsingId(String itemId){        
        Food_Item__c item = [SELECT Id, Food_Name__c, Unit_Price__c, Discount_Percentage__c, Discounted_Price__c, Food_Category__c,Veg_Non_Veg__c ,Description__c FROM Food_Item__c WHERE id=:itemId];
        return item;
    }

    // get cart item
    @AuraEnabled(cacheable=true)
    public static List<Cart__c> getCartItem(String customerId){        
        List<Cart__c> cartItem = [SELECT Id, Name, Customer__c, Food_Item__c, 
        Food_Item__r.Food_Name__c,Food_Item__r.Unit_Price__c, 
        Food_Item__r.Discount_Percentage__c, Food_Item__r.Discounted_Price__c, 
        Food_Item__r.Food_Category__c, Food_Item__r.Veg_Non_Veg__c, Food_Item__r.Description__c
        FROM Cart__c WHERE Customer__c=:customerId];
        return cartItem;
    }
    

    // insert cart Item
    @AuraEnabled
    public static Cart__c addCartItem(String itemId, String customerId){        
        Cart__c cart = new Cart__c();
        cart.Customer__c = customerId;
        cart.Food_Item__c = itemId;

        try{
            insert cart;
            System.debug('Item inserted' + cart);
            return cart;
        }catch(Exception e){
            System.debug('Some Error in insert cart ->' + e.getMessage());
            return null;
        }
    }

    // delete cart item;

    @AuraEnabled
    public static Boolean deleteCartItem(String itemId, String customerId){
        Boolean isDeleted = false;
        Cart__c item = [SELECT id,Customer__c FROM Cart__c WHERE id=:itemId and Customer__c=:customerId];
        try{
            delete item;
            isDeleted = true;
            System.debug('Item deleted' + item);
            return isDeleted;
        }catch(Exception e){
            System.debug('Some Error in delete cart ->' + e.getMessage());
            isDeleted = false;
            return false;
        }
    }

    //  delete all cart items
    @AuraEnabled
    public static Boolean deleteAllCartItems(String customerId){
        Boolean isDeleted = false;
        List<Cart__c> item = [SELECT id,Customer__c FROM Cart__c WHERE Customer__c=:customerId];
        try{
            delete item;
            isDeleted = true;
            System.debug('Item all cart deleted' + item);
            return isDeleted;
        }catch(Exception e){
            System.debug('Some Error in delete cart ->' + e.getMessage());
            isDeleted = false;
            return false;
        }
    }


    //  customer orders
    @AuraEnabled(cacheable=true)
    public static List<Order__c> getAllCustomerOrders(String customerId){
        List<Order__c> item = [SELECT Id, Name, Customer__c, Delivered_by__r.Name__c , Status__c, Payment_Mode__c , Cancellation_Date__c, Delivered_On__c FROM Order__c WHERE Customer__c=:customerId];
        try{
            return item;
        }catch(Exception e){
            System.debug('Some Error in customer all orders ->' + e.getMessage());
            return null;
        }
    }


    // user login check

    @AuraEnabled(cacheable=true)
    public static List<Customer__c> userLogin(String userEmail, String userPassword){
        List<Customer__c> item = [SELECT Id, Name__c, Email__c, Role__c, Password__c FROM Customer__c WHERE Email__c=:userEmail and Password__c =:userPassword];
        try{
            return item;
        }catch(Exception e){
            System.debug('Some Error in customer all orders ->' + e.getMessage());
            return null;
        }
    }
    

}
