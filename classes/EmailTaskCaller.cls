global class EmailTaskCaller {
	
	private static string randChar() { 
		
		integer i = ( math.random()*9 ).intValue();		
		if( i < 1 ) i = 1;
		else if( i > 9) i = 9;
		
		return string.valueOf(i);
	}

	WebService static boolean TriggerQuoteEmailWorkflow( string SalesforceQuoteID,  string GUUID_Quote, string GUUID_CAD) {
		
		//2. save the GUIDs
		/*
		Quote__c q = [SELECT id,Followup_Status__c,Print_Date__c,GUUID_CAD__c, GUUID_Quote__c, Opportunity__c  FROM Quote__c WHERE id = :SalesforceQuoteID ];
		q.Followup_Status__c ='Reviewing';
		q.Print_Date__c = DateTime.now();
		q.GUUID_CAD__c = GUUID_CAD;
		q.GUUID_Quote__c = GUUID_Quote;
		update q;


		//to put in workflow
		Opportunity o = [SELECT Id, Customer_Emailed__c FROM Opportunity WHERE Id = :q.Opportunity__c];
		o.Customer_Emailed__c = true;
		update o;
		*/

		return true;
	}

	WebService static boolean SendQuoteEmail4( string SalesforceQuoteID, integer PDFHistoryID,integer CADHistoryID, string ModelDescription, string ShowroomInfo, string NDGLink_OverrideURL, boolean SendToCustomer, boolean SendToRep ) {
	

		Quote__c q = [SELECT id, Responsible_Rep__c, Cleaned_Discount__c, Cleaned_Quote_ID__c, Discount__c, Responsible_Rep__r.Email, Opportunity__r.Owner.Email, Opportunity__c, Contact__c,ContactName__c,Quote_ID__c,OpportunityName__c, Calculated_Email__c,  (SELECT id, Model__c FROM Quote_Details__r) FROM Quote__c WHERE id = :SalesforceQuoteID ];
				//need a workflow action when you print a quote, this method could be refactored
		q.Followup_Status__c ='Reviewing';
		q.Print_Date__c = DateTime.now();

		q.NanaPDFID__c = (double)PDFHistoryID;
		update q;


		Opportunity o = [SELECT Id, Customer_Emailed__c FROM Opportunity WHERE Id = :q.Opportunity__c];
		o.Customer_Emailed__c = true;
		update o;

		//when this is all working we need to hook the contact's email to the SEND, not my email - ks	
		Contact c = [SELECT id, Email, OwnerID FROM Contact WHERE id = :q.Contact__c ];

		User u = [SELECT Email, FirstName, LastName, OrgWideEmailAddressID__c,Email2__c,Email3__c,Email4__c FROM user WHERE id = :c.OwnerId];
		EmailTemplate template;
		EmailTemplate template_rep;
		try 
		{
//			if( SendToRep ) 
			{
				template_rep = [SELECT Body, HtmlValue, id, Subject FROM EmailTemplate WHERE DeveloperName = :GlobalStrings.RepQuoteEmailTemplateName() ];			
			} 
//			if(SendToCustomer )
			{
				template = [SELECT Body, HtmlValue, id, Subject FROM EmailTemplate WHERE DeveloperName = :GlobalStrings.QuoteEmailTemplateName() ];
			}
			
		} catch (Exception ex ) {
			template = new EmailTemplate();
			template.HtmlValue = '';
			template.Subject = '';
			
			template_rep = new EmailTemplate();
			template_rep.HtmlValue = '';
			template_rep.Subject = '';
			
			//this should not happen at all		
		}
		string HTMLBody = template.HtmlValue;
		string Subject = template.Subject;
		string PlainTextBody = ( template.Body == null ? ' ' : template.Body );

		string HTMLBody_rep = template_rep.HtmlValue;
		string Subject_rep = template_rep.Subject;
		string PlainTextBody_rep = ( template_rep.Body == null ? ' ' : template_rep.Body );

	
	
		// replace Cleaned_Discount__c, ,
		HTMLBody = HTMLBody.replace( '{!Quote__c.Cleaned_Discount__c}',string.valueof(q.Cleaned_Discount__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Cleaned_Discount__c}',string.valueof(q.Cleaned_Discount__c) );
		Subject = Subject.replace('{!Quote__c.Cleaned_Discount__c}',string.valueof(q.Cleaned_Discount__c) );
		
		HTMLBody_rep = HTMLBody_rep.replace( '{!Quote__c.Cleaned_Discount__c}',string.valueof(q.Cleaned_Discount__c) );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote__c.Cleaned_Discount__c}',string.valueof(q.Cleaned_Discount__c) );
		Subject_rep = Subject_rep.replace('{!Quote__c.Cleaned_Discount__c}',string.valueof(q.Cleaned_Discount__c) );
		
		// replace Cleaned_Quote_ID__c, ,
		HTMLBody = HTMLBody.replace( '{!Quote__c.Cleaned_Quote_ID__c}',string.valueof(q.Cleaned_Quote_ID__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Cleaned_Quote_ID__c}',string.valueof(q.Cleaned_Quote_ID__c) );
		Subject = Subject.replace('{!Quote__c.Cleaned_Quote_ID__c}',string.valueof(q.Cleaned_Quote_ID__c) );
		
		HTMLBody_rep = HTMLBody_rep.replace( '{!Quote__c.Cleaned_Quote_ID__c}',string.valueof(q.Cleaned_Quote_ID__c) );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote__c.Cleaned_Quote_ID__c}',string.valueof(q.Cleaned_Quote_ID__c) );
		Subject_rep = Subject_rep.replace('{!Quote__c.Cleaned_Quote_ID__c}',string.valueof(q.Cleaned_Quote_ID__c) );
		
		// replace Discount__c
		HTMLBody = HTMLBody.replace( '{!Quote__c.Discount__c}',string.valueof(q.Discount__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Discount__c}',string.valueof(q.Discount__c) );
		Subject = Subject.replace('{!Quote__c.Discount__c}',string.valueof(q.Discount__c) );
		
		HTMLBody_rep = HTMLBody_rep.replace( '{!Quote__c.Discount__c}',string.valueof(q.Discount__c) );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote__c.Discount__c}',string.valueof(q.Discount__c) );
		Subject_rep = Subject_rep.replace('{!Quote__c.Discount__c}',string.valueof(q.Discount__c) );
		
		 
		// replace {!Quote__c.Quote_ID__c}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		Subject = Subject.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		
		HTMLBody_rep = HTMLBody_rep.replace( '{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		Subject_rep = Subject_rep.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		
		//replace OpportunityName__c
		HTMLBody = HTMLBody.replace( '{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		Subject = Subject.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );

		HTMLBody_rep = HTMLBody_rep.replace( '{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		Subject_rep = Subject_rep.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );

		// replace {!Quote__c.ID}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Id}',string.valueof(q.ID) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Id}',string.valueof(q.ID) );
		Subject = Subject.replace('{!Quote__c.Id}',string.valueof(q.ID) );

		HTMLBody_rep = HTMLBody_rep.replace( '{!Quote__c.Id}',string.valueof(q.ID) );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote__c.Id}',string.valueof(q.ID) );
		Subject_rep = Subject_rep.replace('{!Quote__c.Id}',string.valueof(q.ID) );


		// replace {!Quote__c.ContactName__c}
		HTMLBody = HTMLBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c); 
		PlainTextBody = PlainTextBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		Subject = Subject.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		  
		HTMLBody_rep = HTMLBody_rep.replace('{!Quote__c.ContactName__c}',q.ContactName__c); 
		PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		Subject_rep = Subject_rep.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		  
		// replace {!Quote__c.NanaPDFID__c}
		//stick two random chars
		string encodedID = Encodingutil.urlEncode( EmailTaskCaller.randChar() + EmailTaskCaller.randChar() + Encodingutil.base64Encode( blob.valueOf(string.valueof(PDFHistoryID) ) ) , 'UTF-8');
		
		string encodedCADID = Encodingutil.urlEncode( EmailTaskCaller.randChar() + EmailTaskCaller.randChar() + Encodingutil.base64Encode( blob.valueOf(string.valueof(CADHistoryID) ) ) , 'UTF-8');

//v2 encoded id because bag!
		string hash = '';
		Blob b = Crypto.generateMac('HMacSHA1', Blob.valueOf(String.valueof(PDFHistoryID) ), Blob.valueOf('nanaenc-2.0') );
		hash = EncodingUtil.urlEncode(EncodingUtil.base64Encode(b), 'UTF-8');

		string cadhash = '';
		Blob cadb = Crypto.generateMac('HMacSHA1', Blob.valueOf(String.valueof(CADHistoryID) ), Blob.valueOf('nanaenc-2.0') );
		cadhash = EncodingUtil.urlEncode(EncodingUtil.base64Encode(cadb), 'UTF-8');
		
		HTMLBody = HTMLBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		PlainTextBody = PlainTextBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		Subject = Subject.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		
		HTMLBody_rep = HTMLBody_rep.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		Subject_rep = Subject_rep.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		
				//{!NanaServerAddress}
		HTMLBody = HTMLBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress()  );
		PlainTextBody = PlainTextBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		Subject = Subject.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		
		HTMLBody_rep = HTMLBody_rep.replace('{!NanaServerAddress}',Utility.NanaServerAddress()  );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		Subject_rep = Subject_rep.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		
						//{!QuoteLink}
		string link='';
		string link_rep='';

		link_rep = 'https://' + Utility.NanaServerAddress() + '/filefetching/GetQuotePDF.aspx?rep=true&ID=' +  Encodingutil.urlEncode(encodedID, 'UTF-8') + '&k=' +  Encodingutil.urlEncode(hash, 'UTF-8');		
		link = 'http://now.eloqua.com/e/f2.aspx?elqFormName=QuoteLink&elqSiteID=1745&Description=View&e=' + c.Email + '&QuoteSFID=' + q.Id + '&url=https://' + Utility.NanaServerAddress() + '/filefetching/GetQuotePDF.aspx?ID=' +  Encodingutil.urlEncode(encodedID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(hash, 'UTF-8');		
				
		HTMLBody = HTMLBody.replace('{!QuoteLink}', link);
		PlainTextBody = PlainTextBody.replace('{!QuoteLink}',link);
		Subject = Subject.replace('{!QuoteLink}',link );

		HTMLBody_rep = HTMLBody_rep.replace('{!QuoteLink}', link_rep);
		PlainTextBody_rep = PlainTextBody_rep.replace('{!QuoteLink}',link_rep);
		Subject_rep = Subject_rep.replace('{!QuoteLink}',link_rep );

		
		string cadlink= '';
		if(CADHistoryID > 0 )
		{
			cadlink = '<a href="http://now.eloqua.com/e/f2.aspx?elqFormName=CADLink&elqSiteID=1745&Description=CAD&e=' + c.Email + '&QuoteSFID=' + q.Id + '&url=https://' + Utility.NanaServerAddress() + '/filefetching/GetCADInterface.aspx?ID=' +  Encodingutil.urlEncode(encodedCADID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(cadhash, 'UTF-8') + '">click here to view your CAD drawings</a>';
		}
		if(NDGLink_OverrideURL != null && NDGLink_OverrideURL != '' )
		{
			cadlink = '<a href="'+NDGLink_OverrideURL+'">click here to view your CAD drawings</a>';
			
		}
		
		HTMLBody = HTMLBody.replace('{!CADLink}', cadlink);
		PlainTextBody = PlainTextBody.replace('{!CADLink}',cadlink);
		Subject = Subject.replace('{!CADLink}',cadlink );

		HTMLBody_rep = HTMLBody_rep.replace('{!CADLink}', cadlink);
		PlainTextBody_rep = PlainTextBody_rep.replace('{!CADLink}',cadlink);
		Subject_rep = Subject_rep.replace('{!CADLink}',cadlink );

		//{!Quote_Detail__c.Model__c}
		if( q.Quote_Details__r != null && q.Quote_Details__r.size() > 0 )
		{
			HTMLBody = HTMLBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			PlainTextBody = PlainTextBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			Subject = Subject.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c);
			
			HTMLBody_rep = HTMLBody_rep.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			Subject_rep = Subject_rep.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c);
		} else 
		{
			HTMLBody = HTMLBody.replace('{!Quote_Detail__c.Model__c}', '');
			PlainTextBody = PlainTextBody.replace('{!Quote_Detail__c.Model__c}', '' );
			Subject = Subject.replace('{!Quote_Detail__c.Model__c}', '');
		
			HTMLBody_rep = HTMLBody_rep.replace('{!Quote_Detail__c.Model__c}', '');
			PlainTextBody_rep = PlainTextBody_rep.replace('{!Quote_Detail__c.Model__c}', '' );
			Subject_rep = Subject_rep.replace('{!Quote_Detail__c.Model__c}', '');
		
		}


		//{!User.Email}
		HTMLBody = HTMLBody.replace('{!User.Email}',u.Email  );
		PlainTextBody = PlainTextBody.replace('{!User.Email}',u.Email  );
		Subject = Subject.replace('{!User.Email}',u.Email );

		HTMLBody_rep = HTMLBody_rep.replace('{!User.Email}',u.Email  );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!User.Email}',u.Email  );
		Subject_rep = Subject_rep.replace('{!User.Email}',u.Email );
 
		//{!ModelDescription}
		HTMLBody = HTMLBody.replace('{!ModelDescription}',ModelDescription  );
		PlainTextBody = PlainTextBody.replace('{!ModelDescription}', ModelDescription);
		Subject = Subject.replace('{!ModelDescription}',ModelDescription );

		HTMLBody_rep = HTMLBody_rep.replace('{!ModelDescription}',ModelDescription  );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!ModelDescription}', ModelDescription);
		Subject_rep = Subject_rep.replace('{!ModelDescription}',ModelDescription );



		
		//{!ShowroomInfo}
		HTMLBody = HTMLBody.replace('{!ShowroomInfo}', ShowroomInfo );
		PlainTextBody = PlainTextBody.replace('{!ShowroomInfo}', ShowroomInfo );
		Subject = Subject.replace('{!ShowroomInfo}', ShowroomInfo );

		HTMLBody_rep = HTMLBody_rep.replace('{!ShowroomInfo}', ShowroomInfo );
		PlainTextBody_rep = PlainTextBody_rep.replace('{!ShowroomInfo}', ShowroomInfo );
		Subject_rep = Subject_rep.replace('{!ShowroomInfo}', ShowroomInfo );




		string emailAdd = '';
		string emailAdd_rep = '';
