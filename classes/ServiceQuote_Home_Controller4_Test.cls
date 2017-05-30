@isTest(seeAllData = false)
public class ServiceQuote_Home_Controller4_Test {
    
    public static testMethod void projectDetail() {
        test.startTest();
        Manufacturer_OrderNb__c mo = new Manufacturer_OrderNb__c();
        mo.Name = 'Richmond';
        //mo.LatestNumber__c = 40200;
        mo.LatestOrderNumber__c='40209';
        insert mo;
        
        Manufacturer_OrderNb__c mo1 = new Manufacturer_OrderNb__c();
        mo1.Name = 'Solarlux';
        //mo1.LatestNumber__c = 20001;
        mo1.LatestOrderNumber__c='20017';
        insert mo1;
        
        Manufacturer_OrderNb__c mo2 = new Manufacturer_OrderNb__c();
        mo2.Name = 'Teuffel';
        //mo2.LatestNumber__c = 75400;
        mo2.LatestOrderNumber__c='75401';
        insert mo2;
        
        Manufacturer_OrderNb__c mo3 = new Manufacturer_OrderNb__c();
        mo3.Name = 'Wizard';
        //mo3.LatestNumber__c = 97000;
        mo3.LatestOrderNumber__c='97001';
        insert mo3;
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = new Project__c();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co=new contact();
         co.Accountid = acct.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
         insert co;

         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
         Quote__c q = new Quote__c();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;
         
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
         c.Order__c = ord.id;        
        
        insert c;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        
        
         Service_Quote__c sq=new Service_Quote__c();
         sq.Case__c=c.Id;
         sq.Complaint__c=false;
         insert sq;
        
         Quote_Detail__c qd=new Quote_Detail__c();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         insert qd;
            
         ServiceQuote_Home_Controller4 controller1 = new ServiceQuote_Home_Controller4();
         controller1.dosort();
         controller1.getCountry();
         controller1.getModelOptions();
         controller1.getOldModelsChecked();
         controller1.getOldModelsToggleValue();
         controller1.getStates();
        
         controller1.SearchFields.state = 'new york';
         controller1.SearchFields.Zip = '12345';
         controller1.SearchFields.City='test';
         controller1.SearchFields.ProjectCountry='test';
         controller1.SearchFields.Email='test@test.com';
         controller1.SearchFields.OrderNumber='test';
         controller1.SearchFields.ProjectStreet='test';
         controller1.SearchFields.phone='123456';
         controller1.SearchFields.LastName='test';
         controller1.SearchFields.FirstName='test';
         controller1.SearchFields.OrderNumber = '0';
         controller1.SearchFields.Panels_Count = '3';
         controller1.SearchFields.Panels_Left = '4';
         controller1.SearchFields.Panels_Right = '1';
         controller1.models='HSW 60';
         controller1.SearchFields.ContactName='test';
         controller1.SearchFields.ProjectName='test';    
         controller1.SearchObjects();
        
         ServiceQuote_Home_Controller4.SearchContainer wrapcontroller=new ServiceQuote_Home_Controller4.SearchContainer();
         wrapcontroller.ProjectName='test';
         wrapcontroller.ProjectAddress='test';
         wrapcontroller.ContactName='test';
         wrapcontroller.LastName='test';
         wrapcontroller.FirstName='test';
         wrapcontroller.Address='test';
         wrapcontroller.City='test';
         wrapcontroller.ProjectStreet='test';
         wrapcontroller.ProjectCountry='test';
         wrapcontroller.state='test';
         wrapcontroller.Zip='test';
         wrapcontroller.Phone='test';
         wrapcontroller.Email='test';
         wrapcontroller.Panels_Left='test';
         wrapcontroller.Panels_Right='test';
         wrapcontroller.Panels_Count='test';
         wrapcontroller.ServiceQuoteNumber='test';
         wrapcontroller.CaseNumber='test';
         wrapcontroller.QuoteNumber='test';
         wrapcontroller.OrderNumber='test';
         wrapcontroller.HiGrandTotal='test';
         wrapcontroller.LoServiceQuoteAmount='test';
         wrapcontroller.HiServiceQuoteAmount='test';
               
         ServiceQuote_Home_Controller4.ServiceQuoteSearchResult  sqsResult = new ServiceQuote_Home_Controller4.ServiceQuoteSearchResult();
         sqsResult.QuoteID  = 'test';// { get; set; }
         sqsResult.OrderID  = 'test';// { get; set; } { get; set; }
         sqsResult.City  = 'test';// { get; set; } { get; set; }
         sqsResult.State  = 'test';// { get; set; } { get; set; }
         sqsResult.Zip   = 'test';// { get; set; }{ get; set; }
         sqsResult.ContactName  = 'test';// { get; set; } { get; set; }
         sqsResult.LastName = 'test';
         sqsResult.FirstName = 'test';
         sqsResult.ContactEmail = 'test';
         sqsResult.Phone = 'test';    
         sqsResult.CaseId = 'test';
         sqsResult.ProjectStreet = 'test';
         sqsResult.ProjectCountry  = 'test';   
         sqsResult.CaseNumber = 'test';
         sqsResult.PanelCount = 'test';
         sqsResult.orderNumber = 'test';    
         sqsResult.Selected=true;
         sqsResult.ProjectName  = 'test';// { get; set; } { get; set; }
         sqsResult.ProjectAddress  = 'test';// { get; set; } { get; set; }
         sqsResult.ProjectID   = 'test';// { get; set; }{ get; set; }
         sqsResult.QuoteNumber  = 'test';// { get; set; }{ get; set; }
         sqsResult.origin  = 'test';// { get; set; } { get; set; }
                
         ServiceQuote_Home_Controller4.ServiceQuoteEntry entry = new ServiceQuote_Home_Controller4.ServiceQuoteEntry();
         entry.ID = 'test';
         entry.ServiceQuoteNumber = 'test';  
         test.stopTest();
        
    }
    
    
    
