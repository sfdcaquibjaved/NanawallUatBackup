/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 07-June-2016
    @ Description   : This class serves the pupose of code coverage of Attachment_Utility class
    @ Audit Trial   : 
	@ Last Modified Date : 07-June-2016
  
****************************************************************************/ 

@isTest(SeeAllData = false)
public class AttachmentUtility_Test {
    public static list < Zip_Codes_Master__c > territorymaster;
    public static User testUser;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Account > accounts;

    static testMethod void unitTest() {
        Test.startTest();

        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;

        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;

        countrys = TestDataUtility.getTestCountryCodes();
        insert countrys;

        states = TestDataUtility.getTestStateCodes();
        insert states;

        accounts = TestDataUtility.createAccountTestData();
        insert accounts;

        list < Account > acc = new List < Account > ();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.Phone = '(123) 456-7890';
        ac.BillingCountryCode = 'US';
        ac.BillingPostalCode = '12345';
        ac.BillingStateCode = 'CA';
        ac.Zip__c = '12345';
        acc.add(ac);
        insert acc[0];

        list < contact > con = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'CAD EMAIL RECIPIENT';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        c.Email = 'testUserName@gmail.com';
        con.add(c);
        insert con[0];

        List < Case > cs = new List < Case > ();
        Case newCase = new Case();
        newCase.Status = 'New';
        newCase.SuppliedEmail = 'testUserName@gmail.com';
        newCase.Origin = 'Phone';
        newCase.Subject = 'Test';
        newCase.ContactId = con[0].id;
        newCase.AccountId = acc[0].Id;
        newCase.Description = 'Test Description';
        cs.add(newCase);
        insert cs[0];
        
      list<Opportunity> oplist = TestDataUtility.createOppTestData();
        for(Integer i = 0;i<oplist.size();i++){
            oplist[i].AccountId = accounts[i].id;
        }
        insert oplist;
      nrOpportunity_Account__c noa = new nrOpportunity_Account__c();
        noa.account__c = accounts[0].id;
        noa.Opportunity__c = oplist[0].id;
        insert noa;

        list < Attachment > attList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = cs[0].id;
        
        Attachment attach1 = new Attachment();
        attach1.Name = 'Unit Test Attachment1';
        Blob bodyBlobnew = Blob.valueOf('Unit Test Attachment Body new');
        attach1.body = bodyBlobnew;
        attach1.parentId = oplist[0].id;

        attList.add(attach);
        attlist.add(attach1);

        insert attList[0];

    }
    static testMethod void unitTest2() {
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        Project__c prolist = new Project__c();
        prolist.Project_Zip_Code__c = '94040';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Installation__c> instlist = TestDataUtility.createInsTestData();
        for(Integer i=0;i<instlist.size();i++){
            instlist[i].Project__c = prolist.id;
        }
        insert instlist;
        list<Installation_Form__c> insflist= new list<Installation_Form__c>();
        Installation_Form__c inf = new Installation_Form__c();
        inf.Installation_Number__c = instlist[0].id;
        insflist.add(inf);
        insert insflist;
        
        Test.startTest();
        list < Attachment > attList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'Signature.png';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = insflist[0].id;

        attList.add(attach);

        insert attList[0];
        Test.stopTest();
    }
    static testMethod void unitTest3() {
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        Project__c prolist = new Project__c();
        prolist.Project_Zip_Code__c = '94040';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Installation__c> instlist = TestDataUtility.createInsTestData();
        for(Integer i=0;i<instlist.size();i++){
            instlist[i].Project__c = prolist.id;
        }
        insert instlist;
        
        Test.startTest();
        list < Attachment > attList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'INS_CompleteImg1.png';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = instlist[0].id;

        attList.add(attach);

        insert attList[0];
        Test.stopTest();
    }
    static testMethod void unitTest4() {
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        list<Case> caselist = TestDataUtility.createCaseTestData();
        insert caselist;
        
        Test.startTest();
        list < Attachment > attList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'INS_CompleteImg1.png';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = caselist[0].id;

        attList.add(attach);

        insert attList[0];
        Test.stopTest();
    }

}