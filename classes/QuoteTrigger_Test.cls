@isTest
public class QuoteTrigger_Test {
    public static list < Project__c > olstProject;
    public static list < Opportunity > olstOpportunity;
    public static list < Quote__c > olstQuote;
    public static list < Account > accounts;
    public static list < Zip_Codes_Master__c > territorymaster;
    public static User testUser;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Contact> contacts;
    public static list < Project__c > projects;
    
    public static testMethod void testQuoteTrigger() {

        test.startTest();
        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;
        list < Account > acc = new list < Account > ();
        Account a = new Account();
        a.Name = 'Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry = 'United States';
        a.BillingPostalCode = '12345';
        acc.add(a);

        insert acc;

        list < project__c > olstTestProject2 = new list < project__c > ();
        project__c p = new project__c();
        p.Name = 'xyz enterprise';
        p.Project_Zip_Code__c = '12345';
        p.Project_Country__c = 'United States';
        p.Close_Date__c = Date.newInstance(2015, 12, 12);
        p.Stage__c = 'Closed Lost - Project Lost';
        p.Reason_Project_Lost__c = 'Competitor';

        olstTestProject2.add(p);

        insert olstTestProject2[0];

        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].Project_Name__c = olstTestProject2[0].Id;
        olstOpportunity[0].AccountId = acc[0].id;
        olstOpportunity[0].StageName = 'Influencer Closed/Lost';
        olstOpportunity[0].Reason_Opportunity_Lost__c = 'Project Cancelled';

        insert olstOpportunity;

        olstQuote = TestDataUtility.createQuoteRecords(olstOpportunity);
        olstQuote[0].Printed__c = false;
        olstQuote[0].Primary_Quote__c = FALSE;
        olstQuote[0].Opportunity__c = olstOpportunity[0].id;
        olstQuote[0].Viewed__c = true;
        olstQuote[0].Ordered__c = true;
        olstQuote[0].Order_Confirmation_Sent__c = date.today();
        olstQuote[0].Complete_Signoff_Date__c = date.today();
        olstQuote[0].Deposit_Amount__c = 2000;
        olstQuote[0].Deposit_Date__c = date.today();
        olstQuote[0].Balanced_Received_Date__c = date.today();
        olstQuote[0].Order_Finalized_Date__c = date.today();
        // olstQuote[0].Order_Number__c = 12345 ; 
        olstQuote[0].Discount__c = 10;

        try {
            insert olstQuote;
        } catch (Exception e) {}

        Quote_Detail__c QD = new Quote_Detail__c();
        QD.Name = 'Test Name';
        QD.Quote__c = olstQuote[0].id;
        QD.Price__c = 2000;
        insert QD;

        test.stopTest();

        olstQuote[0].Printed__c = true;
        olstQuote[0].Balanced_Received_Date__c = date.today() - 5;
        olstQuote[0].Order_Finalized_Date__c = date.today() - 7;
        // olstQuote[0].Order_Number__c = 54321 ; 
        olstQuote[0].Discount__c = 15;


        try {
            update olstQuote;
        } catch (Exception e) {}

        
    }
    
}