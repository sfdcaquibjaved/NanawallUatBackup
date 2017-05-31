/**********************************************************************
Apex Class: OrderUpdationShopify_Test 
Description: This test class is used to cover the OrderUpdationShopify Class
Created Date: 29th April,2016            
***********************************************************************/
@isTest
private class OrderUpdationShopify_Test {

    public static string endPointUrl = 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderUpdation';
    
    //This Method is used to Cover the code to create a service quote with case
    static testMethod void OrderUpdationMethod() {
    
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_OrderCreation());

        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        String contentType = res.getHeader('Content-Type');
        
        //The Output of HTTP response must be Application/json format
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        blob b = blob.valueOf(actualValue);
        
        //The Data from HTTP response is stored in actualValue
        System.RestContext.request = new RestRequest();
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderUpdation');
        
        //The EndPoint URL will receive the data from shopify Application on Order Creation event
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderUpdationShopify.doPost();
        test.stopTest();
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
        
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
        
        
        quote__c qu = new quote__c();
        qu.Name = 'TestQuote';
        qu.Contact__c = Con[0].id;
        qu.Opportunity__c = opp[0].Id;
        insert qu;
        Test.startTest(); 
        Quote q = new Quote();
        q.Name = 'Test Quote';
        q.OpportunityId = opp[0].Id;
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


        //Insert test data
        list<case> caseInsertList = TestDataUtility.createCaseTestData();
        insert caseInsertList;
        
        Order od = new Order(EffectiveDate = system.today(), status = 'draft', QuoteID = q.Id, NanaQuote__c = qu.Id, AccountId = acc[0].id, OpportunityID = opp[0].Id, Project__C = Pro[0].id);
        insert od;
        
        list < Service_Quote__c > sqList =new list < Service_Quote__c >();
        Service_Quote__c s=new Service_Quote__c();
        s.status__c='Order Created';
        s.Case__c=caseInsertList[0].id;
        s.Order__c=od.id;
        sqList.add(s);
        //test.startTest();
        insert sqList;
        update sqList;
        
        

        

    }
  /*  static testMethod void OrderUpdationMethodPaymentChange() {

        //Insert test data
        list<case> caseInsertList = TestDataUtility.createCaseTestData();
        insert caseInsertList;

        test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_PaymentChange());

        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        String contentType = res.getHeader('Content-Type');
        
        //The Output of HTTP response must be Application/json format
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        blob b = blob.valueOf(actualValue);
        
        //The Data from HTTP response is stored in actualValue
        System.RestContext.request = new RestRequest();
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderUpdation');
        
        //The EndPoint URL will receive the data from shopify Application on Order Updation event
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderUpdationShopify.doPost();
        test.stopTest();

    }*/
}