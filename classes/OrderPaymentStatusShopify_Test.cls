/**********************************************************************
Apex Class: OrderPaymentStatusShopify_Test
Description: This test class is used to cover the OrderPaymentStatusShopify Class
Created Date: 29thApril,2016            
***********************************************************************/
@isTest(SeeAllData = false)
private class OrderPaymentStatusShopify_Test {
   
    public static string endPointUrl = 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/Ordercancellation';
    public static string endPointUrlOnCreate = 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderCreation';
    public static string endPointUrlOnPayment = 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/Orderpaymentstatus';

    //This Method is used to Cover the code to change status of Service Quote On Order Cancellation
    static testMethod void OrderPaymentChangeOnCancellation() {

        test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_OrderCancel());

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
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/Ordercancellation');
        
        //The EndPoint URL will receive the data from shopify Application on Order Cancellation event
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderPaymentStatusShopify.doPost();
        test.stopTest();

    }
    
    //This Method is used to Cover the code to change status of Service Quote On Order Creation
    static testMethod void OrderPaymentChangeOnCreation() {

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
        System.AssertEquals(endPointUrlOnCreate, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderCreation');
        
        //The EndPoint URL will receive the data from shopify Application on Order Creation event
        RestContext.request.requestURI = endPointUrlOnCreate;
        RestContext.request.requestBody = b;
        OrderPaymentStatusShopify.doPost();
        
        test.stopTest();
    }
    
    //This Method is used to Cover the code to change status of Service Quote On Order Payment Change
    static testMethod void OrderPaymentChange() {

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
        System.AssertEquals(endPointUrlOnPayment, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/Orderpaymentstatus');
        
        //The EndPoint URL will receive the data from shopify Application on Order Payment Status change event
        RestContext.request.requestURI = endPointUrlOnPayment;
        RestContext.request.requestBody = b;
        OrderPaymentStatusShopify.doPost();
        test.stopTest();

    }
}