     public static testMethod void projectDetail1() {
         test.startTest();
        Manufacturer_OrderNb__c mo = new Manufacturer_OrderNb__c();
        mo.Name = 'Richmond';
        //mo.LatestNumber__c = 40200;
        mo.LatestOrderNumber__c='40209';
        insert mo;
        
        Manufacturer_OrderNb__c mo1 = new Manufacturer_OrderNb__c();
        mo1.Name = 'Solarlux';
        //mo1.LatestNumber__c = 20001;
        mo1.LatestOrderNumber__c='20017';
        insert mo1;
        
        Manufacturer_OrderNb__c mo2 = new Manufacturer_OrderNb__c();
        mo2.Name = 'Teuffel';
        //mo2.LatestNumber__c = 75400;
        mo2.LatestOrderNumber__c='75401';
        insert mo2;
        
        Manufacturer_OrderNb__c mo3 = new Manufacturer_OrderNb__c();
        mo3.Name = 'Wizard';
        //mo3.LatestNumber__c = 97000;
        mo3.LatestOrderNumber__c='97001';
        insert mo3;
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = new Project__c();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co=new contact();
         co.Accountid = acct.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
         insert co;

         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
         Quote__c q = new Quote__c();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;
         
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
         c.Order__c = ord.id;        
        
        insert c;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        
        
         Service_Quote__c sq=new Service_Quote__c();
         sq.Case__c=c.Id;
         sq.Complaint__c=false;
         insert sq;
        
         Quote_Detail__c qd=new Quote_Detail__c();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         insert qd;
         
        
         ServiceQuote_Home_Controller4 controller1 = new ServiceQuote_Home_Controller4();
         controller1.dosort();
         controller1.getCountry();
         controller1.getModelOptions();
         controller1.getOldModelsChecked();
         controller1.getOldModelsToggleValue();
         controller1.getStates();        
         controller1.SearchFields.CaseNumber = 'test';
         controller1.SearchFields.Zip='12345';
         controller1.SearchFields.state= 'test';
         controller1.SearchFields.ProjectCountry= 'test';
         controller1.SearchFields.City= 'test';
         controller1.SearchFields.ProjectStreet= 'test';
         controller1.SearchFields.Email='abc@abc.com';
         controller1.SearchFields.Phone='12345';
         controller1.SearchFields.LastName='test';       
         controller1.SearchFields.FirstName='test';                
         controller1.SearchObjects();
                
         ServiceQuote_Home_Controller4.SearchContainer scontainer=new ServiceQuote_Home_Controller4.SearchContainer();
         scontainer.ProjectName='test';
         scontainer.ProjectAddress='test';
         scontainer.ContactName='test';
         scontainer.LastName='test';
         scontainer.FirstName='test';
         scontainer.Address='test';
         scontainer.City='test';
         scontainer.ProjectStreet='test';
         scontainer.ProjectCountry='test';
         scontainer.state='test';
         scontainer.Zip='test';
         scontainer.Phone='test';
         scontainer.Email='test';
         scontainer.Panels_Left='test';
         scontainer.Panels_Right='test';
         scontainer.Panels_Count='test';
         scontainer.ServiceQuoteNumber='test';
         scontainer.CaseNumber='test';
         scontainer.QuoteNumber='test';
         scontainer.OrderNumber='test';
         scontainer.HiGrandTotal='test';
         scontainer.LoServiceQuoteAmount='test';
         scontainer.HiServiceQuoteAmount='test';
        
        
         ServiceQuote_Home_Controller4.ServiceQuoteSearchResult  res = new ServiceQuote_Home_Controller4.ServiceQuoteSearchResult();
         res.QuoteID  = 'test';// { get; set; }
         res.OrderID  = 'test';// { get; set; } { get; set; }
         res.City  = 'test';// { get; set; } { get; set; }
         res.State  = 'test';// { get; set; } { get; set; }
         res.Zip   = 'test';// { get; set; }{ get; set; }
         res.ContactName  = 'test';// { get; set; } { get; set; }
         res.LastName = 'test';
         res.FirstName = 'test';
         res.ContactEmail = 'test';
         res.Phone = 'test';    
         res.CaseId = 'test';
         res.ProjectStreet = 'test';
         res.ProjectCountry  = 'test';   
         res.CaseNumber = 'test';
         res.PanelCount = 'test';
         res.orderNumber = 'test';    
         res.Selected=true;
         res.ProjectName  = 'test';// { get; set; } { get; set; }
         res.ProjectAddress  = 'test';// { get; set; } { get; set; }
         res.ProjectID   = 'test';// { get; set; }{ get; set; }
         res.QuoteNumber  = 'test';// { get; set; }{ get; set; }
         res.origin  = 'test';// { get; set; } { get; set; }
        
        
         ServiceQuote_Home_Controller4.ServiceQuoteEntry entry = new ServiceQuote_Home_Controller4.ServiceQuoteEntry();
         entry.ID = 'test';
         entry.ServiceQuoteNumber = 'test';  
         test.stopTest();
        
    }
    
    
    public static testMethod void projectDetail2() {
        
          test.startTest();
        Manufacturer_OrderNb__c mo = new Manufacturer_OrderNb__c();
        mo.Name = 'Richmond';
        //mo.LatestNumber__c = 40200;
        mo.LatestOrderNumber__c='40209';
        insert mo;
        
        Manufacturer_OrderNb__c mo1 = new Manufacturer_OrderNb__c();
        mo1.Name = 'Solarlux';
        //mo1.LatestNumber__c = 20001;
        mo1.LatestOrderNumber__c='20017';
        insert mo1;
        
        Manufacturer_OrderNb__c mo2 = new Manufacturer_OrderNb__c();
        mo2.Name = 'Teuffel';
        //mo2.LatestNumber__c = 75400;
        mo2.LatestOrderNumber__c='75401';
        insert mo2;
        
        Manufacturer_OrderNb__c mo3 = new Manufacturer_OrderNb__c();
        mo3.Name = 'Wizard';
        //mo3.LatestNumber__c = 97000;
        mo3.LatestOrderNumber__c='97001';
        insert mo3;
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = new Project__c();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co=new contact();
         co.Accountid = acct.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
         insert co;

         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
         Quote__c q = new Quote__c();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;
         
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
         c.Order__c = ord.id;        
        
        insert c;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        
        
         Service_Quote__c sq=new Service_Quote__c();
         sq.Case__c=c.Id;
         sq.Complaint__c=false;
         insert sq;
        
         /*Quote_Detail__c qd=new Quote_Detail__c();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         insert qd;*/
        
         ServiceQuote_Home_Controller4 controller1 = new ServiceQuote_Home_Controller4();
         controller1.dosort();
         controller1.getCountry();
         controller1.getModelOptions();
         controller1.getOldModelsChecked();
         controller1.getOldModelsToggleValue();
         controller1.getStates();       
         controller1.SearchFields.zip='12345';               
         controller1.SearchObjects();
                
         ServiceQuote_Home_Controller4.SearchContainer scontainer=new ServiceQuote_Home_Controller4.SearchContainer();
         scontainer.ProjectName='test';
         scontainer.ProjectAddress='test';
         scontainer.ContactName='test';
         scontainer.LastName='test';
         scontainer.FirstName='test';
         scontainer.Address='test';
         scontainer.City='test';
         scontainer.ProjectStreet='test';
         scontainer.ProjectCountry='test';
         scontainer.state='test';
         scontainer.Zip='test';
         scontainer.Phone='test';
         scontainer.Email='test';
         scontainer.Panels_Left='test';
         scontainer.Panels_Right='test';
         scontainer.Panels_Count='test';
         scontainer.ServiceQuoteNumber='test';
         scontainer.CaseNumber='test';
         scontainer.QuoteNumber='test';
         scontainer.OrderNumber='test';
         scontainer.HiGrandTotal='test';
         scontainer.LoServiceQuoteAmount='test';
         scontainer.HiServiceQuoteAmount='test';
         scontainer.LoGrandTotal='test';
                
         ServiceQuote_Home_Controller4.ServiceQuoteSearchResult  res = new ServiceQuote_Home_Controller4.ServiceQuoteSearchResult();
         res.QuoteID  = 'test';// { get; set; }
         res.OrderID  = 'test';// { get; set; } { get; set; }
         res.City  = 'test';// { get; set; } { get; set; }
         res.State  = 'test';// { get; set; } { get; set; }
         res.Zip   = 'test';// { get; set; }{ get; set; }
         res.ContactName  = 'test';// { get; set; } { get; set; }
         res.LastName = 'test';
         res.FirstName = 'test';
         res.ContactEmail = 'test';
         res.Phone = 'test';    
         res.CaseId = 'test';
         res.ProjectStreet = 'test';
         res.ProjectCountry  = 'test';   
         res.CaseNumber = 'test';
         res.PanelCount = 'test';
         res.orderNumber = 'test';    
         res.Selected=true;
         res.ProjectName  = 'test';// { get; set; } { get; set; }
         res.ProjectAddress  = 'test';// { get; set; } { get; set; }
         res.ProjectID   = 'test';// { get; set; }{ get; set; }
         res.QuoteNumber  = 'test';// { get; set; }{ get; set; }
         res.origin  = 'test';// { get; set; } { get; set; }
        
         ServiceQuote_Home_Controller4.ServiceQuoteEntry entry = new ServiceQuote_Home_Controller4.ServiceQuoteEntry();
         entry.ID = 'test';
         entry.ServiceQuoteNumber = 'test';  
        
    }
    
    
    
