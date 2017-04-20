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
            //Inserting ContentVersion
            insert ContentVersionInsert ;
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
            //Insert FeedItem
            insert FeedItemContentList ;
            //Delete Attachment
            Delete [select id from Attachment where id in :AttachmentID];
            
            
        }
        catch(exception e)
        {
            system.debug('Exception is ' +e);
        }
        
    }
    
}