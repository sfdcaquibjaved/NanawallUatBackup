/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  1. QuoteTrigger - Apex Trigger
                                        2. QuoteTriggerHelper - Apex Class
*
* @ Audit Trial   : Repeating block for each change to the code
**/
@isTest(SeeAllData = false)
public class QuoteTriggerHelper_Test {

    public static list < Zip_Codes_Master__c > territorymaster;
    public static list <Account> accounts;
    public static list <Contact> contacts;
    public static list < Project__c > olstProject;
    public static list < Opportunity > olstOpportunity;
    public static list < Quote__c > olstQuote;
    
    

    static testMethod void QuoteTriggerHelper_Test1() {

        //Create Test Data
        olstProject = TestDataUtility.createProjectTestData();
        try {
            insert olstProject;
        } catch (Exception e) {}
        olstOpportunity = TestDataUtility.createOppTestData();

        for (Opportunity opp: olstOpportunity) {
            opp.Project_Name__c = olstProject[0].Id;
        }
        try {
            insert olstOpportunity;
        } catch (Exception e) {}
        olstQuote = TestDataUtility.createQuoteRecords(olstOpportunity);
        olstQuote[0].Printed__c = true;
        olstQuote[1].Printed__c = true;
        olstQuote[1].Viewed__c = true;
        olstQuote[2].Ordered__c = true;
        olstQuote[3].Order_Confirmation_Sent__c = Date.today();
        olstQuote[4].Complete_Signoff_Date__c = Date.today();
        olstQuote[4].Deposit_Amount__c = 12;
        olstQuote[4].Deposit_Date__c = Date.today();
        try {
            insert olstQuote;
        } catch (Exception e) {}
        Set < Id > projIds = new Set < Id > ();

        for (Project__c pro: olstProject) {
            projIds.add(pro.Id);
        }
        QuoteTriggerHelper.recalculateProjectAmount(projIds);

        Set < Id > oppIds = new Set < Id > ();
        map < Id, String > mapStage = new map < Id, String > ();

        for (Opportunity opp: olstOpportunity) {
            oppIds.add(opp.Id);
            mapStage.put(opp.Id, opp.Stagename);
        }
        QuoteTriggerHelper.updateOppAmount(oppIds, mapStage);
    }
    static testMethod void QuoteTriggerHelper_Test2() {

        //Create Test Data
        olstProject = TestDataUtility.createProjectTestData();
        try {
            insert olstProject;
        } catch (Exception e) {}
        olstOpportunity = TestDataUtility.createOppTestData();

        for (Opportunity opp: olstOpportunity) {
            opp.Project_Name__c = olstProject[0].Id;
            opp.StageName = 'Proposal/Price Quote';
            opp.Amount = 1000;
        }
        try {
            insert olstOpportunity;
        } catch (Exception e) {}

        /*olstQuote = TestDataUtility.createQuoteRecords(olstOpportunity);
        olstQuote[0].Printed__c = true ;
        //olstQuote[0].Primary_Quote__c = false;
        olstQuote[1].Printed__c = true ;
        olstQuote[1].Viewed__c = true ;
        olstQuote[2].Ordered__c = true ;
        olstQuote[3].Order_Confirmation_Sent__c = Date.today() ;
        olstQuote[4].Complete_Signoff_Date__c = Date.today() ;
        olstQuote[4].Deposit_Amount__c = 12 ;
        olstQuote[4].Deposit_Date__c = Date.today();
        olstQuote[5].Primary_Quote__c = false;*/

        list < Quote__c > lstQuote = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'test';
        q.Opportunity__c = olstOpportunity[0].Id;
        q.Primary_Quote__c = false;
        q.Viewed__c = true;
        q.Ordered__c = true;
        q.Order_Confirmation_Sent__c = Date.today();
        q.Complete_Signoff_Date__c = Date.today();
        q.Deposit_Amount__c = 12;
        q.Deposit_Date__c = Date.today();
        lstQuote.add(q);
        try {
            insert lstQuote;
        } catch (Exception e) {}
        Set < Id > projIds = new Set < Id > ();

        for (Project__c pro: olstProject) {
            projIds.add(pro.Id);
        }
        QuoteTriggerHelper.recalculateProjectAmount(projIds);

        Set < Id > oppIds = new Set < Id > ();
        map < Id, String > mapStage = new map < Id, String > ();

        for (Opportunity opp: olstOpportunity) {
            oppIds.add(opp.Id);
            mapStage.put(opp.Id, opp.Stagename);
        }
        QuoteTriggerHelper.updateOppAmount(oppIds, mapStage);
        QuoteTriggerHelper.recalculateProjectAmount(projIds);
        // QuoteTriggerHelper.CheckInfluencerOppOrder(olstQuote);
    }
    static testMethod void QuoteTriggerHelper_Test3() {

        //Create Test Data
        /* olstProject = TestDataUtility.createProjectTestData();
         try{
         insert olstProject ;
         }
         catch(Exception e){}*/

        list < Zip_Codes_Master__c > lstzipCode = new list < Zip_Codes_Master__c > ();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345';
        lstzipCode.add(zipCode1);
        insert lstzipCode;

        list < Account > accountlst = new list < Account > ();
        Account a = new Account();
        a.Name = 'Test account';
        a.Phone = '(123) 456-7890';
        //a.Name = 'Test account';
        a.BillingState = 'Maine';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'stow';
        a.Type = 'Interior Designer';
        accountlst.add(a);
        insert accountlst;

        list < Project__c > projlst = new list < Project__c > ();


        Project__c p1 = new Project__c();
        //p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Architect_Account__c = accountlst[0].id;

        projlst.add(p1);

        insert projlst;


        /* olstOpportunity = TestDataUtility.createOppTestData();
         
         for (Opportunity opp : olstOpportunity){
         opp.Project_Name__c = olstProject[0].Id;
         opp.StageName = 'Proposal/Price Quote';
         opp.Amount=1000;    
         }
         try{
         insert olstOpportunity ;
         }
         catch(Exception e){}*/
        List < Opportunity > oppslist = new List < Opportunity > ();


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.Project_Name__c = Projlst[0].Id;
        o.StageName = 'Proposal/Price Quote';
        o.Amount = 1000;
        oppslist.add(o);


        Opportunity p = new Opportunity();
        p.Name = 'Test OppInflu';
        p.StageName = 'Need Analysis';
        p.CloseDate = Date.today();
        p.Country__c = 'USA';
        p.Postal_Code__c = 'TEST';
        p.Project_Name__c = Projlst[0].Id;
        p.StageName = 'Drawings - Requested';
        p.Amount = 1000;
        p.RecordTypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Influencer Opportunity').getRecordTypeId();
        oppslist.add(p);
        insert oppslist;

        list < Quote__c > lstQuote = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'test';
        q.Opportunity__c = oppslist[0].Id;
        q.Primary_Quote__c = false;
        q.Viewed__c = true;
        q.Ordered__c = true;
        q.Order_Confirmation_Sent__c = Date.today();
        q.Complete_Signoff_Date__c = Date.today();
        q.Deposit_Amount__c = 12;
        q.Deposit_Date__c = Date.today();
      //  q.Send_Quote_to_Installer__c = TRUE ;
        lstQuote.add(q);

        Quote__c qInflu = new Quote__c();
        qInflu.Name = 'testInflu';
        qInflu.Opportunity__c = oppslist[1].Id;
        qInflu.Primary_Quote__c = false;
        qInflu.Viewed__c = true;
        qInflu.Ordered__c = true;
        qInflu.Order_Confirmation_Sent__c = Date.today();
        qInflu.Complete_Signoff_Date__c = Date.today();
        qInflu.Deposit_Amount__c = 0;
        qInflu.Deposit_Date__c = Date.today();
        lstQuote.add(qInflu);



        insert lstQuote;

        // catch(Exception e){}
        Set < Id > projIds = new Set < Id > ();

        for (Project__c pro: Projlst) {
            projIds.add(pro.Id);
        }
        QuoteTriggerHelper.recalculateProjectAmount(projIds);

        Set < Id > oppIds = new Set < Id > ();
        map < Id, String > mapStage = new map < Id, String > ();

        for (Opportunity opp: oppslist) {
            oppIds.add(opp.Id);
            mapStage.put(opp.Id, opp.Stagename);
        }
        QuoteTriggerHelper.updateOppAmount(oppIds, mapStage);
        QuoteTriggerHelper.recalculateProjectAmount(projIds);
    }



