/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  ObjectsOwnerUpdatefromZip - Apex Class
                                       
*
* @ Audit Trial   : Repeating block for each change to the code
**/

@isTest(SeeAllData=false)

private class ObjectsOwnerUpdatefromZip_Test {
  
  public static List<Account> olstTestAccount;
  public static User testUser1;
  public static User testUser2;
  public static List<Lead> olstTestLead;
  public static List<Contact> olstTestContact;
  public static List<Project__c> olstTestProject;
  public static List<Zip_Codes_Master__c> olstTerritoryMastereCode;
  public static List<Zip_Codes_Master__c> olstTerritoryMastereCode2;
  
  
  static testMethod void testobjectsOwnerUpdatefromZip(){
  /*Org_Default_Settings__c ods = new Org_Default_Settings__c();
         ods.OpportunityTrigger__c=TRUE;
        ods.accountownerassignmentTrigger__c=True;
        ods.contactownerassignmentTrigger__c=True;
        ods.OwnerUpdateTrigger__c=True;
        ods.ProjectTrigger__c=True;
        ods.QuoteTrigger__c=true;
        insert ods;*/
    
    testUser1 = TestDataUtility.createUser('System Administrator', 'testUser1@test.com');
    insert testUser1 ;
    
    testUser2 = TestDataUtility.createUser('System Administrator', 'testUser2@test.com');
    insert testUser2 ;
    
    System.runAs(testUser1){
    
    olstTestAccount = TestDataUtility.createAccountTestData();
    olstTestAccount[0].BillingCountry = 'United States';
    olstTestAccount[0].BillingPostalCode = '04037';
    olstTestAccount[1].BillingPostalCode = '08688';
    olstTestAccount[2].BillingCountry = 'United States';
        try{
    insert olstTestAccount ;
        }catch(DMLEXCEPTION e){}
    
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].Country = 'United States';
    olstTestLead[0].PostalCode = '04037' ;
    olstTestLead[1].Country = 'United States';
    olstTestLead[0].OwnerId = testUser1.Id ;
    olstTestLead[1].OwnerId = testUser1.Id ;
        try{
    insert olstTestLead ;
        }catch(DMLEXCEPTION e){}
    
    
    olstTestContact = TestDataUtility.createConTestData();
    olstTestContact[0].MailingCountry = 'United States';
    olstTestContact[0].MailingPostalCode = '04037';
    olstTestContact[1].MailingCountry = 'United States';
        try{
    insert olstTestContact ;
        }catch(DMLEXCEPTION e){}
    
    olstTestProject = TestDataUtility.createProjectTestData();
    olstTestProject[0].project_zip_code__c = '04037';
    olstTestProject[0].project_country__c = 'United States';
    olstTestProject[2].project_country__c = 'United States';
        try{
    insert olstTestProject ;
        }catch(DMLEXCEPTION e){}
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster() ;
    olstTerritoryMastereCode[0].user__c = testUser1.Id ;
    olstTerritoryMastereCode[1].user__c = testUser1.Id ;
    insert olstTerritoryMastereCode ;
    
    olstTerritoryMastereCode2 = TestDataUtility.getTerritoryMaster() ;
    olstTerritoryMastereCode2[0].user__c = testUser2.Id ;
    olstTerritoryMastereCode2[1].user__c = testUser2.Id ;
    olstTerritoryMastereCode2[1].Zip_Code__c = '' ;
    olstTerritoryMastereCode2[1].Country__c = 'United States' ;
    insert olstTerritoryMastereCode2 ;
    olstTerritoryMastereCode2[1].user__c = testUser1.Id ;
    try{
    update olstTerritoryMastereCode2 ;
    }catch(Exception e){}
    
    
    objectsOwnerUpdatefromZip.assignobjectowner(olstTerritoryMastereCode, olstTerritoryMastereCode2);
    }
  }

    static testMethod void testobjectsOwnerUpdatefromZip2(){
    
    testUser1 = TestDataUtility.createUser('System Administrator', 'testUser1@test.com');
    insert testUser1 ;
    
    testUser2 = TestDataUtility.createUser('System Administrator', 'testUser2@test.com');
    insert testUser2 ;
    
    System.runAs(testUser1){
    
    olstTestAccount = TestDataUtility.createAccountTestData();
    olstTestAccount[0].BillingCountry = 'United States';
    olstTestAccount[0].BillingPostalCode = '04037';
    olstTestAccount[1].BillingPostalCode = '08688';
    olstTestAccount[2].BillingCountry = 'United States';
        try{
    insert olstTestAccount ;
        }catch(DMLEXCEPTION e){}
    
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].Country = 'United States';
    olstTestLead[0].PostalCode = '07007' ;
    olstTestLead[1].Country = 'United States';
   // olstTestLead[1].Country = '';
    olstTestLead[0].OwnerId = testUser1.Id ;
   // olstTestLead[1].OwnerId = testUser1.Id ;
    olstTestLead[0].Status= 'Open' ;
     //olstTestLead[1].isConverted= false ;
        try{
    insert olstTestLead ;
        }catch(DMLEXCEPTION e){}
    
    
    olstTestContact = TestDataUtility.createConTestData();
    olstTestContact[0].MailingCountry = 'United States';
    olstTestContact[0].MailingPostalCode = '07007';
    olstTestContact[1].MailingCountry = 'United States';
        try{
    insert olstTestContact ;
        }catch(DMLEXCEPTION e){}
    
    
    olstTestProject = TestDataUtility.createProjectTestData();
    olstTestProject[0].project_zip_code__c = '07007';
    olstTestProject[0].project_country__c = 'United States';
    olstTestProject[2].project_country__c = 'United States';
    olstTestProject[0].Stage__c = 'Closed won - Order Signed';
    olstTestProject[2].Stage__c = 'Closed won - Order In Process';
       // olstTestProject[0].owid
        try{    
    insert olstTestProject ;
        }catch(DMLEXCEPTION e){}
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster() ;
    olstTerritoryMastereCode[0].user__c = testUser1.Id ;
    olstTerritoryMastereCode[1].user__c = testUser1.Id ;
    insert olstTerritoryMastereCode ;
    
    olstTerritoryMastereCode2 = TestDataUtility.getTerritoryMaster() ;
    olstTerritoryMastereCode2[0].user__c = testUser2.Id ;
    olstTerritoryMastereCode2[1].user__c = testUser2.Id ;
    olstTerritoryMastereCode2[1].Zip_Code__c = '12345' ;
    olstTerritoryMastereCode2[1].Country__c = 'United States' ;
    insert olstTerritoryMastereCode2 ;
    olstTerritoryMastereCode2[1].user__c = testUser1.Id ;
    update olstTerritoryMastereCode2 ;
    
    
    objectsOwnerUpdatefromZip.assignobjectowner(olstTerritoryMastereCode, olstTerritoryMastereCode2);
    }
  }
 /*static testMethod void testobjectsOwnerUpdatefromZip3(){
    testUser1 = TestDataUtility.createUser('System Administrator', 'testUser1@test.com');
    insert testUser1 ;
    
    testUser2 = TestDataUtility.createUser('System Administrator', 'testUser2@test.com');
    insert testUser2 ;

System.runAs(testUser1){

Account a = new Account();
        
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account1';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12346';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';

        insert a;


Lead l = new Lead();
        l.Phone = '(123) 456-7890';
        l.project_name__c = 'Test Proj';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        l.PostalCode = '12345';
        l.CountryCode = 'US';
        l.Type_of_record__c = 'Commercial';
        l.Project_Application_Industry__c = 'Automotive';
        l.Project_Application__c = 'Dealership';
        l.Project_Site_Zip_Code__c= '94040';
        l.OwnerId = testUser1.Id ;
        l.isConverted= false ;
insert l;
    System.debug('@@@@@@@@@@'+l.OwnerId);
    System.debug('#############'+l.isconverted);
    
    
    Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
        con.OwnerId = testUser1.Id ;
    insert con;
    
    Project__c p1 = new Project__c();
            p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             p1.OwnerId = testUser1.Id;
             p1.Stage__c = 'Closed won - Order Signed';
            insert p1;
}
}
*/

    
}