trigger OpportunityInsertAddSalesTeam on Opportunity (after insert) {

    /*
    trigger purpose
        Adds the team wrapper object for the salesteam. for some reason, its not getting added when the default split-team owner is added
    */

    /*if( trigger.isAfter && trigger.isInsert )
    {
        list<OpportunitySplit> oppSplits = new list<OpportunitySplit>();
//      OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Revenue'];
        
        OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];

        list<nrOpportunityTeamMember__c> nrOTMS = new list<nrOpportunityTeamMember__c>();
        
        
        for( Opportunity o : Trigger.new )
        {

            OpportunitySplit split = new OpportunitySplit();
            split.SplitOwnerId = o.OwnerId;
            split.OpportunityId = o.Id;
            split.SplitPercentage = 100;
            split.SplitTypeId = splittype.Id;
            oppsplits.add(split);        

            nrOpportunityTeamMember__c tm = new nrOpportunityTeamMember__c();
            tm.Opportunity__c = o.Id;
            tm.User__c = o.OwnerID; 
            
            nrOTMs.add(tm);
        }
    
        if( oppSplits.size() > 0 )
            insert oppSplits;    
    
        if( nrOTMs.size() > 0  )
            insert nrOTMs;
    }*/
}