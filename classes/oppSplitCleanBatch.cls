/*************************************************************************
    @ Author        : Absyz
    @ Date          : Oct 2015
    @ Test File     : 
    @ Description   : Batch Class 
    
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
***********************************************************************************/

global class  oppSplitCleanBatch implements Database.Batchable < sObject >
//implements Database.Batchable < sObject >
 {
    
     //Global Variable
    global String query;
    
    
     //Start method of the batch class
     global Database.QueryLocator start(Database.BatchableContext BC) {
        set<ID> projset = new set<Id>();
        //projset.add('a1sK0000000KIpV');
        this.query = 'SELECT Id,ownerId from Project__c ' ;
        
        return Database.getQueryLocator(query);
    }
    
    
    //Execute method of the batch class
    global void execute(Database.BatchableContext BC, List < Project__c > records) {
        
       // Set<Id> projIdSet = new Set<Id>();
        //map < Id, set < Id >> mapProjOpp = new map < Id, set < Id >> ();
        map < Id, Id > mapProjOwn = new map < Id,Id > ();
        list<OpportunityTeamMember> oppTeamToDelList = new list<OpportunityTeamMember>();
        
        
        for (Project__c proj : records){
            mapProjOwn.put(proj.id,proj.OwnerId);
        }
       /* for(Opportunity opp : [select id,project_name__c ,project_name__r.OwnerId, ownerId from opportunity where project_name__c IN : projIdSet]){
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
        }*/
        system.debug('The map is '+ mapProjOwn);
       for(OpportunityTeamMember  oppTeam : [select id,userId,opportunityId ,opportunity.Project_Name__c from OpportunityTeamMember where opportunity.Project_Name__c IN :mapProjOwn.keySet() ] ){
     		if(mapProjOwn.containsKey(oppTeam.opportunity.Project_Name__c)){
     			if(mapProjOwn.get(oppTeam.opportunity.Project_Name__c)!= oppTeam.userId){
     				OpportunityTeamMember newOppTeam = new OpportunityTeamMember(); // New Opportunity Team Member
                 	newOppTeam.OpportunityId = oppTeam.OpportunityId;
                 	newOppTeam.UserId = mapProjOwn.get(oppTeam.opportunity.Project_Name__c);
     				oppTeamToDelList.add(newOppTeam);
     			}
     		}
     	}
     	system.debug(oppTeamToDelList);
     	if(oppTeamToDelList.size()>0){
     		Database.Insert(oppTeamToDelList);
     	}
     	
     	
    }
     
      //Finish method of the batch class
    global void finish(Database.BatchableContext BC) {

    }
    
   

}