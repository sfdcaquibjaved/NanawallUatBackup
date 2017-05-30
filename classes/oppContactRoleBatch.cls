/*************************************************************************
    @ Author        : Absyz
    @ Date          : June 2015
    @ Test File     : 
    @ Description   : Batch Class 
    
    @ Audit Trial   : Repeating block for each change to the code
                      Commenting the block
    -----------------------------------------------------------------------------
***********************************************************************************/


global class oppContactRoleBatch /*implements Database.Batchable < sObject >*/ {/*
    
     
    global String query;
    
     global oppContactRoleBatch() {
        
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        this.query = 'SELECT Id , Name,AccountId from Opportunity Order By CreatedDate desc' ;
        
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List < Opportunity > records) {
        
        Set<Id> oppIdSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        map<String,nrOpportunityContactRole__c> custOppConRoleMap = new map<String,nrOpportunityContactRole__c>();
        map<Id,Id> contactAccountMap = new map<Id,Id>();
        
        list<nrOpportunityContactRole__c> custoppConRoletoInsertlst = new list<nrOpportunityContactRole__c>();
        list<nrOpportunityContactRole__c> custoppConRoletoUpdatelst = new list<nrOpportunityContactRole__c>();
        
        for (Opportunity opp : records){
            oppIdSet.add(opp.Id);
            accountIdSet.add(opp.AccountId);
        }
        
        list<Contact> contactlst = [Select Id,AccountId from Contact where AccountId =: accountIdSet];
        
        for (Contact con : contactlst){
            contactAccountMap.put(con.Id, con.AccountId);
        }
        
        list<OpportunityContactRole> oppConRolelst = [Select ContactId,IsPrimary,OpportunityId,Opportunity.AccountId,Role from OpportunityContactRole where OpportunityId =: oppIdSet];
        
        list<nrOpportunityContactRole__c> existcustoppConRolelst = [Select Id,Contact__c,Opportunity__c,Role__c,Primary__c from nrOpportunityContactRole__c where Opportunity__c =: oppIdSet];
        
        for (nrOpportunityContactRole__c custOppConRole : existcustoppConRolelst){
            custOppConRoleMap.put(custOppConRole.Opportunity__c + '#' + custOppConRole.Contact__c,custOppConRole);
        }
        
        for (OpportunityContactRole oppConRole : oppConRolelst){
            
            if(contactAccountMap.containsKey(oppConRole.ContactId)){
                
              if(contactAccountMap.get(oppConRole.ContactId) == oppConRole.Opportunity.AccountId){
                
                if (custOppConRoleMap.containsKey(oppConRole.OpportunityId + '#' + oppConRole.ContactId)){
                    nrOpportunityContactRole__c custOppConRoleUpd = custOppConRoleMap.get(oppConRole.OpportunityId + '#' + oppConRole.ContactId) ;
                    custOppConRoleUpd.Primary__c = oppConRole.IsPrimary ;
                    custOppConRoleUpd.Role__c = oppConRole.Role ;
                    custoppConRoletoUpdatelst.add(custOppConRoleUpd);
                    }
                else{
                    nrOpportunityContactRole__c custOppConRoleIns = new nrOpportunityContactRole__c();
                    custOppConRoleIns.Contact__c = oppConRole.ContactId ;
                    custOppConRoleIns.Opportunity__c = oppConRole.OpportunityId ;
                    custOppConRoleIns.Role__c = oppConRole.Role ;
                    custOppConRoleIns.Primary__c = oppConRole.IsPrimary ;
                    custoppConRoletoInsertlst.add(custOppConRoleIns) ;
                   }
             }
            }
        }   
        if(custoppConRoletoUpdatelst.size() > 0){
            update custoppConRoletoUpdatelst ;
        }
        
        if (custoppConRoletoInsertlst.size() > 0){
            insert custoppConRoletoInsertlst ;
        }
        
    }
    
     
    global void finish(Database.BatchableContext BC) {

    }*/
}