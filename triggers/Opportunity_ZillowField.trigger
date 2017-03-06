trigger Opportunity_ZillowField on Opportunity (after insert, after update) {

    /*
    trigger purpose 
        performs callouts for setting zillow fields on projects
    */

    try {
        set<id> ids = new set<id>();
        for( Opportunity o : trigger.new ) 
        {
            if( trigger.isInsert )
            {
                ids.add( o.id );    
            } else if( trigger.isUpdate )
            {
                Opportunity oldopp = trigger.oldMap.get( o.id );
                if(  o.Site_Address__c != oldopp.Site_Address__c
                || o.city__c != oldopp.City__c 
                || o.Postal_Code__c != oldopp.Postal_code__c    )
                {
                    ids.add( o.id );
                }
            }
        }
        
        if( ids.size() > 0 )
        {
            System.debug('calling setzestimateamount for '+ids.size() +' opportunities.');
            
            Opportunity_UtilityClass.SetZestimateAmount( new list<id>( ids) );
        }
    } catch( Exception e ) {}
}