       public static testMethod void projectDetail3() {
        test.startTest();
        Manufacturer_OrderNb__c mo = new Manufacturer_OrderNb__c();
        mo.Name = 'Richmond';
        //mo.LatestNumber__c = 40200;
        mo.LatestOrderNumber__c='40209';
        insert mo;
        
        Manufacturer_OrderNb__c mo1 = new Manufacturer_OrderNb__c();
        mo1.Name = 'Solarlux';
        //mo1.LatestNumber__c = 20001;
        mo1.LatestOrderNumber__c='20017';
        insert mo1;
        
        Manufacturer_OrderNb__c mo2 = new Manufacturer_OrderNb__c();
        mo2.Name = 'Teuffel';
        //mo2.LatestNumber__c = 75400;
        mo2.LatestOrderNumber__c='75401';
        insert mo2;
        
        Manufacturer_OrderNb__c mo3 = new Manufacturer_OrderNb__c();
        mo3.Name = 'Wizard';
        //mo3.LatestNumber__c = 97000;
        mo3.LatestOrderNumber__c='97001';
        insert mo3;
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = new Project__c();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co=new contact();
         co.Accountid = acct.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
         insert co;

         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
         Quote__c q = new Quote__c();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;
         
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
         c.Order__c = ord.id;        
        
        insert c;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        
        
         Service_Quote__c sq=new Service_Quote__c();
         sq.Case__c=c.Id;
         sq.Complaint__c=false;
         insert sq;
        
         /*Quote_Detail__c qd=new Quote_Detail__c();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         insert qd;*/
         
        
         ServiceQuote_Home_Controller4 controller1 = new ServiceQuote_Home_Controller4();
         controller1.dosort();
         controller1.getCountry();
         controller1.getModelOptions();
         controller1.getOldModelsChecked();
         controller1.getOldModelsToggleValue();
         controller1.getStates();        
         controller1.SearchFields.ServiceQuoteNumber='test';
         controller1.SearchFields.CaseNumber = 'test';
         controller1.SearchFields.Zip='12345';
         controller1.SearchFields.state= 'test';
         controller1.SearchFields.ProjectCountry= 'test';
         controller1.SearchFields.City= 'test';
         controller1.SearchFields.ProjectStreet= 'test';
         controller1.SearchFields.Email='abc@abc.com';
         controller1.SearchFields.Phone='12345';
         controller1.SearchFields.LastName='test';
         controller1.SearchFields.FirstName='test';            
         controller1.SearchObjects();
        
        
         ServiceQuote_Home_Controller4.SearchContainer scontainer=new ServiceQuote_Home_Controller4.SearchContainer();
         scontainer.ProjectName='test';
         scontainer.ProjectAddress='test';
         scontainer.ContactName='test';
         scontainer.LastName='test';
         scontainer.FirstName='test';
         scontainer.Address='test';
         scontainer.City='test';
         scontainer.ProjectStreet='test';
         scontainer.ProjectCountry='test';
         scontainer.state='test';
         scontainer.Zip='test';
         scontainer.Phone='test';
         scontainer.Email='test';
         scontainer.Panels_Left='test';
         scontainer.Panels_Right='test';
         scontainer.Panels_Count='test';
         scontainer.ServiceQuoteNumber='test';
         scontainer.CaseNumber='test';
         scontainer.QuoteNumber='test';
         scontainer.OrderNumber='test';
         scontainer.HiGrandTotal='test';
         scontainer.LoServiceQuoteAmount='test';
         scontainer.HiServiceQuoteAmount='test';
         scontainer.LoGrandTotal='test';
        
        
         ServiceQuote_Home_Controller4.ServiceQuoteSearchResult  res = new ServiceQuote_Home_Controller4.ServiceQuoteSearchResult();
         res.QuoteID  = 'test';// { get; set; }
         res.OrderID  = 'test';// { get; set; } { get; set; }
         res.City  = 'test';// { get; set; } { get; set; }
         res.State  = 'test';// { get; set; } { get; set; }
         res.Zip   = 'test';// { get; set; }{ get; set; }
         res.ContactName  = 'test';// { get; set; } { get; set; }
         res.LastName = 'test';
         res.FirstName = 'test';
         res.ContactEmail = 'test';
         res.Phone = 'test';    
         res.CaseId = 'test';
         res.ProjectStreet = 'test';
         res.ProjectCountry  = 'test';   
         res.CaseNumber = 'test';
         res.PanelCount = 'test';
         res.orderNumber = 'test';    
         res.Selected=true;
         res.ProjectName  = 'test';// { get; set; } { get; set; }
         res.ProjectAddress  = 'test';// { get; set; } { get; set; }
         res.ProjectID   = 'test';// { get; set; }{ get; set; }
         res.QuoteNumber  = 'test';// { get; set; }{ get; set; }
         res.origin  = 'test';// { get; set; } { get; set; }
        
         ServiceQuote_Home_Controller4.ServiceQuoteEntry entry = new ServiceQuote_Home_Controller4.ServiceQuoteEntry();
         entry.ID = 'test';
         entry.ServiceQuoteNumber = 'test';  
        
    }
    
    
    
