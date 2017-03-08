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
}