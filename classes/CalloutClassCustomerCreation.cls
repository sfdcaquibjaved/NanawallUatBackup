/**********************************************************************
Apex Class: CalloutClassCustomerCreation 
Description: This class is used to make mock callouts for customer Creation in shopify
Created Date: 3rd May,2016            
***********************************************************************/
public with sharing class CalloutClassCustomerCreation {
    public static HttpResponse getInfoFromExternalService() {
        HttpRequest req = new HttpRequest();
        string s = label.Site_URL_Shopify_Batch;
        req.setEndpoint(s);
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
}