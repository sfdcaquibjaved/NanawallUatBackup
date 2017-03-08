trigger Quote_PostSave on Quote__c (after insert, after update) {

    /*
    trigger purpose
        flags opportunites as CAD viewed when their quotes are CAD viewed; sends a flush call to nana;  
        
        kicks off final invoice emails
        
        
        we also need to update the adjustd quote count field on the opportunity 
    */

    // *** load up all necessary data for the trigger
    /*
    if( !TriggerVariables.Quote_PostSave_DataLoaded )
    {
        
        list<Id> oppsToFetch = new List<Id>();
        list<id> oppQuotesToFetch = new list<id>();
        

        for( Quote__c q : trigger.new )
        {
            if( !TriggerVariables.OpportunityMap_All.containsKey(q.Opportunity__c) )
            {
                oppsToFetch.add(q.Opportunity__c);
            }
                        
            if( !TriggerVariables.Opportunity_To_QuoteList.containsKey(q.Opportunity__c) )
            {
                oppQuotesToFetch.add(q.Opportunity__c);
            }
        }
        if( oppsToFetch.size() > 0 )
        {
            for( Opportunity o : TriggerVariables.GetOpportunitiesFromIdList(oppsToFetch) )
                TriggerVariables.OpportunityMap_All.put(o.Id, o);
        }   
        
        if(oppQuotesToFetch.size() > 0 )
        {
            for(Quote__c q : TriggerVariables.GetQuotesByOpportunityIdList(oppQuotesToFetch) )
            {
                if( !TriggerVariables.Opportunity_To_QuoteList.containsKey(q.Opportunity__c) )
                    TriggerVariables.Opportunity_To_QuoteList.put( q.Opportunity__c, new List<Id>() );
                
                TriggerVariables.Opportunity_To_QuoteList.get(q.Opportunity__c).add( q.Id );
                
                if( !TriggerVariables.QuoteMap_All.containsKey(q.Id) )
                {
                    TriggerVariables.QuoteMap_All.put( q.id, q );
                }
            }
        }

        //now make sure the "after" variables are the ones in the quote map; this avoids looking uyp stale date in the DB
        for( Quote__c q : trigger.new )
            TriggerVariables.QuoteMap_All.put( q.id, q);
        
            
        TriggerVariables.Quote_PostSave_DataLoaded = true;
    }
    //*** end loading necessary data    


    if( trigger.isUpdate )
    {
        list<string> QuoteNumbersToSendFinalInvoices = new list<string>();
        try 
        {
            list<id> ProjIdsToUpdateWithCAD = new list<Id>();
            set<Id> OppsToRecalc = new set<Id>();
            for( Quote__c q : trigger.new )
            {
                
                if( !OppsToRecalc.contains(q.Opportunity__c ) )
                    OppsToRecalc.add(q.Opportunity__c);
                
                
                if( q.CAD_Viewed__c != null && q.CAD_Viewed__c != trigger.oldMap.get(q.id).CAD_Viewed__c )
                {
                    ProjIdsToUpdateWithCAD.add( q.Opportunity__c );
                }
                if( q.Final_Invoice_Amount__c != null && q.Final_Invoice_Amount__c > 0
                && (trigger.oldMap.get(q.id).Final_Invoice_Amount__c == null || trigger.oldMap.get(q.id).Final_Invoice_Amount__c < 1  )   )
                {
                    QuoteNumbersToSendFinalInvoices.add(q.Name);
                }
            }
            
            map<Id, Opportunity> opportunitiesToUpdate = new map<Id, Opportunity>();
            
            for( id OppID :OppsToRecalc )
            {
            
                integer adjustedQuoteCount = 0;
system.debug('checking quotes for opportunity ' + OppId + ': ' + TriggerVariables.Opportunity_To_QuoteList.get(OppID).size() );
                for( Id qId  : TriggerVariables.Opportunity_To_QuoteList.get(OppID) )
                {
                    Quote__c q = TriggerVariables.QuoteMap_All.get(qId);
                    if( q.SubTotal__c > 0 )
                    {
                        adjustedQuoteCount++;
                    }
                    
                }
                
                //we do it this way so we can group together all of our updates and make sure we dont overwrite somethign
                Opportunity o =null;
                if( opportunitiesToUpdate.containsKey(OppId) )      
                    o = opportunitiesToUpdate.get(OppId);
                else o = TriggerVariables.OpportunityMap_All.get(OppId);
                
                o.Adjusted_Quote_Count__c = adjustedQuoteCount;
                opportunitiesToUpdate.put( o.Id, o );
            }
            
//          list<Opportunity> oppsToUpdate = new List<Opportunity>();
            Set<id> oppIdLookup = new Set<id>(ProjIdsToUpdateWithCAD);
            //for( Opportunity o : [SELECT id, CAD_Viewed__c FROM Opportunity WHERE id in :oppIdLookup] )
            for( string id : oppIdLookup )
            {
                
                //we do it this way so we can group together all of our updates and make sure we dont overwrite somethign
                Opportunity o =null;
                if( opportunitiesToUpdate.containsKey(Id) )     
                    o = opportunitiesToUpdate.get(Id);
                else o = TriggerVariables.OpportunityMap_All.get(Id);           
//              Opportunity o = TriggerVariables.OpportunityMap_All.get(Id);

                o.CAD_Viewed__c = true;
                
                opportunitiesToUpdate.put( o.id, o );
            }
            
            
            if( opportunitiesToUpdate.keySet().size() > 0 )
                update opportunitiesToUpdate.values();
                
        } catch( Exception ex )
        {
            System.debug('Got an exception when propagating the CAD View flag to the project level ' + ex);
        }
        
        
        set<id> quoteIdsToFlush = new Set<id>();
        for( Quote__c q : trigger.new )
        {
            if( 
                trigger.oldmap != null
                && trigger.oldmap.get(q.id) != null
                && trigger.oldmap.get(q.id).Contact__c != null
                && q.Contact__c != null
                && q.Contact__c != trigger.oldmap.get(q.id).Contact__c 
                ) 
            {
                quoteIdsToFlush.add( q.id );
            } else if( 
                trigger.oldmap != null
                && trigger.oldmap.get(q.id) != null
                && trigger.oldmap.get(q.id).Opportunity__c != null
                && q.Opportunity__c != null
                && q.Opportunity__c != trigger.oldmap.get(q.id).Opportunity__c          
            ) 
            {
System.debug('Quote_PostSave: Opportunity changes! ' );
                quoteIdsToFlush.add( q.id );
            }
        }
        
        Async_WebServiceCaller.FlushNanaCache(quoteIdsToFlush, 'Quote');
//      FlushNanaCache
System.debug('Quote_PostSave: quotesToFlush = ' + quoteIdsToFlush.size() );
        if( QuoteNumbersToSendFinalInvoices.size() > 0 )
        {
            Quote_SendFinalInvoice.SendBulkEmails(QuoteNumbersToSendFinalInvoices);
        }

                
    }

*/
}