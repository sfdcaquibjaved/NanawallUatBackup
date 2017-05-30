/*************************************************************************
    @ Author        : Absyz
    @ Date          : September 2015
    @ Test File     : 
    @ Description   : Batch Class 
    
    @ Audit Trial   : Repeating block for each change to the code
                      Commenting the block
    -----------------------------------------------------------------------------
***********************************************************************************/

global class oppsOpenPastERD /* implements Database.Batchable < sObject > */ { /*
    
     //Global Variable
    global String query;
    
     global oppsOpenPastERD() {
        
    }
    
     //Start method of the batch class
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        this.query = 'SELECT Id , Name,AccountId from Opportunity where Past_ERD__c =true' ;
        
        return Database.getQueryLocator(query);
    }
    
    //Execute method of the batch class
    global void execute(Database.BatchableContext BC, List < Opportunity > records) {
        map<Id,set<Id>> mapPastErd = new  map<Id,set<Id>>();
        list<Account> listToUpdate = new list<Account>();
        
        for(opportunity opp : records){
            if(mapPastErd != null && !mapPastErd.containsKey(opp.accountId)){
                Set < Id > setOppId = new Set < Id > ();
                setOppId.add(opp.Id);
                mapPastErd.put(opp.accountId, setOppId);
            } else if (mapPastErd.containsKey(opp.accountId)) {
                Set < Id > setOppId = new Set < Id > ();
                setOppId = mapPastErd.get(opp.accountId);
                setOppId.add(opp.id);
                mapPastErd.put(opp.accountId, setOppId);
            }
        }
        
        for(Account acc : [Select id,Total_no_of_Opps_open_but_past_ERD__c from Account where Id IN : mapPastErd.keySet()]){
            acc.Total_no_of_Opps_open_but_past_ERD__c = mapPastErd.get(acc.id).size();
            listToUpdate.add(acc);
        }
        if(listToUpdate.size() > 0){
            update listToUpdate;
        }
    }
    
     global void finish(Database.BatchableContext BC) {

    } */
}