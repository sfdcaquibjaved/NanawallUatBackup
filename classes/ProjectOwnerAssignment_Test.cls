/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests ProjectOwnerAssignment class
*
* @ Audit Trial   : Repeating block for each change to the code
**/

@isTest
private class ProjectOwnerAssignment_Test {
    
     public static List<Project__c> olstTestProject;
     public static List<Country_codes__c> olstTestCountryCode;
     public static List<state_codes__c> olstTestStateCode;
     public static List<Zip_Codes_Master__c> olstTerritoryMastereCode;
    
    static testMethod void testProjectOwnerAssignment1() {
         
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    
    olstTestProject = TestDataUtility.createProjectTestData();
    olstTestProject[0].Project_Country__c = 'United States';
    /*olstTestProject[1].Project_Country__c = 'Canada';
    olstTestProject[1].Project_Zip_Code__c = 'P1H 1Y4';
    olstTestProject[2].Project_Country__c = 'India';
    olstTestProject[2].Project_Zip_Code__c = null;
    olstTestProject[2].Project_Country__c = 'Mexico';
    olstTestProject[2].Project_State__c = 'Mexico';
    olstTestProject[2].Project_Zip_Code__c = '50000';
    
    olstTestProject[2].Project_Country__c = 'India';
    olstTestProject[2].Project_Zip_Code__c = null;  */
    insert olstTestProject[0];
    //projectOwnerAssignment.assignOwner(olstTestProject);
    projectOwnerAssignment.updateResolutionDate(olstTestProject);
    projectOwnerAssignment.validateZip(olstTestProject[0]);
    projectOwnerAssignment.updateOppTeam(olstTestProject);
    }
    static testMethod void testProjectOwnerAssignment2() {
         
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    
    list<project__c> olstTestProject2 = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';
            
        olstTestProject2.add(p);
        try{
    insert olstTestProject2[0];
        }catch(DMLEXCEPTION e){}
        project__c p2= new project__c();
        p2.Name='xyzw enterprise';
        
        p2.Project_Country__c='Canada';
        p2.Project_Zip_Code__c='V0M 9S9';
        p2.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Prospecting';
            
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3= new project__c();
        p3.Name='xyzw enterprise2';
        p3.Project_Zip_Code__c=' ';
        p3.Project_Country__c='Mexico';
        p3.Project_State__c='Coahuila';
        p3.Close_Date__c=Date.newInstance(2015, 12, 12);
        p3.Stage__c='Prospecting';
            
        olstTestProject2.add(p3);
        insert olstTestProject2[2];        
        
    //projectOwnerAssignment.assignOwner(olstTestProject);
    projectOwnerAssignment.updateResolutionDate(olstTestProject2);
    projectOwnerAssignment.validateZip(olstTestProject2[0]);
    projectOwnerAssignment.updateOppTeam(olstTestProject2);
    }
    
    static testMethod void testProjectOwnerAssignment3() {
         
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    
    list<project__c> olstTestProject2 = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';
            
        olstTestProject2.add(p);
        try{ 
    insert olstTestProject2[0];
        }catch(DMLEXCEPTION e){}
        project__c p2= new project__c();
        p2.Name='xyzw enterprise';
        
        p2.Project_Country__c='Canada';
        p2.Project_Zip_Code__c='V0M 9S9';
        p2.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Prospecting';
            
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3= new project__c();
        p3.Name='xyzw enterprise2';
        p3.Project_Zip_Code__c=' ';
        p3.Project_Country__c='India';
        p3.Project_State__c='Delhi';
        p3.Close_Date__c=Date.newInstance(2015, 12, 12);
        p3.Stage__c='Prospecting';
            
        olstTestProject2.add(p3);
        insert olstTestProject2[2];   
        
        list<opportunity> opp= new list<opportunity>();
        opp=TestDataUtility.createOppTestData();
        opp[0].Project_Name__c=olstTestProject2[1].id;
        insert opp;
        
    //projectOwnerAssignment.assignOwner(olstTestProject);
    projectOwnerAssignment.updateResolutionDate(olstTestProject2);
    projectOwnerAssignment.validateZip(olstTestProject2[0]);
    projectOwnerAssignment.updateOppTeam(olstTestProject2);
    }
    
