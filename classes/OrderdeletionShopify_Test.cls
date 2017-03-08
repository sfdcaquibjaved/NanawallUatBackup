/**********************************************************************
Apex Class: OrderdeletionShopify_Test
Description: This test class is used to cover the OrderDeletionShopify Class
Created Date: 29thApril,2016            
***********************************************************************/
@isTest(SeeAllData = false)
private class OrderdeletionShopify_Test {

    public static string endPointUrl = 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderDeletion';
    
    //This Method is used to Cover the code to change status of Service Quote
    static testMethod void OrderDeletionUpdate() {

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
        System.AssertEquals(endPointUrl, 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/OrderDeletion');
        
        //The EndPoint URL will receive the data from shopify Application on Order Deletion event
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderDeletionShopify.doPost();
        
        test.stopTest();
    }
}