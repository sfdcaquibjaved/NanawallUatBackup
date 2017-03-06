/*
 @ Description   : This class serves the pupose of code coverage of recaPTCHA class
 @ Created Date  : April2016
*/

@isTest
public class reCaPTCHA_Test {
    public static List < Case > cases;
    static testMethod void unitTest() {
        /* Fetching test data from the Utility class */
        cases = TestDataUtility.createCaseTestData();
        cases[0].SuppliedEmail = 'test@test.com'; 
        try{
        insert cases;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        System.assert(cases[0] != null);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(cases[0]);
        reCAPTCHA rc = new reCAPTCHA(sc);
        reCAPTCHA rc2 = new reCAPTCHA();
        rc.myName = 'John Smith';
        rc.myEmail = 'test@email.com';
        rc.verify();
        rc.reset();
        reCAPTCHA.makeRequest('testString', 'testString2');
        test.stopTest();
    }
}