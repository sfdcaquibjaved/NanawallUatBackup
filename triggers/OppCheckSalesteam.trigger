trigger OppCheckSalesteam on Opportunity (after insert, after update) {
    
    /*
        trigger purpose 
            Handles team member and share fixups when an opportunity owner changes
    */
    
    
    /*list<nrOpportunityTeamMember__c> inserts = new list<nrOpportunityTeamMember__c>();
    list<OpportunityShare> osInserts = new list<OpportunityShare>();

    if( trigger.isAfter )
    {
        if( trigger.isInsert )
        {
        } else {
            //make sure that the new owner is on the team
            for( integer i=0; i<trigger.old.size();i++)
            {
                if( trigger.old[i].OwnerId != trigger.new[i].OwnerId )
                {
/*                  
                    nrOpportunityTeamMember__c nrotm = new nrOpportunityTeamMember__c();
                    nrotm.opportunity__c = trigger.new[i].id;
                    nrotm.user__c = trigger.new[i].OwnerId;
                    nrotm.OpportunityAccessLevel__c = 'Owner';
                    inserts.add( nrotm );

                    OpportunityShare os = new OpportunityShare();
                    os.UserOrGroupId = trigger.old[i].OwnerId;
                    os.OpportunityId = trigger.new[i].id;       
                    os.OpportunityAccessLevel = 'Edit';
                    
                    osInserts.add(os);      
*/
               /* }
            }
        }
    }

    if( inserts.size() > 0 )
        insert inserts;
        
    if( osInserts.size() > 0 )
    {
        insert osInserts;
        
    }*/
}