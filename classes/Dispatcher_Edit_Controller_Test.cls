@isTest(SeeAllData = false)
public class Dispatcher_Edit_Controller_Test {
    
    public static list < Zip_Codes_Master__c > territorymaster;
    public static User testUser;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Account > accounts;
    
    /*  
         Method Name    : unitTest
         Purpose        : 
         Input Parameter: N/A 
         Created Date   : August 2016
         */
        static testMethod void unitTest() {
        Test.startTest() ; 
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
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1' ;
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
         
         try {
            insert o;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
            
        Quote__c q = new Quote__c();
            q.Name = 'Test Quote' ;
            q.Opportunity__c = o.Id;
            q.Primary_Quote__c=True;
         
          try {
            insert q;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
            
        Quote_Detail__c qd = new Quote_Detail__c(); 
            qd.name = 'Test Name';
            qd.Quote__c = q.id ; 
            try {
            insert qd;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
              ApexPages.StandardController sc = new ApexPages.standardController(qd);
             Dispatcher_Edit_Controller DEC = new Dispatcher_Edit_Controller(sc);
             DEC.getRedir() ; 
              
            //finished
               ApexPages.currentPage().getParameters().put('finished' , qd.id);
              Dispatcher_Edit_Controller DECNew = new Dispatcher_Edit_Controller(sc);
              DECNew.getRedir() ;
            
            // oldRedir
            
             ApexPages.currentPage().getParameters().put('oldRedir' , qd.id);
              Dispatcher_Edit_Controller DECNew2 = new Dispatcher_Edit_Controller(sc);
              DECNew2.getRedir() ;
            
            
            
        Test.stopTest() ;
    }
}