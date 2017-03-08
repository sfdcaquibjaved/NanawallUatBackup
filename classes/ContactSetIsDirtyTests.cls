@isTest(SeeAllData=false)
public without sharing class ContactSetIsDirtyTests {
public static list<Zip_Codes_Master__c> territorymaster;
public static User testUser ;
public static list < Country_codes__c > countrys;
public static list < state_codes__c > states;
static testMethod void ContactSetIsDirtyTest1(){

territorymaster = TestDataUtility.getTerritoryMaster();
insert territorymaster;

testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
insert testUser;

countrys = TestDataUtility.getTestCountryCodes();
insert countrys;

states = TestDataUtility.getTestStateCodes();
insert states;

       list<Account> acc =new List<Account>();
            Account ac = new Account();
            ac.Name = 'Test Account';
            ac.Phone = '(123) 456-7890';
            ac.BillingCountryCode = 'US';
            ac.BillingPostalCode = '12345';
            ac.BillingStateCode ='CA';       
            ac.Zip__c = '12345';
            ac.Phone='+1-541-754-3010';
            ac.Fax ='+1-541-754-3010';
            acc.add(ac);
            insert acc[0];

 list<contact> con = new list<contact>();
        Contact c = new Contact();
        c.Accountid=acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'CAD EMAIL RECIPIENT';
        c.MailingStreet = 'street';
        c.MailingCity = 'city'; 
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        c.Phone='+1-541-754-3010';
        c.Fax ='+1-541-754-3010';

        con.add(c);
 test.startTest();          
insert con[0];
test.stopTest();
}
}