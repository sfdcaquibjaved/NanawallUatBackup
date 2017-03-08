trigger OpportunityTeamMember_Delete on OpportunityTeamMember (before delete , after delete) {

    if(trigger.isBefore  )
    {
        
        list<Id> OppIds = new list<Id>();
        map<string, nrOpportunityTeamMember__c> nrOTMMap = new map<string, nrOpportunityTeamMember__c>();
        map<string, OpportunitySplit> splitMap = new map<string, OpportunitySplit>();
        list<nrOpportunityTeamMember__c> nrOTMsToDelete = new list<nrOpportunityTeamMember__c>();
        list<OpportunitySplit> splitsToDelete = new list<OpportunitySplit>();
        OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];
        
        
        for( OpportunityTeamMember tm : trigger.old )
        {
            oppids.add(tm.OpportunityId);
            
        }
        
        for( nrOpportunityTeamMember__c nrotm : [SELECT Opportunity__c, User__c FROM nrOpportunityTeamMember__c WHERE OPportunity__c = :oppIds])
        {
            nrOTMMap.put( nrotm.User__c+'_'+nrotm.Opportunity__c, nrotm);
        }

        for( OpportunitySplit split : [SELECT OpportunityId, SplitOwnerID FROM OpportunitySplit WHERE OpportunityId = :oppIds AND SplitTypeId = :splittype.Id])
        {
            splitMap.put( split.SplitOwnerId+'_'+ split.OpportunityId, split);
        }

        for( OpportunityTeamMember tm : trigger.old)
        {
            if( nrOTMMap.containsKey(tm.UserId+'_'+tm.OpportunityId) ) 
            {
                nrOTMsToDelete.add(nrOTMMap.get(tm.UserId+'_'+tm.OpportunityId));
            }
            
            if( splitMap.containsKey(tm.UserId+'_'+tm.OpportunityId) ) 
            {
                splitsToDelete.add(splitMap.get(tm.UserId+'_'+tm.OpportunityId));
            }
            
            
            
        }
        

        if( nrOTMsToDelete.size() > 0 )
        {
            delete nrOTMsToDelete;  
        }
        
        if( splitsToDelete.size() > 0 )
        {
            delete splitsToDelete;
        }
    }
    
    /****************************************************************************/
    /*After Insert*/
    else if(trigger.isAfter)
            //Delete the old share records
            Project_Sharing.delete_share_record(Trigger.old);
    /****************************************************************************/


}