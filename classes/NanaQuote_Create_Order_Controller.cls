public with sharing class NanaQuote_Create_Order_Controller {
    
    protected Quote__c thisQuote = null;
    public Order thisOrder = null;
    public NanaQuote_Create_Order_Controller(ApexPages.StandardController stdController) 
    {
        this.thisQuote = (Quote__c)stdController.getRecord();
        
        
        Map<string,string> params = ApexPages.currentPage().getParameters();        
        if( params.get('flushCache') != null && params.get('flushCache') == 'true')
        {
        
            System.debug('flushing the cache ...');
            //tell nana to flush the cache 
            HttpRequest  req = new HttpRequest();   
            HttpResponse response = null;
            Http http = new Http();
            req.setEndpoint('http://www.nanareps.com/refreshorder.aspx?quoteid=' +  this.thisQuote.Id );
            req.setMethod('GET') ;
            response = http.send(req);
        
        }
    
    }
    
    
     
    public Id existingOrder { get; set; }
    
    public boolean doTest { get{ if( doTest == null) {doTest = false;} return doTest; } set; }
    
    public PageReference CreateOrder()
    {


        Quote thisq = null;
        for( Quote q : [SELECT Id, Ordered__c, Order__c,  Nana_Quote__r.Order__c, Dupe_Order__c, Opportunity.AccountId FROM Quote WHERE Nana_Quote__c = :this.thisQuote.Id] )
        {
            thisq = q; 
            break; 
        }

         if( thisq.Nana_Quote__r == null )
         {
            Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.ERROR, 'The SFDC Quote and the Nana Quote do not appear to be linked. Please alert tech support with this quote number. ( '+thisq.Id+' / '+this.thisQuote.Id+')' ) );
            return null;
         
         }
         
        if( thisq.Nana_Quote__r.Order__c  != null && !doTest ) 
        {
            existingOrder = thisq.Nana_Quote__r.Order__c;
            Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.INFO, 'Redirecting to  order ...' ) );
             System.debug('@@@@@@@'+ 'Redirecting to  order ...');
            
            return null;
        }
        
        Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.INFO, 'creating order for quote...'+this.thisQuote.Quote_ID__c ) );
                
        Order thiso = new Order();
        thiso.QuoteId = thisq.Id;
        thiso.NanaQuote__c = this.thisQuote.Id;
        insert thiso;
        
        //we need to activate the order separately because the triggers wont allow you to activate the order during insert
        thiso.Status = 'Order Created';
        update thiso;
        
        Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.INFO, 'created.' ) );
   System.debug('**ASTECH NanaQuote_CreateOrderController 1: Total SOQL Queries: ' + Limits.getQueries() );


        if( thiso != null ) 
        {           
            PageReference pg = new PageReference('/apex/NanaQuote_Create_Order?scontrolCaching=1&id='+this.thisQuote.Id + '&flushCache=true' );
            return pg;

        }        
        else {
            PageReference pg = new PageReference('/apex/NanaQuote_Create_Order?scontrolCaching=1&id='+this.thisQuote.Id);
            system.debug('Page Ref -- '+pg );
            return pg;
            }
        
    }
}