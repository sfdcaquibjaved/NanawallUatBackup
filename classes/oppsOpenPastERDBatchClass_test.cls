/*************************************************************************
    @ Author        : Durga
    @ Date          : Mar 2016
    @ Test File     : 
    @ Description   : Teat Class for oppsOpenPastERD Batch Class 
    
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
***********************************************************************************/
@isTest
public class oppsOpenPastERDBatchClass_test 
{
static testmethod void unitest1(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
       
        User testUser1 = TestDataUtility.createUser('admin2' , 'testUser1@testing.com');
        insert testUser1;
list<project__c> pro = new list<project__c>();
for(integer i=0; i<=10; i++)
{
project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test'+i;
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             p1.Stage__c='Quote - Provided';
             
             pro.add(p1);
             }
             insert pro;
      
    list<Account> acc = new list<account>();
    acc= TestDataUtility.createAccountTestData();
     acc[0].Type='Architecture Firm';
    acc[0].OwnerId=testUser.id;
    acc[1].OwnerId=testUser1.id;
     acc[1].Type='other';
    insert acc;
    
    list<opportunity> opp = new list<opportunity>();
    opp=TestDataUtility.createOppTestData();
    opp[0].Project_Name__c=pro[0].id;
    opp[0].accountid=acc[0].id;
    opp[0].ownerId=testUser.id;
    opp[1].Project_Name__c=pro[1].id;
    opp[1].accountid=acc[1].id;
    opp[1].StageName = 'Need Analysis';
    opp[1].CloseDate = system.today()-1;
    
    insert opp;
    
    OpportunityTeamMember team =new OpportunityTeamMember();
        team.OpportunityId =opp[0].Id ;
        team.TeamMemberRole='Sales Rep';
        team.UserId=opp[0].ownerId;
        insert team;


test.starttest();
oppsOpenPastERD ocp= new oppsOpenPastERD();
ID batchProjectCountid = database.executebatch(ocp);
test.stoptest();
}
    
    static testmethod void unitest2(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
       
        User testUser1 = TestDataUtility.createUser('admin2' , 'testUser1@testing.com');
        insert testUser1;
list<project__c> pro = new list<project__c>();
for(integer i=0; i<=10; i++)
{
project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test'+i;
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             p1.Stage__c='Quote - Provided';
             
             pro.add(p1);
             }
             insert pro;
      
    /*list<Account> acc = new list<account>();
    acc= TestDataUtility.createAccountTestData();
     acc[0].Type='Architecture Firm';
    acc[0].OwnerId=testUser.id;
    acc[1].OwnerId=testUser1.id;
     acc[1].Type='other';
    insert acc;*/
    
    list<opportunity> opp = new list<opportunity>();
    opp=TestDataUtility.createOppTestData();
    opp[0].Project_Name__c=pro[0].id;
    //opp[0].accountid=acc[0].id;
    opp[0].ownerId=testUser.id;
    opp[1].Project_Name__c=pro[1].id;
   // opp[1].accountid=acc[1].id;
    opp[1].StageName = 'Need Analysis';
    opp[1].CloseDate = system.today()-1;
        insert opp;
        
        
    
    OpportunityTeamMember team =new OpportunityTeamMember();
        team.OpportunityId =opp[0].Id ;
        team.TeamMemberRole='Sales Rep';
        team.UserId=opp[0].ownerId;
        insert team;


test.starttest();
oppsOpenPastERD ocp= new oppsOpenPastERD();
ID batchProjectCountid = database.executebatch(ocp);
test.stoptest();
}
}