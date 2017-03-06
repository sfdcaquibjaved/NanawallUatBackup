/**********************************************************************
Apex Class: OrderUpdationShopify_Test 
Description: This test class is used to cover the OrderUpdationShopify Class
Created Date: 29th April,2016            
***********************************************************************/
@isTest
private class ShopifyCustomerCreation_WebService_Test {
    
    public static string endPointUrl = 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/Customercreation';
    static testMethod void testDoPost() {

        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_ContactReceive());

        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClassCustomerCreation.getInfoFromExternalService();
        String contentType = res.getHeader('Content-Type');
        
        //The Output of HTTP response must be Application/json format
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();        
        blob b = blob.valueOf(actualValue);
        
        //The Data from HTTP response is stored in actualValue
        System.RestContext.request = new RestRequest();
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/Customercreation');
        
        //The EndPoint URL will receive the data from shopify Application on Order Creation event
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        ShopifyCustomerCreation_WebService.doPost();
        test.stopTest();

    }
}