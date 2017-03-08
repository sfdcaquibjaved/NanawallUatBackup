@IsTest
public class Quote_AuditEventList_ControllerTest {
public static list<Opportunity> olstOpportunity;
     public static list<Quote__c> olstQuote;
    static testMethod void myUnitTest() 
    {
        
        /*
        olstOpportunity=TestDataUtility.createOppTestData();
        insert olstOpportunity;
        
        olstQuote=TestDataUtility.createQuoteRecords(olstOpportunity);
        insert olstQuote;
        */
        
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
        
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
        insert con;
        
        Project__c p1 = new Project__c();
           // p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             insert p1;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.project_name__c = p1.id;
        insert o;
        
        
        
        //olstopportunity[0].
        //list<Quote__c> quo=new list<Quote__c>();
        Quote__c q=new Quote__c();
        q.Name = 'Test Quote';
            q.Opportunity__c = o.Id;
            q.Primary_Quote__c=True;
        //q.Quote_ID__c=123;
        //quo.add(q);
        //insert quo;
        insert q;
        
       ApexPages.StandardController sc = new ApexPages.StandardController(q);
       Quote_AuditEventList_Controller qaudit=new Quote_AuditEventList_Controller(sc);
        PageReference pageRef = Page.Quote_AuditEventList;
        Test.setCurrentPage(pageRef);
        qaudit.GetEvents(); 
        qaudit.formatNanaSoapPayload('xml');
        //Quote_AuditEventList_Controller.runtest();
       //Quote_AuditEventList_Controller.runtest(); 
    }
}