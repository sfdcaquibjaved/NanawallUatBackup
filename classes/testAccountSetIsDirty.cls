@isTest
public class testAccountSetIsDirty {
    static testmethod void dirtyphone(){
         list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
Account a= new Account(Name='TestAccountx',Phone='+1356.78.90',BillingPostalCode='12345');
    test.startTest();
    insert a;
    test.stopTest();
    }
}