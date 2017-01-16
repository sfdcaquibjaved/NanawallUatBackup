@isTest(SeeAllData=false)
public with sharing class StdObjTests {
    
    
    static  void RunTests () {   
        
        User u = [SELECT id from User WHERE isactive = true LIMIT 1];       
        Account acc = [SELECT id FROM Account LIMIT 1 ]; 
        
        
        Test.Starttest();
        //insert new objects
        List<Account> accs = new List<Account>();
        Integer i;
        for( i = 0; i < 5; i++ )
        {
            Account a = new Account();
            a.Phone = '(123) 456-7890';
            a.Name = 'Test account';
            a.BillingCountryCode = 'US';
            a.BillingPostalCode = '08691';
//            a.Zip__c = '08619';
            accs.add(a);
        }       
        insert accs;

        accs[0].SyncInProgress__c = true;
        update accs[0];

        List<Contact> conts = new List<Contact>();
        for( i = 0; i < 5; i++ )
        {
            Contact c = new Contact();
            c.FirstName = 'TestFirst';
            c.LastName = 'TestLast';
            c.MailingCountryCode = 'US';
            //c.Zip__c = '08619';
            c.MailingPostalCode = '08619';
            
            conts.add(c);
        }       
        insert conts;
 
		

        List<Opportunity> opps = new List<Opportunity>();
        for( i = 0; i < 5; i++ )
        {
            Opportunity o = new Opportunity();
            o.Name = 'test opp';
            o.StageName = 'test stage';
            o.CloseDate = Date.today();
            o.Country__c = 'United States';
            o.Postal_Code__c = '08619';
            opps.add( o );  
        }       
        insert opps; 

        try
        {
//            WebServiceCaller.CallOpportunityWebService(opps[0].id, false);
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
 
        for( Opportunity o : opps )
        {
            o.Name = 'test opp - updated';
            o.StageName = 'test stage - updated';
            o.CloseDate = Date.today();
        }       
        try{
        update opps;
        }
        catch (Exception ex){}

        Lead l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        l.PostalCode = '08619';
        l.CountryCode = 'US';
        insert l;
        
        l.FirstName = 'testfirst - updated';
        
        l.Address_1__c  = '123 street';
        l.Address_2__c = 'another one';
        //l.nrCity__c = 'a city';
        //l.State__c = 'nj';
        //l.nrCountry__c = 'United States';
        l.LeadSource = 'somewhere';
        l.Interest__c = 'yes';      

        update l;


 
        Account convertacc = new Account();
        convertacc.Phone = '(123) 456-7890';
        convertacc.Name = 'Test account';
        convertacc.Country__c = 'United States'; 
        convertacc.Zip__c = '08619';        
        convertacc.BillingCountryCode = 'US';
        convertacc.BillingPostalCode = '08691';
        
        insert convertacc;
      
        LeadConvertController lcc = new LeadConvertController( new Apexpages.Standardcontroller(l) );
        lcc.setCreateNewOpp(true);
        lcc.setNewAccName('test account');
        lcc.setNewOppName('test opp');
        lcc.setUseExistingAccount('new');
        //actually generate the lead-convert        
        lcc.ConvertLead(convertacc.Id); 
//      update l;
        
        
        
        lcc.setTaskSubject('test');
        lcc.getTaskSubject();
        Task t = new Task();
        lcc.setTask(t);
        lcc.getTask();
        
        
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
//      lcc.HandlePostConversion();

//test another sort of lead conversion
        l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        l.Zip__c = '08619';
        l.PostalCode = '08619';
//      l.OwnerId = u.Id;
        insert l;

        lcc = new LeadConvertController( new Apexpages.Standardcontroller(l) );
        lcc.setCreateNewOpp(true);
        lcc.setNewOppName('test opp');
        lcc.setUseExistingAccount('new');
        //actually generate the lead-convert        
        lcc.ConvertLead(convertacc.Id); 
    
/*      */
        //test a different sort of lead conversion 
        l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
//        l.Zip__c = '08619';
        l.CountryCode = 'US';
        l.PostalCode = '08619';
//      l.OwnerId = u.Id;
        insert l;

        lcc = new LeadConvertController( new Apexpages.Standardcontroller(l) );
        lcc.setCreateNewOpp(true);
        lcc.setNewOppName('test opp');
        lcc.getContactLookup().AccountId = acc.Id;
        lcc.setUseExistingAccount('existing');

        //actually generate the lead-convert        
        lcc.ConvertLead(convertacc.Id); 
/* */       

        delete accs;
        delete conts;
        delete opps;
         //Test.StopTest();
        
        Account one = new Account();
        one.Name = 'test';
        one.Zip__c = '08619';
        one.Country__c = 'United States';
        one.BillingCountryCode = 'US';
        one.BillingPostalCode = '08691';        
        insert one;
        
        
        Campaign five = new Campaign();
        five.Name = 'test';
        insert five;
        
        
        Case seven = new Case();
        insert seven;
        
        
        Contact nine = new Contact();
        nine.SyncInProgress__c = false;
        nine.FirstName = 'foo';
        nine.LastName = 'bar';
        nine.MailingStreet = 'street';
        nine.MailingCity = 'city'; 
        nine.mailingstate = 'Utah';
        nine.MailingPostalCode = '08619';
        nine.MailingCountryCode = 'US';
//        nine.Zip__c = '08619';
        
        insert nine;
 
        CaseContactRole eight = new CaseContactRole();
        eight.CasesId = seven.id;
        eight.ContactId = nine.id;
        insert eight;

        CampaignMember six = new CampaignMember();
        six.CampaignId = five.id;
        six.ContactId = nine.id;
        insert six;

        AccountContactRole two = new AccountContactRole();
        two.AccountId = one.id;
        two.ContactId = nine.Id;
        insert two;

        Contract ten = new Contract();
        ten.AccountId = one.Id;
        insert ten;
        
        ContractContactRole eleven = new ContractContactRole();
        eleven.ContractId = ten.id;
        eleven.ContactId = nine.id;
        insert eleven;
        
        Event twelve = new Event();
        twelve.DurationInMinutes = 5;
        twelve.ActivityDate = Date.today();
        twelve.ActivityDateTime = Datetime.now(); 
        insert twelve;
    Test.StopTest();    
     // Test.Starttest();  
        l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        //l.Zip__c = '08619';
        l.PostalCode = '08619';
        l.CountryCode = 'US';
        insert l;

try {
         lcc = new LeadConvertController( new Apexpages.Standardcontroller(l) );
        lcc.setCreateNewOpp(true);
        lcc.setNewOppName('test opp');
        lcc.setUseExistingAccount('new');
        //actually generate the lead-convert        
        lcc.ConvertLead(convertacc.Id); 
} catch(exception ex) {} 
        
        Opportunity fifteen = new Opportunity();
        fifteen.Name = 'test name';
        fifteen.StageName = 'test';
        fifteen.CloseDate = date.today();
        fifteen.Country__c = 'United States';
        fifteen.Postal_Code__c = '08619';
        insert fifteen;
        
        OpportunityContactRole sixteen = new OpportunityContactRole();
        sixteen.ContactId = nine.id;
        sixteen.OpportunityId = fifteen.id;
        insert sixteen;


Pricebook2 pbe2 = new Pricebook2();
pbe2.Name = 'test';
insert pbe2;

Product2 p2  = new Product2();
p2.Name = 'test';
insert p2;

         
        Solution twentyone = new Solution();
        twentyone.SolutionName = 'test';
        insert twentyone;
        
        try{
        Task twentytwo = new Task();
        insert twentytwo;
        }
        catch (Exception ex)
        {}
        

        
        try
        
        {
            ContactHomeController chc = new ContactHomeController();
            chc.getTerritories();
            chc.getTools();
            chc.AccountName = '';
            String ts = chc.AccountName;
            chc.Address = '';
            ts=chc.Address;
            chc.Address2 = '';
            ts=chc.Address2;
            chc.Competitor = true;
            boolean b = chc.Competitor;
            chc.Country='';
            ts=chc.Country;
            chc.CreateDateMax = '';
            ts = chc.CreateDateMax;
            chc.Description='';
            ts=chc.Description;
            chc.doSort();
            chc.LeadSource='';
            ts=chc.LeadSource;
            chc.LeadType='';
            ts=chc.LeadType;
            chc.State='';
            ts=chc.State;
            chc.sortField=''; 
            ts=chc.sortField;
            //chc.previousSortField();
        //  chc.sortexp();
            chc.City='';
            ts=chc.City;
            chc.Zip='';
            ts=chc.Zip;
            chc.FirstName='';
            ts=chc.FirstName;
            chc.LastName='';
            ts=chc.LastName;
            chc.Phone='';
            ts=chc.Phone;
            chc.Email='';
            ts=chc.Email;
            chc.AccountName='';
            ts=chc.AccountName;
            chc.Interest='';
            ts=chc.Interest;
            chc.RegNumber='';
            ts=chc.RegNumber;
            chc.PhoneExt='';
            ts=chc.PhoneExt;
            chc.getDummyContact();
            chc.primeSearch();
            ApexPages.StandardSetController myc = chc.mycontroller;
            chc.myaction();
            chc.GetQuery(true);
            
        }
        catch (Exception ex)
        {
            
        }       

//Test.StopTest();           
    }
}