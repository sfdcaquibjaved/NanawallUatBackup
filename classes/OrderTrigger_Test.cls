@isTest
public class OrderTrigger_Test {
    
    public static testMethod void UnitTest1() {

        list < OrderOppStages__c > ods = new list < OrderOppStages__c > ();
        /*OrderOppStages__c odsv = new OrderOppStages__c();
        odsv.OppStage__c = 'Closed/Won';
        odsv.Name = 'Paid/Delivered';
        ods.add(odsv);*/
        
         
        OrderOppStages__c odsv1 = new OrderOppStages__c();
        odsv1.OppStage__c = 'Order - Requested';
        odsv1.Name = 'Order Created';
        ods.add(odsv1);
        insert ods;
            
         
        list < OrdProjectStages__c > ops = new list < OrdProjectStages__c > ();
        /*OrdProjectStages__c opsv = new OrdProjectStages__c();
        opsv.Name = 'Paid/Delivered';
        opsv.ProjStage__c = 'Closed Complete - Ordered - Paid';
        ops.add(opsv);*/
        //insert opsv;
        OrdProjectStages__c opsv1 = new OrdProjectStages__c();
        opsv1.Name = 'Order Created';
        opsv1.ProjStage__c = 'Order - Negotiation';
        ops.add(opsv1);
        insert ops;

        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('System Administrator', 'testUser@testing.com');
        insert testUser;

         
      
        list < Account > Acc = new list < Account > ();
        Acc = TestDataUtility.createAccountTestData();
       
        insert Acc[0];

        /*list < Contact > Con = new list < Contact > ();
        Con = TestDataUtility.createConTestData();
        Con[0].Accountid = Acc[0].id;
        Con[0].lastName = 'CAD EMAIL RECIPIENT';
        insert Con[0];*/
         
        list<contact> con=new list<contact>();
       contact co=new contact();
         //con.Name='test contact';
         co.Accountid=Acc[0].id;
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
         con.add(co);
          
         insert con;

       
        list < Project__c > Pro = new list < Project__c > ();
        Pro = TestDataUtility.createProjectTestData();
        //pro[0].stage__c = 'Order - Negotiation';
        insert Pro[0];
         
        list < Opportunity > opp = new list < Opportunity > ();
        opp = TestDataUtility.createOppTestData();
        opp[0].Accountid = Acc[0].id;
        opp[0].Project_Name__c = Pro[0].Id;
        opp[0].OwnerId = testuser.id;
        //opp[0].StageName ='Order - Requested';
        insert opp[0];
        
      
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'test';
        insert pb;

        Product2 prod = new Product2();
        prod.Name = 'HSW 67';
        insert prod;

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;

        PricebookEntry new_pbe = new PricebookEntry();
        new_pbe.Pricebook2Id = pb.Id;
        new_pbe.Product2Id = prod.Id;
        new_pbe.UnitPrice = 1.0;
        new_pbe.isActive = true;
        new_pbe.UseStandardPrice = false;
        insert new_pbe;
           
        
        
        quote__c qu = new quote__c();
        qu.Name = 'TestQuote';
        qu.Contact__c = Con[0].id;
        qu.Opportunity__c = opp[0].Id;
        insert qu;
        Test.startTest(); 
        Quote q = new Quote();
        q.Name = 'Test Quote';
        q.OpportunityId = opp[0].Id;
        q.Pricebook2Id = pb.Id;
        q.Nana_Quote__c = qu.Id;
        q.First_Threshold_Price__c = 1;
        q.Name = '12345';
        q.ContactId = Con[0].id;
        q.Tax = 1.0;
        q.ShippingHandling = 1.0;
        q.Drawing_price__c = 1.0;
        q.Packaging__c = 1.0;
        q.Canada_Tax__c = 1.0;
        q.Canada_Tax_Label__c = 'test';
        q.Ship_Label__c = 'test';
        q.Order_Number__c = 12345;
        insert q;

        
        list < Quote_Detail__c > qdlist = new list < Quote_Detail__c > ();
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Quote__c = qu.Id;
        qd.Price__c = 100;
        qd.Discount__c = 10;
        qd.Model__c = 'HSW 67';
        qdlist.add(qd);
        insert qdlist[0];
        
     
      
        
        Id pricebookId = Test.getStandardPricebookId();

        Product2 prd1 = new Product2(Name = 'Test Product Entry 1', Description = 'Test Product Entry 1', isActive = true);
        insert prd1;

        PricebookEntry pe = new PricebookEntry(UnitPrice = 1, Product2Id = prd1.id, Pricebook2Id = pricebookId, isActive = true);
        insert pe;
        Order od = new Order(name = '0000807', EffectiveDate = system.today(), status = 'draft', PriceBook2Id = pricebookId, QuoteID = q.Id, NanaQuote__c = qu.Id, AccountId = acc[0].id, OpportunityID = opp[0].Id, Project__C = Pro[0].id);
        insert od;

        OrderItem oi = new OrderItem(OrderId = od.id, Quantity = 1, PricebookEntryId = pe.id, unitPrice = 1);
        
        insert oi;
        
        List < Manufacturing_Order__c > Mf = new list < Manufacturing_Order__c > ();
        Manufacturing_Order__c Mfo = new Manufacturing_Order__c();
        Mfo.Factory_Completion_Date__c = system.today();
        //Mfo.Name = 'Test';
        Mfo.Order__c = od.id;
        //mfo.status__c = 'Factory Complete';
        Mf.add(Mfo);
        
        Insert Mf;
        
        list < Shipping_Order__c > So = new list < Shipping_Order__c > ();
        Shipping_Order__c Sh = new Shipping_Order__c();
        //Sh.status__c = 'Delivered';
        Sh.Manufacturing_Order__c = Mf[0].id;
        Sh.Actual_Delivery_Date__c = system.today();
        Sh.Order__c = od.id;
        So.add(Sh);
        Insert So;
        
        
        
        API_ConvertOrder.InputData orderconvert = new API_ConvertOrder.InputData();
        orderconvert.SFQuoteID = q.id;
        
            Test.stopTest(); 
       
        API_ConvertOrder.doConvert(orderconvert);
        list < Order > ord = [SELECT Id, Status FROM Order WHERE QuoteID =: q.id];
        ord[0].status = 'Order Created';
        update ord[0];
        
    }
    

}