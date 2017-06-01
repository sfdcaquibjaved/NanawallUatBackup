@isTest
public class KPIDashboardController_Test {
   public static testmethod void unittestmethod(){
   
       User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
      
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;
       
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<2; i++){
        
             Project__c p1 = new Project__c();
           
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
            p1.stage__c='Prospecting';
             ProjectList.add(p1);
        }
        ProjectList[0].amount__c = 12456;
        ProjectList[0].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
         insert ProjectList[0];
        set<id>prid = new set<id>();
       prid.add(ProjectList[0].id);
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
       // OpportunityList[0].StageName = 'Closed/Won';
        // OpportunityList[0].Site_Visit_Paid__c =TRUE;
        //test.startTest();
        insert OpportunityList[0];
        
        
       /* list<Quote__c> QuoteList = new list<Quote__c>();
        quote__c q = new quote__c();
        q.order_Finalized_Date__c = System.today();
        q.Order_Number__c = 12345;
        q.Name = 'TestQuote4';
        //q.Contact__c = con.id;
        q.Opportunity__c = OpportunityList[0].Id;
        q.order_Finalized_Date__c = System.today()-10;
        q.order_Finalized_Date__c = System.today()-20;
        QuoteList.add(q);
        insert QuoteList;*/
        
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
         For(integer i=0; i<3; i++){
         Project_Split__c newSplits = new Project_Split__c();
         newSplits.Project__c = ProjectList[0].Id ;
         newSplits.Split__c = 2.0 ;
         newSplits.Account__c =olstAccount[0].id;
         newSplits.Project_Rep__c = Userinfo.getUserId();
         newSplit.add(newSplits);
         }
       insert newSplit ;
       
       list<Total_Order_Report_Data_Point__c> tplist = new list<Total_Order_Report_Data_Point__c>();
       for(integer i=0; i<3; i++)
       {
           Total_Order_Report_Data_Point__c tp = new Total_Order_Report_Data_Point__c();
           tp.name = 'Test';
           tp.Project__c = ProjectList[0].Id;
           tp.Project_Split__c = newSplit[0].id;
           tp.Nana_Quote__c =  QuoteList[0].id;
           tplist.add(tp);
       }
        
        TerritoryNames__c tn=new TerritoryNames__c();
        tn.Name='Eastern Sales';
       // tn.Regional_Manager__c=
        insert tn;
        
        EasternSalesReps__c es = new EasternSalesReps__c();
        es.name = 'Bill Leon';
        insert es;
        
        MidWestSalesReps__c ms = new MidWestSalesReps__c();
        ms.name = 'Andy Cook';
        insert ms;
        
        MidEasternSalesReps__c mes = new MidEasternSalesReps__c();
        mes.name = 'Paul Nalette';
        insert mes;
        WesternSalesReps__c ws = new WesternSalesReps__c();
        ws.name = 'Rob Laris';
        insert ws;
        insert tplist;
        
        KPIFullAccess__c kpf=new KPIFullAccess__c();
        kpf.name ='George Wiedenhofer';
        insert kpf;
        
        Test.startTest(); 
       // SuccessRatioDynamicHelperClass.projectFetchingForTrends(ws,prid);
        KPIDashboardController kpi=new KPIDashboardController();
        kpi.usedCheck=FALSE;
        kpi.successCheck=FALSE;
        kpi.salesrepCheck=TRUE;
        kpi.regioncheck=TRUE;
        kpi.metriccheck=FALSE;
        kpi.metriccheckdown=FALSE;
        kpi.metricVolumeCheck=FALSE;
        kpi.metricVolumeCheckdown=FALSE;
        kpi.metriccheckEqual=FALSE;
        kpi.metricVolumeCheckEqual=FALSE;
        kpi.metricregioncheck=FALSE;
        kpi.metricregioncheckdown=FALSE;
        kpi.metricregionVolumeCheck=FALSE;
        kpi.metricregionVolumeCheckdown=FALSE;
        kpi.metricregioncheckEqual=FALSE;
        kpi.metricregionVolumeCheckEqual=FALSE;
        kpi.metricyearcheck=FALSE;
        kpi.metricyearcheckdown=FALSE;
        kpi.metricyearcheckequal=FALSE;
        kpi.metricvolumeyearcheck=FALSE;
        kpi.metricvolumeyearcheckdown=FALSE;
        kpi.metricvolumeyearcheckequal=FALSE;
        
        kpi.regionname='Eastern Sales';
        kpi.salesrepname='Bill Leon';
        
        kpi.ChangeReport();
        kpi.getRegionlist();
       // kpi.redirectHome();
        kpi.regionname='Mid Eastern Sales';
        kpi.salesrepname='Paul Nalette';
        
