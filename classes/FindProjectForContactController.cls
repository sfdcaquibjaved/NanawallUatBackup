public  class FindProjectForContactController {

    private final Contact cont;
    private boolean initd = false;
    public FindProjectForContactController(ApexPages.StandardController stdController) {
        this.cont = (Contact)stdController.getRecord();


        try {
            dummyOCR.Contact__c = cont.id;
            
            string oppID = Apexpages.currentPage().getParameters().get('OpportunityID');
            if(  oppID != null && oppID != '' )
            {
                dummyOCR.Opportunity__c = oppID;
            }


            if( !initd )
            {
                dummyOCR.Role__c = cont.LeadType__c;
                
                SearchOpp = new Opportunity();
                initd = true;
            }
            
        } catch( Exception ex )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,  'I could not load the contact you specified. '+ ex ));        
        }
    }

    public Opportunity SearchOpp {
        get; set;
    }

    
    public void doSort(){

        /*
        String order = 'asc';
        
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
        sortexp=' order by ' + sortfield + ' ' + order ;

        myaction();
        */
    }


    public boolean gethasprevious() { return false; }
    public boolean gethasnext() { return false; }
    
    public void previous()
    {
//        mycontroller.previous();
    }
    
    public void next()
    {
//        mycontroller.next();
    }
    
    public PageReference FindProjects() {
        string State = '';
        string Country = null;
        string Name = null;
        string AltName = null;
        string Address = null;
        string City = null;
        string Zip = null;
        string Stage = null;
        string Application = null;
        boolean ChainAccount = false;
        boolean Ordered = false;
        string AmountLow = null;
        string AmountHigh = null;
        list<string> models = new list<string>();
        string ReviewCode = null;
        boolean NIS = false;
        Date CreatedDateLow = null;
        Date CreatedDateHigh = null;
        Date CloseDateLow = null; 
        Date CloseDateHigh = null;
        string SelectedTerritory = null;
        string sortexp = '';

        searchResults = OpportunityHomeController.GetSearchResults( SearchOpp.State__c, Country, SearchOpp.Name, AltName, SearchOpp.Site_Address__c, SearchOpp.City__c, SearchOpp.Postal_Code__c, Stage, SearchOpp.Application__c, SearchOpp.Chain_Account__c, Ordered, AmountLow, AmountHigh, models, ReviewCode, NIS, CreatedDateLow, CreatedDateHigh, CloseDateLow, CloseDateHigh, SelectedTerritory, sortexp, false);
         
        return null;
    } 
    
    public list<Opportunity> searchResults { get; set; }
 
    public nrOpportunityContactRole__c dummyOCR = new nrOpportunityContactRole__c();
    public nrOpportunityContactRole__c getOCR() {
        return dummyOCR;
    }

    public pagereference Cancel() {
        return new PageReference('/'+this.cont.id );
    }
    
    private id selectedProjectID = null;
    public id getselectedProjectID () { return selectedProjectID; }
    public void setSelectedProjectID( id pid ) { selectedProjectID = pid; }     
    public Pagereference projectSelected() {
    
        dummyOcr.Opportunity__c = selectedProjectID;
        return AddToProject();
    }
    
    public pagereference AddToProject() {

        integer tracer = 0;
        try 
        {
            tracer= 1;
            if( dummyocr == null
            || dummyocr.Opportunity__c == null )
            {
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'You must select an opportunity in order to continue.' ));
                return null;
            }
            tracer=2;
            
            Opportunity opp = [SELECT id, ownerid,is_a_dupe__c, (SELECT UserId FROM OpportunityTeamMembers  t) FROM opportunity WHERE id = :dummyocr.Opportunity__c];   
            tracer=3;
            if( opp.Is_A_Dupe__c )
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,  'You are trying to add a contact to a project that is a duplicate.' ));
                return null;
            }
            tracer=4;
            
            tracer=7;
    
            insert dummyOCR;
            tracer=8;
     
            Contact c = [Select c.AccountId, c.Account.Chain_Account__c from Contact c WHERE c.id = :dummyOCR.Contact__c ];
            tracer=9;
     
     
            opp.IsDirty__c = true;
            tracer=10;
            if( c.Account.chain_account__c ) opp.Chain_Account__c = true;
            tracer=11;
            
            update opp;
            tracer=12;
    
            PageReference ref = new PageReference('/' + opp.id);        
            ref.setRedirect(true);
            tracer=13;
            return ref;
        } catch( Exception ex ) 
        {
            if(!Test.isRunningTest()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'A problem ocurred when trying to add that contact to the project you selected. Technical Support has been notified. ' + Utility.HasAccessLastLine ));
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
            mail.setToAddresses( toAddresses );
            mail.setReplyTo('admin@a-stechnologies.com');   
            mail.setSenderDisplayName('Salesforce Error Daemon');
            mail.setSubject('An exception ocurred when adding an existing contact to a project. tracer = ' +tracer );
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('user: '+ Userinfo.getFirstName() + ' '  + Userinfo.getLastName() + ' ( '+Userinfo.getUserId()+' ) '+' contact:  ' + cont.Id + ' ; ' + dummyOcr.Opportunity__c + ' \n' + ex   );
            mail.setHtmlBody( 'user: '+Userinfo.getFirstName() + ' '  + Userinfo.getLastName() + ' ( '+Userinfo.getUserId()+' ) '+'  contact:  ' + cont.Id + ' ; ' + dummyOcr.Opportunity__c + ' <br />\n' + ex );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
            }
            
            return null;        
        }   
    }


}