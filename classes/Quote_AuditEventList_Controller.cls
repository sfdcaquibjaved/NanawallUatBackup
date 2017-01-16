public with sharing class Quote_AuditEventList_Controller {

		//@isTest(SeeAllData=true)
	public static void runtest()
	{
		
		Quote__c q  = [SELECT Id, Quote_ID__c FROM Quote__c LIMIT 1 ];
		
		Quote_AuditEventList_Controller cont = new Quote_AuditEventList_Controller(new ApexPages.StandardController( q) );
		cont.GetEvents();
	}
@testvisible
	private string formatNanaSoapPayload(string xml ) {
	
	return xml;
//		return xml.replaceAll('>', '&gt;').replaceAll('<','&lt;');
	}
	private string buildNanaSoapEnvelope(string xml) {
            string xml2 = '<?xml version=\'1.0\' encoding=\'utf-8\'?>';
            xml2 += '<soap12:Envelotpe xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:soap12=\'http://www.w3.org/2003/05/soap-envelope\'>';
            xml2 += '<soap12:Body><QuoteEvents  xmlns="http://tempuri.org/">';
            xml2 += xml;
            xml2 += '</QuoteEvents></soap12:Body>';
            xml2 += '</soap12:Envelope>';
		return xml2;
	}


	public string jsonEvents { get { if( jsonEvents == null ) {jsonEvents = '';} return jsonEvents; } set; }

	public PageReference GetEvents() 
	{
	
		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/webservices/QuoteGateway.asmx');
		req.setMethod('POST');
	 	req.setHeader('Content-Type', 'text/xml; charset=utf-8');
	 	req.setHeader('SOAPAction', 'http://tempuri.org/QuoteEvents');		

		req.setBody(buildNanaSoapEnvelope( formatNanaSoapPayload('<quoteid>'+q.Quote_ID__c+'</quoteid>" />')));		

		
		Http http = new Http();
		HTTPResponse res = http.send(req); 
			
		string responseBody = res.getBody();			
				
		Pattern p = pattern.compile('(<QuoteEventsResponse(.*?)QuoteEventsResponse>)');
		matcher m = p.matcher(responseBody);
		string parsedXmlResponse = '';
		while( m.find() )
		{
			parsedXmlResponse = responseBody.substring(m.start(), m.end() ).replace('&gt;','>').replace('&lt;','<');
		}
	

//		Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.Info, req.getEndpoint() ) );
		
//		Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.Info, req.getBody() ) );

//		Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.Info, responseBody ) );

//		Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.Info, parsedXmlResponse ) );


		Dom.Document doc = new Dom.Document();
		doc.load( parsedXmlResponse );
		dom.Xmlnode RootNode = doc.getRootElement();
		
		
//		string jsonResponse = RootNode.getChildElement('QuoteEventsResult',null).getText();

		if(RootNode.GetChildElement('QuoteEventsResult','http://tempuri.org/') != null )
			jsonEvents = RootNode.GetChildElement('QuoteEventsResult','http://tempuri.org/').getText();
		else jsonEvents = 'it was null. whats up with that?';



//		Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.Info,  jsonEvents) );


/*
		for(Dom.XMLNode child : RootNode.getChildElements()) {
           System.debug(child.getText());
           Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.Info,  child.getName()) );
           Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.Info,  child.getNamespace() ) );
//           Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.Info,  child.getText()) );
        }
*/
/*
	
		for( dom.XmlNode node : RootNode.GetChildElement('QuoteEventsResult',null).getChildElements() )
		{
			string json = node.getAttribute('Value', null);
	
		}
*/
		return null;
	}


	private final Quote__c q;
	public Quote_AuditEventList_Controller(ApexPages.StandardController stdController) {
		this.q = (Quote__c)stdController.getRecord();

		
	}

}