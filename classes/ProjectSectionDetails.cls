/*********************************
    @ Author        : Satish Lokinindi
    @ Date          : May 2016
    @ Test File     : NA
    Function        : Controller Class for ProjectSelectSectionDetails page
    -----------------------------------------------------------------------------
*********************************/
public class ProjectSectionDetails {
    public boolean box1 {
        get;
        set;
    }
    /*public boolean box2 {
        get;
        set;
    }*/
    public boolean box3 {
        get;
        set;
    }
    public boolean box4 {
        get;
        set;
    }
    public boolean box5 {
        get;
        set;
    }
    public boolean box6 {
        get;
        set;
    }
    public String projectId {
        get;
        set;
    }

    public list < Opportunity > oList {
            get;
            set;
        }
    public Project__c proji {
        get;
        set;
    }
    public boolean proSelected {
        get;
        set;
    }
    public boolean oppSelected {
        get;
        set;
    }

    public boolean hideNextButton {
        get;
        set;
    }
    public boolean hideCloneButton {
        get;
        set;
    }
    public boolean backButton {
        get;
        set;
    }
    public list < oproji > oppList {
        get;
        set;
    }
    public list < Opportunity > oppty {
        get;
        set;
    }
 
    public Opportunity oppty_Clone {
        get;
        set;
    }
    public note nt_Clone {
        get;
        set;
    }
    public Attachment at_Clone {
        get;
        set;
    }
    public list < nttproji > notesAttachList {
        get;
        set;
    }
    public boolean allSelected{get;set;}
    //Constructor 
    public ProjectSectionDetails() {
    //Fetch the Project ID 
        projectId = System.currentPageReference().getParameters().get('projectId');
        oList = new list < Opportunity > ();
        oppty = new list < Opportunity > ();
        oppList = new list < oproji > ();
        proji = new Project__c();
    //set Default Boolean values  
        proSelected = false;
        oppSelected = false;
        hideNextButton = false;
        hideCloneButton = false;
        backButton = false;
       

    //Display the Notes and Attcahments  related to the project
        if (projectId != null || projectId != '') {

            List < Note > notelist = [Select Id, Title, Body, ParentId, LastModifiedById, LastModifiedBy.Name, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate from Note where ParentId =: projectId order by CreatedDate DESC];
            notelist.sort();
            //Query the Attachment of all the Opportunity and Project
            list < Attachment > attachmentlst = [Select Id, Name, ParentId, LastModifiedById, LastModifiedBy.Name, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate from Attachment where ParentId =: projectId order by CreatedDate DESC];
            attachmentlst.sort();

            notesAttachList = new list < nttproji > ();

            //Populating the Wrapper object which gives Notes and Attachment list
            for (Attachment att: attachmentlst) {

                nttproji ntAttProj = new nttproji(att);
                notesAttachList.add(ntAttProj);
            }

            for (Note note: notelist) {
                nttproji ntAttProj = new nttproji(note);
                notesAttachList.add(ntAttProj);
            }
            //show the buttons on display
            proSelected = true;
            hideNextButton = true;
        }

    }
    
