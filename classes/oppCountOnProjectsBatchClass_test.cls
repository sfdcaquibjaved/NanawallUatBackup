@isTest
public class oppCountOnProjectsBatchClass_test 
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
    
    insert opp;
    OpportunityTeamMember team =new OpportunityTeamMember();
        team.OpportunityId =opp[0].Id ;
        team.TeamMemberRole='Sales Rep';
        team.UserId=opp[0].ownerId;
        insert team;


test.starttest();
oppCountOnProjectsBatchClass ocp= new oppCountOnProjectsBatchClass();
ID batchProjectCountid = database.executebatch(ocp);
test.stoptest();
}
static testmethod void unitest2(){
        
        
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
       
        User testUser1 = TestDataUtility.createUser('admin2' , 'testUser1@testing.com');
        insert testUser1;
    list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
         Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        
        Zipcode1.User__c= testuser.id;
        z.add(zipCode1);
    insert z;
    
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
             p1.RecordTypeId= Schema.SObjectType.project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
             pro.add(p1);
             }
             insert pro;
      
    list<Account> acc = new list<account>();
    account a= new account();
         a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.Type='Architecture Firm';
        a.OwnerId=testUser.id;
        acc.add(a);
     account a2= new account();
         a2.Name = 'Test Account2';
        a2.Phone = '(123) 456-7890';
        a2.BillingState = 'New York';
        a2.BillingCountryCode='US';
        a2.BillingPostalCode='12345';
        a2.Type='Architecture Firm';
        a2.OwnerId=testUser1.id;
        acc.add(a2);
    insert acc;
    
    list<opportunity> opp = new list<opportunity>();
    opp=TestDataUtility.createOppTestData();
    opp[0].Project_Name__c=pro[0].id;
    opp[0].accountid=acc[0].id;
    opp[0].ownerId=testUser.id;
    opp[0].RecordTypeId=Label.Influencer_Opportunity_RecordTypeId;
    opp[1].Project_Name__c=pro[0].id;
    opp[1].accountid=acc[1].id;
    opp[1].ownerId=testUser.id;
    opp[1].RecordTypeId=Label.Influencer_Opportunity_RecordTypeId;
    insert opp;
    OpportunityTeamMember team =new OpportunityTeamMember();
        team.OpportunityId =opp[0].Id ;
        team.TeamMemberRole='Sales Rep';
        team.UserId=opp[0].ownerId;
        insert team;


test.starttest();
oppCountOnProjectsBatchClass ocp= new oppCountOnProjectsBatchClass();
ID batchProjectCountid = database.executebatch(ocp);
test.stoptest();
}
static testmethod void unitest3(){
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
     acc[0].Type='Other';
    acc[0].OwnerId=testUser.id;
    acc[1].OwnerId=testUser1.id;
     acc[1].Type='Other';
    insert acc;
    
    list<opportunity> opp = new list<opportunity>();
    opp=TestDataUtility.createOppTestData();
    opp[0].Project_Name__c=pro[0].id;
    opp[0].accountid=acc[0].id;
    opp[0].ownerId=testUser.id;
    opp[1].Project_Name__c=pro[0].id;
    opp[1].accountid=acc[1].id;
    
    insert opp;
    OpportunityTeamMember team =new OpportunityTeamMember();
        team.OpportunityId =opp[0].Id ;
        team.TeamMemberRole='Sales Rep';
        team.UserId=opp[0].ownerId;
        insert team;


test.starttest();
oppCountOnProjectsBatchClass ocp= new oppCountOnProjectsBatchClass();
ID batchProjectCountid = database.executebatch(ocp);
test.stoptest();
}
}