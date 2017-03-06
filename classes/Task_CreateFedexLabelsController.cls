public with sharing class Task_CreateFedexLabelsController {

//a0MQ0000003SQ4XMAW - dev shipping preference
// 


   /* public class MailbookTaskWrapper {
        private Task mailbookTask = null;
        public Task getTask() { return mailbooktask; }
        private Quote__c quote = null;
        private Lead lead = null;
        
        public string errormessage  {
            get ;
            set ;
        }
        
        public string displayerrorstyle {
            get {
            
                if( HasErrors ) return 'display: block';
                else return 'display: none';
            }
            set {}
        }
        public boolean HasErrors { get; set; }
        
        
        public string getRecipientID() { return   ( lead != null ? lead.Id  : quote.Contact__c); }
        public string getRecipientName() { return  ( lead != null ? lead.FirstName + ' ' + lead.LastName  : quote.Contact__r.FirstName + ' ' + quote.Contact__r.LastName); }
        public string getRecipientFirstName() { return  ( lead != null ? lead.FirstName  : quote.Contact__r.FirstName); }
        public string getRecipientLastName() { return  ( lead != null ? lead.LastName  : quote.Contact__r.LastName); }
        public string getRecipientCity() { return  ( lead != null ? lead.nrCity__c  : quote.Contact__r.City__c); }
        public string getRecipientState() { return  ( lead != null ? lead.nrState__c  : quote.Contact__r.State__c); }
        
        public string getRecipientPhone() { return  ( lead != null ? lead.Phone  : quote.Contact__r.Phone); }
        public string getRecipientAccountName() { return  ( lead != null ? lead.Company  : quote.Contact__r.Account.Name); }
        public string getRecipientAddress1() { return  ( lead != null ? lead.Address_1__c  : quote.Contact__r.Address_1__c); }
        public string getRecipientAddress2() { return  ( lead != null ? lead.Address_2__c  : quote.Contact__r.Address_2__c); }
        public string getRecipientZip() { return  ( lead != null ? lead.Zip__c  : quote.Contact__r.Zip__c); }
        public string getRecipientCountry() { return  ( lead != null ? lead.nrCountry__c  : quote.Contact__r.Country__c); }

        public boolean IsAContact { get; set; }

        private boolean useTask = false;
        public boolean getUseTask() { return useTask; }
        public void setUseTask( boolean useIt ) {  useTask = useIt; }
        public DateTime getCreatedDate() { return mailbookTask.CreatedDate; }
        public string getTaskID() { return mailbookTask.id; }   
        public string getTaskSubject() { return mailbooktask.subject; }
        
        
        public MailbookTaskWrapper(Task t, Quote__c q, Lead l ) {
        
            mailbookTask  = t;
            quote = q;
            lead = l;
            haserrors = false;
            errormessage= '';
            if( l != null ) IsAContact = false;
            else IsAContact = true;

        }
    }

    list<MailbookTaskWrapper> taskWrappers = null;  
    public list<MailbookTaskWrapper> gettaskwrappers() {
        
        if( taskWrappers != null) return taskWrappers;
        
        taskWrappers = new List<MailbookTaskWrapper>();
        list<Task> tasks = [SELECT id, CreatedDate, WhatID, WhoID, Subject FROM Task WHERE ( subject = 'Send mailbook' OR subject = 'Send Booklet' ) AND FedexLabelCreated__c = false AND IsClosed = false AND Status = 'In Progress'  ];
        //AND Status = 'In Progress' 
        map<id, MailbookTaskWrapper> taskwrapperMap = new map<id, MailbookTaskWrapper>();
        map<id, list<MailbookTaskWrapper> > contidtotaskwrapperMap = new map<id, list<MailbookTaskWrapper> >();
        
        map<id,Task> idToTaskLookup = new map<id, Task>();
        list<id> quoteIDs  = new list<id>();
        set<id> leadIds = new set<id>();

        for ( Task t : tasks )
        {
            try {
                if( t.subject == 'Send Booklet')
                {
                    if( !leadIds.contains(t.WhoID))
                    {
                        leadIds.add(t.whoid);
                        idToTaskLookup.put( t.whoid, t );
                        
                    }
                } else if( t.subject == 'Send Mailbook') {
                    quoteIDs.add( t.whatid);
                    idToTaskLookup.put( t.whatid, t );
                }

            } catch( Exception ex ) {}
        }

        set<id> whoIds = new set<id>();
        for( Quote__c q :  [SELECT id, Name, Contact__c, Contact__r.firstname, Contact__r.lastname, Contact__r.Phone, Contact__r.Account.Name, Contact__r.Address_1__c, Contact__r.Address_2__c, Contact__r.City__c, Contact__r.Zip__c, Contact__r.State__c, Contact__r.Country__c FROM Quote__c WHERE id in :quoteIDs ] )
        {               

            if( !whoIds.contains(q.contact__c) )
                whoIds.add( q.contact__c);
            
            try {
                if( idToTaskLookup.get(q.id) != null && q != null )
                {
                    MailbookTaskWrapper tw = new MailbookTaskWrapper( idToTaskLookup.get(q.id) , q, null  );
                        taskWrappers.add(  tw );
                    taskwrapperMap.put( tw.getTaskID(), tw );               
                    
                    if( !contidtotaskwrapperMap.keyset().contains(q.contact__c) )
                        contidtotaskwrapperMap.put( q.contact__c, new list<mailbooktaskwrapper>() );
                        
                    contidtotaskwrapperMap.get(q.contact__c).add( tw);  
                }
            } catch( Exception ex ) {
                
            }
        }

        for( Lead l : [SELECT id, firstname, lastname, Phone, Company, Address_1__c, Address_2__c, nrCity__c, Zip__c, nrState__c, nrCountry__c FROM Lead WHERE id in :leadIds  ] )
        {
            if( !whoIds.contains(l.id) )
                whoIds.add( l.id );
            
            //id, firstname, lastname, Phone, CompanyName, Address_1__c, Address_2__c, City__c, Zip__c, State__c, Country__c 
            MailbookTaskWrapper tw = new MailbookTaskWrapper( idToTaskLookup.get(l.id) , null, l  );
            taskWrappers.add(  tw );
            taskwrapperMap.put( tw.getTaskID(), tw );               
            
            if( !contidtotaskwrapperMap.keyset().contains(l.id) )
                contidtotaskwrapperMap.put(l.id, new list<mailbooktaskwrapper>() );
                
            contidtotaskwrapperMap.get(l.id).add( tw);  
        }

        list<id> contIderrorTaskLookup = new list<id>( whoIds);
        for( Task t : [ SELECT id, whoid, description FROM Task WHERE WhoId in :contIderrorTaskLookup AND Subject like '%fedex label could not be created%' ] )
        {
            if( contidtotaskwrapperMap.keyset().contains(t.whoid) )
            {
                for( mailbooktaskwrapper tw : contidtotaskwrapperMap.get(t.whoid) )
                {
                
                    tw.haserrors = true;
                    tw.errormessage += t.description+'<br />';
                }
            }
        }
    
        //sorting
        map<string, MailbookTaskWrapper> sortWrapper = new map<string, MailbookTaskWrapper>();
        for( MailbookTaskWrapper w : taskWrappers )
        {
            
            string LastNameKeyPart = w.getRecipientLastName();
            if(LastNameKeyPart != null && LastNameKeyPart.length() < 25 )
                for( Integer i = 0; i < 25-LastNameKeyPart.length(); i++ )
                    LastNameKeyPart += '0';
            string FirstNameKeyPart = w.getRecipientFirstName();
            if( FirstNameKeyPart != null &&FirstNameKeyPart.length() < 25 )
                for( Integer i = 0; i < 25-FirstNameKeyPart.length(); i++ )
                    FirstNameKeyPart += '0';
            string CountryKeyPart = w.getRecipientCountry();
            if(CountryKeyPart != null && CountryKeyPart.length() < 25 )
                for( Integer i = 0; i < 25-CountryKeyPart.length(); i++ )
                    CountryKeyPart += '0';
            
            string key = CountryKeyPart+';'+LastNameKeyPart+';'+FirstNameKeyPart;
//          string key = w.getRecipientCountry()+';'+w.getRecipientLastName()+';'+w.getRecipientFirstName();
            key = key.toLowerCase();
            if( sortWrapper.containsKey(key) )
                sortWrapper.put(key+';'+Math.random() , w); //just in case a given lead/contact has multiple entries
            else sortWrapper.put( key, w);
        }       
        list<string> sortedKeys = new list<string>(sortWrapper.keySet());
        sortedKeys.sort();
        taskWrappers = new list<MailbookTaskWrapper>();
        for( string key : sortedKeys )
            taskWrappers.add( sortWrapper.get(key) );
        //end sorting       
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, ' got ' + taskWrappers.size() + '  tasks'  ));
    
        return taskWrappers;
        
    }


    public Task_CreateFedexLabelsController() {
        if( !initd )
        {
            initd = true;
            showtasklist = true;
        }
        
    }

    public decimal declaredvalue { get; set; }
    public string weight { get; set; }
    public string width { get; set; }   
    public string length { get; set; }  
    public string height { get; set; }  

    public string SelectedFedexService { get; set; }
    public List<SelectOption> getFedexServiceOptions() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add( new Selectoption('FEDEX_EXPRESS_SAVER','Express Saver') );
        options.add( new Selectoption('FEDEX_2_DAY','2 Day') );
        options.add( new Selectoption('FEDEX_2_DAY_AM','2 Day AM') );
        options.add( new Selectoption('PRIORITY_OVERNIGHT','Priority Overnight') );
        options.add( new Selectoption('FIRST_OVERNIGHT','First Overnight') );
        options.add( new Selectoption('STANDARD_OVERNIGHT','Standard Overnight') );
        options.add( new Selectoption('FEDEX_GROUND','Ground') );
        options.add( new Selectoption('GROUND_HOME_DELIVERY','Ground Home') );
        return options; 
    }
    


    public string SelectedPackagingType { get; set; }
    public List<SelectOption> getPackagingTypes() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add( new Selectoption('FEDEX_10KG_BOX','FedEx 10Kg Box') );
        options.add( new Selectoption('FEDEX_25KG_BOX','FedEx 25Kg Box') );
        options.add( new Selectoption('FEDEX_BOX','FedEx Box') );
        options.add( new Selectoption('FEDEX_ENVELOPE','FedEx Envelope') );
        options.add( new Selectoption('FEDEX_PAK','FedEx Pak') );
        options.add( new Selectoption('FEDEX_TUBE','FedEx Tube') );
        options.add( new Selectoption('YOUR_PACKAGING','Your Packaging') );
        
        return options; 
    }
    
    public string SelectedLabelFormat { get; set; }
    public List<SelectOption> getLabelFormats() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add( new Selectoption('STOCK_4X6','4x6 (default) ') );
        options.add( new Selectoption('STOCK_4X6.75_LEADING_DOC_TAB','4x6.75 with leading doc tab') );
        options.add( new Selectoption('STOCK_4X6.75_TRAILING_DOC_TAB','4x6.75 with trailing doc tab') );
        options.add( new Selectoption('STOCK_4X8','4x8') );
        options.add( new Selectoption('STOCK_4X9_LEADING_DOC_TAB','4x9 with leading doc tab') );
        options.add( new Selectoption('STOCK_4X9_TRAILING_DOC_TAB','4x9 with trailing doc tab') );

        
        return options; 
    }
    

    public string confirmationText { get; set; }
    boolean initd =false;

    public boolean showtasklist { get; set; }

    public PageReference CreateLabels() {
    
    
        list<Task> tasksToClose = new list<Task>();
        list<string> taskIDS = new list<string>();

        boolean hasError = false;
        if( SelectedPackagingType != 'YOUR_PACKAGING' 
        && ( SelectedFedexService == 'GROUND_HOME_DELIVERY' ||  SelectedFedexService == 'FEDEX_GROUND') 
        ) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'If you send using "Ground Home" or "Ground" you must use "Your Packaging" and specify the dimensions. "' ));
            hasError = true;
        }
        
        if( weight == null || weight == '' )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, '"Weight" is a required field.' ));
            hasError = true;
        }

        if( declaredvalue == null || declaredvalue < 1 )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, '"Declared Value" is a required field.' ));
            hasError = true;
        }
        
        if( SelectedPackagingType == 'YOUR_PACKAGING' && 
            (
            width == null || width == ''
            || height == null || height == '' 
            || length == null || length == ''
            ) )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'When using "Your Packaging" as the packagin type, width, height and length are required.' ));
            hasError = true;
        }

//  - cant create an overnight shipment with a fedex envelope

        if( hasError) return null;

        
        string strHeight = String.valueOf( Decimal.valueOf(height).round(RoundingMode.CEILING) );
        string strWidth = String.valueOf( Decimal.valueOf(width).round(RoundingMode.CEILING) );
        string strLength = String.valueOf( Decimal.valueOf(length).round(RoundingMode.CEILING) );


        confirmationText = '';
        list<MailbookTaskWrapper> taskWrappers = gettaskwrappers();
        if( taskWrappers.size() > 0 )
        {
            //create the Fedex serviuce
            Fedex_Gateway.FedEx_GatewaySoap fgw = new Fedex_Gateway.FedEx_GatewaySoap();
            Fedex_Gateway.ArrayOfWsoFedex_MailbookRequest fedexJobs = new Fedex_Gateway.ArrayOfWsoFedex_MailbookRequest();
            fedexJobs.wsoFedex_MailbookRequest = new list<Fedex_Gateway.wsoFedex_MailbookRequest>();
            
            for( MailbookTaskWrapper w : taskWrappers )
            {
                if( !w.getUseTask() ) continue;
                Fedex_Gateway.wsoFedex_MailbookRequest mbr = new Fedex_Gateway.wsoFedex_MailbookRequest();
                mbr.TaskId = w.getTaskID();
                mbr.Lead =  new Fedex_Gateway.wsoLead();
                mbr.Lead.SalesforceID = w.getRecipientID();
                mbr.Lead.LeadID = 0;
                mbr.Lead.Competitor = false;
                mbr.Lead.Newsletter = false;
                mbr.Lead.NoTax = false;
    
                mbr.Lead.FirstName = w.getRecipientFirstName();
                mbr.Lead.LastName = w.getRecipientLastName();
                mbr.Lead.CompanyName    = w.getRecipientAccountName();
                mbr.Lead.Phone = w.getRecipientPhone();
                mbr.Lead.AddressObj = new Fedex_Gateway.wsoAddress();
                mbr.Lead.AddressObj.Street1 = w.getRecipientAddress1();
                mbr.Lead.AddressObj.Street2 = w.getRecipientAddress2();
                mbr.Lead.AddressObj.City = w.getRecipientCity();
                mbr.Lead.AddressObj.Zip = w.getRecipientZip();
                mbr.Lead.AddressObj.State = w.getRecipientState();
                mbr.Lead.AddressObj.Country = w.getRecipientCountry();
                
                
                mbr.FedexService = SelectedFedexService;
                mbr.PackagingType = SelectedPackagingType;
                mbr.LabelFormat = SelectedLabelFormat;
                mbr.DeclaredValue = declaredvalue;
                mbr.SalesforceOwnerID = Userinfo.getUserId();
                mbr.IsContact = w.IsAContact;
                
                Fedex_Gateway.FedexPackage pack = new Fedex_Gateway.FedexPackage();
                pack.Height = strHeight;
                pack.Width = strwidth;
                pack.Length = strlength;
                pack.Weight =  weight;
                

                mbr.Packages = new Fedex_Gateway.ArrayOfFedexPackage();
                mbr.Packages.FedexPackage = new List<Fedex_Gateway.FedexPackage>();
                mbr.Packages.FedexPackage.add( pack);
                

                                
                confirmationText += 'Adding request for ' + w.getRecipientFirstName() + ' ' + w.getRecipientLastName()+'<br />';
                fedexJobs.wsoFedex_MailbookRequest.add( mbr);
                
                Task t = w.getTask();
                t.Status = 'Completed';
                tasksToClose.add( t );
                
            }
            
            if( fedexJobs.wsoFedex_MailbookRequest.size() > 0  )
            {
                
                confirmationText += 'Submitting request for  ' + fedexJobs.wsoFedex_MailbookRequest.size()+ ' labels.<br />';
                fgw.CreateLabelsForMailbookTasks(fedexJobs);
                showtasklist = false;
                
            } else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'You must select at least one task in order to generate a label.' ));
            
            }
        }       
        
        //flip the visible panels
        return null;
    }

*/
}