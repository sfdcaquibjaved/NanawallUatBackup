/**********************************************************************
Apex Class: OrderDeletionShopify
Description: This REST Web service class is to fetch the data from shopify 
             on Order Deletion
Created Date: 20thApril, 2016            
***********************************************************************/
@RestResource(urlMapping = '/Orderdeletion/*')
global without sharing class OrderDeletionShopify {

    //Global Variables
    static string status = 'Order Deleted';
    
    //This method is used to update service quote on deletion of order in shopify
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
              
        //Updating Service Quote on Shopify Order Deletion
        for (Service_Quote__c sq: [select id, status__c from Service_Quote__c where Shopify_ID__c =: orderId]) {
            for (wrapperObjectShopify ord: ordList) {
                sq.status__c = status;
                sqUpdate.add(sq);
            }
        }
        
        //Updating Service Quote
        if (sqUpdate.size() > 0)
        {
              Database.saveresult[] sr = Database.update(sqUpdate, False);
              ErrorLogUtility.processErrorLogs(sr, sqUpdate, 'OrderDeletionShopify', 'doPost', 'Service_Quote__c', 'Update');           
        }
    }
    
}