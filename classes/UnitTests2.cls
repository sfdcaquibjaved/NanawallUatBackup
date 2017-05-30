//i had to break unittests into separate files because there would be fialures, but the tests generated
//more than the 2mb log size, so i could never figure out wtf was going on

@isTest(SeeAllData=false)
public with sharing class UnitTests2 {
	@isTest(SeeAllData=false)
    static void RunTests () 
    {
        test.startTest();
        //objects needed for later tests
        User u = [SELECT id from User WHERE isactive = true LIMIT 1];
        
      list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
    	
		 
        
        List<Opportunity> opps2 = new List<Opportunity>();
        Opportunity o = new Opportunity();
        o.Name = 'test opp';
        o.StageName = 'test stage';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        opps2.add( o );  
        insert opps2;
        
        List<nrOpportunityTeamMember__c> otms = new List<nrOpportunityTeamMember__c>();
        nrOpportunityTeamMember__c nrotm = new nrOpportunityTeamMember__c();        
        nrotm.Opportunity__c = opps2[0].Id;
        nrotm.Commission__c = 20;
        nrotm.User__c = u.Id;
        otms.add(nrotm);
        insert otms;
        
        List<Account> accs = new List<Account>();
        Account a = new Account();
        a.Phone = '123-456-7890';
        a.Name = 'Test account';
        a.Country__c = 'USA';
        a.Zip__c = 'TEST';
        a.BillingState = 'New York';
	    a.BillingCountry='United States';
	    a.BillingPostalCode='12345';
        accs.add(a); 
        insert accs; 
        
        List<Contact> conts = new List<Contact>(); 
		Contact c = new Contact();
		c.FirstName = 'TestFirst';
		c.LastName = 'TestLast';
		c.MailingPostalCode = '12345';
		c.MailingCountryCode = 'US';
        c.AccountId = accs[0].id;
//		c.Zip__c = '1';
//		c.Country__c = 'USA';
		conts.add(c);

        insert conts;       
        
        Account acc = [SELECT id FROM Account LIMIT 1 ];
        
        List<nrOpportunityContactRole__c> ocrs = new List<nrOpportunityContactRole__c>();
		nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
		ocr.Opportunity__c = opps2[0].id;
		ocr.Contact__c = conts[0].id;
        ocrs.add( ocr );
        
    	//end objects
    	
        try {
	        update ocrs;
        }catch (Exception ex ) {}
        
        for(nrOpportunityTeamMember__c nrotm2 : otms )
        {
            nrotm2.User__c = u.id;
        }
        update otms;

		nrOpportunityTeamMember__c ot = new nrOpportunityTeamMember__c();
		ot.User__c = u.Id;
		ot.Opportunity__c = opps2[0].id;

		nrOppTeamController nrotc = new nrOppTeamController( new Apexpages.Standardcontroller(ot));
		nrotc.setSelectedUser(u.id);
		nrotc.Cancel();
		nrotc.getUserItems();
		nrotc.getAvailableAccessLevels(); 
		nrotc.getDontRenderUserLookup();
		nrotc.getEditRoleNotOK();
		nrotc.UpdateRec();
		nrotc.getSelectedUser();
		nrotc.getUserItems();
		nrotc.getAvailableAccessLevels();
        nrotc.getSelectedAccessLevel();
        nrotc.setSelectedAccessLevel('Read');


        //test leads
        Lead l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
//        l.Zip__c = 'TEST';
        l.OwnerId = u.Id;
        l.PostalCode = '12345';
        l.CountryCode = 'US';
        insert l;
        
        l.FirstName = 'testfirst - updated';
        
		l.Address_1__c  = '123 street';
		l.Address_2__c = 'another one';
		l.nrCountry__c = 'USA';
		l.LeadSource = 'somewhere';
		l.Interest__c = 'yes';      
        
		Account convertacc = new Account();
		convertacc.Phone = '(123) 456-7890';
		convertacc.Name = 'Test account';
		convertacc.Country__c = 'USA';
		convertacc.Zip__c = '12345';	
		convertacc.BillingState = 'New York';
	    convertacc.BillingCountry='United States';
	    convertacc.BillingPostalCode='12345';	
		insert convertacc;
/*
        LeadConvertController lcc = new LeadConvertController( new Apexpages.Standardcontroller(l) );
        lcc.setCreateNewOpp(true);
        lcc.setNewAccName('test account');
        lcc.setNewOppName('test opp');
        lcc.setUseExistingAccount('new');
        //actually generate the lead-convert        
        lcc.ConvertLead(convertacc.id);  
        
        //just call all the get-ters for test purposes
        lcc.ToggleAccountType();
        lcc.getAccountID();
        lcc.getAccountOptions();
//      lcc.getAccounts();
        lcc.getContactLookup();
        lcc.getCreateNewOpp();
        lcc.getNewAccName();
        lcc.getNewOppName();
        lcc.getUseExistingAccount();
        lcc.setAccountID('ssss');
//        lcc.HandlePostConversion();


		//test another sort of lead conversion
        l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
//        l.Zip__c = 'TEST';
        l.OwnerId = u.Id;
        l.PostalCode = '08619';
        l.CountryCode = 'US';
        insert l;

        lcc = new LeadConvertController( new Apexpages.Standardcontroller(l) );
        lcc.setCreateNewOpp(true);
        lcc.setNewOppName('test opp');
        lcc.setUseExistingAccount('new');
        //actually generate the lead-convert        
        lcc.ConvertLead(convertacc.id);  
    
/*      */
        //test a different sort of lead conversion 
        /*l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        l.PostalCode = '08610';
        l.CountryCode = 'US';
//        l.Zip__c = 'TEST';
        l.OwnerId = u.Id;
      //  insert l;

        lcc = new LeadConvertController( new Apexpages.Standardcontroller(l) );
        lcc.setCreateNewOpp(true);
        lcc.setNewOppName('test opp');
        lcc.getContactLookup().AccountId = acc.Id;
        lcc.setUseExistingAccount('existing');

        //actually generate the lead-convert        
        lcc.ConvertLead(convertacc.id);  
/* */       

        Project__c p1 = new Project__c();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Quote__c q = new Quote__c();
        q.Opportunity__c = opps2[0].Id;
        q.Contact__c = conts[0].id;
        q.Name = 'Test Quote';
       // q.Quote_ID__c = 999999;
        q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
        string id='';
        try{
        insert q;
        id=q.id;
        }catch (Exception ex){
            System.debug('Exception is:'+ex);
        }
        
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Code__c = '';
        qd.Model__c = 'foo';
        Quote__c q2=[select id from quote__c limit 1];
        qd.Quote__c = q2.id;
        try{
        insert qd;
        }catch(Exception ex){}
        EditQuoteController eqc = new EditQuoteController( new Apexpages.Standardcontroller(q));
        eqc.getUserID();

		try {
	        NewQuoteController nqc = new NewQuoteController( new Apexpages.Standardcontroller(q));
            nqc.getServeraddress();
	        nqc.getOpportunityID();
            nqc.getOpportunity();
	        nqc.getUserID();
		} catch( exception ex ){}

	try {
	    EmailTaskCaller.SendQuoteEmail( q.Id, 123, 'test', 'test'); 
	} catch ( Exception ex ) {}


        TestController tc = new TestController();
		try {
	        //test deletes
	        delete otms;
		}  catch( Exception ex ) {}

        delete conts;
        delete accs;
        
        delete opps2;
        
   test.stopTest(); }

}