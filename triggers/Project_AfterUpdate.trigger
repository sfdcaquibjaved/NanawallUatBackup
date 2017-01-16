trigger Project_AfterUpdate on Opportunity (after update) {

/*
    trigger purpose
        flags contacts as "repeat customer"  and "ordering customer" when relevant project data changes
*/

/*
when the max_finalized_date__c on a project goes from nothing to something all the contacts on the project need to be flagged as a repeat customer
which means we also have to go back and update all the old data
*/

    /*list<id> contactRepeatOppIDs = new List<id>();
    list<id> contactOrderingOppIDs = new List<id>();
    map<Id, list<nrOpportunity_Account__c>> oppAccWonMap = new map<Id, list<nrOpportunity_Account__c>>();

    
    for( integer i=0;i<trigger.new.size(); i++ )
    {
        if( trigger.old[i].Max_Finalized_Date__c 
        !=  trigger.new[i].Max_Finalized_Date__c  )
        {
            contactRepeatOppIDs.add(trigger.new[i].id);
        }
        

        if( trigger.old[i].IsWon != trigger.new[i].IsWon 
        || trigger.old[i].IsClosed != trigger.new[i].IsClosed  )
        {
            oppAccWonMap.put( trigger.new[i].Id, new list<nrOpportunity_Account__c>() );
        }

    }
    
    if( oppAccWonMap.keySet().size() > 0 )
    {
        for(nrOpportunity_Account__c oppacc : [SELECT Id, Opportunity__c, Is_Won__c, Is_Closed__c FROM nrOpportunity_Account__c WHERE Opportunity__c = :oppAccWonMap.keySet() ] )
        {
            oppacc.Is_Won__c = trigger.newmap.get(oppacc.Opportunity__c).IsWon;
            oppacc.Is_Closed__c = trigger.newmap.get(oppacc.Opportunity__c).IsClosed;
            oppAccWonMap.get(oppacc.Opportunity__c).add( oppacc );
        }
    }
    
    set<Contact> updateConts = new set<Contact>();
    if (contactRepeatOppIDs.size()==0)
    {
        //return;
    } else {
    
        for( Contact c : [SELECT id FROM Contact WHERE id in ( Select Contact__c  FROM nrOpportunityContactRole__c WHERE Opportunity__c in :contactRepeatOppIDs and Role__c != 'Contractor' and Role__c != 'Glazing Contractor' and Role__c != 'Door Distributor' and Role__c != 'Lumberyard Dealer') ] )
        {
            c.Repeat_Customer__c = true;
            if( !updateConts.contains( c ) )
                updateConts.add( c );
        } 
        for (Contact c2 : [select id from contact where id in (select contact__c from quote__c where opportunity__c in  :contactRepeatOppIDs and ordered__c  = true )])
        {
            c2.Repeat_Customer__c= true;
            if (!updateConts.contains(c2))
                updateConts.add(c2);
        }
    
    }   
    if (contactOrderingOppIDs.size()==0)
    {
        //return;
    } else {
    
        for( Contact c : [SELECT id FROM Contact WHERE id in ( Select Contact__c  FROM nrOpportunityContactRole__c WHERE Opportunity__c in :contactOrderingOppIDs) ] )
        {
            c.Ordering_Customer__c = true;
            if( !updateConts.contains( c ) )
                updateConts.add( c );
        }
    
    }   
    
    
    //update lists
    if( oppAccWonMap.values().size() > 0 )
    {
        list<nrOpportunity_Account__c> oppaccs = new list<nrOpportunity_Account__c>();
        for( list<nrOpportunity_Account__c> templist : oppAccWonMap.values() )
        {
            oppaccs.addAll( tempList);
        }
    
        if( oppaccs.size() > 0 )
        {
            try
            {
                update oppaccs;
            } catch( Exception ex )
            {
                if( oppaccs.size() < 20 )
                { //if we are only trying to update a few, see if i we can update whatever we have got -- there are permissions problems when someone tries to update an oppacc they dont own that was automatically added by triggers with shared projects
                    for( nrOpportunity_Account__c oa : oppaccs )
                    {
                        try
                        {
                            update oa;
                        } catch( exception ex2 )
                        {
                        }
                    }
                }
            }
        }
    }
    
    if( updateConts.size() > 0 )
    {
        try
        {
            list<contact> updateList = new List<Contact>( updateConts );
            update updateList;
        } catch( Exception ex )
        {
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
            mail.setToAddresses( toAddresses );
            mail.setReplyTo('admin@a-stechnologies.com');   
            mail.setSenderDisplayName('Salesforce - Project_AfterUpdate trigger');
            mail.setSubject('Got an exception with Project_AfterUpdate trigger' );
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('Got an exception with Project_AfterUpdate trigger: ' + ex  );
            mail.setHtmlBody('Got an exception with Project_AfterUpdate trigger: ' + ex  );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                   
        }
    }*/
}