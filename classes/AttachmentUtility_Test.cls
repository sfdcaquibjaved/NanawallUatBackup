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



        list < Attachment > attList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = cs[0].id;

        attList.add(attach);

        insert attList[0];

    }

}