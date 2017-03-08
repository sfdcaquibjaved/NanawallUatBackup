@isTest
public class SuccessRatioApplication_Test {
    public static testmethod void unittestmethod(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        insert caa;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        Test.startTest();
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        ms.name = 'Ray Van Nes';
        ms.name = 'Andy Cook';
        ms.name = 'Anne Morse';
        ms.name = 'Bruce Hillyer';
        ms.name = 'Bryan Bush';
        ms.name = 'Dennis Mills';
        ms.name = 'Harmen Bollen';
        ms.name = 'Katie Stombaugh';
        ms.name = 'Kenny Cobb';
        ms.name = 'Larry Vernier';
        ms.name = 'Matt Tudor';
        ms.name = 'Scott Smith';
        ms.name = 'Stacie Caldwell';
        insert ms;
        
        /*EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        MidEasternSalesReps__c mes = new MidEasternSalesReps__c();
        mes.name = 'Paul Nalette';
        insert mes;
        WesternSalesReps__c ws = new WesternSalesReps__c();
        ws.name = 'Rob Laris';
        insert ws;*/
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.projecttype='Commercial Projects';
        sd.ProjectChoice='By Quarter';
        sd.ChangeReport();
        sd.getRegionlist();
        sd.projecttype='Residential Project';
        sd.ProjectChoice='By Halfyear';
        sd.ChangeReport();
        sd.projecttype='--None--';
        
        sd.ChangeReport();
        
        
        
        
        sd.regionname='Eastern Sales';
        sd.projecttype='Commercial';
        sd.ProjectChoice='By Quarter';
        sd.applicationname='Health Care';
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        sd.regionname='Eastern Sales';
        sd.projecttype='Residential';
        sd.ProjectChoice='By Quarter';
        sd.applicationname='Single Family - New';
        sd.getRegionlist();
        sd.ChangeReport();
        
        test.stopTest();
              
    }
    
    public static testmethod void unittestmethod1(){
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<10; i++){
        
             Project__c p1 = new Project__c();
           
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        Test.startTest();
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        es.name = 'Bill & Beverly Gere';
        es.name = 'Jim Huff';
        es.name = 'Joe Bennett';
        es.name = 'John Aiello';
        es.name = 'Marcel Besner';
        es.name = 'Mark Briggs';
        es.name = 'Peter Newton';
        es.name = 'Ron Walker';
        es.Name = 'Stuart Ferrell';
        insert es;
        
        /*MidEasternSalesReps__c mes = new MidEasternSalesReps__c();
        mes.name = 'Paul Nalette';
        mes.name = 'Georges Lagasse';
        mes.name = 'Miguel Rosani';
        insert mes;
        WesternSalesReps__c ws = new WesternSalesReps__c();
        ws.name = 'Rob Laris';
        insert ws;*/
        insert tplist;
       
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        //sd.projecttype='Commercial Projects';
        sd.ProjectChoice='By Quarter';
        sd.ChangeReport();
        sd.getRegionlist();
        //sd.projecttype='Residential Project';
        sd.ProjectChoice='By Halfyear';
        sd.ChangeReport();
        sd.ProjectChoice='By year';
        sd.ChangeReport();
        sd.projecttype='--None--';
        
        sd.ChangeReport();
        sd.regionname='Eastern Sales';
        sd.projecttype='Residential';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Common Area';
        sd.getRegionlist();
        sd.ChangeReport();
        /*sd.regionname='Eastern Sales';
        sd.projecttype='commercial';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='office';
        sd.getRegionlist();
        sd.ChangeReport();*/
        
        
        test.stopTest();
              
    }
    
    
    
