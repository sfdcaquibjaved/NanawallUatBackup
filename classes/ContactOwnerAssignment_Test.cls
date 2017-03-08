/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests ContactOwnerAssignment class
*
* @ Audit Trial   : Repeating block for each change to the code
**/

@isTest(SeeAllData=false)
private class ContactOwnerAssignment_Test {
    
 public static List<Contact> olstTestContact;
 public static List<Country_codes__c> olstTestCountryCode;
 public static List<state_codes__c> olstTestStateCode;
 public static List<Zip_Codes_Master__c> olstTerritoryMastereCode;
 
 public static testmethod void testcontactOwnerAss(){
    
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    
    olstTestContact = TestDataUtility.createConTestData();
    olstTestContact[1].MailingCountryCode = 'CA' ;
    //olstTestContact[1].mailingPostalCode=' ';
    olstTestContact[2].MailingCountryCode = 'IN' ;
     olstTestContact[3].MailingCountryCode = 'MX' ;
    //olstTestContact[2].mailingPostalCode=' ';
    try{  
    insert olstTestContact ;
    }
    Catch (Exception ex){}
     
     contactOwnerAssignment.validationPass=FALSE;
     contactOwnerAssignment.assignOwner(olstTestContact);
    contactOwnerAssignment.validateZip(olstTestContact[1]);
     
 }
 public static testmethod void testcontactOwnerAss2(){
    
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    
    olstTestContact = TestDataUtility.createConTestData();
    olstTestContact[1].MailingCountryCode = 'CA' ;
    olstTestContact[1].mailingPostalCode='';
    try{  
    insert olstTestContact ;
    }
    Catch (Exception ex){}
     
     contactOwnerAssignment.validationPass=FALSE;
     contactOwnerAssignment.assignOwner(olstTestContact);
    contactOwnerAssignment.validateZip(olstTestContact[1]);
     
 }
public static testmethod void testcontactOwnerAss3(){
    
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    
    olstTestContact = TestDataUtility.createConTestData();
    //olstTestContact[1].MailingCountryCode = 'CA' ;
    //olstTestContact[1].mailingPostalCode='';
    olstTestContact[1].MailingCountryCode = 'MX';
    olstTestContact[2].mailingPostalCode='';
    
    
    try{  
    insert olstTestContact ;
    }
    Catch (Exception ex){}
     
     contactOwnerAssignment.validationPass=FALSE;
     contactOwnerAssignment.assignOwner(olstTestContact);
    contactOwnerAssignment.validateZip(olstTestContact[1]);
     
 }
}