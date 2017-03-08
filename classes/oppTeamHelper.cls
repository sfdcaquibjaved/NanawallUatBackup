/**********************************************************************
Apex Class: oppTeamHelper
Description: This class is used to create/delete the Opportunity Team members records on all the other opps under the same project
when an Opportunity Team member is added / deleted .
Created Date: June 30th , 2015            
***********************************************************************/
public class oppTeamHelper {
	
	    public static boolean runoppTeamUpdate = true ;
	    public static boolean rundelOppTeamMembers = true ;
	
	
		/******************************************************************************************************************************************
		Method Name : oppTeamUpdate
		Description: This method is used to create the Opportunity Team members records on all the other opps under the same project
		when an Opportunity Team member is added.
		Input Variables : set of opp ids          
		*******************************************************************************************************************************************/
       
       public static void oppTeamUpdate(set < Id > setOpp) {
        
        Set<Id> projIds = new Set<Id>();
         	  
	    //Getting the Current Projects in which the opportunity members are getting added
	    list < Opportunity > lstOppty = [select id, project_name__c from Opportunity where Id IN: setOpp];
	    for (Opportunity Opp: lstOppty) {
	    	if(Opp.project_name__c != null){
	        projIds.add(Opp.project_name__c);
	    	}
	     }
         
         if (projIds.size() >0){
         	oppTeamHelper.runoppTeamUpdate = false ;
         	oppTeamHelper.syncOpportunityTeamMember(projIds);
         	
         }
	  }	
	
	   /******************************************************************************************************************************************
		Method Name : syncOpportunityTeamMember
		Description: This method is used to create the Opportunity Team members records on all the other opps under the same project
		when an Opportunity Team member is added.
		Input Variables : set of Project Ids          
		*******************************************************************************************************************************************/
	
	
	public static void syncOpportunityTeamMember(set < Id > setProjId) {
		
	    list < OpportunityTeamMember > oppTeamInsert = new list < OpportunityTeamMember > (); //list to Insert
    	map < Id, set < Id >> oppUserIdMap = new map < Id, set < Id >> (); // Map which will store all the existing team member ids with the opp id as the key
    	map < Id, set < Id >> projUserIdMap = new map < Id, set < Id >> ();
    	
    	 list<Opportunity> oppAll = [Select Id, project_name__c, (Select Id,UserId, OpportunityId from OpportunityTeamMembers) from Opportunity where Project_Name__c = : setProjId];
    	 
    	 for (Opportunity opp: oppAll) {
	        Set < Id > userIdSet = new Set < Id > ();
	        system.debug('--------set-----'+userIdSet);
	        system.debug('--------OPp Set-----'+oppUserIdMap);
	      	System.debug('-----Opp Id Value----'+opp.Id);
	        for (OpportunityTeamMember oppTeam: opp.OpportunityTeamMembers) {
	            userIdSet.add(oppTeam.UserId);
	            System.debug('----Count me One----'+oppTeam.userId+'----OppId---'+oppTeam.OpportunityId+'---myId--'+oppTeam.Id);
	        }
	        if(!oppUserIdMap.containsKey(opp.Id))
	        	oppUserIdMap.put(opp.Id, new set<Id>(userIdSet)); //Populated map contains all the existing team member ids with the opp id as the key
	        
	        if (!projUserIdMap.containsKey(opp.Project_Name__c)){
	        	projUserIdMap.put(opp.Project_Name__c, userIdSet);
	        }
	        else{
	        	Set<Id> setUseId = new Set<Id>();
	        	setUseId = projUserIdMap.get(opp.Project_Name__c);
	        	setUseId.addAll(userIdSet);
	        	projUserIdMap.put(opp.Project_Name__c,setUseId);
	        }
	        System.debug('--mapValues---'+oppUserIdMap.get(opp.Id));
	    }
	    system.debug('&&&&&&&&&&&&&&&&&&&&'+projUserIdMap);
	    system.debug('####################'+oppUserIdMap);
	    for (Opportunity opp: oppAll){
	        for (Id userId : projUserIdMap.get(opp.Project_Name__c)){
	        	System.debug('&&&&&&&&&&%%%%%%%%' + oppUserIdMap.get(opp.Id));
	        	System.debug('************BDNSBDNMSD' + projUserIdMap.get(opp.Project_Name__c));
	        	if(!oppUserIdMap.get(opp.Id).Contains(userId)){
	        	System.debug('&&&&&&&&&&>>>>>>>>>>' + opp.Id);
	        	 OpportunityTeamMember newOppTeam = new OpportunityTeamMember(); // New Opportunity Team Member
	             newOppTeam.OpportunityId = opp.Id;
	             newOppTeam.UserId = userId;
	             oppTeamInsert.add(newOppTeam);
	        	}
	        } 
	     } 
	    system.debug('####@@@@@'+oppTeamInsert);
	    if (oppTeamInsert.size() >0){
	    	Database.saveresult[] sr = Database.insert(oppTeamInsert, False);
	        ErrorLogUtility.processErrorLogs(sr, oppTeamInsert, 'oppTeamHelper', 'syncOpportunityTeamMember', 'OpportunityTeamMember', 'Insert');
	    }
		
	}

