trigger Contact_PreSave on Contact (before insert, before update, after insert, after update) {

/*
    Trigger purpose
        this trigger makes sure that duplicate emails are not added to the system; 
        it also makes sure that email changes on our system are pushed to Eloqua
        
*/

    if( trigger.isAfter )
    {
        set<string> theseEmails = new set<string>();
        set<id> theseIDs = new set<id>();
        for( Contact c : trigger.new ) 
        {
            if( c.Email != null && c.email != '' )
            { 
                theseEmails.add( c.email );
                theseIDs.add( c.id );
            }
        }
        set<string> dupeEmails = new set<string>();
        if( theseEmails.size() > 0 )
        {
            for( lead l :  [SELECT email, id,IsConverted, ConvertedContactId, Is_Converting__c FROM lead where email in :theseEmails AND Is_Converting__c != true AND IsConverted != true ] )
            { 
                if( !theseIDs.contains( l.ConvertedContactId) )
                    dupeEmails.add( l.email );
            }
            for( contact c :  [SELECT email, id FROM contact where email in :theseEmails ] )
            { 
                if (!theseIDs.contains(c.id) )
                    dupeEmails.add( c.email ); 
            }
        }   
        
        map<string,string> emailsToChangeOnEloqua = new map<string,string>();   
        for( Contact c : trigger.new )
        { 
            if( trigger.isInsert )
            {
                if( c.email != null 
                && c.email != '' 
                && dupeEmails.contains(c.email))
                {
                    c.addError('A lead or contact already exists with this email address.');
                    continue;
                }
            
            } else 
            {
    
                if( 
                c != null
                && c.email != null 
                && c.email != '' 
                && trigger.oldMap.get( c.id ) != null
                && trigger.oldMap.get( c.id ).email != null
                && c.email != trigger.oldMap.get( c.id ).email //only when changing it do we check 
                && dupeEmails.contains(c.email))
                {
                    c.addError('A lead or contact already exists with this email address.');
                    continue;
                } else if( 
                c != null
                && c.email != null 
                && c.email != '' 
                && trigger.oldMap.get( c.id ) != null
                && trigger.oldMap.get( c.id ).email != null
                && trigger.oldMap.get( c.id ).email != ''
                && c.email != trigger.oldMap.get( c.id ).email //only when changing it do we check 
                )
                { //email is changing and its not a dupe
                    emailsToChangeOnEloqua.put(trigger.oldMap.get( c.id ).email, c.email);
                }
            }
        }
    
        if( emailsToChangeOnEloqua.size()  > 0 )
        {
            Async_WebServiceCaller.ChangeEloquaEmailAddress(emailsToChangeOnEloqua);
        }       
    
    }
}