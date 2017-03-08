/**********************************************************************
Apex Test Class: Project_SharingTest
Description: This class is used to test the Functionality of Project_Sharing class
Created Date: June 15th , 2015            
***********************************************************************/

@isTest
private with sharing class Project_SharingTest {
   public static list<Project__c> lstTestProjs;
   public static list<Account> lstAccs;
   public static list<Opportunity> lstOpps;
   
   static testMethod void myUnitTest() {
    
        test.startTest();
        
        //Create Test Data
        /*list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;*/
       list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
       /* Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode; */
        lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
       
        Profile testProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
       
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
       
        User testUser1 = TestDataUtility.createUser('admin2' , 'testUser1@testing.com');
        insert testUser1;
       /*
        lstTestProjs = TestDataUtility.createProjectTestData();
       
        Project__c testProj = lstTestProjs[0];
        insert testProj;*/
       list<Project__c> pro =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';

        pro.add(p);
        
    insert pro;
        
        lstAccs= TestDataUtility.createAccountTestData();
        Account testAcc = lstaccs[0];
        insert testAcc;
        
        lstOpps = TestDataUtility.createOppTestData();
        Opportunity testOpp = lstOpps[0];
        testOpp.Project_Name__c = pro[0].id;
        Opportunity testOpp1 = lstOpps[1];
        testOpp1.Project_Name__c = pro[0].id;
        
        insert testOpp;
        insert testOpp1;
      
        OpportunityTeamMember testOTM = new OpportunityTeamMember(TeamMemberRole='Sales Manager' , OpportunityId = testOpp.id , UserId = testUser.id);
        insert testOTM;
        
        delete testOTM;
        
        pro[0].OwnerId = testUser.id;
        update pro;
        
        pro[0].OwnerId = testUser1.id;
        update pro;
        
        test.stopTest();
   
   }
    static testMethod void myUnitTest2() {
    
        
        
        //Create Test Data
       
       /*list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;*/
        
        /*list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode; */
                 list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
        
        Profile testProfile = [SELECT Id FROM Profile WHERE Name='Standard User'];
       
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
       
        User testUser1 = TestDataUtility.createUser('admin2' , 'testUser1@testing.com');
        insert testUser1;
       /*
        lstTestProjs = TestDataUtility.createProjectTestData();
       
        Project__c testProj = lstTestProjs[0];
        insert testProj;*/
        
        list<Project__c> pro =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';

        pro.add(p);
        
    insert pro;
        
        lstAccs= TestDataUtility.createAccountTestData();
        Account testAcc = lstaccs[0];
        insert testAcc;
        
        lstOpps = TestDataUtility.createOppTestData();
        Opportunity testOpp = lstOpps[0];
        testOpp.Project_Name__c = pro[0].id;
        Opportunity testOpp1 = lstOpps[1];
        testOpp1.Project_Name__c = pro[0].id;
        
        insert testOpp;
        insert testOpp1;
      
        OpportunityTeamMember testOTM = new OpportunityTeamMember(TeamMemberRole='Sales Manager' , OpportunityId = testOpp.id , UserId = testUser.id);
        insert testOTM;
        
        delete testOTM;
        
        pro[0].OwnerId = testUser.id;
        update pro;
        
        pro[0].OwnerId = testUser1.id;
        update pro;
                
        set<id> s1= new set<id>{testOpp.id};
        set<id> s2= new set<id>{testUser.id};
            Project_Sharing.delete_Owner_Sharing(s1,s2);
        
   }
   
   
 }