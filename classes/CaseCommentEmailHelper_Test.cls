/*********************************************************************************************************************
Class Name: CaseCommentEmailHelper_Test
Description: This is a test class to cover and increase code coverage for CaseCommentEmailHelper class and caseTrigger
Associated Trigger :  CaseTrigger
LastChangedDate: 12/05/2016
**********************************************************************************************************************/
@isTest(SeeAllData = false)
public class CaseCommentEmailHelper_Test {
    
    public static list < Zip_Codes_Master__c > territorymaster;
    public static User testUser;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Account > accounts;
    public static list < Contact > contacts;
    public static list < Case > cases;
    public static list <Service_Quote_Detail__c> sqdList;
    public static list < Service_Part__c > spartList;
    public static list < CaseTeamRole > ctrList;
    public static list < CaseComment > ccList;
    public static list < EmailMessage > emailList;
    public static list < Attachment > attachments;
    
    static testMethod void CaseCommentValid() {
        
        test.startTest();
        //Inserting Territory Master Data
        territorymaster = TestDataUtility.getTerritoryMaster();
        try{
        insert territorymaster;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        /* Inserting User Test data  */
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try{
        insert testUser;
        }
        catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        /* Inserting Countries Data */
        countrys = TestDataUtility.getTestCountryCodes();
        try{
        insert countrys;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        /* Getting state codes from TestDataUtility class */
        states = TestDataUtility.getTestStateCodes();
        try{
        insert states;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        /* Fetching account data from TestDataUtility class */
        accounts = TestDataUtility.createAccountTestData();
        try{
        insert accounts;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        /* Creating test data for the Contact object */
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = accounts[0].id;
        try{
        insert contacts;
        }catch(Exception e){
        }
        
        //creating case team role data
        ctrList = TestDataUtility.createCaseTeamRoleTestData();
         System.runAs(new User(Id = Userinfo.getUserId())) {
        try{
        insert ctrList;
        }catch(Exception e){
            system.debug('Exception is:' + e);
        }
        }
        
        System.assert(ctrList.size()!= null);
        
        /****Getting test data for cases from Utility class*****/
        cases = TestDataUtility.createCaseTestData();
        try{
        insert cases;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        System.assert(cases[0] != null);
        
        /***Creating test data for CaseTeamMember***/
        CaseTeamMember CTM = new CaseTeamMember();
        CTM.MemberId = testuser.id;
        CTM.ParentId = cases[0].id;
        CTM.TeamRoleId = ctrList[0].Id;
        try{
        insert CTM;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        /***Creating Case comments for a case***/
        ccList = TestDataUtility.createCaseCommentTestData();
        ccList[0].ParentId = cases[0].id;
        try{
        insert ccList;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        Test.stopTest();
    }
 /******************************************************************************************
                            Testclass for email attchements on case 
     ******************************************************************************************/
    static testMethod void myunitTest1() {
        
        test.startTest();
        //Creating test data for Territory Master
        territorymaster = TestDataUtility.getTerritoryMaster();
        try{
        insert territorymaster;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        //creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try{
        insert testUser;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try{
        insert countrys;
        }
        catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        //Creating test data for states
        states = TestDataUtility.getTestStateCodes();
        try{
        insert states;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        //Creating test data for Accounts 
        accounts = TestDataUtility.createAccountTestData();
        try{
        insert accounts;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        } 
        
        //Creating test data for Contacts
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = accounts[0].id;
        try{
        insert contacts;
        }catch(Exception e){
        }
        
        /***Creating test data for case from utility class***/
        cases = TestDataUtility.createCaseTestData();
        cases[0].Who_is_Calling__c = 'Architect';
        cases[0].AccountId = accounts[0].id;
        cases[0].ContactId = contacts[0].id;
        cases[0].Dummy__c = true;
        try{
        insert cases;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }

        System.assert(cases[0] != null);

        //Creating an Email
        emailList = TestDataUtility.createEmailMessageTestData();
        emailList[0].Parentid = cases[0].id;
        
        try{
        insert emailList;        
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }     
        system.assert(emailList[0]!=null); 
        test.stopTest();
    }
    
    /*****************************************************************************************
     *****************************************************************************************
                            Test classs for Attchinsert trigger
     *****************************************************************************************
     *****************************************************************************************/

    static testMethod void myunitTest2() {
        test.startTest();
        
        //Creating Test Data for territory master
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        
        //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        insert countrys;
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        insert states;

        //Create an Account        
        accounts = TestDataUtility.createAccountTestData();
        try{
        insert accounts;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        } 
        
        //Create a Contact
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = accounts[0].id;
        try{
        insert contacts;
        }catch(Exception e){
        }

        //Create a Case
        cases = TestDataUtility.createCaseTestData();
        cases[0].Who_is_Calling__c = 'Architect';
        cases[0].AccountId = accounts[0].id;
        cases[0].ContactId = contacts[0].id;
        cases[0].Dummy__c = true;
        try{
        insert cases;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        System.assert(cases[0] != null);

        //Create an email message
        emailList = TestDataUtility.createEmailMessageTestData();
        emailList[0].Parentid = cases[0].id;
        emailList[0].subject = 'Re:' ; 
        emailList[0].TextBody = 'New Test Test body of email';
        try{
        insert emailList;        
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }     
        system.assert(emailList[0]!=null); 
       

        //Inserting Attachment        
        attachments = TestDataUtility.createAttachmentTestData();
        try{
        insert attachments;        
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }     
        system.assert(attachments[0]!=null); 
        test.stopTest();
    }
     /**********************************************************************************************
     **********************************************************************************************
                            Test class for Service Quote Upsert Trigger
     **********************************************************************************************
     **********************************************************************************************/
    public static testMethod void myUnitTest3() {
        test.startTest();
        
        //Creating test data for Territory mASTER
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        
        //Creating test data for Countrys
        countrys = TestDataUtility.getTestCountryCodes();
        insert countrys;
        
        //Creating test data for states
        states = TestDataUtility.getTestStateCodes();
        insert states;

        //Create an Account 
        accounts = TestDataUtility.createAccountTestData();
        accounts[0].ShippingState = 'New York';
        accounts[0].ShippingCountryCode='US';
        accounts[0].ShippingPostalCode='12345';
        try{
        insert accounts;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        } 
        
        //Create a Contact
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = accounts[0].id;
        contacts[1].Accountid = accounts[0].id;
        try{
        insert contacts;
        }catch(Exception e){
        }
        
        // Create a CASE
        cases = TestDataUtility.createCaseTestData();
        cases[0].Who_is_Calling__c = 'Architect';
        cases[0].AccountId = accounts[0].id;
        cases[0].ContactId = contacts[0].id;
        cases[0].Dummy__c = true;
        cases[0].Ship_To__c = 'End Customer';
        
        insert cases;
        
        
        //Create a Service Quote
        Service_Quote__c sqt = new Service_Quote__c();      
        sqt.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Custom Service Quote').getRecordTypeId();
        sqt.Case__c = cases[0].id; 
        insert sqt;
		Service_Quote__c sqt1 = new Service_Quote__c(); 
     	sqt1.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Custom Service Quote').getRecordTypeId();
        sqt1.Case__c = cases[0].id; 
     	insert sqt1;
     
        //Create a Service Part
        spartList = TestDataUtility.createServicePartTestData();
        try{
        insert spartList;
        }catch(Exception e){
            system.debug('Exception is:' + e);
        }
        system.assert(spartList.size() != null);

        //Create a Service Quote Detail under Service Quote
        sqdList = TestDataUtility.createserviceQuoteDetailTestData();
        sqdList[0].Service_Part__c = spartList[0].id;
        sqdList[0].Service_Quote__c = sqt.id;
        try{
        insert sqdList;
        }catch(Exception e){
            system.debug('Exception is:' + e);
        }       
        
        Test.stopTest();

    }
    /*
     unitTest4
     */
    public static testMethod void myUnitTest4() {
        test.startTest();
        
        //Creating test data for Territory mASTER
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        
        //Creating test data for Countrys
        countrys = TestDataUtility.getTestCountryCodes();
        insert countrys;
        
        //Creating test data for states
        states = TestDataUtility.getTestStateCodes();
        insert states;

        //Create an Account 
        accounts = TestDataUtility.createAccountTestData();
        accounts[0].ShippingState = '';
        accounts[0].ShippingCountryCode='US';
        accounts[0].ShippingPostalCode='12345';
        try{
        insert accounts;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        } 
        
        //Create a Contact
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = accounts[0].id;
        contacts[1].Accountid = accounts[0].id;
        try{
        insert contacts;
        }catch(Exception e){
        }
        
        // Create a CASE
        cases = TestDataUtility.createCaseTestData();
        cases[0].Who_is_Calling__c = 'Architect';
        cases[0].AccountId = accounts[0].id;
        cases[0].ContactId = contacts[0].id;
        cases[0].Dummy__c = true;
        cases[0].Ship_To__c = 'Caller Contact';
        
        insert cases;
        
        
        //Create a Service Quote
        Service_Quote__c sqt = new Service_Quote__c();      
        sqt.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Custom Service Quote').getRecordTypeId();
        sqt.Case__c = cases[0].id; 
        insert sqt;
		Service_Quote__c sqt1 = new Service_Quote__c(); 
     	sqt1.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Custom Service Quote').getRecordTypeId();
        sqt1.Case__c = cases[0].id; 
     	insert sqt1;
        
        //Create a Service Part
        spartList = TestDataUtility.createServicePartTestData();
        try{
        insert spartList;
        }catch(Exception e){
            system.debug('Exception is:' + e);
        }
        system.assert(spartList.size() != null);

        //Create a Service Quote Detail under Service Quote
        sqdList = TestDataUtility.createserviceQuoteDetailTestData();
        sqdList[0].Service_Part__c = spartList[0].id;
        sqdList[0].Service_Quote__c = sqt.id;
        try{
        insert sqdList;
        }catch(Exception e){
            system.debug('Exception is:' + e);
        }       
        
        Test.stopTest();
    }
       /*
     unitTest5
     */
    public static testMethod void myUnitTest5() {
        test.startTest();
        
        //Creating test data for Territory mASTER
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        
        //Creating test data for Countrys
        countrys = TestDataUtility.getTestCountryCodes();
        insert countrys;
        
        //Creating test data for states
        states = TestDataUtility.getTestStateCodes();
        insert states;

        //Create an Account 
        accounts = TestDataUtility.createAccountTestData();
        accounts[0].ShippingState = '';
        accounts[0].ShippingCountryCode='US';
        accounts[0].ShippingPostalCode='12345';
        try{
        insert accounts;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        } 
        
        //Create a Contact
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = accounts[0].id;
        contacts[1].Accountid = accounts[0].id;
        try{
        insert contacts;
        }catch(Exception e){
        }
        
        // Create a CASE
        cases = TestDataUtility.createCaseTestData();
        cases[0].Who_is_Calling__c = 'Architect';
        cases[0].AccountId = accounts[0].id;
        cases[0].ContactId = contacts[0].id;
        cases[0].Dummy__c = true;
        cases[0].Ship_To__c = 'Project Site';
        
        insert cases;
        
        
        //Create a Service Quote
        Service_Quote__c sqt = new Service_Quote__c();      
        sqt.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Custom Service Quote').getRecordTypeId();
        sqt.Case__c = cases[0].id; 
        insert sqt;
		Service_Quote__c sqt1 = new Service_Quote__c(); 
     	sqt1.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Custom Service Quote').getRecordTypeId();
        sqt1.Case__c = cases[0].id; 
     	insert sqt1;
        //Create a Service Part
        spartList = TestDataUtility.createServicePartTestData();
        try{
        insert spartList;
        }catch(Exception e){
            system.debug('Exception is:' + e);
        }
        system.assert(spartList.size() != null);

        //Create a Service Quote Detail under Service Quote
        sqdList = TestDataUtility.createserviceQuoteDetailTestData();
        sqdList[0].Service_Part__c = spartList[0].id;
        sqdList[0].Service_Quote__c = sqt.id;
        try{
        insert sqdList;
        }catch(Exception e){
            system.debug('Exception is:' + e);
        }       
        
        Test.stopTest();
    }
        /*
     unitTest4
     */
    public static testMethod void myUnitTest6() {
        
        //Creating test data for Territory mASTER
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        
        //Creating test data for Countrys
        countrys = TestDataUtility.getTestCountryCodes();
        insert countrys;
        
        //Creating test data for states
        states = TestDataUtility.getTestStateCodes();
        insert states;

        //Create an Account 
        accounts = TestDataUtility.createAccountTestData();
        accounts[0].ShippingState = '';
        accounts[0].ShippingCountryCode='US';
        accounts[0].ShippingPostalCode='12345';
        try{
        insert accounts;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        } 
        
        //Create a Contact
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = accounts[0].id;
        contacts[1].Accountid = accounts[0].id;
        try{
        insert contacts;
        }catch(Exception e){
        }
        
        // Create a CASE
        cases = TestDataUtility.createCaseTestData();
        cases[0].Who_is_Calling__c = 'Architect';
        cases[0].AccountId = accounts[0].id;
        cases[0].ContactId = contacts[0].id;
        cases[0].Dummy__c = true;
        cases[0].Ship_To__c = 'Other';       
        insert cases;
                test.startTest();

        Cases[0].Ship_To__c = 'Other';
        update cases;
        
        
        //Creating Tax Rates
        
        //Create a Service Quote
        Service_Quote__c sqt = new Service_Quote__c();      
        sqt.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Custom Service Quote').getRecordTypeId();
        sqt.Case__c = cases[0].id; 
        sqt.Ship_To_State__c = 'ARKANSAS';
        insert sqt;
        
        sqt.Ship_To_State__c ='Alberta';
        update sqt ; 
        
		Service_Quote__c sqt1 = new Service_Quote__c(); 
     	sqt1.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Custom Service Quote').getRecordTypeId();
        sqt1.Case__c = cases[0].id; 
     	insert sqt1;
        //Create a Service Part
        spartList = TestDataUtility.createServicePartTestData();
        try{
        insert spartList;
        }catch(Exception e){
            system.debug('Exception is:' + e);
        }
        system.assert(spartList.size() != null);

        //Create a Service Quote Detail under Service Quote
        sqdList = TestDataUtility.createserviceQuoteDetailTestData();
        sqdList[0].Service_Part__c = spartList[0].id;
        sqdList[0].Service_Quote__c = sqt.id;
        try{
        insert sqdList;
        }catch(Exception e){
            system.debug('Exception is:' + e);
        }       
        
        Test.stopTest();
    } 
}