trigger Account_PreUpdate on Account (after insert, before update) {

    //this trigger flags opportunities as a chain account when one of its accounts is flagged as a chain account
    
    if( trigger.isInsert )
    {
        
    } else if( trigger.isUpdate )
    {
    
        list<id> accIds = new list<id>();   
    
        for( Account a : trigger.new )
        {
            Account beforeUpdate = System.Trigger.oldMap.get(a.Id);
    
            if( a.Chain_Account__c && !beforeUpdate.Chain_Account__c )
                accIds.add( a.id ); 
        }
        
        if( accIds.size() > 0 )
        {
            try {
                list<id> oppIds = new list<id>();
                for( nrOpportunity_Account__c oa :  [SELECT Opportunity__c FROM nrOpportunity_account__c WHERE Account__c in :accIds ] )
                    oppIds.add( oa.Opportunity__c); 
                    
                list<Opportunity> opps = [SELECT id, Chain_Account__c FROM Opportunity WHERE id in :oppIds  ];
                for( Opportunity o : opps )
                    o.Chain_Account__c = true;
                    
                update opps;
            } catch( Exception ex ) 
            {
            }
        }

    }
}