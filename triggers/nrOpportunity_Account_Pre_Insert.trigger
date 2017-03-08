trigger nrOpportunity_Account_Pre_Insert on nrOpportunity_Account__c (before insert) {

/*
    trigger purpose
        flags opps as Chain Account if an Account with the same flag has been added;  
        
        adds the salesteam / split member for the new oppacc if it isnt on the list, 
        flags opportunities as Residential_Vertical__c as appropriate
        
*/
    //build the opp lookup of the incoming inserts
    set<Id> oppIDs = new set<id>();
    set<Id> accIds = new set<id>();
    set<Id> opportunityUpdateIDs = new set<Id>();
    set<Id> oppsToFlagAsResidentialVertical = new Set<Id>();
    map<id,id> accToProjMap = new Map<Id,Id>();
    for( nrOpportunity_Account__c oJoin : trigger.new )
    { 
        accToProjMap.put( oJoin.Account__c, oJoin.Opportunity__c);
        
        if( !oppIDs.contains( oJoin.Opportunity__c) )
            oppIDs.add( oJoin.Opportunity__c);
        if( !accIds.contains( oJoin.Account__c) )
        {
            accIds.add( oJoin.Account__c);
        }
    }

    /* build the account map; note this gets used in various places in this trigger*/
    map<string, Account> accountMap = new map<string, Account>();
    for( Account a : [SELECT id, Chain_Account__c, OwnerId, Type, Subdivision_Potential__c FROM Account WHERE id in :accIds ] )
    {
        
        if( a.Subdivision_Potential__c )
        {
            string projId = accToProjMap.get( a.Id);
            if( !oppsToFlagAsResidentialVertical.contains(projId) )
                oppsToFlagAsResidentialVertical.add(projId);
        }       
        
        accountMap.put( a.id, a );
    }


    /*we need to look up all of the salesteam members on the opportunities to see if we need to add new ones */
    map<string, OpportunityTeamMember> oppTeams = new map<string, OpportunityTeamMember>();
    for( OpportunityTeamMember otm : [SELECT UserId, OpportunityId FROM OpportunityTeamMember t WHERE OpportunityId in :oppIDs ] )
    {
        if( !oppTeams.containsKey( otm.OpportunityId + '_' + otm.UserId) )
        {
            oppTeams.put(otm.OpportunityId + '_' + otm.UserId, otm);
        }
    }
    
        
        
    /* deal with cleaning up the list of accounts to trim off duplicates first*/ 
    map<string, nrOpportunity_Account__c> extantJoins = new map<string, nrOpportunity_Account__c>();
    //find all of the existing joins on the incoming projects, do a crappy key thing to enable a lookup against the objs in trigger.new
    for( nrOpportunity_Account__c oJoin : [SELECT id, Opportunity__c, Account__c FROM nrOpportunity_Account__c WHERE Opportunity__c in :oppIDs ])   
    {
        if( !extantJoins.containsKey( oJoin.Opportunity__c + '_' + oJoin.Account__c  ) )
            extantJoins.put(oJoin.Opportunity__c + '_' + oJoin.Account__c, oJoin);      
    }

    OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];
    set<nrOpportunity_Account__c> deletes = new set<nrOpportunity_Account__c>();
    list<OpportunitySplit> newSplits = new list<OpportunitySplit>();
    for( nrOpportunity_Account__c oJoin : trigger.new )
    {
        //stick any duplicate joins into the delete list
        if( extantJoins.containsKey(oJoin.Opportunity__c + '_' + oJoin.Account__c) )
        {
            deletes.add(extantJoins.get(oJoin.Opportunity__c + '_' + oJoin.Account__c) );
        }

        //pick up the opps that need to be updated for chain account        
        if( accountMap.get(oJoin.Account__c).Chain_Account__c 
        && !opportunityUpdateIDs.contains( oJoin.Opportunity__c) )
        {
            opportunityUpdateIDs.add( oJoin.Opportunity__c);
        } else 
        {  
        }   

        //if the salesteam for this opportunity doesn't have this account's owner, add it       
        if( !oppTeams.containsKey(  oJoin.Opportunity__c + '_' + accountMap.get(oJoin.Account__c).OwnerId ) )
        {
            
            /* 2014-12-18 - we no longer want to add the account's owner to the project */
            /* 2015-03-05 - we changed our mind again */
            OpportunitySplit split = new OpportunitySplit();
            split.OpportunityId = oJoin.Opportunity__c;
            split.SplitOwnerId = accountMap.get(oJoin.Account__c).OwnerId;
            split.SplitTypeId = splittype.Id;
            
            newSplits.add(split);
            /**/ 
            
        }
        
    }
    

    
    // if there were any opportunities picked up for "chain account" updates, do the do
    list<Opportunity> opportunityUpdates = new List<Opportunity>();
    if( opportunityUpdateIDs.size() > 0 )
    {
        for( Opportunity o : [SELECT id, chain_account__c FROM Opportunity WHERE id in :opportunityUpdateIDs] )
        {
            o.Chain_account__c = true;
            opportunityUpdates.add( o );
        }
    }   
    if( oppsToFlagAsResidentialVertical.size() > 0 )
    {
        for( Opportunity o : [SELECT id, chain_account__c FROM Opportunity WHERE id in :oppsToFlagAsResidentialVertical] )
        {
            o.Residential_Vertical__c = true;

            opportunityUpdates.add( o );
        }
    }   


//oppsToFlagAsResidentialVertical
    //do the updates etc
    
    if ( deletes.size() > 0 )
    {
        list<nrOpportunity_Account__c> deletelist = new list<nrOpportunity_Account__c>(deletes);
        delete deletelist;
    }
        
    if( opportunityUpdates.size() > 0 )
        update opportunityUpdates;
    
    if( newSplits.size() > 0 )
        insert newSplits;   
}