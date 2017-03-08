/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests LeadOwnerAssignment class
*
* @ Audit Trial   : Repeating block for each change to the code
**/
@isTest(SeeAllData=false)

private class LeadOwnerAssignment_Test {
     
     
    
     public static list<Lead> olstTestLead;
     public static List<Country_codes__c> olstTestCountryCode;
     public static List<state_codes__c> olstTestStateCode;
     public static List<Zip_Codes_Master__c> olstTerritoryMastereCode;
     public static  User olstuse;
    
    static testMethod void testLeadOwnerAssignment() {
        
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstuse=TestDataUtility.createUser('System Administrator','satishlokinindi@gmail.com');
        insert olstuse;
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        try{
    insert olstTerritoryMastereCode ;
        }catch(Exception e){}
    

        
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].CountryCode = 'US' ;
    olstTestLead[0].PostalCode='12345';
    olstTestLead[2].CountryCode = 'IN' ;
        
        try{
    insert olstTestLead ;
        
   olstTestLead[2].CountryCode = 'MX' ;
    olstTestLead[2].StateCode='BC';
    update olstTestLead;
    }
    Catch(Exception ex){}
         
     leadOwnerAssignment.doNotRun=FALSE;
    leadOwnerAssignment.doNotRunInsert=FALSE;
    leadOwnerAssignment.validationPass=FALSE;
   
    }
    static testMethod void testLeadOwnerAssignment2() {
        
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstuse=TestDataUtility.createUser('System Administrator','satishlokinindi@gmail.com');
        insert olstuse;
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    

        
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].CountryCode = 'CA' ;
    olstTestLead[1].CountryCode = ' ' ;
        
        try{
    insert olstTestLead ;
    }
    Catch(Exception ex){}
         
     leadOwnerAssignment.doNotRun=FALSE;
    leadOwnerAssignment.doNotRunInsert=FALSE;
    leadOwnerAssignment.validationPass=FALSE;
   
    }
   static testMethod void testLeadOwnerAssignment3() {
        
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstuse=TestDataUtility.createUser('System Administrator','satishlokinindi@gmail.com');
        insert olstuse;
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    

        
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].CountryCode = 'CA' ;
    olstTestLead[0].PostalCode='V0M 9S9';
    olstTestLead[1].CountryCode = 'MX' ;
       olstTestLead[1].StateCode='BC';
        
        try{
    insert olstTestLead ;
    }
    Catch(Exception ex){}
      
           
         
     leadOwnerAssignment.doNotRun=FALSE;
    leadOwnerAssignment.doNotRunInsert=FALSE;
    leadOwnerAssignment.validationPass=FALSE;
   
   
    }
    static testMethod void testLeadOwnerAssignment4() {
        
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstuse=TestDataUtility.createUser('System Administrator','satishlokinindi@gmail.com');
        insert olstuse;
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    

        
    list<lead> le= new list<lead>();
        Lead l = new Lead();
        
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        l.PostalCode = '12345';
        l.CountryCode = 'US';
        l.Type__c= 'other';
        l.Status='open';
        l.Company='xyz';
        
       le.add(l);
    insert le;
    
       Set<Id> s1 = (new Map<Id,Lead>(le)).keySet();
           
         
     leadOwnerAssignment.doNotRun=FALSE;
    leadOwnerAssignment.doNotRunInsert=FALSE;
    leadOwnerAssignment.validationPass=FALSE;
    leadOwnerAssignment.assignOwner(s1);   
   
    }
    static testMethod void testLeadOwnerAssignment5() {
     
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
    insert olstTestCountryCode ;
    
    olstTestStateCode = TestDataUtility.getTestStateCodes();
    insert olstTestStateCode ; 
    
    olstuse=TestDataUtility.createUser('System Administrator','satishlokinindi@gmail.com');
        insert olstuse;
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
    insert olstTerritoryMastereCode ;
    

        
    list<lead> le= new list<lead>();
        Lead l = new Lead();
        
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        l.PostalCode = '';
        l.CountryCode = 'US';
        l.Type__c= 'other';
        l.Status='open';
        l.Company='xyz';
        
       le.add(l);
        try{insert le;
           }catch(Exception e){}
    
        l.Company='abc';
        try{
        update le;
        }catch(Exception e){}
       /*Set<Id> s1 = (new Map<Id,Lead>(le)).keySet();
           
         
     leadOwnerAssignment.doNotRun=FALSE;
    leadOwnerAssignment.doNotRunInsert=FALSE;
    leadOwnerAssignment.validationPass=FALSE;
    leadOwnerAssignment.assignOwner(s1);  */ 
   
    }
    

}