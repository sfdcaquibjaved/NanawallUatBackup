/**
    @ Author        : Durga
    @ Date          : December  2015
    @ Description   : Test Class for PrelimDrawings vf page
  
    -----------------------------------------------------------------------------
 */
@isTest
private class PrelimDrawingsTest {
    public static list<Account> olstAccount = new list<Account>() ;
    public static list<Contact> olstContact = new list<Contact>();
    public static list<Opportunity> olstOpportunity = new list<Opportunity>();
    public static list<Quote__c> orderstarted = new list<Quote__c>();
    public static list<Quote__c> olstQuote = new list<Quote__c>();
    public static list<Quote__c> DrawingStarted = new list<Quote__c>();
    public static list<Quote__c> OrderFinalizationProcess = new list<Quote__c>();
    public static list<Quote__c> OrdersOnHold = new list<Quote__c>();
    public static list<Quote__c> OrdersFinalized = new list<Quote__c>();
    public static User testUser ;
    public static integer count;
    public static integer count1;
    public static integer count2;
    public static integer count3;
    public static integer count4;
     public static string DrawingOwner;
    
    public static testMethod void myUnitTest() {
        //Insert testUser Details
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
            insert testUser;
         list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
        // Insert Account Details
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
            insert olstAccount ;
       //Insert test contact records
        olstContact = TestDataUtility.createConTestData();
        system.debug('COntact####' + olstContact);
        olstContact[0].AccountId = olstAccount[0].Id ;
        //try{
            insert olstContact[0];
        //}catch(Exception e){
            
        //}
        list<Project__c> olstProject =new list<Project__c>();
        Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
       // p.Stage__c='Prospecting';
        p.Application__c = 'Automotive';
        p.Application_2__c = 'Dealership';
        p.Preliminary_Drawings__c = true;
        olstProject.add(p);
        
        insert olstProject;
        
        //insert test Opportunity records 
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        olstOpportunity[0].Project_Name__c = olstProject[0].Id;
        olstOpportunity[0].Preliminary_Drawlings__c = True;
        olstOpportunity[0].Preliminary_Drawlings__c = false;
        
        //olstOpportunity[0].StageName='Quote - Requested';
       // olstOpportunity[0].Owner.Name = testUser; 
            insert olstOpportunity ;
        system.debug('$$$'+olstOpportunity);
        
        
        //olstQuote = TestDataUtility.createQuoteRecords(olstOpportunity);
        Quote__C q = new Quote__C();
        q.Name = 'Test Quote' + 11;
        q.Opportunity__c = olstOpportunity[0].Id;
        q.Primary_Quote__c=True;
        //q.Drawing_Deposit__c = system.today();
        q.Drawing_Order_Confirmation_Signoff__c = system.today();
        q.Drawing_Customer_Drawings_Received__c = system.today();
        q.Custom_Drawing__c=True;
        q.Order_Number__c = 123;
        q.Pipeline_Notes__c ='';  
        //qt.Opportunity__r.StageName ='Quote - Requested';
        olstQuote.add(q);
        
        Quote__C qt = new Quote__C();
        qt.Name = 'Test Quote' + 11;
        qt.Opportunity__c = olstOpportunity[0].Id;
        qt.Primary_Quote__c=True;
        qt.Drawing_Deposit__c = system.today();
        qt.Drawing_Order_Confirmation_Signoff__c = system.today();
        qt.Drawing_Customer_Drawings_Received__c = system.today();
        qt.Custom_Drawing__c=True;
        qt.Order_Number__c = 123;
        qt.Pipeline_Notes__c ='';  
        
        //qt.Opportunity__r.StageName ='Quote - Requested';
        olstQuote.add(qt);
        
        Quote__C qt1 = new Quote__C();
        qt1.Name = 'Test Quote' + 12;
        qt1.Opportunity__c = olstOpportunity[0].Id;
        qt1.Primary_Quote__c=True;
        qt1.Drawing_Deposit_Amount__c = 1000;
        qt1.Drawing_Deposit__c = system.today();
        qt1.Drawing_Order_Confirmation_Signoff__c = system.today();
        qt1.Drawing_Customer_Drawings_Received__c = system.today();
        qt1.Drawing_Eng_Clarification_Contact__c = system.today();
        qt1.Drawing_Complete__c = system.today();
        qt1.Drawing_Internal_Approval__c = system.today();
        qt1.Drawing_Final_Documents_Sent__c = system.today();
        qt1.Drawing_First_Submittal_Order_Sent__c = system.today();
        qt1.Order_Finalized_Date__c = system.today();
        qt1.Custom_Drawing__c=True;
        qt1.Order_Number__c = 123;
        qt1.Pipeline_Notes__c ='';  
        //qt.Opportunity__r.StageName ='Order - Requested';
        olstQuote.add(qt1); 
        Quote__C qt2 = new Quote__C();
        qt2.Name = 'Test Quote' + 12;
        qt2.Opportunity__c = olstOpportunity[0].Id;
        qt2.Primary_Quote__c=True;
        
        qt2.Drawing_Deposit_Amount__c = 1000;
        qt2.Drawing_Deposit__c = system.today();
        qt2.Drawing_Order_Confirmation_Signoff__c = system.today();
        qt2.Drawing_Customer_Drawings_Received__c = system.today();
        qt2.Drawing_Eng_Clarification_Contact__c = system.today();
        qt2.Drawing_Complete__c = system.today();
        qt2.Drawing_Internal_Approval__c = system.today();
        qt2.Drawing_Final_Documents_Sent__c = system.today();
        qt2.Drawing_First_Submittal_Order_Sent__c = system.today();
        qt2.Drawing_Additional_Payment_Received__c = system.today();
        qt2.Drawing_Final_Order_Confirmation__c = system.today();
        qt2.Drawing_Final_Signoff__c = system.today();
        qt2.Order_Finalized_Date__c = system.today();
        qt2.Custom_Drawing__c=True;
        qt2.Order_Number__c = 123;
        qt2.Pipeline_Notes__c ='';  
        //qt.Opportunity__r.StageName ='Order - Requested';
        olstQuote.add(qt2);
        
        Quote__C qt3 = new Quote__C();
        qt3.Name = 'Test Quote' + 12;
        qt3.Opportunity__c = olstOpportunity[0].Id;
        qt3.Primary_Quote__c=True;
        qt3.Drawing_Deposit_Amount__c = 1000;
        qt3.Drawing_Deposit__c = system.today();
        qt3.Drawing_Order_Confirmation_Signoff__c = system.today();
        qt3.Drawing_Customer_Drawings_Received__c = system.today();
        qt3.Drawing_Eng_Clarification_Contact__c = system.today();
        qt3.Drawing_Complete__c = system.today();
        qt3.Drawing_Internal_Approval__c = system.today();
        qt3.Drawing_Final_Documents_Sent__c = system.today();
        qt3.Drawing_First_Submittal_Order_Sent__c = system.today();
        qt3.Drawing_Additional_Payment_Received__c = system.today();
        qt3.Drawing_Final_Order_Confirmation__c = system.today();
        qt3.Drawing_Final_Signoff__c = system.today();
        qt3.Order_Finalized_Date__c = system.today();
        qt3.Drawing_On_Hold_Till_Date__c = system.today();
        qt3.Custom_Drawing__c=True;
        qt3.Order_Number__c = 123;
        qt3.Pipeline_Notes__c ='';  
        //qt.Opportunity__r.StageName ='Order - Requested';
        olstQuote.add(qt3);
        
    
        insert olstQuote;
        
        
        Test.StartTest();
        system.debug('####Ashutosh');
          prelimDrawingsV2 pdc = new prelimDrawingsV2();
        
        Test.StopTest();
        
      }
    
}