        kpi.ChangeReport();
        kpi.getRegionlist();
        // kpi.redirectHome();
        kpi.regionname='Midwest Sales';
        kpi.salesrepname='Andy cook';
        
        kpi.ChangeReport();
        kpi.getRegionlist();
        /// kpi.redirectHome();
        kpi.regionname='Western Sales';
        kpi.salesrepname='Brad Burden';
        
        kpi.ChangeReport();
        kpi.getRegionlist();
       //  kpi.redirectHome();
         kpi.regionname='--None--';
        kpi.ChangeReport();
        kpi.getRegionlist();
        kpi.regionname='Eastern Sales';
        kpi.salesrepname='Andy cook';
        kpi.regioncheck=TRUE;
        kpi.salesrepcheck=TRUE;
        kpi.ChangeReport();
        kpi.getRegionlist();
        // kpi.redirectHome();
       
        
      Test.stopTest();  
    }
    
    
    public static testmethod void unittestmethod1(){
    
     profile p = [select id from Profile where name = 'Standard User'];
        User u = new User ( alias = 'Bill', email = 'testme@noemail.com', emailencodingkey = 'UTF-8', lastname = 'Bill Leon',languagelocalekey = 'en_US', 
         localesidkey = 'en_US', profileid = p.Id, country = 'United Kingdom', timezonesidkey = 'Europe/London', username = 'testme@noemail.com');
         insert u;
        
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
       
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<3; i++){
        
             Project__c p1 = new Project__c();
           
             p1.Name = 'ProjectNew' + i;
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
            p1.stage__c='Prospecting';
             ProjectList.add(p1);
        }
        ProjectList[1].amount__c = 12456;
        ProjectList[1].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList[0];
        
        list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
       // OpportunityList[0].StageName = 'Closed/Won';
        // OpportunityList[0].Site_Visit_Paid__c =TRUE;
       //test.startTest(); 
        insert OpportunityList[0];
        
        list<Quote__c> QuoteList = new list<Quote__c>();
        quote__c q = new quote__c();
        q.order_Finalized_Date__c = System.today();
        q.Order_Number__c = 12345;
        q.Name = 'TestQuote4';
        //q.Contact__c = con.id;
        q.Opportunity__c = OpportunityList[0].Id;
        q.order_Finalized_Date__c = System.today()-10;
        q.order_Finalized_Date__c = System.today()-20;
        QuoteList.add(q);
        insert QuoteList;
        
        
       
        list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
        QuoteDetailList[0].Price__c=5678;
        QuoteDetailList[0].Quote__C=QuoteList[0].id;
        QuoteDetailList[1].Price__c=1235;
        QuoteDetailList[2].Price__c=56708;
        insert QuoteDetailList[0];
        
         list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(integer i=0; i<3; i++){
         Project_Split__c newSplits = new Project_Split__c();
         newSplits.Project__c = ProjectList[0].Id ;
         newSplits.Split__c = 2.0 ;
         newSplits.Account__c =olstAccount[0].id;
         newSplits.Project_Rep__c = Userinfo.getUserId();
         newSplit.add(newSplits);
         }
       insert newSplit ;
       
       list<Total_Order_Report_Data_Point__c> tplist = new list<Total_Order_Report_Data_Point__c>();
       for(integer i=0; i<3; i++)
       {
           Total_Order_Report_Data_Point__c tp = new Total_Order_Report_Data_Point__c();
           tp.name = 'Test';
           tp.Project__c = ProjectList[0].Id;
           tp.Project_Split__c = newSplit[0].id;
           tp.Nana_Quote__c =  QuoteList[0].id;
           tplist.add(tp);
       }
        
        TerritoryNames__c tn=new TerritoryNames__c();
        tn.Name='Mid Eastern Sales';
        tn.Regional_Manager__c = 'Bill Leon';
        insert tn;
        
        MidEasternSalesReps__c mes = new MidEasternSalesReps__c();
        mes.name = 'Paul Nalette';
        insert mes;
        WesternSalesReps__c ws = new WesternSalesReps__c();
        ws.name = 'Rob Laris';
        insert ws;
        MidWestSalesReps__c ms = new MidWestSalesReps__c();
        ms.name = 'Andy Cook';
        insert ms;
        
        insert tplist;
        
       test.startTest(); 
        
        KPIDashboardController kpi=new KPIDashboardController();
            kpi.regionname='Mid Eastern Sales';
        kpi.salesrepname='Paul Nalette';
        //Test.startTest();
        kpi.ChangeReport();
        kpi.getRegionlist();
        kpi.regionname='Eastern Sales';
        kpi.salesrepname='Andy cook';
        kpi.ChangeReport();
        kpi.getRegionlist();
        kpi.regionname='Midwest Sales';
        kpi.ChangeReport();
        kpi.getRegionlist();
        kpi.regionname='Western Sales';
        kpi.ChangeReport();
        kpi.getRegionlist();
        kpi.regionname='--None--';
        kpi.ChangeReport();
        kpi.getRegionlist();
        kpi.regionname='Eastern Sales';
        kpi.salesrepname='Andy cook';
        kpi.regioncheck=TRUE;
        kpi.salesrepcheck=TRUE;
        kpi.ChangeReport();
        kpi.getRegionlist();
      Test.stopTest();  
    }
    
    
    public static testmethod void unittestmethod2(){
        
       // profile p = [select id from Profile where name = 'Standard User'];
        //User u = [select id, name from user where name='Ray Van Nes' LIMIT 1];
        //System.debug('userrrrr'+u);
        /*user u = TestDataUtility.createUser('admin1', 'testuser@test.com');
        insert u;
        u.firstname='test';
        u.lastname='testlast';
        update u;*/
        list<Zip_Codes_Master__c> territorymaster=TestDataUtility.getTerritoryMaster();
      //  territorymaster[0].user__c=u.id;
        insert territorymaster;
        
        //insert test Account records
        list<Account> olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        
        List<Project__c> ProjectList = new list<Project__c>();
        For(integer i=0; i<10; i++){
        
             Project__c p1 = new Project__c();
           
             p1.Name = 'ProjectNew' + i;
            // p1.OwnerId=u.id;
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.stage__c='Quoted';
             ProjectList.add(p1);
        }
        ProjectList[0].amount__c = 12456;
        
        ProjectList[0].RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        insert ProjectList[0];
       /* ProjectList[0].Ownerid=u.id;
        update ProjectList[0];
        Project__c pr = [select id, owner.name, ownerId from Project__c where id=:ProjectList[0].id];
     //   system.assert(pr.ownerId == u.id);
        System.debug('ownerss'+pr.ownerId+' '+u.id+' '+pr.owner.name+' '+u.name);*/
    
       list<Opportunity> OpportunityList = TestDataUtility.createOppTestData();
        OpportunityList[0].AccountId = olstAccount[0].Id ;
        OpportunityList[0].Project_Name__c = ProjectList[0].Id;
        OpportunityList[0].StageName = 'Closed/Won';
         OpportunityList[0].Site_Visit_Paid__c =TRUE;
        
        insert OpportunityList[0];
        //OpportunityList[0].ownerId = u.id;
        OpportunityList[0].Name = 'Opplast';
        OpportunityList[0].Budget_Quote__c =FALSE;
        update OpportunityList[0];
        test.startTest();
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
         For(integer i=0; i<2; i++){
         Project_Split__c newSplits = new Project_Split__c();
         newSplits.Project__c = ProjectList[0].Id ;
         newSplits.Split__c = 2.0 ;
         newSplits.Account__c =olstAccount[0].id;
         newSplits.Project_Rep__c =  Userinfo.getUserId();
         newSplit.add(newSplits);
         }
       insert newSplit ;
       
       list<Total_Order_Report_Data_Point__c> tplist = new list<Total_Order_Report_Data_Point__c>();
       for(integer i=0; i<2; i++)
       {
           Total_Order_Report_Data_Point__c tp = new Total_Order_Report_Data_Point__c();
           tp.name = 'Test';
           tp.Project__c = ProjectList[0].Id;
           tp.Project_Split__c = newSplit[0].id;
           tp.Nana_Quote__c =  QuoteList[0].id;
          // tp.OwnerId=u.id;
           tplist.add(tp);
       }
        
        TerritoryNames__c tn=new TerritoryNames__c();
        tn.Name='Midwest Sales';
        insert tn;
        
        MidEasternSalesReps__c mes = new MidEasternSalesReps__c();
        mes.name = 'Paul Nalette';
        insert mes;
        WesternSalesReps__c ws = new WesternSalesReps__c();
        ws.name = 'Rob Laris';
        insert ws;
        MidWestSalesReps__c ms = new MidWestSalesReps__c();
        ms.name = 'Ray Van Nes';
        insert ms;
        insert tplist;
         
        KPIFullAccess__c kpf=new KPIFullAccess__c();
        kpf.name ='George Wiedenhofer';
        insert kpf;
        
        ProjectStagesFunnelChart__c pfs = new ProjectStagesFunnelChart__c();
        pfs.name = 'Quoted';
        insert pfs;
        
        
        KPIDashboardController kpi=new KPIDashboardController();
       
        kpi.regionname='Midwest Sales';
        kpi.salesrepname='Ray Van Nes';
        kpi.ChangeReport();
        

    test.stoptest();        
                       
    }
    
}