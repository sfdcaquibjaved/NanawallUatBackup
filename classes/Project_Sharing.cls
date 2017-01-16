/**********************************************************************
Apex Test Class: Project_Sharing
Description: This class is used to create/delete the Project Share records when an Opportunity Team member is added / deleted .
Created Date: June 11th , 2015            
***********************************************************************/

public class Project_Sharing{
	
	/*************************************************
    Method Name: share_record
    Description: This method is used to create a Project Share record for every  OpportunityTeamMember added .
    Input Parameter: List of OpportunityTeamMember
    *************************************************/
    public static void share_record(List<OpportunityTeamMember> newTrigger)
    {
        List<Project__share> projShares = new List<Project__share>();
        List<Opportunity> OppRecsList = new List<Opportunity>();
        Set<Id> OppRecsIdList = new Set<Id>();
        Map<Id,Id> mapProjUsrIds = new Map<Id,Id>();
        
        //Populating the OpportunityId's of the OpportunityTeamMember
        for( OpportunityTeamMember member : newTrigger )
        {
            OppRecsIdList.add(member.OpportunityId);
        }
       
        //Query all the Opportunity team Members on the Opportunity
        list<OpportunityTeamMember> oppTeamMemlst = [select id, OpportunityId,Opportunity.Project_Name__c, UserId from OpportunityTeamMember where OpportunityId = : OppRecsIdList];
        
        for(OpportunityTeamMember opp: oppTeamMemlst){
            mapProjUsrIds.put(opp.OpportunityId,opp.Opportunity.Project_Name__c);
        }
        
        list<Project__share> projSharelst = [Select Id,ParentId,UserOrGroupId,RowCause from Project__share where ParentId = : mapProjUsrIds.Values()];
        map<String,Project__share> mapProjectShare = new map<String,Project__share>();
        
        
        for (Project__share pShare : projSharelst){
        	mapProjectShare.put(pShare.UserOrGroupId + '#' + pShare.ParentId ,pShare);
        }
        
        //Create the Project Share record for the User added to the OpportunityTeam and populate them in a list
        for (OpportunityTeamMember otm : oppTeamMemlst){
        	if(!mapProjectShare.containsKey(otm.UserId + '#' + mapProjUsrIds.get(otm.OpportunityId))){
        	Project__share projectShareRecord = new Project__share();
            projectShareRecord.ParentId = mapProjUsrIds.get(otm.OpportunityId);
            projectShareRecord.UserOrGroupId = otm.UserId ;
            projectShareRecord.AccessLevel = 'Read';
            projectShareRecord.RowCause = 'Manual';
            projShares.add(projectShareRecord);
          }
        }
       
        //NULL CHECK
        if (projShares.size() > 0){
        	//Upsert the list of Project Share records 	
        	Database.UpsertResult[] sr = Database.upsert(projShares, False);
            ErrorLogUtility.processUpsertErrorLogs(sr, projShares, 'Project_Sharing', 'share_record', 'Project__share', 'Upsert');
        }
     }
     
