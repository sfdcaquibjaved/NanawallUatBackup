trigger OpportunitySplit_Insert on OpportunitySplit (before insert) {

    /*
        purpose: 
            - makes sure the team member exists before the split goes in.  Cant use the built in function because we need to 
                do this in both directions 
    */
    if( trigger.isBefore )
    {
    
        list<OpportunityTeamMember> membersToAdd = new list<OpportunityTeamMember>();
        OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];
    
//      set<string> existingTeamMembers = new set<string>();
        
        list<Id> oppIds = new list<Id>();
        for( OpportunitySplit split : trigger.new ) 
        {
            oppIds.add(split.OpportunityId); 
        }

        for( OpportunityTeamMember tm : [SELECT OpportunityId, UserId FROM OpportunityTeamMember WHERE OpportunityId = :oppIds] )
        {
            TriggerVariables.OpportunitySplit_Insert_existingTeamMembers.add( tm.OpportunityId + '_' + tm.UserId + '_' + splittype.Id);
        }
        
        for( OpportunitySplit split : trigger.New ) 
        { 
            TriggerVariables.OpportunityTeamMember_Insert_existingSplits.add( split.OpportunityId + '_' + split.SplitOwnerId+ '_' + splittype.Id);
            
            if( !TriggerVariables.OpportunitySplit_Insert_existingTeamMembers.contains(split.OpportunityId+'_' + split.SplitOwnerId + '_' + splittype.Id) )
            {
                OpportunityTeamMember member = new OpportunityTeamMember( );
                member.UserId = split.SplitOwnerId;
                member.OpportunityId = split.OpportunityId;
                if(  split.SplitOwnerId == split.Opportunity.OwnerId)
                {
                    member.Credit__c = 'Lo';
                
                }
                
                membersToAdd.add( member ); 
                  
                //flag the object so it doesnt get repeat inserted
                TriggerVariables.OpportunitySplit_Insert_existingTeamMembers.add( split.OpportunityId+ '_' + split.SplitOwnerId + '_' + splittype.Id);
            } 
        }
        
        
        if( membersToAdd.size() > 0  )
        {
            try 
            {
                insert membersToAdd;
            } catch( exception ex )
            {
                //meep, meep 
            }
        }
    }

}