/*************************************************************************
    @ Author        : Absyz
    @ Date          : Oct 2015
    @ Test File     : 
    @ Description   : Batch Class 
    
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
***********************************************************************************/

global class  oppTeamCleanUpBatch implements Database.Batchable < sObject >
 {
    
     //Global Variable
    global String query;
    
    
     //Start method of the batch class
     global Database.QueryLocator start(Database.BatchableContext BC) {
        //set<Id> projId= new set<id>();
        //projId.add('a1sK0000000KI38');
        this.query = 'SELECT Id from Project__c ';
        
        return Database.getQueryLocator(query);
    }
    
    
    //Execute method of the batch class
    global void execute(Database.BatchableContext BC, List < Project__c > records) {
        
        Set<Id> projIdSet = new Set<Id>();
        map < Id, set < Id >> mapProjOpp = new map < Id, set < Id >> ();
        map < Id, set < Id >> mapProjOwn = new map < Id, set < Id >> ();
        list<OpportunityTeamMember> oppTeamToDelList = new list<OpportunityTeamMember>();
        
        
        for (Project__c proj : records){
            projIdSet.add(proj.Id);
        }
        for(Opportunity opp : [select id,project_name__c ,project_name__r.OwnerId, ownerId from opportunity where project_name__c IN : projIdSet]){
            if (mapProjOpp != null && !mapProjOpp.containsKey(opp.project_Name__c)) {
                Set < Id > setOppId = new Set < Id > ();
                setOppId.add(opp.Id);
                setOppId.add(opp.project_name__r.OwnerId);
                mapProjOpp.put(opp.Project_Name__c, setOppId);
                } else if (mapProjOpp.containsKey(opp.Project_Name__c)) {
                Set < Id > setOppId = new Set < Id > ();
                setOppId = mapProjOpp.get(opp.Project_Name__c);
                setOppId.add(opp.Id);
                mapProjOpp.put(opp.Project_Name__c, setOppId);
                }
            if (mapProjOwn != null && !mapProjOwn.containsKey(opp.project_Name__c)) {
                Set < Id > setOppOwnId = new Set < Id > ();
                setOppOwnId.add(opp.ownerId);
                mapProjOwn.put(opp.Project_Name__c, setOppOwnId);
                } else if (mapProjOwn.containsKey(opp.Project_Name__c)) {
                Set < Id > setOppOwnId = new Set < Id > ();
                setOppOwnId = mapProjOwn.get(opp.Project_Name__c);
                setOppOwnId.add(opp.ownerId);
                mapProjOwn.put(opp.Project_Name__c, setOppOwnId);
                }
        }
       for(OpportunityTeamMember  oppTeam : [select id,userId,opportunityId ,opportunity.Project_Name__c from OpportunityTeamMember where opportunity.Project_Name__c IN :mapProjOpp.keySet() ] ){
            if(mapProjOwn.containsKey(oppTeam.opportunity.Project_Name__c)){
                if(!mapProjOwn.get(oppTeam.opportunity.Project_Name__c).contains(oppTeam.userId)){
                oppTeamToDelList.add(oppTeam);
                }
            }
        }
        
        if(oppTeamToDelList.size()>0){
            Database.delete(oppTeamToDelList);
        }
        
        
    }
     
      //Finish method of the batch class
    global void finish(Database.BatchableContext BC) {

    }
    
   

}