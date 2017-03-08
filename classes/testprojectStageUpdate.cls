@isTest
public class testprojectStageUpdate {
    static testmethod void changestage1(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type ='Competitor Firm';
        insert a;
        
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040' ;
        p1.stage__c = 'Prospecting';
        insert p1;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.stagename = 'Drawings - Provided';
        o.accountid = a.id;
        o.Project_Name__c = p1.id;
        insert o;
        
        test.startTest();
        p1.stage__c = 'Closed Lost - Project Cancelled';
        p1.Reason_Project_Lost__c = 'Competitor';
        update p1;
        test.stopTest();
    }
     static testmethod void changestage2(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type ='Competitor Firm';
        insert a;
        
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040' ;
        p1.stage__c = 'Design';
        p1.Reason_Project_Lost__c = 'Competitor';
        insert p1;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.stagename = 'Drawings - Provided';
        o.accountid = a.id;
        o.Project_Name__c = p1.id;
        insert o;
        
        test.startTest();
        p1.stage__c = 'Closed - Inactivity';
        update p1;
        test.stopTest();
    }
     /*static testmethod void changestage3(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type ='Competitor Firm';
        insert a;
        
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040' ;
        p1.stage__c = 'Design';
        p1.Reason_Project_Lost__c = 'Competitor';
        p1.amount__c = 0;
        insert p1;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.stagename = 'Drawings - Provided';
        o.accountid = a.id;
        o.Project_Name__c = p1.id;
        o.amount = 0;
        insert o;
        
        test.startTest();
        o.amount = 500;
         update o;
        test.stopTest();
    }*/
}