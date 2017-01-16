/**********************************************************************
Apex Class: OrderCreationShopify_Test
Description: This test class is used to cover the OrderCreationShopify Class
Created Date: 29thApril,2016            
***********************************************************************/
@isTest
private class OrderCreationShopify_Test {

    public static string endPointUrl = 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderCreation';
    
    //This Method is used to Cover the code to create a service quote with case
    static testMethod void OrderCreationWithCase() {

        //Insert Test data
        list<case> caseInsertList = TestDataUtility.createCaseTestData();
        insert caseInsertList;

        test.startTest();

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
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderCreation');
        
        //The EndPoint URL will receive the data from shopify Application on Order Creation event
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderCreationShopify.doPost();
        
        test.stopTest();
    }

    //This Method is used to Cover the code to create a service quote without case
    static testMethod void OrderCreationWithoutCase() {
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_WithoutCase());

        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        String contentType = res.getHeader('Content-Type');
        
        //The Output of HTTP response must be Application/json format
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        
        //The Data from HTTP response is stored in actualValue
        blob b = blob.valueOf(actualValue);
        System.RestContext.request = new RestRequest();
        
        //The EndPoint URL will receive the data from shopify Application on Order Creation event
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderCreation');
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderCreationShopify.doPost();

        test.stoptest();
    }

    //This Method is used to Cover the code to create a service quote with account, contact and case
    static testMethod void OrderCreationWithAccountAndContact() {

        //Insert Test data
        list < Zip_Codes_Master__c > lstzipCode = TestDataUtility.getTerritoryMaster();
        insert lstzipCode;

        list<Account> accountInsertList = TestDataUtility.createAccountTestData();
        insert accountInsertList;
        
        /*list<Contact> contactInsertList = TestDataUtility.createConTestData();
        contactInsertList[0].AccountId = accountInsertList[0].id;
        contactInsertList[0].email = 'test.lassr@example.com';
        insert contactInsertList[0];*/
        
        
        list<contact> con=new list<contact>();
       contact co=new contact();
         //con.Name='test contact';
         co.Accountid=accountInsertList[0].id;
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
         
         list<Order> orderInsertList = TestDataUtility.createOrderTestData();
        orderInsertList[0].Accountid = accountInsertList[0].id;
        
        orderInsertList[0].Contact__c = con[0].id;
        insert orderInsertList[0];
        
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_WithoutCase());

        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        String contentType = res.getHeader('Content-Type');
        
        //The Output of HTTP response must be Application/json format
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        
        //The Data from HTTP response is stored in actualValue
        blob b = blob.valueOf(actualValue);
        System.RestContext.request = new RestRequest();
        
        //The EndPoint URL will receive the data from shopify Application on Order Creation event
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderCreation');
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderCreationShopify.doPost();
        
        test.stoptest();
    }

    //This Method is used to Cover the code to create a service quote with case, Account, Contact and Order
    static testMethod void OrderCreationWithStandardOrder() {

        //Insert Test data
        list < Zip_Codes_Master__c > lstzipCode = TestDataUtility.getTerritoryMaster();
        insert lstzipCode;

        list<Account> accountInsertList = TestDataUtility.createAccountTestData();
        insert accountInsertList;
        
        /*list<Contact> contactInsertList = TestDataUtility.createConTestData();
        contactInsertList[0].AccountId = accountInsertList[0].id;
        contactInsertList[0].email = 'test.lassr@example.com';
        insert contactInsertList[0];*/
        
        
        list<contact> con=new list<contact>();
       contact co=new contact();
         //con.Name='test contact';
         co.Accountid=accountInsertList[0].id;
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

        list<Order> orderInsertList = TestDataUtility.createOrderTestData();
        orderInsertList[0].Accountid = accountInsertList[0].id;
        
        orderInsertList[0].Contact__c = con[0].id;
        insert orderInsertList[0];

        test.starttest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_WithoutCase());

        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        
        //The Output of HTTP response must be Application/json format
        String actualValue = res.getBody();
        
        //The Data from HTTP response is stored in actualValue
        blob b = blob.valueOf(actualValue);
        System.RestContext.request = new RestRequest();
        
        //The EndPoint URL will receive the data from shopify Application on Order Creation event
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderCreation');     
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderCreationShopify.doPost();
        
        test.stoptest();
    }

}