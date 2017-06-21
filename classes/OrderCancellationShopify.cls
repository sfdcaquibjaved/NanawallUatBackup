/**********************************************************************
Apex Class: OrderCancellationShopify
Description: This REST Web service class is to fetch the data from shopify 
             on Order Cancellation
Created Date: 20th April,2016            
**********************************************************************/
@RestResource(urlMapping = '/Ordercancellation/*')
global without sharing class OrderCancellationShopify {
    
    //Global Variables
    static string orderStatus = 'Order Cancelled';
    static string financialStatus = 'Refunded';
    
    //This method is used to update service quote on cancellation of order on shopify
    @HttpPost
    global static void doPost() {
        // Local Variables       
        list < string > orderId = new list < string > ();
        list < wrapperObjectShopify > ordList= new list < wrapperObjectShopify > ();
        list < Service_Quote__c > sqUpdate  = new list < Service_Quote__c > ();
         
        //Requesting REST Service to fetch the data send by shopify to this web service class
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob body = req.requestBody;
        String bodyString = body.toString();
        /* res.addHeader('Content-Type', 'application/json'); 
         res.statusCode = 200;*/
        
        //In bodyString the data that is received from shopify is stored and you can see the output in the below debug
        System.debug('ordersssssssss' + bodyString);
        System.debug('ordersssssssss2222222' + res);

        //The data in bodyString is in JSON format the below method is used to parse the json format to normal format.
        wrapperObjectShopify order = (wrapperObjectShopify) JSON.deserialize(bodyString, wrapperObjectShopify.class);
        ordList.add(order);
        orderId.add(order.id);

        //Updating Service Quote on Shopify Order Cancellation
        for (Service_Quote__c sq: [select id, status__c from Service_Quote__c where Shopify_ID__c =: orderId]) {
            for (wrapperObjectShopify ord: ordList) {
                if (ord.cancelled_at != NULL) {
                    sq.status__c = orderStatus;
                    sq.Financial_Status__c = financialStatus;
                    sq.Discount__c = 0;
                    sq.Total_Amount__c = 0;
                    sq.Description__c = 'Order is cancelled. The cancelled reason is' + ord.cancel_reason + '. Money is refunded';
                    sqUpdate.add(sq);
                }

            }
        }

        //Updating Service Quote
        if (sqUpdate.size() > 0)
        {
              Database.saveresult[] sr = Database.update(sqUpdate, False);
              ErrorLogUtility.processErrorLogs(sr, sqUpdate, 'OrderCancellationShopify', 'doPost', 'Service_Quote__c', 'Update');           
        }
    }
}