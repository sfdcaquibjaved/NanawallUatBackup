public with sharing class Quote_SendFinalInvoice {

	public PageReference doSendFinalInvoice() 
	{ 
		
		SendEmail(this.quote.Name);
		return new PageReference('/' + this.quote.Id);	
	}
	
	public static void SendBulkEmails( list<string> QuoteNumbers )
	{
		Quote_SendFinalInvoice qsfi = new Quote_SendFinalInvoice(null);
		for( string quotenumber : QuoteNumbers )
		{
			qsfi.SendEmail(quotenumber);
		}
	}
	
	public void SendEmail(string QuoteNumber ) 
	{
		Quote__c q = [SELECT id, Contact__c,Is_Local__c,ContactName__c,Order_Number__c,Quote_ID__c,Final_Invoice_Amount__c, Calculated_ETA__c, Calculated_Email__c,  (SELECT id, Model__c FROM Quote_Details__r) FROM Quote__c WHERE Name = :QuoteNumber ];
		Contact c = [SELECT id, Email, OwnerID FROM Contact WHERE id = :q.Contact__c ];
		User u = [SELECT Email, FirstName, LastName, OrgWideEmailAddressID__c FROM user WHERE id = :c.OwnerId];
		EmailTemplate template;
		try 
		{
			template = [SELECT Body, HtmlValue, id, Subject FROM EmailTemplate WHERE DeveloperName = 'Order_Confirmation_Pro_Number_Final_Invoice' ];
		} catch (Exception ex ) {
			template = new EmailTemplate();
			template.HtmlValue = '';
			template.Subject = '';
			//this should not happen at all		
		}
		string HTMLBody = template.HtmlValue;
		string Subject = template.Subject;
		string PlainTextBody = ( template.Body == null ? ' ' : template.Body );


		// replace {!Quote__c.ContactName__c}
		HTMLBody = HTMLBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c); 
		PlainTextBody = PlainTextBody.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		Subject = Subject.replace('{!Quote__c.ContactName__c}',q.ContactName__c );
		  
		// replace {!Quote__c.Order_Number__c}
		HTMLBody = HTMLBody.replace('{!Quote__c.Order_Number__c}',String.valueOf(q.Order_Number__c) ); 
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Order_Number__c}',String.valueOf(q.Order_Number__c)  );
		Subject = Subject.replace('{!Quote__c.Order_Number__c}',String.valueOf(q.Order_Number__c)  );
		  
		// replace {!Quote__c.Calculated_ETA__c}
		string calcEta = ( q.Calculated_ETA__c != null ? STring.valueOf(q.Calculated_ETA__c) : '');
		HTMLBody = HTMLBody.replace('{!Quote__c.Calculated_ETA__c}', calcEta); 
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Calculated_ETA__c}', calcEta  );
		Subject = Subject.replace('{!Quote__c.Calculated_ETA__c}',calcEta  );
		  
		// replace {!Quote__c.Final_Invoice_Amount__c}  
		string finalInvoiceAmount = (q.Final_Invoice_Amount__c != null ? String.valueOf(q.Final_Invoice_Amount__c)   : '');
		HTMLBody = HTMLBody.replace('{!Quote__c.Final_Invoice_Amount__c}',  finalInvoiceAmount  ); 
		PlainTextBody = PlainTextBody.replace('{!Quote__c.Final_Invoice_Amount__c}',finalInvoiceAmount );
		Subject = Subject.replace('{!Quote__c.Final_Invoice_Amount__c}',finalInvoiceAmount  );


		string emailAdd = q.Calculated_Email__c;
		if( emailAdd == null || emailAdd == '' ) emailAdd = c.Email;

		
    		
		Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
		
//		email.setCcAddresses(new string[]{'quotes@nanawall.com'} );
		
//		if (c.Email == 'spamcheck@sitesell.net')
//			email.setSubject('TEST');
//		else
			email.setSubject( Subject );
		email.setHtmlBody( HTMLBody );


		//SELECT Id,Name FROM StaticResource WHERE Name = 'Final_Invoice_Instructions'
		list<Messaging.EmailFileAttachment> objEmailAttachments = new list<Messaging.EmailFileAttachment>();
		Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
		StaticResource objPDF = null;
		if( q.Is_Local__c )
		{
			objPDF = [Select body, name from StaticResource where Name = 'Local_Shipping_Instructions'];
		} else
		{
			objPDF = [Select body, name from StaticResource where Name = 'German_Shipping_Instructions'];
		}
		objPDFAttachment.setBody(objPDF.Body);
		objPDFAttachment.setFileName(objPDF.name + '.pdf');
		objEmailAttachments.add(  objPDFAttachment);		
		
		for( Attachment a : [SELECT Id,Name, Body FROM Attachment WHERE ParentId = :q.Id AND Name = 'finalinvoice.pdf'] )
		{
		     Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		     efa.setFileName(a.Name); // neat - set name of PDF
		     efa.setBody(a.Body); //attach the PDF

			objEmailAttachments.add(efa);	
		}		
		email.setFileAttachments(objEmailAttachments );
		
		email.setPlainTextBody(PlainTextBody);
	//	email.setToAddresses( new String[]{ emailAdd } );
//		email.setToAddresses(new String[] {q.Calculated_Email__c});
		email.setToAddresses( new String[]{'gabepaulson@yahoo.com' } );
//		email.setToAddresses( new String[]{ 'kristian.stout@gmail.com' } );
		email.setReplyTo( u.Email );


  		Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 


/*
		try {
			string oweid = string.valueOf(  u.OrgWideEmailAddressID__c   );
			if( u.OrgWideEmailAddressID__c != null 
			&& oweid != '' )
					email.setOrgWideEmailAddressId( oweid  );
			else  email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
		} catch( Exception ex) {
			Utility.JimDebug(ex, 'caught a sendquoteemail2 error');
			email.setOrgWideEmailAddressId( GlobalStrings.DefaultOrgWideEmailAddressID() );
			Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
		}
*/

	}


	private Quote__c quote = null;
	public Quote_SendFinalInvoice(ApexPages.StandardController controller) 
	{
		if( controller != null && controller.getRecord() != null )
		{
			this.quote = (Quote__c)controller.getRecord();
		}
	}

}