/**********************************************************************
Apex Class: OrderFulfillmentShopify
Description: This REST Web service class is to fetch the data from shopify 
             on Order Fulfillment
Created Date: 19thApril,2016            
***********************************************************************/
@RestResource(urlMapping = '/Orderfulfillment/*')
global without sharing class OrderFulfillmentShopify {
	
	//Global Variables
	static string orderStatus = 'Order Fullfilled';
	static string financialStatus = 'Paid';
	static string fulfilledStatus = 'fulfilled';
	
	//This method is used to update the fullfillement status of service quote on fulfillment of order in shopify
    @HttpPost
    global static void doPost() {
        // Local Variables       
        list < string > orderId = new list < string > ();
        list < wrapperObjectShopify.Orders > ordList = new list < wrapperObjectShopify.Orders > ();
        list < Service_Quote__c > sqUpdate = new list < Service_Quote__c > ();

        //Requesting REST Service to fetch the data send by shopify to this web service class
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //res.addHeader('Content-Type', 'application/json'); 
        //res.statusCode = 200;
        Blob body = req.requestBody;
        String bodyString = body.toString();

		//In bodyString the data that is received from shopify is stored and you can see the output in the below debug
        System.debug('ordersssssssss' + bodyString);
        System.debug('ordersssssssss2222222' + res);

        //The data in bodyString is in JSON format the below method is used to parse the json format to normal format.
        JSONParser parser = JSON.createParser(bodyString);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                // Read entire Orders object, including its array of line items.
                wrapperObjectShopify.Orders ord = (wrapperObjectShopify.Orders) parser.readValueAs(wrapperObjectShopify.Orders.class);
                String emailname = parser.getText();
                ordList.add(ord);
                orderId.add(ord.id);
                String ss = JSON.serialize(ord);
                system.debug('Serialized invoice: ' + ss);
                // Skip the child start array and start object markers.
                parser.skipChildren();
            }
        }
        
        //Updating Service Quote on Shopify Order Fulfillment
        for (Service_Quote__c sq: [select id, status__c from Service_Quote__c where Shopify_ID__c =: orderId]) {
            for (wrapperObjectShopify.Orders ord: ordList) {
                if (ord.fulfillment_status == fulfilledStatus) {
                    sq.status__c = orderStatus;
                    sq.Financial_Status__c = financialStatus;
                    for (wrapperObjectShopify.fulfillments ful: ord.fulfillments) {
                        sq.Freight_Tracking_Number__c = ful.tracking_number;
                        sq.Shipping_Method__c = ful.tracking_company;
                    }
                    sqUpdate.add(sq);
                }
            }
        }
        System.debug('@@@@@@@@@@@@' + sqUpdate);
        //Updating Service Quote
        if (sqUpdate.size() > 0)
        {
              Database.saveresult[] sr = Database.update(sqUpdate, False);
              ErrorLogUtility.processErrorLogs(sr, sqUpdate, 'OrderFulfillmentShopify', 'doPost', 'Service_Quote__c', 'Update');           
        }

    }
 }