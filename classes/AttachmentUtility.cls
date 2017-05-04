/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 06-June-2016
    @ Test File     : ATtachmentUtility_Test
    @ Description   : This class serves the pupose of utility class for Attachment_Created trigger
    @ Audit Trial   : 
    @ Last Modified Date : 07-June-2016
  
****************************************************************************/ 

public class AttachmentUtility {

        /*  
         Method Name    : AttachmentHandler
         Purpose        : This Method serves the pupose of handling attachment in email to case functionality.
         Input Parameter: List of attachment  
         Created Date: June 2016
         */
    public static void AttachmentHandler(List < attachment > newAttachment) {
        list < EmailMessage > EmailList = new list < EmailMessage > ();
        Set < String > allEmails = new Set < String > ();
        Set < id > CaseSet = new set < id > ();
        list < case >CaseList = new list <case >();
        list <case >CaseList2 = new list < case >();

        if (HelperClass.firstRun) {
            for (Attachment att: newAttachment) {
                if (att.Description != 'emailToCaseAttachment')
                    allEmails.add(att.ParentId);
            }
            EmailList = [select id, parentid from EmailMessage where id =: allEmails];
            if (EmailList.size() > 0) {
                for (EmailMessage em: EmailList) {
                    caseSet.add(em.parentid);
                }
            }
            CaseList = [select id, dummy__c from
                case where id IN:
                    caseSet
            ];
            for (
                case c:
                    CaseList) {
                c.dummy__c = true;
                caseList2.add(c);
            }
            try {
                update CaseList2;
            } catch (exception e) {
                system.debug('Exception is:' + e);
            }

        }
    }
    
    
     /* 
         Method Name    : moveAttachment
         Purpose        : This Method serves the pupose of moving signature attachment on Installation form to files and deleting attachment.
         Input Parameter: List of attachment  
         Created Date: April 2017
         */
    
    public static void moveAttachment(List < attachment > newAttachment) {
        
        set<ID> AttachmentID = new set<ID> () ;
        String insfprefix;
        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe();
       
        //Getting ID of Installation Form Object
        for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
            if(r.getName() == 'Installation_Form__c'){
                insfprefix = r.getKeyPrefix();
            }
        }
        
        List < ContentVersion > ContentVersionInsert = new List <ContentVersion>() ;
        
        for(Attachment a:newAttachment) {
            string myIdPrefix = String.valueOf(a.parentId).substring(0,3); 
            if(myIdPrefix.equals(insfprefix) && (a.name == 'Signature.png')){
                
                ContentVersion cont = new ContentVersion();
                cont.versionData = a.Body;
                cont.title = 'eSignature_dtd_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss')+'.png';
                cont.pathOnClient ='eSignature_dtd_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss')+'.png';
                