//		if(SendToRep )
		{
			emailAdd_rep = q.Opportunity__r.Owner.Email;
			
		}
		
//		if(SendToCustomer)
		{
			emailAdd = q.Calculated_Email__c;
			if( emailAdd == null || emailAdd == '' ) emailAdd = c.Email;
		}		
		

		
		//set up the user email
		Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();		
		email.setCcAddresses(new string[]{'quotes@nanawall.com', 'gabe@paulsonit.com' } );
		if (c.Email == 'spamcheck@sitesell.net')
			email.setSubject('TEST');
		else
			email.setSubject( Subject );
		email.setHtmlBody( HTMLBody );
		
		email.setPlainTextBody(PlainTextBody);
		email.setToAddresses( new String[]{ emailAdd } );
		email.setReplyTo( u.Email );


		//set up the rep email
		Messaging.Singleemailmessage email_rep = new Messaging.Singleemailmessage();		
		//Email2__c,Email3__c,Email4__c
		list<string> rep_ccs = new list<string>(); // new string[] {'quotes@nanawall.com', 'gabe@paulsonit.com'};
		rep_ccs.add('quotes@nanawall.com');
		rep_ccs.add('gabe@paulsonit.com');
		if(u.Email2__c != null && u.Email2__c != '' )
			rep_ccs.add(  u.Email2__c);
		if(u.Email3__c != null && u.Email3__c != '' )
			rep_ccs.add(  u.Email3__c);
		if(u.Email4__c != null && u.Email4__c != '' )
			rep_ccs.add(  u.Email4__c);
			
		if(q.Responsible_Rep__r != null 
			&& q.Responsible_Rep__r.Email != null 
			&& q.Responsible_Rep__r.Email != '' )
			rep_ccs.add( q.Responsible_Rep__r.Email);

			
			
			
		email_rep.setCcAddresses(rep_ccs );
		
		if (c.Email == 'spamcheck@sitesell.net')
			email_rep.setSubject('TEST');
		else
			email_rep.setSubject( Subject_rep );
		email_rep.setHtmlBody( HTMLBody_rep );
