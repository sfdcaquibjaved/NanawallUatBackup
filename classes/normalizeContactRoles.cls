global class normalizeContactRoles implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Constructing the query
        
        String query = 'Select Id ,contact__c,opportunity__c FROM quote__c  ';
        return Database.getQueryLocator(query);
    }
    
     
     global void execute(Database.BatchableContext BC, List<Quote__c> scope)
    {
         map<id,set<id>> oppConMap = new map<id,set<id>>();  
         map<id,set<id>> conRoleMap = new map<id,set<id>>();
         set<id> conRoleToInsert = new set<id>();
         set<id> oppConRoleSet = new set<Id>();
         list<nrOpportunityContactRole__c> conRolesToDeleteList = new list <nrOpportunityContactRole__c>();
         list<nrOpportunityContactRole__c> conRoleToInsertList = new list <nrOpportunityContactRole__c>();
         
          
         set<Id> conRolesToDelete = new set<Id>();    
         for (Quote__c quoteCon: scope) {
         if(quoteCon.opportunity__c != Null){
                if (oppConMap != null && !oppConMap.containsKey(quoteCon.opportunity__c)) {
                    Set < Id > setConId = new Set < Id > ();
                    setConId.add(quoteCon.contact__c);
                    oppConMap.put(quoteCon.opportunity__c, setConId);
                } else if (oppConMap.containsKey(quoteCon.opportunity__c)) {
                    Set < Id > setConId = new Set < Id > ();
                    setConId = oppConMap.get(quoteCon.opportunity__c);
                    setConId.add(quoteCon.opportunity__c);
                    oppConMap.put(quoteCon.opportunity__c, setConId);
                }
              }
          }
         system.debug('22222222222222'+ oppConMap);
         for(nrOpportunityContactRole__c custContRole : [select id,opportunity__c,contact__c from nrOpportunityContactRole__c where opportunity__c IN : oppConMap.keyset()]){
            if (conRoleMap != null && !conRoleMap.containsKey(custContRole.opportunity__c)) {
                Set < Id > setConRoleId = new Set < Id > ();
                setConRoleId.add(custContRole.contact__c);
                conRoleMap.put(custContRole.opportunity__c, setConRoleId);
            } else if (conRoleMap.containsKey(custContRole.opportunity__c)) {
                Set < Id > setConRoleId = new Set < Id > ();
                setConRoleId = conRoleMap.get(custContRole.opportunity__c);
                setConRoleId.add(custContRole.contact__c);
                conRoleMap.put(custContRole.opportunity__c, setConRoleId);
            }
         system.debug('1111111111111'+ conRoleMap);
            if(oppConMap.containsKey(custContRole.opportunity__c) && !(oppConMap.get(custContRole.opportunity__c).contains(custContRole.contact__c))){
                
                if (!oppConRoleSet.contains(custContRole.Id)){
                oppConRoleSet.add(custContRole.Id);
                conRolesToDeleteList.add(custContRole);
               }
            }
         }
         if (conRolesToDeleteList.size()> 0){
            Database.deleteresult[] dr = Database.delete(conRolesToDeleteList, False);
            ErrorLogUtility.processDeleteErrorLogs(dr, conRolesToDeleteList, 'Execute', 'normalizeContactRoles', 'nrOpportunityContactRole__c', 'Delete');
        } 
         system.debug('3333333333333'+scope);
         for (Quote__c consToAdd : scope){
            if(conRoleMap.containsKey(consToAdd.opportunity__c) && !(conRoleMap.get(consToAdd.opportunity__c).contains(consToAdd.contact__c))){
                nrOpportunityContactRole__c insetNewConRole = new nrOpportunityContactRole__c();
                insetNewConRole.contact__c= consToAdd.contact__c;
                insetNewConRole.opportunity__c= consToAdd.opportunity__c;
                insetNewConRole.role__c= 'Other';
                conRoleToInsertList.add(insetNewConRole);
            }
         }
         
         if (conRoleToInsertList.size()> 0){
            Database.saveresult[] sr = Database.insert(conRoleToInsertList, False);
            ErrorLogUtility.processErrorLogs(sr, conRoleToInsertList, 'Execute', 'normalizeContactRoles', 'nrOpportunityContactRole__c', 'Insert');
        } 
         }
    global void finish(Database.BatchableContext BC)
    {
    }

}