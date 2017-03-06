public with sharing class Quote_TinderBox_Button_Controller {


	Quote__c q = null;
	private boolean initd = false;
	public Quote_TinderBox_Button_Controller (ApexPages.StandardController stdController)
	{	
		q = (Quote__c)stdController.getRecord();
		if( !initd )
		{
			Confirmed = false;
			initd = true;
		}
	}

	public boolean showButton 
	{ 
		get { return !(this.q.Printed__c); }
		set; 
	}

	public string DivDisplay
	{
		get {
			if( showButton && !Confirmed )
				return 'block';
			else return 'none'; 
		}
		set;
	}
	
	public string DivDisplay_NotPrinted
	{
		get {
			if( !showButton )
				return 'block';
			else return 'none'; 
		}
		set;
	
	}

	public boolean Confirmed 
	{
		get;
		set;
	}

	public PageReference returntoquote()
	{
		return new PageReference('/' + this.q.Id);
	}

	public PageReference GeneratePDFs()
	{
		string calltype = ApexPages.currentPage().getParameters().get('type');
		
		if( this.q.Printed__c && calltype == 'all')
		{
			return null;
		
		}
		//baseurl + /generatepdfs?quoteid={SFQUOTEID}
		HttpRequest  req = new HttpRequest();   
		HttpResponse response = null;
		Http http = new Http();
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/generatepdfs.aspx?type='+calltype+'&quoteid=' + this.q.Quote_ID__c  );
		req.setMethod('GET') ;
//		req.setBody('='+Encodingutil.base64Encode(blob.valueOf(jsonToSend)) ); //JSON string
		response = http.send(req);
		
		
		
		if( response.getBody() == 'OK')
		{
			Confirmed = true;
			Apexpages.addMessage(  new Apexpages.Message( Apexpages.Severity.Info, 'The PDFs were successfully generated.') );
			return null;
		}
		else
		{
			Apexpages.addMessage(  new Apexpages.Message( Apexpages.Severity.Info, response.getBody()) );
			return null;
		}
		
		
	}
}