    public static testmethod void unittestmethod2(){
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        test.starttest();
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<10; i++){
        
             Project__c p1 = new Project__c();
           
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
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
        
        MidEasternSalesReps__c mes = new MidEasternSalesReps__c();
        mes.name = 'Paul Nalette';
        mes.name = 'Georges Lagasse';
        mes.name = 'Miguel Rosani';
        insert mes;
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        //sd.projecttype='Commercial Projects';
        /*sd.ProjectChoice='By Quarter';
        sd.ChangeReport();
        sd.getRegionlist();
        //sd.projecttype='Residential Project';
        sd.ProjectChoice='By Halfyear';
        sd.ChangeReport();
        sd.ProjectChoice='By year';
        sd.ChangeReport();
        sd.projecttype='--None--';
        
        sd.ChangeReport();*/
        sd.regionname='Eastern Sales';
        sd.projecttype='commercial';
        sd.ProjectChoice='By Quarter';
        sd.applicationname='Health Care';
        sd.getRegionlist();
        sd.ChangeReport();
        sd.regionname='Eastern Sales';
        sd.projecttype='commercial';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Health Care';
        sd.getRegionlist();
        sd.ChangeReport();
        sd.regionname='Eastern Sales';
        sd.projecttype='commercial';
        sd.ProjectChoice='By year';
        sd.applicationname='Health Care';
        sd.getRegionlist();
        sd.ChangeReport();
        /*sd.regionname='Eastern Sales';
        sd.projecttype='commercial';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='office';
        sd.getRegionlist();
        sd.ChangeReport();*/
        
        
        test.stopTest();
              
    }
    
    
    
    
    public static testmethod void unittestmethod3(){
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;

         
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<10; i++){
        
             Project__c p1 = new Project__c();
           
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        test.starttest();
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
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
        
        WesternSalesReps__c ws = new WesternSalesReps__c();
        ws.name = 'Rob Laris';
        ws.name = 'Brad Burden';
        ws.name = 'Matt Galloro';
        ws.name = 'Stewart McIsack';
        insert ws;
        insert tplist;
       
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        //sd.projecttype='Commercial Projects';
        /*sd.ProjectChoice='By Quarter';
        sd.ChangeReport();
        sd.getRegionlist();
        //sd.projecttype='Residential Project';
        sd.ProjectChoice='By Halfyear';
        sd.ChangeReport();
        sd.ProjectChoice='By year';
        sd.ChangeReport();
        sd.projecttype='--None--';
        
        sd.ChangeReport();*/
        
        sd.regionname='western Sales';
        sd.projecttype='commercial';
        sd.ProjectChoice='By year';
        sd.applicationname='Health Care';
        sd.getRegionlist();
        sd.ChangeReport();
        sd.regionname='western Sales';
        sd.projecttype='Residential';
        sd.ProjectChoice='By year';
        sd.applicationname='Multifamily - Remodel';
        sd.getRegionlist();
        sd.ChangeReport();
        sd.ProjectChoice='By year';
        sd.projecttype='--None--';
        sd.applicationname='--None--';
        sd.ChangeReport();
        
        sd.regionname='western Sales';
        sd.projecttype='commercial';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Health Care';
        sd.getRegionlist();
        sd.ChangeReport();
        sd.regionname='western Sales';
        sd.projecttype='Residential';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Multifamily - Remodel';
        sd.getRegionlist();
        sd.ChangeReport();
        sd.ProjectChoice='By Halfyear';
        sd.projecttype='--None--';
        sd.applicationname='--None--';
        sd.ChangeReport();
        
        
        
        test.stopTest();
              
    }
    
