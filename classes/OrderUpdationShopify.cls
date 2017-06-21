/**********************************************************************
Apex Class: OrderUpdationShopify
Description: This REST Web service class is to fetch the data from shopify 
             on Order Updation
Created Date: 19thApril,2016            
***********************************************************************/
@RestResource(urlMapping = '/Orderupdation/*')
global without sharing class OrderUpdationShopify {

    //Global Variables
    static string orderStatus = 'Order Paid';
    static string paid = 'Paid';
    static string refund = 'refunded';
    static string orderStatusCancel = 'Order Cancelled';
    
    //This method is used to update service quote on updation of order in shopify
    @HttpPost
    global static void doPost() {
        // Local Variables       
        list < string > orderId = new list < string > ();
        list < wrapperObjectShopify > ordList = new list < wrapperObjectShopify > ();
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
               wrapperObjectShopify order1 = (wrapperObjectShopify) JSON.deserialize(bodyString, wrapperObjectShopify.class);
                ordList.add(order1);
                orderId.add(order1.id);
              
        //Updating Service Quote on Shopify Order Updation       
        for (Service_Quote__c sq: [select id, status__c from Service_Quote__c where Shopify_ID__c =: orderId]) {
            for (wrapperObjectShopify ord: ordList) {
                if (ord.financial_status == paid && ord.fulfillment_status == NULL) {
                    sq.status__c = orderStatus;
                    sq.Financial_Status__c = paid;
                    sqUpdate.add(sq);
                } else if (ord.financial_status == refund) {
                    sq.status__c = orderStatusCancel;
                    sq.Financial_Status__c = refund;
                    sq.Discount__c = 0;
                    sq.Total_Amount__c = 0;
                    sq.Description__c = 'Order is cancelled. The cancelled reason is' + ord.cancel_reason + '. Money is refunded';
                    sqUpdate.add(sq);
                }

            }
        }
        System.debug('&&&&&&&&&&&&&&' + sqUpdate);
        //Updating Service Quote
        if (sqUpdate.size() > 0)
        {
              Database.saveresult[] sr = Database.update(sqUpdate, False);
              ErrorLogUtility.processErrorLogs(sr, sqUpdate, 'OrderUpdationShopify', 'doPost', 'Service_Quote__c', 'Update');           
        }
    }
}