    static testMethod void QuoteTriggerHelper_Test4() {

        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;
        list < Account > acc = new list < Account > ();
        Account a = new Account();
        a.Name = 'Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry = 'United States';
        a.BillingPostalCode = '12345';
        acc.add(a);

        insert acc;
        
        list < Account > acc1 = new list < Account > ();
         Account a1 = new Account();
        a1.Name = 'Test account';
        a1.BillingState = 'New York';
        a1.BillingCountry = 'United States';
        a1.BillingPostalCode = '12345';
        acc1.add(a1);

        insert acc1;

        list < project__c > olstTestProject2 = new list < project__c > ();
        project__c p = new project__c();
        p.Name = 'xyz enterprise';
        p.Project_Zip_Code__c = '12345';
        p.Project_Country__c = 'United States';
        p.Close_Date__c = Date.newInstance(2015, 12, 12);
        p.Stage__c = 'Closed Lost - Project Lost';
        p.Reason_Project_Lost__c = 'Competitor';

        olstTestProject2.add(p);

        insert olstTestProject2[0];

        project__c p2 = new project__c();

        p2.Name = 'xyzw enterprise';
        p2.Project_Country__c = 'Canada';
        p2.Project_Zip_Code__c = 'V0M 9S9';
        p2.Close_Date__c = Date.newInstance(2015, 12, 12);
        p2.Stage__c = 'Closed - Inactivity';
        p2.Reason_Project_Lost__c = 'Competitor';
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3 = new project__c();
        p3.Name = 'xyzw enterprise2';
        p3.Project_Zip_Code__c = ' ';
        p3.Project_Country__c = 'Mexico';
        p3.Project_State__c = 'Coahuila';
        p3.Close_Date__c = Date.newInstance(2015, 12, 12);
        p3.Stage__c = 'On Hold';
        p3.Reason_Project_Lost__c = 'Competitor';
        olstTestProject2.add(p3);
        insert olstTestProject2[2];

       
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity;
        Map < String, Schema.RecordTypeInfo > OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = OpportunityRecordTypeInfo.get('Influencer Opportunity').getRecordTypeId();

        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].Project_Name__c = olstTestProject2[0].Id;
        olstOpportunity[0].AccountId = acc1[0].id;
        olstOpportunity[0].recordtypeId = rtId;
        olstOpportunity[1].Project_Name__c = olstTestProject2[0].Id;
        olstOpportunity[1].AccountId = acc[0].id;
        olstOpportunity[1].recordtypeId = rtId;
        olstOpportunity[2].Project_Name__c = olstTestProject2[1].Id;
        olstOpportunity[2].recordtypeId = rtId;
        olstOpportunity[3].Project_Name__c = olstTestProject2[2].Id;
        olstOpportunity[3].recordtypeId = rtId;
        olstOpportunity[4].Project_Name__c = olstTestProject2[0].Id;
        olstOpportunity[4].recordtypeId = rtId;
        olstOpportunity[5].Project_Name__c = olstTestProject2[1].Id;
        olstOpportunity[5].recordtypeId = rtId;
        olstOpportunity[0].name = 'Project';
        olstOpportunity[1].name = 'Account';
        olstOpportunity[0].StageName = 'Influencer Closed/Lost';
        olstOpportunity[0].Reason_Opportunity_Lost__c = 'Project Cancelled';

