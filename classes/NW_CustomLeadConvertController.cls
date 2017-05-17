/***********************************************
Apex Class : NW_CustomLeadConvertController
Description: Controller class for NW_CustomLeadConvertScreen.
            This class is used for custom lead conversion.
***********************************************/
public  class NW_CustomLeadConvertController {

static {
 FCRM.FCR_SupportAPI.SetPassiveModeInContext();
}
    //Variable Declaration
    public Account acct {
        get;
        set;
    } //Account
    public Task tsk {
        get;
        set;
    } //Task

    public Boolean projCheckBlock {
        get;
        set;
    }
    Public Boolean oppCheckBlock {
        get;
        set;
    }
    public Project__c proj {
        get;
        set;
    }
    public String accountToBeIncluded {
        get;
        set;
    }
    public String projectToBeIncluded {
        get;
        set;
    }
    private List < SelectOption > accountsList = new List < SelectOption > ();
    private List < SelectOption > projectList = new List < SelectOption > ();
    public String textNewSelectOption {
        get;
        set;
    }
    public Boolean reqFieldsOnPage {get;set;}
    public Boolean isNewAccount {
        get;
        set;
    }
    public Boolean isNewProject {
        get;
        set;
    }
    public Boolean oppCheck {
        get;
        set;
    }
    public Boolean projCheck {
        get;
        set;
    }
    public Lead mainLead {
        get;
        set;
    }
    public Boolean includeOpp {
        get;
        set;
    }
    public String selectedOpportunityPicklist {
        get;
        set;
    }
    public Opportunity opp {
        get;
        set;
    } // Opportunity
    public Contact con {get; set;}
    public String selectedAccount {
        get;
        set;
    }
    public String selectedProject {
        get;
        set;
    }
    public Boolean sendEmail {
        get;
        set;
    }
    public LeadStatus ldStatus {
        get;
        set;
    }

    public List < SelectOption > getAccountsList() {
        return accountsList;
    }

    public List < SelectOption > getProjectList() {
        return projectList;
    }

    Id redirectId;
    

    public Pagereference cancel() {
        if(redirectId== null){
        Pagereference pg = new Pagereference('/' + mainLead.Id);
        pg.setRedirect(true);
        return pg;
    } else {
        PageReference p = new PageReference('/' + redirectId);
                p.setRedirect(true);
                return p;
        }
        
    }
    public boolean validateFields() {
    
        boolean Validated = true;
        if (mainLead.Project_Name__c !=null && !projCheck){
        if (selectedProject == mainLead.Project_Name__c && (mainLead.Type_of_record__c==null || mainLead.project_application_industry__c==null || mainLead.Project_Application__c==null)) {
        Validated = false;
        }
      }
        else{
        Validated = true;
        } return Validated;
    }
        

    public void autoSelectOpp() {
        system.debug('Check if calling method');
        System.debug('$$$$$$$$$$$$' +accountToBeIncluded);
        if (projCheck) {
            system.debug('Check Inside True' + accountsList);
            oppCheck = true;
        } else {
            oppCheck = false;
        }
       // return null;
    }

    public Contact person {
        get {
            return new Contact() ;
        }
        set {
            acct.Id = person.AccountId;
        }
    }

    public Opportunity project {
        get {
            return new Opportunity(Project_Name__c=null);
        }
        set {
            proj.Id = project.Project_Name__c;
        }
    }