	/**********************************************************************
	Apex Class: OppotunityTeamMemberHelper
	Description: This class is used to delete the Opportunity Team member records on all the other opps under the same project
	when an Opportunity is deleted.
	Input Variables : set of opp ids and oppTeamMember trigger.new  --BEFORE DELETE        
	***********************************************************************/
	
	 public static void validateDeletion(set<Id> setOppIds,list<opportunityTeamMember> lstToDelete){
	 	set<Id> setProjIds= new set<Id>();
	 	map<Id,set<Id>> mapOppTeamMembersToDel= new map<Id,set<Id>>();
		for(Opportunity opp: [Select id, project_name__c from opportunity where Id IN : setOppIds]){
			setProjIds.add(opp.project_name__c);
		}
		for(Opportunity restOpps :[Select id,ownerId,project_name__c,Project_name__r.OwnerId from opportunity where (project_name__c IN: setprojIds AND Id NOT IN: setoppIds)]){
			if (mapOppTeamMembersToDel != null && !mapOppTeamMembersToDel.containsKey(restOpps.project_Name__c)) {
	                Set < Id > setOwnerId = new Set < Id > ();
	                setOwnerId.add(restOpps.OwnerId);
	                setOwnerId.add(restOpps.Project_name__r.OwnerId);
	                mapOppTeamMembersToDel.put(restOpps.Project_Name__c, setOwnerId);
	             }  else if (mapOppTeamMembersToDel.containsKey(restOpps.Project_Name__c)) {
	                Set < Id > setOwnerId = new Set < Id > ();
	                setOwnerId = mapOppTeamMembersToDel.get(restOpps.Project_Name__c);
	                setOwnerId.add(restOpps.OwnerId);
	                mapOppTeamMembersToDel.put(restOpps.Project_Name__c, setOwnerId);
	            }
		}
		for(Opportunity opp :[Select Id, OwnerId,Project_name__r.OwnerId,Project_name__c,(Select Id,UserId,OpportunityId,OpportunityAccessLevel from OpportunityTeamMembers ) from Opportunity where Id IN : setOppIds]){
			for(OpportunityTeamMember oppTeam : lstToDelete){
				if(opp.Id==oppTeam.OpportunityId){
					if(mapOppTeamMembersToDel.containsKey(opp.project_name__c) && mapOppTeamMembersToDel.get(opp.project_name__c).contains(oppTeam.userId)){
						//oppTeam.addError('You can not delete this Opportunity Team Member as this is a owner of an existing Opportunity under the same project or the Project Owner');
					}
				}
			}
		}
	 }
	 
	/**********************************************************************
	Apex Class: OppotunityTeamMemberHelper
	Description: This class is used to delete the Opportunity Team member records on all the other opps under the same project
	when an Opportunity is deleted.
	Input Variables : set of opp ids and oppTeamMember trigger.new  --AFTER DELETE        
	***********************************************************************/
	
	  public static void delOppTeamMembers(set<Id> setOppIds,list<OpportunityTeamMember> lstToDelete){
	     set<Id> setProjIds= new set<Id>();
  		 set<Id> setUserIds= new set<Id>();
  		 map<Id,set<Id>> mapOppTeamMembersToDel = new map<Id,set<Id>>();
  	     
  	      for(Opportunity opp :[Select Id, OwnerId,Project_name__c,(Select Id,UserId,OpportunityId,OpportunityAccessLevel from OpportunityTeamMembers ) from Opportunity where Id IN : setOppIds]){
			Set < Id > setUserId = new Set < Id > ();
		
			for(OpportunityTeamMember oppTeam : lstToDelete){
				if(opp.Id==oppTeam.OpportunityId){
					if (mapOppTeamMembersToDel != null && !mapOppTeamMembersToDel.containsKey(opp.project_Name__c)) {
                	setUserId.add(oppTeam.UserId);
                	mapOppTeamMembersToDel.put(opp.project_Name__c, setUserId);
                	setUserIds.addAll(setUserId);
            	 }  else if (mapOppTeamMembersToDel.containsKey(opp.project_Name__c)) {
                	setUserId = mapOppTeamMembersToDel.get(opp.project_Name__c);
                	setUserId.add(oppTeam.UserId);
                	mapOppTeamMembersToDel.put(opp.project_Name__c, setUserId);
                	setUserIds.addAll(setUserId);
            		}
	   			}
			}
		}
			list<OpportunityTeamMember> oppTeamDelete= [Select id,userId,opportunity.Project_Name__c from opportunityTeamMember where (opportunity.project_name__c IN:mapOppTeamMembersToDel.keySet() AND userId IN: setUserIds)];
			
			if (oppTeamDelete.size() > 0){
				Database.DeleteResult[] sr = Database.delete(oppTeamDelete, false);
                ErrorLogUtility.processDeleteErrorLogs(sr, oppTeamDelete, 'oppTeamHelper', 'delOppTeamMembers', 'OpportunityTeamMember', 'Delete');
                
                rundelOppTeamMembers = false ;
			}	
	  }
  	
}