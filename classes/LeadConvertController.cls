public  class LeadConvertController {


    public class testexception extends Exception {}



    public void sendExceptionEmail(Exception e )
    {
    if(!Test.isRunningTest()){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('admin@a-stechnologies.com');   
        mail.setSenderDisplayName('Salesforce - Lead conversion exception');
        mail.setSubject('Lead conversion exception' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' Lead conversion encountered an exception during "'+stage+'" when '+UserInfo.getName() +' ('+UserInfo.getUserId()+') tried to convert '+l.id+' <br />' + e  );
        mail.setHtmlBody(' Lead conversion encountered an exception during "'+stage+'" when '+UserInfo.getName() +' ('+UserInfo.getUserId()+') tried to convert  '+l.id+' <br />' + e );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
       } 
    }

    private boolean useexistingproject = false;
    private string dupeprojectid = '';
    public string getdupeprojectid() {return dupeprojectid;}
    public void setdupeprojectid(string id) { dupeprojectid = id; } 


    private string convertedContactID = '';
    public string getConvertedContactID() { return convertedContactID; }
    
    private string convertedContactName = '';
    public string getConvertedContactName() { return convertedContactName; }
    
    private boolean showalreadyconvertedblock = false;
    public boolean getshowalreadyconvertedblock() { return showalreadyconvertedblock; }


    private boolean ShowBackButton = false;
    public boolean getShowBackButton() { return ShowBackButton; }

    private boolean showdupeblock = false;
    public boolean getshowdupeblock() { return showdupeblock; }
 
    private Opportunity newOpportunity = new Opportunity();
    public Opportunity getnewopportunity(){ return newopportunity; }
    public void setnewopportunity( Opportunity o ) { newOpportunity = o; }


    private final Lead l;
    public LeadConvertController(ApexPages.StandardController stdController) {
        this.l = (Lead)stdController.getRecord();
        
        if( l.IsConverted )
        {
        
            showalreadyconvertedblock = true;
            showdupeblock = false;
            convertedContactID = l.ConvertedContactId;
            Contact c = [SELECT FirstName, LastName, id FROM COntact where id = :l.ConvertedContactId ];
            convertedContactName = c.FirstName + ' ' + c.LastName;
        } 
        
        this.newOppName = '';
        this.newAccName = l.Company;
        this.dummyContact = new Contact();
        if( this.newOpportunity.city__c == null || this.newOpportunity.city__c == '' )
            this.newOpportunity.city__c = l.nrCity__c;
        if( this.newOpportunity.state__c == null || this.newOpportunity.state__c == '' )
            this.newOpportunity.state__c = l.nrState__c;
    }
    
    public PageReference ToggleAccountType() {
        
        
     
        return null;
    }
    
    private boolean createTask = false;
    public boolean getCreateTask() { return createTask; }
    public void setCreateTask( boolean Create ) { createTask = Create; }
    
    Task newTask = new Task();
    public Task getTask() { return newTask; }
    public void setTask( Task t ) { newTask = t; }

    /* task fields */
    string taskSubject = '';
    public string getTaskSubject(){ return taskSubject; }
    public void setTaskSubject( string Subject ) { taskSubject = Subject; }
    /* end task fields*/
    
    
    
    boolean createNewOpp = true;
    public boolean getCreateNewOpp() { return createNewOpp; }
    public void setCreateNewOpp( boolean c ) { createNewOpp = c; }
    
    string accountID;
    public string getAccountID() { return this.accountID; }
    public void setAccountID(string id) { this.accountID = id; }

    Contact dummyContact;
    public Contact getContactLookup() {
        return dummyContact;
    }

    string newOppName;
    public string getNewOppName() { return newOppName; }
    public void setNewOppName( string n ) { newOppName = n; }

    string newAccName;
    public string getNewAccName() { return newAccName; }
    public void setNewAccName( string n ) { newAccName = n; }

    string useExistingAccount = 'new';
    public string getUseExistingAccount() { return useExistingAccount; }
    public void setUseExistingAccount( string u ) { useExistingAccount = u; }


    private list<opportunity> dupes = new list<opportunity>();
    public list<opportunity> getduplicateOpps() { return dupes; }
    
    
    public pagereference addtoexistingproject() {
        useexistingproject = true;
        createNewOpp = false;
        return PreConvertLead();

    }
    public PageReference CheckDupes() {
        
        
        return PreConvertLead();
        /*
        if( createNewOpp )
        {
            
            if( newOpportunity.City__c == null || newOpportunity.City__c == '' 
            || newOpportunity.State__c == null || newOpportunity.State__c == ''
            || newOppName == null || newOppName == '' 
            || newOpportunity.Application__c == '' || newOpportunity.Application__c == null )
            {
                //createNewOpp  && newOppName 
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error! You must provide an application, a name, a city and a state for projects.' ));
                return null;                
            
            }
            try {
                showdupeblock = true;
                Opportunity o = new Opportunity();
                o.name = newOppName;
                o.city__c = newOpportunity.City__c;
                o.state__c = newOpportunity.State__c;
                dupes = Opportunity_dupefinder_controller.FindDupes(o);
                if( dupes.size() < 1 ) return PreConvertLead();
            } catch(Exception e ) {
                sendExceptionEmail( e);             
                return PreConvertLead();                
            }
        } else 
        {
            return PreConvertLead();
        }
        */
        return null;
    }

    public List<SelectOption> getAccountOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add( new SelectOption( 'new','Create A New Account') ); 
        options.add( new SelectOption( 'existing','Use An Existing Account') ); 
        
        return options;
    }

    public PageReference PreConvertLead() 
    { 
        
        //step 1. we have so much going on in the triggers that the inserts and updates are causing some too-many SOQL errors
        //need to do a pre-convert stage for data cleanup
        
            // -- save the proper objects 
            string leadid = l.Id; //leadid
            string accId = dummyContact.AccountId;              
            
            if( createNewOpp  && newOppName == '' )
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error! When creating a new Opportunity you need to provide a name' ));
                showdupeblock = false;                
                return null;                
            }                

            if( createNewOpp  && (newOpportunity.Application__c == '' || newOpportunity.Application__c == null) )
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error! When creating a new Opportunity you need to provide an application type.' ));
                showdupeblock = false;                
                return null;                
            }                

            if( useExistingAccount == 'new' )
            {
                if( newAccName == '' )
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error! When creating a new Account you need to provide a name' ));
                    showdupeblock = false;                                 
                    return null;                
                }               
                
                Account a = new Account();
                a.Name = newAccName;            
                a.OwnerId = l.OwnerId;
                a.Zip__c = l.Zip__c;
                //a.Country__c = l.nrCountry__c;
                a.BillingCountryCode = l.CountryCode;
                a.BillingStateCode = l.StateCode;
                a.BillingPostalCode = l.PostalCode;
                a.ShippingCountryCode = l.CountryCode;
                a.ShippingStateCode = l.StateCode;
                a.ShippingPostalCode = l.PostalCode;
                a.DoNotAutoAssignOwner__c = true;
                a.Phone = l.Phone;
                insert a;
                accId = a.Id;
                
                l.Company = a.Name;
            } else
            {
                try {
                    Account a = [SELECT Name FROM account where id = :accID ];
                    l.Company = a.Name;
                } catch( Exception e ) 
                {
                    sendExceptionEmail( e);                 
                    showdupeblock = false;                                 
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'Error! It appears that you neither selected an account nor chose to create a new account. The new contact needs an already existing account or you need to create  a new one.' ));
                    return null;                

                }
            }
                 
            l.Is_Converting__c = true; //TODO: make sure this is blocking the email lookup thing
            update l;   
    
            PageReference ref = new PageReference('/apex/nrLeadConvert?retURL=%2F'+l.Id+'&scontrolCaching=1&accId='+accId+'&id='+l.Id+'&id='+l.Id+'&projzip='+l.Zip__c+'&sfdc.override=1&convertAction=doConvert');         
    
        return ref;
    }

    private string stage = 'init';
    public PageReference checkConvertAction() {
        //step 2 -- the cleanups went through on the previous step, now do the conversion
        Map<string,string> params = ApexPages.currentPage().getParameters();

        if( params.get('convertAction') != null && params.get('convertAction') == 'doConvert')
        {
            stage = 'doconvert';
            return ConvertLead(params.get('accId') );
        } else if( params.get('convertAction') != null && params.get('convertAction') == 'doPostConvert' )
        {
            stage = 'dopostconvert';
            
//useexistingproject=' + useexistingproject +'&createNewOpp=' + createNewOpp + '&dupeprojectid=' + dupeprojectid
            if(params.get('useexistingproject') != null && params.get('useexistingproject') != 'null')
                useexistingproject = Boolean.valueOf(params.get('useexistingproject') );
            if(params.get('createNewOpp') != null && params.get('createNewOpp') != 'null')
                createNewOpp = Boolean.valueOf(params.get('createNewOpp') );
            if(params.get('dupeprojectid') != null && params.get('dupeprojectid') != 'null')
                dupeprojectid = string.valueOf(params.get('dupeprojectid') );
            
            return HandlePostConversion(  params.get('opportunityid'), params.get('contactid'), params.get('accountid'), params.get('projcity'), params.get('projstate') , params.get('projapp'), params.get('projzip')  );
        } else 
        {
            return null;
        }
    }
        
    public PageReference ConvertLead(string accId){
        
        try {

            //delete a lead binder task - why do we do this ?
            list<Task> leadBinderTasks = new list<Task>();
            for(Task t :  [SELECT Id, Subject FROM Task WHERE WhoId = :l.id]  )
            {
                if( t.Subject == 'Send Binder') 
                {               
                    leadBinderTasks.add(t);
                }
            }
            if( leadBinderTasks.size() > 0 )
            {
                delete leadBinderTasks;
            }

            
            
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setDoNotCreateOpportunity( !createNewOpp );
            lc.setLeadId(l.Id);
            lc.setAccountId(accId);
            lc.setOverwriteLeadSource(false);
            if( createNewOpp ) lc.setOpportunityName( newOppName );
            lc.setSendNotificationEmail(false);
            LeadStatus convertstatus = [select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);

            //insert the task
            newTask.WhatId = accId;
            newTask.OwnerId = l.OwnerId;         
            
            Database.LeadConvert[] lcArray = new Database.LeadConvert[] {lc};
            Database.LeadConvertResult[] results = Database.convertLead(lcArray);

            string contactId = null;
            if( results[0].isSuccess() )
            {
                
                contactId = results[0].getContactId();
                newtask.WhoId = contactId;
                
                if( createNewOpp )
                {
                    newtask.WhatId = results[0].getOpportunityId();
                } else if( useexistingproject )
                {
                    newtask.WhatId = dupeprojectid;
                }
                
                if( createTask ) insert newtask;
                
                PageReference ref = new PageReference('/apex/nrLeadConvert?retURL=%2F'+l.Id+'&scontrolCaching=1&accId='+accId+'&id='+l.Id+'&id='+l.Id+'&sfdc.override=1&convertAction=doPostConvert&opportunityid='+results[0].getOpportunityId()+'&contactid='+results[0].getContactId()+'&accountid='+accId + '&useexistingproject=' + useexistingproject +'&createNewOpp=' + createNewOpp + '&dupeprojectid=' + dupeprojectid + '&projcity='+newOpportunity.City__c+'&projapp=' + newOpportunity.Application__c + '&projstate='+newOpportunity.State__c + '&projzip=' + ApexPages.currentPage().getParameters().get('projzip')  );   

                      
                ref.setRedirect(true);
                return ref;
                
            } else
            {
                
                ShowBackButton = true;
            }
            
        } catch(DmlException ex){
            ShowBackButton = true;
            sendExceptionEmail( ex );
            Apexpages.addMessage( new ApexPages.message( apexpages.Severity.ERROR,ex.getMessage()  ) );
 //           Apexpages.addMessage( new ApexPages.message( apexpages.Severity.ERROR,ex.getTypeName()  ) );
        }
        return null;
    }
    
    public PageReference BackTolead() {
        return new PageReference('/' + l.id );
    }
    
    public PageReference HandlePostConversion(string opportunityid, string contactid, string accountid, string projcity,  string projstate, string projapp, string projzip ) {
    
        //step 3 - do other non-critical select and updates
        Contact c = [SELECT Id FROM Contact WHERE Id = :contactid];
        c.HomePhone = l.HomePhone__c;
        c.OtherPhone = l.OtherPhone__c;
        c.MobilePhone = l.MobilePhone__c;
        c.OwnerId = l.OwnerId;
        c.Lead_Create_Date__c = l.CreatedDate;
        update c;

System.debug('useexistingproject = ' + useexistingproject + ', createNewOpp = ' + createNewOpp + ', dupeprojectid = ' + dupeprojectid);

        if( createNewOpp && opportunityid != null && opportunityid != 'null')
        { //clean up the new project
system.debug('cleaning up a new project');          
            
            Opportunity o = [SELECT id, Name FROM Opportunity WHERE id = :opportunityid ];

            string projname = o.Name;
            o.OwnerId = l.OwnerId;
            o.Name =  o.Name + ' ';
            o.Site_Address__c = l.Address_1__c;
            o.Country__c = l.nrCountry__c;
            o.City__c = projcity;
            o.State__c = projstate;
            o.Application__c = projapp;  //
//            o.CloseDate = date.today().addDays(7300);   
            o.CloseDate = date.today().addMonths(6);   
            o.accountid = null;             
            o.Postal_Code__c = projzip;
            update o;
            
//            o.Name = projname;
 //           update o;
 
 
            //add on the proper salesteam member - the split and built in team member go on automatically.  need to put our wrapper on for backwards compatibility
            nrOpportunityTeamMember__c nrOTM = new nrOpportunityTeamMember__c();
            nrOTM.Commission__c = 100;
            nrOTM.Opportunity__c = o.Id;
            nrOTM.User__c = o.OwnerId;
            nrotm.TeamMemberRole__c = 'Sales Rep';
            nrotm.OpportunityAccessLevel__c = 'Owner';
//            insert nrOTM;

/*             
            OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];
            OpportunitySplit split = new OpportunitySplit();
            split.SplitOwnerId = o.OwnerId;
            split.OpportunityId = o.Id;
            split.SplitPercentage = 100;
            split.SplitTypeId = splittype.Id;
            insert split;
*/
            
        } else if( useexistingproject )
        {
system.debug('cleaning up existing project');           
            nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
            ocr.Opportunity__c = dupeprojectid;
            ocr.Contact__c = contactid;
            ocr.Role__c = l.Type__c;
            insert ocr;
        }
        //finish salesteam fixes
        

        //update any chat logs
        list<LiveChatTranscript> lChats = [SELECT Id FROM LiveChatTranscript WHERE Leadid = :l.id];
        for( LiveChatTranscript chat : lChats )
        {
            chat.ContactId = contactid;
            chat.AccountId = accountid;

        }
        update lchats;
        
        list<LiveChat_transcript__c> chats = [SELECT id FROM LiveChat_Transcript__c WHERE Lead__c = :l.Id ];
        for( LiveChat_transcript__c chat : chats )
        {
            chat.Contact__c = contactid;
            if( createNewOpp && opportunityid != null ) chat.Opportunity__c = opportunityid;
            chat.Account__c = accountid;
        }
        update chats;
        
        list<SFGA__Keyword__c>   keyUpdates = [SELECT id FROM SFGA__keyword__c WHERE SFGA__Lead__c = :l.id  ];
        for( SFGA__Keyword__c keyword : keyUpdates )
        {
            keyword.Contact__c = contactid;
            if( opportunityid != null )
                keyword.SFGA__Opportunity__c = opportunityid;
        }
        if( keyUpdates.size() > 0 )
            update keyUpdates; 

        try {
            if( opportunityid != null  && opportunityid != 'null' && opportunityid != '' )
            {
                return new PageReference('/' + opportunityid );
                
            }
            return new PageReference('/' + contactid );
        } catch(Exception ex){
            
            sendExceptionEmail( ex );           
            return new PageReference('/' + contactid );
            
        }

    }
    
}