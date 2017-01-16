/*********************************************************************************************************************
Trigger Name: PositionTrigger
Events: after insert, after update
Description: To handle different functionalities on Position in Installation Management
**********************************************************************************************************************/

trigger PositionTrigger on Position__c (after Update , after Insert , before Delete ) {
 set<id> setIds = new set<id>(); //To store the installation ids
    if(trigger.isAfter && trigger.isupdate){
        
    
        for(Position__c po:trigger.new){
            if(trigger.oldmap.get(po.id).Installation__c != null && (trigger.oldmap.get(po.id).Installation__c != po.Installation__c)){
                setIds.add(po.Installation__C);   
            }
        }
        
        if(setIds.size()>0){ //Checking the null pointer exception
            List<Installation__c> instalList = [select id, Installer_Account__c,Order__c from Installation__c where id IN:setIds];
         //   InstallationTriggerHandler.updateEntitlement(instalList);
        }
    }
    
    //Added by Aquib Javed For updating Model List on to the Installation object
    
    if((trigger.isAfter && trigger.isInsert) || (trigger.isAfter && trigger.isUpdate) ){
          PositionTriggerHandler.ModelName(Trigger.New) ; 
    }
    
}