        insert olstOpportunity;

        Test.StartTest();
        olstQuote = TestDataUtility.createQuoteRecords(olstOpportunity);
        olstQuote[0].Printed__c = true;
        olstQuote[0].Primary_Quote__c = FALSE;
        olstQuote[0].Opportunity__c =  olstOpportunity[0].id;

        //olstQuote[0].opportunity__c = olstOpportunity[0].id;
        olstQuote[1].Printed__c = true;
        olstQuote[1].Primary_Quote__c = FALSE;

        // olstQuote[1].opportunity__c = olstOpportunity[1].id;
        olstQuote[1].Viewed__c = true;
        olstQuote[2].Ordered__c = true;
        // olstQuote[2].opportunity__c = olstOpportunity[2].id;
        olstQuote[3].Order_Confirmation_Sent__c = Date.today();
        //  olstQuote[3].opportunity__c = olstOpportunity[3].id;
        olstQuote[4].Complete_Signoff_Date__c = Date.today();
        //  olstQuote[4].opportunity__c = olstOpportunity[4].id;
        olstQuote[4].Deposit_Amount__c = 12;
        olstQuote[4].Deposit_Date__c = Date.today();
        try {
            insert olstQuote;
        } catch (Exception e) {}
        
        Quote_Detail__c QD = new Quote_Detail__c();
        QD.Name = 'Test Name';
        QD.Quote__c =  olstQuote[1].id;
        QD.Price__c = 2000 ; 
        insert QD;