system.debug('** ASTECH: body_rep: '+ HTMLBody_rep);
		
		email_rep.setPlainTextBody(PlainTextBody_rep);
		email_rep.setToAddresses( new String[]{ emailAdd_rep } );
		email_rep.setReplyTo( u.Email );



		try {
			
			email.setOrgWideEmailAddressId('0D2A0000000TNUg'); //ticket 20314 , they want quotes@nanawall to be the sender
			email_rep.setOrgWideEmailAddressId('0D2A0000000TNUg'); //ticket 20314 , they want quotes@nanawall to be the sender
			
			Messaging.SendEmailResult [] r = null;
			if( SendToCustomer)
			{
				system.debug('** ASTECH: sending customer email');
				r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 

				Task t = new Task();
				t.ActivityDate = Date.today();
				t.Description = 'Quote email sent from nanareps.com to ' + c.Email + ' <br />' + HTMLBody;
				t.Subject = 'Quote Email Sent: ' + q.Quote_ID__c;
				t.Status = 'Completed';
				t.WhoId = c.id;
				t.WhatId = q.Id;
				insert t;
				
			}
			
			if( SendToRep )
			{
				system.debug('** ASTECH: sending rep email');
				r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email_rep}); 
				system.debug(r);				
			}
			
		} catch( Exception ex) {
			Utility.JimDebug(ex, 'caught a sendquoteemail4 error');
			
//			email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
//			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
		}


		return true; 
	}


	WebService static boolean SendQuoteEmail3( string SalesforceQuoteID, integer PDFHistoryID,integer CADHistoryID, string ModelDescription, string ShowroomInfo, string NDGLink_OverrideURL ) {
	

		Quote__c q = [SELECT id, Opportunity__c, Contact__c,ContactName__c,Quote_ID__c,OpportunityName__c, Calculated_Email__c,  (SELECT id, Model__c FROM Quote_Details__r) FROM Quote__c WHERE id = :SalesforceQuoteID ];
				//need a workflow action when you print a quote, this method could be refactored
		q.Followup_Status__c ='Reviewing';
		q.Print_Date__c = DateTime.now();

		q.NanaPDFID__c = (double)PDFHistoryID;
		update q;


		Opportunity o = [SELECT Id, Customer_Emailed__c FROM Opportunity WHERE Id = :q.Opportunity__c];
		o.Customer_Emailed__c = true;
		update o;

		//when this is all working we need to hook the contact's email to the SEND, not my email - ks	
		Contact c = [SELECT id, Email, OwnerID FROM Contact WHERE id = :q.Contact__c ];

		User u = [SELECT Email, FirstName, LastName, OrgWideEmailAddressID__c FROM user WHERE id = :c.OwnerId];
		EmailTemplate template;
		try 
		{
			template = [SELECT Body, HtmlValue, id, Subject FROM EmailTemplate WHERE Id = :GlobalStrings.QuoteEmailTemplateID() ];
		} catch (Exception ex ) {
			template = new EmailTemplate();
			template.HtmlValue = '';
			template.Subject = '';
			//this should not happen at all		
		}
		string HTMLBody = template.HtmlValue;
		string Subject = template.Subject;
		string PlainTextBody = ( template.Body == null ? ' ' : template.Body );

		// replace {!Quote__c.Quote_ID__c}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		Subject = Subject.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		
		//replace OpportunityName__c
		HTMLBody = HTMLBody.replace( '{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		Subject = Subject.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );

		// replace {!Quote__c.ID}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Id}',string.valueof(q.ID) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Id}',string.valueof(q.ID) );
		Subject = Subject.replace('{!Quote__c.Id}',string.valueof(q.ID) );


		// replace {!Quote__c.ContactName__c}
		HTMLBody = HTMLBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c); 
		PlainTextBody = PlainTextBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		Subject = Subject.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		  
		// replace {!Quote__c.NanaPDFID__c}
		//stick two random chars
		string encodedID = Encodingutil.urlEncode( EmailTaskCaller.randChar() + EmailTaskCaller.randChar() + Encodingutil.base64Encode( blob.valueOf(string.valueof(PDFHistoryID) ) ) , 'UTF-8');
		
		string encodedCADID = Encodingutil.urlEncode( EmailTaskCaller.randChar() + EmailTaskCaller.randChar() + Encodingutil.base64Encode( blob.valueOf(string.valueof(CADHistoryID) ) ) , 'UTF-8');

//v2 encoded id because bag!
		string hash = '';
		Blob b = Crypto.generateMac('HMacSHA1', Blob.valueOf(String.valueof(PDFHistoryID) ), Blob.valueOf('nanaenc-2.0') );
		hash = EncodingUtil.urlEncode(EncodingUtil.base64Encode(b), 'UTF-8');

		string cadhash = '';
		Blob cadb = Crypto.generateMac('HMacSHA1', Blob.valueOf(String.valueof(CADHistoryID) ), Blob.valueOf('nanaenc-2.0') );
		cadhash = EncodingUtil.urlEncode(EncodingUtil.base64Encode(cadb), 'UTF-8');
		
		HTMLBody = HTMLBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		PlainTextBody = PlainTextBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		Subject = Subject.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		
				//{!NanaServerAddress}
		HTMLBody = HTMLBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress()  );
		PlainTextBody = PlainTextBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		Subject = Subject.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		
						//{!QuoteLink}
		string link='http://now.eloqua.com/e/f2.aspx?elqFormName=QuoteLink&elqSiteID=1745&Description=View&e=' + c.Email + '&QuoteSFID=' + q.Id + '&url=http://' + Utility.NanaServerAddress() + '/filefetching/GetQuotePDF.aspx?ID=' +  Encodingutil.urlEncode(encodedID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(hash, 'UTF-8');		
		HTMLBody = HTMLBody.replace('{!QuoteLink}', link);
		PlainTextBody = PlainTextBody.replace('{!QuoteLink}',link);
		Subject = Subject.replace('{!QuoteLink}',link );

		
		string cadlink= '';
		if(CADHistoryID > 0 )
		{
			cadlink = '<a href="http://now.eloqua.com/e/f2.aspx?elqFormName=CADLink&elqSiteID=1745&Description=CAD&e=' + c.Email + '&QuoteSFID=' + q.Id + '&url=http://' + Utility.NanaServerAddress() + '/filefetching/GetCADInterface.aspx?ID=' +  Encodingutil.urlEncode(encodedCADID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(cadhash, 'UTF-8') + '">click here to view your CAD drawings</a>';
		}
		if(NDGLink_OverrideURL != null && NDGLink_OverrideURL != '' )
		{
			cadlink = '<a href="'+NDGLink_OverrideURL+'">click here to view your CAD drawings</a>';
			
		}
		
		HTMLBody = HTMLBody.replace('{!CADLink}', cadlink);
		PlainTextBody = PlainTextBody.replace('{!CADLink}',cadlink);
		Subject = Subject.replace('{!CADLink}',cadlink );

		//{!Quote_Detail__c.Model__c}
		if( q.Quote_Details__r != null && q.Quote_Details__r.size() > 0 )
		{
			HTMLBody = HTMLBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			PlainTextBody = PlainTextBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			Subject = Subject.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c);
		} else 
		{
			HTMLBody = HTMLBody.replace('{!Quote_Detail__c.Model__c}', '');
			PlainTextBody = PlainTextBody.replace('{!Quote_Detail__c.Model__c}', '' );
			Subject = Subject.replace('{!Quote_Detail__c.Model__c}', '');
		
		}


		//{!User.Email}
		HTMLBody = HTMLBody.replace('{!User.Email}',u.Email  );
		PlainTextBody = PlainTextBody.replace('{!User.Email}',u.Email  );
		Subject = Subject.replace('{!User.Email}',u.Email );



 
		//{!ModelDescription}
		HTMLBody = HTMLBody.replace('{!ModelDescription}',ModelDescription  );
		PlainTextBody = PlainTextBody.replace('{!ModelDescription}', ModelDescription);
		Subject = Subject.replace('{!ModelDescription}',ModelDescription );

		
		//{!ShowroomInfo}
		HTMLBody = HTMLBody.replace('{!ShowroomInfo}', ShowroomInfo );
		PlainTextBody = PlainTextBody.replace('{!ShowroomInfo}', ShowroomInfo );
		Subject = Subject.replace('{!ShowroomInfo}', ShowroomInfo );

		
		string emailAdd = q.Calculated_Email__c;
		if( emailAdd == null || emailAdd == '' ) emailAdd = c.Email;

		
		Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
		
		email.setCcAddresses(new string[]{'quotes@nanawall.com' } );
		if (c.Email == 'spamcheck@sitesell.net')
			email.setSubject('TEST');
		else
			email.setSubject( Subject );
		email.setHtmlBody( HTMLBody );
		
		email.setPlainTextBody(PlainTextBody);
		email.setToAddresses( new String[]{ emailAdd } );
		email.setReplyTo( u.Email );


		try {
			email.setOrgWideEmailAddressId('0D2A0000000TNUg'); //ticket 20314 , they want quotes@nanawall to be the sender
			
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
			
			
		} catch( Exception ex) {
			Utility.JimDebug(ex, 'caught a sendquoteemail2 error');
			email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
		}

		Task t = new Task();
		t.ActivityDate = Date.today();
		t.Description = 'Quote email sent from nanareps.com to ' + c.Email + ' <br />' + HTMLBody;
		t.Subject = 'Quote Email Sent: ' + q.Quote_ID__c;
		t.Status = 'Completed';
		t.WhoId = c.id;
		t.WhatId = q.Id;
		insert t;

		return true; 
	}

	WebService static boolean SendPublicNDGEmail( string ContactID, string CADLink ) {
		return SendPublicNDGEmail_main( ContactID,  CADLink, '' );

	}
	
	WebService static boolean SendPublicNDGEmail_main( string ContactID, string CADLink, string XMLBody ) {


		Contact c = [SELECT id, Email, OwnerID, FirstName, LastName FROM Contact WHERE id = :ContactID ];

system.debug('getting contact with ID: ' + ContactID);
system.debug('template name: ' + GlobalStrings.NDGPublicEmailTemplateName());		
		
		
		EmailTemplate template = [SELECT Body, HtmlValue, id, Subject FROM EmailTemplate WHERE DeveloperName = :GlobalStrings.NDGPublicEmailTemplateName() ];
		
		string HTMLBody = template.HtmlValue;
		string Subject = template.Subject;
		string PlainTextBody = ( template.Body == null ? ' ' : template.Body );

		// replace {!ContactEmail}
		HTMLBody = HTMLBody.replace('{!ContactEmail}',c.Email); 
		PlainTextBody = PlainTextBody.replace('{!ContactEmail}',c.Email );
		Subject = Subject.replace('{!ContactEmail}',c.Email);
		  
		  
		// replace {!Quote__c.ContactName__c}
		HTMLBody = HTMLBody.replace('{!ContactName}',c.FirstName +' ' + c.LastName ); 
		PlainTextBody = PlainTextBody.replace('{!ContactName}',c.FirstName +' ' + c.LastName );
		Subject = Subject.replace('{!ContactName}',c.FirstName +' ' + c.LastName );
		  
		
		//{!NanaServerAddress}
		HTMLBody = HTMLBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress()  );
		PlainTextBody = PlainTextBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		Subject = Subject.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		

		HTMLBody = HTMLBody.replace('{!CADLink}', CADLink);
		PlainTextBody = PlainTextBody.replace('{!CADLink}',CADLink);
		Subject = Subject.replace('{!CADLink}',CADLink );

		HTMLBody = HTMLBody.replace('{!User.Email}', 'quotes@nanawall.com');
		PlainTextBody = PlainTextBody.replace('{!User.Email}','quotes@nanawall.com');
		Subject = Subject.replace('{!User.Email}','quotes@nanawall.com' );

		Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
		
		email.setCcAddresses(new string[]{'quotes@nanawall.com' } );
		email.setSubject( Subject );
		email.setHtmlBody( HTMLBody );

		
		email.setPlainTextBody(PlainTextBody);
		email.setToAddresses( new String[]{ c.Email } );

		email.setReplyTo( 'quotes@nanawall.com'  );


		try {
			email.setOrgWideEmailAddressId('0D2A0000000TNUg'); 		
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
			
		} catch( Exception ex) {
			Utility.JimDebug(ex, 'caught a SendPublicNDGEmail error');
			email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
		}

		Task t = new Task();
		t.ActivityDate = Date.today();
		t.Description = 'Public NDG email sent from nanareps.com to ' + c.FirstName +' ' + c.LastName + ' (' + c.Email + ') <br />\n' + HTMLBody + '<br />\nCAD Link: ' + CADLink + '<br/>\nXML Body: <br />\n' + XMLBody;
		t.Subject = 'Custom NDG5k-CAD Email for sent to  ' + c.FirstName + ' ' + c.LastName + ' ( '+c.Email+')' ;
		t.Status = 'Completed';
		t.WhoId = c.id;
