@isTest
public class testcopydatatocontacts {
    static testmethod void method_1(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
             Project__c p1 = new Project__c();
           // p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
            insert acct; 
         contact co=new contact();
         co.Accountid = acct.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
        insert co;
        
        test.startTest();
  PageReference pageRef = Page.CopyDataToContacts; // Add your VF page Name here
  pageRef.getParameters().put('id', String.valueOf(acct.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(acct);
  CopyDataToContacts cc = new CopyDataToContacts(sc);
  CopyDataToContacts.wrapContact wc=new CopyDataToContacts.wrapContact(co);
  CopyDataToContacts.wrapAccountDetails wa=new CopyDataToContacts.wrapAccountDetails('Shipping City');
        CopyDataToContacts.wrapAccountDetails waa=new CopyDataToContacts.wrapAccountDetails('Shipping Country');
        CopyDataToContacts.wrapAccountDetails wab=new CopyDataToContacts.wrapAccountDetails('Shipping Street');
        CopyDataToContacts.wrapAccountDetails wac=new CopyDataToContacts.wrapAccountDetails('Shipping Zip/Postal Cod');
        CopyDataToContacts.wrapAccountDetails wad=new CopyDataToContacts.wrapAccountDetails('Shipping State/Province Code');
        CopyDataToContacts.wrapAccountDetails wae=new CopyDataToContacts.wrapAccountDetails('Shipping Country Code');
        CopyDataToContacts.wrapAccountDetails waf=new CopyDataToContacts.wrapAccountDetails('Billing State/Province Code');
        CopyDataToContacts.wrapAccountDetails wag=new CopyDataToContacts.wrapAccountDetails('Billing Country');
        CopyDataToContacts.wrapAccountDetails wah=new CopyDataToContacts.wrapAccountDetails('Billing Street');
        CopyDataToContacts.wrapAccountDetails wai=new CopyDataToContacts.wrapAccountDetails('Billing Zip/Postal Code');
        CopyDataToContacts.wrapAccountDetails waj=new CopyDataToContacts.wrapAccountDetails('Billing City');
        CopyDataToContacts.wrapAccountDetails wak=new CopyDataToContacts.wrapAccountDetails('Billing Country Code');
        CopyDataToContacts.wrapAccountDetails wal=new CopyDataToContacts.wrapAccountDetails('Account Phone');
        CopyDataToContacts.wrapAccountDetails wam=new CopyDataToContacts.wrapAccountDetails('Account Fax');

   cc.wrapcontactList[0].isSelected=true;
   cc.wrapAccountFields[0].isSelected=true;
        for(integer i=0;i<cc.wrapAccountFields.size();i++){
            //ApexPages.StandardController sc = new ApexPages.StandardController(acct);
  //CopyDataToContacts cc = new CopyDataToContacts(sc);
            cc.wrapAccountFields[i].isSelected=true;
        }

   cc.bStreet = true;
   cc.bCity = true;
   cc.bState = true;
   cc.bPostalCode = true;
  cc.ButtonClicked(); 
    test.stopTest();
        
    }
}