/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  1. OpportunityRedirect - Apex Trigger
                                        
*
* @ Audit Trial   : Repeating block for each change to the code
**/

@isTest(SeeAllData=false)
private class OpportunityRedirect_Test {
	
	public static list<Opportunity> olstOpportunity ;
	public static list<Account> olstAccount ;

    static testMethod void testOpportunityRedirect() {
        
         
        /*list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;*/
        
        list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        /*Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode;*/
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
    
    olstOpportunity = TestDataUtility.createOppTestData();
        try{
        insert olstOpportunity ;
        }catch(Exception e){}
    
    olstAccount = TestDataUtility.createAccountTestData();
        try{
        insert olstAccount ;
        }catch(Exception e){}
    PageReference pageRef = Page.OpportunityRedirectPage;
    Test.setCurrentPageReference(pageRef);
    
    ApexPages.CurrentPage().getparameters().put('accId', olstAccount[0].Id);
    
    ApexPages.StandardController controller = new ApexPages.StandardController(olstOpportunity[0]);
    	
    OpportunityRedirect oppRedirect = new OpportunityRedirect(controller);
    oppRedirect.redirectPage();
    }
    
    static testMethod void testOpportunityRedirect2() {
        
        /*list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;*/
        
       /* list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode;*/
                 list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
        
    
    olstOpportunity = TestDataUtility.createOppTestData();
        try{
        insert olstOpportunity ;
        }catch(Exception e){}
    olstAccount = TestDataUtility.createAccountTestData();
        try{
        insert olstAccount ;
        }catch(Exception e){}
    PageReference pageRef = Page.OpportunityRedirectPage;
    Test.setCurrentPageReference(pageRef);
    
    ApexPages.CurrentPage().getparameters().put(System.Label.ProjectSourceID, 'CF00NK0000001j6CL');
    
    ApexPages.StandardController controller = new ApexPages.StandardController(olstOpportunity[0]);
    	
    OpportunityRedirect oppRedirect = new OpportunityRedirect(controller);
    oppRedirect.redirectPage();
    }
}