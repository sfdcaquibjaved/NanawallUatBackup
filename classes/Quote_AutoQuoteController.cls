public class Quote_AutoQuoteController {

	string ExplanationOfChoices='';
	public string getExplanationOfChoices(){ return ExplanationOfChoices; }
	public void setExplanationOfChoices(string val){  ExplanationOfChoices = val; }

	boolean AutoQuoteViewEnabled=false;
	public boolean getAutoQuoteViewEnabled(){ return AutoQuoteViewEnabled; }
	public void setAutoQuoteViewEnabled(boolean val){  AutoQuoteViewEnabled = val; }
	
	boolean AutoQuoteEmailRepEnabled=false;
	public boolean getAutoQuoteEmailRepEnabled(){ return AutoQuoteEmailRepEnabled; }
	public void setAutoQuoteEmailRepEnabled(boolean val){  AutoQuoteEmailRepEnabled = val; }
	
	boolean AutoQuoteEmailLeadEnabled=false;
	public boolean getAutoQuoteEmailLeadEnabled(){ return AutoQuoteEmailLeadEnabled; }
	public void setAutoQuoteEmailLeadEnabled(boolean val){  AutoQuoteEmailLeadEnabled = val; }
	
	boolean AutoQuoteEmailSaveTipsEnabled=false;
	public boolean getAutoQuoteEmailSaveTipsEnabled(){ return AutoQuoteEmailSaveTipsEnabled; }
	public void setAutoQuoteEmailSaveTipsEnabled(boolean val){  AutoQuoteEmailSaveTipsEnabled = val; }
	
	boolean AutoQuoteEmailRepCADEnabled=false;
	public boolean getAutoQuoteEmailRepCADEnabled(){ return AutoQuoteEmailRepCADEnabled; }
	public void setAutoQuoteEmailRepCADEnabled(boolean val){  AutoQuoteEmailRepCADEnabled = val; }
	
	boolean AutoQuoteEmailLeadCADEnabled=false;
	public boolean getAutoQuoteEmailLeadCADEnabled(){ return AutoQuoteEmailLeadCADEnabled; }
	public void setAutoQuoteEmailLeadCADEnabled(boolean val){  AutoQuoteEmailLeadCADEnabled = val; }

	boolean AutoQuoteEmailInstallerEnabled=false;
	public boolean getAutoQuoteEmailInstallerEnabled(){ return AutoQuoteEmailInstallerEnabled; }
	public void setAutoQuoteEmailInstallerEnabled(boolean val){ AutoQuoteEmailInstallerEnabled = val; }


	boolean AutoQuoteView=false;
	public boolean getAutoQuoteView(){ return AutoQuoteView; }
	public void setAutoQuoteView(boolean val){  AutoQuoteView = val; }
	
	boolean AutoQuoteEmailRep=false;
	public boolean getAutoQuoteEmailRep(){ return AutoQuoteEmailRep; }
	public void setAutoQuoteEmailRep(boolean val){  AutoQuoteEmailRep = val; }
	
	boolean AutoQuoteEmailLead=false;
	public boolean getAutoQuoteEmailLead(){ return AutoQuoteEmailLead; }
	public void setAutoQuoteEmailLead(boolean val){  AutoQuoteEmailLead = val; }
	
	boolean AutoQuoteEmailSaveTips=false;
	public boolean getAutoQuoteEmailSaveTips(){ return AutoQuoteEmailSaveTips; }
	public void setAutoQuoteEmailSaveTips(boolean val){  AutoQuoteEmailSaveTips = val; }
	
	boolean AutoQuoteEmailRepCAD=false;
	public boolean getAutoQuoteEmailRepCAD(){ return AutoQuoteEmailRepCAD; }
	public void setAutoQuoteEmailRepCAD(boolean val){  AutoQuoteEmailRepCAD = val; }
	
	boolean AutoQuoteEmailLeadCAD=false;
	public boolean getAutoQuoteEmailLeadCAD(){ return AutoQuoteEmailLeadCAD; }
	public void setAutoQuoteEmailLeadCAD(boolean val){  AutoQuoteEmailLeadCAD = val; }
	
	boolean AutoQuoteEmailInstaller=false;
	public boolean getAutoQuoteEmailInstaller(){ return AutoQuoteEmailInstaller; }
	public void setAutoQuoteEmailInstaller(boolean val){  AutoQuoteEmailInstaller = val; }
	
	

    public Quote__c getQuote() { 
    
        return q;
    }
    
    private boolean initd = false;
    public PageReference init() {
    
		if( !initd) 
		{
			AutoClose = false;
			LoadInitialState();
			initd = true;
//			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'init data loaded' ));
		}
    	return null;
    }
    
    private quote__c q;
    public Quote_AutoQuoteController() {
//        q = (Quote__c)stdController.getRecord();

		q = [SELECT id,Quote_ID__c, Contact__r.FirstName, Contact__r.LastName FROM Quote__c where id = :Apexpages.currentPage().getParameters().get('QuoteID')   ];
		
    }
    
    public string FakeCommitResponse() {
    	return '<Root><CommitStatus Value="OK" Message="any status message needed" /></Root>';
    }
    
    
    
    public string FakeXmlInitResponse() {
    	string fakeResponse = '<Root>';
		fakeResponse += '			<Messages>';
		fakeResponse += '				<Message Type="Info" Value="xyz  does not have a valid email address.  Email disabled." />';
		fakeResponse += '				<Message Type="Error" Value="Email status message" />';
		fakeResponse += '				<Message Type="Error" Value="lblAutoQuotePriceErrors thing" />';
		fakeResponse += '				<Message Type="Error" Value="lblSubChoiceErrors thing" />';
		fakeResponse += '				<Message Type="Error" Value="lblConfigErrors thing" />';
		fakeResponse += '			</Messages>';
	
		fakeResponse += '			<AutoQuoteView Enabled="True" HoverText="sample hover text" Selected="False" />';
		fakeResponse += '			<AutoQuoteEmailRep Enabled="True" HoverText="sample hover text" Selected="False"  />';
		fakeResponse += '			<AutoQuoteEmailLead Enabled="True" HoverText="sample hover text"  Selected="False" />';
		fakeResponse += '			<AutoQuoteEmailSaveTips Enabled="True" HoverText="sample hover text"  Selected="False" />';
		fakeResponse += '			<AutoQuoteEmailRepCAD Enabled="True" HoverText="sample hover text"  Selected="False" />';
		fakeResponse += '			<AutoQuoteEmailLeadCAD Enabled="True" HoverText="sample hover text"  Selected="False" />';
		fakeResponse += '			<AutoQuoteEmailInstaller Enabled="True" HoverText="sample hover text"  Selected="False" />';
//AutoQuoteEmailInstaller
		fakeResponse += '			<ExplanationOfChoices>Explanation text for this node</ExplanationOfChoices>';

		fakeResponse += '			<OKAutoQuote Value="True" />';
			
		fakeResponse += '	</Root>';
    
    	return fakeResponse;
    }
    
    string messages = '';
    public string getmessages(){ return messages; }
    
    
	private string formatNanaSoapPayload(string xml ) {
	
		return xml.replaceAll('>', '&gt;').replaceAll('<','&lt;');
	}
	public boolean AutoClose { get; set; }
	private string buildNanaSoapEnvelope(string xml) {
            string xml2 = '<?xml version=\'1.0\' encoding=\'utf-8\'?>';
            xml2 += '<soap12:Envelope xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:soap12=\'http://www.w3.org/2003/05/soap-envelope\'>';
            xml2 += '<soap12:Body><TriggerAutoQuote  xmlns="http://tempuri.org/"><xml>';
            xml2 += xml;
            xml2 += '</xml></TriggerAutoQuote></soap12:Body>';
            xml2 += '</soap12:Envelope>';
		return xml2;
	}
    
	private void LoadInitialState() {
		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/webservices/QuoteGateway.asmx');
		req.setMethod('POST');
	 	req.setHeader('Content-Type', 'text/xml; charset=utf-8');
	 	req.setHeader('SOAPAction', 'http://tempuri.org/TriggerAutoQuote');		

		req.setBody(buildNanaSoapEnvelope( formatNanaSoapPayload('<Root><QuoteID Value="'+q.Quote_ID__c+'" /><UserID Value="'+Userinfo.getUserID()+'" /><Action Value="Initialise" /></Root>')));		

		
		Http http = new Http();
		HTTPResponse res = http.send(req); 
			
		string responseBody = res.getBody();			
		
//ApexPages.addMessage(new ApexPages.message(  ApexPages.severity.INFO, responseBody ) );
//return;
		
		Pattern p = pattern.compile('(&lt;Root(.*?)Root&gt;)');
		matcher m = p.matcher(responseBody);
		string parsedXmlResponse = '';
		while( m.find() )
		{
			parsedXmlResponse = responseBody.substring(m.start(), m.end() ).replace('&gt;','>').replace('&lt;','<');
		}
	

		Dom.Document doc = new Dom.Document();
		doc.load( parsedXmlResponse );
		dom.Xmlnode RootNode = doc.getRootElement();
				
		for( dom.XmlNode node : RootNode.GetChildElement('Messages',null).getChildElements() )
		{
			string Message = node.getAttribute('Value', null);
			string MessageType = node.getAttribute('Type', null);
	
			messages += ('<div style="margin: 5px ;clear:both; '+(MessageType == 'Error' ? 'color: red' : ' color: blue' )+'">'+Message+'</div>');			
		}

		
		AutoQuoteViewEnabled = ( RootNode.getChildElement('AutoQuoteView',null).getAttribute('Enabled',null) == 'True'   );
		AutoQuoteEmailRepEnabled = ( RootNode.getChildElement('AutoQuoteEmailRep',null).getAttribute('Enabled',null) == 'True'   );
		AutoQuoteEmailLeadEnabled = ( RootNode.getChildElement('AutoQuoteEmailLead',null).getAttribute('Enabled',null) == 'True'   );
		AutoQuoteEmailSaveTipsEnabled = ( RootNode.getChildElement('AutoQuoteEmailSaveTips',null).getAttribute('Enabled',null) == 'True'   );
		AutoQuoteEmailRepCADEnabled = ( RootNode.getChildElement('AutoQuoteEmailRepCAD',null).getAttribute('Enabled',null) == 'True'   );
		AutoQuoteEmailLeadCADEnabled = ( RootNode.getChildElement('AutoQuoteEmailLeadCAD',null).getAttribute('Enabled',null) == 'True'   );
		AutoQuoteEmailInstallerEnabled = ( RootNode.getChildElement('AutoQuoteEmailInstaller',null).getAttribute('Enabled',null) == 'True'   );
		
		ExplanationOfChoices = RootNode.getChildElement('ExplanationOfChoices',null).getText();
	
	}
    
    public PageReference TriggerAutoQuote() {
    	
		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/webservices/QuoteGateway.asmx');
		req.setMethod('POST');
	 	req.setHeader('Content-Type', 'text/xml; charset=utf-8');
	 	req.setHeader('SOAPAction', 'http://tempuri.org/TriggerAutoQuote');		

		string b = '';
		b += '<Root>\n';
		b += '		<QuoteID Value="'+q.Quote_ID__c+'" /><UserID Value="'+Userinfo.getUserID()+'" /><Action Value="Commit" />\n';
		b += '		<AutoQuoteView Selected="'+(AutoQuoteView ? 'True' : 'False' )+'" />\n';
		b += '		<AutoQuoteEmailRep Selected="'+(AutoQuoteEmailRep ? 'True' : 'False' )+'" />\n';
		b += '		<AutoQuoteEmailLead Selected="'+(AutoQuoteEmailLead ? 'True' : 'False' )+'" />\n';
		b += '		<AutoQuoteEmailSaveTips Selected="'+(AutoQuoteEmailSaveTips ? 'True' : 'False' )+'" />\n';
		b += '		<AutoQuoteEmailRepCAD Selected="'+(AutoQuoteEmailRepCAD ? 'True' : 'False' )+'" />\n';
		b += '		<AutoQuoteEmailLeadCAD Selected="'+(AutoQuoteEmailLeadCAD ? 'True' : 'False' )+'" />\n';
		b += '		<AutoQuoteEmailInstaller Selected="'+(AutoQuoteEmailInstaller ? 'True' : 'False' )+'" />\n';
		b += '</Root>';
		
		
		req.setBody(buildNanaSoapEnvelope( formatNanaSoapPayload(b) ));		
		
		Http http = new Http();
		HTTPResponse res = http.send(req); 
			
		string responseBody = res.getBody();		
//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'response: ' + responseBody ) );
//return null;
/*
		//extract the XML response 
		XmlStreamReader reader = new XmlStreamReader(responseBody);
		string xmlResponse = '';
		while(reader.hasNext()) 
		{
			if (reader.getEventType() == XmlTag.START_ELEMENT
				&& reader.getLocalName() == 'Root' ) 
			{
				//walk over the subsequent CHARACTERS to collect the response
				while( ( reader.next() != null ) && reader.getEventType() == XmlTag.CHARACTERS )
				{
					xmlResponse += reader.getText();
				}
				xmlResponse = EncodingUtil.urlDecode(xmlResponse, 'UTF-8');
				break;
			} 
			
			reader.next();
		}
		*/
		Pattern p = pattern.compile('(&lt;AutoQuoteResponse(.*?)AutoQuoteResponse&gt;)');
		matcher m = p.matcher(responseBody);
		string parsedXmlResponse = '';
		while( m.find() )
		{
			parsedXmlResponse = responseBody.substring(m.start(), m.end() ).replace('&gt;','>').replace('&lt;','<');
		}
		
		if( parsedXmlResponse == '' )
		{
			 p = pattern.compile('(&lt;AutoQuoteResponse(.*?)/&gt;)');
			 m = p.matcher(responseBody);
			 parsedXmlResponse = '';
			while( m.find() )
			{
				parsedXmlResponse = responseBody.substring(m.start(), m.end() ).replace('&gt;','>').replace('&lt;','<');
			}
			
		}
//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'extracted: ' + parsedXmlResponse ) );
//return null;	 
		
		Dom.Document doc = new Dom.Document();
		doc.load( parsedXmlResponse );
		dom.Xmlnode RootNode = doc.getRootElement();
		
//		string Status = RootNode.getChildElement('Status', null).getAttribute( 'Value', null);
		string Status = RootNode.getAttribute( 'Status', null);
		
		if( Status == 'Error' )
		{
			for( dom.XmlNode node : RootNode.getChildElements() )
			{
				string Message = node.getAttribute('Value', null);
		
				messages += ('<div style="margin: 5px ; color: red">'+Message+'</div>');			
			}
			
		} else
		{	
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'AutoQuote was successful.' ) );
			
//			AutoClose = true;
		
		}
		
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Status: ' + Status ) );
	

    	return null;
    }

}