    public NW_CustomLeadConvertController(ApexPages.StandardController controller) {
        System.debug('$$$$$$$$'+person);
        System.debug('%%%%%%%%'+selectedAccount);
        this.mainLead = (Lead) controller.getrecord();
        oppCheck = false;
        projCheck = false;
        opp = new Opportunity();
        tsk = new Task();
        acct = new Account();
        proj = new Project__c();
        con = new contact();
        reqFieldsOnPage = true;
        mainLead = [SELECT OwnerID, Name, LastName, Project_Name__c, project_application_industry__c,project_application__c,OtherPhone__c,mobilePhone,Status, Company,type_of_record__c,postalCode,state,Project_Site_City__c,Project_Site_Country__c,Project_Site_State__c,Project_Site_Street__c,Project_Site_Zip_Code__c,
            Phone, CreatedDate,Is_Converting__c FROM Lead WHERE Id = : mainLead.id];

        mainLead.Status = 'Qualified';
        textNewSelectOption = 'Attach to existing:' + ' ';

        //Default Project Value        
        List < Project__c > existsProject = new List < Project__c > ();
        if (mainLead.Project_Name__c != null)
            existsProject = [Select id, Name from Project__c where Name = : mainLead.Project_Name__c LIMIT 100];

        if (mainLead.Project_Name__c != null)
            projectList.add(new SelectOption(mainLead.Project_Name__c, 'Create New Project:' + ' ' + mainLead.Project_Name__c));
        else {
            projCheckBlock = true;
            projCheck = true;
            oppCheck = true;
            oppCheckBlock = true;
        }


        isNewProject = true;
        if (existsProject.size() > 0) {
            for (Project__c proj: existsProject) {
                projectList.add(new SelectOption(proj.Id, textNewSelectOption + proj.Name));
            }
        }


        if (mainLead.Project_Name__c != null && mainLead.Project_Name__c != '') {
            String query = 'SELECT id, Name,Project_City__c,Project_Country__c,Application__c,application_2__c,Project_State__c,RecordTypeID,Project_Street_Address__c,Project_Zip_Code__c FROM Project__c WHERE Name LIKE \'%' + String.escapeSingleQuotes(mainLead.Project_Name__c) + '%\' LIMIT 900';
            for (Project__c proj: Database.query(query)) {
                if (proj.Name != mainLead.Project_Name__c) {
                    projectList.add(new SelectOption(proj.Id, textNewSelectOption + proj.Name));
                }
               
                      
            }
        }

        //Default Account value
       /*
        List < Account >  = new List < Account > ();
        if (mainLead.Company != null)
            existsAccount = [SELECT id, Name FROM Account WHERE Name = : mainLead.Company LIMIT 999];
            
            
        

        if (mainLead.Company != null)
            accountsList.add(new SelectOption(mainLead.Company, 'Create New Account:' + ' ' + mainLead.Company));
        
        isNewAccount = true;
        if (existsAccount.size() > 0) {
            system.debug('Inside Exists Account');
            for (Account account: existsAccount) {
                accountsList.add(new SelectOption(account.Id, textNewSelectOption + account.Name));
            }
        }
        */

        if (mainLead.Company != null && mainLead.Company != '') {
            accountsList.add(new SelectOption(mainLead.Company, 'Create New Account:' + ' ' + mainLead.Company));
            String query = 'SELECT id, Name FROM Account WHERE Name LIKE \'%' + String.escapeSingleQuotes(mainLead.Company) + '%\' LIMIT 999';
            for (Account account: Database.query(query)) {
               //If condition commented since with account with the same names are not coming in the Lead Convert page
               // if (account.Name != mainLead.Company) {
                    accountsList.add(new SelectOption(account.Id, textNewSelectOption + account.Name));

              //  }
            }
        } 

        if ((mainLead.Company != null || mainLead.Name != null) && mainLead.Project_Name__c != null) {
            if (mainLead.Company != null)
                opp.Name = 'Fills_Automatically';
            else
                opp.Name = 'Fills_Automatically';
        }
    }

    public void addingNewAccount() {
        List < Account > newAccounts = new List < Account > ();
        
        System.debug('$$$$$$$$$$$$' +accountToBeIncluded);
        
        if (mainLead.Company != null)
            newAccounts = [SELECT Id, Name FROM Account WHERE Name = : accountToBeIncluded ORDER BY createdDate desc LIMIT 1];
        
        for (Account newAccount: newAccounts) {
            system.debug('Inside Adding New Account' + newAccount.Id);
            Boolean shouldAdd = true;
            String newAccountId = newAccount.Id;
            for (SelectOption option: accountsList) {
                if (option.getValue() == newAccountId) {
                    shouldAdd = false;
                    break;
                }
            }
            if (shouldAdd) {
                accountsList.add(new SelectOption(newAccount.Id, textNewSelectOption + newAccount.Name));
            }
            isNewAccount = false;
        }
    }


    public void addingNewProject() {
        List < Project__c > newProjects = [SELECT Id, Name FROM Project__c WHERE Name = : projectToBeIncluded LIMIT 1];

        Id projectRecentlyAdded;
        for (Project__c newProject: newProjects) {
            Boolean shouldAdd = true;
            String newProjectId = newProject.Id;
            for (SelectOption option: projectList) {
                if (option.getValue() == newProjectId) {
                    shouldAdd = false;
                    break;
                }
            }
            if (shouldAdd) {
                projectList.add(new SelectOption(newProject.Id, textNewSelectOption + newProject.Name));
                projectRecentlyAdded = newProject.Id;
            }
            isNewProject = false;

        }

    }

    public void setRequiredFields(){
        /*
        //added this blck for ticket # 109
        if (selectedProject != mainLead.Project_Name__c) {
            reqFieldsOnPage = false;
        }
        else{
            reqFieldsOnPage = true;
        }
        */
    }

