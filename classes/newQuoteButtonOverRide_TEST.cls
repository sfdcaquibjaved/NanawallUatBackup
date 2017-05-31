@istest
public class newQuoteButtonOverRide_TEST {
 static testMethod void testobjectsOwnerUpdatefromZip(){
     
    list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
       
      
         project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             //p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             //p1.Stage__c='Quote - Provided';
             insert p1;
        
    list<Account> acc = new list<account>();
    acc= TestDataUtility.createAccountTestData();
     acc[0].Type='Architecture Firm';
    acc[0].OwnerId=testUser.id;
   // acc[1].OwnerId=testUser1.id;
     //acc[1].Type='other';
    insert acc;
        
    list<Contact> con = new List<Contact>();
        con = TestDataUtility.createConTestData();
        con[0].FirstName = 'foo';
        con[0].LastName = 'bar';
        //con[0].MailingStreet = 'street';
        //con[0].MailingCity = 'city'; 
       // con[0].MailingstateCode = 'CA';
        con[0].MailingPostalCode = '12345';
       // con[0].MailingCountryCode = 'US';
        con[0].Accountid = acc[0].id; 
        insert con;
    
    list<opportunity> opp = new list<opportunity>();
    opp=TestDataUtility.createOppTestData();
    opp[0].Project_Name__c=p1.id;
    opp[0].accountid=acc[0].id;
    opp[0].ownerId=testUser.id;
    
    insert opp;
  
        list<Quote__c> qt = new list<Quote__c>();
      		Quote__c q = new Quote__c();
           q.Name = 'Test Quote3';
           q.Opportunity__c = opp[0].Id;
           q.Contact__c = con[0].id;
           //q.Order_Number__c =12388; 
           //q.Balanced_Received_Date__c=Date.today();
           //q.Order_Finalized_Date__c=Date.today();
           //q.Primary_Quote__c=true;
           //q.Discount__c=10;
           qt.add(q);
           insert qt[0];
     	
     PageReference Pcon = Page.quote_button_overide;
     Test.setCurrentPage(Pcon);
   //  ApexPages.currentPage().getParameters().put('set',qt[0].Id);
		
      //String id1 =  ApexPages.currentPage().getParameters().put('CF00NA0000001O58u') 
     
     
       ApexPAges.StandardController sc = new ApexPages.StandardController(qt[0]);
       newQuoteButtonOverRide testController = new newQuoteButtonOverRide(sc);
        testController.redirect();
 }
}