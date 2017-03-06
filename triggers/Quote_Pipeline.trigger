trigger Quote_Pipeline on Quote__c (before insert, before update, after update) {
    
    
    /*
    trigger purpose
        updates Most_Recently_Ordered_Account__c, Most_Recently_Ordered_Contact__c for i2c realtime scoring (quite a lot of code just for that); 
        
        creates performance label tasks; triggers contacts on opportunities to update their quote counts for I2C scoring (cascading code);
    */
    
    // *** load up all necessary data for the trigger
    /*
    if( !TriggerVariables.Quote_Pipeline_DataLoaded )
    { 
        list<Id> oppsToFetch = new List<Id>();
        list<Id> contactsToFetch = new List<Id>();
        list<id> oppContsToFetch = new list<Id>();
        list<id> oppQuotesToFetch = new list<id>();
        list<id> accountsToFetch = new list<Id>();
        
        for( Quote__c q : trigger.new )
        {
            if( !TriggerVariables.OpportunityMap_All.containsKey(q.Opportunity__c) )
            {
                oppsToFetch.add(q.Opportunity__c);
            }
            
            if( !TriggerVariables.ContactMap_All.containsKey(q.Contact__c) )
            {
                contactsToFetch.add( q.Contact__c);
            }
            
            if(!TriggerVariables.Opportunity_To_ContactList.containsKey(q.Opportunity__c) )
            {
                oppContsToFetch.add(q.Opportunity__c);
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
        if(oppContsToFetch.size() > 0 )
        {
            for(nrOpportunityContactRole__c ocr : TriggerVariables.GetnrOpportunityContactRolesByOpportunityIdList(oppContsToFetch) )
            {
                if( !TriggerVariables.Opportunity_To_ContactList.containsKey(ocr.Opportunity__c) )
                    TriggerVariables.Opportunity_To_ContactList.put( ocr.Opportunity__c, new List<Id>() );
                
                TriggerVariables.Opportunity_To_ContactList.get(ocr.Opportunity__c).add( ocr.Contact__c);
                
                if( !TriggerVariables.ContactMap_All.containsKey(ocr.Contact__c) )
                {
                    contactsToFetch.add( ocr.Contact__c); //make sure this data is in the static map
                }
                
            }
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
            
        if( contactsToFetch.size() > 0 )
        {
            for( Contact c : TriggerVariables.GetContactsFromIdList(contactsToFetch) )
                TriggerVariables.ContactMap_All.put( c.Id, c );
        }        
        for( Quote__c q : trigger.new )
        {
            
            if( q.Contact__c != null 
            && TriggerVariables.ContactMap_All.get(q.Contact__c) != null
            && !TriggerVariables.AccountMap_All.containsKey(TriggerVariables.ContactMap_All.get(q.Contact__c).AccountID ) )
            {
                accountsToFetch.add(TriggerVariables.ContactMap_All.get(q.Contact__c).AccountID);
            }
        }
        
        if(accountsToFetch.size() > 0  )
        {
            for( Account a : TriggerVariables.GetAccountsFromIdList(accountsToFetch))
            {
                TriggerVariables.AccountMap_All.put( a.Id, a );
            }
        }
        
        //now make sure the "after" variables are the ones in the quote map; this avoids looking uyp stale date in the DB
        for( Quote__c q : trigger.new )
            TriggerVariables.QuoteMap_All.put( q.id, q);
        
        TriggerVariables.Quote_Pipeline_DataLoaded = true;
    }
    //*** end loading necessary data    
    
    list<Opportunity> oppsToUpdate = new List<Opportunity>();
    
    //switch this to an aggregate, after update call
    if( trigger.isUpdate && trigger.isAfter )
    {
        list<Task> newTasks = new list<Task>();     
        Set<Id> quotesToLookupForPerformanceLabelTasks = new Set<Id>();
        map<Id, Account> AccountsToUpdate = new map<Id, Account>();
        
        Set<ID> contidsone=new Set<ID>();
        for (Quote__c q : trigger.new)
        {
            if( q.Ordered__c 
            && q.Order_Finalized_Date__c != null
            && trigger.oldmap.get(q.ID).Order_Finalized_Date__c == null )
            {   
                if( !contidsone.contains(q.contact__c))
                    contidsone.add(q.contact__c);       
            }
            if( q.Order_Finalized_Date__c != null
            && trigger.oldmap.get(q.ID).Order_Finalized_Date__c == null )
            {   
                    
                if( !quotesToLookupForPerformanceLabelTasks.contains(q.id) )
                {
                    Utility.JimDebug(null,'quote pipeline ' + q.id);
                    quotesToLookupForPerformanceLabelTasks.add(q.id);
                }
            }
            
            if( q.Order_Finalized_Date__c != trigger.oldMap.get(q.Id).Order_Finalized_Date__c )
            { 
                
                //detect whether we need to increment/decrement the account.order_count field
                if( q.Contact__c != null )
                {
                    
                    Account updateAcc = TriggerVariables.AccountMap_All.get( TriggerVariables.ContactMap_All.get(q.Contact__c).AccountID );
                    if( !AccountsToUpdate.containsKey(updateAcc.Id) )
                    { 
                        if(updateAcc.Order_Count__c == null )
                            updateAcc.Order_Count__c = 0;
                        AccountsToUpdate.put( updateAcc.Id, updateAcc );
//system.debug('updating ' + updateAcc.Id );                        
                    }
                    
//system.debug('update account order count for ' + AccountsToUpdate.get(updateAcc.Id) + ' ; ' + AccountsToUpdate.get(updateAcc.Id).Id  );                   
                    
                }               
                // end the account.order_count increment/decrement
                
                
                
                //the order finalized date changed, make sure the opportunity's most recent contacts and accounts are correct by looking at the whole quote list
                Opportunity o = TriggerVariables.OpportunityMap_All.get( q.Opportunity__c);
                
                Id mostRecentlyOrderedContact = null;
                Id mostRecentlyOrderedAccount = null;
                Date mostRecentDate = null;
                
                for( Id QuoteId : TriggerVariables.Opportunity_To_QuoteList.get(q.Opportunity__c) )
                { //spin over each quote on an opportunity looking for the most recently ordered 
                    Quote__c q2 = TriggerVariables.QuoteMap_All.get( QuoteId );
                    if( mostRecentDate == null || q2.Order_Finalized_Date__c > mostRecentDate )
                    {
                        mostRecentDate = q2.Order_Finalized_Date__c;
                        
                        mostRecentlyOrderedAccount = mostRecentlyOrderedContact = null;
                        
                        if( q2.Order_Finalized_Date__c != null )
                        {
                            Contact c = TriggerVariables.ContactMap_All.get( q2.Contact__c );
                            if( c != null )
                            {                           
                                mostRecentlyOrderedContact = c.Id;
                                mostRecentlyOrderedAccount = c.AccountId;
                            }
                        }
                    }
                }
                
                o.Most_Recently_Ordered_Account__c  = mostRecentlyOrderedAccount;
                o.Most_Recently_Ordered_Contact__c  = mostRecentlyOrderedContact;
                oppsToUpdate.add( o );  
            }
            
        }

//Most Recently Ordered Account
//Most Recently Ordered Contact
        
        for( Quote_Detail__c qd : [SELECT id, Quote__c,UValue__c, SHGC__c, Units__c  FROM Quote_Detail__c WHERE Quote__c in :quotesToLookupForPerformanceLabelTasks] )
        {
            if( qd.UValue__c != null && qd.UValue__c != 0 
            && qd.SHGC__c != null && qd.SHGC__c != 0 )
            {
            
                for( integer i = 0; i< qd.Units__c; i++ )
                {
                    Task tsk = new Task();
                    tsk.WhatId = qd.id;
        //          tsk.WhoId = '005A0000000MOJS';
                    if( GlobalStrings.NanaServerAddress().contains('nanareps'))
                        tsk.OwnerId = '005A0000000NAYj';
                    else tsk.OwnerID = '005A0000000M8pi';
                    tsk.Subject = 'Performance Label';
                    tsk.Description = 'Unit_'+(i+1);
                    newTasks.add( tsk); 
                
                }

            }
        }
        
        if( newTasks.size() > 0 )
            insert newTasks;
            


        if(AccountsToUpdate.size() > 0 )
        {
            
            for( Id i : AccountsToUpdate.keySet() )
            {
                AccountsToUpdate.get(i).Order_Count__c = 0;
            }

            for( Quote__c q : [SELECT Id, Contact__c, Contact__r.AccountID FROM Quote__c WHERE Order_Finalized_Date__c != NULL AND (Contact__r.AccountID = :AccountsToUpdate.keySet() OR Id = :trigger.newMap.keySet() ) ] )
            {

                if( AccountsToUpdate.containsKey(q.Contact__r.AccountID) )
                {
                    AccountsToUpdate.get(q.Contact__r.AccountID).Order_Count__c++;                   
                }
            }
            
            for( Id i : AccountsToUpdate.keySet() )
            {
                
                AccountsToUpdate.get(i).Order_Count_String__c = String.valueOf(AccountsToUpdate.get(i).Order_Count__c);
            }

            

            update AccountsToUpdate.values();
        }


        if( contidsone.size() > 0 )
        {
            list<Contact> conts = Quote_Utility.GetQuoteCountContactUpdates(contidsone);
            if( conts.size() > 0 )
            {
                SYstem.debug('updating '+ conts.size() + ' contacts in the Quote.Pipeline trigger');
                update conts;
            
            }
        }
    }
    
    if(oppsToUpdate.size() > 0 )
        update oppsToUpdate;    
        */

}