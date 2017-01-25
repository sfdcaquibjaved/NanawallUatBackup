@isTest private without sharing class DB_Custom_Project_c
{
	@isTest (SeeAllData=true)
	private static void testTrigger()
	{
		CRMfusionDBR101.DB_Globals.triggersDisabled = true;
		sObject testData = CRMfusionDBR101.DB_TriggerHandler.createTestData( Project__c.getSObjectType() );
		Test.startTest();
		insert testData;
		update testData;
		CRMfusionDBR101.DB_Globals.generateCustomTriggerException = true;
		update testData;
		delete testData;
		Test.stopTest();
	}
}