public with sharing class ServiceQuote_Search_Controller {

   /* class SearchContainer {
    
        public string City { get; set; } // quote, opportunity
        public string state { get; set; }// quote, opportunity
        public string Zip { get; set; }// quote, opportunity
        public string Panels_Left { get; set; } //quote_detail.Configuration__c 
        public string Panels_Right { get; set; } //quote_detail.Configuration__c 
        public string Panels_Count { get; set; } //quote_detail.Configuration__c 
        
        public string ServiceQuoteNumber { get; set; }
        public string CaseNumber { get; set; }
    }
    public SearchContainer SearchFields { get; set; }
    
   @testvisible
    class ServiceQuoteEntry {
        public string ID { get; set; }
        public string ServiceQuoteNumber{ get; set; }
    }
    @testvisible
    class ServiceQuoteSearchResult {
        public string QuoteID { get; set; }
        public string OrderID { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }
        public string ProjectName { get; set; }
        public string ProjectID { get; set; }
        public string QuoteNumber{ get; set; }
        public list<ServiceQuoteEntry> serviceQuotes { get; set; }
    }
    public list<ServiceQuoteSearchResult> searchResults { get; set; }
    
    public List<SelectOption> getStates() {
        return Utility.StateOptions();
    }
    

    private boolean initd = false;
    public ServiceQuote_Search_Controller(){
        
        if( !initd)
        {
            SearchFields = new SearchContainer();
            searchResults = new list<ServiceQuoteSearchResult>();
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
    public pagereference SearchObjects() {
        
        searchResults = new list<ServiceQuoteSearchResult>();
  
        if( (SearchFields.ServiceQuoteNumber != null &&  SearchFields.ServiceQuoteNumber != '' ) 
        ||(SearchFields.CaseNumber != null &&  SearchFields.CaseNumber != '' )  
        ||(SearchFields.Zip != null &&  SearchFields.Zip != '' )  )     
        {
system.debug('search branch 1');            
            string soql = 'Select s.Ship_To_Zip__c, s.Case__c, s.Case__r.CaseNumber, s.Name, s.Quote__c,  s.Quote__r.Order_Number__c, s.Quote__r.City__c, s.Quote__r.Opportunity__c, s.Quote__r.State__c, s.Quote__r.Zip__c, s.Quote__r.Quote_ID__c  FROM Service_Quote__c s  WHERE s.Id != null  ';
            if( (SearchFields.ServiceQuoteNumber != null &&  SearchFields.ServiceQuoteNumber != '' ) )
                soql += ' AND s.Name = \''+SearchFields.ServiceQuoteNumber.trim()+'\' ';
                 
            if (SearchFields.CaseNumber != null &&  SearchFields.CaseNumber != '' ) 
                soql += ' AND s.Case__r.CaseNumber like \'%'+SearchFields.CaseNumber.trim()+'%\' ';     
        
            if (SearchFields.CaseNumber != null &&  SearchFields.CaseNumber != '' ) 
                soql += ' AND s.Case__r.CaseNumber like \'%'+SearchFields.CaseNumber.trim()+'%\' ';     
                
        
            Sobject[] results = Database.query(soql);
            for( Sobject so : results )
            {
                ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();
                Service_Quote__c sq = (Service_Quote__c)so;
                //qd.Id, qd.Quote__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c, qd.Quote__r.State__c, qd.Quote__r.Zip__c 
                res.City = sq.Quote__r.City__c;
                res.State = sq.Quote__r.State__c;
//              res.Zip = sq.Quote__r.Zip__c;
                res.Zip = sq.Ship_To_Zip__c;
                res.OrderID = String.valueOf(sq.Quote__r.Order_Number__c);
                res.ProjectID = sq.Quote__r.Opportunity__c;
                res.QuoteID = sq.Quote__c;
                res.QuoteNumber = String.valueOf(sq.Quote__r.Quote_ID__c);
                
                res.serviceQuotes = new list<ServiceQuoteEntry> ();
                ServiceQuoteEntry entry = new ServiceQuoteEntry();
                entry.ID = sq.Id;
                entry.ServiceQuoteNumber = sq.Name;
                res.serviceQuotes.add(entry);
                
                searchResults.add( res );
            }
//Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO,soql) );
            
            resulttext = results.size() + ' matches found.';
            if( results.size() >= 1000 )
            {
                Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO,'A very large amount of records were returned. Only the first 1000 will be shown.') );
            }       
        } else {
system.debug('search branch 2');
            
            string configuration = '';
            
    //Select qd.Id, qd.Quote__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c, qd.Quote__r.State__c, qd.Quote__r.Zip__c from Quote_Detail__c q       
            string soql = 'SELECT qd.Id, qd.Quote__c, qd.Quote__r.Order_Number__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c, qd.Quote__r.State__c, qd.Quote__r.Zip__c, qd.Quote__r.Quote_ID__c FROM Quote_Detail__c qd WHERE qd.Id != null AND qd.Quote__r.Order_Number__c > 0 ';
            
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
                soql += ' AND Panels__c = '+SearchFields.Panels_Count+' ';
            
            if( SearchFields.City != null && SearchFields.City != '' )
                soql += ' AND qd.Quote__r.City__c LIKE \'%'+SearchFields.City+'%\' ';
                
            if( SearchFields.state != null && SearchFields.state != '' )
                soql += ' AND qd.Quote__r.State__c = \''+SearchFields.state+'\' ';
            
            if( SearchFields.Zip != null && SearchFields.Zip != '' )
                soql += ' AND qd.Quote__r.Zip__c LIKE \'%'+SearchFields.Zip+'%\' ';
    
            soql += ' LIMIT 1000 ';

    
    //Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO,soql) );
    //return null;
            
            Sobject[] results = Database.query(soql);
            for( Sobject so : results )
            {
                ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();
                Quote_Detail__c qd = (Quote_Detail__c)so;
                //qd.Id, qd.Quote__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c, qd.Quote__r.State__c, qd.Quote__r.Zip__c 
                res.City = qd.Quote__r.City__c;
                res.State = qd.Quote__r.State__c;
                res.Zip = qd.Quote__r.Zip__c;
                res.OrderID = String.valueOf(qd.Quote__r.Order_Number__c);
                res.ProjectID = qd.Quote__r.Opportunity__c;
                res.QuoteID = qd.Quote__c;
                res.QuoteNumber = String.valueOf(qd.Quote__r.Quote_ID__c);
                res.serviceQuotes = new list<ServiceQuoteEntry> ();
                
                QuoteIds.add( qd.Quote__c );
                searchResults.add( res );
            }

            list<id> qIds = new LIst<Id>( QuoteIDs);
            for( Service_Quote__c sq :  [SELECT Id, Name, Quote__c FROM Service_Quote__c WHERE Quote__c in :qIds])
            {
                for( ServiceQuoteSearchResult res : searchResults ) 
                {
                    if( res.QuoteID == sq.Quote__c )
                    {
                        ServiceQuoteEntry entry = new ServiceQuoteEntry();
                        entry.ID = sq.Id;
                        entry.ServiceQuoteNumber = sq.Name;
                        res.serviceQuotes.add(entry);
//                      break; //break the inner loop == found the quote
                    }
                }
            }
            
                        
            resulttext = results.size() + ' matches found.';
            if( results.size() >= 1000 )
            {
                Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO,'A very large amount of records were returned. Only the first 1000 will be shown.') );
            }
        }       
        
        
        return null;
    }*/
}