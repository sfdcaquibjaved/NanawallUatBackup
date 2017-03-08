@isTest

public class OpportunityContactListController_Test {
    public static testMethod void testMyController() {
    
    list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();        
         lstzipCode = TestDataUtility.getTerritoryMaster();
         insert lstzipCode;
      
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
    
     List<nrOpportunityContactRole__c> lstOppConRole = new List<nrOpportunityContactRole__c>();
      nrOpportunityContactRole__c nrOppConRole = new nrOpportunityContactRole__c();
      nrOppConRole.Contact__c = lstCon[0].id;
        nrOppConRole.Primary__c = true;
        nrOppConRole.Opportunity__c = testOpp.id;
        nrOppConRole.Role__c = 'Architect';
        lstOppConRole.add(nrOppConRole);
        insert lstOppConRole;
        
        PageReference Pcon = Page.Project_Contacts;
         Test.setCurrentPage(Pcon);
         ApexPAges.StandardController sc = new ApexPages.StandardController(testOpp);
        OpportunityContactListController testController = new OpportunityContactListController(sc);
        List<nrOpportunityContactRole__c> op=testController.getContacts();
         //System.assertEquals(lstOppConRole[0].id,lstCon[0].id);
    
   // OpportunityContactListController obj = new OpportunityContactListController(new ApexPages.StandardController(testOpp));
    }
}