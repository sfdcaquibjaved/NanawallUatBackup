trigger Task_Insert on Task (after insert, before insert) 
{
    /*
    trigger purpose
        handles various field updates related to Photobook and Booklet tasks
        According to aziz, the Prefixes / Selections should be overwritten with each new task, not appended 
    */
    list<Contact> contactsToUpdate = new List<Contact>();
    list<Lead> leadsToUpdate = new List<Lead>();


    if( trigger.isAfter && trigger.isInsert )
    {
        set<Id> idsToFetch = new Set<Id>();
        for( Task t : trigger.new )
        {//first find all the contacts and leads who need to be looked up
            if( 
                ( 
                    t.Subject == 'Send Booklet'
                    &&  t.PhotoBooks_Selection__c != null 
                    && t.PhotoBooks_Selection__c != '' 
                    && t.WhoId != null 
                )
                || ( (t.Subject == 'send binder' || t.Subject == 'Send Binder') && t.WhoId != null )
            ) {
                if( !idsToFetch.contains(t.WhoId) ) 
                {
                    if( !TriggerVariables.ContactMap_All.containsKey(t.WhoId) 
                    && !TriggerVariables.LeadMap_All.containsKey(t.WhoId) )
                        idsToFetch.add( t.WhoId );
                }

            }
        }
        
        for(Contact c : TriggerVariables.GetContactsFromIdList(new list<Id>(idsToFetch)) )
        {
            TriggerVariables.ContactMap_All.put(c.Id, c); //if we are in this loop that shoudl mean we didnt find the contact in the global map. put it there   
        }
        
        for(Lead l : TriggerVariables.GetLeadsFromIdList(new list<Id>(idsToFetch))  )
        {
            TriggerVariables.LeadMap_All.put(l.Id, l); //if we are in this loop that shoudl mean we didnt find the contact in the global map. put it there  
        }
        
        for( Task t : trigger.new )
        { //now go back over them and update their values
            if( t.Subject == 'Send Booklet'
                && t.PhotoBooks_Selection__c != null 
                && t.PhotoBooks_Selection__c != '' 
                && t.WhoId != null  )
            {//we are specificaly interested in making sure the contact and lead have thie photobook selections and booklet dates syncd up from eloqua
                if(TriggerVariables.ContactMap_All.containsKey(t.WhoId)  )
                {
                    Contact c = TriggerVariables.ContactMap_All.get(t.WhoId);
                    c.Last_Booklet_Sent__c = Date.today();
                    c.Photo_Book_Selections__c = t.PhotoBooks_Selection__c;
                    contactsToUpdate.add(c);
                } else if( TriggerVariables.LeadMap_All.containsKey(t.WhoId) )
                {
                    Lead l = TriggerVariables.LeadMap_All.get(t.WhoId);
                    l.Last_Booklet_Sent__c = Date.today();
                    l.Photo_Book_selections__c = t.PhotoBooks_Selection__c;
                    leadsToUpdate.add(l);
                }
            } else if ( ((t.Subject == 'send binder' || t.Subject == 'Send Binder') && t.WhoId != null ) )
            {
                if(TriggerVariables.ContactMap_All.containsKey(t.WhoId)  )
                {
                    /*
                    Contact c = TriggerVariables.ContactMap_All.get(t.WhoId);
                    //c.Send_Binder__c = true;
                    if(t.PhotoBooks_Selection__c != null 
                    && t.PhotoBooks_Selection__c != '' )    
                        c.Photo_Book_Selections__c = t.PhotoBooks_Selection__c;
                    else c.Photo_Book_Selections__c = '';
                        
                    
                    c.Photo_Book_Selections__c += ( c.Photo_Book_Selections__c != null ? c.Photo_Book_Selections__c + ';' : '' ) + 'Binder';
                        */
                    Contact c = TriggerVariables.ContactMap_All.get(t.WhoId);
                    c.Photo_Book_Selections__c = ( t.PhotoBooks_Selection__c != null ? t.PhotoBooks_Selection__c + ';' : '' ) + 'Binder';
                    contactsToUpdate.add(c);
                    
                } else if( TriggerVariables.LeadMap_All.containsKey(t.WhoId) )
                {
                    /*
                    Lead l = TriggerVariables.LeadMap_All.get(t.WhoId);
                    if(t.PhotoBooks_Selection__c != null 
                    && t.PhotoBooks_Selection__c != '' )    
                        l.Photo_Book_selections__c = t.PhotoBooks_Selection__c;
                        
                    l.Photo_Book_Selections__c = ( l.Photo_Book_Selections__c != null ? l.Photo_Book_Selections__c + ';' : '' ) + 'Binder';
*/
                    Lead l = TriggerVariables.LeadMap_All.get(t.WhoId);
                    l.Photo_Book_Selections__c = ( t.PhotoBooks_Selection__c != null ? t.PhotoBooks_Selection__c + ';' : '' ) + 'Binder';
                    leadsToUpdate.add(l);
                }
                
            }
        }

    } else if ( trigger.isBefore && trigger.isInsert )
    {
        
    }
    
    
    if( contactsToUpdate.size() > 0 )
    {
        update contactsToUpdate;
    }

    if( leadsToUpdate.size() > 0 )
    { 
        update leadsToUpdate;
    }

}