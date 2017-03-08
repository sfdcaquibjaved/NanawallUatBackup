/**********************************************************************
Test Class: MockHttpResponseGenerator_ContactReceive
Description: Test class is used to create mock http resonse
Created Date: 3rd May,2016            
***********************************************************************/
@isTest
global class MockHttpResponseGenerator_ContactReceive implements HttpCalloutMock {
    
    //Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
                        
        // Optionally, only send a mock response for a specific endpoint and method.
       // System.assertEquals('http://service-nanawall.cs50.force.com/shopify/services/apexrest/Customercreation', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        res.setBody('{"id":3060358851,"email":"durgap@absyz.com","accepts_marketing":false,"created_at":"2016-05-02T01:10:14-07:00","updated_at":"2016-05-02T01:10:54-07:00","first_name":"Durga","last_name":"p","orders_count":1,"state":"disabled","total_spent":"1.00","last_order_id":2841446403,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"tags":"","last_order_name":"#OL1423","default_address":{"id":3223042435,"first_name":"Durga","last_name":"p","company":"","address1":"","address2":"","city":"los angeles","province":"California","country":"United States","zip":"90001","phone":"","name":"Durga p","province_code":"CA","country_code":"US","country_name":"United States","default":true},"addresses":[{"id":3223042435,"first_name":"Durga","last_name":"p","company":"","address1":"","address2":"","city":"los angeles","province":"California","country":"United States","zip":"90001","phone":"","name":"Durga p","province_code":"CA","country_code":"US","country_name":"United States","default":true}]}');
        res.setStatusCode(200);
        return res;
    }
}