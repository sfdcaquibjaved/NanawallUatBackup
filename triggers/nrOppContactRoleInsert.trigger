trigger nrOppContactRoleInsert on nrOpportunityContactRole__c (before insert, after insert) {

/*
    trigger purpose 
        sets the oppcont role to the leads, if the leads exists, if the lead doesn’t have a role but the oppcont does, sets the leads role to that value; 
        
        also does some of the In2Clouds updates on projects for order counts, contact quote counts, showroom visits, and nearby showrooms; also adds the underlying 
        OppContRole if one doesnt exist, also makes sure that salesteam members for new oppconts are added to the salesteam,  
        
*/

    //load up per-instance maps and lists of data that need to be used for lookups across all runs of this trigger
    
    /*if( TriggerVariables.nrOppContactRoleInsert_ContactMap == null )
    {
        TriggerVariables.nrOppContactRoleInsert_ContactMap = new map<id,Contact>();
        list<id> tempContIdLookup = new list<Id>();
        for( nrOpportunityContactRole__c nrocr : trigger.new )
        {
            //look at each ocr in the trigger.new; if we see the contact is in the global map, put it in our trigger specific map, if not, flag it for lookup
            if( !TriggerVariables.ContactMap_All.containsKey(nrocr.Contact__c) )
                tempContIdLookup.add(nrocr.Contact__c);
            else TriggerVariables.nrOppContactRoleInsert_ContactMap.put(nrocr.Contact__c,TriggerVariables.ContactMap_All.get(nrocr.contact__c) );
        }
        //fetch any contacts that havent been looked up in this set of trigger runs     
        for(Contact c : TriggerVariables.GetContactsFromIdList(tempContIdLookup)  )
        {
            TriggerVariables.nrOppContactRoleInsert_ContactMap.put(c.id, c);        
            TriggerVariables.ContactMap_All.put(c.Id, c); //if we are in this loop that shoudl mean we didnt find the contact in the global map. put it there   
        }
    }

    if( TriggerVariables.nrOppContactRoleInsert_AccountMap_FromContact == null )
    {
        TriggerVariables.nrOppContactRoleInsert_AccountMap_FromContact = new map<id,Account>(); //this is JUST the list of the accounts tied to contacts that are in the trigger.new
        list<id> tempAccidlookup = new list<id>();
        for( Contact c : TriggerVariables.nrOppContactRoleInsert_ContactMap.values() )
        {
            if(TriggerVariables.AccountMap_All.containsKey(c.accountid) ) //some trigger has already loaded that account, use that data
                TriggerVariables.nrOppContactRoleInsert_AccountMap_FromContact.put(c.AccountId,TriggerVariables.AccountMap_All.get(c.accountid) );
            else tempAccidlookup.add(c.accountid);
        }           
        for(Account a :  TriggerVariables.GetAccountsFromIdList(tempAccidlookup) ) 
        {
            TriggerVariables.nrOppContactRoleInsert_AccountMap_FromContact.put(a.id, a);
            TriggerVariables.AccountMap_All.put(a.Id, a); //if we are inside this loop, that should mean the global account map didnt have it, stick it in there
        }
    }   
    
    if(TriggerVariables.nrOppContactRoleInsert_Project_To_nrOpportunity_Account_Map == null )
    {
        TriggerVariables.nrOppContactRoleInsert_Project_To_nrOpportunity_Account_Map = new map<id,nrOpportunity_Account__c>();
        TriggerVariables.nrOppContactRoleInsert_Existing_nrOpportunity_Accounts = new set<string>();
        list<Id> tempProjIds = new list<Id>();
        for( nrOpportunityContactRole__c nrocr : trigger.new )
            tempProjIds.add( nrocr.Opportunity__c );
            
        for(nrOpportunity_Account__c oppAcc : TriggerVariables.GetnrOpportunity_Account_ByProjectIds(tempProjIds) )
        {
            TriggerVariables.nrOppContactRoleInsert_Project_To_nrOpportunity_Account_Map.put(oppAcc.Opportunity__c,oppAcc);
            if (!TriggerVariables.nrOppContactRoleInsert_Existing_nrOpportunity_Accounts.contains(oppAcc.Opportunity__c + '_' + oppAcc.Account__c) )
                TriggerVariables.nrOppContactRoleInsert_Existing_nrOpportunity_Accounts.add(oppAcc.Opportunity__c + '_' + oppAcc.Account__c);
        }
    }
    //end loading lookup data
    
    if( trigger.isBefore )
    {
        system.debug('inserting a contact role');
        set<id> projids = new set<id>();
//      map<id, opportunity> projectMap = new map<id,opportunity>();
        list<Contact> contactUpdates = new list<Contact>();
        
        for( nrOpportunityContactRole__c nrocr : trigger.new )
        {
            if( !projids.contains(nrocr.Opportunity__c) )
                projids.add( nrocr.Opportunity__c );
        }
        
        map<id, Contact> contLookup = TriggerVariables.nrOppContactRoleInsert_ContactMap; //shorter variable name make the lower stuff easier

        for( nrOpportunityContactRole__c nrocr : trigger.new )
        {
            if( nrocr.Role__c == null || nrocr.Role__c == '' )
            {
                try
                {
                    nrocr.Role__c = contlookup.get(nrocr.contact__c).LeadType__c;
                } catch( Exception ex ) {
                    nrocr.role__c = 'Unknown';
                }
                
                if( nrocr.Role__c == null || nrocr.Role__c == ''  )
                    nrocr.Role__c = 'Unknown';
            } else 
            {
                try {
                    if( contlookup.get(nrocr.contact__c).LeadType__c == null
                    || contlookup.get(nrocr.contact__c).LeadType__c == '' )
                    {
                        contlookup.get(nrocr.contact__c).LeadType__c = nrocr.Role__c;
                        contactUpdates.add( contlookup.get(nrocr.contact__c) ); 
                    }
                } catch (Exception ex ){}
            
            }
            
        }

        if( contactUpdates.size() > 0 )
        {
            update contactUpdates;
        }

        
    } else if( Trigger.isAfter )
    {
        List<OpportunityShare> osInserts = new List<OpportunityShare>(); // = new OpportunityShare();
        list<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
        
        list<nrOpportunity_Account__c> accJoins = new List<nrOpportunity_Account__c>();
        set<id> contIDs = new set<id>();
        map<id, set<id> > contOpps = new map<id,set<id>>();
        map<id,id> contAccs = new map<id,id>();
        map<id, Contact> accountToContactLookup = new map<id, Contact>();

        list<Account> accountUpdates = new list<Account>();
        list<nrOpportunityTeamMember__c> nrotm_adds = new list<nrOpportunityTeamMember__c>();
        list<OpportunitySplit> splitsToAdd = new list<OpportunitySplit>();
        
        set<string> existingProjAccs = new set<string>();
        set<id> projids = new set<id>();
        map<string, Integer> lookupProjectSalesteamMember = new map<string,Integer>();
        map<id, Contact> lookupContact = new map<id, Contact>();
        
        for( nrOpportunityContactRole__c nrocr : trigger.new )
        {
            /*begin filling in data structures for the opportunity-account join lookups
            i know this looks ridiculous, but i am trying to keep this bulk safe -- sorry 
            */
            /*if( !contIDs.contains(nrocr.Contact__c) )
            {
                contAccs.put( nrocr.Contact__c, TriggerVariables.ContactMap_All.get(nrocr.Contact__c).AccountId ); // ...
                contIDs.add( nrocr.Contact__c );
            }
            if( !contOpps.containsKey(nrocr.Opportunity__c) )
                contOpps.put( nrocr.Opportunity__c, new set<id>() );
                
            if( !contOpps.get(nrocr.opportunity__c).contains(nrocr.contact__c) )
                contOpps.get(nrocr.opportunity__c).add(nrocr.contact__c);
            /* end opp-acc joins*/
        
            /*if( !projids.contains(nrocr.Opportunity__c) )
                projids.add( nrocr.Opportunity__c );
                    
            //** NOT BULK SAFE -- FIX THIS **/
           /* list<OpportunityContactRole> tmpocrs = [SELECT id FROM OpportunityContactRole WHERE contactid = :nrocr.Contact__c AND opportunityid = :nrocr.Opportunity__c ];
            if( tmpocrs.size() < 1 )
            { //the convert seems to insert one on it's own
                OpportunityContactRole ocr = new OpportunityContactRole();
                ocr.ContactId = nrocr.Contact__c; 
                ocr.OpportunityId = nrocr.Opportunity__c;
                ocr.Role = nrocr.Role__c;
                
                ocrs.add( ocr );
            }
        }

        for( Contact c : TriggerVariables.nrOppContactRoleInsert_ContactMap.values() )
        {
            //fill in the cont-acc data
            contAccs.put(c.id,  c.accountid );  
            accountToContactLookup.put( c.accountId, c );
            lookupContact.put(c.id, C);
        }
        
        existingProjAccs = TriggerVariables.nrOppContactRoleInsert_Existing_nrOpportunity_Accounts;// load only once 
        
        for( OpportunityTeamMember nrotm : [SELECT id, UserID, OpportunityID FROM OpportunityTeamMember WHERE OpportunityID in :projids]  ) 
        {
            lookupProjectSalesteamMember.put( nrotm.OpportunityID+'_'+nrotm.UserID,1);
        }
        
        
        OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];      
        for( nrOpportunityContactRole__c nrocr : trigger.new )
        {
            try {
                string ownerID = lookupContact.get( nrocr.Contact__c).OwnerID;
                if( !lookupProjectSalesteamMember.containsKey( nrocr.Opportunity__c+'_'+ownerID ) )
                {

                    OpportunitySplit split = new OpportunitySplit();
                    split.SplitOwnerID = ownerId;
                    split.OPportunityID = nrocr.Opportunity__c;
                    split.SplitTypeId = splittype.id;
                    splitsToAdd.add(split);

                                     
                }
            }catch(Exception ex )
            {
                system.debug( 'an exception occurred when trying to create an OpportunitySplit in a contactroleinsert');
            }
        }               
                        
        
        
        for( Account a : TriggerVariables.nrOppContactRoleInsert_AccountMap_FromContact.values() )
        {
            Contact c = accountToContactLookup.get(a.id);
            if( c != null && 
                (a.Type == null || a.Type == '' )
            && c.LeadType__c != null
            && c.LeadType__c != '' )
            {
                a.Type = c.LeadType__c;
                accountUpdates.add(a);
            }
        }

        for( id oppid : contOpps.keySet() )
        {
            for( id contid : contOpps.get(oppid) )
            {
                nrOpportunity_Account__c accjoin = new nrOpportunity_Account__c();
                accjoin.Account__c = contAccs.get(contid);
                accjoin.opportunity__c = oppid;
                accJoins.add( accJoin);
            }       
        }

        if( splitsToAdd.size() > 0 )
        {
            insert splitsToAdd;
        }

                 
//      if(nrotm_adds.size() > 0 )
//          insert nrotm_adds;
            
        if( accountUpdates.size() > 0 )
        {
            try 
            {
                update accountUpdates;
            } catch( Exception ex )
            {
                
            }
        }
        
        if( accJoins.size() > 0 )
        {
            insert accJoins;
        }
        
        if(ocrs.size() > 0 )
            insert ocrs;

    
        if( osInserts.size() > 0 )
        {
//          insert osInserts;
        }
    }*/
}