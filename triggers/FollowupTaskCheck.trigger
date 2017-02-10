trigger FollowupTaskCheck on Task (after insert, after update) {
    /*
    trigger purpose
        If a Quote Rep Followup or Quote Office Followup task is set to completed, Followup_Status__c is set to reviewed and followup is set to true
        
        if a Quote Link Clicked: View, or a CAD Link Clicked, or a Quote CAD Email Opened task is created/updated, CAD_Viewed is set to true
        
         there is also a task update that, reading through it, i think won't ever actually run.  
    */  
    
    
    //prefetch the data for the trigger
    set<Id> quotesToFetch = new set<Id>();
    set<Id> taskquotesToFetch = new set<Id>();
    for( Task t : trigger.new )
    {
        if(!TriggerVariables.TaskMap_All.containsKey(t.Id))
            TriggerVariables.TaskMap_All.put(t.Id, t );
            
        if( t.WhatId != null && t.WhatId != null && !taskquotesToFetch.contains(t.WhatId) 
        && !TriggerVariables.Quote_To_TaskMap.containsKey(t.WhatId) )
        { 
            taskquotesToFetch.add( t.WhatId );
        }
            
        /*NB: if you add another subject line to pick up, you need to put it in here to make sure the quote gets looked up */
        if(
        (t.Subject=='Quote Rep Followup' || t.Subject=='Quote Office Followup'
        || t.Subject=='Quote Link Clicked: View'
        || t.Subject =='CAD Link Clicked' )
        && !TriggerVariables.QuoteMap_All.containsKey(t.WhatId) 
        && !quotesToFetch.contains(t.WhatId) )
        {
            quotesToFetch.add(t.WhatId);
        }
    }
    
    for( Quote__c q : TriggerVariables.GetQuotesByIdList(new List<Id>(quotesToFetch) ))
    { //now we put all the quotes int he static trigger map -- this way any other triggers that need them wont have to use up a DML call
        TriggerVariables.QuoteMap_All.put( q.id, q );
    }

    //pull out all the tasks we might need for these quotes 
    for( Task t :TriggerVariables.GetTasksFromQuoteIdList(new List<Id>(taskquotesToFetch) ) )
    {
        if(!TriggerVariables.Quote_To_TaskMap.containsKey(t.WhatId) )
            TriggerVariables.Quote_To_TaskMap.put( t.WhatId, new list<Task>() );

        TriggerVariables.Quote_To_TaskMap.get(t.WhatId).add( t ); //add the task to the list of quotes in this map 

        
        if( !TriggerVariables.TaskMap_All.containsKey(t.id) )
        { //if the task in question is not in the global "cache" put it there
            TriggerVariables.TaskMap_All.put( t.id, t);
        }
        
    }
        
    
    //end prefetching data
    
    string linenbr='start';
    try
    {
        
        List<Quote__c> up  = new List<Quote__c>();
        Map<ID,Task> qid = new Map<ID,Task>();
        Map<ID,Task> cqid = new Map<ID,Task>();
        linenbr ='checking followup tasks 1';
        for (Task t2 : trigger.new ) 
        {
            
system.debug( t2.Id + ' ; ' + t2.Status + '; ' + t2.Subject );          
            if ((t2.Subject=='Quote Rep Followup' ||t2.Subject=='Quote Office Followup') 
                && t2.Status=='Completed')
            { 
                try {
                
                    Task oldtask = (Task)trigger.oldMap.get(t2.Id);
system.debug('it is completed');                    
                    if (oldtask.Status != 'Completed')
                    { 
system.debug('it was not completed before though!');                        
                        if (!qid.containsKey(t2.WhatID))
                        {
                            qid.put(t2.WhatID,null);
                        }
                    }
                } catch( Exception ex ) {}
                
            }
            linenbr = '1a';
            if ( (t2.Subject=='Quote Link Clicked: View') )
            {
                qid.put(t2.WhatID,null);
            }
            linenbr = '1b';         
            if (t2.Subject =='CAD Link Clicked' || String.valueOf(t2.Subject).contains('Quote CAD Email Opened'))
            {
                cqid.put(t2.WhatID,null);
                
            }
        }
        linenbr='setting quotes to reviewed';
        
        map<id, Quote__c> quotesToUpdate = new map<id, Quote__c>();
        if (!cqid.isEmpty())
        {
            for( Quote__c q : TriggerVariables.GetQuotesByIdList( new list<Id>(qid.keySet()) ) )
//          for( Id i : cqid.keySet() )
            {
                /*
                Quote__c q = null;
                if( quotesToUpdate.containsKey(i) )
                    q = quotesToUpdate.get( i);
                else if( TriggerVariables.QuoteMap_All.containsKey(i) )
                    q = TriggerVariables.QuoteMap_All.get(i );
*/
                if( q != null )
                {
                    q.CAD_Viewed__c = true;
                    quotesToUpdate.put( q.Id, q ); //store it back in .. just in case
                }
                    
            }
        }
        if (!qid.isEmpty())
        {
//          for( Id i : qid.keySet() )
            for( Quote__c q : TriggerVariables.GetQuotesByIdList( new list<Id>(qid.keySet()) ) )
            {
                /*
                Quote__c q = null;
                if( quotesToUpdate.containsKey(i) )
                    q = quotesToUpdate.get( i);
                else if( TriggerVariables.QuoteMap_All.containsKey(i) )
                    q = TriggerVariables.QuoteMap_All.get(i );
*/
                if( q != null )
                {
                    q.Followup_Status__c = 'Reviewed';
                    q.Followup__c = true;
                    quotesToUpdate.put( q.Id, q ); //store it back in .. just in case
                }
            }           
        
            linenbr='closing tasks';
            List<Task> tl = new List<Task>();
            
            for( Task masterTask : trigger.new )
            {
                if( masterTask.WhatId != null 
                    && TriggerVariables.Quote_To_TaskMap.containsKey(masterTask.WhatId) //we know its a quote if its in this map
                    && qid.containsKey( masterTask.WhatId ) //and its also a quote that is relevant to this logic
                )
                {
                    for( Task ta : TriggerVariables.Quote_To_TaskMap.get(masterTask.WhatId) )
                    { //look at all the other tasks associated with this quote
                        // if the task is associated with one of the qutoes we got that is closed, 
                        // and it has a relevant subejct line, mark it as complete
                        
                        if(  
                            ( ta.subject=='Quote Rep Followup'  || ta.subject=='Quote Office Followup') 
                            && ta.Status != 'Completed'
                        )
                        {
                            ta.status = 'Completed';
                            tl.add(ta);             
                        } else 
                        {
system.debug('skipping ' + ta.Id + '; ('+ta.subject+' ; '+ta.Status+')'  );
                        }
                    
                    }
                }
            }
            
            if( tl.size() > 0 )
            {
                System.debug('update ' + tl.size() + ' tasks that need to be closed');
                update tl;
            }
        }
        if( quotesToUpdate.size() > 0 )
            update quotesToUpdate.values();
    }
    catch (Exception ex)
    {
        utility.jimdebug(ex,'followup task check trigger ' + linenbr);
    }
}