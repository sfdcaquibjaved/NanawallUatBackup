trigger OpportunitySplit_Delete on OpportunitySplit (after delete ) {


    if(trigger.isAfter  )
    {
        
        list<Id> OppIds = new list<Id>();
        map<string, OpportunityTeamMember> teamMemberMap = new map<string, OpportunityTeamMember>();
        list<OpportunityTeamMember> membersToDelete = new list<OpportunityTeamMember>();
        for( OpportunitySplit split : trigger.old )
        {
            oppids.add(split.OpportunityId);
        }
        
        for( OpportunityTeamMember member : [SELECT UserId, OpportunityID FROM OpportunityTeamMember WHERE OPportunityId = :oppIds])
        {
            teamMemberMap.put( member.UserId+'_'+member.OpportunityId, member);
        }

        for( OpportunitySplit split : trigger.old)
        {
            if( teamMemberMap.containsKey(split.SplitOwnerId+'_'+split.OpportunityId) )
            {
                membersToDelete.add(teamMemberMap.get(split.SplitOwnerId+'_'+split.OpportunityId));
            }
            
        }
        
        try 
        {
            if( membersToDelete.size() > 0 )
                delete membersToDelete; 
        } catch( Exception ex )
        {
        }
    }

}