//		t.WhatId = q.Id;
		insert t;

		return true; 
	}	
	
	WebService static boolean SendNDGEmail( string SalesforceQuoteID, integer CADHistoryID, string RecipientEmail ) {
	

		Quote__c q = [SELECT id, Contact__c,ContactName__c,Quote_ID__c,OpportunityName__c, Opportunity__c, Calculated_Email__c,  (SELECT id, Model__c FROM Quote_Details__r) FROM Quote__c WHERE id = :SalesforceQuoteID ];

		//when this is all working we need to hook the contact's email to the SEND, not my email - ks	
		Contact c = [SELECT id, Email, OwnerID FROM Contact WHERE id = :q.Contact__c ];



//		// Email needs to be sent to the owner of the project	
		Opportunity opp  = [SELECT id,  OwnerID FROM Opportunity WHERE id = :q.Opportunity__c ];

		User u = [SELECT Email, FirstName, LastName, OrgWideEmailAddressID__c FROM user WHERE id = :opp.OwnerId];
		
		EmailTemplate template;
		try 
		{
			template = [SELECT Body, HtmlValue, id, Subject FROM EmailTemplate WHERE Id = :GlobalStrings.NDGEmailEmailTemplateID() ];
		} catch (Exception ex ) {
			template = new EmailTemplate();
			template.HtmlValue = '';
			template.Subject = '';
			//this should not happen at all		
		}
		string HTMLBody = template.HtmlValue;
		string Subject = template.Subject;
		string PlainTextBody = ( template.Body == null ? ' ' : template.Body );

		// replace {!ContactEmail}
		HTMLBody = HTMLBody.replace('{!ContactEmail}',c.Email); 
		PlainTextBody = PlainTextBody.replace('{!ContactEmail}',c.Email );
		Subject = Subject.replace('{!ContactEmail}',c.Email);
		  


		// replace {!Quote__c.Quote_ID__c}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		Subject = Subject.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		
		//replace OpportunityName__c
		HTMLBody = HTMLBody.replace( '{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		Subject = Subject.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );

		// replace {!Quote__c.ID}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Id}',string.valueof(q.ID) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Id}',string.valueof(q.ID) );
		Subject = Subject.replace('{!Quote__c.Id}',string.valueof(q.ID) );


		// replace {!Quote__c.ContactName__c}
		HTMLBody = HTMLBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c); 
		PlainTextBody = PlainTextBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		Subject = Subject.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		  
		// replace {!Quote__c.NanaPDFID__c}
		//stick two random chars
//		string encodedID = Encodingutil.urlEncode( EmailTaskCaller.randChar() + EmailTaskCaller.randChar() + Encodingutil.base64Encode( blob.valueOf(string.valueof(PDFHistoryID) ) ) , 'UTF-8');
		
		string encodedCADID = Encodingutil.urlEncode( EmailTaskCaller.randChar() + EmailTaskCaller.randChar() + Encodingutil.base64Encode( blob.valueOf(string.valueof(CADHistoryID) ) ) , 'UTF-8');

//v2 encoded id because bag!
//		string hash = '';
//		Blob b = Crypto.generateMac('HMacSHA1', Blob.valueOf(String.valueof(PDFHistoryID) ), Blob.valueOf('nanaenc-2.0') );
//		hash = EncodingUtil.urlEncode(EncodingUtil.base64Encode(b), 'UTF-8');

		string cadhash = '';
		Blob cadb = Crypto.generateMac('HMacSHA1', Blob.valueOf(String.valueof(CADHistoryID) ), Blob.valueOf('nanaenc-2.0') );
		cadhash = EncodingUtil.urlEncode(EncodingUtil.base64Encode(cadb), 'UTF-8');

/*		
		HTMLBody = HTMLBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		PlainTextBody = PlainTextBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		Subject = Subject.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
*/
		
		//{!NanaServerAddress}
		HTMLBody = HTMLBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress()  );
		PlainTextBody = PlainTextBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		Subject = Subject.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		
		//{!QuoteLink}

