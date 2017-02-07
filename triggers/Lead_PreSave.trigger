trigger Lead_PreSave on Lead (before insert, before update, after insert, after update) {
  if(UtilityClass.doNotRunOnConverstionOfLead = true){
  /*  trigger purpose
        cleans up invalid phone formats;  
        
        also maintaining a sync to the underlying address fields (duplicative?); 
        checks for duplicate emails;  
        sends email change notices to eloqua
  */
  
  if( trigger.isBefore )
  {
    try {
        Map<string,string> statemap = null; 
        
        for( Lead l : trigger.new )
        {
            
            try { 
                if (l.Phone != NULL)
                {  
                    if (l.Phone.startsWith('+1'))
                    {
                        l.Phone = l.Phone.substring(3);
                        l.Phone = l.Phone.replace('.','-');
                        l.Phone = l.Phone.replaceFirst('(^[0-9][0-9][0-9]).','($1) ');
                    }
                    l.Phone = l.Phone.replace('.','-');
                }   
    
            } catch(Exception e) {
                Utility.JimDebug(e, 'lead pre save, jigsaw tests ' + l.Id);
            }
            
            
        }
    } catch( exception ex ) 
    {
        system.debug('caught an exception while updating a lead showroom for ; ' +ex );
    }
  } else 
  {
    set<string> theseEmails = new set<string>();
    set<id> theseIDs = new set<id>();
    for( lead l : trigger.new ) 
    {
        if( l.email != null && l.email != '' )
        {
            theseEmails.add( l.email );
            theseIDs.add( l.id );
        }
    }
    set<string> dupeEmails = new set<string>();
    if( theseEmails.size() > 0 )
    {
        for( lead l :  [SELECT email, id FROM lead where email in :theseEmails AND IsConverted != true ] )
        {
            if (!theseIDs.contains(l.id) )
                dupeEmails.add( l.email );
        }
        for( contact c :  [SELECT email, id FROM contact where email in :theseEmails ] )
        {
            dupeEmails.add( c.email );
        }
    }   
    
    map<string,string> emailsToChangeOnEloqua = new map<string,string>();
    for( Lead l : trigger.new )
    { 

        if( trigger.isInsert )
        {
            if( !l.IsConverted 
            && l.email != null 
            && l.email != '' 
            && dupeEmails.contains(l.email))
            {
                l.Email.addError('A lead or contact already exists with this email address.');
                continue;
            } 
        
        } else
        {
            if( !l.IsConverted 
            && l.email != null 
            && l.email != '' 
            && trigger.oldmap.get(l.id) != null
            /*&& trigger.oldmap.get(l.id).email != null*/
            && l.email != trigger.oldmap.get(l.id).email
            && dupeEmails.contains(l.email))
            {
                l.Email.addError('A lead or contact already exists with this email address.');
                continue;
            } else if ( !l.IsConverted 
            && l.email != null 
            && l.email != '' 
            && trigger.oldmap.get(l.id) != null
            && trigger.oldmap.get(l.id).email != null
            && trigger.oldmap.get(l.id).email != ''
            && l.email != trigger.oldmap.get(l.id).email )
            { //the email is changing and its NOT a dupe
                emailsToChangeOnEloqua.put(trigger.oldmap.get(l.id).email, l.email);
            }
        }
    
    }
    
    if( emailsToChangeOnEloqua.size() > 0 )
        Async_WebServiceCaller.ChangeEloquaEmailAddress(emailsToChangeOnEloqua);
  }
  }
}