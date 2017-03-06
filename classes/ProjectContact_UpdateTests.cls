@isTest(SeeAllData=false)
public without sharing class ProjectContact_UpdateTests {


public static list<Zip_Codes_Master__c> territorymaster;
public static User testUser ;
public static list < Country_codes__c > countrys;
public static list < state_codes__c > states;

static testMethod void OpportunitySplit_DeleteTest1(){

territorymaster = TestDataUtility.getTerritoryMaster();
insert territorymaster;

testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
insert testUser;

countrys = TestDataUtility.getTestCountryCodes();
insert countrys;

states = TestDataUtility.getTestStateCodes();
insert states;

       list<Account> acc =new List<Account>();
            Account ac = new Account();
            ac.Name = 'Test Account';
            ac.Phone = '(123) 456-7890';
            ac.BillingCountryCode = 'US';
            ac.BillingPostalCode = '12345';
            ac.BillingStateCode ='CA';       
            ac.Zip__c = '12345';
            acc.add(ac);
            insert acc[0];

 list<contact> con = new list<contact>();
        Contact c = new Contact();
        c.Accountid=acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'CAD EMAIL RECIPIENT';
        c.MailingStreet = 'street';
        c.MailingCity = 'city'; 
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        con.add(c);
          insert con[0];

 list<Project__c> Pro= new list<Project__c>();
             Project__c p = new Project__c();
             p.Name = 'Test Project CompetitorHelper_Test';
             p.Application__c = 'Automotive';
             p.Application_2__c = 'Dealership';
             p.Project_Zip_Code__c = '12345' ;
             p.Project_Country__c='United States';
             p.Close_Date__c=Date.newInstance(2015, 12, 12);
             p.Stage__c='Quote - Provided';
            Pro.add(p);
       insert Pro[0];
      
 List<Opportunity> opplist = new List<Opportunity>();
        Opportunity o = new Opportunity();
        o.Name='Test2';
        o.Project_Name__c =Pro[0].Id ;
        o.StageName = 'Qualification';
        o.CloseDate = Date.today()-10;
        o.Country__c = 'USA';
        o.Postal_Code__c = '12345';
        o.OwnerId = testUser.Id;
        o.Accountid=acc[0].id;
        o.chain_account__c=true;
       o.Residential_Vertical__c=true;
        opplist.add(o);
      
        insert opplist[0];
        
        List<nrOpportunityContactRole__c> nrol=new  List<nrOpportunityContactRole__c>();
        nrOpportunityContactRole__c nro=new nrOpportunityContactRole__c();
        nro.Contact__c=con[0].id;
        nro.Opportunity__c=opplist[0].id;
        nrol.add(nro);
        insert nrol[0];
        
        List<OpportunitySplit> osl=new List<OpportunitySplit>();
        OpportunitySplit os=new OpportunitySplit();
        os.Opportunityid= opplist[0].id;
        os.SplitOwnerid=testUser.id;
        osl.add(os);
        insert  osl[0];
        
        List<OpportunityTeamMember> otml= new   List<OpportunityTeamMember>();
        
        OpportunityTeamMember otm=new OpportunityTeamMember();
        otm.Userid=testUser.id;
        otm.Opportunityid=opplist[0].id;
        otml.add(otm);
        insert otml[0];
        
        Test.startTest();

        Database.DeleteResult result = Database.delete(osl[0], false);

        Test.stopTest();
     } 
    
    /****************unitTest1 is for Account_Delete Trigger*********************/
    static testMethod void unitTest1(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser1 = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser1;
        list<Account> acc = new list<account>();
    acc= TestDataUtility.createAccountTestData();
     acc[0].Type='Architecture Firm';
     acc[0].OwnerId=testUser1.id;
     insert acc;
        delete acc[0];
    }
    
    /*******************unitTest2 is for nrOppContactRoleInsertDelete*********************/
    static testMethod void unitTest2(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser1 = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser1;
        
        project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             p1.Stage__c='Quote - Provided'; 
        insert p1;
        list<Account> acc = new list<account>();
    acc= TestDataUtility.createAccountTestData();
     acc[0].Type='Architecture Firm';
     acc[0].OwnerId=testUser1.id;
    acc[1].OwnerId=testUser1.id;
     acc[1].Type='other';
    insert acc;
    
    list<Contact> con = new list<Contact>();
    con = TestDataUtility.createConTestData();
    con[0].accountid=acc[0].id;
    con[0].FirstName = 'foo';
    con[0].LastName = 'bar';
    con[0].MailingStreet = 'street';
    con[1].accountid=acc[1].id;
    con[1].FirstName = 'fool';
    con[1].LastName = 'bar1';
    con[1].MailingStreet = 'street1';
    insert con;
    
    list<opportunity> opp = new list<opportunity>();
    opp=TestDataUtility.createOppTestData();
    opp[0].Project_Name__c=p1.id;
    opp[0].accountid=acc[0].id;
    opp[0].ownerId=testUser1.id;
    opp[1].Project_Name__c=p1.id;
    opp[1].accountid=acc[1].id;
    
    insert opp;
    nrOpportunityContactRole__c ncr = new nrOpportunityContactRole__c();
        ncr.Role__c = 'Architect';
         ncr.Primary__c = true;
          ncr.Contact__c = con[0].Id ;
         ncr.Opportunity__c  = opp[0].id;
        insert ncr;
        
    OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = ncr.Opportunity__c;
        ocr.ContactID = ncr.Contact__c;
        insert ocr;
 }
    /*****************unitTest3 is for WebQuote_Preinsert Trigger****************/
    static testMethod void unitTest3(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser1 = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser1;
        
        project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             p1.Stage__c='Quote - Provided'; 
        insert p1;
        list<Account> acc = new list<account>();
    acc= TestDataUtility.createAccountTestData();
     acc[0].Type='Architecture Firm';
     acc[0].OwnerId=testUser1.id;
    acc[1].OwnerId=testUser1.id;
     acc[1].Type='other';
    insert acc;
    
    list<Contact> con = new list<Contact>();
    con = TestDataUtility.createConTestData();
    con[0].accountid=acc[0].id;
    con[0].FirstName = 'foo';
    con[0].LastName = 'bar';
    con[0].MailingStreet = 'street';
    con[1].accountid=acc[1].id;
    con[1].FirstName = 'fool';
    con[1].LastName = 'bar1';
    con[1].MailingStreet = 'street1';
    insert con;
    
    list<opportunity> opp = new list<opportunity>();
    opp=TestDataUtility.createOppTestData();
    opp[0].Project_Name__c=p1.id;
    opp[0].accountid=acc[0].id;
    opp[0].ownerId=testUser1.id;
    opp[1].Project_Name__c=p1.id;
    opp[1].accountid=acc[1].id;
    
    insert opp;
   /* nrOpportunityContactRole__c ncr = new nrOpportunityContactRole__c();
        ncr.Role__c = 'Architect';
         ncr.Primary__c = true;
          ncr.Contact__c = con[0].Id ;
         ncr.Opportunity__c  = opp[0].id;
        insert ncr;
        
    OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = ncr.Opportunity__c;
        ocr.ContactID = ncr.Contact__c;
        insert ocr; */
        
        Web_Quote__c wq = new Web_Quote__c();
        wq.Contact__c = con[0].name;
        wq.Project_City__c = p1.Name;
        wq.Project_Zip__c = p1.Project_Zip_Code__c;
        insert wq;
        }
    /*****************unitTest4 is for Contact_EmailViewTaskCreated****************/
    static testMethod void unitTest4(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser1 = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser1;
        list<Project__c> testProj = new list<Project__c>();
        Project__c p1 = new Project__c();
             p1.Name = 'Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Country__c='United States';
             p1.Project_Zip_Code__c = '12345' ;
             testProj.add(p1);
             insert testProj;
        
     list<Account> testAcc = new list<Account>();
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        testAcc.add(a);
        insert testAcc;        
     
        List<Contact> lstCon = new List<Contact>();
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo' ;
        con.LastName = 'bar';
        con.Accountid=testAcc[0].id;
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        lstCon.add(con);  
        insert lstCon;
        
     list<Opportunity> lstOpps = TestDataUtility.createOppTestData();
     Opportunity testOpp = lstOpps[0];
     testOpp.AccountId = testAcc[0].id;
     testOpp.Project_Name__c = testProj[0].id;
    insert testOpp;
        try{
        List<Task> tsk = new List<Task>(); 
        Task t = new Task();
        t.Subject = 'Quote Email Opened';
        t.WhoId = lstcon[0].id;
        tsk.add(t);
        Task t1 = new Task();
        t1.Subject = 'Email Viewed';
        t1.WhoId = lstcon[0].id;
        tsk.add(t1);
        insert tsk;
        }
        catch(Exception ex){
        }
        }
    
  /*******************unitTest5 is for nrOppContactRoleInsertDelete*********************/
    static testMethod void unitTest5(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser1 = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser1;
        
        project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             p1.Stage__c='Quote - Provided'; 
        insert p1;
        list<Account> acc = new list<account>();
    acc= TestDataUtility.createAccountTestData();
     acc[0].Type='Architecture Firm';
     acc[0].OwnerId=testUser1.id;
    acc[1].OwnerId=testUser1.id;
     acc[1].Type='other';
    insert acc;
    
    list<Contact> con = new list<Contact>();
    con = TestDataUtility.createConTestData();
    con[0].accountid=acc[0].id;
    con[0].FirstName = 'foo';
    con[0].LastName = 'bar';
    con[0].MailingStreet = 'street';
    con[1].accountid=acc[1].id;
    con[1].FirstName = 'fool';
    con[1].LastName = 'bar1';
    con[1].MailingStreet = 'street1';
    insert con;
    
    list<opportunity> opp = new list<opportunity>();
    opp=TestDataUtility.createOppTestData();
    opp[0].Project_Name__c=p1.id;
    opp[0].accountid=acc[0].id;
    opp[0].ownerId=testUser1.id;
    opp[1].Project_Name__c=p1.id;
    opp[1].accountid=acc[1].id;
    
    insert opp;
    nrOpportunityContactRole__c ncr = new nrOpportunityContactRole__c();
        ncr.Role__c = 'Architect';
         ncr.Primary__c = true;
          ncr.Contact__c = con[0].Id ;
         ncr.Opportunity__c  = opp[0].id;
        insert ncr;
        
    OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = ncr.Opportunity__c;
        ocr.ContactID = ncr.Contact__c;
        insert ocr;
        
        nrOpportunityTeamMember__c nrOTM = new nrOpportunityTeamMember__c();
        nrOTM.Credit__c = 'Lo';
        //ntr.Name = 'test01';
        nrOTM.Opportunity__c = opp[0].Id;
        nrOTM.User__c  = testUser1.id;
        insert nrOTM;
        
        
        OpportunityShare os = new OpportunityShare();
        os.OpportunityAccessLevel = 'Edit';
        os.RowCause = 'Manual';
        os.OpportunityId = nrOTM.Opportunity__c;
        os.UserOrGroupId = nrOTM.User__c;
        insert os;  
        delete nrOTM;
        //delete os;
   
 }
    
     /*******************unitTest6 is for nrOppContactRoleInsertDelete*********************/
    static testMethod void unitTest6(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser1 = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser1;
        
        project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             p1.Stage__c='Quote - Provided'; 
        insert p1;
        list<Account> acc = new list<account>();
    acc= TestDataUtility.createAccountTestData();
     acc[0].Type='Architecture Firm';
     acc[0].OwnerId=testUser1.id;
    acc[1].OwnerId=testUser1.id;
     acc[1].Type='other';
    insert acc;
    
    list<Contact> con = new list<Contact>();
    con = TestDataUtility.createConTestData();
    con[0].accountid=acc[0].id;
    con[0].FirstName = 'foo';
    con[0].LastName = 'bar';
    con[0].MailingStreet = 'street';
    con[1].accountid=acc[1].id;
    con[1].FirstName = 'fool';
    con[1].LastName = 'bar1';
    con[1].MailingStreet = 'street1';
    insert con;
    
    list<opportunity> opp = new list<opportunity>();
    opp=TestDataUtility.createOppTestData();
    opp[0].Project_Name__c=p1.id;
    opp[0].accountid=acc[0].id;
    opp[0].ownerId=testUser1.id;
    opp[1].Project_Name__c=p1.id;
    opp[1].accountid=acc[1].id;
    
    insert opp;
    nrOpportunityContactRole__c ncr = new nrOpportunityContactRole__c();
        ncr.Role__c = 'Architect';
         ncr.Primary__c = true;
          ncr.Contact__c = con[0].Id ;
         ncr.Opportunity__c  = opp[0].id;
        insert ncr;
        
    OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = ncr.Opportunity__c;
        ocr.ContactID = ncr.Contact__c;
        insert ocr;
        
        nrOpportunityTeamMember__c nrOTM = new nrOpportunityTeamMember__c();
        nrOTM.Credit__c = 'Lo';
        //ntr.Name = 'test01';
        nrOTM.Opportunity__c = opp[0].Id;
        nrOTM.User__c  = testUser1.id;
        insert nrOTM;
        
        List<OpportunityShare> oslist = new List<OpportunityShare>();
        OpportunityShare os = new OpportunityShare();
        os.OpportunityAccessLevel = 'Edit';
        os.RowCause = 'Manual';
        os.OpportunityId = '006A0000002f9nsIAA';
        os.UserOrGroupId = '00GA0000000J34eMAC';
        oslist.add(os);
        insert oslist;  
        delete nrOTM;
        //delete os;
   
 }
    /*****************unitTest7 is for Contact_EmailViewTaskCreated****************/
    static testMethod void unitTest7(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser1 = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser1;
        list<Project__c> testProj = new list<Project__c>();
        Project__c p1 = new Project__c();
             p1.Name = 'Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Country__c='United States';
             p1.Project_Zip_Code__c = '12345' ;
             testProj.add(p1);
             insert testProj;
        
     list<Account> testAcc = new list<Account>();
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        testAcc.add(a);
        insert testAcc;        
     
        List<Contact> lstCon = new List<Contact>();
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo' ;
        con.LastName = 'bar';
        con.Accountid=testAcc[0].id;
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        lstCon.add(con);  
        insert lstCon;
        
     list<Opportunity> lstOpps = TestDataUtility.createOppTestData();
     Opportunity testOpp = lstOpps[0];
     testOpp.AccountId = testAcc[0].id;
     testOpp.Project_Name__c = testProj[0].id;
    insert testOpp;
        //delete testopp;
        
        }
}