/*
		string link='http://now.eloqua.com/e/f2.aspx?elqFormName=QuoteLink&elqSiteID=1745&Description=View&e=' + RecipientEmail + '&QuoteSFID=' + q.Id + '&url=http://' + Utility.NanaServerAddress() + '/filefetching/GetQuotePDF.aspx?ID=' +  Encodingutil.urlEncode(encodedID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(hash, 'UTF-8');
		HTMLBody = HTMLBody.replace('{!QuoteLink}', link);
		PlainTextBody = PlainTextBody.replace('{!QuoteLink}',link);
		Subject = Subject.replace('{!QuoteLink}',link );
*/
		
		
		string cadlink= '#';
		if(CADHistoryID > 0 )
		{
			cadlink = 'http://now.eloqua.com/e/f2.aspx?elqFormName=CADLink&elqSiteID=1745&Description=CAD&e=' + RecipientEmail + '&QuoteSFID=' + q.Id + '&url=http://' + Utility.NanaServerAddress() + '/filefetching/GetCADInterface.aspx?ID=' +  Encodingutil.urlEncode(encodedCADID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(cadhash, 'UTF-8') + '';
		}
		HTMLBody = HTMLBody.replace('{!CADLink}', cadlink);
		PlainTextBody = PlainTextBody.replace('{!CADLink}',cadlink);
		Subject = Subject.replace('{!CADLink}',cadlink );


		//{!Quote_Detail__c.Model__c}

		if( q.Quote_Details__r != null && q.Quote_Details__r.size() > 0 )
		{
			HTMLBody = HTMLBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			PlainTextBody = PlainTextBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			Subject = Subject.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c);
		} else 
		{
			HTMLBody = HTMLBody.replace('{!Quote_Detail__c.Model__c}', '');
			PlainTextBody = PlainTextBody.replace('{!Quote_Detail__c.Model__c}', '' );
			Subject = Subject.replace('{!Quote_Detail__c.Model__c}', '');
		
		}


		//{!User.Email}
		HTMLBody = HTMLBody.replace('{!User.Email}',RecipientEmail );
		PlainTextBody = PlainTextBody.replace('{!User.Email}',RecipientEmail  );
		Subject = Subject.replace('{!User.Email}',RecipientEmail );



		
