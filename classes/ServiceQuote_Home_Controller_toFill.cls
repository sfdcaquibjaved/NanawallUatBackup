public with sharing class ServiceQuote_Home_Controller_toFill {

    public PageReference dosort() {
        return null;
    }


    public  string searchResults { get; set; }
    
    public ServiceQuote_Home_Controller_toFill(){
       searchResults= ApexPages.currentPage().getParameters().get('searchResults') ;
    }
}