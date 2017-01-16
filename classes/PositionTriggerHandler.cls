/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : September-2016
    @ Description   : Handler class for PositionTrigger
    @ Audit Trial   : Added comments
    @ Test Class    : 
    @ Last Modified Date : 26-September-2016
  
****************************************************************************/
public class PositionTriggerHandler {
   
    /*  
         Method Name    : ModelName
         Purpose        : This Method serves the pupose of adding model name fromposition to Installation
         Input Parameter: List of Position
         Created Date   : September 2016
         */
    public static void ModelName(List < Position__c > newTrigger){
        Set<Id> parentIds = new Set<ID>();
    system.debug('Inside ModelName');
    // Get all the Parent Ids (Installation ) in the Set
        for(Position__c s : newTrigger){
                parentIds.add(s.Installation__c);
        }
        
     //Create a String of all the models and update it on Installation
   
        Map<Id, String> ModelMap = new Map<Id, String>();
        string ModelName = ''; 
         
        try{
            for(Position__c p : [Select id , Name , Installation__c ,Model__c FROM Position__c WHERE Installation__c IN:parentIds]){
                if(ModelName != '') {
                 ModelName = ModelName + ', '  + p.Model__c ;
                 
                }
                else{
                    ModelName=p.Model__c ;
                }
                ModelMap.put(p.Installation__c, ModelName);
                system.debug('Inside ModelMap' +  ModelMap);
            }
        }
        catch(exception e){
            system.debug('Exception is:' +e);
        }
       
        
         // Iterate over each parent
        List<installation__c> installUpdate = new List<installation__c>();
        
        for(Installation__c i : [Select Id, Name, Model_List__c from Installation__c where Id in :parentIds]) {
            if(ModelMap.containsKey(i.id) && ModelMap.get(i.Id) != NULL) {
                     i.Model_List__c = ModelMap.get(i.id) ;
                     installUpdate.add(i) ; 
                system.debug('inside i');
            }
        }
        try{
            if(installUpdate.size() >0 ){
             update installUpdate ; 
            }
        }
        catch(exception e){
            system.debug('Exception is:' +e);
        }
    }
    
}