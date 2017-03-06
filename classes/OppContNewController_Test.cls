@isTest
public class OppContNewController_Test {
    public static testMethod void testMyController() {
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
         con.Email='test@test.com';
         con.MailingStreet = 'street';
         con.MailingCity = 'city'; 
         con.Mailingstate = 'Utah';
         con.MailingPostalCode = '12345';
         con.MailingCountryCode = 'US';
         insert con;
         
         
         List< Opportunity > oppList = new list < Opportunity > ();
		 Opportunity opp=new Opportunity();
         opp.Name='test opp';
         opp.AccountId=acc.id;
         opp.Amount=1000;
         opp.Probability=20;
         opp.StageName='Need Analysis';
         opp.CloseDate = Date.today()+10;
         //oppList.add(opp);
         insert opp;
        
        nrOpportunityContactRole__c nr=new nrOpportunityContactRole__c();
         nr.Opportunity__c=opp.id;
         nr.Contact__c=con.id;
         insert nr;
      /*  test.startTest();
        PageReference Pcon = Page.nrOppContactRoleNew;
         Test.setCurrentPage(Pcon);
        ApexPages.StandardController sc = new ApexPages.StandardController(nr);
        OppContNewController oc=new OppContNewController(sc);
        oc.getOCR();
        oc.getContactName();
        oc.Save();
        oc.Cancel();
        test.stopTest();*/
    }

}