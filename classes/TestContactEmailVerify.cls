@isTest
Private class TestContactEmailVerify{
public static list<Contact> olstConTestData;
public static list<Account> olstAccTestData;
 static testMethod void Verify(){
     list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
     
 olstAccTestData=TestDataUtility.createAccountTestData();
 insert olstAccTestData;
 olstConTestData=TestDataUtility.createConTestData();
 olstConTestData[0].Account=olstAccTestData[0];
 insert olstConTestData;
     Test.startTest();   
    ApexPages.StandardController controller = new ApexPages.StandardController(olstConTestData[0]);
    Contact_VerifyEmail nCustom = new Contact_VerifyEmail(controller);
     
    nCustom.getVerifyEmail();
     nCustom.getFieldColor();
    Test.StopTest();
    
    }
    }