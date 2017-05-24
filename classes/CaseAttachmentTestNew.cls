/*************************************************************************
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : May-2016
    @ Description   : This class serves the pupose of code coverage of caseAttachment class
    @ Audit Trial   : 
    @ Last Modified Date : 07-June-2016
  
****************************************************************************/
@isTest(SeeAllData = false)
public class CaseAttachmentTestNew {

    public static list < Zip_Codes_Master__c > territorymaster;
    public static User testUser;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Account > accounts;
    public static list < Contact > contacts;
    public static list < case >cases;
    public static list < Attachment > attachments;

    /*  
         Method Name    : unitTest
         Purpose        : This method is for when the case email address equals to contact  email
         Input Parameter: N/A 
         Created Date   : May 2016
         */

    static testMethod void unitTest() {
        Test.startTest();
        
        //Creating test data for Territory Master
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for Accounts
        accounts = TestDataUtility.createAccountTestData();
        try {
            insert accounts;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        //Creating Contacts test data by using utility class
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = Accounts[0].id;
        contacts[0].Email = 'testUserName@gmail.com';
        try {
            insert contacts;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for groups
        Group testGroup = new Group(Name = 'Web to case queue', Type = 'Queue');
        try {
            insert testGroup;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        QueueSobject mappingObject = new QueueSobject(QueueId = testGroup.Id, SobjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            try {
                insert mappingObject;
            } catch (exception e) {
                system.debug('Exception is:' + e);
            }
        }

         /****Getting test data for cases from Utility class*****/
        cases = TestDataUtility.createCaseTestData();
        cases[0].SuppliedEmail = 'testUserName@gmail.com';
        cases[0].ContactId = contacts[0].id;
        cases[0].AccountId = accounts[0].Id;
        Cases[0].Email_Address__c = 'testUserName@gmail.com';
        Cases[0].DummyEmailMessage__c = true;
        cases[1].SuppliedEmail = 'testUserName@gmail.com';
        cases[1].ContactId = contacts[0].id;
        cases[1].AccountId = accounts[0].Id;
        Cases[1].Email_Address__c = 'testUserName@gmail.com';
        Cases[1].DummyEmailMessage__c = true;
        try{
        insert cases;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        System.assert(cases[0] != null);
        system.assertEquals(contacts[0].Email, cases[0].SuppliedEmail);
        
        //Creating Attachments test data
         attachments = TestDataUtility.createAttachmentTestData();
        attachments[0].parentId = cases[0].id;
        try{
        insert attachments;        
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }     
        system.assert(attachments[0]!=null); 
       
        //Creating test data for email messages/
        Set < Id > emailIds = new Set < Id > ();
        EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress = 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = cases[0].Id));
        try {
            insert newEmail;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        for (EmailMessage emm: newEmail) {
            emailIds.add(emm.Id);
        }
        
        //Calling Controller methods
        ApexPages.StandardController sc = new ApexPages.standardController(cases[0]);
        caseattachment ca = new caseattachment(sc);
        ca.fileName = 'Attachment 1';
        ca.myAttachment = attachments[0];
        ca.fileBody = attachments[0].body ;
        
        ca.fileName2 ='Attachment 2';
        ca.myAttachment2 = attachments[1];
        ca.fileBody2 = attachments[1].body;
        
        ca.fileName3 ='Attachment 3';
        ca.myAttachment3 = attachments[2];
        ca.fileBody3 = attachments[2].body;

        map < Id, Id > maping = new map < Id, Id > ();
        // maping.put(newEmail[0].id, cs[0].id);
        maping.put(newEmail[0].id, cases[0].id);

      //  ca.ChangeCount();
        ca.objCase = cases[1];
        ca.SaveAttachments();
        caseAttachment.attins(emailIds, maping);
        Test.stopTest();
    }

    /*  
         Method Name    : unitTest2
         Purpose        : This method will run to cover the code coverage when the case supplied  email not equal to contact email
         Input Parameter: N/A 
         Created Date   : May 2016
         */


    static testMethod void unitTest2() {
        Test.startTest();
        
        //Creating test data for Territory Master
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for Countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for Accounts
        accounts = TestDataUtility.createAccountTestData();
        try {
            insert accounts;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for contacts
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = Accounts[0].id;
        contacts[0].Email = 'testUserName@gmail.com';
        contacts[1].Accountid = Accounts[1].id;
        contacts[1].Email = 'testUserName1@gmail.com';
        try {
            insert contacts;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for Groups
        Group testGroup = new Group(Name = 'Web to case queue', Type = 'Queue');
        try {
            insert testGroup;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        QueueSobject mappingObject = new QueueSobject(QueueId = testGroup.Id, SobjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            try {
                insert mappingObject;
            } catch (exception e) {
                system.debug('Exception is:' + e);
            }
        }

        /****Getting test data for cases from Utility class*****/
       cases = TestDataUtility.createCaseTestData();
        Cases[0].Email_Address__c = 'testUserName2@gmail.com';
        cases[0].ContactId = contacts[0].id;
        cases[0].AccountId = accounts[0].Id;
        Cases[0].DummyEmailMessage__c = true;
        Cases[1].Email_Address__c = 'testUserName3@gmail.com';
        cases[1].ContactId = contacts[0].id;
        cases[1].AccountId = accounts[0].Id;
        cases[1].DummyEmailMessage__c = True;
        try{
        insert cases;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        System.assert(cases[0] != null);
        

      
        //creating test data for email messages
        Set < Id > emailIds = new Set < Id > ();
        EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress = 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = cases[0].Id));
        try {
            insert newEmail;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }

        //Creating Attachments test data
        attachments = TestDataUtility.createAttachmentTestData();
        attachments[0].parentId = cases[0].id;
        attachments[1].parentId = cases[0].id;
        attachments[2].parentId = newEmail[0].id;
        try{
        insert attachments;        
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }     
        system.assert(attachments[0]!=null); 
       
       
        for (EmailMessage emm: newEmail) {
            emailIds.add(emm.Id);
        }


        //Calling the caseAttachment class
        ApexPages.StandardController sc = new ApexPages.standardController(cases[0]);
        caseattachment ca = new caseattachment(sc);
       // ca.FileCount = '5';
        // ca.allFileList = attachments;

        map < Id, Id > maping = new map < Id, Id > ();
        maping.put(newEmail[0].id, cases[0].id);
        // ca.ChangeCount();


        //Creating test data for the Case object
        cases.add(cases[1]);
        ca.objCase = cases[1];
        system.assertnotequals(contacts[1].Email, cases[1].SuppliedEmail);

        ca.SaveAttachments(); //Calling SaveAttachments method
        caseAttachment.attins(emailIds, maping);
        Test.stopTest();


    }
    
    /*  
         Method Name    : unitTest3
         Purpose        : This method will run to cover the code coverage when the case supplied  email not equal to contact email
         Input Parameter: N/A 
         Created Date   : May 2016
         */


    static testMethod void unitTest3() {
        Test.startTest();
        
        //Creating test data for Territory Master
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for Countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for Accounts
        accounts = TestDataUtility.createAccountTestData();
        try {
            insert accounts;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for contacts
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = Accounts[0].id;
        contacts[0].Email = 'testUserName@gmail.com';
        contacts[1].Accountid = Accounts[1].id;
        contacts[1].Email = 'testUserName1@gmail.com';
        try {
            insert contacts;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for Groups
        Group testGroup = new Group(Name = 'Web to case queue', Type = 'Queue');
        try {
            insert testGroup;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        QueueSobject mappingObject = new QueueSobject(QueueId = testGroup.Id, SobjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            try {
                insert mappingObject;
            } catch (exception e) {
                system.debug('Exception is:' + e);
            }
        }
        
        	order o = new order();
            o.Status = 'draft';
            o.EffectiveDate = system.today();
        	
            try {
                insert o;
            } catch (exception e) {
                system.debug('Exception is:' + e);
            }

        /****Getting test data for cases from Utility class*****/
       cases = TestDataUtility.createCaseTestData();
        Cases[0].Email_Address__c = 'testUserName2@gmail.com';
        cases[0].ContactId = contacts[0].id;
        cases[0].AccountId = accounts[0].Id;
        Cases[0].DummyEmailMessage__c = true;
        Cases[1].Email_Address__c = 'testUserName3@gmail.com';
        cases[1].ContactId = contacts[0].id;
        cases[1].AccountId = accounts[0].Id;
        Cases[1].Order_Number__c = 123456 ;
        cases[1].DummyEmailMessage__c = True;
        try{
        insert cases;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        System.assert(cases[0] != null);
        

      
        //creating test data for email messages
        Set < Id > emailIds = new Set < Id > ();
        EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress = 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Re:Test email', TextBody = '23456 ', ParentId = cases[0].Id));
        try {
            insert newEmail;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }

        //Creating Attachments test data
        attachments = TestDataUtility.createAttachmentTestData();
        attachments[0].parentId = cases[0].id;
        attachments[1].parentId = cases[0].id;
        attachments[2].parentId = newEmail[0].id;
        try{
        insert attachments;        
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }     
        system.assert(attachments[0]!=null); 
       
       
        for (EmailMessage emm: newEmail) {
            emailIds.add(emm.Id);
        }


        //Calling the caseAttachment class
        ApexPages.StandardController sc = new ApexPages.standardController(cases[0]);
        caseattachment ca = new caseattachment(sc);
       // ca.FileCount = '5';
        // ca.allFileList = attachments;

        map < Id, Id > maping = new map < Id, Id > ();
        maping.put(newEmail[0].id, cases[0].id);
        // ca.ChangeCount();


        //Creating test data for the Case object
        cases.add(cases[1]);
        ca.objCase = cases[1];
        system.assertnotequals(contacts[1].Email, cases[1].SuppliedEmail);

        ca.SaveAttachments(); //Calling SaveAttachments method
        caseAttachment.attins(emailIds, maping);
        Test.stopTest();


    }
    
}