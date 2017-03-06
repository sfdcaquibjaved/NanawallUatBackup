/*********************************************************************************************************************
Trigger Name: OpportunityTeamMember_Update
Events: after update,before update
Description: Functionality for Creating Project Share Records on Updating of User to opportunityTeam
**********************************************************************************************************************/

trigger OpportunityTeamMember_Update on OpportunityTeamMember (after update, before update) {

    //Updates the Project Apex Sharing if the Opportunity Team Member is added
    //if(Trigger.isUpdate && Trigger.isAfter)
    //Project_Sharing.share_record(Trigger.new);
    
}