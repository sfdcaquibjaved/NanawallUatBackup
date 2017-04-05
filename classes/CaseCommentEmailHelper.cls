/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 12-May-2016
    @ Test File     : 
    @ Description   : To send out email notification to all case team member if the comment added on the case is public
    @ Audit Trial   : Added comments
    @ Last Modified Date : 09-June-2016
  
****************************************************************************/ 


public class CaseCommentEmailHelper {
    
       /*   
         Method Name    : SendCaseCommentEmail
         Purpose        : Sends out email notification to case team member on each public case comment
         Input Parameter: List of case comment  
         Created Date: May 2016
         */

    public void SendCaseCommentEmail(List < CaseComment > newTrigger) {
       
        //Local variables
        Set < id > parentCaseIds = new Set < id > ();
        Set < id > CommentedUsers = new Set < id > (); // To set the reply-to Address
        set < id > ContactMembers = new Set < id > ();
        Set < id > UserMembers = new set < id > ();

        List < CaseComment > isValidComment = new List < CaseComment > ();

        for (CaseComment CC: newTrigger) {
        //Only if comment is public, send out emails  
          if (CC.IsPublished == true)  
            {

                isValidComment.add(CC);
                parentCaseIds.add(CC.ParentId);
                CommentedUsers.add(CC.LastModifiedById);
            }
        }

        if (isValidComment.size() > 0) {
            Map < id, Case > CaseObjs = new Map < id, Case > ([select Id, Description,
                Owner.Email, CaseNumber, Subject
                from Case where id in: parentCaseIds
            ]); 
            // Query all case related Data
            Map < id, List < id >> CaseToUserCaseTeamMembersMap = new Map < id, List < id >> (); 
            // Query Case Team Members
            Map < id, List < id >> CaseToContactCaseTeamMembersMap = new Map < id, List < id >> ();



            for (CaseTeamMember CTMember: [SELECT Id, MemberId, ParentId FROM CaseTeamMember WHERE ParentId in: parentCaseIds ]) {

                if (!isContactID(CTMember.MemberID)) {
                    if (CaseToUserCaseTeamMembersMap.get(CTMember.ParentID) != null)
                        CaseToUserCaseTeamMembersMap.get(CTMember.ParentID).add(CTMember.MemberID);
                    //Add to the list of User Members
                    else
                        CaseToUserCaseTeamMembersMap.put(CTMember.ParentID, new id[] {
                            CTMember.MemberID
                        });
                    //Create a new List for the case and add the memeber to it

                    UserMembers.add(CTMember.MemberID);
                } else if (isContactID(CTMember.MemberID)) {
                    if (CaseToContactCaseTeamMembersMap.get(CTMember.ParentID) != null)
                        CaseToContactCaseTeamMembersMap.get(CTMember.ParentID).add(CTMember.MemberID);
                    //Add to the list of Contact Members
                    else
                        CaseToContactCaseTeamMembersMap.put(CTMember.ParentID, new id[] {
                            CTMember.MemberID
                        });
                    //Create a new List for the case and add the memeber to it

                    ContactMembers.add(CTMember.MemberID);
                }
            }

            Map < id, User > UserObjs;
            Map < id, Contact > ContactObjs;

            if ((CommentedUsers.size() > 0) || (!CaseToUserCaseTeamMembersMap.isEmpty()))
                UserObjs = new Map < id, User > ([select id, Email from
                    User where ID in: CommentedUsers OR ID in: UserMembers
                ]);
            //Query all User Required Data 

            if (!CaseToContactCaseTeamMembersMap.isEmpty())
                ContactObjs = new Map < id, Contact > ([select id, Email from Contact
                    where ID in: ContactMembers AND Email != NULL AND Email != ''
                ]);

            for (CaseComment CC: newTrigger) {
                List < String > toAddresses = new List < String > ();

                // Add Users in case Team to email list    
                if ((!CaseToUserCaseTeamMembersMap.isEmpty()) && CaseToUserCaseTeamMembersMap.get(CC.ParentId).size() > 0)
                    toAddresses.addall(getUserEmailList(UserObjs, CaseToUserCaseTeamMembersMap.get(CC.ParentId)));
                //Add Contacts in Case Team to Email List
                if ((!CaseToContactCaseTeamMembersMap.isEmpty()) &&
                    CaseToContactCaseTeamMembersMap.get(CC.ParentId).size() > 0)
                    toAddresses.addall(getContactEmailList(ContactObjs, CaseToContactCaseTeamMembersMap.get(CC.ParentId)));

                if (toAddresses.size() > 0)
                    SendCommentEmail(toAddresses, UserObjs.get(CC.LastModifiedById).Email, CaseObjs.get(CC.parentId), CC.CommentBody);
            }
        }

    }