//		string emailAdd = q.Calculated_Email__c;
//		if( emailAdd == null || emailAdd == '' ) emailAdd = u.Email;
		string emailAdd = u.Email;

		
		Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
		
		email.setCcAddresses(new string[]{'quotes@nanawall.com' } );
//		if (c.Email == 'spamcheck@sitesell.net')
//			email.setSubject('TEST');
//		else
			email.setSubject( Subject );
		email.setHtmlBody( HTMLBody );

		
		email.setPlainTextBody(PlainTextBody);
		email.setToAddresses( new String[]{RecipientEmail } );
//		email.setToAddresses( new String[]{ emailAdd } );

		email.setReplyTo( u.Email );


		try {
			email.setOrgWideEmailAddressId('0D2A0000000TNUg'); //ticket 20314 , they want quotes@nanawall to be the sender
			
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
			
			
		} catch( Exception ex) {
			Utility.JimDebug(ex, 'caught a sendquoteemail2 error');
//			email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
//			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
		}

		Task t = new Task();
		t.ActivityDate = Date.today();
		t.Description = 'NDG email sent from nanareps.com to ' + u.Email + ' <br />' + HTMLBody;
		t.Subject = 'NDG Email Sent: ' + q.Quote_ID__c;
		t.Status = 'Completed';