    public static testmethod void unittestmethod4(){
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        test.starttest();
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        ProjectList[0].amount__c = 124;
        ProjectList[0].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        
        insert ProjectList[0];
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        es.name = 'Bill & Beverly Gere';
        es.name = 'Jim Huff';
        es.name = 'Joe Bennett';
        es.name = 'John Aiello';
        es.name = 'Marcel Besner';
        es.name = 'Mark Briggs';
        es.name = 'Peter Newton';
        es.name = 'Ron Walker';
        es.Name = 'Stuart Ferrell';
        insert es;
        
        
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.ProjectChoice='By Quarter';
        sd.ChangeReport();
        sd.getRegionlist();
        //sd.projecttype='Residential Project';
        sd.ProjectChoice='By Halfyear';
        sd.ChangeReport();
        sd.ProjectChoice='By year';
        sd.ChangeReport();
        sd.projecttype='--None--';
        sd.ChangeReport();
        
        sd.regionname='Eastern Sales';
        sd.projecttype='commercial';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Health Care';
        sd.getRegionlist();
        sd.ChangeReport();
        
        test.stopTest();
              
    }
    
     public static testmethod void unittestmethod5(){
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
         
         test.starttest();
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        ProjectList[0].amount__c = 124;
        ProjectList[0].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        
        insert ProjectList[0];
         
                
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        es.name = 'Bill & Beverly Gere';
        es.name = 'Jim Huff';
        es.name = 'Joe Bennett';
        es.name = 'John Aiello';
        es.name = 'Marcel Besner';
        es.name = 'Mark Briggs';
        es.name = 'Peter Newton';
        es.name = 'Ron Walker';
        es.Name = 'Stuart Ferrell';
        insert es;
        
        
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.ProjectChoice='By Quarter';
        sd.projecttype='Residential Project';
        sd.ChangeReport();
        sd.getRegionlist();
        
        sd.ProjectChoice='By Halfyear';
        sd.ChangeReport();
        sd.ProjectChoice='By year';
        sd.ChangeReport();
        sd.projecttype='--None--';
        sd.ChangeReport();
        
        sd.regionname='Eastern Sales';
        sd.projecttype='commercial';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Health Care';
        sd.getRegionlist();
        sd.ChangeReport();
        
        test.stopTest();
              
    }
    
    
    public static testmethod void unittestmethod6(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        caa.Name='Health Care';
        insert caa;
        
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
         test.starttest();
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        
        insert tplist;
       
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.projecttype='Commercial Projects';
        sd.regionname='Eastern Sales';
        sd.projecttype='Commercial';
        //sd.ProjectChoice='By Quarter';
        sd.ProjectChoice='By Halfyear';
        //sd.applicationname='Health Care';
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        test.stopTest();
              
    }
    
    
    
    public static testmethod void unittestmethod7(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        caa.Name='Health Care';
        insert caa;
        
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
          
      
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        Datetime yesterday = Datetime.now().addDays(+90);
        Test.setCreatedDate(ProjectList[0].Id, yesterday);
         test.starttest();
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        
        insert tplist;
       
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.projecttype='Commercial Projects';
        //sd.regionname='Eastern Sales';
        //sd.projecttype='Commercial';
        //sd.ProjectChoice='By Quarter';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Health Care';
        
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        test.stopTest();
              
    }
    
    
    public static testmethod void unittestmethod8(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        caa.Name='Health Care';
        insert caa;
        
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        Datetime yesterday = Datetime.now().addDays(-180);
        Test.setCreatedDate(ProjectList[0].Id, yesterday);
        
        test.starttest();
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        /*EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;*/
        
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.projecttype='Commercial Projects';
        //sd.regionname='Eastern Sales';
        sd.projecttype='Commercial';
        //sd.ProjectChoice='By Quarter';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Health Care';
        sd.ProjectChoice='By Year';
        sd.applicationname='Health Care';
        
        
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        test.stopTest();
              
    }
    
    
    public static testmethod void unittestmethod9(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        caa.Name='Health Care';
        insert caa;
        
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        Datetime yesterday = Datetime.now().addDays(-180);
        Test.setCreatedDate(ProjectList[0].Id, yesterday);
         test.starttest();
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        /*EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;*/
        
        insert tplist;
       
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.projecttype='Commercial Projects';
        sd.regionname='Eastern Sales';
        sd.projecttype='Commercial';
        //sd.ProjectChoice='By Quarter';
        
        sd.ProjectChoice='By Year';
        //sd.applicationname='Health Care';
        
        
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        test.stopTest();
              
    }
    
  
    public static testmethod void unittestmethod10(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        caa.Name='Health Care';
        insert caa;
        
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        Datetime yesterday = Datetime.now().addDays(-90);
        Test.setCreatedDate(ProjectList[0].Id, yesterday);
        
        test.starttest();
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.projecttype='Commercial Projects';
        //sd.regionname='Eastern Sales';
        //sd.projecttype='Commercial';
        //sd.ProjectChoice='By Quarter';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Health Care';
        
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        test.stopTest();
              
    }
  
