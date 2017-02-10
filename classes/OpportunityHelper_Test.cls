/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  1. OpportunityTrigger - Apex Trigger
                                        2. OpportunityHelper - Apex Class
*
* @ Audit Trial   : Repeating block for each change to the code
**/
@isTest
public class OpportunityHelper_Test {

    public static list < opp_proj_stages__c > olstprojectStages;
    public static list < HardCodingUtility__c > olstHardcodUtil;

    public static list < Opportunity > olstOpportunity;
    public static list < Quote__c > olstQuote;

    static testMethod void OpportunityTriggerHelper_Test() {

        /*Org_Default_Settings__c ods = new Org_Default_Settings__c();
        ods.OpportunityTrigger__c=TRUE;
        insert ods;*/

        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;

        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;

        //Insert Custom Setting Record
        olstHardcodUtil = TestDataUtility.getHardCodingUtility();
        insert olstHardcodUtil;

        list < Project__c > olstProject = new list < Project__c > ();
        Project__c p1 = new Project__c();
        //p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Close_Date__c = Date.newInstance(2015, 12, 12);
        p1.Stage__c = 'Prospecting';
        p1.Award_date__c = date.newInstance(2014, 12, 12);
        olstProject.add(p1);
        insert olstProject;

        list < Project__c > olstProject2 = new list < Project__c > ();
        Project__c p2 = new Project__c();
        p2.Name = 'Test Project CompetitorHelper_Test2';
        p2.Application__c = 'Automotive';
        p2.Application_2__c = 'Dealership';
        p2.Project_Zip_Code__c = '12345';
        p2.Project_Country__c = 'United States';
        p2.Close_Date__c = Date.newInstance(2015, 12, 12);
        p2.Stage__c = 'Prospecting';
        p2.Award_date__c = date.newInstance(2014, 12, 12);
        olstProject2.add(p2);
        insert olstProject2;

        list < Project__c > olstProject3 = new list < Project__c > ();
        Project__c p3 = new Project__c();
        p3.Name = 'Test Project CompetitorHelper_Test3';
        p3.Application__c = 'Automotive';
        p3.Application_2__c = 'Dealership';
        p3.Project_Zip_Code__c = '12345';
        p3.Project_Country__c = 'United States';
        p3.Close_Date__c = Date.newInstance(2015, 12, 12);
        p3.Stage__c = 'Prospecting';
        p3.Award_date__c = date.newInstance(2014, 12, 12);
        olstProject3.add(p3);
        insert olstProject3;


        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].Project_Name__c = olstProject[0].Id;
        olstOpportunity[0].StageName = 'Quote - Negotiation/Review';
        olstOpportunity[0].CloseDate = Date.today();
        olstOpportunity[0].Country__c = 'USA';
        olstOpportunity[0].Postal_Code__c = 'TEST';
        olstOpportunity[0].Order_Final_Date_from_quote__c = true;
        olstOpportunity[0].Bal_received_date_from_quotes__c = false;
        olstOpportunity[0].OwnerId = testUser.Id;
        olstOpportunity[0].Preliminary_Drawlings__c = true;

        olstOpportunity[1].StageName = 'Quote - Negotiation/Review';
        olstOpportunity[1].CloseDate = Date.today();
        olstOpportunity[1].Country__c = 'USA';
        olstOpportunity[1].Postal_Code__c = 'TEST';
        olstOpportunity[1].Order_Final_Date_from_quote__c = true;
        olstOpportunity[1].Bal_received_date_from_quotes__c = true;
        olstOpportunity[1].Project_Name__c = olstProject[0].Id;
        olstOpportunity[1].Preliminary_Drawlings__c = true;

        olstOpportunity[2].Project_Name__c = olstProject[0].Id;
        olstOpportunity[2].StageName = 'Quote - Negotiation/Review';
        olstOpportunity[2].Preliminary_Drawlings__c = true;

