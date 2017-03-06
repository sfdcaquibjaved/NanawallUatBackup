trigger Opportunity_Account_Owner on nrOpportunity_Account__c (after insert, after update) {

    /*
        trigger purpose
            sets the opportunity's master account to the added oppacc if the oppacc is account_type__c = 'Principal';  
            
            if the acc is a competitor, appends the account name to the opp's competitor list
    */

    //load up all the objects needed for the trigger; make sure to use the TriggerVariables structure to prevent unnecessary SOQL hits
    list<Id> oppIds = new list<id>();
    list<Id> accIds = new list<id>();
    for( nrOpportunity_Account__c noa : trigger.new )
    {
        if( !TriggerVariables.OpportunityMap_All.containsKey(noa.opportunity__c) )
            oppIds.add( noa.opportunity__c );
            
        if( !TriggerVariables.AccountMap_All.containsKey(noa.account__c) )
            accIds.add( noa.account__c );
    }
    if( oppIds.size() > 0  )
    {
        for( Opportunity o : TriggerVariables.GetOpportunitiesFromIdList(oppIds) )
        {
            TriggerVariables.OpportunityMap_All.put(o.Id, o);
        }
    }
    
    if( accIds.size() > 0  )
    {
        for( Account a : TriggerVariables.GetAccountsFromIdList(accIds) )
        {
            TriggerVariables.AccountMap_All.put(a.Id, a);
        }
    }
    
    //end loading up static variables   
    



    List<Opportunity> opplist = new List<Opportunity>(); 
    Set<Opportunity> oppset = new Set<Opportunity>();
    for (nrOpportunity_Account__c noa : trigger.new) 
    {
        Opportunity opp = TriggerVariables.OpportunityMap_All.get( noa.opportunity__c);
        Account acc = TriggerVariables.AccountMap_All.get( noa.account__c);
        
        boolean saveOpp = false;
        if (noa.account_type__c == 'Principal')  
        {
            opp.accountid = noa.account__c;
            saveOpp = true;
        }
        

        if( acc != null && acc.Competitor__c  != null && acc.Competitor__c )
        {       
            if(opp.Competitor_List__c == null)
                opp.Competitor_List__c = acc.Name;
            else opp.Competitor_List__c += '; ' + acc.Name;

            saveOpp = true; 
        }
        
        if( saveOpp )
        {
            TriggerVariables.OpportunityMap_All.put(opp.Id, opp ); //overwriting the reference because im not sure how the data is stored and dont have time to test
            if( !oppset.contains(opp) )
                oppset.add(opp);
        }       
    }
    
    if (oppset.size() >0)
    {
        set<Opportunity> oppset2 = new set<Opportunity>();
        for( Opportunity o : oppset )
        {
            if( !oppset2.contains(o) )
                oppset2.add(o);
        }
        opplist = new List<Opportunity>(oppset2  );
        update opplist;
    }
}