trigger Opportunity_Account_Roles on nrOpportunity_Account__c (after insert, after update) {


    
    try{
        set<id> oppids = new set<id>();
        
        for (nrOpportunity_Account__c oa : trigger.new)
        {
            if (!oppids.contains(oa.Opportunity__c))
            {
                oppids.add(oa.opportunity__c);
            }
        }
        
        Map<id,opportunity> opps = new map<id,opportunity>([select id,roles__c, (select account_type__c from Opportunity_Accounts__r)   from opportunity where id in :oppids]);
        for (Opportunity o:opps.values())
        { 
            set<string> roles = new set<string>();
            string oroles = ';';
            for (nrOpportunity_Account__c oa:o.Opportunity_Accounts__r)
            {
                if (!roles.contains(oa.account_type__c)&& oa.account_type__c !='' && oa.account_type__c != null ) //
                {
                    roles.add(oa.account_type__c);
                }  
                
            }
            for (string r : roles)
            {
                oroles = oroles + ';' + r;
            }
            oroles.replace(';;','');
            o.Roles__c = oroles;
            if (o.Roles__c.contains('Architect'))
            {
                o.Architect_Known__c='Yes'; 
            }
        }
        update(opps.values());
    }
    catch (Exception ex)
    {
    }
    
}