        insert olstOpportunity;
        try {
            olstOpportunity[0].OwnerId = testUser1.Id;
            // olstOpportunity[0].Amount = 1000;
            olstOpportunity[0].Primary_Opportunity__c = TRUE;
            olstOpportunity[0].StageName = 'Closed/Won';
            UPDATE olstOpportunity[0];
        } catch (Exception ex) {}


        Test.startTest();
        olstQuote = TestDataUtility.createQuoteRecords(olstOpportunity);
        olstQuote[1].Primary_Quote__c = TRUE;
        olstQuote[1].Opportunity__c = olstOpportunity[1].Id;
        olstQuote[1].Project__c = olstProject3[0].Id;
        insert olstQuote[1];


        try {
            olstOpportunity[1].StageName = 'Closed/Won';
            olstOpportunity[1].project_name__c = olstProject2[0].Id;
            UPDATE olstOpportunity[1];
        } catch (Exception ex) {}
        try {
            olstOpportunity[1].StageName = 'Influencer Closed/won';
            olstOpportunity[1].project_name__c = olstProject2[0].Id;
            UPDATE olstOpportunity[1];
        } catch (Exception ex) {}

        Set < Id > projectIds = new Set < Id > ();
        Set < Id > OpportunityIds = new Set < Id > ();

