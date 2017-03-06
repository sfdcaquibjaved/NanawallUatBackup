/**********************************************************************
Apex Class: PostingCaseNumberOnShopify
Description: This Callout class is used to post case number on shopify Notes Section
Created Date: 25th April,2016            
***********************************************************************/
public class PostingCaseNumberOnShopify{
    
//This method is used to Post Case Number on Shopify Notes Section on creation of service quote in Salesforce   
@Future(callout=true)
    public static void CaseNumberOnShopifyOrder(string shopifyid, string Notes)
    {
            service_Quote__c sq = [select id, Shopify_ID__c, case__r.CaseNumber from service_quote__c where id=: shopifyid];
            
            //Making HTTP Callouts for Shopify admin page
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            //Fetching Shopify Admin page URL from label
            String url = label.Shopify_Store_URL;
            string endPointValue = url + '/admin/orders/'+sq.Shopify_ID__c+'.json';
            System.debug('#########' + endPointValue);
            req.setEndpoint(endPointValue);
            
            //Fetching Shopify Admin Credentials from custom settings
            Shopify_Credentials__c ShopCred = Shopify_Credentials__c.getOrgDefaults();
            String username = ShopCred.User_Name__c;
            String password = ShopCred.Password__c;
    
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('content-type', 'application/json');
            req.setHeader('Accept', 'application/json');
            
            string data;
            //Adding Service quote data to the body
            data='{"order": {"id":'
            +sq.Shopify_ID__c+',"note":"#'
            +sq.case__r.CaseNumber+' '+Notes+'"}}';
            
            //Using PUT Method to update the existing record in Shopify 
            req.setMethod('PUT');
            req.setBody(data);
            try {
                HttpResponse res = h.send(req);
            } catch (exception e) {
            System.debug('eee' + e);
            }
         }
     }