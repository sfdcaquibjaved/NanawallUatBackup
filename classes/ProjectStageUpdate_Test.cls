/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests ProjectStageUpdate class
*
* @ Audit Trial   : Repeating block for each change to the code
**/

@isTest
private class ProjectStageUpdate_Test {
    
    public static List<Project__c> olstTestProject;
    public static list<Opportunity> olstOpportunity ;

    static testMethod void testprojectStageUpdate() {
        
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        list<project__c> olstTestProject2 = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='94941';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Closed Lost - Project Lost';
        p.Reason_Project_Lost__c = 'Competitor';
            
        olstTestProject2.add(p);
        
    insert olstTestProject2[0];
      
        project__c p2= new project__c();
        
        p2.Name='xyzw enterprise';
        p2.Project_Country__c='Canada';
        p2.Project_Zip_Code__c='V0M 9S9';
        p2.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Closed - Inactivity';
        p2.Reason_Project_Lost__c = 'Competitor';   
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3= new project__c();
        p3.Name='xyzw enterprise2';
        p3.Project_Zip_Code__c=' ';
        p3.Project_Country__c='Mexico';
        p3.Project_State__c='Coahuila';
        p3.Close_Date__c=Date.newInstance(2015, 12, 12);
        p3.Stage__c='On Hold';
        p3.Reason_Project_Lost__c = 'Competitor';   
        olstTestProject2.add(p3);
        insert olstTestProject2[2];       
        
    /*  
    olstTestProject = TestDataUtility.createProjectTestData();
    olstTestProject[0].Project_Country__c = 'United States';
    olstTestProject[0].Stage__c = 'Closed Lost - Project Lost';
    olstTestProject[0].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[1].Project_Country__c = 'Canada';
    olstTestProject[1].Stage__c = 'Closed - Inactivity';
    olstTestProject[1].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[1].Project_Zip_Code__c = 'P1H 1Y4';
    olstTestProject[2].Project_Country__c = 'India';
    olstTestProject[2].Stage__c = 'On Hold';
    olstTestProject[2].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[2].Project_Zip_Code__c = null;
    olstTestProject[2].Project_Country__c = 'Mexico';
    olstTestProject[2].Project_State__c = 'Mexico';
    olstTestProject[2].Project_Zip_Code__c = '50000';
    insert olstTestProject ;*/
    
    olstOpportunity = TestDataUtility.createOppTestData();
    olstOpportunity[0].Project_Name__c = olstTestProject2[0].Id ;
    olstOpportunity[1].Project_Name__c = olstTestProject2[0].Id ;
    olstOpportunity[2].Project_Name__c = olstTestProject2[1].Id ;
    olstOpportunity[3].Project_Name__c = olstTestProject2[2].Id ;
    olstOpportunity[4].Project_Name__c = olstTestProject2[0].Id ;
    olstOpportunity[5].Project_Name__c = olstTestProject2[1].Id ;
    insert olstOpportunity ;
    
    list<Id> projIds = new list<Id>();
    
    for (Project__c proj : olstTestProject2){
        projIds.add(proj.Id);
    }
    
    projectStageUpdate.updateRelatedOpps(projIds);
    
        
    }
    static testMethod void testprojectStageUpdate2() {
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        list<project__c> olstTestProject2 = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Closed Lost - Project Lost';
        p.Reason_Project_Lost__c = 'Competitor';
            
        olstTestProject2.add(p);
        
    insert olstTestProject2[0];
      
        project__c p2= new project__c();
        
        p2.Name='xyzw enterprise';
        p2.Project_Country__c='Canada';
        p2.Project_Zip_Code__c='V0M 9S9';
        p2.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Closed - Inactivity';
        p2.Reason_Project_Lost__c = 'Competitor';   
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3= new project__c();
        p3.Name='xyzw enterprise2';
        p3.Project_Zip_Code__c=' ';
        p3.Project_Country__c='Mexico';
        p3.Project_State__c='Coahuila';
        p3.Close_Date__c=Date.newInstance(2015, 12, 12);
        p3.Stage__c='On Hold';
        p3.Reason_Project_Lost__c = 'Competitor';   
        olstTestProject2.add(p3);
        insert olstTestProject2[2];       
        /*
        
    olstTestProject = TestDataUtility.createProjectTestData();
    olstTestProject[0].Project_Country__c = 'United States';
    olstTestProject[0].Stage__c = 'Closed Lost - Project Lost';
    olstTestProject[0].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[1].Project_Country__c = 'Canada';
    olstTestProject[1].Stage__c = 'Closed - Inactivity';
    olstTestProject[1].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[1].Project_Zip_Code__c = 'P1H 1Y4';
    olstTestProject[2].Project_Country__c = 'India';
    olstTestProject[2].Stage__c = 'On Hold';
    olstTestProject[2].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[2].Project_Zip_Code__c = null;
    olstTestProject[2].Project_Country__c = 'Mexico';
    olstTestProject[2].Project_State__c = 'Mexico';
    olstTestProject[2].Project_Zip_Code__c = '50000';
    insert olstTestProject ;*/
    
    olstOpportunity = TestDataUtility.createOppTestData();
    olstOpportunity[0].Project_Name__c = olstTestProject2[0].Id ;
    olstOpportunity[1].Project_Name__c = olstTestProject2[0].Id ;
    olstOpportunity[2].Project_Name__c = olstTestProject2[1].Id ;
    olstOpportunity[3].Project_Name__c = olstTestProject2[2].Id ;
    olstOpportunity[4].Project_Name__c = olstTestProject2[0].Id ;
    olstOpportunity[5].Project_Name__c = olstTestProject2[1].Id ;
    olstOpportunity[0].name='Project';
    olstOpportunity[1].name='Account';
        
    insert olstOpportunity ;
    
    list<Id> projIds = new list<Id>();
   list<Id> opportunityIds = new list<Id>();
    
    for (Project__c proj : olstTestProject2){
        projIds.add(proj.Id);
       }
        for(Opportunity opp:olstOpportunity){
            opportunityIds.add(opp.Id);
        }
    
    projectStageUpdate.updateRelatedOpps(projIds);
    projectStageUpdate.updateOppNames(opportunityIds,'project');
   // projectStageUpdate.updateOppNames(opportunityIds,'Account');
        
    }
    static testMethod void testprojectStageUpdate3() {
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
         list<Account> acc =new list<Account>();
        Account a = new Account();
        a.Name='Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry='United States';
        a.BillingPostalCode='12345';
        a.type='Competitor Firm';
        acc.add(a);
        
    insert acc;
        
        list<project__c> olstTestProject2 = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Closed Lost - Project Lost';
        p.Reason_Project_Lost__c='Competitor';
            
        olstTestProject2.add(p);
        
    insert olstTestProject2[0];
      
        project__c p2= new project__c();
        
        p2.Name='xyzw enterprise';
        p2.Project_Country__c='Canada';
        p2.Project_Zip_Code__c='V0M 9S9';
        p2.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Closed - Inactivity';
        p2.Reason_Project_Lost__c='Competitor';
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3= new project__c();
        p3.Name='xyzw enterprise2';
        p3.Project_Zip_Code__c=' ';
        p3.Project_Country__c='Mexico';
        p3.Project_State__c='Coahuila';
        p3.Close_Date__c=Date.newInstance(2015, 12, 12);
        p3.Stage__c='On Hold';
        p3.Reason_Project_Lost__c='Competitor'; 
        olstTestProject2.add(p3);
        insert olstTestProject2[2];       
        
        /*
    olstTestProject = TestDataUtility.createProjectTestData();
    olstTestProject[0].Project_Country__c = 'United States';
    olstTestProject[0].Stage__c = 'Closed Lost - Project Lost';
    olstTestProject[0].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[1].Project_Country__c = 'Canada';
    olstTestProject[1].Stage__c = 'Closed - Inactivity';
    olstTestProject[1].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[1].Project_Zip_Code__c = 'P1H 1Y4';
    olstTestProject[2].Project_Country__c = 'India';
    olstTestProject[2].Stage__c = 'On Hold';
    olstTestProject[2].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[2].Project_Zip_Code__c = null;
    olstTestProject[2].Project_Country__c = 'Mexico';
    olstTestProject[2].Project_State__c = 'Mexico';
    olstTestProject[2].Project_Zip_Code__c = '50000';
    insert olstTestProject ;*/
    
    olstOpportunity = TestDataUtility.createOppTestData();
    olstOpportunity[0].Project_Name__c = olstTestProject2[0].Id ;
    olstOpportunity[0].AccountId=acc[0].id;
    olstOpportunity[1].Project_Name__c = olstTestProject2[0].Id ;
        olstOpportunity[1].AccountId=acc[0].id;
    olstOpportunity[2].Project_Name__c = olstTestProject2[1].Id ;
    olstOpportunity[3].Project_Name__c = olstTestProject2[2].Id ;
    olstOpportunity[4].Project_Name__c = olstTestProject2[0].Id ;
    olstOpportunity[5].Project_Name__c = olstTestProject2[1].Id ;
    olstOpportunity[0].name='Project';
    olstOpportunity[1].name='Account';
     olstOpportunity[0].StageName = 'Influencer Closed/Lost';
        olstOpportunity[0].Reason_Opportunity_Lost__c ='Project Cancelled';
        
        
    insert olstOpportunity ;
    
    list<Id> projIds = new list<Id>();
   list<Id> opportunityIds = new list<Id>();
    
    for (Project__c proj : olstTestProject2){
        projIds.add(proj.Id);
       }
        for(Opportunity opp:olstOpportunity){
            opportunityIds.add(opp.Id);
        }
    
    projectStageUpdate.updateRelatedOpps(projIds);
    projectStageUpdate.updateOppNames(projIds,'project');
    projectStageUpdate.updateOppNames(projIds,'Account');
        
    }
   
