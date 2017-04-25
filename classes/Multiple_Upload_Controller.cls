global class Multiple_Upload_Controller {
public string recrdId{get; set;}
    public Multiple_Upload_Controller()
    {
            
    }
    @RemoteAction
    global static String attachBlob(String parentId, String attachmentId, String fileName, String contentType, String base64BlobValue){
        /*
        parentId: The sfdc object Id this file will be attached to
        attachmentId: The record of the current Attachment file being processed
        fileName: Name of the attachment
        contentTye: Content Type of the file being attached
        base64BlobValue: Base64 encoded string of the file piece currently processing
        */
               
        //If recordId is blank this is the first part of a multi piece upload
        list<Attachment> toinsert = new list<Attachment>();
        if(attachmentId == '' || attachmentId == null){
            Attachment att = new Attachment(
                ParentId = parentId,
                Body = EncodingUtil.Base64Decode(base64BlobValue),
                Name = 'INS_'+fileName ,
                ContentType = contentType
            );
            insert att;
           ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, att.Name + ' File uploaded successfully'));
            //Return the new attachment Id
            return att.id;
        }else{
            for(Attachment atm : [select Id, Name, Body from Attachment where Id = :attachmentId]){
                //Take the body of the current attachment, convert to base64 string, append base64 value sent from page, then convert back to binary for the body
                update new Attachment(Id = attachmentId, Name = 'INS_'+fileName,Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body) + base64BlobValue));
            }
            //Return the Id of the attachment we are currently processing
            //return attachmentId;
            return attachmentId;
        }
        
    }
}