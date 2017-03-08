public with sharing class OpportunityTeamMember_Delete {


    private final OpportunityTeamMember teammember;
    public OpportunityTeamMember_Delete(ApexPages.StandardController stdController) 
    {    
        this.teammember = (OpportunityTeamMember)stdController.getRecord();    
    }
    
    
    // we need this method because SF doesnt allow you to delete a team member that is on a 
    //split. so we need to kill the split FIRST, and we cant do it in a trigger. 
    // dont need to delete the teammember because the split will be 
    public PageReference doDelete()
    {
		id oppid = teammember.OpportunityId;
    
		list<OpportunitySplit> splitsToDelete = new list<OpportunitySplit>();
		for( OpportunitySplit split : [SELECT Id FROM OpportunitySplit WHERE OpportunityId = :teammember.OpportunityId AND SplitOwnerID = :teammember.UserId] )
		{
			splitsToDelete.add(split);
		}
		
		if( splitsToDelete.size() > 0 )
		{
			delete splitsToDelete; 
		} else
		{
			delete teammember;
		}
		return new PageReference('/' + oppid);
//		return null;
    
    }


}