        for (Project__c proj: olstProject) {
            projectIds.add(proj.Id);
        }
        for (Opportunity opp: olstOpportunity) {
            opportunityIds.add(opp.Id);
        }
        Test.StopTest();
    }

    static testMethod void OpportunityTriggerHelper_Test1() {
        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;



        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;

        //Insert Custom Setting Record
        olstHardcodUtil = TestDataUtility.getHardCodingUtility();
        insert olstHardcodUtil;

        list < account > a = new list < account > ();
        a = TestDataUtility.createAccountTestData();
        a[0].Type = 'Competitor Firm';
        a[0].OwnerId = testUser.id;
        a[1].Type = 'Competitor Firm';
        a[1].OwnerId = testUser1.id;
        a[2].Type = 'Competitor Firm';
        a[2].OwnerId = testUser1.id;
        insert a;

        list < contact > olstContact = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = a[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        olstContact.add(c);
        insert olstContact;

        list < Project__c > olstProject = new list < Project__c > ();
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Close_Date__c = Date.newInstance(2015, 12, 12);
        p1.Stage__c = 'Quoted';
        olstProject.add(p1);
        insert olstProject;

        list < Project__c > olstProject2 = new list < Project__c > ();
        Project__c p2 = new Project__c();
        p2.Name = 'Test Project CompetitorHelper_Test2';
        p2.Application__c = 'Automotive';
        p2.Application_2__c = 'Dealership';
        p2.Project_Zip_Code__c = '12345';
        p2.Project_Country__c = 'United States';
        p2.Close_Date__c = Date.newInstance(2015, 12, 12);
        p2.Stage__c = 'Quoted';
        olstProject2.add(p2);
        insert olstProject2;

        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].Project_Name__c = olstProject[0].Id;
        olstOpportunity[0].StageName = 'Quote - Negotiation/Review';
        olstOpportunity[0].CloseDate = Date.today();
        olstOpportunity[0].Country__c = 'USA';
        olstOpportunity[0].Postal_Code__c = 'TEST';
        olstOpportunity[0].Order_Final_Date_from_quote__c = true;
        olstOpportunity[0].Bal_received_date_from_quotes__c = true;
        olstOpportunity[0].OwnerId = testUser.Id;
        olstOpportunity[0].Accountid = a[0].id;
        olstOpportunity[0].RecordTypeId = Label.Influencer_Opportunity_RecordTypeId;
        olstOpportunity[0].Preliminary_Drawlings__c = true;

        olstOpportunity[1].StageName = 'Quote - Negotiation/Review';
        olstOpportunity[1].CloseDate = Date.today();
        olstOpportunity[1].Country__c = 'USA';
        olstOpportunity[1].Postal_Code__c = 'TEST';
        olstOpportunity[1].Order_Final_Date_from_quote__c = true;
        olstOpportunity[1].Bal_received_date_from_quotes__c = true;
        olstOpportunity[1].Project_Name__c = olstProject[0].Id;
        olstOpportunity[1].Accountid = a[1].id;
        olstOpportunity[1].RecordTypeId = Label.Influencer_Opportunity_RecordTypeId;
        olstOpportunity[1].Preliminary_Drawlings__c = true;
        insert olstOpportunity;
        test.starttest();

        olstQuote = TestDataUtility.createQuoteRecords(olstOpportunity);
        olstQuote[1].Primary_Quote__c = TRUE;
        olstQuote[1].Opportunity__c = olstOpportunity[1].Id;
        olstQuote[1].Project__c = olstProject2[0].Id;
        insert olstQuote[1];

        olstOpportunity[1].StageName = 'Closed/Won';
        UPDATE olstOpportunity[1];


        List < OpportunityContactRole > oppConRolelist = new List < OpportunityContactRole > ();
        OpportunityContactRole oppConRole = new OpportunityContactRole();
        oppConRole.ContactId = olstContact[0].Id;
        oppConRole.OpportunityId = olstOpportunity[0].Id;
        oppConRolelist.add(oppConRole);

        insert oppConRolelist;
        Project_Split__c pSplit = new Project_Split__c();
        pSplit.Project__c = olstOpportunity[0].Project_Name__c;
        pSplit.Project_Rep__c = olstOpportunity[0].OwnerId;
        pSplit.Account__c = olstOpportunity[0].AccountId;
        pSplit.Split__c = 0;
        pSplit.Role__c = 'Bidder';
        insert pSplit;

        Set < Id > projectIds = new Set < Id > ();
        Set < Id > OpportunityIds = new Set < Id > ();

        for (Project__c proj: olstProject) {
            projectIds.add(proj.Id);
        }
        for (Opportunity opp: olstOpportunity) {
            opportunityIds.add(opp.Id);
        }
        Test.StopTest();
    }

    static testMethod void OpportunityTriggerHelper_Test2() {
        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;

        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;

        //Insert Custom Setting Record
        olstHardcodUtil = TestDataUtility.getHardCodingUtility();
        insert olstHardcodUtil;

        list < account > a = new list < account > ();
        a = TestDataUtility.createAccountTestData();
        a[0].Type = 'Competitor Firm';
        a[0].OwnerId = testUser.id;
        a[1].Type = 'Competitor Firm';
        a[1].OwnerId = testUser1.id;
        insert a;

        list < contact > olstContact = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = a[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        olstContact.add(c);
        insert olstContact;


        list < Project__c > olstProject = new list < Project__c > ();
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Close_Date__c = Date.newInstance(2015, 12, 12);
        p1.Stage__c = 'Quote - Provided';
        olstProject.add(p1);
        insert olstProject;

        list < Project__c > olstProject2 = new list < Project__c > ();
        Project__c p2 = new Project__c();
        p2.Name = 'Test Project CompetitorHelper_Test2';
        p2.Application__c = 'Automotive';
        p2.Application_2__c = 'Dealership';
        p2.Project_Zip_Code__c = '12345';
        p2.Project_Country__c = 'United States';
        p2.Close_Date__c = Date.newInstance(2015, 12, 12);
        p2.Stage__c = 'Quoted';
        olstProject2.add(p2);
        insert olstProject2;

        list < Project__c > olstProject3 = new list < Project__c > ();
        Project__c p3 = new Project__c();
        p3.Name = 'Test Project CompetitorHelper_Test3';
        p3.Application__c = 'Automotive';
        p3.Application_2__c = 'Dealership';
        p3.Project_Zip_Code__c = '12345';
        p3.Project_Country__c = 'United States';
        p3.Close_Date__c = Date.newInstance(2015, 12, 12);
        p3.Stage__c = 'Quoted';
        olstProject3.add(p3);
        insert olstProject3;


        List < Opportunity > opplist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test';
        o.Project_Name__c = olstProject[0].Id;
        o.StageName = 'Quote - Negotiation/Review';
        o.CloseDate = Date.today() + 190;
        o.Country__c = 'USA';
        o.Postal_Code__c = '12345';
        o.CloseDate = Date.today() - 10;
        o.OwnerId = testUser.Id;
        o.Accountid = a[0].id;
        o.ManualChangeOfERD__c = false;
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial Opportunity').getRecordTypeId();
        opplist.add(o);
        insert opplist;

        OpportunityTeamMember team = new OpportunityTeamMember();
        team.OpportunityId = opplist[0].Id;
        team.TeamMemberRole = 'Sales Rep';
        team.UserId = opplist[0].ownerId;
        insert team;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = opplist[0].Id;
        insert q;

        ERDCommercial__c ERDC = new ERDCommercial__c();
        ERDC.Name = 'testc';
        ERDC.No_of_days__c = 10;
        insert ERDC;
        ERDResidential__c ERDR = new ERDResidential__c();
        ERDR.Name = 'testR';
        ERDR.No_of_days__c = 8;
        insert ERDR;
        ERDCommercial_OrderNo__c ERDCO = new ERDCommercial_OrderNo__c();
        ERDCO.Name = 'testco';
        ERDCO.No_of_days__c = 5;
        insert ERDCO;
        ERDResidential_OrderNo__c ERDRO = new ERDResidential_OrderNo__c();
        ERDRO.Name = 'testro';
        ERDRO.No_of_days__c = 3;
        insert ERDRO;

        test.starttest();
        Set < Id > projectIds = new Set < Id > ();
        Set < Id > oppsetid = new Set < Id > ();
        for (Project__c proj: olstProject) {
            projectIds.add(proj.Id);
        }


        for (Opportunity oppty: opplist) {
            oppsetid.add(oppty.id);
        }

        o.CloseDate = Date.today() - 10;
        o.ManualChangeOfERD__c = false;
        update o;

        Quote__c q3 = new Quote__c();
        q3.Name = 'Test Quote3';
        q3.Opportunity__c = opplist[0].Id;
        insert q3;
        Test.StopTest();
    }

    static testMethod void OpportunityTriggerHelper_Test3() {
        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;



        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;

        //Insert Custom Setting Record
        olstHardcodUtil = TestDataUtility.getHardCodingUtility();
        insert olstHardcodUtil;

        list < account > a = new list < account > ();
        a = TestDataUtility.createAccountTestData();
        a[0].OwnerId = testUser.id;
        a[1].OwnerId = testUser1.id;
        insert a;

        list < contact > olstContact = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = a[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        olstContact.add(c);
        insert olstContact;

        list < Project__c > olstProject = new list < Project__c > ();
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Close_Date__c = Date.newInstance(2015, 12, 12);
        p1.Stage__c = 'Quoted';
        olstProject.add(p1);
        insert olstProject;

        list < Project__c > olstProject2 = new list < Project__c > ();
        Project__c p2 = new Project__c();
        p2.Name = 'Test Project CompetitorHelper_Test2';
        p2.Application__c = 'Automotive';
        p2.Application_2__c = 'Dealership';
        p2.Project_Zip_Code__c = '12345';
        p2.Project_Country__c = 'United States';
        p2.Close_Date__c = Date.newInstance(2015, 12, 12);
        p2.Stage__c = 'Quoted';
        olstProject2.add(p2);
        insert olstProject2;

        list < Project__c > olstProject3 = new list < Project__c > ();
        Project__c p3 = new Project__c();
        p3.Name = 'Test Project CompetitorHelper_Test3';
        p3.Application__c = 'Automotive';
        p3.Application_2__c = 'Dealership';
        p3.Project_Zip_Code__c = '12345';
        p3.Project_Country__c = 'United States';
        p3.Close_Date__c = Date.newInstance(2015, 12, 12);
        p3.Stage__c = 'Quoted';
        olstProject3.add(p3);
        insert olstProject3;

        List < Opportunity > opplist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test';
        o.Project_Name__c = olstProject[0].Id;
        o.StageName = 'Quote - Negotiation/Review';
        o.CloseDate = Date.today() + 190;
        o.Country__c = 'USA';
        o.Postal_Code__c = '12345';
        o.CloseDate = Date.today() - 10;
        o.OwnerId = testUser.Id;
        o.Accountid = a[0].id;
        o.ManualChangeOfERD__c = false;
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();
        opplist.add(o);
        insert opplist;

        OpportunityTeamMember team = new OpportunityTeamMember();
        team.OpportunityId = opplist[0].Id;
        team.TeamMemberRole = 'Sales Rep';
        team.UserId = opplist[0].ownerId;
        insert team;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = opplist[0].Id;
        insert q;

        ERDCommercial__c ERDC = new ERDCommercial__c();
        ERDC.Name = 'testc';
        ERDC.No_of_days__c = 10;
        insert ERDC;
        ERDResidential__c ERDR = new ERDResidential__c();
        ERDR.Name = 'testR';
        ERDR.No_of_days__c = 8;
        insert ERDR;
        ERDCommercial_OrderNo__c ERDCO = new ERDCommercial_OrderNo__c();
        ERDCO.Name = 'testco';
        ERDCO.No_of_days__c = 5;
        insert ERDCO;
        ERDResidential_OrderNo__c ERDRO = new ERDResidential_OrderNo__c();
        ERDRO.Name = 'testro';
        ERDRO.No_of_days__c = 3;
        insert ERDRO;

        test.starttest();
        Set < Id > projectIds = new Set < Id > ();
        Set < Id > oppsetid = new Set < Id > ();

        for (Project__c proj: olstProject) {
            projectIds.add(proj.Id);
        }


        for (Opportunity oppty: opplist) {
            oppsetid.add(oppty.id);
        }


        o.CloseDate = Date.today() - 10;
        o.ManualChangeOfERD__c = false;
        update o;

        Quote__c q3 = new Quote__c();
        q3.Name = 'Test Quote3';
        q3.Opportunity__c = opplist[0].Id;
        insert q3;
        Test.StopTest();
    }


   static testMethod void OpportunityTriggerHelper_Test4() {

        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;

        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;

        list < account > a = new list < account > ();
        a = TestDataUtility.createAccountTestData();
        a[0].OwnerId = testUser.id;
        a[1].OwnerId = testUser1.id;
        insert a;

        list < contact > olstContact = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = a[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        olstContact.add(c);
        insert olstContact;

        list < Project__c > olstProject = new list < Project__c > ();
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Close_Date__c = Date.newInstance(2015, 12, 12);
        p1.Stage__c = 'Quoted';
        olstProject.add(p1);
        insert olstProject;


        List < Opportunity > opplist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test2';
        o.Project_Name__c = olstProject[0].Id;
        o.StageName = 'Quote - Negotiation/Review';
        o.CloseDate = Date.today() - 10;
        o.Country__c = 'USA';
        o.Postal_Code__c = '12345';
        o.OwnerId = testUser.Id;
        o.Accountid = a[0].id;
        o.chain_account__c = true;
        o.Residential_Vertical__c = true;
        opplist.add(o);
        insert opplist[0];

        Opportunity o2 = new Opportunity();
        o2.Name = 'Test3';
        o2.Project_Name__c = olstProject[0].Id;
        o2.StageName = 'Need Analysis';
        o2.CloseDate = Date.today() - 10;
        o2.Country__c = 'USA';
        o2.Postal_Code__c = '12345';
        o2.OwnerId = testUser1.Id;
        o2.Accountid = a[1].id;
        o2.chain_account__c = true;
        o2.Residential_Vertical__c = true;
        opplist.add(o2);
        insert opplist[1];

        Test.StartTest();
        list < Quote__c > qt = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'Test Quote3';
        q.Opportunity__c = opplist[0].Id;
        q.Order_Number__c = 12388;
        q.Balanced_Received_Date__c = Date.today();
        q.Order_Finalized_Date__c = Date.today();
        q.Primary_Quote__c = true;
        qt.add(q);
        insert qt[0];

        q.Balanced_Received_Date__c = Date.today() + 10;
        q.Order_Finalized_Date__c = Date.today() + 20;
        update qt[0];
        Test.StopTest();


    }


   static testMethod void OpportunityTriggerHelper_Test5() {


        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;

        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;

        list < account > a = new list < account > ();
        a = TestDataUtility.createAccountTestData();
        a[0].OwnerId = testUser.id;
        a[1].OwnerId = testUser1.id;
        insert a;

        list < contact > olstContact = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = a[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        olstContact.add(c);
        insert olstContact;

        list < Project__c > olstProject = new list < Project__c > ();
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Close_Date__c = Date.newInstance(2015, 12, 12);
        //p1.Stage__c='Quote - Provided';
        p1.Stage__c = 'Quoted';
        olstProject.add(p1);
        insert olstProject;


        List < Opportunity > opplist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test2';
        o.Project_Name__c = olstProject[0].Id;
        o.StageName = 'Quote - Negotiation/Review';
        o.CloseDate = Date.today() - 10;
        o.Country__c = 'USA';
        o.Postal_Code__c = '12345';
        o.OwnerId = testUser.Id;
        o.Accountid = a[0].id;
        o.chain_account__c = true;
        o.Residential_Vertical__c = true;
        opplist.add(o);
        insert opplist[0];

        Test.StartTest();
        list < Quote__c > qt = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'Test Quote3';
        q.Opportunity__c = opplist[0].Id;
        q.Order_Number__c = 12388;
        q.Balanced_Received_Date__c = Date.today();
        q.Order_Finalized_Date__c = Date.today();
        q.Primary_Quote__c = true;
        q.Discount__c = 10;
        qt.add(q);
        insert qt[0];

        q.Balanced_Received_Date__c = Date.today() + 10;
        q.Order_Finalized_Date__c = Date.today() + 20;
        update qt[0];

        list < Quote_Detail__c > qdl = new list < Quote_Detail__c > ();
        Quote_Detail__c qd = new Quote_Detail__c();

        qd.name = 'test';
        qd.Price__c = 120;
        qd.Discount__c = 10;
        qd.Quote__c = qt[0].id;
        qdl.add(qd);
        insert qdl[0];
        Test.StopTest();
    }

    static testMethod void OpportunityTriggerHelper_Test6() {

        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;


        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;

        list < account > a = new list < account > ();
        a = TestDataUtility.createAccountTestData();
        a[0].OwnerId = testUser.id;
        a[1].OwnerId = testUser1.id;
        insert a;

        list < contact > olstContact = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = a[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        olstContact.add(c);
        insert olstContact;

        list < Project__c > olstProject = new list < Project__c > ();
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Close_Date__c = Date.newInstance(2015, 12, 12);
        p1.Stage__c = 'Quoted';
        olstProject.add(p1);
        insert olstProject;

        List < Opportunity > opplist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test2';
        o.Project_Name__c = olstProject[0].Id;
        o.StageName = 'Quote - Negotiation/Review';
        o.CloseDate = Date.today() - 10;
        o.Country__c = 'USA';
        o.Postal_Code__c = '12345';
        o.OwnerId = testUser.Id;
        o.Accountid = a[0].id;
        o.chain_account__c = true;
        o.Residential_Vertical__c = true;

        opplist.add(o);
        insert opplist[0];
        Test.StartTest();

        list < Quote__c > qt = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'Test Quote3';
        q.Opportunity__c = opplist[0].Id;
        q.Order_Number__c = 12388;
        q.Balanced_Received_Date__c = Date.today();
        q.Order_Finalized_Date__c = Date.today();
        q.Discount__c = 10;
        qt.add(q);
        insert qt[0];

        q.Balanced_Received_Date__c = Date.today() + 10;
        q.Order_Finalized_Date__c = Date.today() + 20;
        update qt[0];

        Test.StopTest();
    }
    
    static testMethod void OpportunityTriggerHelper_Test7() {

        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;


        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;

        list < account > a = new list < account > ();
        a = TestDataUtility.createAccountTestData();
        a[0].OwnerId = testUser.id;
        a[1].OwnerId = testUser1.id;
        insert a;

        list < contact > olstContact = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = a[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        olstContact.add(c);
        insert olstContact;

        //list < Project__c > olstProject = new list < Project__c > ();
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Close_Date__c = Date.newInstance(2015, 12, 12);
        p1.Stage__c = 'Quoted';
        //olstProject.add(p1);
        insert p1;

        List < Opportunity > opplist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test2';
        o.Project_Name__c = p1.Id;
        o.StageName = 'Quote - Negotiation/Review';
        o.CloseDate = Date.today() - 10;
        o.Country__c = 'USA';
        o.Postal_Code__c = '12345';
        o.OwnerId = testUser.Id;
        o.Accountid = a[0].id;
        o.chain_account__c = true;
        o.Residential_Vertical__c = true;

        opplist.add(o);
        insert opplist;
        Test.StartTest();
        
         OpportunityContactRole oppConRole = new OpportunityContactRole();
         oppConRole.ContactId = olstContact[0].Id ;
         oppConRole.OpportunityId = opplist[0].Id ;
         oppConRole.IsPrimary = true;
         insert oppConRole;

        list < Quote__c > qt = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'Test Quote3';
        q.Opportunity__c = opplist[0].Id;
        q.Order_Number__c = 12388;
        q.Balanced_Received_Date__c = Date.today();
        q.Order_Finalized_Date__c = Date.today();
        q.Discount__c = 10;
        qt.add(q);
        insert qt[0];
        
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c =qt[0].id;
        insert qd;
        
        opplist[0].stageName = 'Closed/Lost';
        update opplist[0];
         
        Test.StopTest();
    }
    
    static testMethod void OpportunityTriggerHelper_Test8() {

        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;


        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;

        list < account > a = new list < account > ();
        a = TestDataUtility.createAccountTestData();
        a[0].OwnerId = testUser.id;
        a[1].OwnerId = testUser1.id;
        insert a;

        list < contact > olstContact = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = a[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        olstContact.add(c);
        insert olstContact;

        //list < Project__c > olstProject = new list < Project__c > ();
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Close_Date__c = Date.newInstance(2015, 12, 12);
        p1.Stage__c = 'Quoted';
        //olstProject.add(p1);
        insert p1;

        List < Opportunity > opplist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test2';
        o.Project_Name__c = p1.Id;
        o.StageName = 'Closed/Won';
        o.CloseDate = Date.today() - 10;
        o.Country__c = 'USA';
        o.Postal_Code__c = '12345';
        o.OwnerId = testUser.Id;
        o.Accountid = a[0].id;
        o.chain_account__c = true;
        o.Residential_Vertical__c = true;

        opplist.add(o);
        insert opplist;
        Test.StartTest();
        
         OpportunityContactRole oppConRole = new OpportunityContactRole();
         oppConRole.ContactId = olstContact[0].Id ;
         oppConRole.OpportunityId = opplist[0].Id ;
         oppConRole.IsPrimary = true;
         insert oppConRole;

        list < Quote__c > qt = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'Test Quote3';
        q.Opportunity__c = opplist[0].Id;
        q.Order_Number__c = 12388;
        q.Balanced_Received_Date__c = Date.today();
        q.Order_Finalized_Date__c = Date.today();
        q.Discount__c = 10;
        qt.add(q);
        insert qt[0];
        
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c =qt[0].id;
        insert qd;
                 
        Test.StopTest();
    }


}