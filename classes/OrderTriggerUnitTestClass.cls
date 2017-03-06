@isTest
public class OrderTriggerUnitTestClass {
     public static list < orderItem > orderItemList;
    public static testMethod void UnitTest1() {


        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('System Administrator', 'testUser@testing.com');
        insert testUser;
        
        
        list < Account > Acc = new list < Account > ();
        Acc = TestDataUtility.createAccountTestData();
        insert Acc[0];

        list < Contact > Con = new list < Contact > ();
        Con = TestDataUtility.createConTestData();
        Con[0].Accountid = Acc[0].id;
        insert Con[0];

        list < Project__c > Pro = new list < Project__c > ();
        Pro = TestDataUtility.createProjectTestData();
        insert Pro[0];

        list < Opportunity > opp = new list < Opportunity > ();
        opp = TestDataUtility.createOppTestData();
        opp[0].Accountid = Acc[0].id;
        opp[0].Project_Name__c = Pro[0].Id;
        opp[0].OwnerId = testuser.id;
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
       test.starttest();
        list < order > o = new list < order > ();
        o = TestDataUtility.createOrderTestData();
        o[0].AccountId = acc[0].id;
        o[0].OpportunityID = opp[0].Id;
        o[0].NanaQuote__c = qu.Id;
        o[0].Project__c = Pro[0].Id;
        o[0].QuoteID = q.Id;
        o[0].Pricebook2Id  = pb.id;
        o[0].ownerid = testUser.id;
        o[0].Status = 'Draft';
        try{
        insert o[0];
        }catch(exception e){}
        
                
        /*o[0].Status = 'Cancelled';
        update o[0];*/
        
        list<Quote_Detail__c> qdlist=new list<Quote_Detail__c>();
        Quote_Detail__c qd=new Quote_Detail__c();
        qd.Quote__c= qu.Id;
        qd.Price__c=100;
        qd.Discount__c=10;
        qd.Model__c ='HSW 67';
        qdlist.add(qd);
      
        insert qdlist[0];

        Id pricebookId = Test.getStandardPricebookId();                         

        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1', isActive = true);
        insert prd1;

        PricebookEntry pe=new PricebookEntry(UnitPrice = 1,Product2Id=prd1.id,Pricebook2Id=pricebookId,isActive=true);
        insert pe;

        Order od = new Order( EffectiveDate=system.today(),status='draft', PriceBook2Id=pricebookId,QuoteID = q.Id,NanaQuote__c = qu.Id,AccountId = acc[0].id,OpportunityID = opp[0].Id);
       try{
        insert od;
       

        OrderItem oi = new OrderItem(OrderId=od.id,Quantity=1,PricebookEntryId=pe.id, unitPrice=1);
        insert oi;
       }catch(exception e){}
        
        
        /*NanaQuote_Create_Order_Controller CreateOrderCont  = new NanaQuote_Create_Order_Controller(new Apexpages.Standardcontroller(qu));
        CreateOrderCont.CreateOrder();
        
        Order testord = CreateOrderCont.thisOrder;*/
        //testord.StatusCode ='A';
        
      

        
        
        
        List < Manufacturing_Order__c > Mf = new list < Manufacturing_Order__c > ();
        Manufacturing_Order__c Mfo = new Manufacturing_Order__c();
        //Mfo.Name = 'Test';
        Mfo.Order__c = od.id;
        Mf.add(Mfo);
        Insert Mf[0];
        update Mf[0];

        list < Shipping_Order__c > So = new list < Shipping_Order__c > ();
        Shipping_Order__c Sh = new Shipping_Order__c();
        //Sh.Status__c = 'Shipping Order Created';
        Sh.Actual_Delivery_Date__c = system.today();
        Sh.Manufacturing_Order__c = Mf[0].id;
        Sh.Order__c = od.id;
        So.add(Sh);
        Insert So[0];   
        update So[0];
        //o[0].Status = 'Cancelled ';
        //o[0].PriceBook2Id = pb.id;
        //o[0].Product2Id = prod.Id;
        //o[0].Status  = 'Order Created' ;
        //update o[0];
        
        /*o[0].Status = 'On Hold';
        o[0].PriceBook2Id = pb.id;
        update o[0];
        
        o[0].Status = 'Cancelled';
        update o[0];*/
    
        /*o[0].Status = 'Order Created';
        update o[0];*/
        
  test.stoptest();
        
        
    }
}