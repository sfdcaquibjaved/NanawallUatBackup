@RestResource(urlMapping='/v1/case2/*')
global with sharing class integrateCase2 {
  /*  
    @HttpGet
    global static void getIntgCase() {
        RestContext.response.addHeader('Content-Type', 'Application/JSON');
        RestRequest req2 = RestContext.request; 
        RestResponse res = RestContext.Response;  
            
        String caseId = req2.requestURI.substring(req2.requestURI.lastIndexOf('/')+1);
        system.debug('@@@@@@@@@'+caseId);                      
              
        case result =[SELECT id,CaseNumber,Status FROM case WHERE CaseNumber = :caseId];
        system.debug('#######'+result);
        
        string s = result.Status;
        String EventsJSON = JSON.serialize(result); 
        //RestContext.response.responseBody = Blob.valueof(EventsJSON);
        getIntgCase2(s);
             
    }
   
    @future(callout=true)
    public static void getIntgCase2(string cs) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            String url = 'file:///Users/satishlokinindi/Documents/BracketsCODE/SamplePage.html';
            string endPointValue = url;
            req.setEndpoint(endPointValue);
            req.setHeader('content-type', 'application/json');
            req.setHeader('Accept', 'application/json');
             string data;
            //Adding Service quote data to the body
            data='{"case": {"Status":'
            +cs+'}}';
            
            //Using PUT Method to update the existing record in Shopify 
            req.setMethod('PUT');
            req.setBody(data);
            try {
                HttpResponse res2 = h.send(req);
            } catch (exception e) {
            System.debug('eee' + e);
            }
    }*/
    }