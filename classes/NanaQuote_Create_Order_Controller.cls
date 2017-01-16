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
    
    public void fixOrderClone()
    {
    		//update the order with the old quote fields
			Quote thisq = null;
			System.debug('@@@@@@@'+this.thisQuote.Id);
			for( Quote q : [SELECT Id, Ordered__c, Order__c,  Nana_Quote__r.Order__c, Dupe_Order__c,Shipping_Address_2__c,Shipping_Address__c,Shipping_City__c,Shipping_Country__c,Shipping_State__c,Shipping_Zip__c  FROM Quote WHERE Nana_Quote__c = :this.thisQuote.Id] )
			{
				thisq = q;
				system.debug('@@@@@@@@'+thisq);
				break; 
			}
			Order thiso = null;
			system.debug('@@@@@@@@'+this.thisQuote.Id);
			for ( Order o :  [SELECT Id,notes__c,ShippingCity,ShippingCountryCode,ShippingPostalCode,ShippingStateCode,ShippingStreet, Name, Status,Order_Confirmation_Started__c, Invoices_Sent_Date__c, Balance_Received_Date__c, Complete_Signoff_Date__c, Deposit_Date__c, Deposit_Received_Date__c, Order_Finalized_Date__c FROM Order WHERE NanaQuote__c = :this.thisQuote.Id] )
			{
			    thiso = o;
			    system.debug('@@@@@@@@@'+thiso);
			    break;
			} 
system.debug('** ConvertOrder: Dupe_Order__c = ' + thisq.Dupe_Order__c);        	
	        if(thisq.Dupe_Order__c != null )
			{
	        	Order oldOrder = [SELECT Id, Name,notes__c, Order_Confirmation_Started__c, Invoices_Sent_Date__c, Balance_Received_Date__c, Complete_Signoff_Date__c,Deposit_Date__c, Deposit_Received_Date__c, Order_Finalized_Date__c FROM Order WHERE Id = :thisq.Dupe_Order__c];
	        	
	        	thiso.Name = oldOrder.Name;
				thiso.Order_Confirmation_Started__c = oldOrder.Order_Confirmation_Started__c;
				thiso.Invoices_Sent_Date__c = oldOrder.Invoices_Sent_Date__c;
				thiso.Balance_Received_Date__c = oldOrder.Balance_Received_Date__c;
				thiso.Complete_Signoff_Date__c = oldOrder.Complete_Signoff_Date__c;
				thiso.Deposit_Date__c = oldOrder.Deposit_Date__c;
				thiso.Deposit_Received_Date__c = oldOrder.Deposit_Received_Date__c;
				thiso.Order_Finalized_Date__c = oldOrder.Order_Finalized_Date__c;
				

				thiso.ShippingStreet = (thisq.Shipping_Address__c != null? thisq.Shipping_Address__c : '') + (thisq.Shipping_Address_2__c != null ? '\n'+thisq.Shipping_Address_2__c : '' );
				thiso.ShippingCity = thisq.Shipping_City__c;
				thiso.ShippingCountryCode = ( thisq.Shipping_Country__c == null || thisq.Shipping_Country__c == 'US' || thisq.Shipping_Country__c == 'USA' || thisq.Shipping_Country__c == 'United States' || thisq.Shipping_Country__c == 'UNITED STATES' || thisq.Shipping_Country__c == 'united states' ? 'US' : 'CA' );
				thiso.ShippingPostalCode = thisq.Shipping_Zip__c;
				thiso.ShippingStateCode = thisq.Shipping_State__c;
				
				thiso.notes__c = oldOrder.notes__c;
				
				
				

system.debug('** ConvertOrder: updating order; Invoices Sent Date = ' + oldOrder.Invoices_Sent_Date__c);        	

				update thiso;			   
				
				
	        	oldOrder.Status = 'Cancelled';
	        	oldOrder.Name = '0';
				update oldOrder;				
        	}
        	
    
    }
    
    
    public PageReference CreateOrder()
    {

        Map<string,string> uparams = ApexPages.currentPage().getParameters();        
        if( uparams.get('flushCache') != null && uparams.get('flushCache') == 'true') 
        {
        	System.debug('** ConvertOrder: fixing up the Cloned Order');
        	fixOrderClone();
        }



        Quote thisq = null;
        System.debug('@@@@@@@'+this.thisQuote.Id);
        for( Quote q : [SELECT Id, Ordered__c, Order__c,  Nana_Quote__r.Order__c, Dupe_Order__c FROM Quote WHERE Nana_Quote__c = :this.thisQuote.Id] )
        {
            thisq = q;
            system.debug('@@@@@@@@'+thisq);
            break; 
        }
//         System.debug('@@@@@@@@@'+thisq.Nana_Quote__r);

         if( thisq.Nana_Quote__r == null )
         {
            Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.ERROR, 'The SFDC Quote and the Nana Quote do not appear to be linked. Please alert tech support with this quote number. ( '+thisq.Id+' / '+this.thisQuote.Id+')' ) );
            return null;
         
         }
         
         System.debug('@@@@@@@'+thisq.Nana_Quote__r.Order__c );
        if( thisq.Nana_Quote__r.Order__c  != null && !doTest ) 
        {
                     

            existingOrder = thisq.Nana_Quote__r.Order__c;
            Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.INFO, 'Redirecting to  order ...' ) );
             System.debug('@@@@@@@'+ 'Redirecting to  order ...');
            
            return null;
        }
        
        Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.INFO, 'creating order for quote...'+this.thisQuote.Quote_ID__c ) );
        Map<String, Object> params = new Map<String, Object>();
        params.put('QuoteID', thisq.Id);        
        Flow.Interview.Quote_to_Order convertFlow = new Flow.Interview.Quote_to_Order(params);
        convertFlow.start();
        
        Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.INFO, 'created.' ) );


  
        Order thiso = null;
        system.debug('@@@@@@@@'+this.thisQuote.Id);
        for ( Order o :  [SELECT Id, Status,Order_Confirmation_Started__c, Invoices_Sent_Date__c, Balance_Received_Date__c, Complete_Signoff_Date__c, Deposit_Date__c, Deposit_Received_Date__c, Order_Finalized_Date__c FROM Order WHERE NanaQuote__c = :this.thisQuote.Id] )
        {
            thiso = o;
            system.debug('@@@@@@@@@'+thiso);
            break;
        } 

        
        
 
		thisorder = thiso;
		thisorder.Status = 'Order Created';
		update thisorder;


        
        // 
        thisq.Ordered__c = true;
        thisq.Order_Created__c = true;
        thisq.Order_Generated__c = true;         

        update thisq;

		Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.INFO, ' SELECT Id FROM Order WHERE NanaQuote__c = :'+this.thisQuote.Id  ) );

		

        if( thiso != null ) 
        {			
//        	return new PageReference('/' + thiso.Id );    
            PageReference pg = new PageReference('/apex/NanaQuote_Create_Order?scontrolCaching=1&id='+this.thisQuote.Id + '&flushCache=true' );
            return pg;

        }        
        else {
            PageReference pg = new PageReference('/apex/NanaQuote_Create_Order?scontrolCaching=1&id='+this.thisQuote.Id);
            system.debug('Page Ref -- '+pg );
            return pg;
            }
        
        
        
        ///apex/NanaQuote_Create_Order?scontrolCaching=1&id=a0A3B0000006esl

//return null;
    }
}