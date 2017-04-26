public with sharing class pp_EmailFlowUtility {
/*
	private static string formatNanaSoapPayload(string xml ) {
	
	return xml;
	}
	private static string buildNanaSoapEnvelope(string xml) {
            string xml2 = '<?xml version=\'1.0\' encoding=\'utf-8\'?>';
            xml2 += '<soap12:Envelope xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:soap12=\'http://www.w3.org/2003/05/soap-envelope\'>';
            xml2 += '<soap12:Body><QuoteEvents  xmlns="http://tempuri.org/">';
            xml2 += xml;
            xml2 += '</QuoteEvents></soap12:Body>';
            xml2 += '</soap12:Envelope>';
		return xml2;
	}
*/
	public class inputValues{
        @InvocableVariable(label='Order ID' required=true)
        public string orderId;
        @InvocableVariable(label='GUIID' required=true)
        public String guiid;
    }

	@InvocableMethod(label='Inform Nana of GUIID' description='Do the call out to Nana indicating that an email GUIID is being generated.')
	public static List<String> tellNana(List<inputValues> inputs ) {
		
		// params -- 
		// [0]	=> Order ID
		// [1] => email type
		// [2] => GUIID

System.debug('pp_EmailFlowUtility: Calling http://'+GlobalStrings.NanaServerAddress()+'/generateemail.aspx' );

		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/generateemail.aspx?orderid='+inputs.get(0).orderId+'&type=test_type&guid='+inputs.get(0).guiid);
		req.setMethod('GET');
	 	req.setHeader('Content-Type', 'text/plain; charset=utf-8');
//	 	req.setHeader('SOAPAction', 'http://tempuri.org/QuoteEvents');		
//		req.setBody('orderid='+inputs.get(0).orderId+'&type=test_type&guid='+inputs.get(0).guiid);		

		Http http = new Http();
		HTTPResponse res = null;
		list<string> response = new list<string>();
		if( !Test.isRunningTest() )
		{
			res = http.send(req); 
			string responseBody = res.getBody();			
			System.debug('pp_EmailFlowUtility: Got a response: ' + responseBody);
			response.add( responseBody );
		}

		
		return response;
	}
	
	@future(callout=true)
	public static void doCallout(string QuoteID, string GUID) 
	{
		HttpRequest req = new HttpRequest();
//		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/generatepdfs.aspx?quoteid='+QuoteID+'&type=cad&guid='+GUID);
		req.setEndpoint('http://'+GlobalStrings.NanaServerAddress()+'/generatepdfs.aspx?quoteid='+QuoteID+'&type=cad_installer&of=true&guid='+GUID);
		req.setMethod('GET');
	 	req.setHeader('Content-Type', 'text/plain; charset=utf-8');

		if(!Test.isRunningTest() )
		{
			Http http = new Http();
			HTTPResponse res = http.send(req); 
				
			string responseBody = res.getBody();			
			system.debug('pp_EmailFlowUtility.doCallout().response = ' + res);
		}
	
	}
	
    //  -------------------------------------------------------------------------
    //  HELPER method: sendTemplatedEmail
    //  -------------------------------------------------------------------------
    public static void sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity, Attachment[] attachList ) {
      //  templateId   must be ID of an Email template
      //  targetObjId must be a Contact, User, Lead Id -- also used in merge fields of template recipient.xxxx
      //  whatId    must be an SObject that is used in the merge fields of the template relatedTo.xxxx  Cannot use UserID's
      //  fromId    if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
      //  bcc      not permitted when using templates
      
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
		Id templateId;  
		try {
			templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;}
		catch (Exception e) {
			if( !Test.isRunningTest() )
			  throw e;
		}
        
        
        email.setToAddresses(toRecipients);
        email.setCcAddresses(ccRecipients);
        email.setTargetObjectId(targetObjId);
        email.setWhatId(whatId);
        email.setorgWideEmailAddressId(orgWideEmailId);
        email.setTemplateId(templateId);
        email.setSaveAsActivity(saveAsActivity);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users
        
        System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, to:' + toRecipients + ' cc:' + ccRecipients +  ' templateId:' + templateId + ' tagetObjId:' + targetObjId + 
                        ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
        try {
        	if( !Test.isRunningTest() )
        	{
	            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
	            return;
        	}
        }
        catch (EmailException e) {throw e;}
      
    }  
	
    
}