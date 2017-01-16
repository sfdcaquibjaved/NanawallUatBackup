@isTest
public class QuoteDetailTest {
    
   
    
    public static testMethod void testQuoteDetail_UpdateProjetModels2(){
         
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
         
          
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
       
        insert olstAccount[0];
        
    
         
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();
           
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             //p1.Amount__c =1500;
             p1.Stage__c='Order - Negotiation';
             p1.Award_date__c = System.today();
             p1.Bid_date__c = System.today();
             ProjectList.add(p1);
        }
        
       
       
        ProjectList[0].amount__c = 124;
        ProjectList[0].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        ProjectList[2].amount__c = 14590;
        ProjectList[2].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        ProjectList[3].amount__c = 14789;
        ProjectList[3].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        ProjectList[4].amount__c = 19087;
        ProjectList[4].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
         
             
        
          
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        OpportunityList[0].Amount= 2100;
        OpportunityList[0].Bal_received_date_from_quotes__c= True;
        OpportunityList[0].Order_Final_Date_from_quote__c= True;
        OpportunityList[0].StageName='Order - Negotiation/Review';
  
        insert OpportunityList[0];
             
      
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];

            
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
       /* QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[0].Model__C='CERO';
        //QuoteDetailList[1].Price__c=1235;
        //QuoteDetailList[0].Discount__c=12; 
        //QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];*/
      
           
        QuoteDetailList[1].Price__c=5678;
        QuoteDetailList[1].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Model__C='CERO';
        QuoteDetailList[1].Discount__c=10;
        insert QuoteDetailList[1];
        test.starttest();
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[1].Discount__c=10;
        update QuoteDetailList[1];

       // QuoteDetailList[1].Model__C='HSW 50';
               
        delete QuoteDetailList[1];
        
        QuoteDetailList[2].Quote__C=QuoteList[0].id;
        QuoteDetailList[2].Model__C='HSW 50';
        //QuoteDetailList[3].Price__c=1235;
        //QuoteDetailList[4].Price__c=56708;
        insert QuoteDetailList[2];
        
        QuoteDetailList[2].Model__C='CERO';
        update QuoteDetailList[2];
       
        test.stoptest();
                           
       
        
    }

}