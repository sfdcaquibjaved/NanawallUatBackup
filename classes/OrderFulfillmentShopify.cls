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
        list < wrapperObjectShopify.Order > ordList = new list < wrapperObjectShopify.Order > ();
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
                shopifywrapper order = (shopifywrapper) JSON.deserialize(bodyString, shopifywrapper.class);
                ordList.add(order.Order);
                orderId.add(order.Order.id);
               
        //Updating Service Quote on Shopify Order Fulfillment
        for (Service_Quote__c sq: [select id, status__c from Service_Quote__c where Shopify_ID__c =: orderId]) {
            for (wrapperObjectShopify.Order ord: ordList) {
                if (ord.fulfillment_status == fulfilledStatus) {
                    sq.status__c = orderStatus;
                    sq.Financial_Status__c = financialStatus;
                    for (wrapperObjectShopify.fulfillments ful: ord.fulfillments) {
                        sq.Freight_Tracking_Number__c = ful.tracking_number;
                        sq.Tracking_Company__c = ful.tracking_company;
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
    public class shopifywrapper{
       public wrapperObjectShopify.Order Order;
    }
 }