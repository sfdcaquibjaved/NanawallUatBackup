trigger Contact_EmailViewTaskCreated on Task (after insert) {
    
    try {
        set<string> contIds = new set<string>();
    
        for( Task t : trigger.new )
        {
    
            if( t.WhoId != null 
            && (
                t.Subject.contains('Quote Email Opened')
                || t.Subject.contains('Email Viewed')
                ) 
            )
            {
                contIds.add( t.whoid);
            }
        }
        
        if( contIds.size() > 0 )
        {
            list<string> idsToLookup = new List<string>( contIds );
            list<Contact> conts = [SELECT id, emailverificationstatus__c FROM Contact Where id in :idsToLookup];
            for( integer i=0; i<conts.size(); i++ )
            {
                conts[i].EmailVerificationStatus__c = 'OPENED';
            }
            
            update conts;
        }
    } catch (Exception ex ) {}

}