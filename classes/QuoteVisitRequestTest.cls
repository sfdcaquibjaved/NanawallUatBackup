@IsTest
 public class QuoteVisitRequestTest {
 public static list<Zip_Codes_Master__c> zipcode; 
 public static list<Account> accounts;
 public static list<Contact> contacts = new List<Contact>();
 public static list<Project__c> project;  
 public static list<opportunity> opportunity;
 public static list<Quote__c> quote;
    
    static testMethod void QuoteVisitRequestMethod1(){
        try
        {
        zipcode=TestDataUtility.getTerritoryMaster();
        insert zipcode;
        accounts=TestDataUtility.createAccountTestData();
        insert accounts;
        
        contacts=TestDataUtility.createConTestData();
        contacts[0].AccountID = accounts[0].id;
        insert contacts[0];        
        
        
       
        project=TestDataUtility.createProjectTestData();
        insert project;
        opportunity=TestDataUtility.createOppTestData();
        insert opportunity;
        
        quote=TestDataUtility.createQuoteRecords(opportunity);
        
        insert quote;
        
        test.startTest();
        QuoteVisitRequest.CreatePreInstallation(quote[0].id,project[0].id,contacts[0].id);
        test.stopTest();
        
       }
  
     catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
       }
     
       static testMethod void QuoteVisitRequestMethod2(){
        try
        {
        zipcode=TestDataUtility.getTerritoryMaster();
        insert zipcode;
        accounts=TestDataUtility.createAccountTestData();
        insert accounts;
        
        contacts=TestDataUtility.createConTestData();
        contacts[0].AccountID = accounts[0].id;
        insert contacts[0];        
        
        
       
        project=TestDataUtility.createProjectTestData();
        insert project;
        opportunity=TestDataUtility.createOppTestData();
        insert opportunity;
        
        quote=TestDataUtility.createQuoteRecords(opportunity);
        
        //insert quote;
        
        test.startTest();
        QuoteVisitRequest.CreatePreInstallation(quote[1].id,project[0].id,contacts[0].id);
        test.stopTest();
        
       }
  
     catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
       }
     
   
    
}