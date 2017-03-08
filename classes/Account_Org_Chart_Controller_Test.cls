@isTest
public class Account_Org_Chart_Controller_Test {
 public  static testMethod void myUnitTest() {
 
         Account testAccount = new Account();
         testAccount.Name='test';
         testAccount.Phone='12345678';
         testAccount.BillingState = 'New York';
         testAccount.BillingCountry='United States';
         testAccount.BillingPostalCode ='12345';
         insert testAccount;
    
     
     test.startTest();
     ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
     Account_Org_Chart_Controller ao=new Account_Org_Chart_Controller(sc);
     ao.getAccounts();
     test.stopTest();
 }
    
}