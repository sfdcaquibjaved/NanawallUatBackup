global class AttachmentTOFileConversion implements Database.Batchable < sObject >
//implements Database.Batchable < sObject >
 {
  //Start method of the batch class
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name,Phone FROM Installation__c';
        return Database.getQueryLocator(query);
    }
    
    //Execute method of the batch class
     global void execute(Database.BatchableContext BC, List<Installation__c> scope)
    {
    
    set<id> insId = new set<id>();
    for(Installation__c ins:scope){
    insId.add(ins.id);
    }
      List<attachment> attList=[select id,ParentId,Name,Body,ContentType,BodyLength from attachment where ParentId=:insId];
      List<ContentDocument> ListCnd=new List<ContentDocument>();
      List<ContentVersion> versions = new List<ContentVersion>();
      
      for(Installation__c ins:scope){
      
            for ( attachment att: attList)
            {
            if(ins.id==att.ParentId){
           
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        
        //cv.FileType=att.ContentType;
        versions.add(cv);
        //cv.ContentDocumentId = contentDocumentId;
        //cv.VersionData = EncodingUtil.base64Decode(EncodingUtil.urlDecode(base64Data, 'UTF-8'));
        //cv.Title = fileName;
        //cv.PathOnClient = filename;
        
        //insert cv;                          

             }
            }
        }
        insert versions;
        //insert ListCnd;
    }  

    //Finish method of the batch class
    global void finish(Database.BatchableContext BC)
    {
    }
}