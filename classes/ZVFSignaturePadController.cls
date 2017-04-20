public class ZVFSignaturePadController {
    public ZVFSignaturePadController(ApexPages.StandardController stdController){
        
    }
    
    @RemoteAction
    public static String uploadSignature(String b64SignData, String id){
        returnData ret = new returnData();
        ret.success = true;
        ret.message = 'Signature uploaded successfully';
        try{
            Blob signature = EncodingUtil.base64Decode(b64SignData);
            Attachment att = new Attachment();
            att.body = signature;
            att.ContentType = 'image/png';
            att.name = 'eSignature_dtd_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss');
            att.IsPrivate = false;
            att.ParentId = id;
            insert att;
        }catch(Exception e){
            ret.success = false;
            ret.message = e.getMessage();
        }    
        
        return JSON.serialize(ret);
    }
    
    
     private class returnData{
        Boolean success {get;set;}
        String message {get;set;}
    }
}