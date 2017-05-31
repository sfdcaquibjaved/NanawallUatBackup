@isTest
public class Test_ServiceQuoteDetail_Delete {
   
    public static testMethod void RunTest1(){
        
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = TriggerTests.getproject();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co = TriggerTests.getContact();
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

        
        
         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
        
         Quote__c q = TriggerTests.getNewQuote();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         /*order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;*/
         
        case c = TriggerTests.getNewCase();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
       //  c.Order__c = ord.id;        
        
        insert c;
       
        case c1 = TriggerTests.getNewCase();
         c1.Origin = 'Phone';
         c1.Status = 'New';
         c1.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c1.subject = 'Test';
         c1.Description = 'Test Description'; 
       //  c.Order__c = ord.id;        
        
        insert c1;
       
        
        
        
         test.StartTest();
        
         Service_Quote__c sq= TriggerTests.getNewServiceQuote();
         sq.Case__c=c.Id;
         sq.Complaint__c=false;
         insert sq;
        
        Service_Quote__c sq1= TriggerTests.getNewServiceQuote();
         sq1.Case__c=c.Id;
         sq1.Complaint__c=false;
         insert sq1;
        
         
         
         Quote_Detail__c qd = TriggerTests.getNewQuoteDetail();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         insert qd;
        // update sqd;
        
        Service_Quote_Detail__c sqd = TriggerTests.getNewServiceQuoteDetail();
        sqd.Service_Quote__c = sq.Id;
        sqd.Position__c = 2;
        insert sqd;
        
        
        
        
        Service_Quote_Detail__c sqd1 = TriggerTests.getNewServiceQuoteDetail();
        sqd1.Service_Quote__c = sq1.Id;
        sqd1.Position__c = 4;
        insert sqd1;
        
        
        
         delete sqd;

         delete sq;      
         delete c;


         delete q;

       
         test.stopTest();
        
    }
    
     public static testMethod void RunTest2(){
        
      
                list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = TriggerTests.getproject();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co = TriggerTests.getContact();
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

        
        
         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
        
         Quote__c q = TriggerTests.getNewQuote();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         /*order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;*/
         
        case c = TriggerTests.getNewCase();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
       //  c.Order__c = ord.id;        
        
        insert c;
       
        case c1 = TriggerTests.getNewCase();
         c1.Origin = 'Phone';
         c1.Status = 'New';
         c1.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c1.subject = 'Test';
         c1.Description = 'Test Description'; 
       //  c.Order__c = ord.id;        
        
        insert c1;
       
        
        
        
         test.StartTest();
        
         Service_Quote__c sq= TriggerTests.getNewServiceQuote();
         sq.Case__c=c.Id;
         sq.Complaint__c=false;
         insert sq;
        
        Service_Quote__c sq1= TriggerTests.getNewServiceQuote();
         sq1.Case__c=c.Id;
         sq1.Complaint__c=false;
         insert sq1;
        
         
         
         Quote_Detail__c qd = TriggerTests.getNewQuoteDetail();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         insert qd;
        // update sqd;
        
        Service_Quote_Detail__c sqd = TriggerTests.getNewServiceQuoteDetail();
        sqd.Service_Quote__c = sq.Id;
        sqd.Position__c = 2;
        insert sqd;
        delete sqd;
        
        
        
        Service_Quote_Detail__c sqd1 = TriggerTests.getNewServiceQuoteDetail();
        sqd1.Service_Quote__c = sq.Id;
        sqd1.Position__c = 4;
        insert sqd1;
        update sqd1;
        
        
         

        
       
         test.stopTest();
        
     
     }
}