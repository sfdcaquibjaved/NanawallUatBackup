/**********************************************************************
Test Class: MockHttpResponseGenerator_OrderCreation
Description: Test class is used to create mock http resonse
Created Date: 3rd May,2016            
***********************************************************************/
@isTest
global class MockHttpResponseGenerator_OrderCreation implements HttpCalloutMock {
    
    //Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
                        //inserting test data
                        list<case> caseList = TestDataUtility.createCaseTestData();                    
                        insert caseList;
                        
                        case cc = [select id, CaseNumber from case where id=: caseList[0].id];
                        list<Service_Quote__c> sqList = TestDataUtility.createServiceQuoteTestData();
                        sqList[0].Case__c = caseList[0].id;
                        sqList[0].shopify__c= true;
                        sqList[0].recordtypeid=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId();  
                        sqList[0].Status__c='Order Created';
                        sqList[0].Shopify_ID__c='123';  
                        sqList[0].Total_Amount__c=569;
                        insert sqList[0];
                                             
        // Optionally, only send a mock response for a specific endpoint and method.
      //  System.assertEquals('http://service-nanawall.cs50.force.com/shopify/services/apexrest/Ordercreation', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        res.setBody('{"id":'+sqList[0].Shopify_ID__c+',"email":"test.lassr@example.com","closed_at":null,"created_at":"2016-04-29T03:51:04-07:00","updated_at":"2016-04-29T03:51:04-07:00","number":412,"note":"#'+cc.CaseNumber+'","token":"8080c2fc44f1b44d0652d3671e7b0568","gateway":"manual","test":false,"total_price":"1.00","subtotal_price":"1.00","total_weight":0,"total_tax":"0.00","taxes_included":false,"currency":"USD","financial_status":"paid","confirmed":true,"total_discounts":"0.00","total_line_items_price":"1.00","cart_token":null,"buyer_accepts_marketing":false,"name":"#OL1412","referring_site":null,"landing_site":null,"cancelled_at":null,"cancel_reason":null,"total_price_usd":"1.00","checkout_token":null,"reference":null,"user_id":58179523,"location_id":null,"source_identifier":null,"source_url":null,"processed_at":"2016-04-29T03:51:04-07:00","device_id":null,"browser_ip":null,"landing_site_ref":null,"order_number":1412,"discount_codes":[],"note_attributes":[],"payment_gateway_names":["manual"],"processing_method":"manual","checkout_id":null,"source_name":"shopify_draft_order","fulfillment_status":null,"tax_lines":[],"tags":"","contact_email":"test.lassr@example.com","order_status_url":null,"line_items":[{"id":5075467459,"variant_id":19155634691,"title":"Test Product","quantity":1,"price":"1.00","grams":0,"sku":"5","variant_title":null,"vendor":"NanaWall Parts","fulfillment_service":"manual","product_id":6191116163,"requires_shipping":true,"taxable":false,"gift_card":false,"name":"Test Product","variant_inventory_management":"shopify","properties":[],"product_exists":true,"fulfillable_quantity":1,"total_discount":"0.00","fulfillment_status":null,"tax_lines":[{"title":"NY State Tax","price":"0.00","rate":0.04},{"title":"Schenectady County Tax","price":"0.00","rate":0.04}]}],"shipping_lines":[],"billing_address":{"first_name":"lassr","address1":" ","phone":" ","city":" ","zip":"12345","province":" ","country":"United States","last_name":"lasssrr","address2":null,"company":null,"latitude":42.8140012,"longitude":-73.9814578,"name":"lassr lasssrr","country_code":"US","province_code":null},"shipping_address":{"first_name":"lassr","address1":" ","phone":" ","city":" ","zip":"12345","province":" ","country":"United States","last_name":"lasssrr","address2":null,"company":null,"latitude":42.8140012,"longitude":-73.9814578,"name":"lassr lasssrr","country_code":"US","province_code":null},"fulfillments":[],"refunds":[],"customer":{"id":2932068739,"email":"test.lassr@example.com","accepts_marketing":false,"created_at":"2016-04-18T03:57:10-07:00","updated_at":"2016-04-29T03:51:04-07:00","first_name":"lassr","last_name":"lasssrr","orders_count":5,"state":"disabled","total_spent":"1.00","last_order_id":2826493251,"note":null,"verified_email":true,"multipass_identifier":null,"tax_exempt":false,"tags":"","last_order_name":"#OL1412","default_address":{"id":3092672259,"first_name":"lassr","last_name":"lasssrr","company":null,"address1":" ","address2":null,"city":" ","province":" ","country":"United States","zip":"12345","phone":" ","name":"lassr lasssrr","province_code":null,"country_code":"US","country_name":"United States","default":true}}}');
        res.setStatusCode(200);
        return res;
    }
}