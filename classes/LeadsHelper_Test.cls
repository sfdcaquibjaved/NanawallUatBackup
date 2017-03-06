/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  1. LeadTrigger - Apex Trigger
                                        2. LeadsHelper - Apex Class
*
* @ Audit Trial   : Repeating block for each change to the code
**/

@isTest(SeeAllData=false)
public class LeadsHelper_Test{
	
	 public static List<Lead> olstTestLead;
	 public static List<Country_codes__c> olstTestCountryCode;
	 public static List<state_codes__c> olstTestStateCode;
	 public static List<Zip_Codes_Master__c> olstTerritoryMastereCode;
	
    static testMethod void LeadsHelper_Test1(){
        
        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
	 	insert olstTestCountryCode ;
	 	
	 	olstTestStateCode = TestDataUtility.getTestStateCodes();
	 	insert olstTestStateCode ; 
	 	
	 	olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
	 	insert olstTerritoryMastereCode ;
	 	
	 	olstTestLead = TestDataUtility.createLeadTestData();
	 	olstTestLead[0].Company = 'LeadsHelperTest1 Company';
	 	//olstTestLead[0].Email = 'testleadConvert@testlead12.com' ;
	 	olstTestLead[1].CountryCode = 'CA' ;
	 	olstTestLead[2].CountryCode = 'IN' ;
	 	
	 	insert olstTestLead[0] ;
	 	
	 	Test.startTest();
        try{
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(olstTestLead[0].id);
        
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
    
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
         }
         Catch (Exception ex){}
        Test.stopTest();
    }
}