public with sharing class GetEloquaTasks_Controller {

	private string buildNanaSoapEnvelope(string xml) {
            string xml2 = '<?xml version=\'1.0\' encoding=\'utf-8\'?>';
            xml2 += '<soap12:Envelope xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:soap12=\'http://www.w3.org/2003/05/soap-envelope\'>';
            xml2 += '<soap12:Body><GetEloquaTasks  xmlns="http://tempuri.org/"><ID>';
            xml2 += xml;
            xml2 += '</ID></GetEloquaTasks></soap12:Body>';
            xml2 += '</soap12:Envelope>';
		return xml2;
	}
	private string formatNanaSoapPayload(string xml ) {
	
		return xml.replaceAll('>', '&gt;').replaceAll('<','&lt;');
	}


	public string contactid { get; set; } 

	public string resulttext { get; set; }

	public class EloquaTask 
	{
		public string subject {get; set; }
		public string dateString { get; set; }
	}
	
	public list<EloquaTask> taskList { get; set; }
	
	
	public pagereference gettasks() 
	{
		HttpRequest req = new HttpRequest();
		//http://dr.nanawall.com/SalesforceGateway_20101006.asmx?op=GetEloquaTasks
		//		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/webservices/QuoteGateway.asmx');
		
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/SalesforceGateway_20101006.asmx');
//		req.setEndpoint('http://www.nanareps.com/SalesforceGateway_20101006.asmx');
		req.setMethod('POST');
		req.setTimeout(60000);
	 	req.setHeader('Content-Type', 'text/xml; charset=utf-8');
	 	req.setHeader('SOAPAction', 'http://tempuri.org/GetEloquaTasks');		

//		req.setBody(buildNanaSoapEnvelope( formatNanaSoapPayload('<Root><QuoteID Value="'+q.Quote_ID__c+'" /><UserID Value="'+Userinfo.getUserID()+'" /><Action Value="Initialise" /></Root>')));		
		req.setBody(buildNanaSoapEnvelope( objectId ) );		

		
		Http http = new Http();
		HTTPResponse res = http.send(req); 
			
		string responseBody = res.getBody();			

//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, responseBody ));
//return null;

		Pattern p = pattern.compile('(&lt;Root(.*?)Root&gt;)');
		matcher m = p.matcher(responseBody);
		string parsedXmlResponse = '';
		while( m.find() )
		{
			parsedXmlResponse = responseBody.substring(m.start(), m.end() ).replace('&gt;','>').replace('&lt;','<');
		}
	

/*
  ret = "<Root>" +
           "<Tasks>" +
           "<Task Subject ='Test1' Date='2010-11-01' />" +
           "<Task Subject ='Test2' Date='2010-11-02' />" +
           "<Task Subject ='Test3' Date='2010-11-03' />" +
           "</Tasks>" +
           "</Root>";
*/

		Dom.Document doc = new Dom.Document();
		doc.load( parsedXmlResponse );
		dom.Xmlnode RootNode = doc.getRootElement();
				
		taskList = new List<EloquaTask>();
		for( dom.XmlNode node : RootNode.GetChildElement('Tasks',null).getChildElements() )
		{
			string subject = node.getAttribute('Subject', null);
			string dateString = node.getAttribute('Date', null);
			
			EloquaTask  t = new EloquaTask();
			t.subject = subject;
			t.dateString = dateString;
			
			taskList.add(t);
			
		}

		
		return null;
	}
	
	boolean initd = false;
//	Contact c = null;
//.	Lead l = null;
	string objectId = null;
	public GetEloquaTasks_Controller(ApexPages.StandardController controller) 
	{
		if( !initd )
		{
//			this.c = (Contact)controller.getrecord();
/*	
			for( Contact c : [SElECT Id FROM Contact WHERE Id = :controller.getId()] )
			{
				this.c = (Contact)controller.getRecord();
				break;
			}
			if( this.c == null )
				this.l = (Lead)controller.getRecord();
*/
			objectId = controller.getId();			
			taskList = new list<EloquaTask>();
			initd = true;
		}
	}
}