     static testMethod void testProjectOwnerAssignment4() {
  
        
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
         list<Account> acc =new list<Account>();
        Account a = new Account();
        a.Name='Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry='United States';
        a.BillingPostalCode='12345';
        a.type='Competitor Firm';
        acc.add(a);
        
    insert acc;
         
         list<contact> con= new list<contact>();
        Contact c = new Contact();
        c.Accountid=acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city'; 
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        con.add(c);
          
         insert con;
         
         User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
         
          User testUser1 = TestDataUtility.createUser('Gold Partner User' , 'testUser2@testing.com');
         testUser1.ContactId=con[0].id;
        insert testUser1;
    
    list<project__c> olstTestProject2 = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';
            
        olstTestProject2.add(p);
        try{ 
    insert olstTestProject2[0];
        }catch(DMLEXCEPTION e){}
        project__c p2= new project__c();
        p2.Name='xyzw enterprise';
        
        p2.Project_Country__c='Canada';
        p2.Project_Zip_Code__c='V0M 9S9';
        p2.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Prospecting';
            
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3= new project__c();
        p3.Name='xyzw enterprise2';
        p3.Project_Zip_Code__c=' ';
        p3.Project_Country__c='India';
        p3.Project_State__c='Delhi';
        p3.Close_Date__c=Date.newInstance(2015, 12, 12);
        p3.Stage__c='Prospecting';
            
        olstTestProject2.add(p3);
        insert olstTestProject2[2];   
        
        list<opportunity> opp= new list<opportunity>();
        opp=TestDataUtility.createOppTestData();
        opp[0].Project_Name__c=olstTestProject2[1].id;
        insert opp;
        
    //projectOwnerAssignment.assignOwner(olstTestProject);
         System.runAs(testuser1){
    projectOwnerAssignment.updateResolutionDate(olstTestProject2);
    projectOwnerAssignment.validateZip(olstTestProject2[0]);
    projectOwnerAssignment.updateOppTeam(olstTestProject2);
         }
    }
static testMethod void testProjectOwnerAssignment5() {
  
        
    /*olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;*/
    
     list<Country_codes__c> lstCountryCodes = new list<Country_codes__c>();
     
     Country_codes__c couCode1 = new Country_codes__c();
     couCode1.Name = 'US';
     couCode1.Country__c = 'United States';
     lstCountryCodes.add(couCode1);
     
     Country_codes__c couCode2 = new Country_codes__c();
     couCode2.Name = 'CA';
     couCode2.Country__c = 'Canada';
     lstCountryCodes.add(couCode2);
      
     Country_codes__c couCode3 = new Country_codes__c();
     couCode3.Name = 'MX';
     couCode3.Country__c = 'Mexico';
     lstCountryCodes.add(couCode3);
     
     Country_codes__c couCode4 = new Country_codes__c();
     couCode4.Name = 'IN';
     couCode4.Country__c = 'India';
     lstCountryCodes.add(couCode4);
    
    insert lstCountryCodes;
    
    /*olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; */
    
     list<state_codes__c> lstStateCodes = new list<state_codes__c>();
     
     state_codes__c statCode1 = new state_codes__c();
     statCode1.Name = 'CO';
     statCode1.States__c = 'Coahuila';
     lstStateCodes.add(statCode1);
         
     state_codes__c statcode2 = new state_codes__c();
     statCode2.Name = 'CA';
     statCode2.States__c = 'California';
     lstStateCodes.add(statcode2);
    
    insert lstStateCodes;
    
    
   /* olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;*/
    
     list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode; 
    
    
         list<Account> acc =new list<Account>();
        Account a = new Account();
        a.Name='Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry='United States';
        a.BillingPostalCode='12345';
        a.type='Competitor Firm';
        acc.add(a);
        
    insert acc;
         
         list<contact> con= new list<contact>();
        Contact c = new Contact();
        c.Accountid=acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city'; 
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        con.add(c);
          
         insert con;
         
         User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
         
          User testUser1 = TestDataUtility.createUser('Gold Partner User' , 'testUser2@testing.com');
         testUser1.ContactId=con[0].id;
        insert testUser1;
    
    list<project__c> olstTestProject2 = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';
            
        olstTestProject2.add(p);
        try{ 
    insert olstTestProject2[0];
        }catch(DMLEXCEPTION e){}
        project__c p2= new project__c();
        p2.Name='xyzw enterprise';
        
        p2.Project_Country__c='Canada';
        p2.Project_Zip_Code__c='V0M 9S9';
        p2.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Prospecting';
            
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3= new project__c();
        p3.Name='xyzw enterprise2';
        p3.Project_Zip_Code__c=' ';
        p3.Project_Country__c='India';
        p3.Project_State__c='Delhi';
        p3.Close_Date__c=Date.newInstance(2015, 12, 12);
        p3.Stage__c='Prospecting';
            
        olstTestProject2.add(p3);
        insert olstTestProject2[2];  
    
       project__c p4= new project__c();
        p4.Name='xyzw enterprise2';
        p4.Project_Zip_Code__c='45678';
        p4.Project_Country__c='United States';
        p4.Project_State__c='Delhi';
        p4.Close_Date__c=Date.newInstance(2015, 12, 12);
        p4.Stage__c='Prospecting';
            
        olstTestProject2.add(p4);
    try{ 
       insert olstTestProject2[3];
    }catch(Exception e){}
        project__c p5= new project__c();
        p5.Name='xyzw enterprise2';
        p5.Project_Zip_Code__c='';
        p5.Project_Country__c='United States';
        p5.Project_State__c='Delhi';
        p5.Close_Date__c=Date.newInstance(2015, 12, 12);
        p5.Stage__c='Prospecting';
            
        olstTestProject2.add(p5);
    try{ 
       insert olstTestProject2[4];
    }catch(Exception e){}
        
        list<opportunity> opp= new list<opportunity>();
        opp=TestDataUtility.createOppTestData();
        opp[0].Project_Name__c=olstTestProject2[1].id;
        insert opp;
        
    //projectOwnerAssignment.assignOwner(olstTestProject);
         System.runAs(testuser1){
    projectOwnerAssignment.updateResolutionDate(olstTestProject2);
    projectOwnerAssignment.validateZip(olstTestProject2[0]);
    projectOwnerAssignment.updateOppTeam(olstTestProject2);
         }
    }
    
