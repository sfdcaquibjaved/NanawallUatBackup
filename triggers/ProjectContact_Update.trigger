/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : June 2015
    @ Test File     : NA
    Function        : Trigger on Custom Opportunity Contact Role Object
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/
trigger ProjectContact_Update on nrOpportunityContactRole__c (before insert,before update, after insert, after update, after delete) {
    
    if (trigger.isBefore){
        
        set<Id> oppIdSet = new set<Id>();
        Set<Id> accIdSet = new Set<Id>();
        map<Id,Opportunity> oppIdMap = new map<Id,Opportunity>();
        map<Id,Contact> validconIdMap = new map<Id,Contact>();
        
        for (nrOpportunityContactRole__c oppCon :Trigger.new){
            oppIdSet.add(oppCon.Opportunity__c) ;
        }
        
        list<Opportunity> opplst = [Select Id,AccountId, Account.Name from Opportunity where Id=: oppIdSet];
        
        for (Opportunity opp : opplst){
            accIdSet.add(opp.AccountId);
            oppIdMap.put(opp.Id,opp);
          }
        
        list<Contact> contactlst = [Select Id, Name,Account.Name, AccountId from Contact where AccountId =: accIdSet];
        
        for (Contact con : contactlst){
            validconIdMap.put(con.Id,con);
        }
        
        for (nrOpportunityContactRole__c oppCon :Trigger.new){
            if (!validconIdMap.keySet().contains(oppCon.Contact__c)){
                oppCon.addError('Please select a contact from the Account of the Opportunity');
            }
        }
    }
    
    if (trigger.isAfter){
        if(trigger.isUpdate || trigger.isInsert)
        createOpportunityContactRole.createOppContactRole(trigger.new);
    }
    
    if (trigger.isAfter && trigger.isDelete){
        createOpportunityContactRole.deleteOppContactRole(trigger.old);
    }

    
}