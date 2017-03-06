/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 08-June-2016
    @ Test File     : 
    @ Description   : This class serves the pupose of utility class for emailMessage trigger
    @ Audit Trial   : 
    @ Last Modified Date : 08-June-2016
  
****************************************************************************/ 
public class EmailMessageTriggerUtility {
    /*  
         Method Name    : EmailAttachmentHandler
         Purpose        : This method create a new case comment with the content of the email
         Input Parameter: List of attachment  
         Created Date: June 2016
         */
    public static void EmailCommentHandler(List < EmailMessage > NewEmail) {
        List < EmailMessage > emailList = new List < EmailMessage > ();
        List < CaseComment > caseCommentList = new List < CaseComment > ();
        set < id > emailmessageset = new set < id > ();
        set < id > emailMessageCommentSet = new set < id > ();
        map < id, EmailMessage > emailmessageMap = new map < id, EmailMessage > ();
        set < Id > EmailId = new set < id > ();
        map < id, id > caseMapId = new map < id, id > ();
        string mail;
        if (HelperClass.firstRun) {
            
            for (EmailMessage em: NewEmail) {
                if (em.Subject.containsIgnoreCase('Re:')) {
                    if(em.ToAddress.containsIgnoreCase('Service')){
                    
                    mail = Label.EmailTocase2;
                    }
                    else{
                    mail = Label.Email2case;
                    }
                    String Str = em.TextBody.substringBeforeLast(mail);
                    //String Str2 = em.TextBody.substringBeforeLast(mail2);
                    
                    casecomment cc = new casecomment();
                    
                    cc.CommentBody = '\n\r\n From:'+em.FromAddress+ '\r\n\n' + 'To:'+ em.ToAddress + '\n\r\n' +'Subject: ' + em.Subject + '\r\n' + Str;
                    cc.isPublished = True;
                    cc.ParentId = em.ParentId;
                    caseCommentList.add(cc);

                } else if (em.Status == 'New' ) {

                          system.debug('Status value'+em.status);  
                        emailmessageset.add(em.Parentid);


                } else {
                    system.debug('I am here');
                    system.debug('Status value'+em.status); 
                    emailMessageCommentSet.add(em.parentid);
                    emailmessageMap.put(em.parentid, em);
                }
            }
            if (emailmessageset.size() > 0)
                caseAttachment.insertfirstemail(emailmessageset);
            if (caseCommentList.size() > 0) {
                try{
                    insert caseCommentList;
                }
                catch(exception e)
                {
                    system.debug('Exception is:' +e);
             }
            }
            if (emailMessageCommentSet.size() > 0)
            {
                system.debug('The value of emailmessageMap' + emailmessageMap);
                caseAttachment.insertcasecomment(emailMessageCommentSet, emailmessageMap);
            }
            HelperClass.firstRun = false;
        }
        /*  For transferring email attachment to case attachment*/
        
        for (EmailMessage em: NewEmail) {
            EmailId.add(em.id);
            caseMapId.put(em.id, em.ParentId);
        }
        if (EmailId.size() > 0)
            caseattachment.attins(EmailId, caseMapId);

    }

}