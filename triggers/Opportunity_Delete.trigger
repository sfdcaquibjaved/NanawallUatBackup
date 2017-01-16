trigger Opportunity_Delete on Opportunity (after delete, before delete) {
    //calls to nana to signal a precache flush is needed
    
    set<id> oppsToFlush = new set<Id>();
    
    if( Trigger.isAfter )
    {
    
    } else
    { //trigger.isBefore
    
        for( Opportunity o : trigger.old )
        {
            if( !oppsToFlush.contains(o.Id) )
                oppsToFlush.add( o.id );
            
        }
    }
    
    if(oppsToFlush.size() > 0  )
        Async_WebServiceCaller.FlushNanaCache(oppsToFlush, 'Opportunity');

}