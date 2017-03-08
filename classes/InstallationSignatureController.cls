/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : June-2016
    @ Description   : Extension class for InstallationSignature page 
    @ Audit Trial   : Added comments
    @ Test Class    : InstallationSignatureControllerTest
    @ Last Modified Date : 02-July-2016
  
****************************************************************************/
public class InstallationSignatureController {
    public Installation_Form__c ins {
        get;
        set;
    }
    

    public InstallationSignatureController(ApexPages.StandardController stdController){
     }
    
              /*
             Method Name: uploadSignature
             Purpose: To handle signatureon InstallationSignature page
             Created Date: June 2016
             */
    
    @RemoteAction
    public static String uploadSignature(String b64SignData, String id){
       
        
        returnData ret = new returnData();
        system.debug('Blob is:'+b64SignData);
        ret.success = true;
        ret.message = 'Signature uploaded successfully';
        try{
             Blob signature = EncodingUtil.base64Decode(b64SignData);
            Attachment att = new Attachment();
          /*  att.body = signature;
            att.ContentType = 'image/png';
            att.name = 'eSignature_dtd_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss')+'.png';
            att.IsPrivate = false;
            att.ParentId = id;
            insert att; */
            
            ContentVersion cont = new ContentVersion();
            cont.versionData = signature;
        	cont.title = 'eSignature_dtd_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss')+'.png';
       		cont.pathOnClient ='eSignature_dtd_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss')+'.png';
            system.debug('Value of cont' +cont);
            try{
                system.debug('I am here');
            	insert cont ;
                system.debug('I am here after insertion');
            }
            catch(exception e){
                system.debug('Exception is:' +e);
            }
            
            FeedItem elm = new FeedItem(Body = 'Post with related document body', ParentId = id, RelatedRecordId = cont.ID, Type = 'ContentPost');
            try{
            insert elm;
            }
            catch(Exception e){
                system.debug('Exception is:' +e.getMessage());
            }
            
            
            
        }catch(Exception e){
            ret.success = false;
            ret.message = e.getMessage();
            system.debug('Exception is:'+e);
        }    
        
        return JSON.serialize(ret);
    }
    
    
     private class returnData{
        Boolean success {get;set;}
        String message {get;set;}
    }
}