    //=============== Private Methods ===================
    
    /*  
         Method Name    : getUserEmailList
         Purpose        : To get the email addresses of all users in case team member
         Input Parameter: Map of id and User and List of User id  
         Created Date   : May 2016
         */
    private List < String > getUserEmailList(Map < id, User > UserObjs, List < ID > UserIds) {
        List < String > UserEmailList = new List < String > ();
        if (UserIds != null && UserObjs != null) {
            for (Id userId: UserIDs) {
                if (UserObjs.get(userId) != null)
                    UserEmailList.add(UserObjs.get(userId).Email);
            }
        }
        return UserEmailList;
    }
    
        /*  
         Method Name    : getContactEmailList
         Purpose        : To get the email addresses of contacts in case team member
         Input Parameter: Map of id and Contact and List of Contact id  
         Created Date   : May 2016
         */
    @TestVisible
    private List < String > getContactEmailList(Map < id, Contact > ContactObjs, List < ID > ContactIds) {
        List < String > ContactEmailList = new List < String > ();
        if (ContactIds != null && ContactObjs != null) {
            for (Id ContactId: ContactIds) {
                if (ContactObjs.get(ContactId) != null)
                    ContactEmailList.add(ContactObjs.get(ContactId).Email);
            }
        }
        return ContactEmailList;
    }

    /*  
         Method Name    : SendCommentEmail
         Purpose        : To send comment notification to case team member
         Input Parameter: List of String , String , Case and String
         Created Date   : May 2016
         */
    private void SendCommentEmail(List < String > toAddresses, string replyTo, Case CurrentCase, string CommentBody) {
        case c = [select id, CaseNumber, Category__c, Subject, Priority, Description from
            case where id = :
                CurrentCase.id
        ];
        String CaseLink = System.URL.getSalesforceBaseUrl().toExternalForm().remove('-api') + '/' + CurrentCase.Id;
        string TXTEmailBody = StringVariablesHelper.Welcome +
        '\n\n'+StringVariablesHelper.CaseNumber + c.CaseNumber +
        '\n---------------------------------------------' +
        +'\n'+StringVariablesHelper.problemType + c.Category__c +
        '\n---------------------------------------------' +
        +'\n'+StringVariablesHelper.Order + c.Order_Number_formula__c +
        '\n---------------------------------------------' +
        +'\n'+ StringVariablesHelper.Subject + c.Subject +
        '\n---------------------------------------------' +
        +'\n'+StringVariablesHelper.Priority + c.Priority +
        '\n---------------------------------------------' +
        +'\n'+StringVariablesHelper.Description + c.Description +
        '\n-----------------------------------------------------------------------------------------------' +
        +'\n\n'+StringVariablesHelper.Comment +
        +'\n\nHi,' +
        '\n\n' + CommentBody +
        '\n-----------------------------------------------------------------------------------------------' +
        +'\n'+StringVariablesHelper.link + CaseLink +
        '\n\n'+ StringVariablesHelper.Thanks;

        string Subject = StringVariablesHelper.CaseName + CurrentCase.CaseNumber + ': ' +
        (String.isNotBlank(CurrentCase.Subject) ? CurrentCase.Subject : ' ') +
        StringVariablesHelper.Updated;

        // Send Email
       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setReplyTo(replyTo);
        mail.setSubject(Subject);
        mail.setUseSignature(false);
        mail.setPlainTextBody(TXTEmailBody);
        try{
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
                });
        }
        catch(exception e)
        {
            system.debug('Exception is:' +e);
        }

    }

     /* 
         Method Name    : isContactID
         Purpose        : To check if the id passed is of contact type
         Input Parameter: Id 
         Created Date   : May 2016
         */
    private boolean isContactID(id IdInQuestion) {
        return (IdInQuestion.getSObjectType() == Contact.sObjectType);
    }
}