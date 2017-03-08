public class SinglePageLeadConvertController {
/*
    public Account newAccount = new Account(billingCountryCode='US');
    public Account getnewaccount() { return newAccount; }
    public void setnewaccount( Account a ) { newAccount = a;  }
    public String sAppIndus{get;set;}
    public String sApplication {get; set;}
    public Contact newContact{get;set;}

    public Contact getnewcontact() { return newcontact; }   
    public void setnewcontact( Contact c ) { newcontact = c; }

    public Opportunity newOpportunity = new Opportunity(name='This field will be auto populated');
    public Opportunity getnewopportunity() { return newopportunity; }
    public void setnewopportunity( Opportunity o ){ newopportunity = o; } 

    public Project__c newproject{get; set;}
    public Account existAccount {get; set;}


    public Task newTask = new Task();
    public Task getnewtask() { return newtask; }
    public void setnewtask( Task t ){ newtask = t; }



    public Boolean createTask { get; set; }
    public Boolean createOpportunity { get; set; }
    public Boolean createProject { get; set;}
    public boolean showsyncpanel { get; set; }
    public string selectedType {get; set;}

    public boolean initialized = false;

    public SinglePageLeadConvertController() {

        if(!initialized)
        {
            newContact = new Contact();
            createOpportunity = true;
            createProject = true;
            createTask = false;     
            selectedType='Residential';    
            //          ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, 'Initializing page ...' ));
            showsyncpanel = false;
            showdupeblock = false;
            newContact.mailingCountryCode = 'US';
            newAccount.Country__c = 'United States';
            newProject = new Project__c(project_country__c='United States');
            //          newContact.MailingS
        }

        initialized = true;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('existing','Existing')); 
        options.add(new SelectOption('new','New'));
        return options;
    }
    public List<SelectOption> getPros() {
        List<SelectOption> proValues = new List<SelectOption>(); 
        proValues.add(new SelectOption('existing','Existing'));
        proValues.add(new SelectOption('new','New')); 
        return proValues;
    }
    public List<selectOption> getrecType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption ('Residential','Residential'));
        options.add(new SelectOption ('Commercial','Commercial'));
        return options;
    }

    public list<SelectOption> getAppItems()
    {
        List<SelectOption> lstOptions = new List<SelectOption>();
        lstOptions.add(new SelectOption('--None--','--None--'));
        system.debug('Check::'+selectedType);
        if(selectedType=='Residential')
        {
            //lstOptions.add(new SelectOption('Residential','Residential'));
            lstOptions.add(new SelectOption('Multifamily - Remodel','Multifamily - Remodel'));
            lstOptions.add(new SelectOption('Multifamily - New','Multifamily - New'));
            lstOptions.add(new SelectOption('Single Family - New','Single Family - New'));
            lstOptions.add(new SelectOption('Single Family - Remodel','Single Family - Remodel'));
            
        }
        else
        {
            lstOptions.add(new SelectOption('Automotive','Automotive'));
            lstOptions.add(new SelectOption('Education','Education'));
            lstOptions.add(new SelectOption('Health Care','Health Care'));
            lstOptions.add(new SelectOption('Hotel','Hotel'));
            lstOptions.add(new SelectOption('Office','Office'));
            lstOptions.add(new SelectOption('Other Industries','Other Industries'));   
            lstOptions.add(new SelectOption('Recreation/Entertainment','Recreation/Entertainment'));
            lstOptions.add(new SelectOption('Religious Institutions','Religious Institutions')); 
            lstOptions.add(new SelectOption('Retail','Retail'));
            lstOptions.add(new SelectOption('Restaurant','Restaurant'));
            lstOptions.add(new SelectOption('Sports Venue','Sports Venue')); 
            lstOptions.add(new SelectOption('Other','Other'));        
        } 
        return lstOptions;
    }

    public list<selectOption> getApplications()
    {   list <selectoption> lstApp = new List<selectOption>();
    if(!String.isblank(sAppIndus) && sAppIndus !='--None--'){
        lstApp.add(new SelectOption('--None--','--None--'));

        list<string> newApp = app_value__c.getinstance(sAppIndus).application__c.split(',');

        if(newApp.size()>0){
            for(string s : newApp){
                lstApp.add(new selectOption(s,s));
            }

        }
        return lstApp;

    }else { lstApp.add(new SelectOption('--None--','--None--'));
    return lstApp; }
    }



    string useExistingAccount = 'existing';
    public string getaccounttype() { return useExistingAccount; }
    public void setaccounttype( string u ) { useExistingAccount = u; }

    string useExistingproject='existing';
    public string getprojects(){ return useExistingProject;}
    public void setprojects( string pro){ useExistingProject=pro;}

    private list<Opportunity> duplicateOpps = new list<Opportunity>();
    public list<Opportunity> getduplicateopps() { return duplicateopps; }

    
    public boolean validateFields() {

        boolean Validated = true;

        if( newContact.FirstName == '' || newContact.FirstName == null ) {
            Validated=false;
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Contact First Name is required'));
        }
        if( newContact.LastName == '' || newContact.LastName == null ) 
        {
            Validated=false;
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Contact Last Name is required'));
        }
        //      if( newContact.Zip__c == '' || newContact.Zip__c == null ) 
        if( (newContact.MailingPostalCode == '' || newContact.MailingPostalCode == null) && (newContact.MailingCountryCode=='US' || newContact.MailingCountryCode=='CA') ) 
        {
            Validated=false;
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Contact Zip Code is required'));
        } 
        if( newContact.MailingCountryCode == '' || newContact.MailingCountryCode == null )  
        {
            Validated=false;
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Contact Country is required'));       
        }  
        if( (newContact.MailingCountryCode=='MX' || newContact.MailingCountryCode=='CA'|| newContact.MailingCountryCode=='US') && (newContact.MailingStateCode=='' || newContact.MailingStateCode==null )) 
        {
            Validated=false;
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Please select a state for the selected Country'));
        }   
        if( useExistingAccount == 'new' )
        {
            if( newAccount.name == '' || newAccount.name == null )  
            {
                Validated=false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Account Name is required'));      
            }
            //          if( newAccount.Zip__c == '' || newAccount.Zip__c == null )  
            if( (newAccount.BillingCountryCode == 'MX' || newAccount.BillingCountryCode == 'US' || newAccount.BillingCountryCode == 'CA' ) && ( newAccount.BillingStateCode == null || newAccount.BillingStateCode == ''))  
            {
                Validated=false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Please select a state for the selcted Country'));       
            }
            if( newAccount.BillingPostalCode == '' || newAccount.BillingPostalCode == null && newAccount.BillingCountryCode=='US' || newAccount.BillingCountry=='CA' )    
            {    
                Validated= false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Account Zip Code is required'));
                if( newContact.MailingPostalCode != null )
                {
                    Validated=false;
                    newAccount.BillingPostalCode = newContact.MailingPostalCode;
                }
            }
            //          if( newAccount.Country__c == '' || newAccount.Country__c == null )  
            if( newAccount.BillingCountryCode == '' || newAccount.BillingCountryCode == null )  
            {
                Validated=false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Account Country is required'));       
            }
        } else if (newContact.AccountId == null )
        {
            Validated=false;
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'If you are using an existing account you must select an account.'));      

        }
        if(createProject && (useExistingproject =='new' || useExistingProject =='existing'))
        {
            if((newProject.name ==''||newproject.name ==null) && useExistingproject =='new'){
                Validated=false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Project Name is required'));
            }
            if(sAppIndus == '--None--' && useExistingproject =='new'){
                Validated=false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Project Application industry is required'));
            }
            if(sApplication =='--None--' && useExistingproject =='new'){
                Validated=false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Project Application is required'));
            }
            if((newProject.Project_Zip_Code__c==''|| newProject.Project_Zip_Code__c==null) && useExistingproject =='new' && (newProject.Project_Country__c=='United States' || newProject.Project_Country__c=='Canada')){
                Validated=false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Project zipcode is required'));
            }
            if((newProject.Project_State__c==''|| newProject.Project_state__c==null) && useExistingproject =='new' && (newProject.Project_Country__c=='Mexico' || newProject.Project_Country__c=='United States' || newProject.Project_Country__c=='Canada')){
                Validated=false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'Project State is required'));
            }
            if(useExistingProject=='existing' && newOpportunity.Project_Name__c==null){
                Validated = false;
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,'If you are using an existing project you must select a project.'));
            }
        }
        newOpportunity.StageName = 'Quote - Requested';
        
        system.debug('the value is' + validated);

        return Validated;
    }

    public boolean showdupeblock { get; set; }

    public boolean useduplicateproject = false;
    public PageReference continueWithProject() {
        useduplicateproject = true;
        return CreateObjects();
    }

    public PageReference CreateObjects() {


        if( !validateFields() )
        {
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR, 'Please check all of your entries. You missed some required information.' ));         
            return null;
        }

        Savepoint sp = Database.setSavepoint();
        if(newAccount.Id!=null)
            newAccount.Id=null;
        if(newContact.Id!=null)
            newContact.Id=null;
        try {   

            if( useExistingAccount == 'new'){
                upsert newAccount;
                if(newAccount.Id!=null)
                    newContact.AccountId = newAccount.id;
            }
            System.debug('&&&&&&&&&&&&' + newContact);
            
            upsert newContact;

            Contact contWithOwner = [SELECT id, ownerid FROM Contact WHERE id = :newcontact.id ];

            if(createproject){  
                if(useExistingProject== 'new'){
                    system.debug('Chck for values::'+newproject);
                    newproject.recordTypeID = Schema.getGlobalDescribe().get('Project__c').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(selectedType).Project_record_type_name__c).getRecordTypeId();
                    if(sAppIndus!='--None--')
                        newProject.Application__c = sAppIndus;
                    newProject.Application_2__c=sApplication;
                    newProject.stage__c='Prospecting';
                    newProject.Close_date__c=system.today();
                    insert newproject ;
                }
            }

            if( createOpportunity )
            {
                if(useExistingProject== 'existing'){
                    if(newProject.Id==null && newOpportunity.Project_Name__c!=null){
                        List<Project__c> existPrj = [SELECT stage__c,close_date__c,recordTypeId,recordType.Name FROM project__c WHERE Id=:newOpportunity.Project_Name__c LIMIT 1];
                        newOpportunity.stageName = existPrj[0].stage__c=='Pospecting'?'Need Analysis':'Quote - Requested';
                        if(newOpportunity.closeDate==null){
                            newOpportunity.closeDate = existPrj[0].Close_Date__c < system.today()?system.today().addDays(180):existPrj[0].Close_Date__c;
                        }
                        newOpportunity.recordTypeID=Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(existPrj[0].recordType.name.split(' ')[0]).Opportunity_record_type_name__c).getRecordTypeId();
                    }
                }
                if(useExistingproject=='new'){
                    newOpportunity.CloseDate = system.today().addDays(180);
                    newOpportunity.recordTypeID=Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get(Record_type_assign__c.getinstance(selectedType).Opportunity_record_type_name__c).getRecordTypeId();
                }
                newopportunity.name= 'Fills_Automatically';
                if(newOpportunity.closeDate==null){
                    newOpportunity.CloseDate = system.today().addDays(180);
                }

                newOpportunity.OwnerId = contWithOwner.OwnerId;
                if(newOpportunity.Project_Name__c == null && newProject.Id!=null){ 
                    newOpportunity.Project_Name__c = newProject.Id; 
                }
                newOpportunity.AccountID=newContact.Accountid;
                upsert newOpportunity;

                nrOpportunityContactRole__c newContactRole = new nrOpportunityContactRole__c ();
                newContactRole.Opportunity__c=newopportunity.id;
                newContactRole.Contact__c=newContact.id;
                if(newContact.LeadType__c != null) {
                    newContactRole.Role__c= newContact.LeadType__c;
                } 
                else 
                    newContactRole.Role__c='Other';
                insert newContactRole;

            }       

            if( createTask )
            {
                if( createOpportunity ){
                    newtask.WhatId = newOpportunity.id;
                }
                else{    
                    newTask.WhatId = newContact.AccountId;
                    newTask.WhoId = newContact.id;
                    newTask.OwnerId = contWithOwner.OwnerId;         
                    insert newTask;
                }
            }       

            showsyncpanel = true;

            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, 'Done !' ));   
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, '<a href="/'+newcontact.accountid+'" target="_blank">Account</a>' ));  
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, '<a href="/'+newcontact.id+'" target="_blank">Contact</a>' )); 
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, '<a href="/'+Newopportunity.id+'" target="_blank">Opportunity</a>' )); 

            try {
                set<id> accIds = new set<id>();
                accIds.add(newcontact.AccountId);
                Async_WebServiceCaller.SynchronizeAccounts(accIds);

                set<id> contIds = new set<id>();
                contIds.add(newContact.Id);
                Async_WebServiceCaller.SynchronizeContacts(contIds);
            } catch( Exception ex )
            {

            }

            if(newOpportunity.Id!=null)
                return new PageReference('/'+newOpportunity.Id);
            else
                return new PageReference('/'+newContact.Id);
        }  catch( DmlException dex ) {
            Database.rollback(sp);
            showdupeblock = false;
            if(!dex.getMessage().contains('valid Zip') && !ApexPages.hasMessages()){
                ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR,dex.getMessage()));
            }            
        } catch( Exception ex ) {
            showdupeblock = false;
            Database.rollback(sp);
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR, 'Caught an error when creating objects. ' + ex ));    
        }
        return null;
    }


    public void onProjectCheck()
    {
        system.debug('Check for Value::'+createProject);
        if(!createProject)
        {
            createOpportunity = false;
        }
        else
        {
            createOpportunity = true;
        }

        system.debug('Check for Opp Value::'+createOpportunity);
    }

    public Pagereference updateAddressNew()
    {
        String sCountry = String.valueOf(newContact.MailingCountryCode);
        system.debug('Check::'+newContact.MailingCountryCode+'Check 2::'+sCountry);
        if(newContact.MailingCountryCode!=null)
        {
            newAccount.BillingCountryCode = newContact.MailingCountryCode;
            newAccount.BillingStateCode = newContact.MailingStateCode;
            newAccount.BillingStreet = newContact.MailingStreet;
            newAccount.BillingCity = newContact.MailingCity;
            newAccount.BillingPostalCode = newContact.MailingPostalCode;
        }
        return null;
    }
*/
}