    static testMethod void testProjectOwnerAssignment6() {
         
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    
    list<project__c> olstTestProject2 = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='V0M 9S9';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';
            
        olstTestProject2.add(p);
        try{ 
    insert olstTestProject2[0];
        }catch(DMLEXCEPTION e){}
        project__c p2= new project__c();
        p2.Name='xyzw enterprise';
        
        p2.Project_Country__c='Canada';
        p2.Project_Zip_Code__c='V0M 9S9';
        p2.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Prospecting';
            
        olstTestProject2.add(p2);
        insert olstTestProject2[1];

        project__c p3= new project__c();
        p3.Name='xyzw enterprise2';
        p3.Project_Zip_Code__c='V0M 9S9';
        p3.Project_Country__c='Canada';
        p3.Project_State__c='Delhi';
        p3.Close_Date__c=Date.newInstance(2015, 12, 12);
        p3.Stage__c='Prospecting';
            
        olstTestProject2.add(p3);
        insert olstTestProject2[2];   
        
        list<opportunity> opp= new list<opportunity>();
        opp=TestDataUtility.createOppTestData();
        opp[0].Project_Name__c=olstTestProject2[1].id;
        insert opp;
        
    //projectOwnerAssignment.assignOwner(olstTestProject);
    projectOwnerAssignment.updateResolutionDate(olstTestProject2);
    projectOwnerAssignment.validateZip(olstTestProject2[0]);
    projectOwnerAssignment.updateOppTeam(olstTestProject2);
    }
    
}