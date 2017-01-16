trigger Quote_UpdateStage on Quote__c (after update) {
    /*
    trigger purpose
        only works on printed quotes; 
        
        updates opp stage to Order Process Started when an order number is added; 
        
        flags an opp as considered, if it was passed ERD; 
        
        does various stage updates based on OppCont Role*/
    
    
    
  /*  Task newTask ;

    Set<id> oppids = new Set<id>();
    for (Quote__c q : trigger.new)
    {
        oppids.add(q.Opportunity__c );
    }

    Map<id,Opportunity> opps = new Map<id,Opportunity>([select id,Application__c,StageName,CloseDate,(select id,role__c,contact__c from nropportunitycontactroles__r) from Opportunity where id in :oppids]);
    List<nrOpportunityContactRole__c> roles = [select id,Role__c,Contact__c,opportunity__c from nrOpportunityContactRole__c where opportunity__c in :oppids ];
    Map<id,Opportunity> updateopps = new Map<id,Opportunity>();
    integer index = 0;
    for( Quote__c q : trigger.new )
    {
        if (q.Printed__c == False)
            continue;
        Opportunity o = opps.get(q.Opportunity__c);
         
        if (q.Ordered__c==True && q.Order_Number__c > 0 && o.StageName != 'Ordered - Paid' && q.Cancelled__c == false)
        {
            o.StageName = 'Order Process Started';
            //update o;
            if (!updateopps.containsKey(o.id))
                updateopps.put(o.id,o);
            continue;
        }

        for (nrOpportunityContactRole__c nocr : o.nropportunitycontactroles__r)
        {
            if (nocr.Contact__c!= q.Contact__c)
                continue;
            if (o.StageName == 'Quotes Passed Expected Resolution Date')
                o.StageName = 'Considered';
            if (nocr.Role__c == 'Architect')
            {
                if (o.StageName == 'Quoted Architect and Non-Architect' || o.StageName == 'Budget Quote to Architect')  
                {
                    continue;
                }
                else if (o.StageName == 'Quote/Non-Architect')
                {
                    o.StageName = 'Quoted Architect and Non-Architect';
                    if (!updateopps.containsKey(o.id))
                        updateopps.put(o.id,o);
                }
                else if (o.StageName == 'Considered' ||
                    o.StageName == 'Specified' ||
                    o.StageName == 'Quote Requested' ||
                    o.StageName == 'Glazing Contractor')
                    {
                        o.StageName ='Budget Quote to Architect';
                        if (!updateopps.containsKey(o.id))
                            updateopps.put(o.id,o);
                    }
            }
            else 
            {
                if (o.StageName == 'Quoted Architect and Non-Architect' ||o.StageName == 'Quote/Non-Architect') 
                {
                    continue;
                }
                else if (o.StageName == 'Budget Quote to Architect')
                {
                    o.StageName = 'Quoted Architect and Non-Architect';
                    if (!updateopps.containsKey(o.id))
                        updateopps.put(o.id,o);
                }
                else if (o.StageName == 'Considered' ||
                    o.StageName == 'Specified' ||
                    o.StageName == 'Quote Requested'||
                    o.StageName == 'Glazing Contractor')
                    {
                        o.StageName ='Quote/Non-Architect';
                        if (!updateopps.containsKey(o.id))
                            updateopps.put(o.id,o);
                    }
            }
        }
        index++;
    }
    update updateopps.values();*/
    
}