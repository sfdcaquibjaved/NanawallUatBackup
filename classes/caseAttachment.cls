/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 18-May-2016
    @ Description   : To handle attachments on web to case form. Extension of NewServiceRequestForm VF Page
    @ Audit Trial   : Changed line 41 from a single group initialization to a collection
    @ Test Class    :
    @ Last Modified Date : 16-June-2016
  
****************************************************************************/
public class caseAttachment {
    public
    case objCase {
        get;
        set;
    }
    public Account newAccount;
    public Contact newContact;
    public Attachment myAttachment{get;set;}
    public Attachment myAttachment2{get;set;}
     public Attachment myAttachment3{get;set;}
    public string fileName{get;set;}
     public string fileName2{get;set;}
    public string fileName3{get;set;} 
    public Blob fileBody{get;set;}
    public Blob fileBody2{get;set;}
    public Blob fileBody3{get;set;}
 
    //constructor
    public caseattachment(Apexpages.standardcontroller controller) {
        
        
        Group[] g = [Select Id from Group where name =: 'Web to Case' Limit 1];
    
            
        objcase = new case ();
        objcase.ownerId = g[0].id;


        
    }

    /*  
         Method Name    : SaveAttachments
         Purpose        : This Method serves the pupose of handling attachment in web to case functionality.
         Input Parameter: N/A 
         Created Date   : May 2016
         */
    public Pagereference SaveAttachments() {
        system.debug('Inside Save Attachment');
        if (objcase.Email_Address__c != null) {
            //attach case to contact and account based on the email id given
            list < contact > contactid = [SELECT id, email, AccountId FROM Contact WHERE email =: objcase.Email_Address__c LIMIT 1];
            // if email is associated with any contact link it with the case
            if (contactid.size() > 0 && contactid != null ) {
                System.debug('contact id' + contactid[0].id);
                objcase.ContactId = contactid[0].id;
                System.debug('case contact id' + contactid[0].id);
                objcase.AccountId = contactid[0].Accountid;
            }
            // if the email is not associated with any case create a new account and contact and then link them with the case
            else {
                newAccount = new Account();
                newAccount.BillingPostalCode = objCase.Project_Site_Zip_Postal_Code__c;
                newAccount.Name = objcase.Company_Name__c;
                try {
                    insert newAccount;
                } catch (exception e) {
                    system.debug('exception is :' + e) ; 
                }
                system.debug(objCase);
                system.debug(objCase.Project_Site_Street_Address__c);
                newContact = new Contact();
                newContact.FirstName = objCase.Other_First_Name__c;
                newContact.LastName = objCase.Other_Last_Name__c;
                newContact.Email = objCase.Email_Address__c;
                newContact.Phone = objCase.SuppliedPhone;
                newContact.MailingStreet = objCase.Project_Site_Street_Address__c;
                newContact.MailingCity = objCase.Project_Site_City__c;
                newContact.MailingState = objCase.Project_Site_State__c;
                newContact.MailingCountry = objCase.Project_Site_Country__c;
                newContact.MailingPostalCode = objCase.Project_Site_Zip_Postal_Code__c;
                newContact.AccountId = newAccount.id;
                try {
                    insert newContact;
                } catch (exception e) {
                    system.debug('exception is :' + e) ;
                }
                objCase.ContactId = newContact.id;
                objCase.AccountId = newAccount.id;
                
                
                
            }
            
           
            
        }
        
        

        try {
            insert objcase;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
       
        if(objcase.Order_Number__c != null){
            system.debug('Order value'+objCase.Order_Number__c );
           // string OrdNum = '00' + String.valueOf(objCase.Order_Number__c) ; 
            list < Quote__c > orderId = [SELECT id , Order_Number__c FROM Quote__c WHERE Order_Number__c =: objCase.Order_Number__c LIMIT 1];
           system.debug('OrderId' + orderId);
            if (orderId.size() > 0){
                system.debug('Inside if');
                objCase.Order__c = orderId[0].id ; 
                EmailTemplate templateId = [Select id from EmailTemplate where name = 'Support: Case Created (Web to case)' Limit 1];
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(templateId.Id); 
                // Who you are sending the email to
                mail.setTargetObjectId(objCase.ContactId);
                mail.setSenderDisplayName('Nanawall Support');
                mail.setSaveAsActivity(false);
                mail.setWhatId(objCase.id);
                allmsg.add(mail);
            //    Messaging.sendEmail(allmsg,false);
                if (!allmsg.isEmpty()) {
                    try {
                        Messaging.SendEmail(allmsg);
                    } catch (exception e) {
                        system.debug('Exception is:' + e);
                    }
        }

            }
            else {
                
             system.debug('Inside else');
             EmailTemplate templateId = [Select id from EmailTemplate where name = 'Support: Case Created (Web to case) - No Order'  Limit 1];              
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(templateId.Id); 
                // Who you are sending the email to
                mail.setTargetObjectId(objCase.ContactId);
               
                mail.setSenderDisplayName('Nanawall Support');
                mail.setSaveAsActivity(false);
                mail.setWhatId(objCase.id);
                allmsg.add(mail);
              // Messaging.sendEmail(allmsg,false);
                if (!allmsg.isEmpty()) {
                    try {
                        system.debug('Inside try of sending mail');
                        Messaging.SendEmail(allmsg);
                    } catch (exception e) {
                        system.debug('Inside exception test');
                        system.debug('Exception is:' + e);
                    }
                }
            }
        }
            else{
                system.debug('Inside else');
             EmailTemplate templateId = [Select id from EmailTemplate where name = 'Support: Case Created (Web to case) - No Order'  Limit 1];              
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateID(templateId.Id); 
                // Who you are sending the email to
                mail.setTargetObjectId(objCase.ContactId);
                mail.setSenderDisplayName('Nanawall Support');
                mail.setSaveAsActivity(false);
                mail.setWhatId(objCase.id);
                allmsg.add(mail);
              //  Messaging.sendEmail(allmsg,false);
                if (!allmsg.isEmpty()) {
                    try {
                        system.debug('Inside try');
                        Messaging.SendEmail(allmsg);
                    } catch (exception e) {
                        system.debug('Exception is:' + e);
                    }
                }
                
            }
            
            
       
         try {
            update objcase;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }

        String caseId = objcase.id;
        if (caseId == null || caseId == '')
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, 'No record is associated. Please pass record Id in parameter.'));


