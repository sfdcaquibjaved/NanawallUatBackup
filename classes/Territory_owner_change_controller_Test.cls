/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  1. Territory_owner_change_controller - Apex Class
*
* @ Audit Trial   : Repeating block for each change to the code
**/

@isTest(SeeAllData=false)
private class Territory_owner_change_controller_Test {
	
	public static List<Zip_Codes_Master__c> olstTerritoryMastereCode;

    static testMethod void myUnitTest() {
        
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
 	    olstTerritoryMastereCode[0].User__c = UserInfo.getUserId();
 	    olstTerritoryMastereCode[1].User__c = UserInfo.getUserId();
 	    insert olstTerritoryMastereCode ;
        
        territory_owner_change_controller testClass = new territory_owner_change_controller();
        testClass.closePopup();
        testClass.dosort();
        testClass.updateZipOwner();
        testClass.showPopup();
        try{
        testClass.SearchObjects();
        }
        Catch (Exception ex){}
    }
}