    public PageReference convertLead() {
      

      system.debug('oppcheckhey'+oppcheck);
      system.debug('selectedAccounthey'+selectedAccount);
      system.debug('selectedProjecthey'+selectedProject);
      system.debug('projCheckhey'+projCheck);
  
        
       if( !validateFields() )
        {
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR, 'Please check all of your entries. You missed some required information.' ));         
            return null;
        }
        system.debug('mainLead'+mainLead);
        mainLead.Is_Converting__c = true;
        update mainLead;
        UtilityClass.doNotRunOnConverstionOfLead = false;
        Database.LeadConvertResult lcr;
        
        Database.Leadconvert lc = new Database.Leadconvert();
        lc.setLeadId(mainLead.Id);
        lc.setSendNotificationEmail(sendEmail);
       // lc.setOwnerId(mainLead.OwnerId);
        
        System.debug('$$$$$$'+ selectedAccount+mainLead.company);
        system.debug('selectedAccount'+selectedAccount);
        
        if (selectedAccount != mainLead.Company) {
            acct.Id = selectedAccount;
            Account account = [Select Id, OwnerId from Account where Id =: selectedAccount];
            lc.setAccountId(acct.Id);
            lc.setOwnerId(account.OwnerId);
        }
         System.debug('opppppppppppppp'+oppCheck);
        list<LiveChatTranscript>chatsToUpdate = new list <LiveChatTranscript>();
        list<Get_Feedback_Survey_Response__c> surveysToUpdate= new list<Get_Feedback_Survey_Response__c>();
        if (oppCheck) {
            lc.setDoNotCreateOpportunity(true);
        } else {
            lc.setDoNotCreateOpportunity(false);
            lc.setOpportunityName(opp.Name);
        }
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Savepoint sp = Database.setSavepoint();
        try {
            
            lcr = Database.convertLead(lc);
            if (lcr.isSuccess()) {

                //insert task
                tsk.WhatId = lcr.getAccountId();
                tsk.WhoId = lcr.getContactId();
                tsk.Status = String.valueOf(tsk.Status);
                if (!oppCheck) {
                    tsk.WhatId = lcr.getOpportunityId();
                }
                if (tsk.subject != null){
                insert tsk ;
                }
                
                //Redirect to Opportunity page if it is being created else to Account page
                if (oppCheck) {
                    system.debug('lcr.getContactId()');
                    redirectId = lcr.getContactId();
                } else
                    redirectId = lcr.getOpportunityId();

                //Need to move it in different method as Post Convert 
                boolean check = false;
                
                if (selectedProject != mainLead.Project_Name__c && !(oppCheck)) {
                    system.debug('selectedProject != mainLead.Project_Name__c && !(oppCheck)');
                    system.debug('selectedProject != mainLead.Project_Name__c selectedProject'+selectedProject);
                    system.debug('selectedProject != mainLead.Project_Name__c oppCheck'+oppCheck);
                    
                    proj.Id = selectedProject;
                    check = true;
                    try{
                        Project__c p = new Project__c();
                        p = [SELECT Id, Name, RecordType.Name, Application__c, Application_2__c FROM Project__c WHERE Id = :proj.Id LIMIT 1];
                        if(p.RecordType.name != null && p.RecordType.name.contains('Commercial')){
                            mainLead.type_of_record__c = 'Commercial';
                        }
                        else if(p.RecordType.name != null && p.RecordType.name.contains('Residential')){
                            mainLead.type_of_record__c = 'Residential';
                        }
                        mainLead.project_application_industry__c = p.Application__c;
                        mainLead.project_Application__c = p.Application_2__c;                            
                    }
                    catch(Exception ex){
                        System.Debug('>>> Error in getting Project Type. Error is :: '+ ex.getMessage());
                    }
                    
                } else {
                    if (!projCheck) {
                        system.debug('else projCheck'+projCheck);
                        proj = new Project__c();
                        proj.Name = mainLead.Project_Name__c;
                        
                        proj.Project_City__c = mainLead.Project_Site_City__c;
                        proj.Application__c = mainLead.project_application_industry__c;
                        proj.Application_2__c= mainLead.project_Application__c;
                        proj.Project_Country__c = mainLead.Project_Site_Country__c;
                        proj.Project_State__c = mainLead.Project_Site_State__c;
                        proj.Project_Street_Address__c= mainLead.Project_Site_Street__c;
                        proj.Project_Zip_Code__c = mainLead.Project_Site_Zip_Code__c;
                        //Added by Praveen on 21st May 2015
                        proj.Close_Date__c = System.Today() + 180;
                        
                        proj.recordTypeID = Schema.getGlobalDescribe().get('Project__c').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(mainlead.type_of_record__c).Project_record_type_name__c).getRecordTypeId();
                        insert proj;
                        system.debug('else projCheck proj '+proj.id);
                        check = true;
                    }
                }

                if (check && !oppCheck) {
                    system.debug('check && !oppCheck');
                      system.debug('check && !oppCheck '+check);
                    system.debug('check && !oppCheck'+proj.Id);
                    Opportunity opp = [Select Id, RecordTypeID,Account.ownerId,ownerID,Project_Name__c from Opportunity where id = : lcr.getOpportunityId()];
                    opp.Project_Name__c = proj.Id;
                    opp.CloseDate= system.today() + 180;
                    
                    Opp.stageName= 'Quote - Requested';
                    opp.recordTypeID = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(mainlead.type_of_record__c).Opportunity_record_type_name__c).getRecordTypeId();
                    update opp ;
                    
                    System.debug('OPPPPPPPPPPPPPPP----------'+opp.id);
                    }
                    
                    if(lcr.getcontactID()!=null){
                    Contact con = [Select id,MobilePhone,LeadType__c,owner_assignment__c,OtherPhone,phone from contact where id=: lcr.getContactID()];
                    con.mobilephone=mainLead.MobilePhone;
                    con.OtherPhone=mainLead.OtherPhone__c;
                    con.phone=mainLead.phone;
                    con.owner_assignment__c = true ;
                    update con ;
                    // System.debug('CONNNNNNNNNNNN----------'+con.id);
                      System.debug('CONNNNNNNNNNNN  OWNER----------'+con.OwnerID);
                    // System.debug('CON ROLEEE----------'+con.owner.userrole.name);
                    if(lcr.getOpportunityId() != null && lcr.getOpportunityId() != null){
                    nrOpportunityContactRole__c newContactRole = new nrOpportunityContactRole__c ();
                    newContactRole.Opportunity__c=lcr.getOpportunityId();
                    newContactRole.Contact__c= lcr.getcontactID();
                    newContactRole.Primary__c=true;
                    if(con.LeadType__c != null) {
                    newContactRole.Role__c= con.LeadType__c;
                    } 
                    
                    insert newContactRole ;
                    
                   System.debug('CONNNNNNNNNNNN----------'+con.id);
           
                    }
                        // Code For Full Circle Integration
       
 
       list<id> conid= new list<id>();
        conid.add(con.id);
             System.debug('efwhifkjehkf'+con.id);
      System.debug('efwhifkjehkf'+conid);
       list<CampaignMember> campmem = new list<CampaignMember>();
       
      campmem=FCRM.FCR_SupportAPI.GetActiveResponses(conid);
     
         System.debug('Campaign----------'+campmem);
         System.debug('Campaign size-----'+campmem.size());
          System.debug('oppresponse id----------'+opp.FCRM__FCR_Response_ID__c);
            //System.debug('Campaign idd--------------'+campmem[0].id);
         if(campmem.size()!=0 && (opp.FCRM__FCR_Response_ID__c==null || opp.FCRM__FCR_Response_ID__c==' '))
         {
             for(integer i=0; i<campmem.size(); i++)
             {
             campmem[i].FCRM__FCR_Opportunity__c=opp.id;
             campmem[i].FCRM__FCR_Admin_Response_Control__c=8;
             }
          update campmem;
         }
          
       
         list<CampaignMember> cmp= new list <CampaignMember>();
         
     if(campmem.size()==0 || campmem.size()==null)
       {
         Default_User_Campaigns__c c = Default_User_Campaigns__c.getOrgDefaults();
           decimal d = c.Search_Timeframe__c;
           Integer integerValue = Integer.valueOf(d);
          date responsedate= system.today() + (-integerValue);
          System.debug('dateValue is--------'+responsedate);
         cmp=[select id, Contactid, FCRM__FCR_Response_Date__c, FCRM__FCR_Opportunity__c, FCRM__FCR_Admin_Response_Control__c, Status_Reason__c from CampaignMember where FCRM__FCR_Response_Date__c<: responsedate ORDER BY FCRM__FCR_Response_Date__c LIMIT 1];
         //System.debug('CMP id---------------------'+cmp[0].id);
         System.debug('cmp @@@@@@@'+cmp);
         System.debug('cmp @@@@@@@'+cmp.size());
           
           for(integer i=0; i<cmp.size(); i++)
           {
         cmp[i].FCRM__FCR_Opportunity__c=opp.id;
         cmp[i].FCRM__FCR_Admin_Response_Control__c=8;
         cmp[i].Status_Reason__c=' ';
         }
        update cmp;
        
         System.debug('CMP id22222---------------------'+cmp);
      }
        
        list<CampaignMember> campignlist = new list<CampaignMember>();
       
  if((campmem.size()==0 || campmem.size()==null) && (cmp.size()==0 || cmp.size()==null)) 
   {
          list<Default_User_Campaigns__c> dlist = new list<Default_User_Campaigns__c>();
       list<Default_User_Campaigns__c> dlist2 = new list<Default_User_Campaigns__c>();
       System.debug('iddddddddddddd'+con.id);
            list<contact> conl=[select id, Owner.UserRole.Name from contact where id=:con.id];
            list<contact> conlist2=[select id, OwnerID from contact where id=:con.id];
       System.debug('conlist222222222----@@@@ '+conlist2);
            list<campaign> cmplist =[select id from campaign];
            System.debug('cmpign-----@@@@ '+cmplist);
            
            System.debug('roleeeeeeeeee'+conl[0].Owner.userrole.name);
          dlist = [select Campaign_Id__c,Member_Status__c from Default_User_Campaigns__c where User_Role__c=:conl[0].owner.userrole.name];
            System.debug('dlist========'+dlist.size());
       if(dlist.size()!=null || dlist.size()!=0)
       {
            for(integer i=0; i<dlist.size(); i++)
            {
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=dlist[i].Campaign_Id__c;
                campign.ContactId=con.id;
                campign.Status=dlist[i].Member_Status__c;
                campign.FCRM__FCR_Opportunity__c=opp.id;
                campign.FCRM__FCR_Admin_Response_Control__c=8; 
        
                campignlist.add(campign);
            }
           
           insert campignlist;
       }
       if(dlist.size()==null || dlist.size()==0)
       {
         
          dlist2 = [select Campaign_Id__c,Member_Status__c, User_Role__c from Default_User_Campaigns__c where User_Role__c =:'default'];   
       System.debug('dlist2222222222'+dlist2.size());
            for(integer i=0; i<dlist2.size(); i++)
            {
                           System.debug('dlist23333'+dlist2);
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=dlist2[i].Campaign_Id__c;
                campign.ContactId=con.id;
                campign.Status=dlist2[i].Member_Status__c;
                campign.FCRM__FCR_Opportunity__c=opp.id;
                campign.FCRM__FCR_Admin_Response_Control__c=8; 
        
                campignlist.add(campign);
               
                System.debug('cmpgniglist--------'+campignlist);
            }
           UserRecordAccess accAccess = [SELECT RecordId, HasReadAccess, HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: cmplist[0].Id];
           
           //System.debug('acesss--------'+uacesslist);
           if(accAccess.HasEditAccess == TRUE)
           {
                insert campignlist;               
           }
           else
           {
               ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR, 'You Dont Have a permission to create a campaign and Campaign Member' )); 
           }
     
           System.debug('cmpgniglist22222222--------'+campignlist);
       }
    }
           
          System.debug('CONNNNNNNNNNNN----------'+con.id);
   }
             
 }
                
                if (mainLead.id!=null){
                    for(LiveChatTranscript chats : [SELECT id, ContactID,Opportunity_name__c,Project_ID__c,leadID FROM LiveChatTranscript WHERE LeadID=: mainLead.id]){
                        chats.ContactId=lcr.getContactId();
                       if(proj.id!= null){
                            chats.Project_ID__c=proj.id;
                            
                        } chatsToUpdate.add(chats);
                        
                    } 
                    if(chatsToUpdate.size()>0){
                    update chatsToupdate;
                    }
                }
                if(mainLead.id!=null){
                    for(  Get_Feedback_Survey_Response__c   surveyToMigrate : [select id,ContactID__c,LeadID__c,Project_ID__c from Get_Feedback_Survey_Response__c where leadID__c=: mainLead.id]){
                     surveyToMigrate.contactID__c=lcr.getContactId();
                     if(proj.id!= null){
                            surveyToMigrate.Project_ID__c=proj.id;
                            
                        } surveysToUpdate.add(surveyToMigrate);
                    }
                        if(surveysToUpdate.size()>0){
                        update surveysToUpdate ;
                      }
                }
         
       
            
            
               //Redirect
                PageReference p = new PageReference('/' + redirectId);
                p.setRedirect(true);
                return p;
   }
         
        catch (Exception e) {
            if (e.getMessage().contains(System.Label.LeadConvertErrorMessage)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.LeadConvertException));
                Database.rollback(sp);
            }
            else {
               //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
               Database.rollback(sp);
            }
        }
        
        
         
         
        

        return null;
       
    }
    
    
}