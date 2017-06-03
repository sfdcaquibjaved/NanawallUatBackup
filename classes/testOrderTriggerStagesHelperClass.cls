@isTest
public class testOrderTriggerStagesHelperClass {
static testmethod void method1(){
        test.startTest();
                list < OrderOppStages__c > ods = new list < OrderOppStages__c > ();
 OrderOppStages__c odsv1 = new OrderOppStages__c();
        odsv1.OppStage__c = 'Order - Requested';
        odsv1.Name = 'Order Created';
        ods.add(odsv1);
        insert ods;
            
         
        list < OrdProjectStages__c > ops = new list < OrdProjectStages__c > ();
        
        OrdProjectStages__c opsv1 = new OrdProjectStages__c();
        opsv1.Name = 'Order Created';
        opsv1.ProjStage__c = 'Order - Negotiation';
        ops.add(opsv1);
        insert ops;        
        
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
        
        Manufacturer_OrderNb__c mo7 = new Manufacturer_OrderNb__c();
        mo7.Name = 'VQ';
        //mo1.LatestNumber__c = 20001;
        mo7.LatestOrderNumber__c='95001';
        insert mo7;
        
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
        mm.Manufacturer__c='VQ';
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
         System.debug('Account inserted?'+acct.id);
         contact co=new contact();
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
         co.Accountid = acct.id;
         insert co;

         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         o.AccountId = acct.id;
         insert o;
        
        /*1Pricebook2 pb = new Pricebook2();
        pb.Name = 'test';
        insert pb;

        Product2 prod = new Product2();
        prod.Name = 'HSW 67';
        insert prod;

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;*/
        
         
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
         //q1.Pricebook2Id = pb.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         //q1.AccountId = acct.id;
         insert q1;
         
        Id pricebookId = Test.getStandardPricebookId();

        Product2 prd1 = new Product2(Name = 'Test Product Entry 1', Description = 'Test Product Entry 1', isActive = true);
        insert prd1;
// Insert Pricebook
        PriceBook2 customPriceBook = new PriceBook2();
        customPriceBook.Name='Custom Pricebook';
        customPriceBook.IsActive=true;
        insert customPriceBook;
        
        // Query Standard and Custom Price Books
        Pricebook2 customPriceBookRec=[select Id from Pricebook2 where id=:customPriceBook.Id];
        PricebookEntry pe = new PricebookEntry(UnitPrice = 1, Product2Id = prd1.id, Pricebook2Id = pricebookId, isActive = true);
        insert pe;
        PricebookEntry pe2 = new PricebookEntry(UnitPrice = 1, Product2Id = prd1.id, Pricebook2Id = customPriceBookRec.id, isActive = true);
        insert pe2;
        
         order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
        // ord.Account = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         ord.PriceBook2Id = customPriceBookRec.id;
         ord.AccountId = acct.id;
         ord.QuoteId = q1.id;
         //ord.Selected_Manufacturing_Orders__c = 'Richmond';
         insert ord;
         
       OrderItem oi = new OrderItem(OrderId = ord.id, Quantity = 1, PricebookEntryId = pe2.id, unitPrice = 1);
        insert oi;
        
        List < Manufacturing_Order__c > Mf = new list < Manufacturing_Order__c > ();
        Manufacturing_Order__c Mfo = new Manufacturing_Order__c();
        Mfo.Factory_Completion_Date__c = system.today();
        //Mfo.Name = 'Test';
        Mfo.Order__c = ord.id;
        //mfo.status__c = 'Factory Complete';
        Mf.add(Mfo);
        
        Insert Mf;
        
        list < Shipping_Order__c > So = new list < Shipping_Order__c > ();
        Shipping_Order__c Sh = new Shipping_Order__c();
        //Sh.status__c = 'Delivered';
        Sh.Manufacturing_Order__c = Mf[0].id;
        Sh.Actual_Delivery_Date__c = system.today();
        Sh.Order__c = ord.id;
        So.add(Sh);
        Insert So;
        
        
        
        API_ConvertOrder.InputData orderconvert = new API_ConvertOrder.InputData();
        orderconvert.SFQuoteID = q1.id;
        
       
        API_ConvertOrder.doConvert(orderconvert);
        list < Order > orde = [SELECT Id, Status FROM Order WHERE QuoteID =: q1.id];
        orde[0].status = 'Order Created';
        update orde[0];
        test.stopTest(); 
  }
}