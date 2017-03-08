@isTest
public class SuccessRatioTableNew_Test {
   /* public static testmethod void unittestmethod(){
    list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<10; i++){
        
             Project__c p1 = new Project__c();
           
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        ProjectList[2].amount__c = 14590;
        ProjectList[2].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        ProjectList[3].amount__c = 14789;
        ProjectList[3].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        ProjectList[4].amount__c = 19087;
        ProjectList[4].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        Datetime yesterday = Datetime.now().addDays(-180);
        Test.setCreatedDate(ProjectList[0].Id, yesterday);
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        OpportunityList[0].amount =  ProjectList[1].amount__c;
        test.startTest();
        insert OpportunityList;
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList;
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<10; i++){
         Project_Split__c newSplits = new Project_Split__c();
         newSplits.Project__c = ProjectList[0].Id ;
         newSplits.Split__c = 2.0 ;
         newSplits.Account__c =olstAccount[0].id;
         newSplits.Project_Rep__c = Userinfo.getUserId();
         newSplit.add(newSplits);
         }
       insert newSplit ;
       
       list<Total_Order_Report_Data_Point__c> tplist = new list<Total_Order_Report_Data_Point__c>();
       for(integer i=0; i<10; i++)
       {
           Total_Order_Report_Data_Point__c tp = new Total_Order_Report_Data_Point__c();
           tp.name = 'Test';
           tp.Project__c = ProjectList[0].Id;
           tp.Project_Split__c = newSplit[0].id;
           tp.Nana_Quote__c =  QuoteList[0].id;
           tplist.add(tp);
       }
        MidWestSalesReps__c ms = new MidWestSalesReps__c();
        ms.name = 'Andy Cook';
        insert ms;
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        MidEasternSalesReps__c mes = new MidEasternSalesReps__c();
        mes.name = 'Paul Nalette';
        insert mes;
        WesternSalesReps__c ws = new WesternSalesReps__c();
        ws.name = 'Rob Laris';
        insert ws;
        insert tplist;
        
        
        successRatioControllerTablenew srct=new successRatioControllerTablenew();
        //srct.successRatioControllerTablenew();
        test.stopTest();
    
    }*/
    
    
}