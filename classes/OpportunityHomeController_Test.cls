/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  1. OpportunityHomeController - Apex Class
                                        
* @ Audit Trial   : Repeating block for each change to the code
**/

@isTest(SeeAllData=false)
private class OpportunityHomeController_Test {
	
	public static list<Opportunity> olstOpportunity ;

    static testMethod void myUnitTest() {
    
    olstOpportunity = TestDataUtility.createOppTestData();
    insert olstOpportunity ;
    
    OpportunityHomeController testOppHomeController = new OpportunityHomeController();
    try{
    testOppHomeController.getApplications();
    testOppHomeController.getCountries();
    testOppHomeController.getDummyOpportunity();
    testOppHomeController.getModelOptions();
    testOppHomeController.getmyOpportunitys();
    testOppHomeController.getOfficeUser();
    testOppHomeController.getOldModelsChecked();
    testOppHomeController.getOldModelsToggleValue();
    testOppHomeController.getSelectedTerritory();
    testOppHomeController.getTerritories();
    testOppHomeController.reset();
    testOppHomeController.primeSearch();
    testOppHomeController.gotonew();
    testOppHomeController.GetQuery(true);
    }
    Catch(Exception ex){}
    
    	
    }
}