@isTest
public class Rep_Commission_Test_Controller_Test {
    public static testMethod void myuntiTest1(){
        Rep_Commission_Test_Row__c rct = new Rep_Commission_Test_Row__c();
        rct.Name = 'Test1'; 
        rct.Opportunity_City__c = 'new york';
        insert rct;
    
        test.startTest();
        Rep_Commission_Test_Controller rtc = new Rep_Commission_Test_Controller();
        list<Rep_Commission_Test_Row__c> rc1 = rtc.getRepCommissionTestRows();
        string str1 = rtc.testMatch();
        //rtc.runtests();
        test.stopTest();
    }

}