        QuoteTriggerHelper.CheckInfluencerOppOrder(olstQuote);
        
        Set < Id > oppIds = new Set < Id > ();
        map < Id, String > mapStage = new map < Id, String > ();

        for (Opportunity opp: olstOpportunity) {
            oppIds.add(opp.Id);
            mapStage.put(opp.Id, opp.Stagename);
        }
        
        QuoteTriggerHelper.updateOppAmount(oppIds, mapStage);

        Test.StopTest();


    }
    
    
    static testMethod void QuoteTriggerHelper_Test5() {

        //Create Test Data
        olstProject = TestDataUtility.createProjectTestData();
        try {
            insert olstProject;
        } catch (Exception e) {}
        olstOpportunity = TestDataUtility.createOppTestData();

        for (Opportunity opp: olstOpportunity) {
            opp.Project_Name__c = olstProject[0].Id;
        }
        try {
            insert olstOpportunity;
        } catch (Exception e) {}
        olstQuote = TestDataUtility.createQuoteRecords(olstOpportunity);
        olstQuote[0].Printed__c = true;
        olstQuote[1].Printed__c = true;
        olstQuote[1].Viewed__c = true;
        olstQuote[2].Ordered__c = true;
        olstQuote[3].Order_Confirmation_Sent__c = Date.today();
        olstQuote[4].Complete_Signoff_Date__c = Date.today();
        olstQuote[4].Deposit_Amount__c = 12;
        olstQuote[4].Deposit_Date__c = Date.today();
        try {
        Test.startTest();
            insert olstQuote;
        Test.StopTest();    
        } catch (Exception e) {}
        Set < Id > projIds = new Set < Id > ();

        for (Project__c pro: olstProject) {
            projIds.add(pro.Id);
        }
        QuoteTriggerHelper.recalculateProjectAmount(projIds);

        Set < Id > oppIds = new Set < Id > ();
        map < Id, decimal > mapStage = new map < Id, decimal > ();

        for (Opportunity opp: olstOpportunity) {
            oppIds.add(opp.Id);
            mapStage.put(opp.Id, opp.Average_Quote_Discount__c);
        }
       // QuoteTriggerHelper.reCalculateProjectAmtOnOrders(oppIds, mapStage);
    }
     
  
    
     public static testMethod void UnitTest1() {
        
       
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        
       accounts = TestDataUtility.createAccountTestData();
       insert accounts;
        
         
        contacts = TestDataUtility.createConTestData();
        Contacts[0].Accountid=accounts[0].id;
        Contacts[1].Accountid=accounts[1].id;
        Contacts[2].Accountid=accounts[2].id;
        insert contacts;
       
        olstProject = TestDataUtility.createProjectTestData();
        insert olstProject;
        
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].Accountid = accounts[0].id;
        olstOpportunity[0].Project_Name__c = olstProject[0].id;
        insert olstOpportunity;  
        
        Test.startTest(); 
        list<Quote__c> lstQuote = new list <Quote__C>();
       
        Quote__c q1 = new Quote__c();
        q1.Name = 'Test Quote';
        q1.Opportunity__c = olstOpportunity[0].id;
        q1.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q1.Actual_Delivery_Date__c = date.today();
        q1.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q1.Contact__c = contacts[0].id;
        //q1.Balanced_Received_Date__c = Date.today();
        
         
       // lstQuote.add(q1);
        insert q1;
         
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'HSW66'; 
        qd.quote__c = q1.id;
        qDetail.add(qd); 
        insert qDetail;
          
        warranties__c entwar =  new warranties__c(Name='HSW66');
        insert entwar;
         
        q1.Balanced_Received_Date__c = Date.today();
        update q1;
    
        entitlementBatch en = new entitlementBatch();
        Database.executeBatch(en);
 
       Test.stopTest();
           
    }
     
    public static testMethod void UnitTest2() {
        
        
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        
       accounts = TestDataUtility.createAccountTestData();
       insert accounts;
        
         
        contacts = TestDataUtility.createConTestData();
        Contacts[0].Accountid=accounts[0].id;
        Contacts[1].Accountid=accounts[1].id;
        Contacts[2].Accountid=accounts[2].id;
        insert contacts;
       
        olstProject = TestDataUtility.createProjectTestData();
        insert olstProject;
        
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].Accountid = accounts[0].id;
        olstOpportunity[0].Project_Name__c =olstProject[0].id;
        insert olstOpportunity;  
        
        Test.startTest(); 
        list<Quote__c> lstQuote = new list <Quote__C>();

      
         
        Quote__c q1 = new Quote__c();
        q1.Name = 'Test Quote';
        q1.Opportunity__c = olstOpportunity[0].id;
        q1.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q1.Actual_Delivery_Date__c = date.today();
        q1.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q1.Contact__c = contacts[0].id;
        //q1.Balanced_Received_Date__c = Date.today();
        
         
       // lstQuote.add(q1);
        insert q1;
         
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'CERO'; 
        qd.quote__c = q1.id;
        qDetail.add(qd); 
        insert qDetail;
          
        warranties__c entwar =  new warranties__c(Name='HSW66');
        insert entwar;
         
        q1.Balanced_Received_Date__c = Date.today();
        update q1;
    
        entitlementBatch en = new entitlementBatch();
        Database.executeBatch(en);
        
          Test.stopTest();
           
    }
   
    static testMethod void QuoteTriggerHelper_Test6() {
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;

        list < Account > accountlst = new list < Account > ();
        Account a = new Account();
        a.Name = 'Test account';
        a.Phone = '(123) 456-7890';
        //a.Name = 'Test account';
        a.BillingState = 'Maine';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'stow';
        a.Type = 'Interior Designer';
        accountlst.add(a);
        
        Account a1 = new Account();
        a1.Name = 'Test account';
        a1.Phone = '(123) 456-7890';
        //a.Name = 'Test account';
        a1.BillingState = 'Maine';
        a1.BillingCountryCode = 'US';
        a1.BillingPostalCode = '12345';
        a1.BillingStreet = 'xyz street';
        a1.BillingCity = 'stow';
        a1.Type = 'Interior Designer';
        accountlst.add(a1);
        
        insert accountlst;
        
        contacts = TestDataUtility.createConTestData();
        Contacts[0].Accountid=accountlst[0].id;
        Contacts[1].Accountid=accountlst[1].id;
        //Contacts[2].Accountid=accountlst[2].id;
        insert contacts;

        list < Project__c > projlst = new list < Project__c > ();


        Project__c p1 = new Project__c();
        //p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project';
        p1.RecordTypeid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p1.Application__c = 'MultiFamily - new';
        p1.Application_2__c = 'Living Room';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Architect_Account__c = accountlst[0].id;
        //p1.RecordTypeid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        projlst.add(p1);
        
        Project__c p2 = new Project__c();
        //p1.recordtypeId='012K0000000DKP0IAO';
        p2.Name = 'Test Project';
        p2.RecordTypeid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p2.Application__c = 'MultiFamily - new';
        p2.Application_2__c = 'Living Room';
        p2.Project_Zip_Code__c = '12345';
        p2.Project_Country__c = 'United States';
        p2.Architect_Account__c = accountlst[1].id;

        projlst.add(p2);

        insert projlst;
     
        List < Opportunity > oppslist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.Project_Name__c = Projlst[0].Id;
        o.AccountId= accountlst[0].id;
        o.StageName = 'quoted';
        o.Amount = 1000;
        oppslist.add(o);


        Opportunity p = new Opportunity();
        p.Name = 'Test OppInflu';
        p.StageName = 'Need Analysis';
        p.CloseDate = Date.today();
        p.Country__c = 'USA';
        p.Postal_Code__c = 'TEST';
        p.Project_Name__c = Projlst[0].Id;
        p.AccountId =accountlst[1].id;
        p.StageName = 'Drawings - Requested';
        p.Amount = 1000;
        p.RecordTypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Influencer Opportunity').getRecordTypeId();
        oppslist.add(p);
        insert oppslist;

        test.startTest();
        
        list < Quote__c > lstQuote = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'test';
        q.Opportunity__c = oppslist[0].Id;
        q.Primary_Quote__c = true;
        q.Viewed__c = true;
        q.Ordered__c = true;
        q.Order_Confirmation_Sent__c = Date.today()-2;
        q.Complete_Signoff_Date__c = Date.today()-1;
        q.Deposit_Amount__c = 1200;
        q.Deposit_Date__c = Date.today()-1;
        q.order_Number__c = 12;
        q.Contact__c = contacts[0].id;
    //    q.Send_Quote_to_Installer__c = TRUE ;
        lstQuote.add(q);

        Quote__c qInflu = new Quote__c();
        qInflu.Name = 'testInflu';
        qInflu.Opportunity__c = oppslist[0].Id;
        qInflu.Primary_Quote__c = true;
        qInflu.Viewed__c = true;
        qInflu.Ordered__c = true;
        qInflu.Order_Confirmation_Sent__c = Date.today();
        qInflu.Complete_Signoff_Date__c = Date.today();
        qInflu.Deposit_Amount__c = 100;
        qInflu.Contact__c = contacts[1].id;
        qInflu.Deposit_Date__c = Date.today();
        lstQuote.add(qInflu);
        insert lstQuote;
        
        
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
      
        qd.Model__c = 'HSW 60'; 
        qd.quote__c = lstQuote[0].id;
        qd.price__c= 140;
        qDetail.add(qd);  
        
        Quote_Detail__c qd1 = new Quote_Detail__c();
      
        qd1.Model__c = 'HSW 66'; 
        qd1.price__C = 10;
        qd1.quote__c = lstQuote[1].id;
        qDetail.add(qd1);
        
        insert qDetail;
        
      
        // catch(Exception e){}
        Set < Id > projIds = new Set < Id > ();
         map<id,String > mapamt = new map<Id,String>();

        for (Project__c pro: Projlst) {
            projIds.add(pro.Id);
        //    mapStage.put(proj.Id)
        }
        
       // QuoteTriggerHelper.recalculateProjectAmount(projIds);

        Set < Id > oppIds = new Set < Id > ();
        map < Id, String > mapStage = new map < Id, String > ();

        for (Opportunity opp: oppslist) {
            oppIds.add(opp.Id);
            mapStage.put(opp.Id, opp.Stagename);
        }
       
        Map<ID, Decimal> MapProjectOpp = new Map<ID, Decimal>();
       
        for(Opportunity opp1: oppslist)
        {
            mapProjectOpp.put(opp1.Project_Name__c,opp1.amount);
        }
        
        
        QuoteTriggerHelper.updateOppAmount(oppIds,mapStage);
        QuoteTriggerHelper.recalculateProjectAmount(projIds);
        QuoteTriggerHelper.reCalculateProjectAmtOnOrders(MapProjectOpp);
        
        test.stopTest();
    }

  
    static testMethod void QuoteTriggerHelper_Test7() {
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;

        list < Account > accountlst = new list < Account > ();
        Account a = new Account();
        a.Name = 'Test account';
        a.Phone = '(123) 456-7890';
        a.BillingState = 'Maine';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'stow';
        a.Type = 'Interior Designer';
        accountlst.add(a);
        
        Account a1 = new Account();
        a1.Name = 'Test account';
        a1.Phone = '(123) 456-7890';
        a1.BillingState = 'Maine';
        a1.BillingCountryCode = 'US';
        a1.BillingPostalCode = '12345';
        a1.BillingStreet = 'xyz street';
        a1.BillingCity = 'stow';
        a1.Type = 'Interior Designer';
        accountlst.add(a1);
        
        insert accountlst;
        
        contacts = TestDataUtility.createConTestData();
        Contacts[0].Accountid=accountlst[0].id;
        Contacts[1].Accountid=accountlst[1].id;
        //Contacts[2].Accountid=accountlst[2].id;
        insert contacts;

        list < Project__c > projlst = new list < Project__c > ();


        Project__c p1 = new Project__c();
        //p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Architect_Account__c = accountlst[0].id;

        projlst.add(p1);
        
        Project__c p2 = new Project__c();
        //p1.recordtypeId='012K0000000DKP0IAO';
        p2.Name = 'Test Project';
        p2.Application__c = 'Automotive';
        p2.Application_2__c = 'Dealership';
        p2.Project_Zip_Code__c = '12345';
        p2.Project_Country__c = 'United States';
        p2.Architect_Account__c = accountlst[1].id;

        projlst.add(p2);

        insert projlst;
     
        List < Opportunity > oppslist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.Project_Name__c = Projlst[0].Id;
        o.AccountId= accountlst[0].id;
        o.StageName = 'quoted';
        o.Amount = 1000;
        oppslist.add(o);


        /*Opportunity p = new Opportunity();
        p.Name = 'Test OppInflu';
        p.StageName = 'Need Analysis';
        p.CloseDate = Date.today();
        p.Country__c = 'USA';
        p.Postal_Code__c = 'TEST';
        p.Project_Name__c = Projlst[0].Id;
        p.AccountId =accountlst[1].id;
        p.StageName = 'Drawings - Requested';
        p.Amount = 1000;
        p.RecordTypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Influencer Opportunity').getRecordTypeId();
        oppslist.add(p);*/
        insert oppslist;

        test.startTest();
        
        list < Quote__c > lstQuote = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'test';
        q.Opportunity__c = oppslist[0].Id;
        q.Primary_Quote__c = False;
        q.Viewed__c = true;
        //q.Ordered__c = true;
        q.Order_Confirmation_Sent__c = Date.today()-2;
        q.Complete_Signoff_Date__c = Date.today()-1;
        q.Deposit_Amount__c = 1200;
        q.Deposit_Date__c = Date.today()-1;
        q.order_Number__c = 0;
        q.Contact__c = contacts[0].id;
      //  q.Send_Quote_to_Installer__c = TRUE ;
        lstQuote.add(q);

        /*Quote__c qInflu = new Quote__c();
        qInflu.Name = 'testInflu';
        qInflu.Opportunity__c = oppslist[0].Id;
        qInflu.Primary_Quote__c = False;
        qInflu.Viewed__c = true;
        qInflu.Ordered__c = true;
        qInflu.Order_Confirmation_Sent__c = Date.today();
        qInflu.Complete_Signoff_Date__c = Date.today();
        qInflu.Deposit_Amount__c = 100;
        qInflu.Contact__c = contacts[1].id;
        qInflu.Deposit_Date__c = Date.today();
        lstQuote.add(qInflu);*/
        insert lstQuote;
        
        
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
      
        qd.Model__c = 'HSW 60'; 
        qd.quote__c = lstQuote[0].id;
        //qd.Unit_Subtotal__c = 120;
        qd.Price__c = 120;
        qDetail.add(qd);  
        
       /* Quote_Detail__c qd1 = new Quote_Detail__c();
      
        qd1.Model__c = 'HSW 66'; 
        qd1.Unit_Subtotal__c = 120;
        qd1.quote__c = lstQuote[1].id;
        qDetail.add(qd1);*/
        
        insert qDetail;
        
      
      
        Set < Id > projIds = new Set < Id > ();
         map<id,String > mapamt = new map<Id,String>();

        for (Project__c pro: Projlst) {
            projIds.add(pro.Id);
       
        }
        
      

        Set < Id > oppIds = new Set < Id > ();
        map < Id, String > mapStage = new map < Id, String > ();

        for (Opportunity opp: oppslist) {
            oppIds.add(opp.Id);
            mapStage.put(opp.Id, opp.Stagename);
        }
       
        Map<ID, Decimal> MapProjectOpp = new Map<ID, Decimal>();
       
        for(Opportunity opp1: oppslist)
        {
            mapProjectOpp.put(opp1.Project_Name__c,opp1.amount);
        }
        
        
        QuoteTriggerHelper.updateOppAmount(oppIds,mapStage);
        QuoteTriggerHelper.recalculateProjectAmount(projIds);
        QuoteTriggerHelper.reCalculateProjectAmtOnOrders(MapProjectOpp);
        
        test.stopTest();
    }
    
    
        static testMethod void QuoteTriggerHelper_Test8() {
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;

        list < Account > accountlst = new list < Account > ();
        Account a = new Account();
        a.Name = 'Test account';
        a.Phone = '(123) 456-7890';
        //a.Name = 'Test account';
        a.BillingState = 'Maine';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'stow';
        a.Type = 'Interior Designer';
        accountlst.add(a);
        
        Account a1 = new Account();
        a1.Name = 'Test account';
        a1.Phone = '(123) 456-7890';
        //a.Name = 'Test account';
        a1.BillingState = 'Maine';
        a1.BillingCountryCode = 'US';
        a1.BillingPostalCode = '12345';
        a1.BillingStreet = 'xyz street';
        a1.BillingCity = 'stow';
        a1.Type = 'Interior Designer';
        accountlst.add(a1);
        
        insert accountlst;
        
        contacts = TestDataUtility.createConTestData();
        Contacts[0].Accountid=accountlst[0].id;
        Contacts[1].Accountid=accountlst[1].id;
        //Contacts[2].Accountid=accountlst[2].id;
        insert contacts;

        list < Project__c > projlst = new list < Project__c > ();


        Project__c p1 = new Project__c();
        //p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project';
        p1.RecordTypeid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '12345';
        p1.Project_Country__c = 'United States';
        p1.Architect_Account__c = accountlst[0].id;
        //p1.RecordTypeid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        projlst.add(p1);
        
        Project__c p2 = new Project__c();
        //p1.recordtypeId='012K0000000DKP0IAO';
        p2.Name = 'Test Project';
        p2.RecordTypeid = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        p2.Application__c = 'Automotive';
        p2.Application_2__c = 'Dealership';
        p2.Project_Zip_Code__c = '12345';
        p2.Project_Country__c = 'United States';
        p2.Architect_Account__c = accountlst[1].id;

        projlst.add(p2);

        insert projlst;
     
        List < Opportunity > oppslist = new List < Opportunity > ();
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.Project_Name__c = Projlst[0].Id;
        o.AccountId= accountlst[0].id;
        o.StageName = 'quoted';
        o.Amount = 1000;
        oppslist.add(o);


        Opportunity p = new Opportunity();
        p.Name = 'Test OppInflu';
        p.StageName = 'Need Analysis';
        p.CloseDate = Date.today();
        p.Country__c = 'USA';
        p.Postal_Code__c = 'TEST';
        p.Project_Name__c = Projlst[0].Id;
        p.AccountId =accountlst[1].id;
        p.StageName = 'Drawings - Requested';
        p.Amount = 1000;
        p.RecordTypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Influencer Opportunity').getRecordTypeId();
        oppslist.add(p);
        insert oppslist;

        test.startTest();
        
        list < Quote__c > lstQuote = new list < Quote__c > ();
        Quote__c q = new Quote__c();
        q.Name = 'test';
        q.Opportunity__c = oppslist[0].Id;
        q.Primary_Quote__c = true;
        q.Viewed__c = true;
        q.Ordered__c = true;
        q.Order_Confirmation_Sent__c = Date.today()-2;
        q.Complete_Signoff_Date__c = Date.today()-1;
        q.Deposit_Amount__c = 1200;
        q.Deposit_Date__c = Date.today()-1;
        q.order_Number__c = 12;
        q.Contact__c = contacts[0].id;
     //   q.Send_Quote_to_Installer__c = TRUE ;
        lstQuote.add(q);

        Quote__c qInflu = new Quote__c();
        qInflu.Name = 'testInflu';
        qInflu.Opportunity__c = oppslist[0].Id;
        qInflu.Primary_Quote__c = true;
        qInflu.Viewed__c = true;
        qInflu.Ordered__c = true;
        qInflu.Order_Confirmation_Sent__c = Date.today();
        qInflu.Complete_Signoff_Date__c = Date.today();
        qInflu.Deposit_Amount__c = 100;
        qInflu.Contact__c = contacts[1].id;
        qInflu.Deposit_Date__c = Date.today();
        lstQuote.add(qInflu);
        insert lstQuote;
        
        
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
      
        qd.Model__c = 'HSW 60'; 
        qd.quote__c = lstQuote[0].id;
        qd.price__c= 140;
        qDetail.add(qd);  
        
        Quote_Detail__c qd1 = new Quote_Detail__c();
      
        qd1.Model__c = 'HSW 66'; 
        qd1.price__C = 10;
        qd1.quote__c = lstQuote[1].id;
        qDetail.add(qd1);
        
        insert qDetail;
        
      
        // catch(Exception e){}
        Set < Id > projIds = new Set < Id > ();
         map<id,String > mapamt = new map<Id,String>();

        for (Project__c pro: Projlst) {
            projIds.add(pro.Id);
        //    mapStage.put(proj.Id)
        }
        
       // QuoteTriggerHelper.recalculateProjectAmount(projIds);

        Set < Id > oppIds = new Set < Id > ();
        map < Id, String > mapStage = new map < Id, String > ();

        for (Opportunity opp: oppslist) {
            oppIds.add(opp.Id);
            mapStage.put(opp.Id, opp.Stagename);
        }
       
        Map<ID, Decimal> MapProjectOpp = new Map<ID, Decimal>();
       
        for(Opportunity opp1: oppslist)
        {
            mapProjectOpp.put(opp1.Project_Name__c,opp1.amount);
        }
        
        
        QuoteTriggerHelper.updateOppAmount(oppIds,mapStage);
        QuoteTriggerHelper.recalculateProjectAmount(projIds);
        QuoteTriggerHelper.reCalculateProjectAmtOnOrders(MapProjectOpp);
        
        test.stopTest();
    }


}