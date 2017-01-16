global class CaseIntegrate {
    global list < case >caseList {
            get;
            set;
        }

    global list < Service_Quote__c > QuoteList {
        get;
        set;
    }

    global string searchstring {
        get;
        set;
    }

    global string searchEmail {
        get;
        set;
    }

    global string searchEmail1 {
        get;
        set;
    }

    global string searchServiceQuote {
        get;
        set;
    }
    
    global string searchShopifyQuote {
        get;
        set;
    }

    global boolean flag {
        get;
        set;
    }

    global boolean flag1 {
        get;
        set;
    }
    
    global boolean Shopifyflag {
        get;
        set;
    }

    global CaseIntegrate() {
        flag = false;
        flag1 = false;
        Shopifyflag = false;
    }
    
    global void search() {
        flag = true;
        if(string.isNotBlank(searchEmail) && (string.isNotBlank(searchstring))) {
        string searchquery = 'select CaseNumber,id,Status,Email__c from case where Status!=null AND Email__c=:searchEmail AND CaseNumber=:searchstring';
        if (string.isNotBlank(searchEmail))
            searchquery += ' and Email__c LIKE \'%' + searchEmail + '%\' ';
        if (string.isNotBlank(searchstring))
            searchquery += ' and CaseNumber LIKE \'%' + searchstring + '%\' ';
        caseList = Database.query(searchquery);
        system.debug('###########' + caseList);
        }
        else{
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            ApexPages.addMessage(myMsg1);
        }

    }

    global void search1() {
        
        if((searchServiceQuote.length()>2) && (string.isNotBlank(searchEmail1)) ){
        string searchquery1 = 'select id,name,Status__c,Shopify_Order_NO__c,Send_Quote_To_Email__c from Service_Quote__c where status__c !=null AND Send_Quote_To_Email__c=:searchEmail1';
        if (string.isNotBlank(searchEmail1)){
            searchquery1 += ' and Send_Quote_To_Email__c LIKE \'%' + searchEmail1 + '%\' ';
        }
        if(searchServiceQuote.length()>2){
        searchShopifyQuote = searchServiceQuote.substring(0,2);
        
        if(searchShopifyQuote=='SQ'){
        
        if (string.isNotBlank(searchServiceQuote)){
            searchquery1 += ' and name LIKE \'%' + searchServiceQuote + '%\' ';
            }
        }
        if(searchShopifyQuote=='OL'){
        Shopifyflag = true;
        if (string.isNotBlank(searchShopifyQuote)){
            searchquery1 += ' and Shopify_Order_NO__c LIKE \'%' + searchServiceQuote + '%\' ';
            }
        }
        }        
        QuoteList = Database.query(searchquery1);
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            ApexPages.addMessage(myMsg);
        }
        system.debug('###########QuoteList' + QuoteList);
    flag1 = true;
    }

}