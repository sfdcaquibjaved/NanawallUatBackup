/**********************************************************************
Apex Class: CalloutClass_ShopifyBatch
Description: This class is used to create mock callouts for shopify batch class
Created Date: 3rd May,2016            
***********************************************************************/
public with sharing class CalloutClass_ShopifyBatch {
    public static HttpResponse getInfoFromExternalService() {
        HttpRequest req = new HttpRequest();
        string s = label.Shopify_Batch_Order_Fetching;
        req.setEndpoint(s);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
}