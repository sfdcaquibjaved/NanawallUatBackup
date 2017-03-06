/**********************************************************************
Apex Test Class: projSharingRecal
Description: This class is used to Recalculte the APex Sharing rules once a Project Share record is inserted .
Created Date: June 12th , 2015            
***********************************************************************/
public class projSharingRecal{
        
        /*************************************************
	    Method Name: projShare
	    Description: This method is used to create a Project Share record for every  OpportunityTeamMember added .
	    Input Parameter: Map of Project record and its id
	    *************************************************/
        public static void projShare(map<Id,Project__c> projectMap)
        {
	        List<Project__Share> newprojShrs = new List<Project__Share>(); 
	        Map<Id,Id> oppIdMap = new Map<Id,Id>();
	        list<OpportunityTeamMember> oppTeamMemberlst;
	        
	        //Query the Opportunities with respective Projects
	        List<Opportunity> opplst = [Select Id, Name,Project_Name__c from Opportunity where Project_Name__c =: projectMap.keySet()];
	        for (Opportunity opp : opplst)
	        {
	        	 oppIdMap.put(opp.Id,opp.Project_Name__c);
	        }
	        
	        //Query the OpportunityTeamMembers with the Opportunity Ids
	        oppTeamMemberlst = [Select Id, Name, OpportunityId,UserId from OpportunityTeamMember where OpportunityId =: oppIdMap.keySet()];
	        
	        //Create the Project share record and add them to the list
	        for (OpportunityTeamMember oppTeam : oppTeamMemberlst){
	        	Project__Share projShr = new Project__Share();
	            projShr.UserOrGroupId = oppTeam.UserId ;
	            projShr.AccessLevel = 'Read'; 
	            projShr.ParentId =  oppIdMap.get(oppTeam.OpportunityId) ;
	            projShr.RowCause = 'Manual'; 
				newprojShrs.add(projShr); 
	        }
	      
	        try {
	        		//Null Check
	        		if(newprojShrs.size()>0){
	        		//Insert the Project Share records
	        		Database.saveresult[] sr = Database.insert(newprojShrs, False);
                    ErrorLogUtility.processErrorLogs(sr, newprojShrs, 'projSharingRecal', 'projShare', 'Project__Share', 'Insert');
	        		}
	            } 
	        
	        catch(DMLException e){
	            	System.debug(e);
	        	}
       }
}