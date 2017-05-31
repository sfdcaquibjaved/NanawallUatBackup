trigger Quote_Delete on Quote__c (after delete, before delete) {
/*
    trigger purpose
        flags opportunites as CAD viewed when their quotes are CAD viewed; sends a flush call to nana;  
        
        kicks off final invoice emails
        
        
        we also need to update the adjustd quote count field on the opportunity 
    */

    // *** load up all necessary data for the trigger
    if( !TriggerVariables.Quote_Delete_DataLoaded )
    {
        
        list<Id> oppsToFetch = new List<Id>();
        list<id> oppQuotesToFetch = new list<id>();
        

        for( Quote__c q : trigger.old )
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
        for( Quote__c q : trigger.old )
            TriggerVariables.QuoteMap_All.put( q.id, q); 
            
        
            
        TriggerVariables.Quote_Delete_DataLoaded = true;
    }
    //*** end loading necessary data    


    if( trigger.isAfter )
    {

        try 
        {
            set<Id> OppsToRecalc = new set<Id>();
            set<Id> deletingQuotes = new set<id>();
            for( Quote__c q : trigger.old )
            {
                deletingQuotes.add(q.Id);
                
                if( !OppsToRecalc.contains(q.Opportunity__c ) )
                    OppsToRecalc.add(q.Opportunity__c);
                
            }
            
            map<Id, Opportunity> opportunitiesToUpdate = new map<Id, Opportunity>();
            
            for( id OppID :OppsToRecalc )
            {
            
                integer adjustedQuoteCount = 0;
				system.debug('Opportunity ' + OppId + ' has ' + TriggerVariables.Opportunity_To_QuoteList.get(OppID).size() + ' total quotes to check');
                for( Id qId  : TriggerVariables.Opportunity_To_QuoteList.get(OppID) )
                {
                    if( deletingQuotes.contains(qId) )
                        continue;
                        
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
            
            if( opportunitiesToUpdate.keySet().size() > 0 )
                update opportunitiesToUpdate.values();
                
        } catch( Exception ex )
        {
            System.debug('Got an exception when deleting a quote ' + ex);
        }
        
    
                
    }

}