    public PageReference selectAll(){
    //To Check/uncheck all the Checkboxes on selecting select all option on page
       box1 = allSelected;
       //box2 = allSelected;
       box3 = allSelected;
       box4 = allSelected;
       box5 = allSelected;
       box6 = allSelected;
       
        return null;
    }
    //Method to clone all the selected sections on project page or notes and attachments or Opportunites 
    public pageReference selected() {
        Boolean validate = validate();
        list < Project__c > plist1 = new list < Project__c > ();
        list < Project__c > plist2 = new list < Project__c > ();
        list < Project__c > plist3 = new list < Project__c > ();
        list < Project__c > plist4 = new list < Project__c > ();
        list < Project__c > plist5 = new list < Project__c > ();
        list < Project__c > plist6 = new list < Project__c > ();
        
       //check to find which project section is selected on page to be cloned
        if (validate == True ) {
            if (box1 == true) {
                plist1 = [select id, Name, Stage__c, OwnerId, RecordTypeId, Application__c, Application_2__c, Project_City__c, Project_Country__c, Project_State__c, Project_Street_Address__c, Project_Zip_Code__c, TerritoryName__c from Project__c where ID =: projectId];

            }
            /*if (box2 == true) {
                plist2 = [select id, Name, Stage__c, OwnerId, RecordTypeId,Project_Country__c, Project_Zip_Code__c, Application__c, Application_2__c, Purchaser_Account__c, Purchaser_Contact__c, Other_Influencer_Account__c, Other_Influencer_Contact__c, Architect_Account__c, Architect_Contact__c, Brand_Name_Account__c, Brand_Name_Contact__c, End_Customer_Account__c, End_Customer_Contact__c, Franchise_Account__c, Franchise_Contact__c, Franchisor_Account__c, Franchisor_Contact__c from Project__c where ID =: projectId];

            }*/
            if (box3 == true) {
                plist3 = [select id, Name, Stage__c, OwnerId, RecordTypeId,Project_Country__c,Project_State__c, Project_Zip_Code__c, Application__c, Application_2__c, Interior_Application__c, Corporate_Account__c, Residential_Vertical__c, Chain_Project_Type__c, Budget_Quote_Provided__c, Web_Project__c, Public_Spec_d_Job__c, Publicly_Specified_Jobs__c, Installer_Email_Viewed__c from Project__c where ID =: projectId];

            }
            if (box4 == true) {
                plist4 = [select id, Name, Stage__c, OwnerId, RecordTypeId, Project_Country__c,Project_State__c,Project_Zip_Code__c, Application__c, Application_2__c, Ordering_Account__c, Purchasing_Method__c from Project__c where ID =: projectId];

            }
            if (box5 == true) {
                plist5 = [select id, Name, Stage__c, OwnerId, RecordTypeId,Project_Country__c,Project_State__c, Project_Zip_Code__c, Application__c, Application_2__c, Preliminary_Drawings__c, Preliminary_Drawings_Date__c, Award_Date__c, Bid_Date__c, Close_Date__c, Estimated_Project_Need_Date__c, Expected_Install_Date__c, Expected_Open_Date__c, Actual_Project_Need_Date__c from Project__c where ID =: projectId];

            }

            if (box6 == true) {
                plist6 = [select id, Name, Stage__c, OwnerId, IsDeleted, RecordTypeId, Application__c,Project_State__c, Application_2__c, Amount__c, Project_Country__c,Project_Zip_Code__c, Architect_Considered__c from Project__c where ID =: projectId];

            }
            if (plist1.size() > 0) {
                for (Project__c pro: plist1) {
                    proji.Name = pro.Name;
                    proji.Stage__c = pro.Stage__c;
                    proji.OwnerId = pro.OwnerId;
                    proji.RecordTypeId = pro.RecordTypeId;
                    proji.Project_City__c = pro.Project_City__c;
                    proji.Project_Country__c = pro.Project_Country__c;
                    proji.Project_State__c = pro.Project_State__c;
                    proji.Project_Street_Address__c = pro.Project_Street_Address__c;
                    proji.Project_Zip_Code__c = pro.Project_Zip_Code__c;
                    proji.TerritoryName__c = pro.TerritoryName__c;
                    proji.Application__c = pro.Application__c;
                    proji.Application_2__c = pro.Application_2__c;

                }
            }
            /*if (plist2.size() > 0) {
                for (Project__c pro: plist2) {
                    proji.Name = pro.Name;
                    proji.Stage__c = pro.Stage__c;
                    proji.OwnerId = pro.OwnerId;
                    proji.RecordTypeId = pro.RecordTypeId;
                    proji.Project_City__c = pro.Project_City__c;
                    proji.Project_Country__c = pro.Project_Country__c;
                    proji.Project_State__c = pro.Project_State__c;
                    proji.Project_Street_Address__c = pro.Project_Street_Address__c;
                    proji.Project_Zip_Code__c = pro.Project_Zip_Code__c;
                    proji.TerritoryName__c = pro.TerritoryName__c;
                    proji.Purchaser_Account__c = pro.Purchaser_Account__c;
                    proji.Purchaser_Contact__c = pro.Purchaser_Contact__c;
                    proji.Other_Influencer_Account__c = pro.Other_Influencer_Account__c;
                    proji.Other_Influencer_Contact__c = pro.Other_Influencer_Contact__c;
                    proji.Architect_Account__c = pro.Architect_Account__c;
                    proji.Architect_Contact__c = pro.Architect_Contact__c;
                    proji.Brand_Name_Account__c = pro.Brand_Name_Account__c;
                    proji.Brand_Name_Contact__c = pro.Brand_Name_Contact__c;
                    proji.End_Customer_Account__c = pro.End_Customer_Account__c;
                    proji.End_Customer_Contact__c = pro.End_Customer_Contact__c;
                    proji.Franchise_Account__c = pro.Franchise_Account__c;
                    proji.Franchise_Contact__c = pro.Franchise_Contact__c;
                    proji.Franchisor_Account__c = pro.Franchisor_Account__c;
                    proji.Franchisor_Contact__c = pro.Franchisor_Contact__c;
                    proji.Application__c = pro.Application__c;
                    proji.Application_2__c = pro.Application_2__c;
                    


                }
            }*/
            if (plist3.size() > 0) {
                for (Project__c pro: plist3) {
                    proji.Name = pro.Name;
                    proji.Stage__c = pro.Stage__c;
                    proji.OwnerId = pro.OwnerId;
                    proji.RecordTypeId = pro.RecordTypeId;
                    
                    proji.Application__c = pro.Application__c;
                    proji.Application_2__c = pro.Application_2__c;
                    proji.Interior_Application__c = pro.Interior_Application__c;
                    proji.Corporate_Account__c = pro.Corporate_Account__c;
                    proji.Residential_Vertical__c = pro.Residential_Vertical__c;
                    proji.Chain_Project_Type__c = pro.Chain_Project_Type__c;
                    proji.Budget_Quote_Provided__c = pro.Budget_Quote_Provided__c;
                    proji.Web_Project__c = pro.Web_Project__c;
                    proji.Public_Spec_d_Job__c = pro.Public_Spec_d_Job__c;
                    proji.Publicly_Specified_Jobs__c = pro.Publicly_Specified_Jobs__c;
                    proji.Installer_Email_Viewed__c = pro.Installer_Email_Viewed__c;
                    
                    
                    proji.Project_Country__c = pro.Project_Country__c;
                    proji.Project_State__c = pro.Project_State__c;
                    
                    proji.Project_Zip_Code__c = pro.Project_Zip_Code__c;
                    
                }
            }
            if (plist4.size() > 0) {
                for (Project__c pro: plist4) {
                    proji.Name = pro.Name;
                    proji.Stage__c = pro.Stage__c;
                    proji.OwnerId = pro.OwnerId;
                    proji.RecordTypeId = pro.RecordTypeId;
                    proji.Project_Zip_Code__c = pro.Project_Zip_Code__c;
                    proji.Application__c = pro.Application__c;
                    proji.Application_2__c = pro.Application_2__c;
                    proji.Ordering_Account__c = pro.Ordering_Account__c;
                    proji.Purchasing_Method__c = pro.Purchasing_Method__c;
                    proji.Project_Country__c = pro.Project_Country__c;
                    proji.Project_State__c = pro.Project_State__c;

                }
            }
            if (plist5.size() > 0) {
                for (Project__c pro: plist5) {
                    proji.Name = pro.Name;
                    proji.Stage__c = pro.Stage__c;
                    proji.OwnerId = pro.OwnerId;
                    proji.RecordTypeId = pro.RecordTypeId;
                    proji.Project_Zip_Code__c = pro.Project_Zip_Code__c;
                    proji.Application__c = pro.Application__c;
                    proji.Application_2__c = pro.Application_2__c;
                    proji.Preliminary_Drawings__c = pro.Preliminary_Drawings__c;
                    proji.Preliminary_Drawings_Date__c = pro.Preliminary_Drawings_Date__c;
                    proji.Award_Date__c = pro.Award_Date__c;
                    proji.Bid_Date__c = pro.Bid_Date__c;
                    proji.Close_Date__c = pro.Close_Date__c;
                    proji.Estimated_Project_Need_Date__c = pro.Estimated_Project_Need_Date__c;
                    proji.Expected_Install_Date__c = pro.Expected_Install_Date__c;
                    proji.Expected_Open_Date__c = pro.Expected_Open_Date__c;
                    proji.Actual_Project_Need_Date__c = pro.Actual_Project_Need_Date__c;
                    proji.Project_Country__c = pro.Project_Country__c;
                    proji.Project_State__c = pro.Project_State__c;
                }
            }

            if (plist6.size() > 0) {
                for (Project__c pro: plist6) {
                    proji.Name = pro.Name;
                    proji.Stage__c = pro.Stage__c;
                    proji.OwnerId = pro.OwnerId;
                    proji.RecordTypeId = pro.RecordTypeId;
                    //proji.Amount__c = pro.Amount__c;
                    proji.Project_Zip_Code__c = pro.Project_Zip_Code__c;
                    proji.Application__c = pro.Application__c;
                    proji.Application_2__c = pro.Application_2__c;
                    proji.Architect_Considered__c = pro.Architect_Considered__c;
                    proji.Project_Country__c = pro.Project_Country__c;
                    proji.Project_State__c = pro.Project_State__c;

                }
            }
            //Checkto ensure that required field are having  data before performing clone.
            if( proji.Project_Zip_Code__c!=null && proji.Project_Country__c!=null && proji.Application__c != null && proji.Application_2__c!=null){

            Cloned_Project_Name__c Clname = Cloned_Project_Name__c.getOrgDefaults();
            String clp = Clname.Name;
            proji.Name = proji.Name + clp;
            proji.Stage__c = 'Quoted';
            proji.Parent_Project__c = projectId;       
            insert proji;
            

           //change Approaval status field as rejected and store the Projectclone id to the field
            Project__C pr =[select Id,Approval_Status__c,ProjectCloneID__c from Project__c where ID =:projectId ];
            pr.Approval_Status__c ='Rejected';
            pr.ProjectCloneID__c =proji.id;
            update pr;
            
            //Change the Approval process status upon clone and set as rejected
            //ProcessInstance approvlStatus  = [select Id, Status from ProcessInstance where TargetObjectId = :projectId];
            try{
            processinstanceworkitem p = [ select id from processinstanceworkitem where ProcessInstance.TargetObjectId = :projectId and ProcessInstance.status ='Pending'];
            
            Approval.processWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setComments('Rejecting  using Trigger');
                    req.setAction('Reject');//set reject
                    req.setWorkitemId(p.id);
                    
                    Approval.ProcessResult result;
                       
                        // submit the approval request for processing
                        result = Approval.process(req);
                        }catch(Exception e){
                        System.debug('No approval process has been setup yet.');
                        }
            
            // To clone only selected attachments and notes 
            set < ID > qNtID = new set < ID > ();
            set < ID > qAttID = new set < ID > ();
            for (nttproji n: notesAttachList) {
                if (n.isSelected2 == true && n.Type == 'Note') {
                    //find selected and add them to a seperate set 
                    qNtID.add(n.recordId);
                }
                if (n.isSelected2 == true && n.Type == 'Attachment') {
                    //find selected and add them to a seperate set 
                    qAttID.add(n.recordId);
                }
            }
            //Query the notes of selected notes to be cloned from wrapper
            List < Note > notevar = [Select Id, Title, Body, ParentId, LastModifiedById, LastModifiedBy.Name, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate from Note where id =: qNtID];

            //Query the Attachment of selected attachments to be cloned from wrapper
            list < Attachment > attachmentvar = [Select OwnerId, IsPrivate, Description, ContentType, BodyLength, Body, Id, Name, ParentId, LastModifiedById, LastModifiedBy.Name, CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate from Attachment where id =: qAttID];

            list < Note > noteli = new List < Note > ();
            list < Note > noteli2 = new List < Note > ();
            //loop over notes to create a clone of selected 
            for (Note n: notevar) {

                nt_Clone = n.clone(false, true, false, false);
                noteli.add(nt_Clone);
            }
            //Update the parent ID
            for (Note n: noteli) {
                n.ParentId = proji.id;
                noteli2.add(n);
            }
            //insert the notes data
            If(noteli2.size() > 0) {
                insert noteli2;
            }

            list < Attachment > attli = new List < Attachment > ();
            list < Attachment > attli2 = new List < Attachment > ();
            //loop over attachments to create a clone of selected 
            for (Attachment a: attachmentvar) {

                at_Clone = a.clone(false, true, false, false);
                attli.add(at_Clone);
            }
            //Update the parent ID
            for (Attachment a: attli) {
                a.ParentId = proji.id;
                attli2.add(a);
            }
            //insert the notes data
            If(attli2.size() > 0) {
                insert attli2;
            }
            //To clone only selected Opportunity on page
            set < ID > oSetID = new set < ID > ();
            for (oproji oo: oppList) {
                if (oo.isSelected1 == true) {
                    oSetID.add(oo.id);
                }
             }
            if (oSetID.size() > 0) {
                oppty = [select id, Name, Project_Name__c, StageName, AccountID, OwnerID, RecordTypeID, Application_Industry__c, Application_Sub_Industry__c, CloseDate from Opportunity WHERE ID =: oSetID];
            }
            list < Opportunity > oppy = new List < Opportunity > ();
            list < Opportunity > oppy1 = new List < Opportunity > ();

            if(oppty.size()>0){
            For(Opportunity o: oppty) {
                oppty_Clone = o.clone(false, true, false, false);
                oppy.add(oppty_Clone);
            }
            //set the stage as Quote-Requested and fill other required information.
            for (Opportunity o: oppy) {
                o.Project_Name__c = proji.id; 
                o.StageName = 'Quote - Requested';
                o.CloseDate = System.today()+180;
                oppy1.add(o);
            }
            If(oppy1.size() > 0) {
            insert oppy1;
            }
            }
             //Add contact roles to the cloned opportunities  
            if(oppy1.size()>0){
            map<id,id> oppMapId = new map<id,id>();
            map<id,id> accConMapId = new map<id,id>();
            set<id> setAccId = new Set<id>();
            set<id> setConId = new Set<id>();
            
           
            for(Opportunity oppQuery : [Select Id,AccountID from Opportunity where Id = : oppy1]){
            //oppMapId.put(oppQuery.ID,oppQuery.AccountID);
            setAccId.add(oppQuery.AccountID);            
            }
            List<Account> queryResults = [Select Id, (Select Id from Contacts) from Account where id=:setAccId];
                for (Account a : queryResults) {
                    for (Contact c : a.Contacts) {
                      accConMapId.put(c.id,a.id); 
                     }
                }
                         
                set < ID > conrolset = new set < ID > ();
            
                for (nrOpportunityContactRole__c oppConRole: [select Id, Contact__c, Opportunity__c from nrOpportunityContactRole__c WHERE Opportunity__c = : oppty]) {
                    conrolset.add(oppConRole.Contact__c);
                    
                }
                
                list<Contact> conList = [select id ,AccountID from Contact where id =:conrolset];
                list<nrOpportunityContactRole__c> oppConRolelist = new list<nrOpportunityContactRole__c>();
                for(Opportunity o:[Select Id,AccountID from Opportunity where Id = : oppy1]){
                    for(Contact c:conList){
                       // if(conrolset.contains(accConMapId.get(o.AccountID))){
                            if((c.AccountId ==o.AccountID) && (o.AccountID == accConMapId.get(c.ID))){
                                nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                                    
                                    oppConRole.Contact__c = c.id;
                                    oppConRole.Opportunity__c = o.id;
                                    oppConRolelist.add(oppConRole);
                               } 
                          // } 
                       }
                   }
                    try {
                        insert oppConRolelist;
                    }
                    catch (exception e) {}
                    
                
             }
            //fetch details of the user who requested for the cloned project and send email after cloned project is created.
            Project__c prouser = [select id , CloneUser__c from Project__c where ID =:projectId];
            
            if(prouser.CloneUser__c!='' && prouser.CloneUser__c!=null){
            User activeUser = [Select id, Email , FirstName, LastName, Name,ProfileID ,userName From User where id = : prouser.CloneUser__c ];
            
            string userEmail =activeUser.Email;
            string userName = activeUser.Name;
            
            
            List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List < String > sendTo = new List < String > ();

            sendTo.add(userEmail);
            mail.setToAddresses(sendTo);
            List < String > ccTo = new List < String > ();
            mail.setSubject(' Cloned Project has been Created');
            mail.setReplyTo(UserInfo.getUserEmail());
            string body1 = 'Dear ' + ' ' + userName + ',<br>';
            //if (Network.getNetworkId() == null) {
            if(activeUser.ProfileID!=label.RepProfileID2 && activeUser.ProfileID!=label.RepProfileID1 && activeUser.ProfileID!=label.RepProfileID3 && activeUser.ProfileID!=label.RepProfileID4 && activeUser.ProfileID!=label.RepProfileID5){
            body1 += 'This is to inform that the cloned project has been created !please use this project to create a quote' + ' ' + label.OrgUrl + '/' + proji.id + ' ';
            }
            //}
            else{
            body1 += 'This is to inform that the cloned project has been created !please use this project to create a quote' + ' ' + label.ComntyUrl + '/' + proji.id + ' ';
            }
            mail.setHtmlBody('<html><body>'+label.imageurl+'</body></html><br/><br/><br/> ' +body1+'<br><br><b>With Best Regards, <br><br> Your Support Team </br>');
            mails.add(mail);
            Messaging.sendEmail(mails);
            }
            //redirect to cloned Project 
            String url = '/' + proji.id;
            PageReference redUrl = new PageReference(url);
            redUrl.setRedirect(true);
            return redUrl;
            }
            else {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Project Required Fields info is Missing .'));
            }
        }
        return null;
    }
    //Next Button Functionality
    public pageReference Next() {
        Boolean validate = validate();
        if (validate == true) {
            hideNextButton = false;
            hideCloneButton = true;
            oppSelected = true;
            proSelected = false;
            backButton = true;
            //reterive opp on project and display through wrapper
            oList = [Select Id, Name, AccountId, Account.name, Project_Name__c, Primary_Opportunity__c from Opportunity where Project_Name__c =: projectId];
           if(oppList.size()>0){}
               else{
                if(oList.size()>0){
                    for (Opportunity o: oList) {
                        oproji owrap = new oproji(o);
                        oppList.add(owrap);
                    }
                 }
               }
         }  
        return null;
    }
    //back Button functionality 
    public pageReference goBack() {
        hideNextButton = true;
        proSelected = true;
        oppSelected = false;
        backButton = false;
        hideCloneButton = false;
        return null;
    }
    //validate Method to ensure atleast one section is selected to clone
    public boolean validate() {
        boolean validate = true;
        integer count = 0;
        if (box1 == false  && box3 == false && box4 == false && box5 == false && box6 == false) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please Select Atleast One.'));
            validate = false;
        }
        if (projectId == Null || projectId == '') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'ProjectID not Found.'));
            validate = false;
        }
        if(projectId!=null){
         project__c prjListToCheckRejected = [select id, Approval_Status__c from Project__c where id=: projectId];
         if(prjListToCheckRejected.Approval_Status__c=='Rejected' || prjListToCheckRejected.Approval_Status__c=='Approved'){
         
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'This Project cannot be clonned.  Quoting team either Approved or Rejected this before'));
              validate = false;
         }
        }
        

        return validate;
    }
    //Wrapper class to display the Opportunities under the ProjectID
    public class oproji {
        public boolean isSelected1 {
            get;
            set;
        }
        
        public string Name {
            get;
            set;
        }
        public string AccountName {
            get;
            set;
        }
        public string id {
            get;
            set;
        }
        public boolean Primary {
            get;
            set;
        }
        //create wrapper for Opportunity
        public oproji(Opportunity opp) {
            this.isSelected1 = false;
            this.Name = opp.Name;
            this.AccountName = opp.Account.name;
            this.id = opp.id;
            this.Primary = opp.Primary_Opportunity__c;
        }
    }

    //wrapper class to display notes and attachments of that projectID
    public class nttproji {

        public Note note {
            get;
            set;
        }
        public Attachment attach {
            get;
            set;
        }
        Public String Type {
            get;
            set;
        }
        Public String recordId {
            get;
            set;
        }
        public boolean isSelected2 {
            get;
            set;
        }
        public Date CreatedDate {
            get;
            set;
        }
        public Date LastModifiedDate {
            get;
            set;
        }
        Public String Body {
            get;
            set;
        }
        //create wrapper for Notes
        public nttproji(Note nt) {
            this.note = nt;
            this.Type = 'Note';
            this.Body = nt.Body;
            this.recordId = nt.Id;
            this.isSelected2 = false;
            this.CreatedDate = nt.CreatedDate.date();
            this.LastModifiedDate = nt.LastModifiedDate.date();

        }
        //create wrapper for Attachments
        public nttproji(Attachment att) {
            this.attach = att;
            this.Type = 'Attachment';
            this.recordId = att.Id;
            this.isSelected2 = false;
            this.CreatedDate = att.CreatedDate.date();
            this.LastModifiedDate = att.LastModifiedDate.date();
        }
    }

}