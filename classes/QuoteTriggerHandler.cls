/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 16-August-2016
    @ Test File     : 
    @ Description   : To create Installation record when Balance received date is updated
    @ Audit Trial   : 
    @ Last Modified Date : 16-August-2016
  
****************************************************************************/ 

public class QuoteTriggerHandler {
    
    /*  
         Method Name    : CreateInstallation
         Purpose        : Create installation if Balanced received date is filled in quote
         Input Parameter: List of Quote
         Created Date   : August 2016
         */
    
    public static void CreateInstallation(List < Quote__c > newTrigger) {
        list<Installation__c> lstInstallation = new list<Installation__c>();
        set<ID> cotactID = new set<ID> () ;
        system.debug('I am here');
        for(Quote__c conID : newTrigger){
        	    cotactID.add(conID.Contact__c) ; 
        }
       List<Contact> ContactList = [SELECT Id, AccountID From Contact WHERE ID in : cotactID ] ; 
        system.debug('The value of ContactList' + ContactList);
         for(Quote__c qu : newTrigger){
             for(COntact con : ContactList) {
             if(qu.Balanced_Received_Date__c != null && qu.Shipping_Min__c != null) {
                  Decimal d = qu.Shipping_Min__c * 7 ; 
                    Integer Days = d.intValue();
                 system.debug('I am inside loop');
                 	
                 lstInstallation.add(new Installation__c(
                     
                      Account__c = con.AccountId, 
                        Contact__c = con.ID,
                        Installation_Date__c = qu.Balanced_Received_Date__c.addDays(Days),
                        Quote_Name__c = qu.id , 
						 Project__c = qu.Project__c  
                        
                 )) ; 
                 
                 
             }
         }
         }
        
          try{
              system.debug('Inside try');
 
           insert lstInstallation ; 
        }
        catch(exception e){
            system.debug('Exception is:' +e);
        }
        
    }
    

    
   
    

}