     /*************************************************
    Method Name: delete_share_record
    Description: This method is used to delete a Project Share record of OpportunityTeamMember deleted provided 
    			 that User is not in other OpportunityTeam of the same Project.
    Input Parameter: List of OpportunityTeamMember
    *************************************************/
     public static void delete_share_record(List<OpportunityTeamMember> oldTrigger)
     {
        List<Id> projIdsList = new List<Id>();
        List<Project__Share> delProjShareLst = new List<Project__Share>();
        Set<Id> oppIdsSet = new Set<Id>();
        Set<Id> userIdsSet = new Set<Id>();
        Set<Id> delUsersSet = new Set<Id>();
        set<Id> idsToDel = new Set<Id>();
        Map<Id,Id> opptoProjIdsMap = new Map<Id,Id>();
        
        //Populating the OpportunityId's and UserId's of the OpportunityTeamMember deleted
        for( OpportunityTeamMember member : oldTrigger )
        {
            oppIdsSet.add(member.OpportunityId);
            idsToDel.add(member.UserId);
        }   
        
        //Querying the Opportunities with their respective Project
        List<Opportunity> oppRecsList = [select id, Project_Name__c from Opportunity where Id IN :oppIdsSet];
        for(Opportunity opp: oppRecsList)
       	{
            opptoProjIdsMap.put(opp.Id,opp.Project_Name__c);
        }
        
        //Query the Opportunity with its OpportunityTeamMembers excluding the User which was deleted 
        List<Opportunity> oppLst = [Select Id ,Project_Name__c, (Select Id,OpportunityId,UserId FROM OpportunityTeamMembers) FROM Opportunity WHERE Project_Name__c IN :opptoProjIdsMap.values() AND Id NOT IN :oppIdsSet];
        
        //Populate the User ids into a set
        for(Opportunity opp :oppLst)
        {
          for (OpportunityTeamMember oppTeam : opp.OpportunityTeamMembers){
          	userIdsSet.add(oppTeam.UserId);
          }	
        }
        
        for(Id tempId : idsToDel)
        {
	        if(!(userIdsSet.contains(tempId)))
	        delUsersSet.add(tempId);
        }
         
        //Query the Share records which have to be deleted
        delProjShareLst = [Select Id,RowCause FROM Project__Share WHERE UserOrGroupId =:delUsersSet AND Rowcause='Manual' And ParentId =: opptoProjIdsMap.values()];
        
        //NULL CHECK
        if (delProjShareLst.size() > 0){
	        //Delete the Project Share records
	        Database.DeleteResult[] sr = Database.delete(delProjShareLst, false);
            ErrorLogUtility.processDeleteErrorLogs(sr, delProjShareLst, 'Project_Sharing', 'delete_share_record', 'Project__share', 'Delete');
        }
    }
    
    /*************************************************
    Method Name: delete_Owner_Sharing
    Description: This method is used to delete a Project Share record of OpportunityTeamMember deleted provided 
    			 that User is not in other OpportunityTeam of the same Project.
    Input Parameter: List of Opportunity
    *************************************************/
    
     public static void delete_Owner_Sharing(Set<id> oppId , set<Id> delUserId)
     {
     	
     	Map<Id,Id> opptoProjIdsMap = new Map<Id,Id>();
        Set<Id> userIdsSet = new Set<Id>();
        Set<Id> delUsersSet = new Set<Id>();
        List<Project__Share> delProjShareLst = new List<Project__Share>();
     	
        //Querying the Opportunities with their respective Project
        List<Opportunity> oppRecsList = [select id, Project_Name__c from Opportunity where Id IN :oppId];
        for(Opportunity opp: oppRecsList)
       	{
            opptoProjIdsMap.put(opp.Id,opp.Project_Name__c);
        }
        
        //Query the Opportunity with its OpportunityTeamMembers excluding the User which was deleted 
        List<Opportunity> oppLst = [Select Id ,Project_Name__c, (Select Id,OpportunityId,UserId FROM OpportunityTeamMembers) FROM Opportunity WHERE Project_Name__c IN :opptoProjIdsMap.values() AND Id NOT IN :oppId];
        
        //Populate the User ids into a set
        for(Opportunity opp :oppLst)
        {
          for (OpportunityTeamMember oppTeam : opp.OpportunityTeamMembers){
          	userIdsSet.add(oppTeam.UserId);
          }	
        }
        
        for(Id tempId : delUserId)
        {
	        if(!(userIdsSet.contains(tempId)))
	        delUsersSet.add(tempId);
        }
         
        //Query the Share records which have to be deleted
        delProjShareLst = [Select Id,RowCause FROM Project__Share WHERE UserOrGroupId =:delUsersSet AND Rowcause='Manual' And ParentId =: opptoProjIdsMap.values()];
        
        //NULL CHECK
        if (delProjShareLst.size() > 0){
	        //Delete the Project Share records
	        Database.DeleteResult[] sr = Database.delete(delProjShareLst, false);
            ErrorLogUtility.processDeleteErrorLogs(sr, delProjShareLst, 'Project_Sharing', 'delete_Owner_Sharing', 'Project__share', 'Delete');
        }	
     	
     }
    
}