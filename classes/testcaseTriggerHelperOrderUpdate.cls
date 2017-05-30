@isTest
public class testcaseTriggerHelperOrderUpdate {
    
    
    static testmethod void method1(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
             Project__c p1 = new Project__c();
           // p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
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
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.project_name__c = p1.id;
        insert o;
        
         Opportunity op = new Opportunity();
        op.Name = 'Test Opp CompetitorHelper_Test2';
        op.StageName = 'Qualification';
        op.CloseDate = Date.today();
        op.Country__c = 'USA';
        op.Postal_Code__c = 'TEST';
        op.project_name__c =p1.id;
        insert op;
        test.startTest();
        Quote__c q1 = new Quote__c();
            q1.Name = 'Test Quote';
            q1.Opportunity__c = o.Id;
            q1.Primary_Quote__c=True;
            insert q1;
        
        Quote__c q2 = new Quote__c();
            q2.Name = 'Test Quote new';
            q2.Opportunity__c = op.Id;
            q2.Primary_Quote__c=false;
            insert q2;
        
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';   
        qd.quote__C = q1.id;
        insert qd;
        
         Quote_Detail__c qd1 = new Quote_Detail__c();
        qd1.Model__c = 'WA63';   
        qd1.quote__C = q2.id;
        insert qd1;
        
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         c.subject = 'Test';
        c.quote__c = q1.id;
        c.Description = 'Test Description'; 
        insert c;
        
        c.quote__c = q2.id;
        update c;
        test.stopTest();
        
    }
    
    
      static testmethod void method2(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
          
       
          
            Account acct = new Account(Name='My Test Account1',Type = 'Architecture Firm',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
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
          
              case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         c.subject = 'Test';
   c.ContactId=co.Id;
        c.Description = 'Test Description'; 
          
            c.I_am_requesting_service_as__c  = co.LeadType__c;
                    c.Account_Type__c = co.Account.type;
                    c.AccountID = co.AccountID;
        insert c;
          
        
        
    }


   static testmethod void method3(){
       
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
         c.subject = 'Test';
   	
        c.Description = 'Test Description'; 
          c.Order__c=ord.Id;

        insert c;
       
           
       
 
         Manufacturing_Order__c morder= new Manufacturing_Order__c();
       	 morder.Supplier_WO_Number__c='213';
         morder.Order__c=ord.Id;
         insert morder;
       
        c.Order__c=ord.Id;
    	c.SL_Order_Id_Manuf__c=morder.Supplier_WO_Number__c;
    	update c;
      
        
    }
    
   
}