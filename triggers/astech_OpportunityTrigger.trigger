trigger astech_OpportunityTrigger on Opportunity (after update) {
    //calls to nana to signal a precache flush is needed
    
    set<id> oppsToFlush = new set<Id>();
    
    if( Trigger.isAfter )
    {
    
        for( Opportunity o : trigger.new )
        {
            
            if(   o.Project_Name__c != trigger.oldMap.get(o.Id).Project_Name__c  
                && !oppsToFlush.contains(o.Id)  )
                {
                    oppsToFlush.add( o.id );
                }
        }
    }
    
    if(oppsToFlush.size() > 0  )
        Async_WebServiceCaller.FlushNanaCache(oppsToFlush, 'Opportunity');

}