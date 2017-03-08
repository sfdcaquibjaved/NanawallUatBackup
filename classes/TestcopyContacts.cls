@isTest
public class TestcopyContacts {
 /*static testMethod void copycontact(){
    
            list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
            Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
            insert acct;
            Contact con = new Contact(FirstName='Test',LastName='Contact',MailingCountry='United States',MailingPostalCode='08619', OtherPostalCode='08619',OtherStreet='x',Phone='78576465',AccountId=acct.id); 
            insert con; 
           // boolean bo = copyContacts.copyContactsMethod(acct.id);
     //if(bo == true){
       //    list<Contact> conlist =[ select MailingCity, MailingCountry,MailingPostalCode, MailingState, MailingStreet, OtherCity, OtherCountry, OtherState, OtherPostalCode,OtherStreet, Fax, Phone,AccountId from Contact where AccountId =:acct.id];  
            Test.startTest ();
copyContacts.copyContactsMethod(acct.id);
Test.stopTest();*/
    
    
        //Contact c= new Contact(AccountId=acct.id);  
   /* System.assertEquals(con.MailingCity,acct.BillingCity);
            System.assertEquals(con.MailingCountry,acct.BillingCountry);
            System.assertEquals(con.MailingPostalCode,acct.BillingPostalCode);
            System.assertEquals(con.MailingState,acct.BillingState);
            System.assertEquals(con.MailingStreet,acct.BillingStreet);
            System.assertEquals(con.OtherCity,acct.ShippingCity);
            System.assertEquals(con.OtherCountry,acct.ShippingCountry);
            System.assertEquals(con.OtherState,acct.ShippingState);
            System.assertEquals(con.OtherPostalCode,acct.ShippingPostalCode);
            System.assertEquals(con.OtherStreet,acct.ShippingStreet);
            System.assertEquals(con.Fax,acct.Fax);
            System.assertEquals(con.Phone,acct.Phone);*/
    
     
//}
/*static testmethod void case2(){
 list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
 Account acct = new Account(Name='My Test Account2',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
            insert acct;
     Account acc = new Account(Name='My Test Account3',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
            insert acc;
             Contact con = new Contact(FirstName='Test22',LastName='Contact',MailingCountry='United States',MailingPostalCode='08619', OtherPostalCode='08619',OtherStreet='x',Phone='78576465',AccountId=acct.id);
            insert con; 
            test.startTest();
    try{
        copyContacts.copyContactsMethod(acc.id);}
    catch(Exception e){
        System.assert( e.getMessage().contains('Update failed. First exception on ' +
                'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' +
                'contacts not updated[Miles__c]'), 
                e.getMessage() );
    }
            test.stopTest();
            }*/
}