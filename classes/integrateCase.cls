@RestResource(urlMapping='/v1/case/*')
global with sharing class integrateCase {
  
 /* @HttpGet
    global static case getIntgCase() {
        RestRequest req = RestContext.request; 
        RestResponse res = RestContext.Response;      
        String caseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug('@@@@@@@@@'+caseId);                      
              
        case result =[SELECT id,CaseNumber,Status FROM case WHERE CaseNumber = :caseId];
        system.debug('#######'+result);
        return result;
    }*/
    }