  static testMethod void testprojectStageUpdate4() {
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
         list<Account> acc =new list<Account>();
        Account a = new Account();
        a.Name='Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry='United States';
        a.BillingPostalCode='12345';
        a.type='Competitor Firm';
        acc.add(a);
        
    insert acc;
        
        list<project__c> olstTestProject2 = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Closed Lost - Project Lost';
        p.Reason_Project_Lost__c='Competitor';
            
        olstTestProject2.add(p);
        
        insert olstTestProject2[0];
      
        project__c p2= new project__c();
        
        p2.Name='xyzw enterprise';
        p2.Project_Country__c='Canada';
        p2.Project_Zip_Code__c='V0M 9S9';
        p2.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Closed - Inactivity';
        p2.Reason_Project_Lost__c='Competitor';
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3= new project__c();
        p3.Name='xyzw enterprise2';
        p3.Project_Zip_Code__c=' ';
        p3.Project_Country__c='Mexico';
        p3.Project_State__c='Coahuila';
        p3.Close_Date__c=Date.newInstance(2015, 12, 12);
        p3.Stage__c='On Hold';
        p3.Reason_Project_Lost__c='Competitor'; 
        olstTestProject2.add(p3);
        insert olstTestProject2[2];       
        
        /*
    olstTestProject = TestDataUtility.createProjectTestData();
    olstTestProject[0].Project_Country__c = 'United States';
    olstTestProject[0].Stage__c = 'Closed Lost - Project Lost';
    olstTestProject[0].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[1].Project_Country__c = 'Canada';
    olstTestProject[1].Stage__c = 'Closed - Inactivity';
    olstTestProject[1].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[1].Project_Zip_Code__c = 'P1H 1Y4';
    olstTestProject[2].Project_Country__c = 'India';
    olstTestProject[2].Stage__c = 'On Hold';
    olstTestProject[2].Reason_Project_Lost__c = 'Competitor';
    olstTestProject[2].Project_Zip_Code__c = null;
    olstTestProject[2].Project_Country__c = 'Mexico';
    olstTestProject[2].Project_State__c = 'Mexico';
    olstTestProject[2].Project_Zip_Code__c = '50000';
    insert olstTestProject ;*/
    
    Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
Id rtId = OpportunityRecordTypeInfo.get('Influencer Opportunity').getRecordTypeId();

    olstOpportunity = TestDataUtility.createOppTestData();
    olstOpportunity[0].Project_Name__c = olstTestProject2[0].Id ;
      olstOpportunity[0].AccountId=acc[0].id;
      olstOpportunity[0].recordtypeId = rtId ; 
    olstOpportunity[1].Project_Name__c = olstTestProject2[0].Id ;
        olstOpportunity[1].AccountId=acc[0].id;
       olstOpportunity[1].recordtypeId = rtId ; 
    olstOpportunity[2].Project_Name__c = olstTestProject2[1].Id ;
       olstOpportunity[2].recordtypeId = rtId ; 
    olstOpportunity[3].Project_Name__c = olstTestProject2[2].Id ;
       olstOpportunity[3].recordtypeId = rtId ; 
    olstOpportunity[4].Project_Name__c = olstTestProject2[0].Id ;
       olstOpportunity[4].recordtypeId = rtId ; 
    olstOpportunity[5].Project_Name__c = olstTestProject2[1].Id ;
       olstOpportunity[5].recordtypeId = rtId ; 
    olstOpportunity[0].name='Project';
    olstOpportunity[1].name='Account';
     olstOpportunity[0].StageName = 'Influencer Closed/Lost';
        olstOpportunity[0].Reason_Opportunity_Lost__c ='Project Cancelled';
        
        
    insert olstOpportunity ;
    
    list<Id> projIds = new list<Id>();
   list<Id> opportunityIds = new list<Id>();
    
    for (Project__c proj : olstTestProject2){
        projIds.add(proj.Id);
       }
        for(Opportunity opp:olstOpportunity){
            opportunityIds.add(opp.Id);
        }
    
    projectStageUpdate.updateRelatedOpps(projIds);
    projectStageUpdate.updateOppNames(projIds,'project');
    projectStageUpdate.updateOppNames(projIds,'Account');
        
    }
}