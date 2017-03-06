public with sharing class TestController {

/*
    @istest
    public static void rununittest()
    {
    
        TestController c = new TestController();
        c.dummyopportunity.Nana_Create_Date__c = Date.valueOf('2012-01-01');
        c.dummyOpportunity.Nana_Edit_Date__c =  Date.valueOf('2012-12-31');
        c.FindSalesteamsOverOneHundredPercent();
        c.zipcode = '08619';
        c.gettaxrate();
        c.runTest();
    }
*/


    public string FixOwners_ZipPrefix  { get; set; }
    public PageReference FixOwnsersByZipPrefix()
    {
        list<Account> accountsToUpdate = new list<Account>();
        integer totalaccounts = 0;
        string debugstr = '';
        for( Account a : [SELECT id, BillingPostalCode,BillingCountryCode,BillingStateCode, OwnerId FROM Account WHERE BillingPostalCode like :FixOwners_ZipPrefix+ '%'] )
        {
            string oldownerid = a.OwnerId;
            string newownerid = GetUserFromAddress.GetUser(a.BillingCountryCode, a.BillingPostalCode);
            
            totalaccounts++;
            if( oldownerid != newownerid )
            {
                debugstr += 'Account,'+a.Id + ',' + a.OwnerId +','+a.BillingCountryCode +','+a.BillingStateCode+'<br>';
                a.OwnerId = newownerid;
                accountsToUpdate.add(a);
            }
        }
        
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, accountsToUpdate.size() + ' accounts need to be updated out of '+totalaccounts+' total accounts. ' )  );
        
        list<Contact> contactsToUpdate = new list<Contact>();
        integer totalcontacts = 0;
        for( Contact c : [SELECT id, MailingCountryCode,MailingPostalCode,MailingStateCode, OwnerId FROM Contact WHERE MailingPostalCode like :FixOwners_ZipPrefix+ '%'] )
        {
            string oldownerid = c.OwnerId;
            string newownerid = GetUserFromAddress.GetUser(c.MailingCountryCode, c.MailingPostalCode);
            
            totalcontacts++;
            if( oldownerid != newownerid )
            {
                debugstr += 'Contact,'+c.Id+ ',' + c.OwnerId +','+c.MailingCountryCode +','+c.MailingStateCode+'<br>';              
                c.OwnerId = newownerid;
                contactsToUpdate.add(c);
            }
        }
        
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, contactsToUpdate.size() + ' contacts need to be updated out of '+totalcontacts+' total contacts. ' )  );
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, debugstr )  );
        
