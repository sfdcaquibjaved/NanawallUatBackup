/**************************************************************************************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : July 2015
    @ Test File     : NA
    Function        : Controller Class for Quote Wizard Pages
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
*******************************************************************************************************************************************************/
public with sharing class Quote_WizardController {

    //local variables
    public String contactCreateOption {
        get;
        set;
    } //select list for Contact Create Option
    public String accountCreateOption {
        get;
        set;
    } //select list for Account Create Option
    public String projectCreateOption {
        get;
        set;
    } //select list for Project Create Option

    //Variables to store the object information
    public Contact con {
        get;
        set;
    }
    
    public List < SelectOption > contactList {get;set;}
    
    public String selectedContact {get;set;}
    
    public Contact con2 {
        get;
        set;
    }
    
    public Account acc {
        get;
        set;
    }
    public Opportunity opp {
        get;
        set;
    }
    public Project__c proj {
        get;
        set;
    }
    
    public id cloneprojid
    {
        get;
        set;
    }
    
    public Project__c Proj_Clone {
        get;
        set;
    }
    public nrOpportunityContactRole__c oppConRole {
        get;
        set;
    }
    
    public list<Quote__c> quoteList {get;set;}

    //Boolean flags to hide/show information on the page
    public boolean createNewContact {
        get;
        set;
    }
    public boolean createNewProject {
        get;
        set;
    }
    public boolean createNewAccount {
        get;
        set;
    }
    public boolean showAccountSection {
        get;
        set;
    }
    public boolean selectedAccountSection {
        get;
        set;
    }
   
    public boolean showProjectForm {
        get;
        set;
    }
    
    public boolean showQuoteSection {
        get;
        set;
    }
    

    //Variables which will be set on action methods of the page
    public String contactId {
        get;
        set;
    }
    public String accountId {
        get;
        set;
    }
    public String projectId {
        get;
        set;
    }
   
    public String rowId {
        get;
        set;
    }
    
     public String conUrlId {
        get;
        set;
    }
    
    
    public String projUrlId {
        get;
        set;
    }
    
     public String oppUrlId {
        get;
        set;
    }
    
     public String accUrlId {
        get;
        set;
    }
    
    public boolean contactCreated {
        get;
        set;
    }
    public boolean accountCreated {
        get;
        set;
    }
    public boolean projectCreated {
        get;
        set;
    }
    public boolean opportunityCreated {
        get;
        set;
    }
    public boolean quoteCreated {
        get;
        set;
    }
    
    public boolean showNanaQuoteButton {
        get;
        set;
    }
    
    public conWrapper contactWrapper{
        get;
        set;
    }
    
    public accWrapper accountWrapper {
        get; set;
    }
    
    //Boolean Variables to make the sections readonly
    public boolean accountURLSelected {
        get;
        set;
    }
    
     public boolean conURLSelected {
        get;
        set;
    }
    
     public boolean projURLSelected {
        get;
        set;
    }
    
    public boolean oppURLSelected {
        get;
        set;
    }
    
    public Boolean insufficentPrivilege 
    {
        get;
        set;
    }
    
    public Boolean Clone
    {
        get;
        set;
    }
    
    public Boolean Clone_Button
    {
        get;
        set;
    }
    
    
    /***********************************************************************************************************************************************
             Method Name :- Constructor of the class.
             @description :- Constructor of the Class.Contains the initialization of all the variables.
             @param :- NA
    ***********************************************************************************************************************************************/

    public Quote_WizardController() {

        //Default value of the variables
        createNewContact = false;
        createNewAccount = false;
        createNewProject = false;
        showAccountSection = false;
        selectedAccountSection = false;
        showProjectForm = false;
        contactCreated = false;
        accountCreated = false ;
        projectCreated = false ;
        opportunityCreated = false;
        quoteCreated = false ;
        showQuoteSection = false ;
        showNanaQuoteButton = true ;
        accountURLSelected = false;
        conURLSelected = false ;
        projURLSelected = false ;
        oppURLSelected = false ;
        insufficentPrivilege = true ;
        Clone=false;
        Clone_Button=false;
        
        //Default value of the records which needs to be created/shown
        con = new Contact(mailingCountryCode = 'US');
        oppConRole = new nrOpportunityContactRole__c();
        acc = new Account(billingCountryCode = 'US');
        opp = new Opportunity();
        proj = new Project__c(Project_Country__c = 'United States');
        quoteList = new list<Quote__c>() ;
        contactWrapper = new conWrapper();
        accountWrapper = new accWrapper();
        
        if(conUrlId == null){
          conUrlId = System.currentPageReference().getParameters().get('conUrl');
           
           if(conUrlId != null){
           con = [Select Id, AccountId,Name, FirstName,Phone, Email,LastName,MailingCountryCode, MailingStateCode, MailingStreet, MailingCity, MailingPostalCode from Contact where Id = : conUrlId];
          
           contactWrapper.conId = con.Id ;
           oppConRole.Contact__c = con.Id ;
           selectedAccountSection = true; //setting the variable true so that the account section is shown on the page
           contactCreated = true;
           accountCreated = true ;
           showProjectForm = true;
           conURLSelected = true ;
           selectedAccountSection = false;
           showAccountSection = true;
           accountCreateOption = 'Attach To Existing Account' ;

           if (con.AccountId != null) {
               acc = [Select Id, Name, Owner.Name, BillingCountryCode, BillingStateCode, BillingStreet, BillingCity, BillingPostalCode from Account where Id = : con.AccountId];
            }
          }
        }
        
        if(projUrlId == null){
          projUrlId = System.currentPageReference().getParameters().get('projUrl');
          
            if (projUrlId != null && projUrlId != '') {
    
                proj = [select id, name, Close_Date__c,RecordTypeId from Project__c where Id = : projUrlId];
                opp.Project_Name__c = proj.Id ;
                
                projectCreated = true ; 
                showNanaQuoteButton = false ; 
                projURLSelected = true ;
            }
        }
        
        if (accUrlId == null){
            
            accUrlId = System.currentPageReference().getParameters().get('accUrl');
            
            if (accUrlId != null && accUrlId != '') {
            
            acc = [Select Id, Name, Owner.Name, BillingCountryCode, BillingStateCode, BillingStreet, BillingCity, BillingPostalCode from Account where Id = : accUrlId];    
            accountWrapper.accId = accUrlId ;
            
            contactList = new List < SelectOption>();
            contactList.add(new SelectOption('--None--', '--None--'));
            
            for (Contact con : [Select Id, AccountId,Name, FirstName,Phone, Email,LastName,MailingCountryCode, MailingStateCode, MailingStreet, MailingCity, MailingPostalCode from Contact where AccountId = : accUrlId]){
             contactList.add(new SelectOption(con.Id, 'Select Contact:' + ' ' + con.Name));
            }
             
            accountCreated = true ;
            con.AccountId = acc.Id ;
            selectedAccountSection = true; //setting the variable true so that the account section is shown on the page
            contactCreateOption = 'Existing Contact';
            accountCreateOption = 'Attach To Existing Account' ;
            accountURLSelected = true ;
            }
         }
        
        if(oppUrlId == null){
          oppUrlId = System.currentPageReference().getParameters().get('oppUrl');
          
            if (oppUrlId != null && oppUrlId != '') {
                
                opp = [Select Id, Account.Name, Name,AccountId,Project_Name__c, CloseDate, recordTypeID from Opportunity where Id = : oppUrlId]; //list of opportunities to be shown when user selects an existing project
                
                proj = [select id, name, Close_Date__c,RecordTypeId from Project__c where Id = : opp.Project_Name__c];
                opp.Project_Name__c = proj.Id ;
                projectId = proj.Id ;
                
                acc = [Select Id, Name, Owner.Name, BillingCountryCode, BillingStateCode, BillingStreet, BillingCity, BillingPostalCode from Account where Id = : opp.AccountId];
    
                showProjectForm = false;
                contactCreated = true;
                accountCreated = true ;
                projectCreated = true ;
                opportunityCreated = true;
                showQuoteSection = true ;
                showNanaQuoteButton = false ;
                oppURLSelected = true ;
                selectedAccountSection = true; //setting the variable true so that the account section is shown on the page
               
                contactList = new List < SelectOption>();
                contactList.add(new SelectOption('--None--', '--None--'));
            
                for (Contact con : [Select Id, AccountId,Name, FirstName,Phone, Email,LastName,MailingCountryCode, MailingStateCode, MailingStreet, MailingCity, MailingPostalCode from Contact where AccountId = : opp.AccountId]){
                  contactList.add(new SelectOption(con.Id, 'Select Contact:' + ' ' + con.Name));
                }
                
                contactCreateOption = 'Existing Contact';
            }
        }

        //Default value of Contact create option
        if (contactCreateOption == null) {
            contactCreateOption = 'Existing Contact';
        }

        //Default value of Project create option
        if (projectCreateOption == null) {
            projectCreateOption = 'Existing Project';
        }
    }

    /***********************************************************************************************************************************************
             Method Name  :- getContactOption
             @description :- Method which returns list of contact create options
             @param :- NA
    ***********************************************************************************************************************************************/

    public List < SelectOption > getContactOption() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Existing Contact', 'Existing Contact'));
        options.add(new SelectOption('New Contact', 'New Contact'));
        return options;
    }

   
    /***********************************************************************************************************************************************
              Method Name  :- getAccountOption
              @description :- Method which returns list of Account create options
              @param :- NA
    ***********************************************************************************************************************************************/

    public List < SelectOption > getAccountOption() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Attach To Existing Account', 'Attach To Existing Account'));
        options.add(new SelectOption('New Account', 'New Account'));
        return options;
    }

    /***********************************************************************************************************************************************
              Method Name  :- getProjectOption
              @description :- Method which returns list of Project create options
              @param :- NA
    ***********************************************************************************************************************************************/

    public List < SelectOption > getProjectOption() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Existing Project', 'Existing Project'));
        options.add(new SelectOption('New Project', 'New Project'));
        return options;
    }

    /***********************************************************************************************************************************************
              Method Name  :- initializeContactCreateOption
              @description :- Pagereference Method which sets the boolean variable, depending on which the section of the page will be shown/hidden.
                               Also sets the default value Account create option.
              @param :- NA
    ***********************************************************************************************************************************************/

    public pageReference initializeContactCreateOption() {
        
        if (contactCreateOption == 'Existing Contact') {
          //    oppConRole = new nrOpportunityContactRole__c();
            createNewContact = false;
            if(accountURLSelected){
            showAccountSection = true;
            }
            else{
             showAccountSection = false;
            }
            
             if(oppURLSelected){
              showAccountSection = false;
             selectedAccountSection = true;
             }
             else{
             selectedAccountSection = false;    
             }
            
             if(contactWrapper.conId != null){
             oppConRole.Contact__c = contactWrapper.conId ; 
             syncContact();
             }
           } else {
            
            con = new Contact(mailingCountryCode = 'US');
            createNewContact = true;
            createNewAccount = false;
            
             if(oppURLSelected == false){
               showAccountSection = true;
               selectedAccountSection = false;
               accountCreateOption = 'Attach To Existing Account';
             }
            
            contactCreated = false;
            
            if (oppConRole.Contact__c != null){
              contactWrapper.conId = oppConRole.Contact__c ;
            }
            
            if(accountWrapper.accId != null){
             con.AccountId = accountWrapper.accId ; 
           }
          
           }

        return null;
    }

    /***********************************************************************************************************************************************
              Method Name  :- initializeAccountCreateOption
              @description :- Pagereference Method which sets the boolean variable, depending on which the section of the page will be shown/hidden.
              @param       :- NA
    ***********************************************************************************************************************************************/

    public pageReference initializeAccountCreateOption() {

        if (accountCreateOption == 'Attach To Existing Account') {
            createNewAccount = false;
            if(accountWrapper.accId != null){
             con.AccountId = accountWrapper.accId ; 
           }
        } 
        else {
            acc = new Account(billingCountryCode = 'US');
            createNewAccount = true;
            selectedAccountSection = false;
            
            accountCreated = false ;
            
            if (con.AccountId != null){
              accountWrapper.accId = con.AccountId ;
            }
            
        }

        return null;
    }
    
  
    /***********************************************************************************************************************************************
              Method Name  :- initializeProjectCreateOption
              @description :- Pagereference Method which sets the boolean variable, depending on which the section of the page will be shown/hidden.
              @param       :- NA
    ***********************************************************************************************************************************************/

    public pageReference initializeProjectCreateOption() {
        if (projectCreateOption == 'Existing Project') {
            createNewProject = false;

        } else {
            proj = new Project__c(Project_Country__c = 'United States');
            projectCreated = false ;
            createNewProject = true;
            showQuoteSection = false ;
            }

        return null;
    }

    /***********************************************************************************************************************************************
             Method Name  :- CopyAddressFields
             @description :- Pagereference Method which copies the Project Address information from contact address information.
             @param       :- NA
    ***********************************************************************************************************************************************/

    public Pagereference CopyAddressFields() {
        //Map to store the Country code and State code as key and Country Names and State Names as values
        Map < String, Country_codes__c > countryMap = Country_codes__c.getAll();
        Map < String, state_codes__c > stateMap = state_codes__c.getAll();
        
        if (con.MailingCountryCode != null) {
            if (countryMap.containsKey(con.MailingCountryCode)) {
                proj.Project_Country__c = countryMap.get(con.MailingCountryCode).Country__c;
            }
      
        if(con.MailingStateCode == null || con.MailingStateCode == '')
            {
            proj.Project_State__c = '--None--';
            }
                else
            {
        if (stateMap.containsKey(con.MailingStateCode)){ 
             proj.Project_State__c = stateMap.get(con.MailingStateCode).States__c;
            }
           }
      
            proj.Project_Street_Address__c = con.MailingStreet;
            proj.Project_City__c = con.MailingCity;
            proj.Project_Zip_Code__c = con.MailingPostalCode;
        }
        return null;
    }

    /***********************************************************************************************************************************************
              Method Name  :- updateAddressNew
              @description :- Pagereference Method which copies the Account Address information from contact address information.
              @param       :- NA
     ***********************************************************************************************************************************************/

    public Pagereference updateAddressNew() {

        if (con.MailingCountryCode != null) {
            acc.BillingCountryCode = con.MailingCountryCode;
            acc.BillingStateCode = con.MailingStateCode;
            acc.BillingStreet = con.MailingStreet;
            acc.BillingCity = con.MailingCity;
            acc.BillingPostalCode = con.MailingPostalCode;
        }
        return null;
    }
    /***********************************************************************************************************************************************
              Method Name  :- updateContactAddressNew
              @description :- Pagereference Method which copies the Account Address information to contact address information.
              @param       :- NA
     ***********************************************************************************************************************************************/

    public Pagereference updateContactAddressNew() {
        
        if (acc.BillingCountryCode != null) {
            con.MailingCountryCode = acc.BillingCountryCode ;
            con.MailingStateCode = acc.BillingStateCode ;
            con.MailingStreet = acc.BillingStreet ;
            con.MailingCity = acc.BillingCity;
            con.MailingPostalCode = acc.BillingPostalCode ;
        }
        return null;
    }
    
    /***********************************************************************************************************************************************
              Method Name  :- syncAccount
              @description :- Void Method which is called on action function of the page , for querying the account fields which is shown on the page.
              @param       :- NA
     ***********************************************************************************************************************************************/

    public void syncAccount() {


        accountId = '';

        accountId = System.currentPageReference().getParameters().get('accountId');
      //  selectedAccountSection = true; //setting the variable true so that the account section is shown on the page

        if (con.AccountId != null ) {
            acc = [Select Id, Name, Owner.Name, BillingCountryCode, BillingStateCode, BillingStreet, BillingCity, BillingPostalCode from Account where Id = : con.AccountId];
        
         accountCreated = true ;
          
           if (con.AccountId != null){
              accountWrapper.accId = con.AccountId ;
            }
        
        }
    }

    /***********************************************************************************************************************************************
              Method Name  :- syncContact
              @description :- Void Method which is called on action function of the page , for querying the contact and account fields 
                              which is shown on the page.
              @param       :- NA
     ***********************************************************************************************************************************************/

    public void syncContact() {

        contactId = '';

        contactId = System.currentPageReference().getParameters().get('contactId');
        selectedAccountSection = true; //setting the variable true so that the account section is shown on the page

        if (oppConRole.Contact__c != null) {
            try{
            con = [Select Id,Name, AccountId,FirstName,Phone, Email,LastName, MailingCountryCode, MailingStateCode, MailingStreet, MailingCity, MailingPostalCode from Contact where Id = : oppConRole.Contact__c];
            }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'selected Contact is not in Your Territory'));
            } 
              contactWrapper.conId = oppConRole.Contact__c ;
              contactCreated = true;
            
            if (con.AccountId != null) {
                acc = [Select Id, Name, Owner.Name, BillingCountryCode, BillingStateCode, BillingStreet, BillingCity, BillingPostalCode from Account where Id = : con.AccountId];
            }
        }
    }

    /***********************************************************************************************************************************************
             Method Name  :- syncProject
             @description :- Void Method which is called on action function of the page , for querying the project and opportunity fields 
                             which is shown on the page.
             @param       :- NA
    ***********************************************************************************************************************************************/

    public void syncProject() {
        projectId = '';

        projectId = System.currentPageReference().getParameters().get('projectId');
       
        if (projectId != null && projectId != '') {

            proj = [select id, name, Close_Date__c,RecordTypeId from Project__c where Id = : projectId];
            showNanaQuoteButton = false ;
            
            if (acc.Id != null) {
                Set<Id> oppIdSet = new Set<Id>();
                
                for (Opportunity opp : [Select Id,AccountId from Opportunity where Project_Name__c = :  projectId and AccountId =: acc.Id]){
                    oppIdSet.add(opp.Id);
                }
                projectCreated = true ;
                
                if(oppIdSet.size() > 0){ 
                showQuoteSection = true ;
                quoteList = [Select Id, Name,Account_Name__c,Contact__c from Quote__c where Opportunity__c =: oppIdSet and Opportunity__r.AccountId =: acc.Id];
                }
            }

        }
    }

    /***********************************************************************************************************************************************
              Method Name  :- createOpportunityProjects
              @description :- PageReference Method which redirects user to Quote creationstep 2 page(Quote_Wizard_CreateProjectOpportunity). 
                              Querying the records again to avoid any errors due to action function delayed response.
              @param       :- NA
     ***********************************************************************************************************************************************/

    public pageReference createOpportunityProjects() {

        if (contactCreateOption == 'Existing Contact') {
            system.debug('opp con role'+oppConRole.Contact__c);
            if (oppConRole.Contact__c != null) {
                con = [Select Id,Name, FirstName,LastName,Phone, Email,AccountId, MailingCountryCode, MailingStateCode, MailingStreet, MailingCity, MailingPostalCode from Contact where Id = : oppConRole.Contact__c];
                system.debug('contact role'+con.id+'oppconrole'+oppConRole.Contact__c);
                if (con.AccountId != null) {
                    acc = [Select Id, Name, Owner.Name, BillingCountryCode, BillingStateCode, BillingStreet, BillingCity, BillingPostalCode from Account where Id = : con.AccountId];
                }
            }
            
            if(accountURLSelected || oppURLSelected){
                system.debug('selectedContact'+oppURLSelected);
             if(selectedContact != null){
             try{
             con = [Select Id,Name, FirstName,LastName,Phone, Email,AccountId, MailingCountryCode, MailingStateCode, MailingStreet, MailingCity, MailingPostalCode from Contact where Id = : selectedContact];
             system.debug('contactinfo'+con.id);
             }
             Catch(Exception ex){
                
             }
            }
           }  
        }

        if (accountCreateOption == 'Attach To Existing Account') {
            if (con.AccountId != null) {
                acc = [Select Id, Name, Owner.Name, BillingCountryCode, BillingStateCode, BillingStreet, BillingCity, BillingPostalCode from Account where Id = : con.AccountId];
            }
        }

        Boolean validate = validateFields(); //checking all the validation required for account and contact

        if (validate == false) {
            return null;
        } else {
             
               if (opp.Project_Name__c != null) {
    
                proj = [select id, name, Close_Date__c,RecordTypeId from Project__c where Id = : opp.Project_Name__c];
                
                if (acc.Id != null) {
                    Set<Id> oppIdSet = new Set<Id>();
                    
                    for (Opportunity opp : [Select Id,AccountId from Opportunity where Project_Name__c = :  opp.Project_Name__c and AccountId =: acc.Id]){
                        oppIdSet.add(opp.Id);
                    }
                    
                    if(oppIdSet.size() >0){ 
                    showQuoteSection = true ;
                    quoteList = [Select Id, Name,Account_Name__c,Contact__c from Quote__c where Opportunity__c =: oppIdSet and Opportunity__r.AccountId =: acc.Id];
                    } 
                }
               }
               if(projURLSelected){
                return saveAndCreateQuote();
               }
                showProjectForm = true;
                contactCreated = true;
                accountCreated = true ;
                return null;
          }
    }
    
     /***********************************************************************************************************************************************
              Method Name  :- createOpportunityProjects
              @description :- PageReference Method which redirects user to Quote creationstep 2 page(Quote_Wizard_CreateProjectOpportunity). 
                              Querying the records again to avoid any errors due to action function delayed response.
              @param       :- NA
     ***********************************************************************************************************************************************/
             public pageReference goBack() {
                showProjectForm = false;
                contactCreated = true;
                accountCreated = true ;
                Clone_Button=false;
                return null;
             }
    /***********************************************************************************************************************************************
              Method Name  :- saveAndCreateQuote
              @description :- PageReference Method which upserts account, contact, project and opportunity.
                              If there are no error it redirects the user to Quote creation in Nana rep.
              @param       :- NA
     ***********************************************************************************************************************************************/

    public pageReference saveAndCreateQuote() {
    
    System.debug('%%%%%%%%%%%%%');

        Boolean validate = validateProjects(); // checking all the validation required for projects
        
        if (validate == false) {
        
    System.debug('!!!!!!!!!');
            return null;
        } 
        
        else if(validate == true && Clone== true){
            
            //showNanaQuoteButton= false;
            Clone_Button=true;
            
            return null;
        }
      
        else
        {
        
    System.debug('$$$$$$$'+opp.Project_Name__c);
    System.debug('$$$$$$$'+projectCreateOption);

            if (opp.Project_Name__c != null && projectCreateOption == 'Existing Project') {
                proj = [select id, name, Close_Date__c,RecordTypeId from Project__c where Id = : opp.Project_Name__c];
            }

            try {
                 if(accountCreateOption == 'New Account'){
                 upsert acc;
                 UserRecordAccess accAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: acc.Id];
                 if(accAccess.HasReadAccess == false){
                 
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Account as it is not in your territory.'));
                    
                    /*List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo.add('praveen.vallabhaneni@absyz.com');
                    mail.setToAddresses(sendTo);
                    mail.setSubject(' Cross Territory Activity ');
                    mail.setReplyTo(UserInfo.getUserEmail());
                    String body = 'Dear ' +'Praveen'+',<br>' ;
                    
                    
                    body += UserInfo.getName() +' '+'has been created a new Account '+ System.url.getSalesforceBaseUrl().toExternalForm()+'/'+acc.id +' outside own territory ';
                    mail.setHtmlBody(body);
                    mails.add(mail);
                    Messaging.sendEmail(mails);*/
                 
                 
                 insufficentPrivilege = false ;
                 return null ;
                 }
                }
                
                if(contactCreateOption == 'New Contact' && insufficentPrivilege){
                con.AccountId = acc.Id;
                upsert con;
                UserRecordAccess conAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: con.Id];
                if(conAccess.HasReadAccess == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Contact as it is not in your territory.'));
               /* List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo.add('Satish.lokinindi@absyz.com');
                    mail.setToAddresses(sendTo);
                    mail.setSubject('Provided Zipcode outside User Territory ');
                    mail.setReplyTo(UserInfo.getUserEmail());
                    String body = 'Dear ' +',<br>';
                    body += 'User Tried to Create a Contact outside his Territory.<br>';
                    body += '<b>Contact Name</b>'+':' +con.Name + '<br>';
                    body += '<b>Contact ID</b>'  +':' +con.id   + '<br>';
                    mail.setHtmlBody(body);
                    mails.add(mail);
                    Messaging.sendEmail(mails);*/
                insufficentPrivilege = false ;
                return null ;
                }
                }
                
                System.debug('projectCreateOption-------'+projectCreateOption);
                System.debug('insufficentPrivilege------'+insufficentPrivilege);
                
                if(projectCreateOption == 'New Project' && insufficentPrivilege){
                proj.stage__c= 'Quoted';
                upsert proj;
                UserRecordAccess projAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: proj.Id];
                if(projAccess.HasReadAccess == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Project as it is not in your territory.'));
                /*List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo.add('Satish.lokinindi@absyz.com');
                    mail.setToAddresses(sendTo);
                    mail.setSubject('Provided Zipcode outside User Territory ');
                    mail.setReplyTo(UserInfo.getUserEmail());
                    String body = 'Dear ' +',<br>';
                    body += 'User Tried to Create a Project outside his Territory.<br>';
                    body += '<b>Project Name</b>'+':' +proj.Name + '<br>';
                    body += '<b>Project ID </b> '+':' +proj.id   + '<br>';
                    mail.setHtmlBody(body);
                    mails.add(mail);
                    Messaging.sendEmail(mails);*/
                insufficentPrivilege = false ;
                return null ;
                }
                }
               
                Opportunity opp = new Opportunity(); 
                
                RecordType projRecordType = [Select Id,Name from RecordType where id =: proj.RecordTypeId];
                
                if (oppUrlId == null && !showQuoteSection && insufficentPrivilege){
                //Creating the opportunity in the background
                opp.Name = 'Fills_Automatically';
                opp.StageName = 'Quote - Requested';
                    opp.Project_Name__c = proj.Id;
                opp.AccountId = acc.Id;
                if(proj.Close_Date__c != null && proj.Close_Date__c >= system.today()){
                opp.CloseDate = proj.Close_Date__c;
                }
                else{
                opp.CloseDate = date.today().addDays(180);
                }
                if (projRecordType != null){
                 opp.recordTypeID=Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(projRecordType.Name.split(' ')[0]).Opportunity_record_type_name__c).getRecordTypeId();
                }
                
                insert opp;
                
                UserRecordAccess oppAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: opp.Id];
                if(oppAccess.HasReadAccess == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Opportunity as it is not in your territory.'));
                insufficentPrivilege = false ;
                return null ;
                }
                
                //Creating the opportunity contact role in the background
                nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                oppConRole.Contact__c = con.Id; 
                oppConRole.Opportunity__c = opp.Id;
                insert oppConRole;
                }
                system.debug('#$!'+oppUrlId+'projectCreateOption'+projectCreateOption+'insufficentPrivilege'+insufficentPrivilege+' showQuoteSection'+showQuoteSection);
                //removing !showQuoteSection check !!----Praveen
                if(oppUrlId != null && projectCreateOption == 'Existing Project' && insufficentPrivilege){
                 opp = [Select Id, Account.Name, Name,AccountId,Project_Name__c, CloseDate from Opportunity where Id = : oppUrlId]; //list of opportunities to be shown when user selects an existing project
                 System.debug('closed date of opp'+opp.CloseDate);
                 if(contactCreateOption == 'New Contact' && insufficentPrivilege){
                    con.AccountId = acc.Id;
                    upsert con;
                    UserRecordAccess conAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: con.Id];
                    if(conAccess.HasReadAccess == false){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Contact as it is not in your territory.'));
                    insufficentPrivilege = false ;
                    return null ;
                    }
                  }
                  
                  set<Id> contactRoleSet = new set<Id>();
                 
                     for (nrOpportunityContactRole__c oppConRole : [Select Id,Contact__c from nrOpportunityContactRole__c where Opportunity__c =: opp.Id]){
                        contactRoleSet.add(oppConRole.Contact__c);
                     }
                     system.debug('#$!'+con.id+'#$!'+contactWrapper.conId+'#$!'+contactRoleSet.contains(con.id));
                     if((con.id !=null) && !contactRoleSet.contains(con.id)&& (opp.account.Id == con.accountId)){
                            
                        nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                        oppConRole.Contact__c = con.Id; 
                        oppConRole.Opportunity__c = opp.Id;
                        insert oppConRole;  
                     }
                 }
                
                if(opp.Id == null && !showQuoteSection && insufficentPrivilege){
                opp.Name = 'Fills_Automatically';
                opp.StageName = 'Quote - Requested';
                if (projRecordType != null){
                 opp.recordTypeID=Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(projRecordType.Name.split(' ')[0]).Opportunity_record_type_name__c).getRecordTypeId();
                }
                opp.Project_Name__c = proj.Id;
                opp.AccountId = acc.Id;
                if(proj.Close_Date__c != null && proj.Close_Date__c >= system.today()){
                opp.CloseDate = proj.Close_Date__c;
                }
                else{
                opp.CloseDate = date.today().addDays(180);
                }
                insert opp;
                
                UserRecordAccess oppAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: opp.Id];
                if(oppAccess.HasReadAccess == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Opportunity as it is not in your territory.'));
                insufficentPrivilege = false ;
                return null ;
                }
                
                //Creating the opportunity contact role in the background
                if(con.Id != null){
                nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                oppConRole.Contact__c = con.Id; 
                oppConRole.Opportunity__c = opp.Id;
                insert oppConRole;  
                 }
                }
                
                if (showQuoteSection && insufficentPrivilege){
                 opp = [Select Id, Account.Name,Account.Id, Name,AccountId,Project_Name__c from Opportunity where AccountId = : acc.Id and Project_Name__c =: proj.Id limit 1];
                 
                 set<Id> contactRoleSet = new set<Id>();
                 
                 for (nrOpportunityContactRole__c oppConRole : [Select Id,Contact__c from nrOpportunityContactRole__c where Opportunity__c =: opp.Id]){
                    contactRoleSet.add(oppConRole.Contact__c);
                 }
                 if((con.id !=null) && !contactRoleSet.contains(con.id)&& (opp.account.Id == con.accountId)){
                    
                nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                oppConRole.Contact__c = con.Id; 
                oppConRole.Opportunity__c = opp.Id;
                system.debug('###########'+ oppConRole.Opportunity__c +opp.Id+con.id);
                insert oppConRole;  
                 }
                }
                
                if (insufficentPrivilege){
                PageReference pageRef = new PageReference('/a0A/e?CF00NA0000001O58u=' + EncodingUtil.URLENCODE(opp.Name,'UTF-8') + '&CF00NA0000001O58u_lkid=' + opp.Id + '&set=1');
                return pageRef;
                }
                else{
                    return null ;
                }
            }
            Catch(Exception ex) {
                System.debug('$$$$$$$$$$$$$' + ex);
                return null;
            }

        }
    }
 /***********************************************************************************************************************************************
              Method Name  :- CloneAndCreateQuote
              @description :- PageReference Method which upserts account, contact, project and opportunity.
                              If there are no error it redirects the user to Quote creation in Nana rep.
              @param       :- NA
     ***********************************************************************************************************************************************/
   
  /* public pageReference CloneAndCreateQuote() 
   {
      showQuoteSection=false;
       
       
            
            if (opp.Project_Name__c != null && projectCreateOption == 'Existing Project') 
            {
                proj = [Select Id, OwnerId, IsDeleted, Name, RecordTypeId, Actual_Project_Need_Date__c, Amount__c, Application_2__c, Application__c, Architect_Account__c, Architect_Considered__c, Architect_On_Project__c, Award_Date__c, Bid_Date__c, Budget_Quote_Provided__c, Choices__c, Close_Date__c, Corporate_Account__c, Dodge_Number__c, End_Customer_Contact__c, Estimated_Project_Need_Date__c, Expected_Install_Date__c, Expected_Open_Date__c, Explicit_Score__c, HighRise__c, How_Many_Models__c, Implicit_Contact__c, Installer_Email_Viewed__c, Lead_Source__c, Model_Home__c, Nearby_Showrooms__c, Office_Interior__c, OldProjectId__c, Opportunity_ID__c, Opportunity_Name__c, Ordering_Account__c, Preliminary_Drawings_Date__c, Preliminary_Drawings__c, Primary_Campaign_Source__c, Prizm_4__c, Project_City__c, Project_Coordinator__c, Project_Country__c, Project_Has_Competitor__c, Project_Implicit_Score__c, Project_State__c, Project_Street_Address__c, Project_Zip_Code__c, Public_Spec_d_Job__c, Publicly_Specified_Jobs__c, Purchasing_Method__c, Reason_Project_Lost__c, Residential_Vertical__c, Sale_Resulting_From_Model__c, Stage__c, Use_Ordering_Account_Address__c, Use_Project_Address__c, Use_Shipping_Address__c, Web_Project__c, Split_Stage__c, Influencer_Count__c, Opportunity_Count__c, TerritoryName__c FROM Project__c where Id = : opp.Project_Name__c];
                
                
                   
                       Proj_Clone = proj.clone(false, true, false, false);
                       insert Proj_Clone;
                       Cloned_Project_Name__c Clname = Cloned_Project_Name__c.getOrgDefaults();
                       String clp = Clname.Name;
                       Proj_Clone.Name=Proj_Clone.Name+clp;
                       Proj_Clone.Stage__c='Quoted';
                       update Proj_Clone;
                        cloneprojid=Proj_Clone.RecordTypeId;
                    System.debug('cloned pro------'+cloneprojid);
                
                //String getRefere = ApexPages.currentPage().getHeaders().get('referer');
                User userlist = [select id, profile.Name from user WHERE id=:proj.Ownerid];
                if(userlist.profile.Name=='NanaRepPartnerProfile2' || userlist.profile.Name=='NanaRepPartnerProfile')
                {
                      // string BaseURL =  System.url.getSalesforceBaseUrl().toExternalForm();
                       
                       Proj_Clone.Old_Project_Link__c= label.OrgUrl +'/reps/'+Proj.id;
                       update Proj_Clone;
                    
                }
                else
                {
                     //string BaseURL =  System.url.getSalesforceBaseUrl().toExternalForm();
                       
                       Proj_Clone.Old_Project_Link__c= label.OrgUrl +'/'+Proj.id;
                       update Proj_Clone;                    
                }
                      
                      
                   
              System.debug('projclone---'+Proj_Clone);
                
            }

            try {
                 if(accountCreateOption == 'New Account'){
                 upsert acc;
                 UserRecordAccess accAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: acc.Id];
                 if(accAccess.HasReadAccess == false){
                 
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Account as it is not in your territory.'));
    
                 
                 
                 insufficentPrivilege = false ;
                 return null ;
                 }
                }
                
                if(contactCreateOption == 'New Contact' && insufficentPrivilege){
                con.AccountId = acc.Id;
                upsert con;
                UserRecordAccess conAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: con.Id];
                if(conAccess.HasReadAccess == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Contact as it is not in your territory.'));
         
                insufficentPrivilege = false ;
                return null ;
                }
                }
                
                if(projectCreateOption == 'New Project' && insufficentPrivilege){
                Proj_Clone.stage__c= 'Quoted';
                upsert Proj_Clone;
                UserRecordAccess projAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: Proj_Clone.Id];
                if(projAccess.HasReadAccess == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Project as it is not in your territory.'));
               
               insufficentPrivilege = false ;
                return null ;
                }
                }
               
                Opportunity opp = new Opportunity(); 
                
                RecordType projRecordType = [Select Id,Name from RecordType where id =: cloneprojid];
              
                
                if (oppUrlId == null && !showQuoteSection && insufficentPrivilege){
                //Creating the opportunity in the background
                opp.Name = 'Fills_Automatically';
                opp.StageName = 'Quote - Requested';
                opp.Project_Name__c = Proj_Clone.Id;
                opp.AccountId = acc.Id;
                if(Proj_Clone.Close_Date__c != null && Proj_Clone.Close_Date__c >= system.today()){
                opp.CloseDate = Proj_Clone.Close_Date__c;
                }
                else{
                opp.CloseDate = date.today().addDays(180);
                }
                if (projRecordType != null){
                 opp.recordTypeID=Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(projRecordType.Name.split(' ')[0]).Opportunity_record_type_name__c).getRecordTypeId();
                }
                    System.debug('opp recordtypeeeeeee---------'+opp.recordTypeID);
                

                insert opp;
                
                UserRecordAccess oppAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: opp.Id];
                if(oppAccess.HasReadAccess == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Opportunity as it is not in your territory.'));
                insufficentPrivilege = false ;
                return null ;
                }
                
                //Creating the opportunity contact role in the background
                nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                oppConRole.Contact__c = con.Id; 
                oppConRole.Opportunity__c = opp.Id;
                insert oppConRole;
                }
                system.debug('#$!'+oppUrlId+'projectCreateOption'+projectCreateOption+'insufficentPrivilege'+insufficentPrivilege+' showQuoteSection'+showQuoteSection);
                //removing !showQuoteSection check !!----Praveen
                if(oppUrlId != null && projectCreateOption == 'Existing Project' && insufficentPrivilege){
                 opp = [Select Id, Account.Name, Name,AccountId,Project_Name__c from Opportunity where Id = : oppUrlId]; //list of opportunities to be shown when user selects an existing project
                 opp.Project_Name__c=Proj_Clone.Id;
                 update opp;
                 if(contactCreateOption == 'New Contact' && insufficentPrivilege){
                    con.AccountId = acc.Id;
                    upsert con;
                    UserRecordAccess conAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: con.Id];
                    if(conAccess.HasReadAccess == false){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Contact as it is not in your territory.'));
                    insufficentPrivilege = false ;
                    return null ;
                    }
                  }
                  
                  set<Id> contactRoleSet = new set<Id>();
                 
                     for (nrOpportunityContactRole__c oppConRole : [Select Id,Contact__c from nrOpportunityContactRole__c where Opportunity__c =: opp.Id]){
                        contactRoleSet.add(oppConRole.Contact__c);
                     }
                     system.debug('#$!'+con.id+'#$!'+contactWrapper.conId+'#$!'+contactRoleSet.contains(con.id));
                     if((con.id !=null) && !contactRoleSet.contains(con.id)&& (opp.account.Id == con.accountId)){
                            
                        nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                        oppConRole.Contact__c = con.Id; 
                        oppConRole.Opportunity__c = opp.Id;
                        insert oppConRole;  
                     }
                 }
                
                if(opp.Id == null && !showQuoteSection && insufficentPrivilege){
                opp.Name = 'Fills_Automatically';
                opp.StageName = 'Quote - Requested';
                if (projRecordType != null){
                 opp.recordTypeID=Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(projRecordType.Name.split(' ')[0]).Opportunity_record_type_name__c).getRecordTypeId();
                }
                opp.Project_Name__c = Proj_Clone.Id;
                opp.AccountId = acc.Id;
                if(Proj_Clone.Close_Date__c != null && Proj_Clone.Close_Date__c >= system.today()){
                opp.CloseDate = Proj_Clone.Close_Date__c;
                }
                else{
                opp.CloseDate = date.today().addDays(180);
                }
                insert opp;
                
                UserRecordAccess oppAccess = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: opp.Id];
                if(oppAccess.HasReadAccess == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You do not have access to create Quote on the created Opportunity as it is not in your territory.'));
                insufficentPrivilege = false ;
                return null ;
                }
                
                //Creating the opportunity contact role in the background
                if(con.Id != null){
                nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                oppConRole.Contact__c = con.Id; 
                oppConRole.Opportunity__c = opp.Id;
                insert oppConRole;  
                 }
                }
                
                if (showQuoteSection && insufficentPrivilege){
                 opp = [Select Id, Account.Name,Account.Id, Name,AccountId,Project_Name__c from Opportunity where AccountId = : acc.Id and Project_Name__c =: Proj_Clone.Id limit 1];
                 
                 set<Id> contactRoleSet = new set<Id>();
                 
                 for (nrOpportunityContactRole__c oppConRole : [Select Id,Contact__c from nrOpportunityContactRole__c where Opportunity__c =: opp.Id]){
                    contactRoleSet.add(oppConRole.Contact__c);
                 }
                 if((con.id !=null) && !contactRoleSet.contains(con.id)&& (opp.account.Id == con.accountId)){
                    
                nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                oppConRole.Contact__c = con.Id; 
                oppConRole.Opportunity__c = opp.Id;
                system.debug('###########'+ oppConRole.Opportunity__c +opp.Id+con.id);
                insert oppConRole;  
                 }
                }
                
                if (insufficentPrivilege){
                PageReference pageRef = new PageReference('/a0A/e?CF00NA0000001O58u=' + EncodingUtil.URLENCODE(opp.Name,'UTF-8') + '&CF00NA0000001O58u_lkid=' + opp.Id + '&set=1');
                return pageRef;
                }
                else{
                    return null ;
                }
            }
            Catch(Exception ex) {
                System.debug('$$$$$$$$$$$$$' + ex);
                return null;
            }

        
        
   }*/
   
    /***********************************************************************************************************************************************
              Method Name  :- validateProjects
              @description :- Boolean Method which returns true if all the project passes all the validation.
              @param       :- NA
      ***********************************************************************************************************************************************/

    public boolean validateProjects() {
        set<string> prozips =new set<string>();
        boolean Validated = true;
        
        if (projectCreateOption == 'Existing Project') {
            
            if(opp.Project_Name__c != null){
            proj = [select id, name, Project_Zip_Code__c, Project_Country__c, Project_State__c, Close_Date__c,RecordTypeId,Stage__c from Project__c where Id = : opp.Project_Name__c];
            }
            if(proj.Stage__c =='Closed Won - Order Signed'||proj.Stage__c =='Closed Won - Order In Process'||proj.Stage__c =='Closed Complete - Ordered - Paid'||proj.Stage__c =='Closed Lost - Project Lost'||proj.Stage__c =='Closed Lost - Project Cancelled'){
                //Validated = true;
               //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Project is already Closed ,please Click on Clone & Create NewQuote Button.'));
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'To reopen a Closed Project please contact Ozair Nana or Taha Nana in Order Operations Team'));
                //oppURLSelected =false;
                //Validated = false;
                //Clone=True;
            }
            
            if (proj.Name == null) {
                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'If you are using an existing project you must select a project.'));
            }
        }

        if (projectCreateOption != 'Existing Project') {
            if ((proj.Project_State__c == '' || proj.Project_State__c == null) && (proj.Project_Country__c == 'Mexico')) {
                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Project State is required'));
            }
            
            if (proj.Project_Zip_Code__c != null &&  proj.Project_Zip_Code__c != '' && proj.Project_Country__c=='United States') {
                
                if(proj.Project_Country__c=='United States'){
                    prozips.add(proj.Project_Zip_Code__c.substring(0,5));
                }
                
             list<Zip_Codes_Master__c> z =[Select Zip_Code__c, user__c,state__c,country__c from Zip_Codes_Master__c WHERE (Zip_Code__c IN: prozips)];
       
             if (z.size()==0 ){
               Validated = false;
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Project zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>'));
             } }
           
        }
        /*if(oppUrlId != null && showQuoteSection){
            opp = [select id,Name,Project_Name__c, StageName from Opportunity Where id =:oppUrlId];
            if(opp.StageName=='Bid Unsuccessful'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Opportunity is already Bid Unsuccessfull.'));
                Validated = false;
            }
        }*/
        return Validated;
    }

    /***********************************************************************************************************************************************
             Method Name  :- validateFields
             @description :- Boolean Method which returns true if all the account and contact passes all the validation.
             @param       :- NA
     ***********************************************************************************************************************************************/

    public boolean validateFields() {
        set<string> zipsAll = new set<string>();
        set<string> conzips = new set<string>();
         
        boolean Validated = true;

        if (contactCreateOption != 'Existing Contact') {
            
            if(con.FirstName == null || con.FirstName == ''){
                Validated = false;
                con.FirstName.addError('You must enter a value');   
            }
            
            if(con.LastName == null || con.LastName == ''){
                Validated = false;
                con.LastName.addError('You must enter a value');    
            }
            
             if(con.Email == null || con.LastName == ''){
                Validated = false;
                con.Email.addError('You must enter a value');   
            }
            
            /*if(con.MailingPostalCode == null || con.LastName == ''){
                Validated = false;
                con.MailingPostalCode.addError('You must enter a value');   
            }*/
            
            if(con.email != null){
            list<contact> conEmailList= [ select id, email from contact where email =: con.email];
            list<Lead> ledEmailList =[select id,email, IsConverted from lead where email =:con.email AND IsConverted != true];
            system.debug('size$$$$'+ conEmailList.size() + con.email);
            if(conEmailList.size()>0){
               validated= false;
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There is already an existing contact with the same email address. Please enter a different email address or select an existing contact'));
               }
             if(ledEmailList.size()>0){
             Validated = false;
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There is already an existing Lead with the same email address. Please enter a different email address.'));

             }
             
            }
            if (con.MailingCountryCode == 'MX' && (con.MailingStateCode == '' || con.MailingStateCode == null)) {
                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a state for the selected Contact Country'));
            }
            
            if (con.MailingCountryCode != '' && con.MailingCountryCode != null && con.MailingPostalCode != '' && con.MailingPostalCode != null && !(validateZip(con.MailingPostalCode, con.MailingCountryCode))) {

                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a valid zip Code for Contact'));
            }
           if ((con.MailingCountryCode =='US' || con.MailingCountryCode == 'CA') && (con.MailingPostalCode =='' || con.MailingPostalCode == null)) {
            System.debug('errot'+con.MailingCountryCode);
                Validated = false;
                con.MailingPostalCode.addError('You must enter a value');
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please Enter  zip Code for Selected Country'));
           }
           if (con.MailingPostalCode != null &&  con.MailingPostalCode != '' && con.MailingCountryCode=='US') {
                
                if(con.MailingCountryCode=='US'){
                    conzips.add(con.MailingPostalCode.substring(0,5));
                }
             
          
           list<Zip_Codes_Master__c> z =[Select Zip_Code__c, user__c,state__c,country__c from Zip_Codes_Master__c WHERE (Zip_Code__c IN: conzips)];
       
             if (z.size()==0 ){
               Validated = false;
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Mailing zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>'));
              }
            }
          }
        else{
            if(con.Id == null && oppURLSelected == false){
              Validated = false;
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'If you are using an existing Contact you must select a Contact.'));
            }
            if(selectedContact == '--None--'){
             Validated = false;
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'If you are using an existing Contact you must select a Contact.'));
            }
        }

        if (accountCreateOption == 'Attach To Existing Account') {

            if (con.AccountId == null) {
                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select an Account'));
            }
        }

        if (accountCreateOption != null && accountCreateOption != 'Attach To Existing Account') {

            /*if (acc.BillingPostalCode == null || acc.BillingPostalCode == '') {

                Validated = false;
                acc.BillingPostalCode.addError('Account Billing Zip/Postal Code : You must enter a value');

            }*/

            if (acc.BillingCountryCode == 'MX' && (acc.BillingStateCode == null || acc.BillingStateCode == '')) {
                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a state for the selcted Account Country'));
            }

            if (acc.BillingCountryCode != '' && acc.BillingCountryCode != null && acc.BillingPostalCode != '' && acc.BillingPostalCode != null && !(validateZip(acc.BillingPostalCode, acc.BillingCountryCode))) {

                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a valid zip Code for Account'));

            }
            if ( (acc.BillingCountryCode =='US' || acc.BillingCountryCode == 'CA') && (acc.BillingPostalCode =='' || acc.BillingPostalCode == null)) {
                Validated = false;
                acc.BillingPostalCode.addError('You must enter a value');
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please Enter  zip Code for Selected Country'));
           }
           if (acc.BillingPostalCode != null &&  acc.billingPostalCode != '' && acc.BillingcountryCode=='US') {
                
                if(acc.billingCountryCode=='US'){
                    zipsAll.add(acc.BillingPostalCode.substring(0,5));
                }
             
          
           list<Zip_Codes_Master__c> z =[Select Zip_Code__c, user__c,state__c,country__c from Zip_Codes_Master__c WHERE (Zip_Code__c IN: zipsAll)];
       
             if (z.size()==0 ){
               Validated = false;
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Billing zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>'));
             } }
            
        }
        return Validated;
    }

    /***********************************************************************************************************************************************
             Method Name  :- validateZip
             @description :- Boolean Method which returns true for contact and account if it passes zip code validation
             @param       :- NA
     ***********************************************************************************************************************************************/

    public boolean validateZip(String zipCode, String CountryCode) {
        string zipUS = '\\d{5}(-\\d{4})?';
        string zipCan = '((?i)[ABCEGHJKLMNPRSTVXY]\\d[A-Z]?\\s?\\d[A-Z]\\d)?';

        Boolean returnValue = false;

        if (CountryCode != null && zipCode != null && ((CountryCode == 'US' && !(pattern.matches(ZipUS, zipCode))) || (CountryCode == 'CA' && !(pattern.matches(zipCan, zipCode))))) {

            returnValue = false;
        } else {
            returnValue = true;
        }

        return returnValue;

    }
    
    public class conWrapper {
        
        public string conId {get;set;}
        /*
        public string firstName {get;set;}
        public string lastName {get;set;}
        public string phone {get;set;}
        public string email {get;set;}
        public string mailStreet {get;set;}
        public string mailCity {get;set;}
        public string mailPostalCode {get;set;}
        public string mailCountryCode {get;set;}
        public string mailStreetCode {get;set;}
        */
    }
    
    public class accWrapper {
        
        public string accId {get;set;}
        
    }   

}