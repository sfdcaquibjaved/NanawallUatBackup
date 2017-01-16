/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  1. UtilityClass - Apex Class
*
* @ Audit Trial   : Repeating block for each change to the code
**/
@isTest
private class UtilityClass_Test {
    
   public static list<HardCodingUtility__c> olstHardcodUtil ;
   public static list<Opportunity> olstOpportunity ; 
   public static list<OpportunityContactRole> olstContactRole ;
   public static list<Contact> olstContact ;
 
    static testMethod void UtilityClassTestMethod() {
    	
    	//Insert Custom Setting Record
    	
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;

        olstHardcodUtil = TestDataUtility.getHardCodingUtility();
        insert olstHardcodUtil ;
        
        olstOpportunity = TestDataUtility.createOppTestData();
        insert olstOpportunity ;
        
        olstContact = TestDataUtility.createConTestData();
        insert olstContact ;
        
        olstContactRole = TestDataUtility.createOppConRoleTestData(olstOpportunity, olstContact);
    	insert olstContactRole ;
    	
       Test.startTest();
       UtilityClass.getStringValue(olstHardcodUtil[0].Name);
       UtilityClass.checkContactRoles(olstOpportunity[0].Id);
       UtilityClass.validateContactRoles(olstOpportunity[0].Id);
       Test.stopTest();
    }
    
     static testMethod void UtilityClassTestMethod2() {
    	
    	//Insert Custom Setting Record
    	
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;

        olstHardcodUtil = TestDataUtility.getHardCodingUtility();
        insert olstHardcodUtil ;
        
        olstOpportunity = TestDataUtility.createOppTestData();
        insert olstOpportunity ;
        
        olstContact = TestDataUtility.createConTestData();
        insert olstContact ;
        
      /*  olstContactRole = TestDataUtility.createOppConRoleTestData(olstOpportunity, olstContact);
    	insert olstContactRole ;*/
    	
       Test.startTest();
       UtilityClass.getStringValue(olstHardcodUtil[0].Name);
       UtilityClass.checkContactRoles(olstOpportunity[0].Id);
       UtilityClass.validateContactRoles(olstOpportunity[0].Id);
       Test.stopTest();
    }
}