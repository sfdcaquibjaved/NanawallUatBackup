@isTest
public class testQuoteTriggerHandler {
    static testmethod void method1(){
       
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;
        
         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'California';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type ='Competitor Firm';
        insert a;
        
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.AccountID = a.id;
        insert con;
        
        Project__c p1 = new Project__c();
           // p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             insert p1;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;
        test.startTest();
        Quote__c q = new Quote__c();
            q.Name = 'Test Quote';
            q.Opportunity__c = o.Id;
            q.Primary_Quote__c=True;
            q.contact__c = con.id;
            q.Balanced_Received_Date__c = System.today();
            q.Shipping_Min__c = 6;
            insert q; 
        test.stopTest();
       
        
    }
}