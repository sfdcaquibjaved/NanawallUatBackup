/**********************************************************************
Apex Class: OrderCreationShopify_Test
Description: This test class is used to cover the OrderCreationShopify Class
Created Date: 29thApril,2016            
***********************************************************************/
@isTest
private class OrderCancellationShopify_Test {
    
    public static string endPointUrl = 'https://uatfullsb-nanawall.cs50.force.com/shopify/services/apexrest/Ordercancellation';
    
    //This Method is used to Cover the code to change status of Service Quote
    static testMethod void OrderCancellationStatusUpdate() {
        //Insert test data
        list<case> caseInsertList = TestDataUtility.createCaseTestData();
        insert caseInsertList;
        
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
        
        //The EndPoint URL will receive the data from shopify Application on Order Creation event
        RestContext.request.requestURI = endPointUrl;
        RestContext.request.requestBody = b;
        OrderCancellationShopify.doPost();
        
        test.stopTest();

    }
}