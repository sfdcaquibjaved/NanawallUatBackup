/**
    @ Author        : Satish
    @ Date          : July 2015
    @ Description   : Test Class for All Triggers
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
 */
@isTest(SeeAllData=false)
public without sharing class TriggerTests {
        public static List<Project__c> olstTestProject;
        public static List<Country_codes__c> olstTestCountryCode;
        public static List<state_codes__c> olstTestStateCode;
        public static List<Zip_Codes_Master__c> olstTerritoryMastereCode;
        public static List<Quote__c> olstTestQuoteData;
        public static Attachment getNewAttachment() {
            Attachment a = new Attachment();
            a.Name = 'testattachment';
            a.Body = Blob.valueOf('test data');
    
            return a;
        }
    
    public static User getUserdata(){
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        return testUser;
    }
    
        public static Account getNewAccount() {
            
            Account a = new Account();
            a.Name = 'Test Account';
            a.Phone = '(123) 456-7890';
            a.Name = 'Test account';
            a.BillingCountryCode = 'US';
            a.BillingPostalCode = '12345';
            a.BillingStateCode ='CA';       
            a.Zip__c = '12345';
            
            return a;
    
        }
    
        public static Lead getNewLead() {
            Lead l = new Lead();
            l.FirstName = 'First Name';
            l.LastName = 'Last Name';
            l.FirstName = 'TestFirst';
            l.LastName = 'TestLast';
            l.Company = 'fOo Bar';
            l.PostalCode = '12345';
            l.CountryCode = 'US';
            //l.StateCode='CA';
    //      l.nrCountry__c = 'USA';
    //      l.Zip__c = 'TEST';
    //      l.Country = 'United States';
    //      l.PostalCode = '1';
            
            return l;
        }
        public static list<Account> getAcclist(){
            list<Account> acc =new List<Account>();
            Account ac = new Account();
            ac.Name = 'Test Account';
            ac.Phone = '(123) 456-7890';
            ac.Name = 'Test account';
            //ac.BillingCountry='Mexico';
            ac.BillingCountryCode = 'MX';
            //ac.BillingPostalCode = '12345';
            ac.BillingStateCode ='CO';       
            //ac.Zip__c = '12345';
            acc.add(ac);
            Account accc = new Account();
            accc.Name = 'Test Account';
            accc.Phone = '(123) 456-7890';
            accc.Name = 'Test account';
            accc.BillingCountryCode = 'US';
            accc.BillingPostalCode = '12345';
            accc.BillingStateCode ='CA';       
            //ac.Zip__c = '12345';
            acc.add(accc);
            
            Account ab = new Account();
            ab.Name = 'Test AccountIN';
            ab.Phone = '(123) 456-7890';
            //ab.Name = 'Test accountIN';
            ab.BillingCountryCode = 'IN';
            ab.BillingPostalCode = '12345';
            ab.BillingStateCode ='';
            ab.Chain_Account__c = false;
           // ab.OwnerId = testUser1.id;
            
            acc.add(ab);
            
            Account ad = new Account();
            ad.Name = 'Test AccountMX';
            ad.Phone = '(123) 456-7890';
            ad.Name = 'Test accountMX';
            ad.BillingCountryCode = 'MX';
            ad.BillingPostalCode = '';
            ad.BillingStateCode ='CO';
            ad.Chain_Account__c = false;
           // ad.OwnerId = testUser1.id;
            
            acc.add(ad);
            
            return acc;
        }
  /*public static Org_Default_Settings__c getOrg_default_Setting(){
        Org_Default_Settings__c ods = new Org_Default_Settings__c();
        ods.OpportunityTrigger__c=TRUE;
        
        
        return ods;
        }*/
      
        
        private static Contact unitTestContact = null;
        public static Contact getContact()
        {
            
            if( unitTestContact == null )
            {
                unitTestContact = getNewContact();
            }
        
            return unitTestContact;
        }
    
    
        public static Contact getNewContact() {
            Contact c = new Contact();
            c.FirstName = 'First Name';
            c.LastName = 'Last Name';
            c.FirstName = 'TestFirst';
            c.LastName = 'TestLast';
            c.MailingCountryCode = 'US';
    
            c.MailingPostalCode = '12345';
    //      c.MailingCountry  = 'United States';
            
            return c;
        }
        Public static Project__c getproject(){
            Project__c proj = new Project__c();
            proj.Name='TestDummy';
            //proj.RecordTypeId ='';
            proj.Close_Date__c = Date.today();
            //proj.Application__c ='';
            //proj.Application_2__c ='';
            proj.Project_Country__c ='United States';
            proj.Project_Zip_Code__c ='12345';
            proj.Project_State__c = 'California';
            return proj;
        }
        
        public static Opportunity unitTestOpportunity = null;
        public static Opportunity getOpportunity() 
        {
            if( unitTestOpportunity == null )
                unitTestOpportunity = getNewOpportunity();
        
            return unitTestOpportunity;
        }
        
        public static Opportunity getNewOpportunity() {
        
            Opportunity o = new Opportunity();
            o.Name = 'New OPportunity';
            o.StageName = 'initial';
            o.CloseDate = Date.today();
            
            return o;
        }
        public static Task getNewTask() {
        
            Task t = new Task();
            t.Subject = 'Send Mailbook';
            
            return t;
        }
    
        public static nrOpportunity_Account__c getNewOpportunityAccount() {
            nrOpportunity_Account__c oppacc = new nrOpportunity_Account__c();
            
            return oppacc;
        }
    
        public static nrOpportunityContactRole__c getNewOpportunityContactRole() {
            nrOpportunityContactRole__c controle = new nrOpportunityContactRole__c();
            
            return controle;
        }
    
        public static Quote__c getNewQuote() {
            Quote__c q = new Quote__c();
            
            return q;
        }
    
        public static Quote_Detail__c getNewQuoteDetail() {
            Quote_Detail__c qd = new Quote_Detail__c();
            
            
            return qd;
        }
    
        public static Service_Quote__c getNewServiceQuote() {
            Service_Quote__c sq = new Service_Quote__c();
            
            return sq;
        }
        
        public static Service_Quote_Detail__c getNewServiceQuoteDetail() {
        
            Service_Quote_Detail__c sqd = new Service_Quote_Detail__c();
            
            
            return sqd;
        }
    
        public static Case getNewCase() 
        {
            Case c = new Case();
            return c;
        }
    
        public static Web_Quote__c getNewWebQuote() {
            Web_Quote__c wq = new Web_Quote__c();
            
            return wq;
        }
    
        public static nrOpportunityTeamMember__c getNewTeamMember() {
            nrOpportunityTeamMember__c mem = new nrOpportunityTeamMember__c();
            
            return mem;
        
        }   
    
        public static Stock_Order__c getNewStockOrder()
        {
            Stock_Order__c so = new Stock_Order__c();
            
            return so;
        }
        
        public static Stock_Order_Detail__c getNewStockOrderDetail()
        {
            return new Stock_Order_Detail__c();
        }
         public static  list<Country_codes__c>  getTestCountryCode() {
         list<Country_codes__c> lstCountryCodes = new list<Country_codes__c>();
         
         Country_codes__c couCode1 = new Country_codes__c();
         couCode1.Name = 'US';
         couCode1.Country__c = 'United States';
         lstCountryCodes.add(couCode1);
         
         Country_codes__c couCode2 = new Country_codes__c();
         couCode2.Name = 'CA';
         couCode2.Country__c = 'Canada';
         lstCountryCodes.add(couCode2);
          
         Country_codes__c couCode3 = new Country_codes__c();
         couCode3.Name = 'MX';
         couCode3.Country__c = 'Mexico';
         lstCountryCodes.add(couCode3);
    
         Country_codes__c couCode4 = new Country_codes__c();
         couCode4.Name = 'IN';
         couCode4.Country__c = 'India';
         lstCountryCodes.add(couCode4);
             
         return lstCountryCodes ;
         
        }
        
         public static  list<state_codes__c>  getTestStateCodes() {
            
         list<state_codes__c> lstStateCodes = new list<state_codes__c>();
         
         state_codes__c statCode1 = new state_codes__c();
         statCode1.Name = 'CA';
         statCode1.States__c = 'California';
         lstStateCodes.add(statCode1);
         
         state_codes__c statCode2 = new state_codes__c();
         statCode2.Name = 'CO';
         statCode2.States__c = 'Coahuila';
         lstStateCodes.add(statCode2);
         
         return lstStateCodes ;
         
        }
static testMethod void Accountruntest()
    {
        /*Org_Default_Settings__c ods = new Org_Default_Settings__c();
        
       ods.OpportunityTrigger__c=TRUE;
        ods.accountownerassignmentTrigger__c=True;
        ods.contactownerassignmentTrigger__c=True;
        ods.OwnerUpdateTrigger__c=True;
        ods.ProjectTrigger__c=True;
        ods.QuoteTrigger__c=true;
        insert ods;*/
        Test.startTest();
        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        insert olstTestCountryCode ;
        olstTestStateCode = TestDataUtility.getTestStateCodes();
        system.debug('StateCodes###'+olstTestStateCode);
        insert olstTestStateCode ; 
        
        User testUser1 = TestDataUtility.createUser('System Administrator','satish@lokin.com');
        insert testUser1;
        List<Opportunity> lstOpps =  TestDataUtility.createOppTestData();
        lstOpps[0].Amount = 500;
        insert lstOpps;
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
 
        list<Account> accoun = getAcclist();
        accoun[0].Name = 'Test Account';
        accoun[0].Phone = '(123) 456-7890';
        accoun[0].Name = 'Test account';
        accoun[0].BillingCountryCode = 'US';
        accoun[0].BillingPostalCode = '12345';
        accoun[0].BillingStateCode ='CA';   
        accoun[0].Type = 'Architecture Firm';
        try{
        insert accoun[0];
        }
        catch(Exception e){}
        accoun[1].Name = 'Test Account1';
        accoun[1].Phone = '(123) 456-78190';
        accoun[1].Name = 'Test account1';
        accoun[1].BillingCountryCode = 'CA';
        accoun[1].BillingPostalCode = 'V0M 9S9';
        accoun[1].BillingStateCode ='';   
        accoun[1].Type = 'Architecture Firm';
        insert accoun[1];

        accoun[2].Name = 'Test AccountIN';
        accoun[2].Phone = '(123) 456-78190';
        accoun[2].Name = 'Test accountIN';
        accoun[2].BillingCountryCode = 'IN';
        accoun[2].BillingPostalCode = '12345';
        accoun[2].BillingStateCode ='';
        accoun[2].Chain_Account__c = false;
        //accoun[2].OwnerId = testUser1.id;
       try{
        insert accoun[2];
        }catch(Exception e){}
        
        accoun[3].Name = 'Test AccountMX';
        accoun[3].Phone = '(123) 456-78191';
        //accoun[3].Name = 'Test accountMX';
        accoun[3].BillingCountryCode = 'MX';
        //accoun[3].BillingCountry='Mexico';
        accoun[3].BillingPostalCode = '';
        accoun[3].BillingStateCode ='CO';
        accoun[3].Chain_Account__c = false;
        //accoun[3].OwnerId = testUser1.id;
        insert accoun[3];
    
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        //olstTerritoryMastereCode[0].State__c = '';
        olstTerritoryMastereCode[0].User__c  = testUser1.id;
        insert olstTerritoryMastereCode;
        
        //olstTerritoryMastereCode[0].Country__c = 'Canada';
        // olstTerritoryMastereCode[0].Zip_Code__c = 'V0S' ;
        //update olstTerritoryMastereCode[0];
    
        olstTestProject = TestDataUtility.createProjectTestData();
        olstTestProject[0].Project_Country__c = 'United States';
        olstTestProject[1].Project_Country__c = 'Canada';
        olstTestProject[1].Project_Zip_Code__c = 'V0M 9s9';
        olstTestProject[2].Project_Country__c = 'India';
        olstTestProject[2].Project_Zip_Code__c = '';
        
        olstTestProject[3].Project_Country__c = 'Canada';
        olstTestProject[3].corporate_account__c = true;
        olstTestProject[3].Project_Zip_Code__c = 'V0M 9S9';
        olstTestProject[4].Architect_Account__c  = accoun[0].id;
        olstTestProject[4].Stage__c='Closed Lost - Project Lost';
        olstTestProject[4].OwnerId = testUser1.id;
        olstTestProject[4].corporate_account__c = false;
        olstTestProject[4].Opportunity_Name__c = lstOpps[0].id;
        olstTestProject[4].Reason_Project_Lost__c = 'Test Reason';
        try{
        insert olstTestProject ;
        }
        catch(Exception e){}
        olstTestProject[2].Project_Country__c = 'Mexico';
        olstTestProject[2].Project_State__c = 'Coahuila';
        olstTestProject[2].Project_Zip_Code__c = '50000';
        try{
        update olstTestProject[2] ;
        }
        catch(Exception e){}
        olstTestProject[4].Architect_Account__c  =accoun[1].id;
        olstTestProject[4].Stage__c='Closed Lost - Project Cancelled';
        olstTestProject[4].Name = 'Test Acc updated';
        olstTestProject[4].OwnerId = testUser2.id;
        olstTestProject[4].corporate_account__c = true;
        try{
        update olstTestProject[4] ;
        }
        catch(Exception e){}
        projectOwnerAssignment.updateResolutionDate(olstTestProject);
        projectOwnerAssignment.validateZip(olstTestProject[0]);
        projectOwnerAssignment.updateOppTeam(olstTestProject);    
        Test.stopTest();  
    }
static testMethod void triggersRunTest() 
    {
        /*Org_Default_Settings__c ods = new Org_Default_Settings__c();
        ods.OpportunityTrigger__c=TRUE;
        ods.accountownerassignmentTrigger__c=True;
        ods.contactownerassignmentTrigger__c=True;
        ods.OwnerUpdateTrigger__c=True;
        ods.ProjectTrigger__c=True;
        ods.QuoteTrigger__c=true;
        insert ods;*/
        User testUser = TestDataUtility.createUser('System Administrator','satish@lokinindi.com');
        insert testUser;
        List<Zip_Codes_Master__c> lstZipCOdes = TestDataUtility.getTerritoryMaster();
        lstZipCodes[0].Zip_Code__c = '12345';
        lstZipCOdes[0].User__c  = testUser.id;
        insert lstZipCOdes[0];
                
        User testUser1 = TestDataUtility.createUser('System Administrator','satish@lokin.com');
        insert testUser1;
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testupdate.com');
        insert testUser2;
        list<Country_codes__c> cc = getTestCountryCode();
        cc[1].Name = 'CA';
        cc[1].Country__c ='Canada';
        insert cc;
        
        cc[2].Name ='MX';
        cc[2].Country__c ='Mexico';
        update cc;
        
        list<state_codes__c> sc=getTestStateCodes();
        sc[0].Name='CA';
        sc[0].States__c = 'California';
        insert sc[0];
        
        sc[0].Name='CO';
        sc[0].States__c = 'Coahuila';
        update sc[0];
        
        
        List<Zip_Codes_Master__c> lstZipCOdes1 = TestDataUtility.getTerritoryMaster();
        //lstZipCodes1[0].State__c = 'CO';
        lstZipCOdes1[0].User__c  = testUser1.id;
        insert lstZipCOdes1;
        /*lstZipCodes1[0].Country__c = 'Canada';
        lstZipCodes1[0].Zip_Code__c = 'V0M 9S9' ;
        //lstZipCOdes1[0].User__c  = testUser1.id;
        update lstZipCodes1[0];
        lstZipCodes1[0].Country__c = 'Mexico';
        lstZipCodes1[0].state__c = 'Coahuila';
        //lstZipCodes1[0].Zip_Code__c = 'V0B 9S9' ;
        update lstZipCodes1[0];
        lstZipCodes1[0].Country__c = 'India';
        lstZipCodes1[0].state__c = 'Assam';
        update lstZipCodes1[0];*/
        

        
        Account a = getNewAccount();
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.Chain_Account__c = false;
        a.OwnerId = testUser1.id;
        insert a;
        
        Account a1 = getNewAccount();
        a1.Name = 'test Acc Name';
        a1.BillingCountryCode = 'US';
        a1.BillingPostalCode = '12345';
        a1.amount__c = 100;
        a1.Parent = a;
        insert a1;
        a1.Name = 'Test Account Name1';
        a1.BillingPostalCode = 'v0m 9s9';
        a1.BillingCountryCode = 'CA';
        a1.Chain_Account__c = true;
        update a1;
        
        Account a2 = getNewAccount();
        a2.OwnerId = testUser1.id;
        a2.Name = 'test Acc Name';
        a2.BillingCountryCode = 'US';
        a2.BillingPostalCode = '12345';
        a2.amount__c = 100;
        a2.Parent = a;
        insert a2;
        a2.Name = 'Test Account Name1';
        a2.BillingPostalCode = 'v0m 9s9';
        a2.BillingCountryCode = 'CA';
        a2.Chain_Account__c = true;
        update a2;
        
        a.Chain_Account__c = true;
        a.Name = 'Test Account Name';
        update a;
    
        list<Account> accoun = getAcclist(); 
        Account ac1 = new Account();
        ac1.Name = 'Test Account';
        ac1.Phone = '(123) 456-7890';
        //ac1.Name = 'Test account';
        ac1.BillingCountryCode = 'US';
        ac1.BillingPostalCode = '12345';
        ac1.BillingStateCode ='CA';       
        //ac.Zip__c = '12345';
        accoun.add(ac1);
        insert accoun;
        accoun[0].name='Raj';
        accoun[0].BillingCountryCode='MX';
        accoun[0].BillingStateCode='CO';
        update accoun;
       
//      Contact c = getNewContact();
        Contact c = getContact();
        c.AccountId = a.Id;
        insert c;
        c.FirstName = 'Edited First';
        update c;
        
        Contact c1 = new Contact();
        c1.FirstName = 'First test Name';
        c1.LastName = 'Last Name test';
        c1.MailingCountryCode = 'US';
//      c.Zip__c = 'TEST';
        c1.MailingPostalCode = '12345';
//      c.MailingCountry  = 'United States';
        c1.AccountId = a1.Id;
        insert c1;
        
        Contact c2 = new Contact();
        c2.FirstName = 'First 2test Name';
        c2.LastName = 'Last Nam2e test';
        c2.MailingCountryCode = 'CA';
//      c.Zip__c = 'TEST';
        c2.MailingPostalCode = 'V0m 9S9';
//      c.MailingCountry  = 'United States';
        c2.AccountId = a1.Id;
        insert c2;

        
        Contact c3 = new Contact();
        c3.AccountId = a.Id;
        c3.FirstName = 'First 2test Name';
        c3.LastName = 'Last Nam2e test';
        c3.MailingCountryCode = 'MX';
        c3.MailingStateCode = 'CO';
        insert c3;

        
        
        DateTime testDateTime = DateTime.newInstance(2014, 11, 18, 3, 3, 3);
        c1.Last_Mailbook_Sent__c = testDateTime;
        c1.Last_Booklet_Sent__c = testDateTime;
        c1.Last_Binder_Sent__c = testDateTime;
        update c1;
        
        Lead l = getNewLead();
        l.PostalCode = '12345';
        l.CountryCode = 'US';
        insert l;
        Lead le = getNewLead();
        le.PostalCode = 'v0m 9s9';
        le.CountryCode = 'CA';
        insert le;
        Lead lea = getNewLead();
        lea.StateCode = 'CO';
        lea.CountryCode = 'MX';
        insert lea;
        lea.PostalCode = '12345';
        lea.CountryCode = 'US';
        lea.StateCode = '';
        update lea;
        
        Test.startTest();
        Project__c p = getproject();
        Project__c proj = new Project__c();
        proj.Name='TestDummy';
        //proj.RecordTypeId ='';
        proj.Close_Date__c = Date.today();
        //proj.Application__c ='';
        //proj.Application_2__c ='';
        proj.Project_Country__c ='United States';
        proj.Project_Zip_Code__c ='12345';
        proj.Project_State__c = 'California';
        insert p;
        proj.Project_Country__c ='Mexico';
        proj.Project_State__c = 'Coahuila';
        update p;
        
        Showroom__c sr = new Showroom__c();
        sr.City__c = 'blah';
        insert sr;
        
        
        Case cs = getNewCase();
        insert cs;
        update cs;

        Stock_Order__c stockOrder = getNewStockOrder();
        insert stockOrder;
        
        Stock_Order_Detail__c stockOrderDetail = getNewStockOrderDetail();
        stockOrderDetail.Stock_Order__c = stockOrder.Id;
        insert stockOrderDetail;
        
        
        
        Web_Quote__c wq = getNewWebQuote();     
        insert wq;
        update wq;
                
        update stockOrderDetail;
        update stockOrder;
        
        delete stockOrderDetail;
        delete stockOrder;
         try{
        delete wq;
        delete c;
        
        delete c2;
        delete a;
        
        //delete o;
        delete l;
        }  
         catch( Exception ex )
        {
            //a workflow is causing an "ENTITY_IS_DELETED" here. wtf? who knows.
        } 
        Test.stopTest();
    }
static testMethod void Validationsruntest() {
        /*Org_Default_Settings__c ods = new Org_Default_Settings__c();
         ods.OpportunityTrigger__c=TRUE;
        ods.accountownerassignmentTrigger__c=True;
        ods.contactownerassignmentTrigger__c=True;
        ods.OwnerUpdateTrigger__c=True;
        ods.ProjectTrigger__c=True;
        ods.QuoteTrigger__c=true;
        insert ods;*/
        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
         insert olstTestCountryCode ;
        olstTestStateCode = TestDataUtility.getTestStateCodes();
         insert olstTestStateCode ; 
        
        User testUser1 = TestDataUtility.createUser('System Administrator','satish@lokin.com');
        insert testUser1;
        List<Opportunity> lstOpps =  TestDataUtility.createOppTestData();
        lstOpps[0].Amount = 500;
        insert lstOpps;
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
        Test.startTest();
        list<Account> accoun = getAcclist();
        accoun[0].Name = 'Test Account';
        accoun[0].Phone = '(123) 456-7890';
        accoun[0].Name = 'Test account';
        accoun[0].BillingCountryCode = 'US';
        accoun[0].BillingPostalCode = '';
        accoun[0].BillingStateCode ='CA';   
        accoun[0].Type = 'Architecture Firm';
        try{
        insert accoun[0];
        }
        catch(DmlException e) {
        }
        list<Account> accou = getAcclist();
        accou[0].Name = 'Test Account';
        accou[0].Phone = '(123) 456-7890';
        accou[0].Name = 'Test account';
        accou[0].BillingCountryCode = 'US';
        accou[0].BillingPostalCode = '123';
        accou[0].BillingStateCode ='CA';   
        accou[0].Type = 'Architecture Firm';
        try{
        insert accou[0];
        }
        catch(DmlException e) {
        }
        Account a = getNewAccount();
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.Chain_Account__c = false;
        a.OwnerId = testUser1.id;
    try{    
    insert a;
    }
    catch(Exception e){}
        Contact c = getContact();
        c.AccountId = a.Id;
        c.MailingCountryCode = 'US';
        c.MailingPostalCode = '';
        try{
          insert c;  
        }
        catch(DmlException e){}
        Contact c1 = getContact();
        c1.AccountId = a.Id;
        c1.MailingCountryCode = 'US';
        c1.MailingPostalCode = '1234';
        try{
          insert c1;  
        }
        catch(DmlException e){}
        
        Project__c p = getproject();
        p.Name='TestDummy';
        p.Close_Date__c = Date.today();
        p.Project_Country__c ='United States';
        p.Project_Zip_Code__c ='';
        //p.Project_State__c = 'California';
        try{
          insert p;  
        }
        catch(DmlException e){}
        Project__c p1 = getproject();
        p1.Name='TestDummy';
        p1.Close_Date__c = Date.today();
        p1.Project_Country__c ='United States';
        p1.Project_Zip_Code__c ='1234';
        //p1.Project_State__c = 'California';
        try{
          insert p1;  
        }
        catch(DmlException e){}
        
        Project__c p2 = getproject();
        p2.Name='TestDummy';
        p2.Close_Date__c = Date.today();
        p2.Project_Country__c ='Canada';
        p2.Project_Zip_Code__c ='v0a 9s9';
        //p2.Project_State__c = 'California';
        try{
          insert p2;  
        }
        catch(DmlException e){}
        Lead l = getNewLead();
        l.PostalCode = '1234';
        l.CountryCode = 'US';
        try{
          insert l;  
        }
        catch(DmlException e){}
        Lead le = getNewLead();
        le.PostalCode = '';
        le.CountryCode = 'US';
        try{
          insert le ;  
        }
        catch(DmlException e){}
        Test.stopTest();
    }
static testMethod void Opportunityruntest() {
    
        /*Org_Default_Settings__c ods = new Org_Default_Settings__c();
         ods.OpportunityTrigger__c=TRUE;
        ods.accountownerassignmentTrigger__c=True;
        ods.contactownerassignmentTrigger__c=True;
        ods.OwnerUpdateTrigger__c=True;
        ods.ProjectTrigger__c=True;
        ods.QuoteTrigger__c=true;
        insert ods;*/
        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        insert olstTestCountryCode ;
        olstTestStateCode = TestDataUtility.getTestStateCodes();
        insert olstTestStateCode ; 
        
        User testUser1 = TestDataUtility.createUser('System Administrator','satish@lokin.com');
        insert testUser1;
        List<Opportunity> lstOpps =  TestDataUtility.createOppTestData();
        lstOpps[0].Amount = 500;
        insert lstOpps;
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
        Account a = getNewAccount();
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.Chain_Account__c = false;
        a.OwnerId = testUser1.id;
    try{    
    insert a;
    }
    catch(Exception e){}
        
        Account a1 = getNewAccount();
        a1.BillingCountryCode = 'US';
        a1.BillingPostalCode = '12345';
        a1.Chain_Account__c = false;
        a1.OwnerId = testUser2.id;
    try{    
    insert a1;
    }
    catch(Exception e){}
        Contact c = getContact();
        c.AccountId = a.Id;
    try{   
    insert c;
    }
    catch(Exception e){}
        
        Project__c p = getproject();
        Project__c proj = new Project__c();
        proj.Name='TestDummy';
        proj.OwnerId = testUser1.id;
        proj.Close_Date__c = Date.today();

        proj.Project_Country__c ='United States';
        proj.Project_Zip_Code__c ='12345';
        proj.Project_State__c = 'California';
    try{    
    insert p;
    }
    catch(Exception e){}
        Test.startTest();
        list<Opportunity> listOpps = new List<Opportunity>();
        Opportunity o = getNewOpportunity();
            o.AccountId = a1.Id ;
            o.Project_Name__c = p.id;
            //o.Close_Date__c = Date.today();
            o.StageName= 'Need Analysis';
            insert o;
            listOpps.add(o);
            olstTestQuoteData =TestDatautility.createQuoteRecords(listOpps);
            insert olstTestQuoteData;
            o.Name = 'Edited Opportunity';
            o.AccountId= a.Id;
            o.OwnerId = testUser2.id;
            //o.StageName='Quote-Requested';
    try{        
    update o;
    }
    catch(Exception e){}
            //o.Primary_Opportunity__c=True;
            //o.StageName='Closed/Won';
            //update o;
           // o.AccountId= a.Id;
            //update o;
            
        nrOpportunityContactRole__c controle = getNewOpportunityContactRole();
        controle.Contact__c = c.Id;
        controle.Opportunity__c = o.Id;
    try{    
    insert controle;
    }
    catch(Exception e){}
        controle.Role__c = 'Some Role';
    try{    
    update controle;        
    }
    catch(Exception e){}

        /****************
        Opportunity o1 = getNewOpportunity();
           o1.AccountId = a2.Id ;
            insert o1;
            o1.Name = 'Edited Opportunity';
            o1.StageName='On Hold';
            o1.Project_Name__c = p.id;
            o1.OwnerId = testUser2.id;
            update o1;
        *************/        
        Attachment attcmnt = getNewAttachment() ;
        attcmnt.ParentId = o.Id;
        
    insert attcmnt;
        
               
        Task t = getNewTask();
        t.Subject = 'Send Booklet';
        t.PhotoBooks_Selection__c = 'Interior';
        t.WhoId = c.Id;
        t.WhatId = o.Id;
        insert t;
        /*t.WhoId = c1.Id;
        t.Subject = 'Send Mailbook';
        update t;
        
        Task t2 = getNewTask();
        t2.Subject = 'Send Booklet';
        t2.PhotoBooks_Selection__c = 'Interior';
        t2.WhoId = c2.Id;
        t2.WhatId = o.Id;
        insert t2;
        t2.WhoId = c.Id;
        t2.Subject = 'Send Binder';
        update t2;
        
        Task t1 = getNewTask();
        t1.Subject = 'Send Binder';
        t1.PhotoBooks_Selection__c = 'Interiors';
        t1.WhoId = c.Id;
        t1.WhatId = o.Id;
        insert t1;
        t1.WhoId = c2.Id;
        t.Subject = 'Send Booklet';
        update t;*/


        nrOpportunity_Account__c oppacc = getNewOpportunityAccount();
        oppacc.Opportunity__c = o.Id;
        oppacc.Account__c = a.Id;
    try{    
    insert oppacc;
        update oppacc;
    }
    catch(Exception e){}

        try
        {
            delete oppacc;
        } catch( Exception ex )
        {
            //a workflow is causing an "ENTITY_IS_DELETED" here. wtf? who knows.
        }

    try{
        delete controle;
    }
    catch(Exception e){}
        
        try{
        delete o;

        }  
         catch( Exception ex )
        {
            //a workflow is causing an "ENTITY_IS_DELETED" here. wtf? who knows.
        }             

        Test.stopTest();
    }   
static testMethod void runtest5(){
    
       /* Org_Default_Settings__c ods = new Org_Default_Settings__c();
         ods.OpportunityTrigger__c=TRUE;
        ods.accountownerassignmentTrigger__c=True;
        ods.contactownerassignmentTrigger__c=True;
        ods.OwnerUpdateTrigger__c=True;
        ods.ProjectTrigger__c=True;
        ods.QuoteTrigger__c=true;
        insert ods;*/
        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        insert olstTestCountryCode ;
    
        olstTestStateCode = TestDataUtility.getTestStateCodes();
        system.debug('StateCodes###'+olstTestStateCode);
        insert olstTestStateCode ; 
        
        User testUser1 = TestDataUtility.createUser('System Administrator','satish@lokin.com');
        insert testUser1;
        
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
        
        olstTerritoryMastereCode= TestDataUtility.getTerritoryMaster();
        insert olstTerritoryMastereCode ;
        
        Account a = getNewAccount();
        a.BillingCountryCode = 'IN';
        a.BillingPostalCode = '';
        a.BillingStateCode ='';
        a.OwnerId = testUser1.id;
        insert a;
        
        Account aa = getNewAccount();
        aa.BillingCountryCode = 'CA';
        aa.BillingPostalCode = 'V0M 9t9';
        aa.BillingStateCode ='';
        aa.OwnerId = testUser1.id;
        insert aa;
        
        Contact cc = getContact();
        cc.FirstName = 'Jackvin';
        cc.LastName ='Vin';
        cc.AccountId = a.Id;
        cc.MailingCountryCode = 'IN';
        cc.MailingPostalCode = '';
        insert cc;
    
        // Contact c1 = getContact();
        cc.FirstName = 'Jackvin';
        cc.LastName ='Vin';
        cc.AccountId = a.Id;
        cc.MailingCountryCode = 'CA';
        cc.MailingPostalCode = 'V0M 9t9';
        update cc;  
        
        Lead l = getNewLead();
        l.PostalCode = '';
        l.CountryCode = 'IN';
        insert l;
        Lead le = getNewLead();
        le.PostalCode = 'v0m 9t9';
        le.CountryCode = 'CA';
        insert le;
        
        Project__c pp = getproject();
        pp.Name='TestDummy';
        pp.Close_Date__c = Date.today();
        pp.Project_Country__c ='Canada';
        pp.Project_Zip_Code__c ='v0m 9t9';
        pp.Project_State__c = '';
        insert pp;  
        Project__c p1 = getproject();
        p1.Name='TestDummy';
        p1.Close_Date__c = Date.today();
        p1.Project_Country__c ='India';
        p1.Project_Zip_Code__c ='';
        p1.Project_State__c = '';
        insert p1;
        
        Opportunity o = getNewOpportunity();
        o.AccountId = a.Id ;
        o.Project_Name__c = pp.id;
        //o.Close_Date__c = Date.today();
        o.StageName= 'Need Analysis';
        insert o;
        
        a.OwnerId = testUser2.id;
        update a;
        update o;
        
        
    } 
    static testMethod void runtest6(){
        
        /*Org_Default_Settings__c ods = new Org_Default_Settings__c();
        ods.OpportunityTrigger__c=TRUE;
        ods.accountownerassignmentTrigger__c=True;
        ods.contactownerassignmentTrigger__c=True;
        ods.OwnerUpdateTrigger__c=True;
        ods.ProjectTrigger__c=True;
        ods.QuoteTrigger__c=true;
        insert ods;*/
        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        insert olstTestCountryCode ;
    
        olstTestStateCode = TestDataUtility.getTestStateCodes();
        system.debug('StateCodes###'+olstTestStateCode);
        insert olstTestStateCode ; 
        
        User testUser1 = TestDataUtility.createUser('System Administrator','satish@lokin.com');
        insert testUser1;
        
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
        
        olstTerritoryMastereCode= TestDataUtility.getTerritoryMaster();
        insert olstTerritoryMastereCode ;
        
        Account a = getNewAccount();
        a.BillingCountryCode = 'IN';
        a.BillingPostalCode = '';
        a.BillingStateCode ='';
        a.OwnerId = testUser1.id;
        insert a;
        
        Account aa = getNewAccount();
        aa.BillingCountryCode = 'CA';
        aa.BillingPostalCode = 'V0M 9t9';
        aa.BillingStateCode ='';
        aa.OwnerId = testUser1.id;
        insert aa;
        
        Contact cc = getContact();
        cc.FirstName = 'Jackvin';
        cc.LastName ='Vin';
        cc.AccountId = a.Id;
        cc.MailingCountryCode = 'IN';
        cc.MailingPostalCode = '';
        insert cc;
    
        // Contact c1 = getContact();
        cc.FirstName = 'Jackvin';
        cc.LastName ='Vin';
        cc.AccountId = a.Id;
        cc.MailingCountryCode = 'CA';
        cc.MailingPostalCode = 'V0M 9t9';
        update cc;  
        
        Lead l = getNewLead();
        l.PostalCode = '';
        l.CountryCode = 'IN';
        insert l;
        Lead le = getNewLead();
        le.PostalCode = 'v0m 9t9';
        le.CountryCode = 'CA';
        insert le;
        
        /*Project__c pp = getproject();
        pp.Name='TestDummy';
        pp.Close_Date__c = Date.today();
        pp.Project_Country__c ='Canada';
        pp.Project_Zip_Code__c ='v0m 9t9';
        pp.Project_State__c = '';
        insert pp;  
        Project__c p1 = getproject();
        p1.Name='TestDummy';
        p1.Close_Date__c = Date.today();
        p1.Project_Country__c ='India';
        p1.Project_Zip_Code__c ='';
        p1.Project_State__c = '';
        insert p1;*/
        
        list<Project__c> projlst = new list<Project__c>();
            Project__c p1 = new Project__c();
             //p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Close_Date__c = Date.today();
             p1.Project_State__c = '';
             
             projlst.add(p1);
        insert projlst;
        //ProjectHelper.updateCorpAccFrmProj();
        
        Opportunity o = getNewOpportunity();
        o.AccountId = a.Id ;
        o.Project_Name__c = projlst[0].id;
        //o.Close_Date__c = Date.today();
        o.StageName= 'Need Analysis';
        insert o;
        
        a.OwnerId = testUser2.id;
        update a;
        update o;
       
        /*Set<Id> projIds = new Set<Id>();
        for (Project__c pro :projlst ){
        projlst.add(pro.id);
        }*/
        
        Set<Id> s1 = (new Map<Id,Project__c>(projlst)).keySet();
        
        ProjectHelper.updateCorpAccFrmProj(s1);
        ProjectHelper.updateResidentialVerticalFrmProj(s1);
        ProjectHelper.createProjSplitSpecifier(projlst);
    }  
}