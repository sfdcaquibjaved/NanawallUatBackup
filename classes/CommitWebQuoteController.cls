public with sharing class CommitWebQuoteController {
    Web_Quote__c wq = null;
    public CommitWebQuoteController(ApexPages.StandardController controller)
    {
         wq = (Web_Quote__c)controller.getRecord();
          
    }
    

    string webQuoteProjectID = '';
    public String getwebQuoteProjectID(){
        return webQuoteProjectID;
    }

    public void setwebQuoteProjectID(String s){
        webQuoteProjectID=s;
    }       
    
    private list<opportunity> duplicateOpps = new list<opportunity>();
    public list<Opportunity> getduplicateopps() { return duplicateopps; }
    
    private boolean showDupeBlock = false;
    public boolean getShowDupeBlock() { return showDupeBlock; }
    
    private opportunity existingOpp = null;
    public opportunity getExistingOpp() { return existingOpp; }
    
    public Opportunity o = new Opportunity();
    public opportunity getNewOPportunity() { return o; }
    
    private boolean bSaveAnway = false;
    public pagereference saveAnyway() {
    
        bSaveAnway = true;
        return Create();
    }
    
    boolean useExistingProject = false;
    public PageReference UseProject() {
        if( webQuoteProjectID == null || webQuoteProjectID == '' )
        {
            string id = Apexpages.currentPage().getParameters().get('id');
            if( id != null && id != '' ) webQuoteProjectID = id;
        }
        useExistingProject = true;

        return Create();    
    }
    
    public PageReference Create()
    {
        if (wq.committed__c && ApexPages.currentPage().getParameters().get('o')==null)
        {
            return new PageReference('/' + wq.id);
        }

        if (ApexPages.currentPage().getParameters().get('o')!=null)
        {
            return Sync();
        }
        
        if( useExistingProject )
            o = [SELECT id, StageName, CloseDate, Name, Site_address__c, City__c, Postal_code__c,  state__c, country__c, application__c, description, ownerID, (SELECT id, userid FROM OpportunityTeamMembers), (SELECT id, ContactId from OpportunityContactRoles) FROM opportunity WHERE id = :webQuoteProjectID ];
        else o = new Opportunity();
        
        
        try 
        {
         Contact c = [select id,ownerid, AccountID, Account.Name from contact where id=:wq.Contact__c ];
         Account a = [SELECT Id, Name FROM Account WHERE ID = :c.AccountId];
        if( !useExistingProject )
        {
            
            
            
             o.StageName='Considered';
             o.CloseDate = date.today().addMonths(6);
             if (wq.Project_Name__c == null || wq.Project_Name__c=='')
                o.Name = 'Web Quote Project ' + wq.Name + '-'+a.Name;
            else
                o.Name = wq.Project_Name__c + '-'+a.Name;
                
            o.AccountId = a.Id;
             o.Site_Address__c = wq.Project_Address__c;
             o.City__c = wq.Project_City__c;
             o.Postal_Code__c = wq.Project_Zip__c;
             o.State__c = wq.Project_State__c;
             o.Country__c  = wq.Project_Country__c;
             o.Application__c = wq.Project_Type__c;
             o.Description = wq.Project_Comments__c;
             o.OwnerId = GetUserFromAddress.GetUser(o.Country__c,o.Postal_Code__c );

            //commercial recordtype = 012A0000000Gjh5IAC
            //residential recordtype = 012A0000000Gjh7IAC
            if( wq.Project_Type__c == 'Common Area' 
                || wq.Project_Type__c == 'Hospitality'
                || wq.Project_Type__c == 'Multifamily - New'
                || wq.Project_Type__c == 'Multifamily - Remodel'
                || wq.Project_Type__c == 'Single Family - New'
                || wq.Project_Type__c == 'Single Family - Remodel'
                )
            {
                o.RecordTypeId = '012A0000000Gjh7IAC';
            } else o.RecordTypeId = '012A0000000Gjh5IAC';


        }
        o.web_project__c=true;
         
         
         if( !bSaveAnway && !useExistingProject )
         {
            try {
                //duplicateOpps = Opportunity_dupefinder_controller.FindDupes(o); 
                
            } catch( Exception ex ) {
                duplicateOpps = new list<Opportunity>();
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'An error occurred: ' + ex  ));
                    
            }         
         } else duplicateOpps = new list<opportunity>();
          
         if( duplicateOpps.size() >= 1 )
         {
            showDupeBlock = true;
         
            return null;
         } else showDupeBlock = false;
         
         if( !useExistingProject )
         {
            Project__c p = new Project__c();
            p.Name = wq.Project_Name__c;
            p.Project_Zip_Code__c = o.Postal_Code__c;           
            p.Application__c = wq.Project_Type__c;
            
            /*
                Commercial = 012A0000000GjgvIAC
                Residential = 012A0000000GjgwIAC    
             */
            if( wq.Project_Type__c == 'Common Area' 
                || wq.Project_Type__c == 'Hospitality'
                || wq.Project_Type__c == 'Multifamily - New'
                || wq.Project_Type__c == 'Multifamily - Remodel'
                || wq.Project_Type__c == 'Single Family - New'
                || wq.Project_Type__c == 'Single Family - Remodel'
                )
            {
                p.RecordTypeId = '012A0000000GjgwIAC';
            } else p.RecordTypeId = '012A0000000GjgvIAC';
            
            
            insert p;
            
            o.Project_Name__c = p.Id;
            insert o;
         }
        boolean insertOTM = true;
         
         if (o.OwnerID != c.OwnerId)
         {
            
            if( useExistingProject)
            {
                for( OpportunityTeamMember existingOTM : o.OpportunityTeamMembers )
                {
                    if( existingOTM.UserId == c.OwnerID )
                    { //the team member already exists, do not insert it
                        
                        insertOTM = false;
                        break;
                    }
                }
            }

            if( insertOTM )
            {
                OpportunitySplit split = new OpportunitySplit();
                split.SplitPercentage = 0;
                split.SplitOwnerId = c.OwnerId;
                split.OpportunityId = o.Id;
                insert split;
                
            }
         }
         
         boolean insertRole = true;
//         for( nrOpportunityContactRole__c existingOCR : o.nrOpportunityContactRoles__r )
        for( OpportunityContactRole existingOCR : o.OpportunityContactRoles )
         {
            if( existingOCR.ContactId  == wq.Contact__c )
            { //this contact already exists on the project
                insertRole = false;
                break;
            }
         }
         
         if( insertRole )
         {
             OpportunityContactRole ocr = new OpportunityContactRole();
             ocr.OpportunityId = o.Id;
             ocr.ContactId = wq.Contact__c;
             insert ocr; 
         }
         
         wq.committed__c=true;
         update wq;
         
         PageReference pageRef = new PageReference('/apex/CommitWebQuote?id='+wq.Id+'&o='+o.Id+'&c='+c.id);
         pageRef.setRedirect(true);
         return pageRef;

        }
        catch (exception ex)
        {
            return null;
        }
        return new PageReference('/' + o.Id );

        return null;
    }
    
    public PageReference Sync()
    {
        string id = ApexPages.currentPage().getParameters().get('o');
        string cid = ApexPages.currentPage().getParameters().get('c');

         
        NanaQuoteGateway.QuoteGatewaySoap qgs = new NanaQuoteGateway.QuoteGatewaySoap();
        string input='';
        input += '<root>';
        input += '<Project Value="' + id + '" />';
        input += '<QuoteDetails>';
        for (Web_Quote_Detail__c wqd : [select id,NanaID__c from web_quote_detail__c where web_quote__c = :wq.id])
        {
            input += '<ID Value="' + wqd.NanaID__c +  '" />';
        }
        input += '</QuoteDetails>';
        input += '</root>';
        qgs.timeout_x = 120000;
        string ret = qgs.CreateQuote(input);

        return new PageReference('/' + id );
    }
}