//		t.WhoId = u.id;
		t.WhatId = q.Id;
		insert t;

		return true; 
	}	
	
	WebService static boolean SendQuoteEmail2( string SalesforceQuoteID, integer PDFHistoryID,integer CADHistoryID, string ModelDescription, string ShowroomInfo ) {
	

		Quote__c q = [SELECT id, Contact__c,ContactName__c,Quote_ID__c,OpportunityName__c, Calculated_Email__c,  (SELECT id, Model__c FROM Quote_Details__r) FROM Quote__c WHERE id = :SalesforceQuoteID ];
//		List<Quote_Detail__c> qds = [SELECT id, Name FROM Quote_Detail__c];
				//need a workflow action when you print a quote, this method could be refactored
		q.Followup_Status__c ='Reviewing';
		q.Print_Date__c = DateTime.now();

		q.NanaPDFID__c = (double)PDFHistoryID;
		update q;

		//when this is all working we need to hook the contact's email to the SEND, not my email - ks	
		Contact c = [SELECT id, Email, OwnerID FROM Contact WHERE id = :q.Contact__c ];

		User u = [SELECT Email, FirstName, LastName, OrgWideEmailAddressID__c FROM user WHERE id = :c.OwnerId];
		EmailTemplate template;
		try 
		{
			template = [SELECT Body, HtmlValue, id, Subject FROM EmailTemplate WHERE Id = :GlobalStrings.QuoteEmailTemplateID() ];
		} catch (Exception ex ) {
			template = new EmailTemplate();
			template.HtmlValue = '';
			template.Subject = '';
			//this should not happen at all		
		}
		string HTMLBody = template.HtmlValue;
		string Subject = template.Subject;
		string PlainTextBody = ( template.Body == null ? ' ' : template.Body );

		// replace {!Quote__c.Quote_ID__c}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		Subject = Subject.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		
		//replace OpportunityName__c
		HTMLBody = HTMLBody.replace( '{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );
		Subject = Subject.replace('{!Quote__c.OpportunityName__c}',string.valueof(q.OpportunityName__c) );

		// replace {!Quote__c.ID}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Id}',string.valueof(q.ID) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Id}',string.valueof(q.ID) );
		Subject = Subject.replace('{!Quote__c.Id}',string.valueof(q.ID) );


		// replace {!Quote__c.ContactName__c}
		HTMLBody = HTMLBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c); 
		PlainTextBody = PlainTextBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		Subject = Subject.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		  
		// replace {!Quote__c.NanaPDFID__c}
		//stick two random chars
		string encodedID = Encodingutil.urlEncode( EmailTaskCaller.randChar() + EmailTaskCaller.randChar() + Encodingutil.base64Encode( blob.valueOf(string.valueof(PDFHistoryID) ) ) , 'UTF-8');
		
		string encodedCADID = Encodingutil.urlEncode( EmailTaskCaller.randChar() + EmailTaskCaller.randChar() + Encodingutil.base64Encode( blob.valueOf(string.valueof(CADHistoryID) ) ) , 'UTF-8');

//v2 encoded id because bag!
		string hash = '';
		Blob b = Crypto.generateMac('HMacSHA1', Blob.valueOf(String.valueof(PDFHistoryID) ), Blob.valueOf('nanaenc-2.0') );
		hash = EncodingUtil.urlEncode(EncodingUtil.base64Encode(b), 'UTF-8');

		string cadhash = '';
		Blob cadb = Crypto.generateMac('HMacSHA1', Blob.valueOf(String.valueof(CADHistoryID) ), Blob.valueOf('nanaenc-2.0') );
		cadhash = EncodingUtil.urlEncode(EncodingUtil.base64Encode(cadb), 'UTF-8');
		
		HTMLBody = HTMLBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		PlainTextBody = PlainTextBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		Subject = Subject.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		
				//{!NanaServerAddress}
		HTMLBody = HTMLBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress()  );
		PlainTextBody = PlainTextBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		Subject = Subject.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		
						//{!QuoteLink}
		string link='http://now.eloqua.com/e/f2.aspx?elqFormName=QuoteLink&elqSiteID=1745&Description=View&e=' + c.Email + '&QuoteSFID=' + q.Id + '&url=http://' + Utility.NanaServerAddress() + '/filefetching/GetQuotePDF.aspx?ID=' +  Encodingutil.urlEncode(encodedID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(hash, 'UTF-8');
		HTMLBody = HTMLBody.replace('{!QuoteLink}', link);
		PlainTextBody = PlainTextBody.replace('{!QuoteLink}',link);
		Subject = Subject.replace('{!QuoteLink}',link );
		
//		string cadlink='http://now.eloqua.com/e/f2.aspx?elqFormName=CADLink&elqSiteID=1745&Description=CAD&e=' + c.Email + '&QuoteSFID=' + q.Id + '&url=http://' + Utility.NanaServerAddress() + '/filefetching/GetCADInterface.aspx?ID=' +  Encodingutil.urlEncode(encodedCADID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(cadhash, 'UTF-8');

		
		string cadlink= '';
		if(CADHistoryID > 0 )
		{
			cadlink = '<a href="http://now.eloqua.com/e/f2.aspx?elqFormName=CADLink&elqSiteID=1745&Description=CAD&e=' + c.Email + '&QuoteSFID=' + q.Id + '&url=http://' + Utility.NanaServerAddress() + '/filefetching/GetCADInterface.aspx?ID=' +  Encodingutil.urlEncode(encodedCADID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(cadhash, 'UTF-8') + '">click here to view your CAD drawings</a>';
		}
		HTMLBody = HTMLBody.replace('{!CADLink}', cadlink);
		PlainTextBody = PlainTextBody.replace('{!CADLink}',cadlink);
		Subject = Subject.replace('{!CADLink}',cadlink );
/*
		HTMLBody = HTMLBody.replace('{!Quote__c.NanaPDFID__c}', string.valueOf(PDFHistoryID) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.NanaPDFID__c}',string.valueOf(PDFHistoryID) );
		Subject = Subject.replace('{!Quote__c.NanaPDFID__c}',string.valueOf(PDFHistoryID) );
*/


		//{!Quote_Detail__c.Model__c}
		if( q.Quote_Details__r != null && q.Quote_Details__r.size() > 0 )
		{
			HTMLBody = HTMLBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			PlainTextBody = PlainTextBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
			Subject = Subject.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c);
		} else 
		{
			HTMLBody = HTMLBody.replace('{!Quote_Detail__c.Model__c}', '');
			PlainTextBody = PlainTextBody.replace('{!Quote_Detail__c.Model__c}', '' );
			Subject = Subject.replace('{!Quote_Detail__c.Model__c}', '');
		
		}


		//{!User.Email}
		HTMLBody = HTMLBody.replace('{!User.Email}',u.Email  );
		PlainTextBody = PlainTextBody.replace('{!User.Email}',u.Email  );
		Subject = Subject.replace('{!User.Email}',u.Email );



 
		//{!ModelDescription}
		HTMLBody = HTMLBody.replace('{!ModelDescription}',ModelDescription  );
		PlainTextBody = PlainTextBody.replace('{!ModelDescription}', ModelDescription);
		Subject = Subject.replace('{!ModelDescription}',ModelDescription );

		
		//{!ShowroomInfo}
		HTMLBody = HTMLBody.replace('{!ShowroomInfo}', ShowroomInfo );
		PlainTextBody = PlainTextBody.replace('{!ShowroomInfo}', ShowroomInfo );
		Subject = Subject.replace('{!ShowroomInfo}', ShowroomInfo );



//        Subject += 'send to: ' + c.Email + '';

/*
		// strip out <![CDATA[  and ]]>
		HTMLBody = HTMLBody.replace('<![CDATA[', '' );
		PlainTextBody = PlainTextBody.replace('<![CDATA[','' );
		HTMLBody = HTMLBody.replace(']]>', '' );
		PlainTextBody = PlainTextBody.replace(']]>','' );
*/
		
/*		BrandTemplate letterhead = [Select b.Id, b.Name, b.Value from BrandTemplate b WHERE id = :'016S0000000099mIAA' ];
		 

		Pattern p = Pattern.compile('\\<img.*\\>[\n*]\\<!\\[CDATA\\[');
		string overallLayout = p.matcher(letterhead.Value).replaceAll('<img border="0" src="http://'+ utility.HostName() );
		p = Pattern.compile('\\]\\]\\>\\</img\\>');
		overallLayout = p.matcher(overallLayout).replaceAll('" />');
		p = Pattern.compile('\\<.*bLabel="main".*\\>[\n*]\\</style\\>');
		 overallLayout = p.matcher(overallLayout).replaceAll( HTMLBody );
*/
		
		string emailAdd = q.Calculated_Email__c;
		if( emailAdd == null || emailAdd == '' ) emailAdd = c.Email;

		
		Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
		
		email.setCcAddresses(new string[]{'quotes@nanawall.com' } );
		if (c.Email == 'spamcheck@sitesell.net')
			email.setSubject('TEST');
		else
			email.setSubject( Subject );
		email.setHtmlBody( HTMLBody );
System.debug('using plaintext: ' + PlainTextBody);		
		
		email.setPlainTextBody(PlainTextBody);
//		email.setToAddresses( new String[]{'stout@kristianstout.com' } );
//		email.setToAddresses( new String[]{c.Email } );
		email.setToAddresses( new String[]{ emailAdd } );
		email.setReplyTo( u.Email );


//		email.setSenderDisplayName( u.FirstName + ' ' + u.LastName );

		try {
			/*
			string oweid = string.valueOf(  u.OrgWideEmailAddressID__c   );
			if( u.OrgWideEmailAddressID__c != null 
			&& oweid != '' )
					email.setOrgWideEmailAddressId( oweid  );
			else  email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
*/
			email.setOrgWideEmailAddressId('0D2A0000000TNUg'); //ticket 20314 , they want quotes@nanawall to be the sender
			
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
			
			
		} catch( Exception ex) {
			Utility.JimDebug(ex, 'caught a sendquoteemail2 error');
			email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
		}

		Task t = new Task();
		t.ActivityDate = Date.today();
		t.Description = 'Quote email sent from nanareps.com to ' + c.Email + ' <br />' + HTMLBody;
		t.Subject = 'Quote Email Sent: ' + q.Quote_ID__c;
		t.Status = 'Completed';
		t.WhoId = c.id;
		t.WhatId = q.Id;
		insert t;

		return true; 
	}
	
	WebService static boolean SendQuoteEmail( string SalesforceQuoteID, integer PDFHistoryID,  string ModelDescription, string ShowroomInfo ) {
	
  
		Quote__c q = [SELECT id, Contact__c,ContactName__c,Quote_ID__c,Use_Controlling_Account__c,  (SELECT id, Model__c FROM Quote_Details__r) FROM Quote__c WHERE id = :SalesforceQuoteID ];
//		List<Quote_Detail__c> qds = [SELECT id, Name FROM Quote_Detail__c];
				//need a workflow action when you print a quote, this method could be refactored
		q.Followup_Status__c ='Reviewing';
		q.Print_Date__c = DateTime.now();


		q.NanaPDFID__c = (double)PDFHistoryID;
		update q;

		//when this is all working we need to hook the contact's email to the SEND, not my email - ks	
		Contact c = [SELECT id, Email, OwnerID FROM Contact WHERE id = :q.Contact__c ];

		User u = [SELECT Email, FirstName, LastName, OrgWideEmailAddressID__c FROM user WHERE id = :c.OwnerId];
		EmailTemplate template;
		try 
		{
			template = [SELECT Body, HtmlValue, id, Subject FROM EmailTemplate WHERE Id = :GlobalStrings.QuoteEmailTemplateID() ];
		} catch (Exception ex ) {
			template = new EmailTemplate();
			template.HtmlValue = '';
			template.Subject = '';
			//this should not happen at all		
		}
		string HTMLBody = template.HtmlValue;
		string Subject = template.Subject;
		string PlainTextBody = ( template.Body == null ? ' ' : template.Body );

		// replace {!Quote__c.Quote_ID__c}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );
		Subject = Subject.replace('{!Quote__c.Quote_ID__c}',string.valueof(q.Quote_ID__c) );

		// replace {!Quote__c.ID}
		HTMLBody = HTMLBody.replace( '{!Quote__c.Id}',string.valueof(q.ID) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Id}',string.valueof(q.ID) );
		Subject = Subject.replace('{!Quote__c.Id}',string.valueof(q.ID) );


		// replace {!Quote__c.ContactName__c}
		HTMLBody = HTMLBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c); 
		PlainTextBody = PlainTextBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		Subject = Subject.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		  
		// replace {!Quote__c.NanaPDFID__c}
		//stick two random chars
		string encodedID = Encodingutil.urlEncode( EmailTaskCaller.randChar() + EmailTaskCaller.randChar() + Encodingutil.base64Encode( blob.valueOf(string.valueof(PDFHistoryID) ) ) , 'UTF-8');

