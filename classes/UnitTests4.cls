@isTest(SeeAllData=false)

public with sharing class UnitTests4 {

    @isTest(SeeAllData=false)
    static  void RunObjectTests () {
        
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        Account one = new Account();
        one.Name = 'test';
        one.Country__c = 'USA';
        one.Zip__c = '08619';
        one.BillingState = 'New York';
        one.BillingCountry='United States';
        one.BillingPostalCode='12345';
        insert one;
         
        Campaign five = new Campaign();
        five.Name = 'test';
        insert five;
        
        
        
        Contact nine = new Contact();
        nine.SyncInProgress__c = false;
        nine.FirstName = 'foo';
        nine.LastName = 'bar';
        nine.MailingStreet = 'street';
        nine.MailingCity = 'city'; 
        nine.Mailingstate = 'Utah';
        nine.MailingPostalCode = '12345';
        nine.MailingCountryCode = 'US';
//        nine.Zip__c = 'TEST';
//        nine.Country__c = 'USA';        
        insert nine;
        
        Case seven = new Case();
        seven.Contact=nine;
        seven.Description='test';
        //seven.ClosedDate=date.today();
        insert seven;

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
        
        Lead l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        l.PostalCode = '12345';
        l.CountryCode = 'US';
//        l.Zip__c = 'TEST';
//        l.nrCountry__c = 'USA';
        
        insert l;

        try {
        
            Account convertacc = new Account();
            convertacc.Phone = '(123) 456-7890';
            convertacc.Name = 'Test account';
            convertacc.Country__c = 'USA';
            convertacc.Zip__c = '12345';        
            insert convertacc;
        /*
            LeadConvertController lcc = new LeadConvertController( new Apexpages.Standardcontroller(l) );
            lcc.setCreateNewOpp(true);
            lcc.setNewOppName('test opp');
            lcc.setUseExistingAccount('new');
            //actually generate the lead-convert        
            lcc.ConvertLead(convertacc.id); */ 
        } catch(exception ex) {
        
        Opportunity fifteen = new Opportunity();
        fifteen.Name = 'test name';
        fifteen.StageName = 'test';
        fifteen.CloseDate = date.today();
        fifteen.Country__c = 'USA';
        fifteen.Postal_Code__c = 'TEST';
        fifteen.description='test';
        fifteen.Review_Code__c='4-dead';
        fifteen.Residential_Vertical__c=true;
        fifteen.NIS__c=true;
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
        
        Task twentytwo = new Task();
        insert twentytwo;
        
        
        try{

            LeadHomeController lhc = new LeadHomeController();
            
            lhc.next();
            lhc.previous();
            boolean a2 = lhc.hasprevious;
            boolean b2 = lhc.hasnext;
            lhc.myaction();
            lhc.getLeadTypes();
            lhc.getLeadInterests();
            lhc.getLeadSources();
            lhc.gotonew();
            //ahc.viewaccount();
            lhc.getcountries();
            lhc.getstates();
            lhc.getTools();
            
            //string name=lhc.name;
            string firstname=lhc.firstname;
            lhc.firstname='a';
            string lastname=lhc.lastname;
            lhc.lastname='j';
            string city=lhc.city;
            lhc.city='a';
            string lhc_country=lhc.country;
            lhc.country='a';
            string lhc_address=lhc.address;
            lhc.address='a';
            string lhc_zip=lhc.zip;
            lhc.zip='a';
            string lhc_state=lhc.state;
            lhc.state='a';
            string lhc_country2=lhc.country;
            lhc.country = 'a';
            string lhc_email=lhc.email;
            lhc.email='a';
            string lhc_phone=lhc.phone;
            lhc.phone='a';
            string lhc_Company=lhc.company;
            lhc.company='a';
            string lhc_Interest=lhc.Interest;
            lhc.Interest='a';
           string lhc_LeadType=lhc.LeadType;
            lhc.LeadType='other'; 
            string lhc_LeadSource=lhc.LeadSource;
            lhc.LeadSource='other';
            string lhc_RegNumber=lhc.RegNumber;
            lhc.RegNumber='a2';
            
            lhc.dosort();
            lhc.getquery();
            string lhc_t = lhc.total;
            lhc.total='';
            lhc.getmyleads();
            lhc.previoussortfield='asc';
            lhc.sortfield='asc';
            lhc.dosort();
            
        }
        catch (exception exx){}
        
        try{

            QuoteHomeController chc = new QuoteHomeController();
            
            chc.next();
            chc.previous();
            boolean qhc_a = chc.hasprevious;
            boolean qhc_b = chc.hasnext;
            chc.myaction();
            //chc.gotonew();
            //ahc.viewaccount();
            chc.getcountries();
            chc.getstates();
            //string name=lhc.name;
            string qhc_address= chc.Address;
            chc.Address = 'a';
            string qhc_city = chc.City;
            chc.City = 'a';
            string qhc_State = chc.State;
            chc.State = 'a';
            string qhc_Name = chc.Name;
            chc.Name = 'a';
            string qhc_Zip = chc.Zip;
            chc.Zip = '12345';
            
            string qhc_OrderNumber = chc.OrderNumber;
            chc.OrderNumber= 'a';
            chc.dosort();
            chc.getmyquotes();
            chc.previoussortfield='asc';
            chc.sortfield='asc';
            
        } 
        catch (exception e){}
        
        
//        try{
            list<string> s= new list<string>{'Test', 'test2'};
           
        
        OpportunityHomeController chc = new OpportunityHomeController();
        chc.setSelectedTerritory('AUS');
        chc.getTerritories();
        chc.next();
        chc.previous();
        chc.reset();
        chc.getDummyOpportunity();
        chc.setDummyOpportunity(fifteen);
        boolean ohc_a = chc.hasprevious;
        boolean ohc_b = chc.hasnext;
        
        
        chc.getcountries();
        chc.getstates();
        
        string ohc_address= chc.Address;
        chc.Address = 'a';
        string ohc_city = chc.City;
        chc.City = 'a';
        string ohc_state = chc.State;
        chc.State = 'a';
        string ohc_zip = chc.Zip;
        chc.Zip ='a';

//        chc.getmyOpportunitys();
        chc.previoussortfield='asc';
        chc.sortfield='asc';
        chc.dosort();
        string ohc_ah = chc.AmountHigh;
        chc.AmountHigh='a';
        string ohc_al = chc.AmountLow;
        chc.AmountLow='a';
        string ohc_ap =chc.Application;
        chc.Application = 'a';
        boolean ohc_c =chc.ChainAccount;
        chc.ChainAccount = true;
        string ohc_co = chc.Country;
        chc.Country = 'a';
        chc.getApplications();
        chc.getStages();
        string ohc_n =chc.Name;
        chc.Name='a';
        boolean ohc_ord =chc.Ordered;
        chc.Ordered=true;
        string ohc_st= chc.Stage;
        chc.Stage='a';
        string ohc_to = chc.Total;
        chc.Total='a';
        chc.myaction();
        chc.primeSearch();
//        }  catch (exception ex){}
        
        Quote__c q= new Quote__c();
            try{
        EditQuoteController eqc = new EditQuoteController(new ApexPages.StandardController(q));
         eqc.getUserID();
            }catch(Exception e2){}

        Showroom__c sr = new Showroom__c();
        insert(sr);

        try
        {
            Quote__c qt = [select id,contact__c from quote__c where id = 'a0AA0000001Gdoi'];
            Task t= new Task();
            t.whatid = qt.id;
            t.whoid = qt.contact__c;
            t.subject='PDF';
            insert(t);
            Utility.TaskScoring(null, null, null, null) ;
            
        }
        catch (Exception exxx)
        {}
     
        Quote__c quoteforcase= new Quote__c();
        quoteforcase.Opportunity__c = fifteen.Id;
        insert quoteforcase;
        list<case> ca= new list<case>();
        Case c = new Case();
        c.Status = 'test';
        c.Origin = 'Email';
        c.Type = 'Other';
        c.Quote__c = quoteforcase.Id;
        c.ContactId=nine.id;
        c.Description='test';
        //c.ClosedDate=date.today();
            ca.add(c);
        insert ca[0];
            
            Case c2 = new Case();
        c2.Status = 'test';
        c2.Origin = 'Email';
        c2.Type = 'Other';
        c2.Quote__c = quoteforcase.Id;
        c2.ContactId=nine.id;
        c2.Description='test';
        //c2.ClosedDate=date.today();
            ca.add(c2);
            insert ca[1];
     
        Service_Quote__c sq = new Service_Quote__c();
        sq.Case__c = c.id;
        insert sq;
        
        
        Quote_Case_Related_List_Controller qcrlc = new Quote_Case_Related_List_Controller( new ApexPages.StandardController(quoteforcase) );
        qcrlc.BaseUrl = '';
        qcrlc.CloseID = '';
        qcrlc.getCases();
        
        Quote_CaseComment_Controller qccc = new Quote_CaseComment_Controller( new ApexPages.StandardController(quoteforcase) );
        qccc.BaseUrl = '';
        qccc.CloseID = '';
       
        qccc.getCases2();
        qccc.getCases();
        
        }
        
    }
}