public with sharing class territory_owner_change_controller {

    class searchContainer {

        public string territoryName {
            get;
            set;
        }
        public string tCity {
            get;
            set;
        }
        public string tZipHigh {
            get;
            set;
        }
        public string tZipLow {
            get;
            set;
        }
        public string tCountry {
            get;
            set;
        }
        public string tState {
            get;
            set;
        }
        public string tUser {
            get;
            set;
        }

    }
    public searchContainer searchFields {
        get;
        set;
    }

    class territoryEntry {
        public string ID {
            get;
            set;
        }
    }

    class territorySearchResult {

        public Zip_Codes_Master__c zCode {
            get;
            set;
        }
        public boolean isSelected {
            get;
            set;
        }

        public territorySearchResult(Zip_Codes_Master__c zCode) {
            this.zCode = zCode;
            this.isSelected = false;
        }
    }
    public Zip_Codes_Master__c zipCode {
        get;
        set;
    }
    public Account acc {
        get;
        set;
    }
    public Contact cont {
    get;
    set;
    }
    public boolean displayPopup {
        get;
        set;
    }

    public void closePopup() {
        displayPopup = false;
    }
    public void showPopup() {
       integer counter=0;
       for (territorySearchResult res: searchResults) {
            system.debug('Inside before Check::' + res);
            if (res.isSelected) {
                counter++;
            }
        }
        if(counter>0){
            displayPopup = true;
        } else {
            displayPopup=false;
            resulttext= 'Please select atleast 1 record';
        }
    } 

    public list < territorySearchResult > searchResults {
        get;
        set;
    }

    private boolean initd = false;
    public territory_owner_change_controller() {


        SearchFields = new SearchContainer();
        searchResults = new list < territorySearchResult > ();
        zipCode = new Zip_Codes_Master__c();
        acc = new Account();
        cont = new Contact ();
    }


    public String sortField {
        get;
        set;
    }
    public String previousSortField {
        get;
        set;
    }
    public String sortexp {
        get;
        set;
    }
    public pagereference dosort() {

        return null;
    }
    public string resulttext {
        get;
        set;
    }

    public void SearchObjects() {

        searchResults = new list < territorySearchResult > ();
        List<String> lstZips = new List<String>();
        Id ownID = zipCode.user__c;
        String sCountry = String.valueOf(zipCode.Country__c);
        String sState = String.valueOf(zipCode.State__c);
        system.debug('Check for ID' + sCountry);
        set < id > terr = new Set < id > ();

        Pattern nonWordChar = Pattern.compile('[^0-9\\.]');
        if(SearchFields.tZipLow!=null || SearchFields.tZipLow!='')
        {
            lstZips = SearchFields.tZipLow.split(',');
        }

        if ((SearchFields.territoryName != null && SearchFields.territoryName != '') || (SearchFields.tCity != null && SearchFields.tCity != '') || (zipCode.Country__C != null) || (SearchFields.tZipLow != null && SearchFields.tZipLow != '') || (SearchFields.tZipHigh != null && SearchFields.tZipHigh != '') || (zipCode.User__c != null) || (searchFields.tstate != null && searchFields.tstate != '')) {
            string soql = 'Select s.Name,s.zip_code__c,s.city__c,s.country__c,s.user__c,s.User__r.Name,s.state__c from Zip_Codes_Master__c s  WHERE s.Id != null ';
            if ((SearchFields.territoryName != null && SearchFields.territoryName != ''))
                soql += ' AND s.Name = \'' + SearchFields.territoryName.trim() + '\' ';

            if (SearchFields.tCity != null && SearchFields.tCity != '')
                soql += ' AND s.city__c like \'%' + SearchFields.tcity.trim() + '%\' ';

            if (zipCode.Country__c != null)
                soql += 'AND s.country__c = :sCountry';
            if (zipCode.State__c != null)
                soql += ' AND s.state__c =:sState';
            if (zipCode.User__c != null)
                soql += ' AND s.user__c= :ownID';

            if (SearchFields.tZipLow != null && SearchFields.tZipLow != '') {
                soql += ' AND s.zip_code__c IN :lstZips';
            }

            if (SearchFields.tZipHigh != null && SearchFields.tZipHigh != '') {

                soql += ' AND s.zip_code__c <= ' + searchFields.tZipHigh + ' ';
            }



            soql += ' LIMIT 501 ';
            System.debug('Query is --' + soql);
            system.debug('value is' + ownID);
            for (Zip_Codes_Master__c so: Database.query(soql)) {

                searchResults.add(new territorySearchResult(so));
            }
            resulttext = searchResults.size() + ' matches found.';
        }
    }

    public void updateZipOwner() {
        List < Zip_Codes_Master__c > updateZipList = new List < Zip_Codes_Master__c > ();
        if(zipCode.User__c!= Null){
        for (territorySearchResult res: searchResults) {
            system.debug('Inside before Check::' + res);
            if (res.isSelected) {
                system.debug('Inside' + zipCode.User__c);
                res.zCode.User__c = zipCode.user__c;
                updateZipList.add(res.zCode);
            } 
        }
        }  else {
            apexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a user before changing the owner'));
        }

        if (updateZipList.size() > 0) {
            update updateZipList;
            displayPopUp = false;
            SearchObjects();
        }
    }

}