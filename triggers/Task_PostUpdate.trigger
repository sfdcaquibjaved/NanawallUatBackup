trigger Task_PostUpdate on Task (after update) {

    /*
    trigger purpose 
        this handles contact merges  -- fixes up last sent date on mailbooks etc
    */

    list<Contact> contactsToUpdate = new List<Contact>();
    
    if( trigger.isAfter && trigger.isUpdate)
    {
        list<id> contactIds = new list<id>();
        String contact_prefix = Schema.SObjectType.Contact.getKeyPrefix();
        for( Task t : trigger.new )
        {
            Task oldTask = trigger.oldMap.get(t.Id);

            if( oldTask.WhoId != t.WhoId  )
            {
                //the contact was updated on the task; this means the contact needs to be checked for
                //the proper last mailbook sent date

                contactIds.add( t.whoId );
                
            }
        }

        map<Id,Contact> contactMap = new map<Id,Contact>();     
        for( Contact c : [SELECT Id, Last_Mailbook_Sent__c, Last_Booklet_Sent__c, Last_Binder_Sent__c FROM Contact WHERE Id in :contactIds ])
        {
            contactMap.put( c.Id, c);
        }
        boolean runUpdate = false;
        for( Task t : [ SELECT Id, CreatedDate, WhoId,Subject FROM Task WHERE WhoId in :(contactIds) AND ( Subject = 'Send Mailbook' OR Subject = 'Send Booklet' ) ] )
        {
            
            Contact c = contactMap.get(t.WhoId);
            
            if(t.Subject == 'Send Binder')
            {
                if( c != null && ( t.CreatedDate > c.Last_Binder_Sent__c || c.Last_Binder_Sent__c == null) )
                {
system.debug('updated contact last binder date');                   
                    c.Last_Binder_Sent__c = t.CreatedDate;
                    runUpdate = true;
                }
            
            } else if(t.Subject == 'Send Mailbook')
            {
                if( c != null && ( t.CreatedDate > c.Last_Mailbook_Sent__c || c.Last_Mailbook_Sent__c == null) )
                {
system.debug('updated contact last mailbook date');                 
                    c.Last_Mailbook_Sent__c = t.CreatedDate;
                    runUpdate = true;
                }
            } else if( t.Subject == 'Send Booklet')
            {
                if( c != null && ( t.CreatedDate > c.Last_Booklet_Sent__c || c.Last_Booklet_Sent__c == null) )
                {
system.debug('updated contact last booklet date');                  
                    c.Last_Booklet_Sent__c = t.CreatedDate;
                    runUpdate = true;
                }
            }
        }
        
        if (runUpdate )
            contactsToUpdate = contactMap.values();     
    }
    
    
    if( contactsToUpdate.size() > 0 )
    {
        update contactsToUpdate;
    }


}