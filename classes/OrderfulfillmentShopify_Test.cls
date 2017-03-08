/**********************************************************************
Apex Class: OrderfulfillmentShopify_Test
Description: This test class is used to cover the OrderFulfillmentShopify Class
Created Date: 29thApril,2016            
***********************************************************************/
@isTest(SeeAllData = false)
private class OrderfulfillmentShopify_Test {
    
    public static string endPointUrl = 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/Orderfulfillment';
    
    //This Method is used to Cover the code to change status of Service Quote
    static testMethod void OrderFullfillment() {

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_OrderFull());

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
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/Orderfulfillment');
        
        //The EndPoint URL will receive the data from shopify Application on Order Fulfillment event
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderFulfillmentShopify.doPost();
        
        test.stopTest();

    }
}