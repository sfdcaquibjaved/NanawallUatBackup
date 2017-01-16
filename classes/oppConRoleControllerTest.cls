@isTest
private class oppConRoleControllerTest {

    static testMethod void myUnitTest() {
        list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        /*Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode; */
        
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
    	
      //LIST<Project__c> lstTestProjs = TestDataUtility.createProjectTestData();
      //Project__c testProj = lstTestProjs[0];
        list<Project__c> testProj = new list<Project__c>();
        Project__c p1 = new Project__c();
             p1.Name = 'Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Country__c='United States';
             p1.Project_Zip_Code__c = '12345' ;
             testProj.add(p1);
        
        
      insert testProj;
        
        
     /*Project__c testProj1 = lstTestProjs[1];
        //try{
     //insert testProj1; 
        //
        //catch(Exception e){}
    //list<Account> lstaccs = TestDataUtility.createAccountTestData();
	//Account testAcc = lstaccs[0];*/
	
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
      
     /* LIST<Contact> lstCon = TestDataUtility.createConTestData();
      Contact con = lstCon[0];
      //con.AccountId = testAcc.id;
      insert con;
      Contact con1 = lstCon[1];
     // con1.AccountId = testAcc.id;
      insert con1;
      Contact con2 = lstCon[2];
      //con2.AccountId = testAcc.id;
      insert con2;
      Contact con3 = lstCon[3];
      //con3.AccountId = testAcc.id;
      insert con3;
      Contact con4 = lstCon[4];
     // con4.AccountId = testAcc.id;
      insert con4;*/
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
        
     List<nrOpportunityContactRole__c> lstOppConRole = new List<nrOpportunityContactRole__c>();
    //nrOpportunityContactRole__c nrOppConRole = new nrOpportunityContactRole__c( Contact__c = lstCon[0].id,Primary__c = true , Opportunity__c = testOpp[0].id ,Role__c = 'Architect');
     nrOpportunityContactRole__c nrOppConRole = new nrOpportunityContactRole__c();
      nrOppConRole.Contact__c = lstCon[0].id;
        nrOppConRole.Primary__c = true;
        nrOppConRole.Opportunity__c = testOpp.id;
        nrOppConRole.Role__c = 'Architect';
        lstOppConRole.add(nrOppConRole);
        
      
        insert lstOppConRole;
        
	/* lstOppConRole.add(nrOppConRole);
    List<nrOpportunityContactRole__c> nrOppConRole1 = new List<nrOpportunityContactRole__c>( Contact__c = lstCon[1].id,Primary__c = true , Opportunity__c = testOpp[1].id ,Role__c = 'Architect');
        try{
        insert nrOppConRole1;
        }
        catch(Exception e){}*/
        
        PageReference oppConRolePage = Page.oppConRolePage;
         Test.setCurrentPage(oppConRolePage);
         ApexPAges.StandardController sc = new ApexPages.StandardController(testOpp);
         oppConRoleController testController = new oppConRoleController(sc);
          ApexPAges.StandardController sc1 = new ApexPages.StandardController(nrOppConRole);
         oppContactRoleControllerOverride testControllerOverride = new oppContactRoleControllerOverride(sc1);
         testController.saveRecords();
         testController.cancel();
         testControllerOverride.redirect();
         //delete nrOppConRole1;
         oppConRoleController.oppConRoleWrapper wrapObj = new oppConRoleController.oppConRoleWrapper(nrOppConRole , true);
         //wrapObj.results = lstOppConRole;
        
    }
    static testMethod void myUnitTest2() {
        list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode; 
    	
      //LIST<Project__c> lstTestProjs = TestDataUtility.createProjectTestData();
      //Project__c testProj = lstTestProjs[0];
        list<Project__c> testProj = new list<Project__c>();
        Project__c p1 = new Project__c();
             p1.Name = 'Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Country__c='United States';
             p1.Project_Zip_Code__c = '12345' ;
             testProj.add(p1);
        
        
      insert testProj;
        
        
     /*Project__c testProj1 = lstTestProjs[1];
        //try{
     //insert testProj1; 
        //
        //catch(Exception e){}
    //list<Account> lstaccs = TestDataUtility.createAccountTestData();
	//Account testAcc = lstaccs[0];*/
	
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
      
     /* LIST<Contact> lstCon = TestDataUtility.createConTestData();
      Contact con = lstCon[0];
      //con.AccountId = testAcc.id;
      insert con;
      Contact con1 = lstCon[1];
     // con1.AccountId = testAcc.id;
      insert con1;
      Contact con2 = lstCon[2];
      //con2.AccountId = testAcc.id;
      insert con2;
      Contact con3 = lstCon[3];
      //con3.AccountId = testAcc.id;
      insert con3;
      Contact con4 = lstCon[4];
     // con4.AccountId = testAcc.id;
      insert con4;*/
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
        
     List<nrOpportunityContactRole__c> lstOppConRole = new List<nrOpportunityContactRole__c>();
    //nrOpportunityContactRole__c nrOppConRole = new nrOpportunityContactRole__c( Contact__c = lstCon[0].id,Primary__c = true , Opportunity__c = testOpp[0].id ,Role__c = 'Architect');
     nrOpportunityContactRole__c nrOppConRole = new nrOpportunityContactRole__c();
      //nrOppConRole.Contact__c = lstCon[0].id;
        nrOppConRole.Primary__c = true;
        nrOppConRole.Opportunity__c = testOpp.id;
        nrOppConRole.Role__c = 'Architect';
        lstOppConRole.add(nrOppConRole);
        
        try{
        insert lstOppConRole;
        }catch(DMLEXCEPTION e){}
        
	/* lstOppConRole.add(nrOppConRole);
    List<nrOpportunityContactRole__c> nrOppConRole1 = new List<nrOpportunityContactRole__c>( Contact__c = lstCon[1].id,Primary__c = true , Opportunity__c = testOpp[1].id ,Role__c = 'Architect');
        try{
        insert nrOppConRole1;
        }
        catch(Exception e){}*/
        
        PageReference oppConRolePage = Page.oppConRolePage;
         Test.setCurrentPage(oppConRolePage);
         ApexPAges.StandardController sc = new ApexPages.StandardController(testOpp);
         oppConRoleController testController = new oppConRoleController(sc);
          ApexPAges.StandardController sc1 = new ApexPages.StandardController(nrOppConRole);
         oppContactRoleControllerOverride testControllerOverride = new oppContactRoleControllerOverride(sc1);
         testController.saveRecords();
         testController.cancel();
         testControllerOverride.redirect();
         //delete nrOppConRole1;
         oppConRoleController.oppConRoleWrapper wrapObj = new oppConRoleController.oppConRoleWrapper(nrOppConRole , true);
         //wrapObj.results = lstOppConRole;
        
    }
}