//v2 encoded id because bag!
		string hash = '';
		Blob b = Crypto.generateMac('HMacSHA1', Blob.valueOf(String.valueof(PDFHistoryID) ), Blob.valueOf('nanaenc-2.0') );
		hash = EncodingUtil.urlEncode(EncodingUtil.base64Encode(b), 'UTF-8');

		HTMLBody = HTMLBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		PlainTextBody = PlainTextBody.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		Subject = Subject.replace('{!Quote__c.NanaPDFID__c}', encodedID +'&k='+hash);
		
				//{!NanaServerAddress}
		HTMLBody = HTMLBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress()  );
		PlainTextBody = PlainTextBody.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		Subject = Subject.replace('{!NanaServerAddress}',Utility.NanaServerAddress() );
		
						//{!QuoteLink}
		string link='http://now.eloqua.com/e/f2.aspx?elqFormName=QuoteLink&elqSiteID=1745&Description=View&e=' + c.Email + '&QuoteSFID=' + q.Id + '&url=http://' + Utility.NanaServerAddress() + '/filefetching/GetQuotePDF.aspx?ID=' +  Encodingutil.urlEncode(encodedID, 'UTF-8') + '%26k=' +  Encodingutil.urlEncode(hash, 'UTF-8');
		HTMLBody = HTMLBody.replace('{!QuoteLink}', link);
		PlainTextBody = PlainTextBody.replace('{!QuoteLink}',link);
		Subject = Subject.replace('{!QuoteLink}',link );
/*
		HTMLBody = HTMLBody.replace('{!Quote__c.NanaPDFID__c}', string.valueOf(PDFHistoryID) );
		PlainTextBody = PlainTextBody.replace('{!Quote__c.NanaPDFID__c}',string.valueOf(PDFHistoryID) );
		Subject = Subject.replace('{!Quote__c.NanaPDFID__c}',string.valueOf(PDFHistoryID) );
*/


		//{!Quote_Detail__c.Model__c}
		HTMLBody = HTMLBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
		PlainTextBody = PlainTextBody.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c );
		Subject = Subject.replace('{!Quote_Detail__c.Model__c}', q.Quote_Details__r[0].Model__c);


		//{!User.Email}
		HTMLBody = HTMLBody.replace('{!User.Email}',u.Email  );
		PlainTextBody = PlainTextBody.replace('{!User.Email}',u.Email  );
		Subject = Subject.replace('{!User.Email}',u.Email );



 
		//{!ModelDescription}
		HTMLBody = HTMLBody.replace('{!ModelDescription}',ModelDescription  );
		PlainTextBody = PlainTextBody.replace('{!ModelDescription}', ModelDescription);
		Subject = Subject.replace('{!ModelDescription}',ModelDescription );

		
		//{!ShowroomInfo}
		HTMLBody = HTMLBody.replace('{!ShowroomInfo}', ShowroomInfo );
		PlainTextBody = PlainTextBody.replace('{!ShowroomInfo}', ShowroomInfo );
		Subject = Subject.replace('{!ShowroomInfo}', ShowroomInfo );



//        Subject += 'send to: ' + c.Email + '';

/*
		// strip out <![CDATA[  and ]]>
		HTMLBody = HTMLBody.replace('<![CDATA[', '' );
		PlainTextBody = PlainTextBody.replace('<![CDATA[','' );
		HTMLBody = HTMLBody.replace(']]>', '' );
		PlainTextBody = PlainTextBody.replace(']]>','' );
*/
		
/*		BrandTemplate letterhead = [Select b.Id, b.Name, b.Value from BrandTemplate b WHERE id = :'016S0000000099mIAA' ];
		 

		Pattern p = Pattern.compile('\\<img.*\\>[\n*]\\<!\\[CDATA\\[');
		string overallLayout = p.matcher(letterhead.Value).replaceAll('<img border="0" src="http://'+ utility.HostName() );
		p = Pattern.compile('\\]\\]\\>\\</img\\>');
		overallLayout = p.matcher(overallLayout).replaceAll('" />');
		p = Pattern.compile('\\<.*bLabel="main".*\\>[\n*]\\</style\\>');
		 overallLayout = p.matcher(overallLayout).replaceAll( HTMLBody );
*/
		
		Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
		
		
		email.setCcAddresses(new string[]{'quotes@nanawall.com'} );
		if (c.Email == 'spamcheck@sitesell.net')
			email.setSubject('TEST');
		else
			email.setSubject( Subject );
		email.setHtmlBody( HTMLBody );
System.debug('using plaintext: ' + PlainTextBody);		 
		email.setPlainTextBody(PlainTextBody);
		
		string emailAddress = q.Calculated_Email__c;

//		email.setToAddresses( new String[]{'stout@kristianstout.com' } );
//		email.setToAddresses( new String[]{c.Email } );
		email.setToAddresses( new String[]{ emailAddress } );
		email.setReplyTo( u.Email );


//		email.setSenderDisplayName( u.FirstName + ' ' + u.LastName );

		try {
			string oweid = string.valueOf(  u.OrgWideEmailAddressID__c   );
			if( u.OrgWideEmailAddressID__c != null 
			&& oweid != '' )
					email.setOrgWideEmailAddressId( oweid  );
			else  email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
		} catch( Exception ex) {
			email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
		}

		Task t = new Task();
		t.ActivityDate = Date.today();
		t.Description = 'Quote email sent from nanareps.com to ' + c.Email + ' <br />' + HTMLBody;
		t.Subject = 'Quote Email Sent: ' + q.Quote_ID__c;
		t.Status = 'Completed';
		t.WhoId = c.id;
		t.WhatId = q.Id;
		insert t;

		return true; 
	}



}