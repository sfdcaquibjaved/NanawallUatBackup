@isTest
public class testServiceQuotecreationController {
    static testmethod void createmethod1() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;
        
         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
        insert con;

        Contact con1 = new Contact();
        //con.SyncInProgress__c = false;
        con1.FirstName = 'foo';
        con1.LastName = 'bar';
        con1.MailingStreet = 'street';
        con1.MailingCity = 'city';
        con1.MailingstateCode = 'CA';
        con1.MailingPostalCode = '08619';
        con1.MailingCountryCode = 'US';
        insert con1;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;

        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'Other';
        cc.UseAddressShipping = 'Other';
        cc.contactCreateOption = 'New Contact';
        cc.accountCreateOption = 'Attach To Existing Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();

        cc.contactId = con.id;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        //cc.CustomServiceQuote();
        test.stopTest();

    }

    static testmethod void createmethod2() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;
        
         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
        insert con;

        Contact con1 = new Contact();
        //con.SyncInProgress__c = false;
        con1.FirstName = 'foo';
        con1.LastName = 'bar';
        con1.MailingStreet = 'street';
        con1.MailingCity = 'city';
        con1.MailingstateCode = 'CA';
        con1.MailingPostalCode = '08619';
        con1.MailingCountryCode = 'US';
        insert con1;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = '-SELECT-';
        cc.UseAddressShipping = '-SELECT-';
        cc.contactCreateOption = 'New Contact';
        cc.accountCreateOption = 'Attach To Existing Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        //cc.CustomServiceQuote();
        test.stopTest();

    }
    static testmethod void createmethod3() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

        statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;

        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'cont';
        cc.UseAddressShipping = 'cont';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        try {
            cc.ShopifyServiceQuote();
        } catch (Exception e) {}
        //cc.CustomServiceQuote();
        test.stopTest();

    }
    static testmethod void createmethod4() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;
        
         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;



        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'projectDummy';
        cc.UseAddressShipping = 'projectDummy';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.updateAddressNew();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.checkAccMate = true;
        cc.Acct = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        try{
        cc.CustomServiceQuote();
        }catch(Exception e){}
        test.stopTest();

    }
    static testmethod void createmethod5() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;
        
         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
        con.Accountid = a.id;

        insert con;

        Contact con1 = new Contact();
        //con.SyncInProgress__c = false;
        con1.FirstName = 'foo';
        con1.LastName = 'bar';
        con1.MailingStreet = 'street';
        con1.MailingCity = 'city';
        con1.MailingstateCode = 'CA';
        con1.MailingPostalCode = '08619';
        con1.MailingCountryCode = 'US';
        insert con1;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Contact__c = con.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        /* ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'cont';
        cc.UseAddressShipping = 'cont';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.AccountId = a.id;
        System.currentPageReference().getParameters().put('contactId', con.id);
        System.currentPageReference().getParameters().put('AccountId', a.id);
        cc.acc = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        cc.syncContact();
        cc.syncAccount();
        //cc.ShopifyServiceQuote();
        //cc.CustomServiceQuote();
        test.stopTest();

    }
    static testmethod void createmethod6() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'cont';
        cc.UseAddressShipping = 'cont';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.updateAddressNew();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
        cc.checkAccMate = true;
        cc.Acct = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        try{
        cc.CustomServiceQuote();
        }catch(Exception e){}
        test.stopTest();
    }
    static testmethod void createmethod7() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'other';
        cc.UseAddressShipping = 'other';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.updateAddressNew();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
        cc.checkAccMate = true;
        cc.Acct = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        try{
        cc.CustomServiceQuote();
        }
        catch(Exception e){}
        test.stopTest();
    }
    static testmethod void createmethod8() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;



        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.email = 'ab@absyz.com';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        /* ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        
        cc.UseAddress = '-SELECT-';
        cc.UseAddressShipping = '-SELECT-';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.updateAddressNew();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
        cc.checkAccMate = true;
        cc.Acct = a;
        cc.validateButtons();
        cc.validateZip('12345', 'US');
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        try{
        cc.CustomServiceQuote();
        }
        catch(Exception e){}
        test.stopTest();
    }
    static testmethod void createmethod9() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'cont';
        cc.UseAddressShipping = 'cont';
        cc.contactCreateOption = 'New Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.checkAccMate = true;
        cc.Acct = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        try {
            cc.ShopifyServiceQuote();
        } catch (Exception e) {}
        //cc.CustomServiceQuote();
        test.stopTest();

    }
    static testmethod void createmethod10() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

        statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /* order ord = new order();
             ord.Status = 'draft';
             ord.EffectiveDate = system.today();
             ord.Accountid = a.id;
            insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'cont';
        cc.UseAddressShipping = 'cont';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.checkAccMate = true;
        cc.Acct = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        try {
            cc.ShopifyServiceQuote();
        } catch (Exception e) {}
        //cc.CustomServiceQuote();
        test.stopTest();

    }
    static testmethod void createmethod11() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

        statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'projectDummy';
        cc.UseAddressShipping = 'projectDummy';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
        cc.checkAccMate = true;
        cc.Acct = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        try {
            cc.ShopifyServiceQuote();
        } catch (Exception e) {}
        //cc.CustomServiceQuote();
        test.stopTest();

    }
    static testmethod void createmethod12() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;

        
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'Other';
        cc.UseAddressShipping = 'Other';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
        cc.checkAccMate = true;
        cc.Acct = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        try {
            cc.ShopifyServiceQuote();
        } catch (Exception e) {}
        //cc.CustomServiceQuote();
        test.stopTest();

    }
    static testmethod void createmethod13() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'California';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'cont';
        cc.UseAddressShipping = 'cont';
        cc.contactCreateOption = 'New Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
        cc.checkAccMate = true;
        cc.Acct = a;
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        try {
            cc.CustomServiceQuote();
        } catch (Exception e) {}

        test.stopTest();

    }
    static testmethod void createmethod14() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

        statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'California';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.Email = 'aditya.moro@absyz.com';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = 'cont';
        cc.UseAddressShipping = 'cont';
        cc.contactCreateOption = 'New Contact';
        cc.accountCreateOption = 'Attach to Existing Account';
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();

        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
cc.validateButtons();
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        try {
            cc.CustomServiceQuote();
        } catch (Exception e) {}
        test.stopTest();

    }
    static testmethod void createmethod15() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

         statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'California';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.UseAddress = '-SELECT-';
        cc.UseAddressShipping = '-SELECT-';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
        cc.initializeAccountCreateOption();
        
        cc.initializeContactCreateOption();
        cc.setaddress();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
        cc.checkAccMate = true;
        cc.Acct = a;
        Boolean v = cc.validateButtons();
        System.debug('Boolean'+v);
        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        try {
            cc.ShopifyServiceQuote();
        } catch (Exception e) {}
        //cc.CustomServiceQuote();
        test.stopTest();

    }
    static testmethod void createmethod16() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

        statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'California';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.email = 'ab@absyz.com';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.initializeAccountCreateOption();

        cc.initializeContactCreateOption();
        cc.UseAddress = '-SELECT-';
        cc.UseAddressShipping = '-SELECT-';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
       

        cc.setaddress();
        cc.updateAddressNew();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
        cc.checkAccMate = true;
        cc.Acct = a;
        cc.validateButtons();
        cc.validateZip('12345', 'US');

        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        try {
            cc.CustomServiceQuote();
        } catch (Exception e) {}
        test.stopTest();

    }
    
    static testmethod void createmethod17() {
        list < Zip_Codes_Master__c > tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;

        Country_codes__c couCode1 = new Country_codes__c();
        couCode1.Name = 'US';
        couCode1.Country__c = 'United States';
        insert couCode1;

        statecodes__c statcode2 = new statecodes__c();
        statCode2.Name = 'CA';
        statCode2.State__c = 'California';
        insert statcode2;


        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'California';
        a.BillingCountryCode = 'US';
        a.BillingPostalCode = '12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        insert a;

        Contact con = new Contact();
        //con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.email = 'ab@absyz.com';
        insert con;


        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        insert o;

        Project__c p1 = new Project__c();
        // p1.recordtypeId='012K0000000DKP0IAO';
        p1.Name = 'Test Project CompetitorHelper_Test';
        p1.Application__c = 'Automotive';
        p1.Application_2__c = 'Dealership';
        p1.Project_Zip_Code__c = '94040';
        insert p1;

        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = o.Id;
        q.Primary_Quote__c = True;
        q.Project__c = p1.id;
        insert q;

        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;

        insert qd;



        /*order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.Accountid = a.id;
           insert ord;*/

        Entitlement Entitle = new Entitlement();
        Entitle.nAME = qd.Name + ' ' + qd.Model__c;
        //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
        Entitle.accountid = a.id;
        Entitle.Contacts__c = qd.Quote__r.Contact__c;
        Entitle.Nana_Quote__c = qd.Quote__c;
        Entitle.Quote_Detail__c = qd.id;
        Entitle.StartDate = qd.Quote__r.Balanced_Received_Date__c;
        Entitle.SlaProcessId = system.Label.Sla_Process;
        insert Entitle;

        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        //c.Send_Quote_To__c = 'End Customer';
        //c.Ship_To__c = 'End Customer';
        //c.Bill_To__c = 'End Customer'; 
        c.subject = 'Test';
        c.Description = 'Test Description';
        c.ProjectName__c = p1.id;
        c.ContactID = con.id;
        c.AccountId = a.id;
        c.quote__c = q.id;
        insert c;


        test.startTest();
        PageReference pageRef = Page.ServiceQuoteCreationPage; // Add your VF page Name here
        // pageRef.getParameters().put('contactId',(con1.Id));
        pageRef.getParameters().put('CaseId', string.valueof(c.Id));
        Test.setCurrentPage(pageRef);
        ServiceQuotecreationController cc = new ServiceQuotecreationController();
        cc.initializeAccountCreateOption();
        cc.initializeContactCreateOption();

        cc.UseAddress = '-SELECT-';
        cc.UseAddressShipping = '-SELECT-';
        cc.contactCreateOption = 'Existing Contact';
        cc.accountCreateOption = 'New Account';
       

        cc.setaddress();
        cc.updateAddressNew();
        cc.setaddressshipping();
        cc.contactId = con.id;
        cc.acc = a;
        cc.con = con;
        cc.checkAccMate = true;
        cc.Acct = a;
        cc.validateButtons();
        cc.validateZip('12345', 'US');

        List < SelectOption > getco = cc.getContactOption();
        List < SelectOption > getac = cc.getAccountOption();
        //cc.syncContact();
        //cc.ShopifyServiceQuote();
        try {
            cc.ShopifyServiceQuote();
        } catch (Exception e) {}
        test.stopTest();

    }
       
    
}