        List < Attachment > listToInsert = new List < Attachment > ();
        if(fileBody <> null && filename <>null){                  
                               
              System.debug('@@@@@fileBody'+fileBody);     
              myAttachment  = new Attachment();
              myAttachment .clear();
              myAttachment.Body = fileBody; 
              string ext1 = '.'+filename.substringafter('.');
              myAttachment.Name = 'Attachment 1'+ext1;
              myAttachment.ParentId = objcase.id;
               listToInsert.add(myAttachment) ;
                         
              }
              if(fileBody2 <> null && filename2 <>null)
              {
               myAttachment2 = new Attachment();
               myAttachment2 .clear();
               myAttachment2.Body = fileBody2; 
               string ext2 = '.'+filename2.substringafter('.');
               myAttachment2.Name = 'Attachment 2'+ext2;
               myAttachment2.ParentId = objcase.id;  
                 listToInsert.add(myAttachment2) ;      
              }
              if(fileBody3 <> null && filename3 <>null)
              {
               myAttachment3 = new Attachment();
               myAttachment3.clear();
               myAttachment3.Body = fileBody3; 
               string ext3 = '.'+filename3.substringafter('.');
               myAttachment3.Name = 'Attachment 3'+ext3;
               myAttachment3.ParentId = objcase.id;  
                 listToInsert.add(myAttachment3) ;    
              }
        

     

        //Inserting attachments
        if (listToInsert.size() > 0) {
            insert listToInsert;
            pagereference pr = new pagereference('http://www.nanawall.com/');
            return pr;
        }

        pagereference pr = new pagereference('http://www.nanawall.com/');
        return pr;
    }

   


    /* To transfer email attachment to attachment 
Trigger associated with: emailMessageTrigger
         */
    @future
    public static void attins(set < id > EmailId, map < id, id > caseid) {
        list < Attachment > Attachmentlist = new list < Attachment > ();


        for (attachment attlist: [select id, name, body, parentid from Attachment where parentid IN: EmailId]) {
            Attachment newattch = new Attachment();
            newAttch.body = attlist.body; // required field
            newAttch.name = attlist.name; // required field  
            newAttch.parentId = caseid.get(attlist.parentid); //required field
            newattch.Description = 'emailToCaseAttachment';
            Attachmentlist.add(newattch);
        }
        try {
            insert Attachmentlist;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }

        System.debug('att:' + Attachmentlist);
    }
    @future
    public static void insertfirstemail(set < id > caseid) {
        system.debug('Inside future');
        list <
            case >caseUpdate = new list <
            case >();
        list <
            case >caseList = [select id, DummyEmailMessage__c from
                case where id IN:
                    caseid
            ];
        for (
            case cs:
                caseList) {
            cs.DummyEmailMessage__c = TRUE;
            caseUpdate.add(cs);
        }
        try {
            update caseUpdate;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        list < casecomment > caseCommentInsert = new list < casecomment > ();
        list < EmailMessage > emailMessageList = [select id, Subject,FromAddress ,ToAddress ,TextBody, ParentId from EmailMessage where ParentId IN: caseid ORDER BY createddate];
        for (EmailMessage em: emailMessageList) {
            casecomment cc = new casecomment();
            cc.CommentBody = '\n\r\n From:'+em.FromAddress+ '\r\n\n' + 'To:'+ em.ToAddress + '\n\r\n' +'Subject: ' + em.Subject + '\r\n' + em.TextBody;
            cc.ParentId = em.ParentId;
            cc.isPublished = False;
            caseCommentInsert.add(cc);
            system.debug('Inside future 2');
        }
        try {
           // insert caseCommentInsert;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
    }

    public static void insertcasecomment(set < id > caseid, map < id, EmailMessage > emailmessageMap) {
        if (HelperClass.firstRun){
        list < casecomment > caseCommentList = new list < casecomment > ();
        list <
            case >caseList = [select id, DummyEmailMessage__c from
                case where id IN:
                    caseid
            ];
        system.debug('Value of caseList' +caseList);
        system.debug('Inside insertcasecomment');
        for (
            case cs:
                caseList) {
            if (cs.DummyEmailMessage__c == TRUE) {
                system.debug('In case attachment if');
                casecomment cc = new casecomment();
                cc.CommentBody = '\n\r\n From:'+emailmessageMap.get(cs.id).FromAddress+ '\r\n\n' + 'To:'+ emailmessageMap.get(cs.id).ToAddress + '\n\r\n' +'Subject: ' +emailmessageMap.get(cs.id).Subject + '\r\n' + emailmessageMap.get(cs.id).TextBody;
                
                
                
                cc.ParentId = emailmessageMap.get(cs.id).ParentId;
                cc.isPublished = FALSE;
                caseCommentList.add(cc);
            }
        }

        if (caseCommentList.size() > 0) {
            try {
               // insert caseCommentList;
            } catch (exception e) {
                system.debug('Exception is:' + e);
            }
        }
            HelperClass.firstRun = FALSE ;
    }
    }

}