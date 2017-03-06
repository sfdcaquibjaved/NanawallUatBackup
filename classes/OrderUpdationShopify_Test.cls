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

        //Insert test data
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
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderUpdation');
        
        //The EndPoint URL will receive the data from shopify Application on Order Creation event
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderUpdationShopify.doPost();
        test.stopTest();

    }
    static testMethod void OrderUpdationMethodPaymentChange() {

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

    }
}