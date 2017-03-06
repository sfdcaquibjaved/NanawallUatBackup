/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod 
 * keyword in the method definition. 
 * 
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *  
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 
@isTest(SeeAllData=false)
private class UnitTests {

 public static list < Zip_Codes_Master__c > territorymaster;
 public static list < Country_codes__c > countrys;
 public static list < state_codes__c > states;
 
    @istest
    public static void testTestController()
    {
    
        TestController c = new TestController();
        c.dummyopportunity.Nana_Create_Date__c = Date.today().addDays(-10);//Date.valueOf('2012-01-01');
        c.dummyOpportunity.Nana_Edit_Date__c =  Date.today().addDays(-10);//Date.valueOf('2012-12-31');
        c.FindSalesteamsOverOneHundredPercent();
        c.zipcode = '08619';
        c.gettaxrate();
        c.runTest();
    }


    @isTest(SeeAllData=false)
    static void RunTests () {
    
     //Creating test data for Territory Master
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
         //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
        testTestController();
        
        User u = [SELECT id from User WHERE isactive = true LIMIT 1];
        //Account acc = [SELECT id FROM Account LIMIT 1 ];
        
        User u2;
        try { 
            u2 = [SELECT id from User WHERE ProfileId = :Utility.RequiredProfileID() AND isactive = true LIMIT 1 ];
        } catch(Exception ex )
        {
             u2 = [SELECT id from User WHERE isactive = true AND id != :u.id LIMIT 1];
        }       
         
        //insert new objects
        List<Account> accs = new List<Account>();
        Integer i;
        for( i = 0; i < 1; i++ )
        {
            Account a = new Account();
            a.Phone = '123-456-7890';
            a.Name = 'Test account';
            a.BillingCountryCode = 'US';
            a.BillingPostalCode = '12345';
            accs.add(a); 
        }       
        insert accs; 
         
        try { 
                accs[0].IsDirty__c = true;
            update accs[0];
            ApexPages.currentPage().getParameters().put('id', accs[0].Id);

        } catch( exception ex ){}

 
 
        List<Contact> conts = new List<Contact>();
        for( i = 0; i < 1; i++ )
        {
            Contact c = new Contact();
            c.FirstName = 'TestFirst';
            c.LastName = 'TestLast';
            c.MailingPostalCode = '12345';
            c.MailingCountryCode = 'US';
            conts.add(c);
//            c.Email = 'kristian.stout.'+(100+i)+'@a-stechnologies.com';
        }       
        insert conts;        
          
        try {
            conts[0].IsDirty__c = true;
            update conts[0];

        } catch( exception ex ){}


        List<Opportunity> opps2 = new List<Opportunity>();
        for( i = 0; i < 1; i++ )
        { 
            Opportunity o = new Opportunity();
            o.Name = 'test opp';
            o.StageName = 'test stage';
            o.CloseDate = Date.today();
            o.Country__c = 'USA';
            o.Postal_Code__c = 'TEST';
            opps2.add( o );  
        }       
        insert opps2;
        try{
            update(opps2[0]);
        }catch (Exception ex ){}
        
        List<nrOpportunityContactRole__c> ocrs = new List<nrOpportunityContactRole__c>();
        for( i = 0; i < 1; i++ )
        {
            nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
            ocr.Opportunity__c = opps2[0].id;
            ocr.Contact__c = conts[0].id;
            
            ocrs.add( ocr );
        }       
        
        try{
            insert ocrs;
        } catch (Exception ex){}

        nrOpportunityContactRole__c ocr2 = new nrOpportunityContactRole__c();
        ocr2.Opportunity__c = opps2[0].id;
        ocr2.Contact__c = conts[0].id;
        OppContNewController ocnc = new OppContNewController( new Apexpages.Standardcontroller(ocr2));
        ocnc.Cancel();
        
        try
        {
            ocnc.Save();
        }catch(Exception ex){}
        
        ocnc.getContactName();
        ocnc.getOCR();
        ocnc.setContactName('test');
        
        OppContRoleEditController ocrec = new OppContRoleEditController( new Apexpages.Standardcontroller(ocr2));
        ocrec.getContactName();
        ocrec.setContactName('test');
        
        try
        {
            ocrec.Save();
        } catch(Exception ex){}     
        
        List<nrOpportunityTeamMember__c> otms = new List<nrOpportunityTeamMember__c>();
        for( i = 0; i < 1; i++ )
        {
            nrOpportunityTeamMember__c nrotm = new nrOpportunityTeamMember__c();        
            nrotm.Opportunity__c = opps2[0].Id;
            nrotm.Commission__c = 20;
            nrotm.User__c = u.Id;
            otms.add(nrotm);
        }
        insert otms;
        
        
        try
        {
            nrSalesteamListController slc = new nrSalesteamListController( new Apexpages.Standardcontroller(opps2[0]));
            slc.getOpp();
            slc.getOTMs();
            slc.getRenderRedirectCode();
            slc.UpdateOTMs();
        
        } catch( Exception ex ) {}

        
        //update objects
        for( Account a : accs )
        {
            a.Phone = '234-567-8903';
            a.Name = 'Test account - updated';
        }       
        update accs;

        for( Contact c : conts )
        {
            c.FirstName = 'TestFirst - updated';
            c.LastName = 'TestLast - updated';
        }       
        update conts;

        for( Opportunity o : opps2 )
        {
            o.Name = 'test opp - updated';
            o.StageName = 'test stage - updated'; 
            o.CloseDate = Date.today();
        }       
        try{
            update opps2;
        }catch (Exception ex){}
        
        
    }
    @isTest(SeeAllData=false)
    static void RunTests2 () {
        
        //Creating test data for Territory Master
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
         //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
        testTestController();
        
        User u = [SELECT id from User WHERE isactive = true LIMIT 1];
        //Account acc = [SELECT id FROM Account LIMIT 1 ];
        
        User u2;
        try { 
            u2 = [SELECT id from User WHERE ProfileId = :Utility.RequiredProfileID() AND isactive = true LIMIT 1 ];
        } catch(Exception ex )
        {
             u2 = [SELECT id from User WHERE isactive = true AND id != :u.id LIMIT 1];
        }       
         
        //insert new objects
        List<Account> accs = new List<Account>();
        Integer i;
        for( i = 0; i < 1; i++ )
        {
            Account a = new Account();
            a.Phone = '123-456-7890';
            a.Name = 'Test account';
            a.BillingCountryCode = 'US';
            a.BillingPostalCode = '12345';
            accs.add(a); 
        }       
        insert accs; 
 
        try { 
                accs[0].IsDirty__c = true;
            update accs[0];
            ApexPages.currentPage().getParameters().put('id', accs[0].Id);

        } catch( exception ex ){}

 
 
        List<Contact> conts = new List<Contact>();
        for( i = 0; i < 1; i++ )
        {
            Contact c = new Contact();
            c.FirstName = 'TestFirst';
            c.LastName = 'TestLast';
            c.MailingPostalCode = '12345';
            c.MailingCountryCode = 'US';
            conts.add(c);
//            c.Email = 'kristian.stout.'+(100+i)+'@a-stechnologies.com';
        }       
        insert conts;        
          
        try {
            conts[0].IsDirty__c = true;
            update conts[0];

        } catch( exception ex ){}


        List<Opportunity> opps2 = new List<Opportunity>();
        for( i = 0; i < 1; i++ )
        { 
            Opportunity o = new Opportunity();
            o.Name = 'test opp';
            o.StageName = 'test stage';
            o.CloseDate = Date.today();
            o.Country__c = 'USA';
            o.Postal_Code__c = 'TEST';
            opps2.add( o );  
        }       
        insert opps2;
        try{
            update(opps2[0]);
        }catch (Exception ex ){}
        
        List<nrOpportunityContactRole__c> ocrs = new List<nrOpportunityContactRole__c>();
        for( i = 0; i < 1; i++ )
        {
            nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
            ocr.Opportunity__c = opps2[0].id;
            ocr.Contact__c = conts[0].id;
            
            ocrs.add( ocr );
        }       
        
        try{
            insert ocrs;
        } catch (Exception ex){}

        nrOpportunityContactRole__c ocr2 = new nrOpportunityContactRole__c();
        ocr2.Opportunity__c = opps2[0].id;
        ocr2.Contact__c = conts[0].id;
        OppContNewController ocnc = new OppContNewController( new Apexpages.Standardcontroller(ocr2));
        ocnc.Cancel();
        
        try
        {
            ocnc.Save();
        }catch(Exception ex){}
        
        ocnc.getContactName();
        ocnc.getOCR();
        ocnc.setContactName('test');
        
        OppContRoleEditController ocrec = new OppContRoleEditController( new Apexpages.Standardcontroller(ocr2));
        ocrec.getContactName();
        ocrec.setContactName('test');
        
        try
        {
            ocrec.Save();
        } catch(Exception ex){}     
        
        List<nrOpportunityTeamMember__c> otms = new List<nrOpportunityTeamMember__c>();
        for( i = 0; i < 1; i++ )
        {
            nrOpportunityTeamMember__c nrotm = new nrOpportunityTeamMember__c();        
            nrotm.Opportunity__c = opps2[0].Id;
            nrotm.Commission__c = 20;
            nrotm.User__c = u.Id;
            otms.add(nrotm);
        }
        insert otms;
        
        
        try
        {
            nrSalesteamListController slc = new nrSalesteamListController( new Apexpages.Standardcontroller(opps2[0]));
            slc.getOpp();
            slc.getOTMs();
            slc.getRenderRedirectCode();
            slc.UpdateOTMs();
        
        } catch( Exception ex ) {}

        
        //update objects
        for( Account a : accs )
        {
            a.Phone = '234-567-8903';
            a.Name = 'Test account - updated';
        }       
        update accs;
    }
}