public with sharing class ServiceQuote_Home_Controller4 {

    public SearchContainer SearchFields {
        get;
        set;
    }
    public list < ServiceQuoteSearchResult > searchResults {
        get;
        set;
    }
    private boolean initd = false;
    public String sortField {
        get;
        set;
    }
    public String previousSortField {
        get;
        set;
    }
    public String sortExp {
        get;
        set;
    }
    public string resultText {
        get;
        set;
    }
    public string JSurl {
        get;
        set;
    }



    //put this back on the UI for old model search
    //<input {!OldModelsChecked} type='checkbox' id='chkShowOldModels' onclick="_refreshModelSelector()" /> include old models
    public String models {
        get;
        set;
    }

    /**************************************Constructor for Main class****************************************************/
    public ServiceQuote_Home_Controller4() {

        if (!initd) {
            SearchFields = new SearchContainer();
            searchResults = new list < ServiceQuoteSearchResult > ();
            SearchFields.firstServiceQuote = new Service_Quote__c();
            SearchFields.secondServiceQuote = new Service_Quote__c();
            SearchFields.firstServiceQuote.ETA__c = null;
            SearchFields.secondServiceQuote.ETA__c = null;
        }
        
    }


    //  private set<string> excludedModels = new set<String>{ 'hsw 50', 'hsw 55', 'sl 35l', 'sl 35us', 'sl 45us', 'sl 50', 'sl 50l', 'sl 50us', 'sl 68l', 'sl 72', 'sl 72l', 'sl 78f', 'sl 78l', 'sl 78tt', 'vsw 50', 'wd 75' };
    private set < string > excludedModels = new set < String > {};

    public string getOldModelsChecked() {
        if ((Apexpages.currentPage().getParameters().get('useOldModels') != null)) return ' checked="checked" ';
        else return '';
    }


    public string getOldModelsToggleValue() {
        if ((Apexpages.currentPage().getParameters().get('useOldModels') != null)) return '';
        else return 'useOldModels=true';
    }

     /***
    Getting modeloptions
    ***/
    public List < SelectOption > getModelOptions() {

        List < SelectOption > options = new List < SelectOption > ();

        Schema.DescribeFieldResult f = Schema.sObjectType.Opportunity.fields.Models__c;
        boolean useOldModels = (Apexpages.currentPage().getParameters().get('useOldModels') != null);

        options.add(new Selectoption('', '-SELECT-'));
        for (Schema.Picklistentry entry: f.getPicklistValues()) {
            if (!useOldModels && this.excludedModels.contains(entry.getValue().toLowerCase())) continue;

            options.add(new Selectoption(entry.getvalue(), entry.getlabel()));
        }

        return options;
    }


    /***
    Getting States list
    ***/
    public List < SelectOption > getStates() {
        List < SelectOption > options = new List < SelectOption > ();

        Schema.DescribeFieldResult f = Schema.sObjectType.Account.fields.State__c;

        for (Schema.Picklistentry entry: f.getPicklistValues()) {
            options.add(new Selectoption(entry.getvalue(), entry.getlabel()));
        }


        return options;
    }

    /***
    Getting Countries list
    ***/
    public List < SelectOption > getCountry() {
        List < SelectOption > options = new List < SelectOption > ();
        Schema.DescribeFieldResult s = Schema.sObjectType.Account.fields.Country__c;
        for (Schema.Picklistentry entry: s.getPicklistValues()) {
            Options.add(new Selectoption(entry.getvalue(), entry.getlabel()));
        }
        return options;
    }



    /***
    Do sort method
    ***/
    public pagereference dosort() {

        return null;
    }




    /***
    ServiceQuoteEntry wrapper class
    ***/
@TestVisible    class ServiceQuoteEntry {
        public string ID {
            get;
            set;
        }
        public string ServiceQuoteNumber {
            get;
            set;
        }
    }
    
    /***
    serviceQuoteSearchResult wrapper class
    ***/
    
@TestVisible   class ServiceQuoteSearchResult {
        public string QuoteID {
            get;
            set;
        }
        public string OrderID {
            get;
            set;
        }
        public string contactId{
            get;
            set;
        }
        public string City {
            get;
            set;
        }
        public string State {
            get;
            set;
        }
        public string Zip {
            get;
            set;
        }
        public string ContactName {
            get;
            set;
        }
        public string LastName {
            get;
            set;
        }
        public string FirstName {
            get;
            set;
        }
        public string ProjectName {
            get;
            set;
        }
        public string ProjectAddress {
            get;
            set;
        }
        public string ProjectID {
            get;
            set;
        }
        public string QuoteNumber {
            get;
            set;
        }
        public list < ServiceQuoteEntry > serviceQuotes {
            get;
            set;
        }
        public string origin {
            get;
            set;
        }
        public string ContactEmail {
            set;
            get;
        }
        public string Phone {
            set;
            get;
        }
        public string CaseId {
            set;
            get;
        }
        public string ProjectStreet {
            set;
            get;
        }
        public string ProjectCountry {
            set;
            get;
        }
        public String CaseNumber {
            set;
            get;
        }
        Public String PanelCount {
            set;
            get;
        }
        public string orderNumber {
            set;
            get;
        }
        public Boolean Selected {
            get;
            set;
        }

    }


    public ServiceQuoteSearchResult getServiceQuoteSearchResultFromRecord(Service_Quote__c sq) {
        ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();

        res.City = sq.Case__r.Order__r.NanaQuote__r.Project__r.Project_City__c;
        res.State = sq.Case__r.Order__r.NanaQuote__r.Project__r.Project_State__c;
        res.Zip = sq.Case__r.Order__r.NanaQuote__r.Project__r.Project_Zip_Code__c;
        res.OrderID = String.valueOf(sq.Case__r.Order__c);
        res.contactId = string.valueOf(sq.Case__r.Order__r.Contact__c);
        
        res.ProjectID = sq.Case__r.Order__r.NanaQuote__r.Project__c;
        res.QuoteID = sq.Case__r.Order__r.NanaQuote__c;
        res.QuoteNumber = String.valueOf(sq.Case__r.Order__r.NanaQuote__r.Name);
        res.ProjectName = sq.Case__r.Order__r.NanaQuote__r.Project__r.Name;
        //  res.ProjectAddress = sq.Quote__r.OpportunityAddress__c;
        res.ContactName = sq.Case__r.Order__r.Contact__r.FirstName + ' ' + sq.Case__r.Order__r.Contact__r.LastName;
        res.ContactEmail = sq.Case__r.Order__r.Contact__r.Email;
        res.ProjectCountry = sq.Case__r.Order__r.NanaQuote__r.Project__r.Project_Country__c;
        res.ProjectStreet = sq.Case__r.Order__r.NanaQuote__r.Project__r.Project_Street_Address__c;
        res.Phone = sq.Case__r.Order__r.Contact__r.Phone;
        res.CaseNumber = sq.Case__r.CaseNumber;
        res.CaseId = sq.Case__c;
        res.origin = 'I';

        res.serviceQuotes = new list < ServiceQuoteEntry > ();

        ServiceQuoteEntry entry = new ServiceQuoteEntry();
        entry.ID = sq.Id;
        entry.ServiceQuoteNumber = sq.Name;
        res.serviceQuotes.add(entry);

        return res;
    }

    /****************************** calling create case method **********************************/
   /* public pagereference createcase() {
        Integer countofselect = 0;
        PageReference newPage;
        String newURL = '/';
        Schema.DescribeSObjectResult descResult = case.sObjectType.getDescribe();
        String keyPrefix = descResult.getKeyPrefix();
        newURL += keyPrefix + '/e';


        if (!searchresults.isEmpty()) {

            list < string > strlist = new list < string > ();

            for (ServiceQuoteSearchResult sqq: searchresults) {
                strlist.add(sqq.ContactEmail);
            }

            list < contact > conlist = [select id, email, accountid, account.BillingCountry, account.BillingCity, account.BillingState, account.BillingStreet, account.BillingPostalCode, account.ShippingStreet, account.ShippingCity, account.ShippingState, account.ShippingCountry, account.ShippingPostalCode from contact where email in: strlist];
            for (ServiceQuoteSearchResult sq: searchresults) {

                if (sq.selected) {

                    for (contact con: conlist) {

                        if (con.email == sq.ContactEmail) {
                            string[] s = sq.ContactName.split(' ');

                            //newpage=new pagereference(+newURL+'?'+Label.Quote_number_Id+'='+sq.quoteNumber +'&'+Label.Quote_number_Id+'_lkid'+'='+sq.quoteid );
                            newpage = new pagereference(+newURL + '?' + Label.Quote_number_Id + '=' + sq.quoteNumber + '&' + Label.Quote_number_Id + '_lkid' + '=' + sq.quoteid + '&' + Label.Contact_Name + '=' + sq.ContactName + '&' + Label.First_Name + '=' + s[0] + '&' + Label.Last_Name + '=' + s[1] + '&' + Label.Phone + '=' + sq.Phone + '&' + Label.Email + '=' + sq.ContactEmail + '&' + Label.Project_Site_Country + '=' + sq.ProjectCountry + '&' + Label.Project_Site_Street_Address + '=' + sq.ProjectStreet + '&' + Label.Project_Site_City + '=' + sq.City + '&' + Label.Project_Site_State + '=' + sq.State + '&' + Label.Project_Site_Zip + '=' + sq.Zip + '&' + Label.Billing_Address_Country + '=' + con.Account.BillingCountry + '&' + Label.Billing_Address_State + '=' + con.Account.BillingState + '&' + Label.Billing_Address_City + '=' + con.Account.BillingCity + '&' + Label.Billing_Address_Street + '=' + con.account.BillingStreet + '&' + Label.Billing_Address_Zip_Postal_Code + '=' + con.account.BillingPostalCode + '&' + Label.Shipping_Address_Street + '=' + con.account.ShippingStreet + '&' + Label.Shipping_Address_City + '=' + con.account.ShippingCity + '&' + Label.Shipping_Address_State + '=' + con.account.ShippingState + '&' + Label.Shipping_Address_Country + '=' + con.account.ShippingCountry + '&' + Label.Shipping_Address_Zip_Postal_Code + '=' + con.account.ShippingPostalCode);
                            // newPage.getParameters().put('order_Number__c', ApexPages.currentPage().getParameters().get(sq.orderid));
                            //newPage.getParameters().put('retURL', ApexPages.currentPage().getParameters().get('retURL'));
                            countofselect++;
                        }
                    }
                }
                if (countofselect > 1) {
                    Apexpages.addMessage(new ApexPages.message(apexpages.Severity.error, 'check only one'));
                    return null;
                }
            }
        } else {
            //newpage=new pagereference(+newURL+'?'+Label.Quote_number_Id+'='+searchfields.QuoteNumber +'&'+Label.Quote_number_Id+'_lkid'+'='+sq.QuoteID + '&'+Label.First_Name+'='+searchfields.FirstName +'&'+Label.Last_Name+'='+searchfields.LastName +'&'+Label.Phone+'='+searchfields.Phone +'&'+Label.Email+'='+searchfields.Email);
            newpage = new pagereference(+newURL + '?' + Label.First_Name + '=' + searchfields.FirstName + '&' + Label.Last_Name + '=' + searchfields.LastName + '&' + Label.Phone + '=' + searchfields.Phone + '&' + Label.Email + '=' + searchfields.Email + '&' + Label.Project_Site_Country + '=' + searchfields.ProjectCountry + '&' + Label.Project_Site_Street_Address + '=' + searchfields.ProjectStreet + '&' + Label.Project_Site_City + '=' + searchfields.City + '&' + Label.Project_Site_State + '=' + searchfields.state + '&' + Label.Project_Site_Zip + '=' + searchfields.Zip);
        }
        //newPage.setRedirect(true);
        JSurl = 'newpage';
        return newpage;




    }*/

    /***
    Calling SearchObjects Method
    ***/

    public pagereference SearchObjects() {

        searchResults = new list < ServiceQuoteSearchResult > ();

        list < ServiceQuoteSearchResult > SearchResultChecklist = new list < ServiceQuoteSearchResult > ();

        set < id > QuoteNumbersSeen = new Set < id > ();

        Pattern nonWordChar = Pattern.compile('[^0-9\\.]');
        //Search using Order Object
        if ((SearchFields.Zip != null && SearchFields.Zip != '') ||
            (SearchFields.ProjectCountry != null && SearchFields.ProjectCountry != '') ||
            (SearchFields.City != null && SearchFields.City != '') ||
            (SearchFields.State != null && SearchFields.State != '') ||
            (SearchFields.Email != null && SearchFields.Email != '') ||
            (SearchFields.OrderNumber != null && SearchFields.OrderNumber != '') ||
            (SearchFields.QuoteNumber!= null && SearchFields.QuoteNumber!= '') ||
            (searchFields.ProjectStreet != null && SearchFields.ProjectStreet != '') ||
            (searchFields.phone != NULL && searchFields.phone != '') ||
            (SearchFields.LastName != NULL && SearchFields.LastName != '') ||
            (SearchFields.FirstName != null && SearchFields.FirstName != '')) {
            string soql = 'select id, OrderNumber, NanaQuote__r.Name, NanaQuote__r.Opportunity__r.Project_Name__r.Name, NanaQuote__r.Quote_ID__c, NanaQuote__r.Opportunity__r.Project_Name__c, NanaQuote__r.Opportunity__r.Project_Name__r.Project_City__c, NanaQuote__r.Opportunity__r.Project_Name__r.Project_Country__c, NanaQuote__r.Opportunity__r.Project_Name__r.Project_State__c, NanaQuote__r.Opportunity__r.Project_Name__r.Project_Street_Address__c, NanaQuote__r.Opportunity__r.Project_Name__r.Project_Zip_Code__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Email, Contact__r.Phone from order WHERE id!=NULL ';

            if (SearchFields.OrderNumber != null && SearchFields.OrderNumber.trim() != '') {

                soql += 'AND OrderNumber like \'%' + SearchFields.OrderNumber + '%\' ';
            }
            if (SearchFields.QuoteNumber!= null && SearchFields.QuoteNumber.trim() != '') {

                soql += 'AND NanaQuote__r.Name like \'%' + SearchFields.QuoteNumber+ '%\' ';
            }
            if (SearchFields.FirstName != null && SearchFields.FirstName.trim() != '') {

                soql += ' AND Contact__r.FirstName like \'%' + SearchFields.FirstName + '%\' ';
            }
            if (SearchFields.LastName != NULL && SearchFields.LastName != '') {

                soql += ' AND Contact__r.LastName like \'%' + SearchFields.LastName.trim() + '%\' ';
            }
            if (SearchFields.Email != null && SearchFields.Email != '') {

                soql += ' AND Contact__r.Email like \'%' + SearchFields.Email.trim() + '%\' ';
            }
            if (searchFields.phone != NULL && searchFields.phone != '') {

                soql += ' AND Contact__r.Phone like \'%' + searchFields.phone.trim() + '%\' ';
            }
            if (SearchFields.City != null && SearchFields.City != '') {

                soql += ' AND NanaQuote__r.Opportunity__r.Project_Name__r.Project_City__c like \'%' + SearchFields.City.trim() + '%\' ';
            }
            if (SearchFields.State != null && SearchFields.State != '') {

                soql += ' AND NanaQuote__r.Opportunity__r.Project_Name__r.Project_State__c like \'%' + SearchFields.State.trim() + '%\' ';
            }
            if (SearchFields.ProjectCountry != null && SearchFields.ProjectCountry != '') {

                soql += ' AND NanaQuote__r.Opportunity__r.Project_Name__r.Project_Country__c like \'%' + SearchFields.ProjectCountry.trim() + '%\' ';
            }
            if (searchFields.ProjectStreet != null && SearchFields.ProjectStreet != '') {

                soql += ' AND NanaQuote__r.Opportunity__r.Project_Name__r.Project_Street_Address__c like \'%' + searchFields.ProjectStreet.trim() + '%\' ';
            }
            if (SearchFields.Zip != null && SearchFields.Zip != '') {

                soql += ' AND NanaQuote__r.Opportunity__r.Project_Name__r.Project_Zip_Code__c like \'%' + SearchFields.Zip.trim() + '%\' ';
            }

            soql += ' LIMIT 501 ';

            Sobject[] results = Database.query(soql);
            for (Sobject so: results) {

                ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();
                Order ord = (Order) so;
                res.City = ord.NanaQuote__r.Opportunity__r.Project_Name__r.Project_City__c;
                res.State = ord.NanaQuote__r.Opportunity__r.Project_Name__r.Project_State__c;
                res.Zip = ord.NanaQuote__r.Opportunity__r.Project_Name__r.Project_Zip_Code__c;
                res.OrderID = String.valueOf(ord.id);
                res.orderNumber=String.valueOf(ord.OrderNumber);
                res.ProjectID = ord.NanaQuote__r.Opportunity__r.Project_Name__c;
                res.QuoteID = ord.NanaQuote__c;
                res.QuoteNumber = String.valueOf(ord.NanaQuote__r.Name);
                res.ProjectName = ord.NanaQuote__r.Opportunity__r.Project_Name__r.Name;
                res.ContactName = ord.Contact__r.FirstName + ' ' + ord.Contact__r.LastName;
                res.ProjectCountry = ord.NanaQuote__r.Opportunity__r.Project_Name__r.Project_Country__c;
                res.ProjectStreet = ord.NanaQuote__r.Opportunity__r.Project_Name__r.Project_Street_Address__c;
                res.ContactEmail = ord.Contact__r.Email;
                res.Phone = ord.Contact__r.Phone;
                res.contactId = string.valueOf(ord.contact__c);

                searchResults.add(res);
                SearchResultChecklist.add(res);

                QuoteNumbersSeen.add(ord.NanaQuote__c);

            }
            System.debug('&&&&&&&&&&&&&&&&&&&&&&&&'+SearchResultChecklist);
            resultText = results.size() + ' matches found.';
            if (results.size() >= 500) {
                Apexpages.addMessage(new ApexPages.message(apexpages.Severity.INFO, 'A very large amount of records were returned. Only the first 500 will be shown.'));
            }
        }
        
        //Search Using Quote Deatil Object
        
        if ((models != null && models != '') || (SearchFields.Panels_Count != null && SearchFields.Panels_Count != '') || (SearchFields.Panels_Left != null && SearchFields.Panels_Left != '') || (SearchFields.Panels_Right != null && SearchFields.Panels_Right != '') ) {
            string configuration = '';
            searchResults.clear();
            string soql = 'SELECT qd.Id, qd.name, qd.Quote__c, qd.Quote__r.Name, qd.quote__r.contact__r.phone,qd.quote__r.contact__r.email,qd.quote__r.Project__r.Project_Street_Address__c,qd.quote__r.Project__r.Project_Country__c ,qd.Quote__r.Email__c,qd.Quote__r.Order_Number__c, qd.Quote__r.Project__r.Project_City__c, qd.Configuration__c, qd.Quote__r.Project__c, qd.Quote__r.Project_Name__c,qd.Quote__r.OpportunityAddress__c,qd.Quote__r.Contact__r.id, qd.Quote__r.ContactName__c,qd.quote__r.State__c, qd.Model__c, qd.Quote__r.Project__r.Project_Zip_Code__c,qd.Quote__r.Quote_ID__c FROM Quote_Detail__c qd WHERE qd.Id != null AND qd.Quote__r.Order_Number__c > 0  ';

            set < Id > QuoteIds = new set < Id > ();

            if (SearchFields.Panels_Left != null && SearchFields.Panels_Left != '') {
                configuration += SearchFields.Panels_Left + 'L';
            }
            /*   else {
               configuration += '0L';
               }*/

            if (SearchFields.Panels_Right != null && SearchFields.Panels_Right != '') {
                configuration += SearchFields.Panels_Right + 'R';
            }

            /*  else {
              configuration += '0R';
              }*/


            if (configuration != '' /*&& configuration != '0L0R'*/ ) {
                soql += ' AND Configuration__c LIKE \'%' + configuration + '%\' ';
            }

            if (SearchFields.Panels_Count != null && SearchFields.Panels_Count != '' && SearchFields.Panels_Count != '0') {

                soql += ' AND Panels__c = ' + Integer.valueOf(nonWordChar.matcher(SearchFields.Panels_Count).replaceAll('')) + ' ';
            }


            if (SearchFields.ContactName != null && SearchFields.ContactName != '') {
                soql += ' AND qd.Quote__r.ContactName__c LIKE \'%' + SearchFields.ContactName.trim() + '%\' ';

            }

            if (SearchFields.LastName != null && SearchFields.LastName != '') {
                soql += ' AND qd.Quote__r.Contact__r.LastName like \'%' + SearchFields.LastName.trim() + '%\' ';
            }
            if (SearchFields.FirstName != null && SearchFields.FirstName != '') {
                soql += ' AND qd.Quote__r.Contact__r.FirstName like \'%' + SearchFields.FirstName.trim() + '%\' ';

            }

            if (SearchFields.ProjectName != null && SearchFields.ProjectName != '') {
                soql += ' AND qd.Quote__r.Project__r.name LIKE \'%' + SearchFields.ProjectName.trim() + '%\' ';
            }

            if (SearchFields.City != null && SearchFields.City != '') {
                soql += ' AND qd.Quote__r.Project__r.Project_City__c LIKE \'%' + SearchFields.City.trim() + '%\' ';
            }

            if (SearchFields.state != null && SearchFields.state != '') {
                soql += ' AND qd.Quote__r.Project__r.Project_State__c = \'' + SearchFields.state.trim() + '\' ';
            }

            if (SearchFields.Zip != null && SearchFields.Zip != '') {
                soql += ' AND qd.Quote__r.Project__r.Project_Zip_Code__c  LIKE \'%' + SearchFields.Zip.trim() + '%\' ';
            }

            if (SearchFields.Phone != null && SearchFields.Phone != '') {
                soql += ' AND qd.Quote__r.Contact__r.Phone like \'%' + SearchFields.Phone.trim() + '%\' ';

            }
            if (SearchFields.ProjectStreet != null && SearchFields.ProjectStreet != '') {
                soql += 'AND qd.Quote__r.Project__r.Project_Street_Address__c LIKE \'%' + SearchFields.ProjectStreet.trim() + '%\' ';
            }

            if (SearchFields.Email != null && SearchFields.Email != '') {
                soql += ' AND qd.Quote__r.Contact__r.Email like \'%' + SearchFields.Email.trim() + '%\' ';
            }

            if (SearchFields.ProjectCountry != null && SearchFields.ProjectCountry != '') {
                soql += ' And qd.Quote__r.Project__r.Project_Country__c=\'' + SearchFields.ProjectCountry.trim() + '\' ';
            }

            if (SearchFields.ServiceQuoteNumber != null && SearchFields.ServiceQuoteNumber != '') {
                soql += ' AND qd.Name = \'' + SearchFields.ServiceQuoteNumber.trim() + '\' ';
            }
            
            if (SearchFields.OrderNumber != null && SearchFields.OrderNumber != '') {
                soql += ' AND qd.Quote__r.Order_Number__c = ' + SearchFields.OrderNumber.trim() + ' ';
            }        

            if (models != null && models != '') {
                soql += ' AND qd.Model__c like \'%' + models + '%\' ';

            }
            System.debug('------------- soql Query-----' + soql + '------------Models------' + Models + '------------' + SearchFields.Zip);

            soql += ' LIMIT 501 ';
            //Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO, soql) );
            System.debug('modellast----------------' + soql);
            list < Sobject > results = new list < Sobject > ();

            /*if( models != null && models != '' || SearchFields.Panels_Count != null && SearchFields.Panels_Count != '' || SearchFields.Panels_Right != null  && SearchFields.Panels_Right != '' || SearchFields.Panels_Left != null  && SearchFields.Panels_Left != '')
            {
               if(soql !=null || soql !='')
               {
                     results = Database.query(soql);
               }
            }*/
            results = Database.query(soql);
            for (Sobject so: results) {
                ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();
                Quote_Detail__c qd = (Quote_Detail__c) so;

                /* if( qd != null && qd.Quote__c != null )
                   
                     continue;*/


                QuoteNumbersSeen.add(qd.Quote__c);

                //qd.Id, qd.Quote__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c, qd.Quote__r.State__c, qd.Quote__r.Zip__c 
                //Quote__r.Shipping_Phone__c, qd.Quote__r.Order_Number__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c, qd.Quote__r.Project_Name__c,qd.Quote__r.OpportunityAddress__c, qd.Quote__r.ContactName__c, qd.Quote__r.State__c, qd.Quote__r.Zip__c, qd.Quote__r.Quote_ID__c
                res.City = qd.Quote__r.Project__r.Project_City__c;
                res.State = qd.Quote__r.State__c;
                res.Zip = qd.Quote__r.Project__r.Project_Zip_Code__c;
                res.OrderID = String.valueOf(qd.Quote__c);
                res.orderNumber = String.valueOf(qd.Quote__r.Order_Number__c);
                res.ProjectID = qd.Quote__r.Project__c;
                res.QuoteID = qd.Quote__c;
                res.QuoteNumber = String.valueOf(qd.Quote__r.Name);
                res.ProjectName = qd.Quote__r.Project_Name__c;
                res.ContactName = qd.Quote__r.ContactName__c;
                res.ProjectCountry = qd.Quote__r.Project__r.Project_Country__c;
                res.ProjectStreet = qd.Quote__r.Project__r.Project_Street_Address__c;
                res.ContactEmail = qd.Quote__r.Contact__r.Email;
                res.Phone = qd.Quote__r.Contact__r.Phone;
                res.contactId = string.valueOf(qd.Quote__r.Contact__c);

                QuoteIds.add(qd.Quote__c);
                searchResults.add(res);
            }


            /*Now do a service quote pass for any service quotes that (1) match the quote found up there or (2) match the search criteria*/
            /* soql = 'SELECT Id, Name, Quote__c,Case__r.CaseNumber, Quote__r.Order_Number__c,Quote__r.Opportunity__c,Quote__r.Project_Name__c,Quote__r.Quote_ID__c,Quote__r.Project__r.Project_Street_Address__c,Quote__r.Project__r.Project_Country__c,Quote__r.Contact__r.Email,Quote__r.Project__r.Project_City__c,Ship_To_Zip__c,Quote__r.Contact__r.Phone, Ship_To_State__c FROM Service_Quote__c WHERE Quote__c in :QuoteIds ';
      string soqlWhere = '';
//Quote__r.Order_Number__c, qd.Quote__r.City__c, qd.Quote__r.Opportunity__c
        if( SearchFields.City != null && SearchFields.City != '' )
          soqlWhere += ' AND Ship_To_City__c LIKE \'%'+SearchFields.City+'%\' ';
          
        if( SearchFields.state != null && SearchFields.state != '' )
          soqlWhere += ' AND Ship_To_State__c = \''+SearchFields.state+'\' ';
        
        if( SearchFields.Zip != null && SearchFields.Zip != '' )
          soqlWhere += ' AND Ship_To_Zip__c LIKE \'%'+SearchFields.Zip+'%\' ';
    
      if( SearchFields.Phone != null && SearchFields.Phone != '' )
        soqlWhere += ' AND Quote__r.Contact__r.Phone like \'%'+SearchFields.Phone+'%\' ';
      
      
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

          res.City = sq.Quote__r.Project__r.Project_City__c;
//          res.State = sq.Ship_To_State__c;
         // res.Zip = sq.Ship_To_Zip__c;
          res.OrderID = String.valueOf(sq.Quote__r.Order_Number__c);
          res.ProjectID = sq.Quote__r.Project__c;
          res.QuoteID = sq.Quote__c;
          res.QuoteNumber = String.valueOf(sq.Quote__r.Quote_ID__c);
          res.ProjectName = sq.Quote__r.Project_Name__c;
          res.Phone=sq.Quote__r.Contact__r.Phone;
          res.ProjectCountry=sq.Quote__r.Project__r.Project_Country__c;
          res.ProjectStreet=sq.Quote__r.Project__r.Project_Street_Address__c;
          res.ContactEmail=sq.Quote__r.Contact__r.Email;
          res.State = sq.Quote__r.State__c;
          res.Zip = sq.Quote__r.Project__r.Project_Zip_Code__c;
          
          
          res.serviceQuotes = new list<ServiceQuoteEntry> ();
          
          res.origin = 'III';
          

          ServiceQuoteEntry entry = new ServiceQuoteEntry();
          entry.ID = sq.Id;
          entry.ServiceQuoteNumber = sq.Name;
          res.serviceQuotes.add(entry);
          
          searchResults.add( res );
        }
      }*/

            resultText = results.size() + ' matches found.';
            if (results.size() >= 500) {
                Apexpages.addMessage(new ApexPages.message(apexpages.Severity.INFO, 'A very large amount of records were returned. Only the first 500 will be shown.'));
            }
        }
        //Search using Service Quote Object
        if ((SearchFields.ServiceQuoteNumber != null && SearchFields.ServiceQuoteNumber != '')) {
                searchResults.clear();
            string soql = 'Select s.id, s.Case__c, s.Case__r.CaseNumber, s.Case__r.Order__c, s.Case__r.Order__r.NanaQuote__r.Name, s.Case__r.Order__r.NanaQuote__c, s.Case__r.Order__r.NanaQuote__r.Project__c, s.Name, s.Case__r.Order__r.NanaQuote__r.Project__r.Name, s.Case__r.Order__r.NanaQuote__r.Project__r.Project_City__c, s.Case__r.Order__r.NanaQuote__r.Project__r.Project_Street_Address__c, s.Case__r.Order__r.NanaQuote__r.Project__r.Project_State__c, s.Case__r.Order__r.NanaQuote__r.Project__r.Project_Country__c, s.Case__r.Order__r.NanaQuote__r.Project__r.Project_Zip_Code__c, s.Case__r.Order__r.OrderNumber, s.Case__r.Order__r.Contact__r.FirstName, s.Case__r.Order__r.Contact__r.LastName, s.Case__r.Order__r.Contact__r.Email, s.Case__r.Order__r.Contact__r.Phone, s.Case__r.Caller_contact__r.FirstName, s.Case__r.Caller_contact__r.LastName, s.Case__r.Caller_contact__r.Email, s.Case__r.Caller_contact__r.Phone, s.Case__r.Contact.FirstName, s.Case__r.Contact.LastName, s.Case__r.Contact.Email, s.Case__r.Contact.Phone FROM Service_Quote__c s  WHERE s.id!=NULL ';

            if ((SearchFields.ServiceQuoteNumber != null && SearchFields.ServiceQuoteNumber != '')) {
                soql += 'AND s.Name like \'%' + SearchFields.ServiceQuoteNumber.trim() + '%\' ';
            }

            if (SearchFields.CaseNumber != null && SearchFields.CaseNumber != '') {
                soql += ' AND s.Case__r.CaseNumber like \'%' + SearchFields.CaseNumber.trim() + '%\' ';
            }

            if (SearchFields.Zip != null && SearchFields.Zip != '') {
                soql += ' AND s.Case__r.Order__r.NanaQuote__r.Project__r.Project_Zip_Code__c  like \'%' + SearchFields.Zip.trim() + '%\' ';
            }
            if (SearchFields.state != null && SearchFields.state != '') {
                soql += ' AND s.Case__r.Order__r.NanaQuote__r.Project__r.Project_State__c = \'' + SearchFields.state + '\' ';
            }

            if (SearchFields.ProjectCountry != null && SearchFields.ProjectCountry != '') {
                soql += ' And s.Case__r.Order__r.NanaQuote__r.Project__r.Project_Country__c=\'' + SearchFields.ProjectCountry + '\' ';
            }

            if (SearchFields.City != null && SearchFields.City != '') {
                soql += ' AND s.Case__r.Order__r.NanaQuote__r.Project__r.Project_City__c LIKE \'%' + SearchFields.City.trim() + '%\' ';
            }

            if (SearchFields.ProjectStreet != null && SearchFields.ProjectStreet != '') {
                soql += 'AND s.Case__r.Order__r.NanaQuote__r.Project__r.Project_Street_Address__c LIKE \'%' + SearchFields.ProjectStreet.trim() + '%\' ';
            }

            if (SearchFields.Email != null && SearchFields.Email != '') {
                soql += ' AND s.Case__r.Order__r.Contact__r.Email like \'%' + SearchFields.Email.trim() + '%\' ';

            }

            if (SearchFields.Phone != null && SearchFields.Phone != '') {
                soql += ' AND s.Case__r.Order__r.Contact__r.Phone like \'%' + SearchFields.Phone.trim() + '%\' ';
            }
            if (SearchFields.LastName != null && SearchFields.LastName != '') {
                soql += ' AND s.Case__r.Order__r.Contact__r.LastName like \'%' + SearchFields.LastName.trim() + '%\' ';
            }
            if (SearchFields.FirstName != null && SearchFields.FirstName != '') {
                soql += ' AND s.Case__r.Order__r.Contact__r.FirstName like \'%' + SearchFields.FirstName.trim() + '%\' ';

            }
            if (SearchFields.OrderNumber != null && SearchFields.OrderNumber != '') {
                soql += ' AND s.Case__r.Order__r.OrderNumber = ' + SearchFields.OrderNumber.trim() + ' ';
            }

            soql += ' LIMIT 501 ';

            Sobject[] results = Database.query(soql);
            for (Sobject so: results) {

                Service_Quote__c sq = (Service_Quote__c) so;
                ServiceQuoteSearchResult res = getServiceQuoteSearchResultFromRecord(sq);
                searchResults.add(res);

                QuoteNumbersSeen.add(sq.Case__r.Order__r.NanaQuote__c);

            }

            resultText = results.size() + ' matches found.';
            if (results.size() >= 500) {
                Apexpages.addMessage(new ApexPages.message(apexpages.Severity.INFO, 'A very large amount of records were returned. Only the first 500 will be shown.'));
            }

        }
        
        //Search using Case object
        
        if ((SearchFields.CaseNumber != null && SearchFields.CaseNumber != '') && !(SearchFields.ServiceQuoteNumber != null && SearchFields.ServiceQuoteNumber != '')) {
            searchResults.clear();
            string soql = 'select id, casenumber, Order__r.NanaQuote__c, Order__r.NanaQuote__r.Project__r.Project_Street_Address__c, Order__r.NanaQuote__r.Project__r.Project_City__c, Order__r.NanaQuote__r.Project__r.Project_State__c, Order__r.NanaQuote__r.Project__r.Project_Country__c, Order__r.NanaQuote__r.Project__r.Project_Zip_Code__c, Order__r.Contact__r.Email, Order__r.Contact__r.Phone, Order__r.Contact__r.LastName, Order__r.Contact__r.FirstName, Order__r.OrderNumber, Order__r.NanaQuote__r.Project__c, Order__r.NanaQuote__r.Project__r.Name, order__c, Contact.LastName, Contact.FirstName from case WHERE id!=NULL ';

            if (SearchFields.CaseNumber != null && SearchFields.CaseNumber != '') {
                soql += 'AND CaseNumber like \'%' + SearchFields.CaseNumber.trim() + '%\' ';
            }

            if (SearchFields.Zip != null && SearchFields.Zip != '') {
                soql += ' AND Order__r.NanaQuote__r.Project__r.Project_Zip_Code__c  like \'%' + SearchFields.Zip.trim() + '%\' ';
            }
            if (SearchFields.state != null && SearchFields.state != '') {
                soql += ' AND Order__r.NanaQuote__r.Project__r.Project_State__c = \'' + SearchFields.state + '\' ';
            }

            if (SearchFields.ProjectCountry != null && SearchFields.ProjectCountry != '') {
                soql += ' And Order__r.NanaQuote__r.Project__r.Project_Country__c=\'' + SearchFields.ProjectCountry + '\' ';
            }

            if (SearchFields.City != null && SearchFields.City != '') {
                soql += ' AND Order__r.NanaQuote__r.Project__r.Project_City__c LIKE \'%' + SearchFields.City.trim() + '%\' ';
            }

            if (SearchFields.ProjectStreet != null && SearchFields.ProjectStreet != '') {
                soql += 'AND Order__r.NanaQuote__r.Project__r.Project_Street_Address__c LIKE \'%' + SearchFields.ProjectStreet.trim() + '%\' ';
            }

            if (SearchFields.Email != null && SearchFields.Email != '') {
                soql += ' AND Order__r.Contact__r.Email like \'%' + SearchFields.Email.trim() + '%\' ';

            }

            if (SearchFields.Phone != null && SearchFields.Phone != '') {
                soql += ' AND Order__r.Contact__r.Phone like \'%' + SearchFields.Phone.trim() + '%\' ';
            }
         /*   if (SearchFields.LastName != null && SearchFields.LastName != '') {
                soql += ' AND Order__r.Contact__r.LastName like \'%' + SearchFields.LastName + '%\' ';
            }
            if (SearchFields.FirstName != null && SearchFields.FirstName != '') {
                soql += ' AND Order__r.Contact__r.FirstName like \'%' + SearchFields.FirstName + '%\' ';

            }*/
            if (SearchFields.LastName != null && SearchFields.LastName != '') {
                soql += ' AND Contact.LastName like \'%' + SearchFields.LastName.trim() + '%\' ';
            }
            if (SearchFields.FirstName != null && SearchFields.FirstName != '') {
                soql += ' AND Contact.FirstName like \'%' + SearchFields.FirstName.trim() + '%\' ';

            }

            if (SearchFields.OrderNumber != null && SearchFields.OrderNumber != '') {
                soql += ' AND Order__r.OrderNumber = ' + SearchFields.OrderNumber.trim() + ' ';
            }

            soql += ' LIMIT 501 ';

            Sobject[] results = Database.query(soql);
            for (Sobject so: results) {

                ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();
                case cs = (case) so;
                res.City = cs.Order__r.NanaQuote__r.Project__r.Project_City__c;
                res.State = cs.Order__r.NanaQuote__r.Project__r.Project_State__c;
                res.Zip = cs.Order__r.NanaQuote__r.Project__r.Project_Zip_Code__c;
                res.OrderID = String.valueOf(cs.Order__c);
                res.ProjectID = cs.Order__r.NanaQuote__r.Project__c;
                //res.QuoteID =  cs.Order__r.NanaQuote__c;
                // res.QuoteNumber = String.valueOf(sq.Case__r.Order__r.NanaQuote__r.Name);        
                res.ProjectName = cs.Order__r.NanaQuote__r.Project__r.Name;
                //  res.ProjectAddress = sq.Quote__r.OpportunityAddress__c;
                //res.ContactName = cs.Order__r.Contact__r.FirstName + ' ' + cs.Order__r.Contact__r.LastName;
                res.ContactName = cs.Contact.FirstName + ' ' + cs.Contact.LastName;
                res.ContactEmail = cs.Order__r.Contact__r.Email;
                res.contactId= cs.Contact.id;
                res.ProjectCountry = cs.Order__r.NanaQuote__r.Project__r.Project_Country__c;
                res.ProjectStreet = cs.Order__r.NanaQuote__r.Project__r.Project_Street_Address__c;
                res.Phone = cs.Order__r.Contact__r.Phone;
                res.CaseNumber = cs.CaseNumber;
                res.CaseId = cs.id;
                searchResults.add(res);

                QuoteNumbersSeen.add(cs.Order__r.NanaQuote__c);

            }

            resultText = results.size() + ' matches found.';
            if (results.size() >= 500) {
                Apexpages.addMessage(new ApexPages.message(apexpages.Severity.INFO, 'A very large amount of records were returned. Only the first 500 will be shown.'));
            }

        }
        
        //Search by using contact object
        
        if (SearchResultChecklist.size() < 1 && !(SearchFields.ServiceQuoteNumber != null && SearchFields.ServiceQuoteNumber != '') && !((models != null && models != '') || (SearchFields.Panels_Count != null && SearchFields.Panels_Count != '') || (SearchFields.Panels_Left != null && SearchFields.Panels_Left != '') || (SearchFields.Panels_Right != null && SearchFields.Panels_Right != '')) && !(SearchFields.CaseNumber != null && SearchFields.CaseNumber != '') && ((SearchFields.LastName != null && SearchFields.LastName != '') || (SearchFields.FirstName != null && SearchFields.FirstName != '') || (SearchFields.Phone != null && SearchFields.Phone != '') || (SearchFields.Email != null && SearchFields.Email != ''))) {
            
            string soql = 'select id, FirstName, LastName, email, phone, MailingStreet, MailingCity, Mailingstate, MailingPostalCode, MailingCountry from contact WHERE id!=NULL ';

            if (SearchFields.Email != null && SearchFields.Email != '') {
                soql += ' AND email like \'%' + SearchFields.Email.trim() + '%\' ';

            }
            if (SearchFields.Phone != null && SearchFields.Phone != '') {
                soql += ' AND phone like \'%' + SearchFields.Phone.trim() + '%\' ';
            }
            if (SearchFields.LastName != null && SearchFields.LastName != '') {
                soql += ' AND LastName like \'%' + SearchFields.LastName.trim() + '%\' ';
            }
            if (SearchFields.FirstName != null && SearchFields.FirstName != '') {
                soql += ' AND FirstName like \'%' + SearchFields.FirstName.trim() + '%\' ';

            }

            soql += ' LIMIT 501 ';

            Sobject[] results = Database.query(soql);
            for (Sobject so: results) {

                ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();
                contact con = (contact) so;
                //res.City = cs.Order__r.NanaQuote__r.Project__r.Project_City__c;
                //res.State = cs.Order__r.NanaQuote__r.Project__r.Project_State__c;
                //res.Zip = cs.Order__r.NanaQuote__r.Project__r.Project_Zip_Code__c ;
                //res.OrderID = String.valueOf(cs.Order__c);
                //res.ProjectID = cs.Order__r.NanaQuote__r.Project__c;
                //res.QuoteID =  cs.Order__r.NanaQuote__c;
                // res.QuoteNumber = String.valueOf(sq.Case__r.Order__r.NanaQuote__r.Name);        
                //res.ProjectName = cs.Order__r.NanaQuote__r.Project__r.Name;
                //  res.ProjectAddress = sq.Quote__r.OpportunityAddress__c;
                res.ContactName = con.FirstName + ' ' + con.LastName;
                res.ContactEmail = con.Email;
                res.contactId = con.id;
                //   res.ProjectCountry=cs.Order__r.NanaQuote__r.Project__r.Project_Country__c;
                //res.ProjectStreet=cs.Order__r.NanaQuote__r.Project__r.Project_Street_Address__c;
                res.Phone = con.Phone;
                // res.CaseNumber = cs.CaseNumber;
                //res.CaseId = cs.id;
                searchResults.add(res);

                //QuoteNumbersSeen.add(cs.Order__r.NanaQuote__c);

            }

            resultText = results.size() + ' matches found.';
            if (results.size() >= 500) {
                Apexpages.addMessage(new ApexPages.message(apexpages.Severity.INFO, 'A very large amount of records were returned. Only the first 500 will be shown.'));
            }

        }
        //Search using project object
        if (SearchResultChecklist.size() < 1 && !(SearchFields.ServiceQuoteNumber != null && SearchFields.ServiceQuoteNumber != '') && !((models != null && models != '') || (SearchFields.Panels_Count != null && SearchFields.Panels_Count != '') || (SearchFields.Panels_Left != null && SearchFields.Panels_Left != '') || (SearchFields.Panels_Right != null && SearchFields.Panels_Right != '')) && !(SearchFields.CaseNumber != null && SearchFields.CaseNumber != '') && ((SearchFields.ProjectStreet !=null && SearchFields.ProjectStreet !='') || (SearchFields.City != null && SearchFields.City != '') || (SearchFields.state != null && SearchFields.state != '') || (SearchFields.ProjectCountry != null && SearchFields.ProjectCountry != '') || (SearchFields.Zip != null &&  SearchFields.Zip != '' ))) {
        
            string soql = 'select id, Name, Project_Street_Address__c, Project_City__c, Project_State__c, Project_Country__c, Project_Zip_Code__c from project__c WHERE id!=NULL ';
        
            if ( SearchFields.ProjectCountry != null && SearchFields.ProjectCountry != '') {
          soql += ' And Project_Country__c=\''+SearchFields.ProjectCountry+'\' ';  
           }
           if( SearchFields.City != null && SearchFields.City != '' ) {
          soql += ' AND Project_City__c LIKE \'%'+SearchFields.City.trim()+'%\' ';  
             }
             if( SearchFields.ProjectStreet !=null && SearchFields.ProjectStreet !=''){
          soql += 'AND Project_Street_Address__c LIKE \'%'+SearchFields.ProjectStreet.trim()+'%\' ';
              }
              if (SearchFields.Zip != null &&  SearchFields.Zip != '' ) {
          soql += ' AND Project_Zip_Code__c  like \'%'+SearchFields.Zip.trim()+'%\' ';  
            }
          if( SearchFields.state != null && SearchFields.state != '' ) {
          soql += ' AND Project_State__c = \''+SearchFields.state+'\' ';
            }
            
            soql += ' LIMIT 501 ';

            Sobject[] results = Database.query(soql);
            for (Sobject so: results) {

                ServiceQuoteSearchResult res = new ServiceQuoteSearchResult();
                project__c pro = (project__c) so;
                res.City = pro.Project_City__c;
                res.State = pro.Project_State__c;
                res.Zip = pro.Project_Zip_Code__c ;
                //res.OrderID = String.valueOf(cs.Order__c);
                res.ProjectID = pro.id;
                //res.QuoteID =  cs.Order__r.NanaQuote__c;
                // res.QuoteNumber = String.valueOf(sq.Case__r.Order__r.NanaQuote__r.Name);        
                res.ProjectName = pro.Name;
                //  res.ProjectAddress = sq.Quote__r.OpportunityAddress__c;
                //res.ContactName = con.FirstName + ' ' + con.LastName;
                //res.ContactEmail = con.Email;
                res.ProjectCountry= pro.Project_Country__c;
                res.ProjectStreet= pro.Project_Street_Address__c;
                //res.Phone = con.Phone;
                // res.CaseNumber = cs.CaseNumber;
                //res.CaseId = cs.id;
                searchResults.add(res);
            }
            resultText = results.size() + ' matches found.';
            if (results.size() >= 500) {
                Apexpages.addMessage(new ApexPages.message(apexpages.Severity.INFO, 'A very large amount of records were returned. Only the first 500 will be shown.'));
            }
                
        }

        return null;
    }




    /***
    SearchContainer Wrapper class
    ***/

 @TestVisible   
    class SearchContainer {
        public string ProjectName {
            get;
            set;
        } // quote, opportunity
        public string ProjectAddress {
            get;
            set;
        } // quote, opportunity
        public string ContactName {
            get;
            set;
        }
        public string LastName {
            get;
            set;
        } // quote, opportunity
        public string FirstName {
            get;
            set;
        } // quote, opportunity

        public string Address {
            get;
            set;
        } // quote, opportunity
        public string City {
            get;
            set;
        } // quote, opportunity
        public string ProjectStreet {
            get;
            set;
        } //   quote, opportunity
        public string ProjectCountry {
            get;
            set;
        }
        public string state {
            get;
            set;
        } // quote, opportunity
        public string Zip {
            get;
            set;
        } // quote, opportunity
        public string Phone {
            get;
            set;
        } // quote, opportunity
        public string Email {
            get;
            set;
        } // quote, opportunity
        public string Panels_Left {
            get;
            set;
        } //quote_detail.Configuration__c 
        public string Panels_Right {
            get;
            set;
        } //quote_detail.Configuration__c 
        public string Panels_Count {
            get;
            set;
        } //quote_detail.Configuration__c 

        public string ServiceQuoteNumber {
            get;
            set;
        }
        public string CaseNumber {
            get;
            set;
        }

        public string QuoteNumber {
            get;
            set;
        }
        public string OrderNumber {
            get;
            set;
        }


        public string LoGrandTotal {
            get;
            set;
        }
        public string HiGrandTotal {
            get;
            set;
        }

        public string LoServiceQuoteAmount {
            get;
            set;
        }
        public string HiServiceQuoteAmount {
            get;
            set;
        }

        public Service_Quote__c FirstServiceQuote {
            get;
            set;
        }
        public Service_Quote__c SecondServiceQuote {
            get;
            set;
        }


    }

}