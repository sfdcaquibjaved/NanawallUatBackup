/*************************************************************************
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : August-2016
    @ Description   : To update entitlement certified installer check box for each order item whenever the order items moved to another Installation record
    @ Audit Trial   : Added comments
    @ Test Class    : FeedItemTriggerHandler_Test
    @ Last Modified Date : 
  
****************************************************************************/
trigger orderItemProductTrigger on OrderItem (after update) {
    
   List<id> instalids = new List<id>(); //To store the installation ids
    if(trigger.isAfter && trigger.isupdate){
        
    //To check each order item for the installation
        for(orderitem ot:trigger.new){
            if(trigger.oldmap.get(ot.id).Installation__c != null && (trigger.oldmap.get(ot.id).Installation__c != ot.Installation__c)){
                instalids.add(ot.Installation__C);   
            }
        }
        
        if(instalids.size()>0){ //Checking the null pointer exception
            List<Installation__c> instalList = [select id, Installer_Account__c,Order__c from Installation__c where id IN:instalids];
         //   InstallationTriggerHandler.updateEntitlement(instalList);
        }
    }
}