/**********************************************************************
Apex Class: CalloutClass 
Description: This class is used to make mock callouts
Created Date: 3rd May,2016            
***********************************************************************/

public with sharing class CalloutClass {
//@future(callout=true)
    public static HttpResponse getInfoFromExternalService() {
        HttpRequest req = new HttpRequest();
        string s = label.Site_URL_Order_Creation;
        req.setEndpoint(s);
        req.setMethod('POST');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
}