/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  1. OpportunityNewController - Apex Class
                                        
* @ Audit Trial   : Repeating block for each change to the code
**/
@isTest(SeeAllData=false)
private class OpportunityNewController_Test {
	
	public static list<Account> olstAccount ;
	public static list<Contact> olstContact ;
	public static list<Opportunity> olstOpportunity ;

     static testMethod void testmth()
    {
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
        
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
        try{
        insert olstAccount ;
        }
        catch(Exception e){}
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        try{
        insert olstContact ;
        }
        catch(Exception e){}
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        try{
        insert olstOpportunity ;
        }
        catch(Exception e){}
        
//      Apexpages.currentPage().getParameters().set('conid', c.id);
        OpportunityNewController.fakecontid = olstContact[0].Id;
        
                
        OpportunityNewController ocnc = new OpportunityNewController(  new ApexPages.StandardController(new Opportunity() ) );
        list<selectoption> opts = ocnc.competitoraccounts;

        ocnc.getShowInfoBlock();
        ocnc.getShowDupeBlock();
        ocnc.updateProbability();
        ocnc.getProbability();
        ocnc.CheckDupes();
        ocnc.getNewOpportunity();
        ocnc.getnrOCR();
        
        ocnc.getNewOpportunity().Application__c = 'supermarket';
        ocnc.getNewOpportunity().Name = 'jsldkijisdijsjld';
        
        //ocnc.getnrOCR().Contact__c = olstContact[0].id;
        
        //ocnc.competitoraccount = opts[0].getValue();
        
        ocnc.save();
        ocnc.cancel();

        ocnc.getNewOpportunity().StageName = 'Considered';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Specified';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Quote Requested';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Budget Quote to Architect';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Quote/Non-Architect';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Quoted Architect and Non-Architect';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Order Probably Coming';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Order Process Started';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Ordered - Paid';
        ocnc.getProbability();

    }
static testMethod void testmth2()
    {
                list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode; 
        /*list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode;*/
        
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
        try{
        insert olstAccount ;
        }
        catch(Exception e){}
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        try{
        insert olstContact ;
        }
        catch(Exception e){}
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        //olstOpportunity[0].Name='';
        try{
        insert olstOpportunity ;
        }
        catch(Exception e){}
        
//      Apexpages.currentPage().getParameters().set('conid', c.id);
        OpportunityNewController.fakecontid = olstContact[0].Id;
        
        OpportunityNewController.fakecontid = '';
        
        //OpportunityNewController.du
        
        
        
     
        
                
        OpportunityNewController ocnc = new OpportunityNewController(  new ApexPages.StandardController(new Opportunity() ) );
        list<selectoption> opts = ocnc.competitoraccounts;
		ocnc.getduplicateOpps();
        ocnc.getShowInfoBlock();
        ocnc.getShowDupeBlock();
        ocnc.updateProbability();
        ocnc.getProbability();
        ocnc.CheckDupes();
        ocnc.getNewOpportunity();
        ocnc.getnrOCR();
        //ocnc.saveproj();
        
        ocnc.getNewOpportunity().Application__c = 'supermarket';
        ocnc.getNewOpportunity().Name = 'jsldkijisdijsjld';
        
       // ocnc.getduplicateOpps().Name='';

        ocnc.getNewOpportunity().Name = '';         
        //ocnc.getnrOCR().Contact__c = olstContact[0].id;
        
       ocnc.competitoraccount ='testing';
       // ocnc.competitoraccount =olstAccount[0].id;
        
         //ocnc.competitoraccount=opts.size();
        //ocnc.competitoraccount = opts[0].getValue();
        
        ocnc.save();
        ocnc.cancel();

        ocnc.getNewOpportunity().StageName = 'Considered';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Specified';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Quote Requested';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Budget Quote to Architect';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Quote/Non-Architect';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Quoted Architect and Non-Architect';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Order Probably Coming';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Order Process Started';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = 'Ordered - Paid';
        ocnc.getProbability();
        ocnc.getNewOpportunity().StageName = '';
        ocnc.getProbability();

    }
static testMethod void testmth3()
    {
        
                 list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
       /* list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode;*/
        
        list<Account> olstAccount1 = new list<Account>();
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Competitor__c = true;
        olstAccount1.add(a);
        insert olstAccount1;
        
        List<Contact> olstContact1 = new List<Contact>();
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo' ;
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.AccountId = olstAccount1[0].Id ;
        olstContact1.add(con);  
         insert olstContact1;
        
        
        /*olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        olstContact[0].city__c='test';
        olstContact[0].state__c='california';
        try{
        insert olstContact ;
        }
        catch(Exception e){}*/
        
        /*olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount1[0].Id ;
        olstOpportunity[0].Name='';
        olstOpportunity[0].city__c='city';
        olstOpportunity[0].state__c='CA';
        try{
        insert olstOpportunity ;
        }
        catch(Exception e){}*/
        List<Opportunity> olstOpportunity1 = new List<Opportunity>();
        Opportunity o = new Opportunity();
        o.Name = 'Opportunity test';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'US';
        o.Postal_Code__c = '12345';
        o.city__c='city';
        o.state__c='CA';
        olstOpportunity1.add(o); 
       
        insert olstOpportunity1;
        
        
//      Apexpages.currentPage().getParameters().set('conid', c.id);
        OpportunityNewController.fakecontid = olstContact1[0].Id;
        
        OpportunityNewController.fakecontid = '';
        
        //OpportunityNewController.du
        
        
        
     
        
                
        OpportunityNewController ocnc1 = new OpportunityNewController(  new ApexPages.StandardController(new Opportunity() ) );
        list<selectoption> opts = ocnc1.competitoraccounts;
		ocnc1.getduplicateOpps();
        ocnc1.getShowInfoBlock();
        ocnc1.getShowDupeBlock();
        ocnc1.updateProbability();
        ocnc1.getProbability();
        ocnc1.getduplicateopps();
        ocnc1.CheckDupes();
        ocnc1.getNewOpportunity();
        ocnc1.getnrOCR();
        ocnc1.getduplicateopps() ;
       // ocnc.saveproj();
       
        ocnc1.getnrOCR().Contact__c = olstContact1[0].id; 
        ocnc1.getNewOpportunity().Application__c = 'supermarket';
        //ocnc1.getNewOpportunity().Name = 'jsldkijisdijsjld';
        
       
        ocnc1.getNewOpportunity().Chain_Account__c = true;
        ocnc1.getNewOpportunity().Name = '';
        ocnc1.getNewOpportunity().Name =null;
        //ocnc.getnrOCR().Contact__c = olstContact1[0].id;
        
       ocnc1.competitoraccount ='testing';
       // ocnc.competitoraccount =olstAccount[0].id;
        
         //ocnc.competitoraccount=opts.size();
        //ocnc.competitoraccount = opts[0].getValue();
        
        ocnc1.save();
        ocnc1.cancel();
        
       

        ocnc1.getNewOpportunity().StageName = 'Considered';
        ocnc1.getProbability();
        ocnc1.getNewOpportunity().StageName = 'Specified';
        ocnc1.getProbability();
        ocnc1.getNewOpportunity().StageName = 'Quote Requested';
        ocnc1.getProbability();
        ocnc1.getNewOpportunity().StageName = 'Budget Quote to Architect';
        ocnc1.getProbability();
        ocnc1.getNewOpportunity().StageName = 'Quote/Non-Architect';
        ocnc1.getProbability();
        ocnc1.getNewOpportunity().StageName = 'Quoted Architect and Non-Architect';
        ocnc1.getProbability();
        ocnc1.getNewOpportunity().StageName = 'Order Probably Coming';
        ocnc1.getProbability();
        ocnc1.getNewOpportunity().StageName = 'Order Process Started';
        ocnc1.getProbability();
        ocnc1.getNewOpportunity().StageName = 'Ordered - Paid';
        ocnc1.getProbability();
        ocnc1.getNewOpportunity().StageName = '';
        ocnc1.getProbability();
        
        ocnc1.getNewOpportunity().city__c='city';
       ocnc1.getNewOpportunity().state__c='CA';
        

    }

}