/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : May-2016
    @ Description   : This class copies attachments in emails to attachments in case
    @ Audit Trial   : Added comments and exception handling for DML operation
    @ Test Class    :
    @ Last Modified Date : 08-June-2016
  
****************************************************************************/
public class emailAttachmentsCopyToCase {

       /*   
         Method Name    : copyEmailAttachmentsToCase
         Purpose        : This Method serves the pupose of handling attachment in web to case functionality.
         Input Parameter: Set of Email Message 
         Created Date   : May 2016
         */
    public static void copyEmailAttachmentsToCase(set < EmailMessage > emailMessageSet) {

        list <case >caseUpdateList = new list < case >();
        list < Attachment > attachmentInsertList = new list < Attachment > ();
        set < id > emailMessageId = new set < id > ();
        set < id > CaseId = new set < id > ();
        for (EmailMessage emsg: emailMessageSet) {
            emailMessageId.add(emsg.id);
            Caseid.add(emsg.parentid);
        }
       
        for (case c: [select id, dummy__c from case where id IN: Caseid]) {
            c.dummy__c = False;
            caseUpdateList.add(c);
        }

        list < Attachment > attachmentList = [select id, Name, body, parentid from Attachment where parentid IN: emailmessageId];       
        map<string, set< Attachment >> emailMap = new map<string, set< Attachment >>();
        for (EmailMessage em: emailMessageSet) 
        {
            set< Attachment > attachmentSet =  new set< Attachment >();
            for (Attachment at: attachmentList) 
            {
               if (em.id == at.parentid) 
               {             
                   attachmentSet.add(at);        
               }                 
           }
           emailMap.put(em.id, attachmentSet);
        }
        
        for (EmailMessage em: emailMessageSet) {
            for (Attachment at: emailMap.get(em.id)) 
            {              
                    Attachment attach = new Attachment();
                    attach.body = at.body;
                    attach.Name = at.Name;
                    attach.parentid = em.parentid;
                    attachmentInsertList.add(attach);              
            }
        }

        if (attachmentInsertList.size() > 0) {
            try {
                insert attachmentInsertList;
            } catch (exception e) {
                system.debug('Exception is:' + e);
            }
        }
        if (caseUpdateList.size() > 0) {
            try {
                update caseUpdateList;
            } catch (exception e) {
                system.debug('Exception is:' + e);
            }
        }
    }

}