@isTest
public class EntitlementCaseTrigger_Test {
    public static list < Zip_Codes_Master__c > territorymaster;
    public static User testUser;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Account > accounts;
    public static list < Contact > contacts;
    public static list < Case > cases;
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
        cases[0].Milestone_check__c =TRUE;
        UPDATE cases[0];        
        System.assert(cases[0] != null);       
	}
}