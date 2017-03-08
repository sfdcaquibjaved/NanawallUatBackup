trigger Quote_Printed on Quote__c (before update) {

    /*
    trigger purpose
    
        if a quote is reprinted, reopens the stage; 
        
        flags contacts for nurture type under these conditions; 
        
        this trigger could use some optimization and cleanup
    */

/*
    set<id> oppIDs = new set<id>();
    for( quote__c q : trigger.new ) 
    {
        if( q.Opportunity__c != null )
        {
            oppIDs.add( q.Opportunity__c );
        }
    }
            set<id> conIDs = new set<id>();
    for( quote__c q : trigger.new ) 
    {
        if( q.Contact__c != null )
        {
            conIDs.add( q.Contact__c );
        }
    }
    List<Contact> updatecons = new List<Contact>();
    List<opportunity> updateopps = new List<opportunity>();
    map<id,Contact> cons = new map<id,Contact>([SELECT id  FROM contact WHERE id in :conIDs ]);
    map<id,opportunity> opps = new map<id,opportunity>([SELECT id, application__c, CloseDate,StageName FROM opportunity WHERE id in :oppIDs ]);
    for  (Quote__c q : trigger.new)
    {
        Quote__c oldquote = trigger.oldMap.get(q.Id);
        if ( (oldquote.Print_Date__c != q.Print_Date__c) && q.Printed__c==true)
        {
            //if a quote is reprinted on a passed resolution or closed project
            // re-open and push the close date
            Contact c= cons.get(q.Contact__c);
            Opportunity o = opps.get(q.opportunity__c);
            c.Project_Type_Nurture__c = o.application__c;
            updatecons.add(c);
            if (o.StageName == 'Quotes Passed Expected Resolution Date' || o.StageName == 'Closed - Inactivity' ||
                o.StageName == 'Closed - Lost')
            {
                o.StageName='Considered';
                o.Reason_Opportunity_Lost__c='';

                updateopps.add(o);
            }
        }
    }
    update(updateopps);
    update(updatecons);
    */
}