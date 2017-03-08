public class projectOwnerAssignment {
    public static boolean validationPass = false;
    public static string userEmail;
    public static string userNam;
    public static string cUrl;
    public static ID profileid;
    public static User activeUser;
    public static void assignOwner(List < project__c > projectValues) {
        set < string > zips = new set < string > ();
        set < string > cntrys = new set < string > ();
        set < string > states = new set < string > ();
        string user, zipDummy;
        for (project__c l: projectValues) {
            if (l.Project_Zip_Code__c != null && l.project_zip_code__c != '' && (l.Project_Country__c == 'United States' || l.Project_Country__c == 'Canada')) {
                if (l.project_country__c == 'Canada') {
                    zips.add(l.project_zip_code__c.substring(0, 3).toUpperCase());
                    zips.add(l.project_zip_code__c.toUpperCase());
                } else if (l.Project_Country__c == 'United States') {
                    zips.add(l.project_zip_code__c.substring(0, 5));
                }
            } else if (l.Project_Country__c != null && l.Project_Country__c != 'United States' && l.Project_Country__c != 'Canada') {
                if (l.project_country__c == 'Mexico') {
                    states.add(l.project_state__c);
                } else cntrys.add(l.Project_Country__c);
            }
        }
        map < string, ID > territoryMap = new map < string, string > ();
        map < string, string > newTerritoryMap = new map < string, string > ();

        for (Zip_Codes_Master__c z: [Select Zip_Code__c, user__c, state__c, country__c, Territory__c from Zip_Codes_Master__c WHERE(Zip_Code__c IN: zips OR country__c IN: cntrys OR state__c IN: states)]) {
            if (z.Zip_Code__c != null && z.zip_code__c != '' && (z.country__c == 'United States' || z.country__c == 'Canada')) {
                territoryMap.put(z.Zip_Code__c, z.user__c);
                newTerritoryMap.put(z.Zip_Code__c, z.Territory__c);
            } else if (z.country__c == 'Mexico') {
                territoryMap.put(z.state__c, z.user__c);
                newTerritoryMap.put(z.state__c, z.Territory__c);
            } else

                territoryMap.put(z.Country__c, z.user__c);
            newTerritoryMap.put(z.Country__c, z.Territory__c);
        }
        system.debug(territoryMap);
        for (project__c l: projectValues) {
            if (l.Project_Zip_Code__c != null && l.project_zip_code__c != '' && (l.Project_Country__c == 'United States' || l.project_country__c == 'Canada')) {
                if (l.project_country__c == 'Canada') {
                    if (territoryMap.containsKey(l.project_zip_code__c.toUpperCase())) {
                        user = territoryMap.get(l.project_zip_code__c.toUpperCase());
                        l.TerritoryName__c = newTerritoryMap.get(l.project_zip_code__c.toUpperCase());
                    } else if (territoryMap.containsKey(l.project_zip_code__c.substring(0, 3).toUpperCase())) {
                        user = territoryMap.get(l.project_zip_code__c.substring(0, 3).toUpperCase());
                        l.TerritoryName__c = newTerritoryMap.get(l.project_zip_code__c.substring(0, 3).toUpperCase());
                    }
                } else if (l.Project_Country__c == 'United States') {
                    user = territoryMap.get(l.project_zip_code__c.substring(0, 5));
                    l.TerritoryName__c = newTerritoryMap.get(l.project_zip_code__c.substring(0, 5));
                }
            } else if (l.Project_Country__c != null) {
                if (l.project_country__c == 'Mexico') {
                    user = territoryMap.get(l.project_state__c);
                    l.TerritoryName__c = newTerritoryMap.get(l.project_state__c);
                } else
                    user = territoryMap.get(l.Project_Country__c);
                l.TerritoryName__c = newTerritoryMap.get(l.Project_Country__c);

            }
            if (user != null) {
                l.OwnerID = user;
            } else
                l.ownerID = id.valueof(system.label.Default_owner); // if(zipDummy != NULL && zipDummy !=''){ l.project_zip_code__c=zipdummy;}
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
    }

    public static boolean validateZip(Project__c pro) {
        set < string > zips = new set < string > ();
        string zipUS = '\\d{5}(-\\d{4})?';
        string zipCan = '((?i)[ABCEGHJKLMNPRSTVXY]\\d[A-Z]?\\s?\\d[A-Z]\\d)?';


        Boolean returnValue = true;

        if ((pro.Project_Country__c == 'United States' || pro.Project_Country__c == 'Canada') && (pro.project_zip_code__c == null || pro.project_zip_code__c == '')) {
            pro.project_zip_code__c.adderror('Please enter a valid Zip code');
            returnValue = false;
            return returnValue;

        }
        if (pro.Project_Country__c != null && (pro.project_zip_code__c != '' || pro.project_zip_code__c != null) && ((pro.Project_Country__c == 'United States' && !(pattern.matches(ZipUS, pro.project_zip_code__c))) || (pro.Project_Country__c == 'Canada' && !(pattern.matches(zipCan, pro.project_zip_code__c))))) {

            pro.project_zip_code__c.adderror('Please enter a valid Zip code');
            returnValue = false;
            return returnValue;
        }
        if (pro.project_zip_code__c != null && pro.project_zip_code__c != '' && pro.Project_Country__c == 'United States') {
            if (pro.Project_Country__c == 'United States') {
                zips.add(pro.project_zip_code__c.substring(0, 5));
            }
            if (zips.size() > 0) {
                list < Zip_Codes_Master__c > z = [Select Zip_Code__c, user__c, state__c, country__c from Zip_Codes_Master__c WHERE Zip_Code__c IN: zips];
                if (z.size() == 0) {
                    pro.project_zip_code__c.addError('Project zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>', false);
                    returnValue = false;
                    return returnValue;
                }
            }
        }

        /*else{ 
        returnValue = true;
        return returnValue ;
        }*/

        system.debug('the return value is' + returnValue);
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
        return returnValue;
        

    }
    public static void updateOppTeam(list < project__c > projValues) {
        set < ID > projIds = new set < ID > ();
        //list < opportunity > updatedopps = new list < opportunity > ();
        List < OpportunityTeamMember > updateOppTeamList = new List < OpportunityTeamMember > ();
        for (project__c vPrj: projValues) {
            projIds.add(vPrj.ID);
        }
        for (project__c oppToUpdate: [SELECT id, ownerID, (SELECT id, ownerID, StageName from Opportunities__r) from project__c where ID in: projIds]) {
            for (Opportunity op: oppToUpdate.opportunities__r) {
                if (op.ownerID != oppToUpdate.ownerID) {
                    OpportunityTeamMember oppTeam = new OpportunityTeamMember();
                    //oppTeam.OpportunityAccessLevel = 'Read';
                    oppTeam.OpportunityId = op.Id;
                    oppTeam.UserId = oppToUpdate.OwnerID;
                    updateOppTeamList.add(oppTeam);
                }


            }
        }

        if (updateOppTeamList.size() > 0) {
            Database.saveresult[] sr = Database.insert(updateOppTeamList, False);
            ErrorLogUtility.processErrorLogs(sr, updateOppTeamList, 'OpportunityHelper', 'updateOppTeam', 'OpportunityTeamMember', 'Insert');

        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

    }
    public static void updateResolutionDate(list < project__c > lstProj) {
        set < ID > stProjIds = new set < ID > ();
        Date minDt = date.newInstance(2999, 12, 12);
        // list < opportunity > updatedopps = new list < opportunity > ();
        List < OpportunityTeamMember > updateOppTeamList = new List < OpportunityTeamMember > ();
        for (project__c vProj: lstProj) {
            stProjIds.add(vProj.ID);
        }
        for (project__c oppToUpdateDate: [SELECT id, ownerID, Close_Date__c, (SELECT id, ownerID, CloseDate, StageName from Opportunities__r) from project__c where ID in: stProjIds]) {
            for (Opportunity op: oppToUpdateDate.opportunities__r) {
                if (op.closeDate < minDt) {
                    minDt = op.closeDate;
                }
            }
            oppToUpdateDate.Close_date__c = minDt;

        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
    }

    /*************************************************
    Added By Satish Lokinindi
    Method Name: createReadOnlyAccessonProjectCreation
    Description: This method is used to create project share record whenever a new Project record is created.
    Input Parameter: list of Project         
    *************************************************/
    
    //to find the context running in sandbox or prod
    public static Boolean runningInASandbox() {
        return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    public static void createReadOnlyAccessonProjectCreation(list < Project__c > projectTriggerlst) {
        set < id > proIds = new set < id > ();
        for (project__c pro: projectTriggerlst) {
            proIds.add(pro.ID);
        }
        //This should only happen only if it is on production
        if (!runningInASandbox()) {
            list < UserRecordAccess > projAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: proIds];

            //To send email notification on cross territory access
            for (UserRecordAccess UR: projAccess) {
                if (UR.HasReadAccess == false) {
                    //Project__c proj =[select id ,Name From Project__c where ID =:proIds];
                    system.debug('*************');
                    List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List < String > sendTo = new List < String > ();
                    sendTo.add(label.TahaEmail);
                    mail.setToAddresses(sendTo);
                    List < String > ccTo = new List < String > ();
                    ccTo.add(label.CCZZalkiflEmail);
                    mail.setCcAddresses(ccTo);
                    mail.setSubject(' Cross Territory Activity ');
                    mail.setReplyTo(UserInfo.getUserEmail());

                    String body = label.ToMail + ',<br>';
                    body += UserInfo.getName() + ' ' + label.EmailBody + ' ' + label.OrgUrl + '/' + UR.RecordId + ' ' + label.EmailBody1;
                    mail.setHtmlBody(body);
                    mails.add(mail);
                    Messaging.sendEmail(mails);

                }
            }
        }

        list < Project__Share > projectSharelist = new list < Project__Share > ();
        for (Project__c project: projectTriggerlst) {

            //Inserting Project Share record on Project Creation
            Project__Share pShare = new Project__Share();
            pShare.AccessLevel = 'Read';
            pShare.UserOrGroupId = project.CreatedById;
            pShare.ParentId = project.Id;
            projectSharelist.add(pShare);

        }
        //error Log 
        if (projectSharelist.size() > 0) {
            Database.saveresult[] sr = Database.insert(projectSharelist, False);
            ErrorLogUtility.processErrorLogs(sr, projectSharelist, 'projectOwnerAssignment', 'createReadOnlyAccessonProjectCreation', 'Project__Share', 'Insert');
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

    }
   /*************************************************
    Added By Satish Lokinindi
    Method Name: sendApprovalRejectMails
    Description: This method is used to Send Status Emails to Users on Rejection or Approval .
    Input Parameter: list of Project         
    *************************************************/
    public static void sendApprovalRejectMails(list < Project__c > proList) {
        set < ID > pIDs = new set < ID > ();
        for (Project__c pro: proList) {
            pIDs.add(pro.id);
            cUrl = pro.Conurl__c;
        }
       
        //query projects for clone user to get the email info to send the mails 
        Project__c prouser = [select id, CloneUser__c from Project__c where ID =: pIDs];

        if (prouser.CloneUser__c != '' && prouser.CloneUser__c != null) {
            activeUser = [Select id, Email, FirstName, LastName, Name, ProfileID, userName From User where id =: prouser.CloneUser__c];
            //profileid = activeUser.ProfileID;
            
            //store in string to utilze in the email context
            userEmail = activeUser.Email;
            userNam = activeUser.Name;
        }
        for (Project__c pro: proList) {
        //check if status is approved
            if (pro.Approval_Status__c == 'Approved') {
                List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List < String > sendTo = new List < String > ();

                sendTo.add(userEmail);
                mail.setToAddresses(sendTo);
                List < String > ccTo = new List < String > ();
                mail.setSubject(' Approval on creating quote on closed project');
                mail.setReplyTo(UserInfo.getUserEmail());
                string body1 = 'Dear ' + ' ' + userNam + ',<br>';
                
                /*check for specific profiles (portal),here its a different scenario to hard code the profile as the initail requests are sent to internal user 
                where in after approval and rejection should send the mails to cloned user who  can be a portal user*/
                
                if(activeUser.ProfileID!=label.RepProfileID2 && activeUser.ProfileID!=label.RepProfileID1 && activeUser.ProfileID!=label.RepProfileID3 && activeUser.ProfileID!=label.RepProfileID4 && activeUser.ProfileID!=label.RepProfileID5){
                body1 += 'Your Request to create a NEW QUOTE on the project has been Approved. Please Proceed with Quote Creation by clicking on below link.' + ' ' + label.Clonepageurl + 'projUrl=' + pro.Id + '&conUrl=' + cUrl + label.override;
                }else{
                 body1 += 'Your Request to crea+te a NEW QUOTE on the project has been Approved. Please Proceed with Quote Creation by clicking on below link.' + ' ' + label.ComunityUrl + 'projUrl=' + pro.Id + '&conUrl=' + cUrl + label.override;
                }
                //For image/Logo in the email 
                mail.setHtmlBody('<html><body><img src = "https://c.cs30.content.force.com/servlet/servlet.ImageServer?id=015A0000001fMLe&oid=00Dn00000000Zd4&lastMod=1473771645000" align="center" /></body></html><br/><br/><br/> ' + body1 + '<br><br><b>With Best Regards, <br><br> Your Support Team </br>');
                mails.add(mail);
                Messaging.sendEmail(mails);


            }
            if (pro.Approval_Status__c == 'Rejected' && pro.ProjectCloneID__c==null) {
                List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List < String > sendTo = new List < String > ();

                sendTo.add(userEmail);
                mail.setToAddresses(sendTo);
                List < String > ccTo = new List < String > ();
                mail.setSubject('Rejection on creating quote on closed project');
                mail.setReplyTo(UserInfo.getUserEmail());
                string body1 = 'Dear ' + ' ' + userNam + ',<br>';
                
                /*check for specific profiles (portal),here its a different scenario to hard code the profile as the initail requests are sent to internal user 
                where in after approval and rejection should send the mails to cloned user who  can be a portal user*/
                
                if(activeUser.ProfileID!=label.RepProfileID2 && activeUser.ProfileID!=label.RepProfileID1 && activeUser.ProfileID!=label.RepProfileID3 && activeUser.ProfileID!=label.RepProfileID4 && activeUser.ProfileID!=label.RepProfileID5){
                //if (Network.getNetworkId() == null) {
                    body1 += 'Your request to create a quote has been rejected. Please contact ADMIN for more details OR Please click on below link to  Create a new Project before creating a quote .' + ' ' + label.Clonepageurl + '&conUrl=' + cUrl + label.override;
                //} 
                }else {
                    body1 += 'Your request to create a quote has been rejected. Please contact ADMIN for more details OR Please click on below link to  Create a new Project before creating a quote .' + ' ' + label.ComunityUrl + '&conUrl=' + cUrl + label.override;
                }
                //For image/Logo in the email 
                mail.setHtmlBody('<html><body><img src = "https://c.cs30.content.force.com/servlet/servlet.ImageServer?id=015A0000001fMLe&oid=00Dn00000000Zd4&lastMod=1473771645000" align="center" /></body></html><br/><br/><br/> ' + body1 + '<br><br><b>With Best Regards, <br><br> Your Support Team </br>');
                mails.add(mail);
                Messaging.sendEmail(mails);
            }
        }
             System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
    }
}