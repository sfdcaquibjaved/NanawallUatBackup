/*************************************************************************
    @ Author        : Absyz
    @ Date          : May 2015
    @ Test File     : 
    @ Description   : Batch Class 
    
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
***********************************************************************************/

global class  oppTeamSyncBatchClass/* implements Database.Batchable < sObject >*/ {/*
    
     //Global Variable
    global String query;
    
    
     //Start method of the batch class
     global Database.QueryLocator start(Database.BatchableContext BC) {
        
        this.query = 'SELECT Id from Project__c Order By CreatedDate desc' ;
        
        return Database.getQueryLocator(query);
    }
    
    
    //Execute method of the batch class
    global void execute(Database.BatchableContext BC, List < Project__c > records) {
        
        Set<Id> projIdSet = new Set<Id>();
        
        oppTeamHelper.runoppTeamUpdate = false;
        
        for (Project__c proj : records){
            projIdSet.add(proj.Id);
        }
        
        list < OpportunityTeamMember > oppTeamInsert = new list < OpportunityTeamMember > (); //list to Insert
        map < Id, set < Id >> oppUserIdMap = new map < Id, set < Id >> (); // Map which will store all the existing team member ids with the opp id as the key
        map < Id, set < Id >> projUserIdMap = new map < Id, set < Id >> ();
        
         list<Opportunity> oppAll = [Select Id, project_name__c, (Select UserId, OpportunityId from OpportunityTeamMembers) from Opportunity where Project_Name__c = : projIdSet];
        
         list<OpportunityTeamMember> oppAllTeamMember  = new list<OpportunityTeamMember>();
         
         for (Opportunity opp: oppAll) {
            Set < Id > userIdSet = new Set < Id > ();
          
            for (OpportunityTeamMember oppTeam: opp.OpportunityTeamMembers) {
                userIdSet.add(oppTeam.UserId);
                oppAllTeamMember.add(oppTeam);
            }
            oppUserIdMap.put(opp.Id, new set<Id>(userIdSet)); //Populated map contains all the existing team member ids with the opp id as the key
            
            if (!projUserIdMap.containsKey(opp.Project_Name__c)){
                projUserIdMap.put(opp.Project_Name__c, userIdSet);
            }
            else{
                projUserIdMap.get(opp.Project_Name__c).addAll(userIdSet);
            }
        }
        
        for (Opportunity opp: oppAll){
            for (Id userId : projUserIdMap.get(opp.Project_Name__c)){
                if(!oppUserIdMap.get(opp.Id).Contains(userId)){
                 OpportunityTeamMember newOppTeam = new OpportunityTeamMember(); // New Opportunity Team Member
                 newOppTeam.OpportunityId = opp.Id;
                 newOppTeam.UserId = userId;
                 oppTeamInsert.add(newOppTeam);
                }
            } 
        }
        
        if (oppTeamInsert.size() >0){
            Database.saveresult[] sr = Database.insert(oppTeamInsert, False);
            ErrorLogUtility.processErrorLogs(sr, oppTeamInsert, 'oppTeamSyncBatchClass', 'Execute', 'OpportunityTeamMember', 'Insert');
        }
     }
     
      //Finish method of the batch class
    global void finish(Database.BatchableContext BC) {

    } */
    
    

}