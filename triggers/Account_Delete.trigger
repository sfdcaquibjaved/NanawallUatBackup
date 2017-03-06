trigger Account_Delete on Account (before delete, after delete) {

    //calls to nana to signal a precache flush is needed
    
    set<id> accountsToFlush = new set<Id>();
    
    if( Trigger.isAfter )
    {
    
    } else
    { //trigger.isBefore
    
        for( Account a : trigger.old )
        {
            if( !accountsToFlush.contains(a.Id) )
                accountsToFlush.add( a.id );
            
        }
    }
    
    if(accountsToFlush.size() > 0  )
        Async_WebServiceCaller.FlushNanaCache(accountsToFlush, 'Account');
    


}