    public static testmethod void unittestmethod11(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        caa.Name='Health Care';
        insert caa;
        
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        Datetime yesterday = Datetime.now().addDays(-190);
        Test.setCreatedDate(ProjectList[0].Id, yesterday);
        
        test.starttest();
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.data='test';
        sd.projecttype='Commercial Projects';
        //sd.regionname='Eastern Sales';
        //sd.projecttype='Commercial';
        //sd.ProjectChoice='By Quarter';
        sd.ProjectChoice='By Halfyear';
        sd.applicationname='Health Care';
        
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        test.stopTest();
              
    }
    
    public static testmethod void unittestmethod12(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        caa.Name='Health Care';
        insert caa;
        
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        Datetime yesterday = Datetime.now().addDays(-190);
        Test.setCreatedDate(ProjectList[0].Id, yesterday);
        
        test.starttest();
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.data='test';
        sd.projecttype='Commercial Projects';
        sd.regionname='Eastern Sales';
        sd.projecttype='Commercial';
        sd.ProjectChoice='By Quarter';
        //sd.ProjectChoice='By Halfyear';
        //sd.applicationname='Health Care';
        
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        test.stopTest();
              
    }
    
    public static testmethod void unittestmethod13(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        caa.Name='Health Care';
        insert caa;
        
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        Datetime yesterday = Datetime.now().addDays(-190);
        Test.setCreatedDate(ProjectList[0].Id, yesterday);
        
        test.starttest();
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.data='test';
        //sd.projecttype='Commercial Projects';
        sd.regionname='Eastern Sales';
        //sd.projecttype='Commercial';
        sd.ProjectChoice='By Quarter';
        //sd.ProjectChoice='By Halfyear';
        //sd.applicationname='Health Care';
        
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        test.stopTest();
              
    }

    
    public static testmethod void unittestmethod14(){
        Commercialapplications__c caa=new Commercialapplications__c();
        caa.Name='Automotive';
        caa.Name='Health Care';
        insert caa;
        
        Residentialapplications__c resA=new Residentialapplications__c();
        resA.Name='Common Area';
        insert resA;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<5; i++){
        
             Project__c p1 = new Project__c();         
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Health Care';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList;
        
        Datetime yesterday = Datetime.now().addDays(-190);
        Test.setCreatedDate(ProjectList[0].Id, yesterday);
        
        test.starttest();
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = TestDataUtility.createQuoteRecords(OpportunityList);
        QuoteList[0].order_Finalized_Date__c = System.today();
        QuoteList[0].Order_Number__c = 12345;
        QuoteList[1].order_Finalized_Date__c = System.today()-10;
        QuoteList[2].order_Finalized_Date__c = System.today()-20;
        insert QuoteList[0];
        
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<5; i++){
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
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        
        insert tplist;
        
        successRatioApplicationControllerNew sd = new successRatioApplicationControllerNew();
        sd.data='test';
        sd.projecttype='Commercial Projects';
        //sd.regionname='Eastern Sales';
        sd.projecttype='Commercial';
        sd.ProjectChoice='By Quarter';
        //sd.ProjectChoice='By Halfyear';
        sd.applicationname='Health Care';
        
        sd.getRegionlist();
        sd.ChangeReport();
        
        
        test.stopTest();
              
    }
  
  
  

    

}