                ContentVersionInsert.add(cont);
                AttachmentID.add(a.ID);
                
            }
        }
        
        try{
            if(ContentVersionInsert.size() > 0){
            //Inserting ContentVersion
            insert ContentVersionInsert ;
            }
        }
        catch(exception e){
            system.debug('Exception is:' +e);
        }

        List <FeedItem> FeedItemContentList = new List <FeedItem> () ;
        List<Attachment> AttachmentDelete = new List <Attachment> () ;
        
        for(ContentVersion C : ContentVersionInsert ){
            for(Attachment a : newAttachment ){ 
                if(c.versionData == a.Body ){
                    //Attaching FeedItem to ContentVersion and InstallationForm
                    FeedItem elm = new FeedItem(Body = 'Post with related document body', ParentId = a.parentid, RelatedRecordId = c.ID, Type = 'ContentPost');
                    FeedItemContentList.add(elm);
                    
                }
            }
        }
        
        try{
            if(FeedItemContentList.size() > 0){
            //Insert FeedItem
          		  insert FeedItemContentList ;
            }
            if(AttachmentID.size() > 0){
            //Delete Attachment
          		  Delete [select id from Attachment where id in :AttachmentID];
            }
            
            
        }
        catch(exception e)
        {
            system.debug('Exception is ' +e);
        }
        
    }
    /*  
         Method Name    : moveuploads
         Purpose        : This Method serves the pupose of moving all attachments on Installation to files and deleting attachment.
         Input Parameter: List of attachment  
         Created Date: April 2017
         */
    public static void moveuploads(List < attachment > newAttachment) {
        
        set<ID> AttachmentID = new set<ID> () ;
        String instprefix;
        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe();
       
        //Getting ID of Installation Object
        for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
            if(r.getName() == 'Installation__c' ) {
               instprefix = r.getKeyPrefix();
            }
        }
        
        List < ContentVersion > ContentVersionInsert = new List <ContentVersion>() ;
        
        for(Attachment a:newAttachment) {
            string myIdPrefix = String.valueOf(a.parentId).substring(0,3); 
            if(myIdPrefix.equals(instprefix)){
                System.debug('in here');
                ContentVersion cont = new ContentVersion();
                cont.versionData = a.Body;
                cont.title = a.Name;
                cont.pathOnClient = a.Name;
                
                ContentVersionInsert.add(cont);
                AttachmentID.add(a.ID);
                
            }
        }
        
        try{
            if(ContentVersionInsert.size() > 0){
                //Inserting ContentVersion
                insert ContentVersionInsert ;
                system.debug('I am here with ContentVersion' +ContentVersionInsert);
            }
        }
        catch(exception e){
            system.debug('Exception is:' +e);
        }

        List <FeedItem> FeedItemContentList = new List <FeedItem> () ;
        List<Attachment> AttachmentDelete = new List <Attachment> () ;
        
        for(ContentVersion C : ContentVersionInsert ){
            for(Attachment a : newAttachment ){ 
                if(c.versionData == a.Body ){
                    //Attaching FeedItem to ContentVersion and InstallationForm
                    FeedItem elm = new FeedItem(Body = 'Post with related document body', ParentId = a.parentid, RelatedRecordId = c.ID, Type = 'ContentPost');
                    FeedItemContentList.add(elm);
                    
                }
            }
        }
        
        try{
            if(FeedItemContentList.size() > 0){
            //Insert FeedItem
            	insert FeedItemContentList ;
            }
            if(AttachmentID.size() > 0){
            //Delete Attachment
            	Delete [select id from Attachment where id in :AttachmentID];
            }
            
            
        }
        catch(exception e)
        {
            system.debug('Exception is ' +e);
        }
        
    }
    /*  
         Method Name    : movecaseuploads
         Purpose        : This Method serves the pupose of moving all attachments on Cases related to Installations to files and deleting attachment.
         Input Parameter: List of attachment  
         Created Date: April 2017
         */
    public static void movecaseuploads(List < attachment > newAttachment) {
        
        set<ID> AttachmentID = new set<ID> () ;
        String caseprefix;
        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe();
       
        //Getting ID of Installation Object
        for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                if(r.getName() == 'Case'){
                caseprefix = r.getKeyPrefix();
                System.debug('case'+caseprefix);
            }
        }
        
        List < ContentVersion > ContentVersionInsert = new List <ContentVersion>() ;
        
        for(Attachment a:newAttachment) {
            string myIdPrefix = String.valueOf(a.parentId).substring(0,3); 
            string aname = String.valueOf(a.name).substring(0,4);
            if(myIdPrefix.equals(caseprefix) && aname == 'INS_'){
                System.debug('in here');
                ContentVersion cont = new ContentVersion();
                cont.versionData = a.Body;
                cont.title = a.Name;
                cont.pathOnClient = a.Name;
                
                ContentVersionInsert.add(cont);
                AttachmentID.add(a.ID);
                
            }
        }
        System.debug('list'+ContentVersionInsert);
        try{
            if(ContentVersionInsert.size() > 0){
            //Inserting ContentVersion
            	insert ContentVersionInsert ;
            }
            System.debug('Success !');
        }
        catch(exception e){
            system.debug('Exception is:' +e);
            System.debug('catch');
        }

        List <FeedItem> FeedItemContentList = new List <FeedItem> () ;
        List<Attachment> AttachmentDelete = new List <Attachment> () ;
        
        for(ContentVersion C : ContentVersionInsert ){
            for(Attachment a : newAttachment ){ 
                if(c.versionData == a.Body ){
                    System.debug('is it equal?');
                    //Attaching FeedItem to ContentVersion and InstallationForm
                    FeedItem elm = new FeedItem(Body = 'Post with related document body', ParentId = a.parentid, RelatedRecordId = c.ID, Type = 'ContentPost');
                    FeedItemContentList.add(elm);
                    
                }
            }
        }
        System.debug('feed list'+FeedItemContentList);
        try{
            if(FeedItemContentList.size() > 0 ){
            //Insert FeedItem
            	insert FeedItemContentList ;
            	System.debug('Success 2!');
            }
            if(AttachmentID.size() > 0){
            //Delete Attachment
            Delete [select id from Attachment where id in :AttachmentID];
          System.debug('Success 3!');   
            }
        }
        catch(exception e)
        {
            system.debug('Exception is ' +e);
        }
        
    }
    
}