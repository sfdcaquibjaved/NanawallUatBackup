@isTest
public class Contact_Check_Showroom_Test {

    public  static testMethod void myUnitTest() {
	list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
         zipCode1.City__c = 'Stow';
         zipCode1.Country__c = 'United States';
         zipCode1.State__c = 'Maine';
         zipCode1.Zip_Code__c = '12345' ;
         lstzipCode.add(zipCode1);
         insert  lstzipCode; 
         
         Account acc=new Account();
         acc.Name='test';
         acc.Phone='12345678';
         acc.BillingState = 'New York';
         acc.BillingCountry='United States';
         acc.BillingPostalCode ='12345';
         insert acc;
         
         contact con=new contact();
         //con.Name='test contact';
         con.Accountid=acc.id;
         con.FirstName = 'john';
         con.LastName = 'doe';
         con.address_1__c='abcd';
         con.Address_2__c='hyd';
         con.City__c='abc';
         con.State_Abbr__c='asd';
         con.State__c='ALASKA';
         con.Zip__c='12345';
         con.Country__c='Anguilla';
         con.Phone='563256';
         con.Fax='563256';
         con.Email='test1@test.com';
         con.MailingStreet = 'street';
         con.MailingCity = 'city'; 
         con.Mailingstate = 'Utah';
         con.MailingPostalCode = '12345';
         con.MailingCountryCode = 'US';
         insert con;
         
         test.startTest();
     	 ApexPages.StandardController sc = new ApexPages.StandardController(con);
         Contact_Check_Showroom cc=new Contact_Check_Showroom(sc);
         cc.getOutput();
         test.stopTest();
     
    }
}