    public static testMethod void projectDetail4() {
        
         test.startTest();
        Manufacturer_OrderNb__c mo = new Manufacturer_OrderNb__c();
        mo.Name = 'Richmond';
        //mo.LatestNumber__c = 40200;
        mo.LatestOrderNumber__c='40209';
        insert mo;
        
        Manufacturer_OrderNb__c mo1 = new Manufacturer_OrderNb__c();
        mo1.Name = 'Solarlux';
        //mo1.LatestNumber__c = 20001;
        mo1.LatestOrderNumber__c='20017';
        insert mo1;
        
        Manufacturer_OrderNb__c mo2 = new Manufacturer_OrderNb__c();
        mo2.Name = 'Teuffel';
        //mo2.LatestNumber__c = 75400;
        mo2.LatestOrderNumber__c='75401';
        insert mo2;
        
        Manufacturer_OrderNb__c mo3 = new Manufacturer_OrderNb__c();
        mo3.Name = 'Wizard';
        //mo3.LatestNumber__c = 97000;
        mo3.LatestOrderNumber__c='97001';
        insert mo3;
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = new Project__c();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co=new contact();
         co.Accountid = acct.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
         insert co;

         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
         Quote__c q = new Quote__c();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;
         
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
         c.Order__c = ord.id;        
        
        insert c;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        
        
         Service_Quote__c sq=new Service_Quote__c();
         sq.Case__c=c.Id;
         sq.Complaint__c=false;
         insert sq;
        
         Quote_Detail__c qd=new Quote_Detail__c();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         insert qd;
                
         ServiceQuote_Home_Controller4 controller1 = new ServiceQuote_Home_Controller4();
         controller1.dosort();
         controller1.getCountry();
         controller1.getModelOptions();
         controller1.getOldModelsChecked();
         controller1.getOldModelsToggleValue();
         controller1.getStates();
         controller1.SearchFields.OrderNumber = '0';
         controller1.SearchFields.firstname='test';
         controller1.SearchFields.ProjectStreet='test';
         controller1.SearchFields.phone='test';
         controller1.SearchFields.LastName='test';
         controller1.SearchFields.zip='12345';
         controller1.SearchFields.ProjectCountry='test';
         controller1.SearchFields.City='test';
         controller1.SearchFields.state='test';
         controller1.SearchFields.email='abc@abc.com';
         controller1.SearchObjects();
        
         ServiceQuote_Home_Controller4.SearchContainer containerclass=new ServiceQuote_Home_Controller4.SearchContainer();
         containerclass.ProjectName='test';
         containerclass.ProjectAddress='test';
         containerclass.ContactName='test';
         containerclass.LastName='test';
         containerclass.FirstName='test';
         containerclass.Address='test';
         containerclass.City='test';
         containerclass.ProjectStreet='test';
         containerclass.ProjectCountry='test';
         containerclass.state='test';
         containerclass.Zip='test';
         containerclass.Phone='test';
         containerclass.Email='test';
         containerclass.Panels_Left='test';
         containerclass.Panels_Right='test';
         containerclass.Panels_Count='test';
         containerclass.ServiceQuoteNumber='test';
         containerclass.CaseNumber='test';
         containerclass.QuoteNumber='test';
         containerclass.OrderNumber='test';
         containerclass.HiGrandTotal='test';
         containerclass.LoServiceQuoteAmount='test';
         containerclass.HiServiceQuoteAmount='test';
                
         ServiceQuote_Home_Controller4.ServiceQuoteSearchResult  res = new ServiceQuote_Home_Controller4.ServiceQuoteSearchResult();
         res.QuoteID  = 'test';// { get; set; }
         res.OrderID  = 'test';// { get; set; } { get; set; }
         res.City  = 'test';// { get; set; } { get; set; }
         res.State  = 'test';// { get; set; } { get; set; }
         res.Zip   = 'test';// { get; set; }{ get; set; }
         res.ContactName  = 'test';// { get; set; } { get; set; }
         res.LastName = 'test';
         res.FirstName = 'test';
         res.ContactEmail = 'test';
         res.Phone = 'test';    
         res.CaseId = 'test';
         res.ProjectStreet = 'test';
         res.ProjectCountry  = 'test';   
         res.CaseNumber = 'test';
         res.PanelCount = 'test';
         res.orderNumber = 'test';    
         res.Selected=true;
         res.ProjectName  = 'test';// { get; set; } { get; set; }
         res.ProjectAddress  = 'test';// { get; set; } { get; set; }
         res.ProjectID   = 'test';// { get; set; }{ get; set; }
         res.QuoteNumber  = 'test';// { get; set; }{ get; set; }
         res.origin  = 'test';// { get; set; } { get; set; }
        
         ServiceQuote_Home_Controller4.ServiceQuoteEntry entry = new ServiceQuote_Home_Controller4.ServiceQuoteEntry();
         entry.ID = 'test';
         entry.ServiceQuoteNumber = 'test';  
         test.stopTest();
        
    }
    
