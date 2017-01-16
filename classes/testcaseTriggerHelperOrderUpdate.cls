@isTest
public class testcaseTriggerHelperOrderUpdate {
    static testmethod void method1(){
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
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.project_name__c = p1.id;
        insert o;
        
         Opportunity op = new Opportunity();
        op.Name = 'Test Opp CompetitorHelper_Test2';
        op.StageName = 'Qualification';
        op.CloseDate = Date.today();
        op.Country__c = 'USA';
        op.Postal_Code__c = 'TEST';
        op.project_name__c =p1.id;
        insert op;
        test.startTest();
        Quote__c q1 = new Quote__c();
            q1.Name = 'Test Quote';
            q1.Opportunity__c = o.Id;
            q1.Primary_Quote__c=True;
            insert q1;
        
        Quote__c q2 = new Quote__c();
            q2.Name = 'Test Quote new';
            q2.Opportunity__c = op.Id;
            q2.Primary_Quote__c=false;
            insert q2;
        
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';   
        qd.quote__C = q1.id;
        insert qd;
        
         Quote_Detail__c qd1 = new Quote_Detail__c();
        qd1.Model__c = 'WA63';   
        qd1.quote__C = q2.id;
        insert qd1;
        
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         c.subject = 'Test';
        c.quote__c = q1.id;
        c.Description = 'Test Description'; 
        insert c;
        
        c.quote__c = q2.id;
        update c;
        test.stopTEst();
        
    }
    
    static testmethod void method2(){
         list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
             Project__c p1 = new Project__c();
           // p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             insert p1;
        
        Account acct = new Account(Name='My Test Account1',Type = 'Architecture Firm',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
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
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.project_name__c = p1.id;
        insert o;
        
         Opportunity op = new Opportunity();
        op.Name = 'Test Opp CompetitorHelper_Test2';
        op.StageName = 'Qualification';
        op.CloseDate = Date.today();
        op.Country__c = 'USA';
        op.Postal_Code__c = 'TEST';
        op.project_name__c =p1.id;
        insert op;
        test.startTest();
        Quote__c q1 = new Quote__c();
            q1.Name = 'Test Quote';
            q1.Opportunity__c = o.Id;
            q1.Primary_Quote__c=True;
            insert q1;
        
        Quote__c q2 = new Quote__c();
            q2.Name = 'Test Quote new';
            q2.Opportunity__c = op.Id;
            q2.Primary_Quote__c=false;
            insert q2;
        
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';   
        qd.quote__C = q1.id;
        insert qd;
        
         Quote_Detail__c qd1 = new Quote_Detail__c();
        qd1.Model__c = 'WA63';   
        qd1.quote__C = q2.id;
        insert qd1;
        
        order orr = new order();
            orr.Status = 'draft';
            orr.EffectiveDate = system.today();
            orr.nanaquote__c = q1.id;
            orr.accountid = acct.id;
        insert orr;
        
        order orr1 = new order();
            orr1.Status = 'draft';
            orr1.EffectiveDate = system.today();
            orr1.nanaquote__c = q2.id;
           orr1.accountid = acct.id;
        insert orr1;
        
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         c.subject = 'Test';
        c.order__C = orr.id;
        c.quote__c = q1.id;
        c.ContactId = co.id;
        c.Description = 'Test Description'; 
        insert c;
        
        c.order__c = orr1.id;
        update c;
        test.stopTEst();
    }
}