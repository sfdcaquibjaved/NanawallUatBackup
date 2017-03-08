public with sharing class ServiceQuote_Home_Controller {

    //put this back on the UI for old model search
    //<input {!OldModelsChecked} type='checkbox' id='chkShowOldModels' onclick="_refreshModelSelector()" /> include old models
    public String models { 
        get; 
        set; 
    }
     public boolean urlPass{
        get;
        set;
    }
//  private set<string> excludedModels = new set<String>{ 'hsw 50', 'hsw 55', 'sl 35l', 'sl 35us', 'sl 45us', 'sl 50', 'sl 50l', 'sl 50us', 'sl 68l', 'sl 72', 'sl 72l', 'sl 78f', 'sl 78l', 'sl 78tt', 'vsw 50', 'wd 75' };
    private set<string> excludedModels = new set<String>{  };
 
    public string getOldModelsChecked() {
        if( ( Apexpages.currentPage().getParameters().get('useOldModels') != null ) ) return ' checked="checked" ';
        else return '';
    }
    public string getOldModelsToggleValue() {
        if( ( Apexpages.currentPage().getParameters().get('useOldModels') != null ) ) return '';
        else return 'useOldModels=true';
    }

    public List<SelectOption> getModelOptions() {
        
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult f = Schema.sObjectType.Opportunity.fields.Models__c;
        boolean useOldModels = ( Apexpages.currentPage().getParameters().get('useOldModels') != null );
        
        options.add(new Selectoption('','- select -') );
        for( Schema.Picklistentry entry : f.getPicklistValues( ))
        {
            if( !useOldModels && this.excludedModels.contains(entry.getValue().toLowerCase() ) ) continue;
            
            options.add( new Selectoption(entry.getvalue(), entry.getlabel() ));
        }

        return options; 
    }


    class SearchContainer {
        public string ProjectName { get; set; } // quote, opportunity
        public string ProjectAddress { get; set; } // quote, opportunity
    
        public string ContactName { get; set; } // quote, opportunity

        public string Address { get; set; } // quote, opportunity
        public string City { get; set; } // quote, opportunity
        public string state { get; set; }// quote, opportunity
        public string Zip { get; set; }// quote, opportunity
        public string Phone { get; set; }// quote, opportunity
        public string Email { get; set; } // quote, opportunity
        public string Panels_Left { get; set; } //quote_detail.Configuration__c 
        public string Panels_Right { get; set; } //quote_detail.Configuration__c 
        public string Panels_Count { get; set; } //quote_detail.Configuration__c 
        
        public string ServiceQuoteNumber { get; set; }
        public string CaseNumber { get; set; }
        
        public string QuoteNumber { get; set; }
        public string OrderNumber { get; set; }
        
        
        public string LoGrandTotal { get; set; }
        public string HiGrandTotal { get; set; }

        public string LoServiceQuoteAmount { get; set; }
        public string HiServiceQuoteAmount { get; set; }

        public Service_Quote__c FirstServiceQuote { get; set; }
        public Service_Quote__c SecondServiceQuote { get; set; }
        
        
    }
    public SearchContainer SearchFields { get; set; }
    

    class ServiceQuoteEntry {
        public string ID { get; set; }
        public string ServiceQuoteNumber{ get; set; }
    }   
    class ServiceQuoteSearchResult {
        public string QuoteID { get; set; }
        public string OrderID { get; set; }
        public string OrderID_SFID { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string ContactName { get; set; }
        public string ProjectName { get; set; }
        public string ProjectAddress { get; set; }
        public string ProjectID { get; set; }
        public string QuoteNumber{ get; set; }
        public list<ServiceQuoteEntry> serviceQuotes { get; set; }
        public string origin { get; set; }
    }
    public static list<ServiceQuoteSearchResult> searchResults { get; set; }
    
    public List<SelectOption> getStates() {
       List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult f = Schema.sObjectType.Account.fields.State__c;
        
        for( Schema.Picklistentry entry : f.getPicklistValues( ))
        {
            options.add( new Selectoption(entry.getvalue(), entry.getlabel() ));
        }

        
        return options; 
    }
    

    private boolean initd = false;
    public ServiceQuote_Home_Controller(){
        
        if( !initd)
        {
            SearchFields = new SearchContainer();
            searchResults = new list<ServiceQuoteSearchResult>();
            SearchFields.FirstServiceQuote = new Service_Quote__c();
            SearchFields.SecondServiceQuote = new Service_Quote__c();
            SearchFields.FirstServiceQuote.ETA__c = null;
            SearchFields.SecondServiceQuote.ETA__c = null;
        }
//      Service_Quote__c
    }
    
    
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    public String sortexp{get;set;}
    public pagereference dosort() {
    
        return null;
    }
    public string resulttext { get; set; }
    
    public ServiceQuoteSearchResult getServiceQuoteSearchResultFromRecord( Service_Quote__c sq)
    {
        ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();

        res.City = sq.Quote__r.City__c;
        res.State = sq.Quote__r.State__c;
        res.Zip = sq.Ship_To_Zip__c;
        res.OrderID = String.valueOf(sq.Quote__r.Order_Number__c);
        res.OrderID_SFID = String.valueOf( sq.Quote__r.Order__c);
        res.ProjectID = sq.Quote__r.Opportunity__c;
        res.QuoteID = sq.Quote__c;
        res.QuoteNumber = String.valueOf(sq.Quote__r.Quote_ID__c);
                
        res.ProjectName = sq.Quote__r.OpportunityName__c;
        res.ProjectAddress = sq.Quote__r.OpportunityAddress__c;
        res.ContactName = sq.Quote__r.ContactName__c;
                
                
        res.origin = 'I';
                
        res.serviceQuotes = new list<ServiceQuoteEntry> ();
                
        ServiceQuoteEntry entry = new ServiceQuoteEntry();
        entry.ID = sq.Id;
        entry.ServiceQuoteNumber = sq.Name;
        res.serviceQuotes.add(entry);
                
        return res;
    }
    
    public pagereference SearchObjects() {
        
        
        searchResults = new list<ServiceQuoteSearchResult>();

        set<id> QuoteNumbersSeen = new Set<id>();
  
        Pattern nonWordChar = Pattern.compile('[^0-9\\.]');
  
        if( (SearchFields.ServiceQuoteNumber != null &&  SearchFields.ServiceQuoteNumber != '' ) 
        ||(SearchFields.CaseNumber != null &&  SearchFields.CaseNumber != '' )
        ||(SearchFields.Zip != null &&  SearchFields.Zip != '' ) 
        ||(SearchFields.LoServiceQuoteAmount != null &&  SearchFields.LoServiceQuoteAmount != '' )  
        ||(SearchFields.HiServiceQuoteAmount != null &&  SearchFields.HiServiceQuoteAmount != '' )  )   
        {
            string soql = 'Select s.Ship_To_Zip__c, s.Case__c, s.Case__r.CaseNumber, s.Name, s.Quote__c,  s.Quote__r.Order__c, s.Quote__r.OpportunityName__c,s.Quote__r.OpportunityAddress__c, s.Quote__r.ContactName__c,   s.Quote__r.Order_Number__c, s.Quote__r.City__c, s.Quote__r.Opportunity__c, s.Quote__r.State__c, s.Quote__r.Zip__c, s.Quote__r.Quote_ID__c  FROM Service_Quote__c s  WHERE s.Id != null  ';
            if( (SearchFields.ServiceQuoteNumber != null &&  SearchFields.ServiceQuoteNumber != '' ) )
                soql += ' AND s.Name = \''+SearchFields.ServiceQuoteNumber.trim()+'\' ';
                 
            if (SearchFields.CaseNumber != null &&  SearchFields.CaseNumber != '' ) 
                soql += ' AND s.Case__r.CaseNumber like \'%'+SearchFields.CaseNumber.trim()+'%\' ';     
        
            if (SearchFields.FirstServiceQuote.Case__r.Type != null ) 
                soql += ' AND s.Case__r.Type = \''+SearchFields.FirstServiceQuote.Case__r.Type+'\' ';   
        
            if (SearchFields.Zip != null &&  SearchFields.Zip != '' ) 
                soql += ' AND s.Ship_To_Zip__c like \'%'+SearchFields.Zip.trim()+'%\' ';    
        
            if( SearchFields.LoServiceQuoteAmount != null && SearchFields.LoServiceQuoteAmount != '' )
            {
                soql += ' AND s.SubTotal__c >= ' + Double.valueOf( nonWordChar.matcher(SearchFields.LoServiceQuoteAmount).replaceAll('') ) +' ';
            }
            
            if( SearchFields.HiServiceQuoteAmount != null && SearchFields.HiServiceQuoteAmount != '' )
            {
                  
                soql += ' AND s.SubTotal__c <= ' +Double.valueOf( nonWordChar.matcher(SearchFields.HiServiceQuoteAmount).replaceAll('') )+' ';
            }
            
        
        
            soql += ' LIMIT 501 ';
        
            Sobject[] results = Database.query(soql);
            for( Sobject so : results )
            {
                
                Service_Quote__c sq = (Service_Quote__c)so;
                ServiceQuoteSearchResult res = getServiceQuoteSearchResultFromRecord(sq);               
                searchResults.add( res );
                
                QuoteNumbersSeen.add(sq.Quote__c);
                
            }
            
            resulttext = results.size() + ' matches found.';
            if( results.size() >= 500 )
            {
                Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO,'A very large amount of records were returned. Only the first 500 will be shown.') );
            }       
        } else {
            string configuration = '';
            
            string soql = 'SELECT qd.Id, qd.Quote__c, qd.Quote__r.Order__c, qd.Quote__r.Shipping_Phone__c, qd.Quote__r.Order_Number__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c, qd.Quote__r.OpportunityName__c,qd.Quote__r.OpportunityAddress__c, qd.Quote__r.ContactName__c, qd.Quote__r.State__c, qd.Quote__r.Zip__c, qd.Quote__r.Quote_ID__c FROM Quote_Detail__c qd WHERE qd.Id != null AND qd.Quote__r.Order_Number__c > 0 ';
            
            set<Id> QuoteIds = new set<Id>();

            if( SearchFields.Panels_Left != null  && SearchFields.Panels_Left != '' )
                configuration += SearchFields.Panels_Left + 'L';
            else configuration += '0L';
            
            if( SearchFields.Panels_Right != null  && SearchFields.Panels_Right != '' )
                configuration += SearchFields.Panels_Right + 'R';
            else configuration += '0R';
    
            if (configuration != '' && configuration != '0L0R' )
            {
                soql += ' AND Configuration__c = \''+configuration+'\' ';
            }       
            
            if( SearchFields.Panels_Count != null && SearchFields.Panels_Count != ''  && SearchFields.Panels_Count != '0' )
            {
                
                soql += ' AND Panels__c = '+Integer.valueOf( nonWordChar.matcher(SearchFields.Panels_Count).replaceAll('') )+' ';
            }
            
            if( SearchFields.ContactName != null && SearchFields.ContactName != '' )
                soql += ' AND qd.Quote__r.ContactName__c LIKE \'%'+SearchFields.ContactName+'%\' ';
            
            if(SearchFields.ProjectName != null && SearchFields.ProjectName != '' )
                soql += ' AND qd.Quote__r.OpportunityName__c LIKE \'%'+SearchFields.ProjectName+'%\' ';
            
            if(SearchFields.ProjectAddress != null && SearchFields.ProjectAddress != '' )
                soql += ' AND qd.Quote__r.OpportunityAddress__c LIKE \'%'+SearchFields.ProjectAddress+'%\' ';
            
            if( SearchFields.City != null && SearchFields.City != '' )
                soql += ' AND qd.Quote__r.City__c LIKE \'%'+SearchFields.City+'%\' ';
                
            if( SearchFields.Address != null && SearchFields.Address != '' )
                soql += ' AND qd.Quote__r.Address__c LIKE \'%'+SearchFields.Address+'%\' ';

            if( SearchFields.state != null && SearchFields.state != '' )
                soql += ' AND qd.Quote__r.State__c = \''+SearchFields.state+'\' ';
            
            if( SearchFields.Zip != null && SearchFields.Zip != '' )
                soql += ' AND qd.Quote__r.Zip__c LIKE \'%'+SearchFields.Zip+'%\' ';
        
            if( SearchFields.Phone != null && SearchFields.Phone != '' )
                soql += ' AND qd.Quote__r.Shipping_Phone__c like \'%'+SearchFields.Phone+'%\' ';

            if( SearchFields.Email != null && SearchFields.Email != '' )
                soql += ' AND qd.Quote__r.Calculated_Email__c like \'%'+SearchFields.Email+'%\' ';

            if( SearchFields.LoGrandTotal != null && SearchFields.LoGrandTotal != '' )
            {
                
                soql += ' AND qd.Quote__r.SubTotal__c >= ' + Double.valueOf( nonWordChar.matcher(SearchFields.LoGrandTotal).replaceAll('') )+' ';
            }
            
            if( SearchFields.HiGrandTotal != null && SearchFields.HiGrandTotal != '' )//sq15237
            {
                
                soql += ' AND qd.Quote__r.SubTotal__c <= ' + Double.valueOf( nonWordChar.matcher(SearchFields.HiGrandTotal).replaceAll('') ) +' ';
            }
            
            if( SearchFields.FirstServiceQuote.ETA__c != null )
            {
                datetime lodate = (datetime)SearchFields.FirstServiceQuote.ETA__c;
                soql += ' AND qd.Quote__r.CreatedDate >= '+lodate.format('yyyy-MM-dd')+'T00:00:00Z ';
            }
            
            if( SearchFields.SecondServiceQuote.ETA__c != null  )
            {
                datetime hidate = (datetime)SearchFields.SecondServiceQuote.ETA__c;

                soql += ' AND qd.Quote__r.CreatedDate <= '+hidate.format('yyyy-MM-dd')+'T00:00:00Z ';
            }


            if( SearchFields.QuoteNumber != null && SearchFields.QuoteNumber !=  '' )
                soql += ' AND qd.Quote__r.Quote_ID__c = '+SearchFields.QuoteNumber+' ';

            if( SearchFields.OrderNumber != null && SearchFields.OrderNumber !=  '' )
                soql += ' AND qd.Quote__r.Order_Number__c = '+SearchFields.OrderNumber+' ';

//          if( models.size() > 0 )
            {
                /*
                string modelSoql = '';
                for( string model : models )
                {
                    if( modelSoql != '' ) modelSoql += ' OR ';
                    soql += ' AND qd.Model__c = \''+model+'\' ';
                }
                soql += modelSoql;
                */
            if( models != null && models != '' )
                soql += ' AND qd.Model__c = \''+models+'\'';
            }
            soql += ' LIMIT 501 ';
//Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO, soql) );
System.debug(soql);
            Sobject[] results = Database.query(soql);
            for( Sobject so : results )
            {
                ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();
                Quote_Detail__c qd = (Quote_Detail__c)so;               
                
                if( qd != null 
                    && qd.Quote__c != null 
                    && QuoteNumbersSeen.contains(qd.Quote__c) )
                        continue;
                
                QuoteNumbersSeen.add(qd.Quote__c);
                
                //qd.Id, qd.Quote__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c, qd.Quote__r.State__c, qd.Quote__r.Zip__c 
                //Quote__r.Shipping_Phone__c, qd.Quote__r.Order_Number__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c, qd.Quote__r.OpportunityName__c,qd.Quote__r.OpportunityAddress__c, qd.Quote__r.ContactName__c, qd.Quote__r.State__c, qd.Quote__r.Zip__c, qd.Quote__r.Quote_ID__c
                res.City = qd.Quote__r.City__c;
                res.State = qd.Quote__r.State__c;
                res.Zip = qd.Quote__r.Zip__c;
                res.OrderID = String.valueOf(qd.Quote__r.Order_Number__c);
                res.OrderID_SFID = String.valueOf( qd.Quote__r.Order__c);        
                res.ProjectID = qd.Quote__r.Opportunity__c;
                res.QuoteID = qd.Quote__c;
                res.QuoteNumber = String.valueOf(qd.Quote__r.Quote_ID__c);
                res.ProjectName = qd.Quote__r.OpportunityName__c;
                res.ProjectAddress = qd.Quote__r.OpportunityAddress__c;
                res.ContactName = qd.Quote__r.ContactName__c;
                res.serviceQuotes = new list<ServiceQuoteEntry> ();
                res.origin = 'II';
                
                QuoteIds.add( qd.Quote__c );
                searchResults.add( res );
            } 


            /*Now do a service quote pass for any service quotes that (1) match the quote found up there or (2) match the search criteria*/
            soql = 'SELECT Id, Name, Quote__c,Quote__r.Order__c, Quote__r.Order_Number__c,Quote__r.Opportunity__c,Quote__r.OpportunityName__c,Quote__r.Quote_ID__c,Ship_To_City__c,Ship_To_Zip__c,Ship_To_Phone__c, Ship_To_State__c FROM Service_Quote__c WHERE Quote__c in :QuoteIds ';
            string soqlWhere = '';
//Quote__r.Order_Number__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c
            if( SearchFields.City != null && SearchFields.City != '' )
                soqlWhere += ' AND Ship_To_City__c LIKE \'%'+SearchFields.City+'%\' ';
                
            if( SearchFields.state != null && SearchFields.state != '' )
                soqlWhere += ' AND Ship_To_State__c = \''+SearchFields.state+'\' ';
            
            if( SearchFields.Zip != null && SearchFields.Zip != '' )
                soqlWhere += ' AND Ship_To_Zip__c LIKE \'%'+SearchFields.Zip+'%\' ';
        
            if( SearchFields.Phone != null && SearchFields.Phone != '' )
                soqlWhere += ' AND Ship_To_Phone__c like \'%'+SearchFields.Phone+'%\' ';
            
            
            if(soqlWhere != '' )
            {
                soql +=  'OR ( Id != null '+soqlWhere+' ) ';            
            }
            //Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO, soql) );
            
            for( Sobject so : Database.query(soql) )
            {
                Service_Quote__c sq  = (Service_Quote__c)so;
                
                boolean foundOnQuote = false;
                for( ServiceQuoteSearchResult res : searchResults ) 
                {
                    if( res.QuoteID == sq.Quote__c )
                    {
                        ServiceQuoteEntry entry = new ServiceQuoteEntry();
                        entry.ID = sq.Id;
                        entry.ServiceQuoteNumber = sq.Name;
                        res.serviceQuotes.add(entry);
                        foundOnQuote = true;
                    }
                }
                
                if( !foundOnQuote && models == '' )
                {
                    //wasnt already found on a quote; need to add as an independent search result from the filters
                    ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();

                    res.City = sq.Ship_To_City__c;
//                  res.State = sq.Ship_To_State__c;
                    res.Zip = sq.Ship_To_Zip__c;
                    res.OrderID = String.valueOf(sq.Quote__r.Order_Number__c);
                    res.OrderID_SFID = String.valueOf( sq.Quote__r.Order__c);
                    res.ProjectID = sq.Quote__r.Opportunity__c;
                    res.QuoteID = sq.Quote__c;
                    res.QuoteNumber = String.valueOf(sq.Quote__r.Quote_ID__c);
                    res.ProjectName = sq.Quote__r.OpportunityName__c;
                    res.serviceQuotes = new list<ServiceQuoteEntry> ();
                    
                    res.origin = 'III';
                    

                    ServiceQuoteEntry entry = new ServiceQuoteEntry();
                    entry.ID = sq.Id;
                    entry.ServiceQuoteNumber = sq.Name;
                    res.serviceQuotes.add(entry);
                    
                    searchResults.add( res );
                }
            }
                        
            resulttext = results.size() + ' matches found.';
            if( results.size() >= 500 )
            {
                Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO,'A very large amount of records were returned. Only the first 500 will be shown.') );
            }
        }       
        /*
           urlPass = true;
           PageReference pageRef= new PageReference('/apex/SerachresultsPageService');
           pageRef.setRedirect(true);       
           return pageRef; 
           */
           return null;
    }
    
   // ***** Unit Tests
    @isTest static void TestThisClass() {
        ServiceQuote_Home_Controller cont = new ServiceQuote_Home_Controller();
        
        Service_Quote__c sq = new Service_Quote__c();
        ServiceQuoteSearchResult res = cont.getServiceQuoteSearchResultFromRecord( sq );
        
        cont.getModelOptions();
        cont.getOldModelsChecked();
        cont.getOldModelsToggleValue();
        cont.getStates();
        string mod = cont.models;
        cont.resulttext = 'test result text';
        cont.SearchFields = new SearchContainer();
        cont.SearchFields.Address = 'test';
        cont.SearchFields.CaseNumber = 'test';
        cont.SearchFields.City = 'test';
        cont.SearchFields.ContactName = 'test';
        cont.SearchFields.Email = '';
        cont.SearchFields.FirstServiceQuote = new Service_Quote__c();
        cont.SearchFields.FirstServiceQuote.Case__r = new Case();
        cont.SearchFields.FirstServiceQuote.Case__r.Type = 'test';
        cont.SearchFields.HiGrandTotal = '10000';
        cont.SearchFields.HiServiceQuoteAmount = '1000000';
        cont.SearchFields.LoGrandTotal = '0';
        cont.SearchFields.LoServiceQuoteAmount = '0';
        cont.SearchFields.OrderNumber = '0';
        cont.SearchFields.Panels_Count = '3';
        cont.SearchFields.Panels_Left = '4';
        cont.SearchFields.Panels_Right = '1';
        cont.SearchFields.Phone = '1112223333';
        cont.SearchFields.ProjectAddress = 'test';
        cont.SearchFields.ProjectName = 'test';
        cont.SearchFields.QuoteNumber = '12345';
        cont.SearchFields.SecondServiceQuote = new Service_Quote__c();
        cont.SearchFields.state = 'new york';
        cont.SearchFields.Zip = '10001';
        cont.SearchFields.ServiceQuoteNumber = 'test';
        
        
        cont.sortField = 'Name';
        cont.previousSortField = 'Name';
        cont.sortexp = 'order by name asc';
        cont.SearchObjects();
        cont.doSort();      
        cont.sortField = cont.sortField;
        cont.doSort();
        
                
        cont.SearchFields.ServiceQuoteNumber = null;
        cont.SearchFields.CaseNumber = null;
        cont.SearchFields.Zip = null;
        cont.SearchFields.LoServiceQuoteAmount = null;
        cont.SearchFields.HiServiceQuoteAmount = null;
        cont.SearchObjects();
        
        
         res = new ServiceQuoteSearchResult();
        res.QuoteID  = 'test';// { get; set; }
        res.OrderID  = 'test';// { get; set; } { get; set; }
        res.City  = 'test';// { get; set; } { get; set; }
        res.State  = 'test';// { get; set; } { get; set; }
        res.Zip   = 'test';// { get; set; }{ get; set; }
        res.ContactName  = 'test';// { get; set; } { get; set; }
        res.ProjectName  = 'test';// { get; set; } { get; set; }
        res.ProjectAddress  = 'test';// { get; set; } { get; set; }
        res.ProjectID   = 'test';// { get; set; }{ get; set; }
        res.QuoteNumber  = 'test';// { get; set; }{ get; set; }
        res.serviceQuotes  = new list<ServiceQuoteEntry>();// { get; set; }
        res.origin  = 'test';// { get; set; } { get; set; }

        ServiceQuoteEntry entry = new ServiceQuoteEntry();
        entry.ID = 'test';
        entry.ServiceQuoteNumber = 'test';      
    }    
}