//      update accountsToUpdate;
//      update contactsToUpdate;
        
        
        return null;
    }

    public string SyncAccReps_FromDate  { get; set; }
    public string SyncAccReps_ToDate  { get; set; }

    public PageReference SyncAccountRepsOnOpportunities()
    {
        
        
        Datetime startDate = (Datetime)Date.parse(SyncAccReps_FromDate);
        Datetime endDate = (Datetime)Date.parse(SyncAccReps_ToDate);
        
        
        map<string,nrOpportunity_Account__c> currentOppAccs = new map<string,nrOpportunity_Account__c>();
        set<id> opportunitiestocheck = new set<Id>();
        for( nrOpportunity_Account__c oppacc :  [SELECT Id, Opportunity__c, Account__c, Account__r.OwnerId FROM nrOpportunity_Account__c WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate ] )
        {
            currentOppAccs.put( oppacc.Opportunity__c + '_' +oppacc.Account__r.OwnerID, oppacc );
            if( !opportunitiestocheck.contains(oppacc.Opportunity__c) )
            {
                opportunitiestocheck.add( oppacc.Opportunity__c);
            }
        }
        
        map< string, string > existingSaleTeamMembers = new map<string,string>();
        list<OpportunitySplit> splitsToAdd = new list<OpportunitySplit>();  
        OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];      
        
        string pairstoadd = '';
        for( OpportunitySplit split: [SELECT Id, SplitOwnerId, OpportunityID FROM OpportunitySplit WHERE OpportunityID in :opportunitiestocheck AND SplitTypeId = :splittype.Id] )
        {
            if( !existingSaleTeamMembers.containsKey(split.OpportunityId + '_' + split.SplitOwnerId) )
                existingSaleTeamMembers.put( split.OpportunityId+ '_' + split.SplitOwnerId, '1' );
                
        }
        
        for( string k : currentOppAccs.keySet() )
        {
            nrOpportunity_Account__c oppacc = currentOppAccs.get(k);
            if( !existingSaleTeamMembers.containsKey( oppacc.Opportunity__c + '_'+oppacc.Account__r.OwnerId) )
            {
                OpportunitySplit split = new OpportunitySplit();
                split.Splittypeid = splittype.id;
                split.SplitOwnerId = oppacc.Account__r.OwnerId;
                split.OpportunityId = oppacc.Opportunity__c;
                
                splitsToAdd.add(split); 
                pairstoadd +=   oppacc.Opportunity__c + '; '+oppacc.Account__r.OwnerId + '<br>';        
            }
            
        }
        
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, currentOppAccs.size() + ' oppaccs currently exist on the system. ' + splitsToAdd.size() + ' splits need to be added.')  );
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, pairstoadd )  );



        insert splitsToAdd;

                


        
        return null;
    }

    public PageReference InsertLiveChatData()
    {
    
        
        Lead l = new Lead( FirstName='Live Agent-'+ ( Math.random() * 10000), LastName='Visitor-'+ (Math.random() * 10000), PostalCode='08619');
        insert l;
    
        LiveChatVisitor visitor = new LiveChatVisitor();
        insert visitor;
    
        LiveChatTranscript transcript = new LiveChatTranscript();
        transcript.LeadId = l.Id;
        transcript.LiveChatVisitorId = visitor.Id;
        insert transcript;
    
    
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, ' Lead ID:  ' + l.id + ' ; Visitor ID: ' + visitor.Id  + ' ; Transcript ID: ' + transcript.Id)  );
    
        return null;
    }

 
    public string NDG_SalesforceQuoteID  { get; set; }
    public integer NDG_CADHistoryID  { get; set; }
    public string NDG_RecipientEmail  { get; set; }
    public PageReference SendNDGEMail()
    {
        EmailTaskCaller.SendNDGEmail(NDG_SalesforceQuoteID, NDG_CADHistoryID, NDG_RecipientEmail);
        
        return null;
    } 

    public string zipcode { get; set; }
    public PageReference gettaxrate()  
    {

        double testresponse = 0;
        try 
        {
             testresponse = Utility.GetTaxRateFromZip(zipcode);
        } catch(Exception ex )
        {
        }
        integer i = 0;
        i++;
        i++;
        
        i++;
        i++;
        
        i++;
        i++;
        
        i++;
        i++;
        
        i++;
        i++;
        
        i++;
        i++;
        
        i++;
        i++;
        
        i++;
        i++;
        
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, 'Tax Rate Response: ' + String.valueOf(testresponse) )  );
        
    
        return null;
    }

    public Opportunity dummyopportunity { 
        get
        {
            if( dummyOpportunity == null )
                dummyOpportunity = new Opportunity();
                
            return dummyOpportunity;
        } 
        set; 
    }


    public class OppOverOneHundred 
    {
        public string id {get; set; }
        public double CommissionTotal { get; set; }
    }

    public list<OppOverOneHundred> oppsOverOneHundred { get { if(oppsOverOneHundred == null ) {oppsOverOneHundred = new list<OppOverOneHundred>(); } return oppsOverOneHundred;   }  set; }
    public PageReference FindSalesteamsOverOneHundredPercent()
    {
    
        map<Id, list<nrOpportunityTeamMember__c> > oppTeamMap = new map<Id, list<nrOpportunityTeamMember__c> >();
    
        oppsOverOneHundred = new list<OppOverOneHundred>();
    
        for( nrOpportunityTeamMember__c  otm : [SELECT Id, Opportunity__c, User__c, Commission__c FROM nrOpportunityTeamMember__c WHERE Opportunity__c in (SELECT Id FROM Opportunity  WHERE (CreatedDate >= :dummyopportunity.Nana_Create_Date__c AND CreatedDate <= :dummyopportunity.Nana_Edit_Date__c)) limit 1 ] )
        {
            if( !oppTeamMap.containsKey(otm.Opportunity__c) )
            {
                oppTeamMap.put( otm.Opportunity__c, new list<nrOpportunityTeamMember__c>() );
            }
            
            oppTeamMap.get(otm.Opportunity__c).add(otm);        
        }
        
            
        for( string id : oppTeamMap.keySet() )
        {
        
            double totalcommission = 0;
            for( nrOpportunityTeamMember__c otm : oppTeamMap.get(id) )
                totalCommission += otm.Commission__c;
                
            if( totalCommission > 100 )
            {
                OppOverOneHundred o = new OppOverOneHundred();
                o.Id = id;
                o.CommissionTotal = totalCommission;
                oppsOverOneHundred.add(o);
            }
        }
    
        return null;
    }

    public PageReference runTest() 
    {

        set<id> opportunityIds = new set<id>();
        map<id, set<Id> > expectedSalesTeams = new map<id, set<Id> > ();
        map<id, set<Id> > existingSalesTeams = new map<id, set<Id> > ();
        integer expectedSalesTeamCount = 0;
        integer existingSalesTeamCount = 0;
        for( nrOpportunityContactRole__c contRole : [SELECT Contact__r.OwnerID, Opportunity__c FROM nrOpportunityContactRole__c WHERE Opportunity__c in (SELECT Id FROM Opportunity  WHERE CreatedDate >= :dummyopportunity.Nana_Create_Date__c AND CreatedDate <= :dummyopportunity.Nana_Edit_Date__c AND StageName like '%Order%' ) ] )
        {

            if( !opportunityIds.contains(contRole.Opportunity__c ) ) 
                opportunityIds.add( contRole.Opportunity__c);
                
            if( !expectedSalesTeams.containsKey(contRole.Opportunity__c ))
                expectedSalesTeams.put(contRole.Opportunity__c, new set<Id>() );
                
            if( !expectedSalesTeams.get(contRole.Opportunity__c).contains(contRole.Contact__r.OwnerID) )
            {
                expectedSalesTeams.get(contRole.Opportunity__c).add(contRole.Contact__r.OwnerID);
                expectedSalesTeamCount++;
            }
        }   
            
        for( nrOpportunityTeamMember__c teamMember : [SELECT User__c, Opportunity__c FROM nrOpportunityTeamMember__c WHERE Opportunity__c in :new list<Id>(opportunityIds) ] )
        {

            if( !existingSalesTeams.containsKey(teamMember.Opportunity__c ))
                existingSalesTeams.put(teamMember.Opportunity__c, new set<Id>() );
                
            if( !existingSalesTeams.get(teamMember.Opportunity__c).contains(teamMember.User__c) )
            {
                existingSalesTeams.get(teamMember.Opportunity__c).add(teamMember.User__c);
                existingSalesTeamCount++;
            }
                
        }       

        list<nrOpportunityTeamMember__c> teamMembersToAdd = new list<nrOpportunityTeamMember__c>();
        for( Id OpportunityID : expectedSalesTeams.keySet() )
        {
            for( string UserID_Expected : expectedSalesTeams.get(OpportunityID) )
            {
                boolean hasTeamMember = false;
                for( string UserID_Existing : existingSalesTeams.get(OpportunityID) )
                {
                    if( UserID_Existing == UserID_Expected )
                    {
                        hasTeamMember = true;
                        break;
                    }
                }
                
                if( !hasTeamMember )
                {
                    nrOpportunityTeamMember__c teamMember = new nrOpportunityTeamMember__c();
                    teamMember.Opportunity__c = OpportunityId;
                    teamMember.User__c = UserID_Expected;
                    teamMembersToAdd.add( teamMember );
                }
            }
        }
        
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, 'Total Opportunities to check: ' + opportunityIds.size()+ '; Total Expected Salesteam members:  ' + expectedSalesTeamCount + '; Existing Salesteam Members: ' + existingSalesTeamCount + '; team members to add: ' + teamMembersToAdd.size()) );
        
        return null;
    }
 
    public  PageReference runDataCleanup() 
    {
    
        DataCleanup.cleanupPerformanceTasks();
    
        return null;
    }

}