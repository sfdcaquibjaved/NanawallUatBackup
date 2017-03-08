public with sharing class Opportunity_UtilityClass {
		private static string formatNanaSoapPayload(string xml ) {
	
		return xml.replaceAll('>', '&gt;').replaceAll('<','&lt;');
	}

	@future (callout= true)
	public static void SetIn2CloudsScore( list<id> ids )
	{
		system.debug('calling in2clouds 2');
		try
		{
			//salesforcegateway.In2Cloud
			//<root><IDs><ID value=""></ID></IDs></root>		
			string xml = '<root><Model Value="2" /><IDs>';
			for( id i : ids )
			{
				xml += '<ID value="'+i+'"></ID>';
			}
			xml += '</IDs></root>';
			string b = '<?xml version=\'1.0\' encoding=\'utf-8\'?>';
			
            b += '<soap12:Envelope xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:soap12=\'http://www.w3.org/2003/05/soap-envelope\'>';
            b += '<soap12:Body><In2Cloud  xmlns="http://tempuri.org/"><xml>';
            b += formatNanaSoapPayload(xml);
            b += '</xml></In2Cloud></soap12:Body>';
            b += '</soap12:Envelope>';
			
		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/webservices/QuoteGateway.asmx');
		req.setMethod('POST'); 
	 	req.setHeader('Content-Type', 'text/xml; charset=utf-8');
	 	req.setHeader('SOAPAction', 'http://tempuri.org/In2Cloud');		
			req.setBody(b);
			
			Http http = new Http();
			HTTPResponse res = http.send(req); 		
		
			System.debug('called in2clouds 2 for: ' + xml );
		} catch(Exception ex )
		{
			system.debug('an exception occurred in in2clouds 2: ' + ex);
		}
	}

	@future (callout= true)
	public static void SetIn2CloudsScore_2d( list<id> ids )
	{
		system.debug('calling in2clouds 2');
		try
		{
			//salesforcegateway.In2Cloud
			//<root><IDs><ID value=""></ID></IDs></root>		
			string xml = '<root><Model Value="2" /><IDs>';
			for( id i : ids )
			{
				xml += '<ID value="'+i+'"></ID>';
			}
			xml += '</IDs></root>';
			string b = '<?xml version=\'1.0\' encoding=\'utf-8\'?>';
			
            b += '<soap12:Envelope xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:soap12=\'http://www.w3.org/2003/05/soap-envelope\'>';
            b += '<soap12:Body><In2Cloud  xmlns="http://tempuri.org/"><xml>';
            b += formatNanaSoapPayload(xml);
            b += '</xml></In2Cloud></soap12:Body>';
            b += '</soap12:Envelope>';
			
		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/webservices/QuoteGateway.asmx');
		req.setMethod('POST'); 
	 	req.setHeader('Content-Type', 'text/xml; charset=utf-8');
	 	req.setHeader('SOAPAction', 'http://tempuri.org/In2Cloud');		
			req.setBody(b);
			
			Http http = new Http();
			HTTPResponse res = http.send(req); 		
		
			System.debug('called in2clouds 2 for: ' + xml );
		} catch(Exception ex )
		{
			system.debug('an exception occurred in in2clouds 2: ' + ex);
		}
	}

	
	@future (callout= true)
	public static void SetIn2CloudsScore_1st( list<id> ids )
	{
		system.debug('calling in2clouds 1');
		try
		{
			//salesforcegateway.In2Cloud
			//<root><IDs><ID value=""></ID></IDs></root>		
			string xml = '<root><Model value="1" /><IDs>';
			for( id i : ids )
			{
				xml += '<ID value="'+i+'"></ID>';
			} 
			xml += '</IDs></root>';

			string b = '<?xml version=\'1.0\' encoding=\'utf-8\'?>';
			
            b += '<soap12:Envelope xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:soap12=\'http://www.w3.org/2003/05/soap-envelope\'>';
            b += '<soap12:Body><In2Cloud  xmlns="http://tempuri.org/"><xml>';
            b += formatNanaSoapPayload(xml);
            b += '</xml></In2Cloud></soap12:Body>';
            b += '</soap12:Envelope>';
			
						
		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/webservices/QuoteGateway.asmx');
		req.setMethod('POST');
	 	req.setHeader('Content-Type', 'text/xml; charset=utf-8');
	 	req.setHeader('SOAPAction', 'http://tempuri.org/In2Cloud');		
			req.setBody(b);
			
			Http http = new Http();
			HTTPResponse res = http.send(req); 		
	
			System.debug('called in2clouds 1 for: ' + xml );
		} catch(Exception ex )
		{
			system.debug('an exception occurred in in2clouds 1: ' + ex);
		}
		
	}	

	
	@future (callout= true)
	public static void SetZestimateAmount( list<id> ids )
	{
		
		list<Opportunity> opps = new list<Opportunity>();
		for( Opportunity o : [SELECT id, ZEstimateAmount__c, Site_Address__c, City__c, State__c FROM opportunity WHERE id in :ids ] )
		{
//			System.debug('checking zestimateamount for ' + o.id);
			try{
				ZillowService p = new ZillowService() ;
				ZillowTypes.PropertySearchResponse r = p.searchZillow( o.Site_Address__c, o.City__c +', ' + o.State__c ) ;
				
				o.ZEstimateAmount__c = r.getZEstimateAmount();		
				opps.add( o );
			} catch(  Exception e){
				System.debug( '**** Caught Exception in Opportunity_UtilityClass.SetZestimateAmount(id): ' +e ) ;
			}
		}
		if( opps.size() > 0  )
		{
			update opps;
		}
	
	}

}