      public static testMethod void projectDetail5() {
        
            test.startTest();
        Manufacturer_OrderNb__c mo = new Manufacturer_OrderNb__c();
        mo.Name = 'Richmond';
        //mo.LatestNumber__c = 40200;
        mo.LatestOrderNumber__c='40209';
        insert mo;
        
        Manufacturer_OrderNb__c mo1 = new Manufacturer_OrderNb__c();
        mo1.Name = 'Solarlux';
        //mo1.LatestNumber__c = 20001;
        mo1.LatestOrderNumber__c='20017';
        insert mo1;
        
        Manufacturer_OrderNb__c mo2 = new Manufacturer_OrderNb__c();
        mo2.Name = 'Teuffel';
        //mo2.LatestNumber__c = 75400;
        mo2.LatestOrderNumber__c='75401';
        insert mo2;
        
        Manufacturer_OrderNb__c mo3 = new Manufacturer_OrderNb__c();
        mo3.Name = 'Wizard';
        //mo3.LatestNumber__c = 97000;
        mo3.LatestOrderNumber__c='97001';
        insert mo3;
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = new Project__c();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co=new contact();
         co.Accountid = acct.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
         insert co;

         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
         Quote__c q = new Quote__c();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;
         
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
         c.Order__c = ord.id;        
        
        insert c;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        
        
         Service_Quote__c sq=new Service_Quote__c();
         sq.Case__c=c.Id;
         sq.Complaint__c=false;
         insert sq;
        
         Quote_Detail__c qd=new Quote_Detail__c();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         insert qd;
                  
         ServiceQuote_Home_Controller4 cont = new ServiceQuote_Home_Controller4();
           
         ServiceQuote_Home_Controller4.ServiceQuoteSearchResult res = cont.getServiceQuoteSearchResultFromRecord( sq );      
         cont.dosort();
         cont.getCountry();
         cont.getModelOptions();
         cont.getOldModelsChecked();
         cont.getOldModelsToggleValue();
         cont.getStates();
         cont.SearchFields.ServiceQuoteNumber='test';
         cont.SearchFields.CaseNumber = 'test';
         cont.SearchFields.Zip='12345';
         cont.SearchFields.state= 'test';
         cont.SearchFields.ProjectCountry= 'test';
         cont.SearchFields.City= 'test';
         cont.SearchFields.ProjectStreet= 'test';
         cont.SearchFields.Email='abc@abc.com';
         cont.SearchFields.Phone='12345';
         cont.SearchFields.LastName='test';
         cont.SearchFields.FirstName='test';
         cont.models='HSW 60';
         cont.SearchFields.Panels_Count = '3';
         cont.SearchFields.Panels_Left = '4';
         cont.SearchFields.Panels_Right = '1';
         cont.SearchObjects();
           
         res = new ServiceQuote_Home_Controller4.ServiceQuoteSearchResult();
         res.QuoteID  = 'test';// { get; set; }
         res.OrderID  = 'test';// { get; set; } { get; set; }
         res.City  = 'test';// { get; set; } { get; set; }
         res.State  = 'test';// { get; set; } { get; set; }
         res.Zip   = 'test';// { get; set; }{ get; set; }
         res.ContactName  = 'test';// { get; set; } { get; set; }
         res.ProjectName  = 'test';// { get; set; } { get; set; }
         res.ProjectAddress  = 'test';// { get; set; } { get; set; }
         res.ProjectID   = 'test';// { get; set; }{ get; set; }
         res.QuoteNumber  = 'test';// { get; set; }{ get; set; }
         res.origin  = 'test';// { get; set; } { get; set; }
     
         ServiceQuote_Home_Controller4.SearchContainer ss=new ServiceQuote_Home_Controller4.SearchContainer();
         ss.ProjectName='test';
         ss.ProjectAddress='test';
         ss.ContactName='test';
         ss.LastName='test';
         ss.FirstName='test';
         ss.Address='test';
         ss.City='test';
         ss.ProjectStreet='test';
         ss.ProjectCountry='test';
         ss.state='test';
         ss.Zip='test';
         ss.Phone='test';
         ss.Email='test';
         ss.Panels_Left='test';
         ss.Panels_Right='test';
         ss.Panels_Count='test';
         ss.ServiceQuoteNumber='test';
         ss.CaseNumber='test';
         ss.QuoteNumber='test';
         ss.OrderNumber='test';
         ss.HiGrandTotal='test';
         ss.LoServiceQuoteAmount='test';
         ss.HiServiceQuoteAmount='test';
         ss.LoGrandTotal='test';
        
         ServiceQuote_Home_Controller4.ServiceQuoteEntry entry = new ServiceQuote_Home_Controller4.ServiceQuoteEntry();
         entry.ID = 'test';
         entry.ServiceQuoteNumber = 'test';  
         test.stoptest();   
        
    }
    
    
        public static testMethod void ProjectDetail6() {
        
                test.startTest();
        Manufacturer_OrderNb__c mo = new Manufacturer_OrderNb__c();
        mo.Name = 'Richmond';
        //mo.LatestNumber__c = 40200;
        mo.LatestOrderNumber__c='40209';
        insert mo;
        
        Manufacturer_OrderNb__c mo1 = new Manufacturer_OrderNb__c();
        mo1.Name = 'Solarlux';
        //mo1.LatestNumber__c = 20001;
        mo1.LatestOrderNumber__c='20017';
        insert mo1;
        
        Manufacturer_OrderNb__c mo2 = new Manufacturer_OrderNb__c();
        mo2.Name = 'Teuffel';
        //mo2.LatestNumber__c = 75400;
        mo2.LatestOrderNumber__c='75401';
        insert mo2;
        
        Manufacturer_OrderNb__c mo3 = new Manufacturer_OrderNb__c();
        mo3.Name = 'Wizard';
        //mo3.LatestNumber__c = 97000;
        mo3.LatestOrderNumber__c='97001';
        insert mo3;
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = new Project__c();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co=new contact();
         co.Accountid = acct.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
         insert co;

         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
         Quote__c q = new Quote__c();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;
         
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
         c.Order__c = ord.id;        
        
        insert c;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        
        
         Service_Quote__c sq=new Service_Quote__c();
         sq.Case__c=c.Id;
         sq.Complaint__c=false;
         insert sq;
        
         Quote_Detail__c qd=new Quote_Detail__c();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         insert qd;
            
         ServiceQuote_Home_Controller4 cont = new ServiceQuote_Home_Controller4();
         ServiceQuote_Home_Controller4.ServiceQuoteSearchResult res = cont.getServiceQuoteSearchResultFromRecord( sq );
        
         cont.dosort();
         cont.getCountry();
         cont.getModelOptions();
         cont.getOldModelsChecked();
         cont.getOldModelsToggleValue();
         cont.getStates();
         cont.SearchFields.orderNumber='12345';       
         cont.SearchObjects();
        
         ServiceQuote_Home_Controller4.SearchContainer ss=new ServiceQuote_Home_Controller4.SearchContainer();
         ss.ProjectName='test';
         ss.ProjectAddress='test';
         ss.ContactName='test';
         ss.LastName='test';
         ss.FirstName='test';
         ss.Address='test';
         ss.City='test';
         ss.ProjectStreet='test';
         ss.ProjectCountry='test';
         ss.state='test';
         ss.Zip='test';
         ss.Phone='test';
         ss.Email='test';
         ss.Panels_Left='test';
         ss.Panels_Right='test';
         ss.Panels_Count='test';
         ss.ServiceQuoteNumber='test';
         ss.CaseNumber='test';
         ss.QuoteNumber='test';
         ss.OrderNumber='test';
         ss.HiGrandTotal='test';
         ss.LoServiceQuoteAmount='test';
         ss.HiServiceQuoteAmount='test';
         ss.LoGrandTotal='test';
        
         res = new ServiceQuote_Home_Controller4.ServiceQuoteSearchResult();
         res.QuoteID  = 'test';// { get; set; }
         res.OrderID  = 'test';// { get; set; } { get; set; }
         res.City  = 'test';// { get; set; } { get; set; }
         res.State  = 'test';// { get; set; } { get; set; }
         res.Zip   = 'test';// { get; set; }{ get; set; }
         res.ContactName  = 'test';// { get; set; } { get; set; }
         res.ProjectName  = 'test';// { get; set; } { get; set; }
         res.ProjectAddress  = 'test';// { get; set; } { get; set; }
         res.ProjectID   = 'test';// { get; set; }{ get; set; }
         res.QuoteNumber  = 'test';// { get; set; }{ get; set; }
         res.serviceQuotes  = new list<ServiceQuote_Home_Controller4.ServiceQuoteEntry>();// { get; set; }
         res.origin  = 'test';// { get; set; } { get; set; }
        
         ServiceQuote_Home_Controller4.ServiceQuoteEntry entry = new ServiceQuote_Home_Controller4.ServiceQuoteEntry();
         entry.ID = 'test';
         entry.ServiceQuoteNumber = 'test';  
         test.stoptest();
        
    }
    
           
}