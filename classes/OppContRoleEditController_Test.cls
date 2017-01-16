@isTest
public class OppContRoleEditController_Test {
    public static list < Account > testAccount;
    public static list < contact > testContact;
    public static list < project__c > testproj;
    public static list < opportunity > testOpp;
    public static list < opp_proj_stages__c > olstprojectStages;

    public static testMethod void myUnitTest() {
        string n = 'test';
        list < Zip_Codes_Master__c > lstzipCode = new list < Zip_Codes_Master__c > ();
        lstzipCode = TestDataUtility.getTerritoryMaster();
        insert lstzipCode;

        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages;


        testAccount = TestDataUtility.createAccountTestData();
        insert testAccount;

        testContact = TestDataUtility.createConTestData();
        testContact[0].Accountid = testAccount[0].id;
        insert testContact;



        testproj = TestDataUtility.createProjectTestData();
        testproj[0].Project_Country__c = 'United States';
        insert testproj;

        testOpp = TestDataUtility.createOppTestData();
        testOpp[0].AccountId = testAccount[0].id;
        testOpp[0].Project_Name__c = testproj[0].id;
        insert testOpp;

        nrOpportunityContactRole__c nr = new nrOpportunityContactRole__c();
        nr.Opportunity__c = testOpp[0].id;
        nr.Contact__c = testContact[0].id;
        insert nr;

        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(nr);
        OppContRoleEditController oc = new OppContRoleEditController(sc);
        oc.Cancel();
        oc.checkDelete();
        oc.getContactName();
        oc.Save();
        oc.setContactName(n);
        test.stopTest();
    }

}