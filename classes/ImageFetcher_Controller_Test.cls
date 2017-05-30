@isTest
public class ImageFetcher_Controller_Test {

    static testMethod void myUnitTest() {
        
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
        
        	 
             
        	list<contact> conList =new list<contact>();
             contact con=new contact();
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
        	conList.add(con);
             insert conList;
        	con.FirstName = 'Test';
             con.LastName = 'don';
        	update conList;
        
        List<Task> tasks = new List<Task>();
             tasks.add(new Task(
             ActivityDate = Date.today().addDays(7),
             Subject='Send Mailbook',
             WhatId = acc.Id,
             WhoId = conList[0].id,
             OwnerId = UserInfo.getUserId(),
             Status='In Progress'));
             insert tasks;
             
             Opportunity opp=new Opportunity();
             opp.Name='test opp';
             opp.AccountId=acc.id;
             opp.Amount=1000;
             opp.Probability=20;
             opp.StageName='Need Analysis';
             opp.CloseDate = Date.today()+10;
             insert opp;
        
        Apexpages.currentPage().getParameters().put('emailtype','installer');
        
         Quote__c qt=new Quote__c();
         qt.Name='test quote';
         qt.AACO__c=true;
         qt.Actual_Delivery_Date__c=date.today();
         qt.Actual_Pickup_Date__c=date.today();
         qt.Address__c='abc';
         qt.Average_Quote_Discount__c=15.23;
         qt.Balanced_Received_Date__c=date.today();
         qt.Balance_Received__c=20.66;
         qt.CAD_Opened__c=system.now();
        // qt.CAD_Sent__c=system.now();
         qt.CAD_Viewed__c=false;
         qt.Canadian_Tax_Status__c='Company';
         qt.Cancelled__c=true;
         qt.City__c='abc';  
         qt.Opportunity__c=opp.id;
        insert qt;
        
        Apexpages.currentPage().getParameters().put('quoteid',qt.Id);
        ImageFetcher_Controller ic=new ImageFetcher_Controller();
        ic.getImage();
    }
}