/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 16-August-2016
    @ Test File     : 
    @ Description   : To create Installation record when Order finalized date is updated
    @ Audit Trial   : 
    @ Last Modified Date : 16-August-2016
  
****************************************************************************/ 
public class OrderTriggerHandler {
     /*  
         Method Name    : CreateInstallation
         Purpose        : Create installation if Order finalized date is filled on Order
         Input Parameter: List of Order
         Created Date   : August 2016
         */
    
    public static void CreateInstallation(List < Order > newTrigger){
        list<Installation__c> lstInstallation = new list<Installation__c>();
        list <id> QuoteId = new list<id>();
            system.debug('I am here Inside CreateInstallation');
           
     
        for(order ord : newTrigger){
            
                if(Ord.Shipping_Min_from_Quote__c != null && Ord.Order_Finalized_Date__c != null){
                    Decimal d = Ord.Shipping_Min_from_Quote__c * 7 ; 
                    Integer Days = d.intValue();
                    
                 lstInstallation.add(new Installation__c(
                        Account__c = ord.AccountId, 
                        Contact__c = ord.Contact__c,
                        Installation_Date__c = ord.Order_Finalized_Date__c.addDays(Days),
                        Order__c = ord.id , 
                        Quote_Name__c = ord.NanaQuote__c , 
                        Project__c = ord.Project__c 
                        
                 )) ; 
            }
            
        }
            try{
                if(lstInstallation.size() > 0 ) {
 
          				 insert lstInstallation ; 
                }
        }
        catch(exception e){
            system.debug('Exception is:' +e);
        }
            
           
        
    }
    
    /*  
         Method Name    : UpdateInstallation
         Purpose        : Update installation if Order finalized date is Changed on Order
         Input Parameter: List of Order
         Created Date   : January 2017
         */
    
    public static void UpdateInstallation (set< ID > orderID , List < Order > newTrigger) {
       // List <ID> orderID = new List<ID> () ; 
         list<Installation__c> lstInstallation = new list<Installation__c>();
         list<Installation__c> lstInstallationInsert = new list<Installation__c> () ; 
        system.debug('I am here Inside UpdateInstallation');
        
        //Get Order ID 
   /*     for(Order o : newTrigger) {
            OrderID.add(o.Id) ; 
        } */
       	System.debug('order ids'+ OrderID);
        Integer installationCount = [SELECT Count() FROM Installation__c WHERE Order__c IN : OrderID ] ; 
        System.debug('My count'+ installationCount);
        if(installationCount == 0){
            for(order ord : newTrigger) {
                 if(Ord.Shipping_Min_from_Quote__c != null && Ord.Order_Finalized_Date__c != null){
                    Decimal d = Ord.Shipping_Min_from_Quote__c * 7 ; 
                    Integer Days = d.intValue();
                    
                 lstInstallationInsert.add(new Installation__c(
                        Account__c = ord.AccountId, 
                        Contact__c = ord.Contact__c,
                        Installation_Date__c = ord.Order_Finalized_Date__c.addDays(Days),
                        Order__c = ord.id , 
                        Quote_Name__c = ord.NanaQuote__c , 
                        Project__c = ord.Project__c 
                        
                 )) ; 
            }
            }
            
        }
        //Query related Installations
        else {
        List <Installation__c> relatedInstalls = [SELECT id,Installation_Date__c , Order__c FROM Installation__c WHERE Order__c IN: OrderID] ;  
        
        //Change Installation Date on Installation record
        for(Installation__c i : relatedInstalls){
            for(Order o : newTrigger){
                if(i.Order__c == o.ID){
                      if(O.Shipping_Min_from_Quote__c != null && O.Order_Finalized_Date__c != null){
                    		Decimal d = O.Shipping_Min_from_Quote__c * 7 ; 
                   		    Integer Days = d.intValue();
                          	
                          	i.Installation_Date__c = O.Order_Finalized_Date__c.addDays(Days) ; 
                            lstInstallation.add(i)  ; 
                          
                      }
                    
                }
                
            }
        }
        }
        
        try{
            //updating Installation records
            if(lstInstallation.size() >0 )
            		update lstInstallation ; 
            if(lstInstallationInsert.size() >0 )
            		insert lstInstallationInsert ;
        }
        
        catch (exception e) {
            system.debug('Exception is: ' + e.getMessage());
        }
    }
    
}