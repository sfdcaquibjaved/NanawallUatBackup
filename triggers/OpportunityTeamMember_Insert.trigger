/*********************************************************************************************************************
Trigger Name: OpportunityTeamMember_Insert
Events: after insert,before insert
Description: Functionality for Split Users Update , Creating Project Share Records on adding of User to opportunityTeam
**********************************************************************************************************************/
trigger OpportunityTeamMember_Insert on OpportunityTeamMember (after insert, before insert,before delete,after delete) {
    Set<Id> oppIds = new Set<Id>();
    Set<Id> userIds = new Set<Id>();
    //Updates the Project Apex Sharing if the Opportunity Team Member is added
    if(Trigger.isInsert && Trigger.isAfter){
    //Create the Project Share records on the After Insert event of the OpportunityTeamMember
    Project_Sharing.share_record(Trigger.new);
    for(OpportunityTeamMember oTm : trigger.new){
    	oppIds.add(oTm.OpportunityId);
    }
    if(Trigger.isInsert && oppTeamHelper.runoppTeamUpdate){
    	oppTeamHelper.oppTeamUpdate(oppIds);
    }
    }
    if(Trigger.isDelete && Trigger.isBefore){
    	for(OpportunityTeamMember oTm : trigger.old){
    	oppIds.add(oTm.OpportunityId);
    	}
    	oppteamHelper.validateDeletion(oppIds,trigger.old);
    } 
   
    if(Trigger.isAfter && Trigger.isDelete && oppTeamHelper.rundelOppTeamMembers){
    	for(OpportunityTeamMember oTm : trigger.old){
    	oppIds.add(oTm.OpportunityId);
    	userIds.add(oTm.UserId);
    	}
    	oppteamHelper.delOppTeamMembers(oppIds, trigger.old);
    	
   } 
     if (trigger.isAfter && trigger.isDelete){
      Project_Sharing.delete_share_record(Trigger.old);
      }
}