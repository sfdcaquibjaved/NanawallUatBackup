/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests AccountOwnerAssignment class
*
* @ Audit Trial   : Repeating block for each change to the code
**/
@isTest
private class AccountOwnerAssignment_Test {
	
	 public static List<Account> olstTestAccount;
	 public static List<Country_codes__c> olstTestCountryCode;
	 public static List<state_codes__c> olstTestStateCode;
	 public static List<Zip_Codes_Master__c> olstTerritoryMastereCode;
	 public static  User olstuse;
    static testMethod void myUnitTest() {
        
        
      olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        try{
        insert olstTestCountryCode ;
        }
        catch(Exception e){}
 	olstTestStateCode = TestDataUtility.getTestStateCodes();
 	try{
        insert olstTestStateCode ; 
    }
        catch(Exception e){}
        
    olstuse=TestDataUtility.createUser('System Administrator','satishlokinindi@gmail.com');
       try{
        insert olstuse;
       }
        catch(Exception e){}
    
    olstTestAccount = TestDataUtility.createAccountTestData();
		
    olstTestAccount[1].BillingCountryCode = 'CA';
    olstTestAccount[1].BillingPostalCode = 'v0m 9s9'; 
    olstTestAccount[1].BillingState = 'Alberta';
        
    olstTestAccount[2].BillingCountryCode = 'US';
    olstTestAccount[2].BillingPostalCode = '12345';   

        
    olstTestAccount[3].BillingCountryCode = 'MX';
	olstTestAccount[3].BillingState = 'Colima';
        try{
		 insert olstTestAccount ; 
        }
        catch(Exception e)
        {
            
        }
        
    olstTestAccount[1].BillingCountryCode = 'US';
    olstTestAccount[1].BillingPostalCode = '12345'; 
    olstTestAccount[2].BillingCountryCode = 'CA';
    olstTestAccount[2].BillingPostalCode = 'v0m 9s9';
    olstTestAccount[3].BillingCountryCode = 'MX';
	olstTestAccount[3].BillingState = 'Colima';
    olstTestAccount[4].BillingCountryCode = 'US';
    olstTestAccount[4].BillingPostalCode = '12345';    
    try{
    
    Update olstTestAccount;
    }
    Catch (Exception ex){}
        
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        //For (Zip_Codes_Master__c o:olstTerritoryMastereCode )
        try{    //o.User__c=olstuse.ID ; 
 	insert olstTerritoryMastereCode ;  
        }
        Catch (Exception ex){}
        
    }
    static testMethod void myUnitTestnew() {
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        //For (Zip_Codes_Master__c o:olstTerritoryMastereCode )
           //o.User__c=olstuse.ID ; 
 	insert olstTerritoryMastereCode ;  
       
       
    	
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        
        insert olstTestCountryCode ;
       
        //catch(Exception e){}
 	olstTestStateCode = TestDataUtility.getTestStateCodes();
 	
        insert olstTestStateCode ; 
    
        //catch(Exception e){}
        
    olstuse=TestDataUtility.createUser('System Administrator','satishlokinindi@gmail.com');
       
        insert olstuse;
       
        //catch(Exception e){}
    
    olstTestAccount = TestDataUtility.createAccountTestData();
	 olstTestAccount[0].BillingCountryCode = 'US';
    olstTestAccount[0].BillingPostalCode = '12345';   
	
    olstTestAccount[1].BillingCountryCode = 'CA';
    olstTestAccount[1].BillingPostalCode = 'v0m 9s9'; 
    olstTestAccount[1].BillingState = 'Alberta';
        
    olstTestAccount[2].BillingCountryCode = 'US';
    olstTestAccount[2].BillingPostalCode = '12345';   

        
    olstTestAccount[3].BillingCountryCode = 'MX';
	olstTestAccount[3].BillingState = 'Colima';
        
    olstTestAccount[4].BillingCountryCode = 'india';
        olstTestAccount[5].BillingCountryCode = 'US';
    olstTestAccount[5].BillingPostalCode = '12345'; 
        
        olstTestAccount[6].BillingCountryCode = 'US';
    olstTestAccount[6].BillingPostalCode = '12345';
        try{
		 insert olstTestAccount ; 
        }
        catch(Exception e){}
        
   // Set<Id> s1 = (new Map<Id,Account>(olstTestAccount)).keySet();
        
      olstTestAccount[0].BillingCountryCode = 'US';
    olstTestAccount[0].BillingPostalCode = '12345';     
    olstTestAccount[1].BillingCountryCode = 'US';
    olstTestAccount[1].BillingPostalCode = '12345'; 
    olstTestAccount[2].BillingCountryCode = 'CA';
    olstTestAccount[2].BillingPostalCode = 'v0m 9s9';
    olstTestAccount[3].BillingCountryCode = 'MX';
	olstTestAccount[3].BillingState = 'Colima';
    olstTestAccount[5].BillingCountryCode = 'US';
    olstTestAccount[5].BillingPostalCode = ''; 
        olstTestAccount[6].BillingCountryCode = 'US';
    olstTestAccount[6].BillingPostalCode = '12345';
        
    
        try{
    
        Update olstTestAccount;
        }
    Catch (Exception ex){}
        
//Set<Id> s1 = (new Map<Id,Account>(olstTestAccount)).keySet();
Set<Id> AccountIds = new Set<Id>();
            //Set<Id> OpportunityIds=new Set<Id>();
            
            for (Account acc :olstTestAccount ){
             AccountIds.add(acc.Id);
            }

       accountOwnerAssignment.assignoppowner(AccountIds);
        accountOwnerAssignment.checkProjectSplit(AccountIds);
   /* olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        //For (Zip_Codes_Master__c o:olstTerritoryMastereCode )
        try{    //o.User__c=olstuse.ID ; 
 	insert olstTerritoryMastereCode ;  
        }
        Catch (Exception ex){}*/
        
    }
     static testMethod void myUnitTestnew2() {
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
         
 	     insert olstTerritoryMastereCode ;  
       
       
    	
    olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        
        insert olstTestCountryCode ;
       
        
 	olstTestStateCode = TestDataUtility.getTestStateCodes();
 	
        insert olstTestStateCode ; 
    
       
        
    olstuse=TestDataUtility.createUser('System Administrator','satishlokinindi@gmail.com');
       
        insert olstuse;
       
        
       
    
    olstTestAccount = TestDataUtility.createAccountTestData();
		
   
         
         
        olstTestAccount[1].BillingCountryCode = 'US';
    olstTestAccount[1].BillingPostalCode = '12345';
        try{
		 insert olstTestAccount ; 
        }
        catch(Exception e){}
        
    olstTestAccount[1].BillingCountryCode = 'US';
    olstTestAccount[1].BillingPostalCode = '12345';
        
    
        try{
    
        Update olstTestAccount;
        }
    Catch (Exception ex){}
        
   
         
    }
}