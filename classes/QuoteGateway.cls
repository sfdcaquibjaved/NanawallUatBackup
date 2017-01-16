global with sharing class QuoteGateway {

	webservice static void QuoteViewed(string input)
	{
		try
		{
		XMLDom xmld = new XMLDom(input);
		string QuoteID = xmld.getElementByTagName('QuoteID').getAttribute('Value');
		string browser = xmld.getElementByTagName('Browser').getAttribute('Value');
		//Utility.RegisterQuoteEmailView(  QuoteID,true,browser, false);
		}
		catch (Exception ex)
		{
			Utility.JimDebug(ex,'quote view web service ');
		}	
	}
	 
	webservice static string Get3DFormats()
	{
		NanaQuoteGateway.QuoteGatewaySoap qgs = new NanaQuoteGateway.QuoteGatewaySoap();
		qgs.timeout_x = 60000;
		string ret = qgs.Get3DFormats();
		return ret;
	}
	
	webservice static string GetSolidWorksLink(string input)
	{
		NanaQuoteGateway.QuoteGatewaySoap qgs = new NanaQuoteGateway.QuoteGatewaySoap();
		qgs.timeout_x = 60000;
		string ret = qgs.GetSolidWorksLink(input);
		return ret;
	}
	
	webservice static string HandleQuoteRequest(string input)
	{
		string line='';	
		NanaQuoteGateway.QuoteGatewaySoap qgs = new NanaQuoteGateway.QuoteGatewaySoap();
		qgs.timeout_x = 60000;
		string ret = qgs.HandleQuoteRequest2(input);
		try
		{
		line='1';
		Web_Quote_Detail__c wqd = new Web_Quote_Detail__c();
		wqd.XML__c=ret;
		line='2';
		XMLDom xmld = new XMLDom(ret);
		line='3';
		string key = xmld.getElementByTagName('UniqueKey').getAttribute('Value') ;
		line='4';
		wqd.Name = key;
		wqd.NanaID__c = double.valueOf(key);
		line='5';
		
		string model = xmld.getElementByTagName('Model').getAttribute('Name') ;
		wqd.Model__c = model;
		
		line='6';
		string width_feet = xmld.getElementByTagName('Width').getAttribute('Feet') ;
		wqd.Width_Feet__c = width_feet;
		string width_inches = xmld.getElementByTagName('Width').getAttribute('Inches') ;
		wqd.Width_Inches__c = width_inches;
		string width_numerator = xmld.getElementByTagName('Width').getAttribute('Numerator') ;
		wqd.Width_Numerator__c = width_numerator;
		string width_denominator = xmld.getElementByTagName('Width').getAttribute('Denominator') ;
		wqd.Width_Denominator__c = width_denominator;
		
		line='7';
		string height_feet = xmld.getElementByTagName('Height').getAttribute('Feet') ;
		wqd.Height_Feet__c = height_feet;
		string height_inches = xmld.getElementByTagName('Height').getAttribute('Inches') ;
		wqd.Height_Inches__c = height_inches;
		string height_numerator = xmld.getElementByTagName('Height').getAttribute('Numerator') ;
		wqd.Height_Numerator__c = height_numerator;
		string height_denominator = xmld.getElementByTagName('Height').getAttribute('Denominator') ;
		wqd.Height_Denominator__c = height_denominator;
		
		line = '8';
		string panels = xmld.getElementByTagName('Panels').getAttribute('Count') ;
		wqd.Panels__c = panels;
		string units = xmld.getElementByTagName('Units').getAttribute('Value') ;
		wqd.Units__c = units;
		
		List<XMLDom.Element> configs = xmld.getElementsByTagName('Configuration');
		string configleft='';
		string configright='';
		for (XMLDom.Element e : configs)
		{
			if (e.getAttribute('Selected') == 'True')
			{
				configleft = e.getAttribute('Left');
				configright = e.getAttribute('Right');
			}
		}
		
		wqd.Config_Left__c = configleft;
		wqd.Config_Right__c = configright;
		
		Upsert wqd NanaID__c;
		}
		catch (Exception ex)
		{
			Utility.JimDebug(ex, 'handling quote request ' + line + ' ' + input );
		}
		return ret; 
	}

	webservice static string CreateWebQuote_test(string input)
	{
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com', 'kristian.stout@gmail.com'}; 
		mail.setToAddresses( toAddresses );
		mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
		mail.setSenderDisplayName('CreateWebQuote Messager');
		mail.setSubject(' CreateWebQuote debug message '  );
		mail.setBccSender(false);
		mail.setUseSignature(false);
		mail.setPlainTextBody(input);
		mail.setHtmlBody(input);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
		
		return '<Root><ReturnCode Value="1" Error="Test Error. Trying to debug the Web Quote"/></Root>';
		
	}

	webservice static string CreateWebQuote(string input)
	{
Utility.JimDebug(null, 'Create WebQuote started');
/*
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com', 'kristian.stout@gmail.com'}; 
mail.setToAddresses( toAddresses );
mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
mail.setSenderDisplayName('CreateWebQuote Messager');
mail.setSubject(' CreateWebQuote debug message '  );
mail.setBccSender(false);
mail.setUseSignature(false);
mail.setPlainTextBody('Create WebQuote started');
mail.setHtmlBody('Create WebQuote started');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
	*/	
		string line='';	
		string ret='';
		XMLDom xmld = null;
		try
		{
			xmld = new XMLDom(input);
		}
		catch (Exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
			Utility.JimDebug(ex, 'xml parse error');
		}
		string personid = '';
		string iscontact='';

//		try
		{
			personid = xmld.getElementByTagName('LeadID').getAttribute('Value');
			iscontact = xmld.getElementByTagName('LeadID').getAttribute('IsContact');
		}
/*		catch (Exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
			Utility.JimDebug(ex, 'leadid does not exist');
		}
	*/


Utility.JimDebug(null, 'WebQuote: personid = ' +personid + '; iscontact = ' + iscontact );
	
	/*
mail = new Messaging.SingleEmailMessage();
toAddresses = new String[] {'james.appenzeller@a-stechnologies.com', 'kristian.stout@gmail.com'}; 
mail.setToAddresses( toAddresses );
mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
mail.setSenderDisplayName('CreateWebQuote Messager');
mail.setSubject(' CreateWebQuote debug message '  );
mail.setBccSender(false);
mail.setUseSignature(false);
mail.setPlainTextBody( 'WebQuote: personid = ' +personid + '; iscontact = ' + iscontact );
mail.setHtmlBody( 'WebQuote: personid = ' +personid + '; iscontact = ' + iscontact );
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
*/

		Web_Quote__c wq = new Web_Quote__c();
		Account a = null;
		Boolean accountCreated = false;
		Contact c= null;
//		try
		{
			if (iscontact=='True')
			{
				wq.Contact__c = personid;
			}
			else
			{
				accountCreated = true;
				Lead l = [select id,company,name,OwnerID,Zip__c,
				nrCountry__c,Phone,Address_1__c,
				CountryCode,PostalCode, Street, City, StateCode,
				Address_2__c,nrCity__c,nrState__c,LeadSource,
				Reg_Number__c,Source_Date__c,Newsletter__c,
				Competitor__c,Office_Ext__c,HomePhone__c,OtherPhone__c,
				Interest__c,Type__c,Please_Contact__c,How_did_you_hear_about_us__c,
				Mail_Info__c,Please_enter_questions_requests_or_comm__c,
				Email_Newsletter__c,NanaWall_Applications_of_Interest_y__c,
				Send_Booklet__c,Which_best_describes_role__c,Name_of_Project__c,
				Description,MobilePhone__c, Email, 
				ConvertedAccountId,ConvertedContactId,IsConverted 
				FROM Lead where id= :personid];
				
				if( !l.isconverted )
				{
					a = new Account();
					if (l.company !=null && l.company !='')
		            	a.Name =  l.company;
		           	else
		           	{
		           		a.Name = l.name;
		           		l.company = l.name;
		           		update l;
		           	}          
	
		            a.OwnerId = l.OwnerId;
//		            a.Zip__c = l.Zip__c;
		            a.BillingPostalCode = l.PostalCode;
		            a.ShippingPostalCode = l.PostalCode;
		            //a.Country__c = l.nrCountry__c;
		            a.BillingCountryCode = l.CountryCode;
		            a.ShippingPostalCode = l.CountryCode;
		            
		            a.DoNotAutoAssignOwner__c = true;
		            a.Phone = l.Phone;
		            a.Competitor__c = l.Competitor__c;
					insert a;
			//		Utility.FutureCallAccountWebService(a.Id);
					
					string correctemail = l.email;
//					l.email = '';
					l.Is_Converting__c = true;


Utility.JimDebug(null,  'WebQuote Pre-Convert: ' + l.Id + ' ; CountryCode = '+l.CountryCode+'; PostalCode = '+l.PostalCode+'; StateCode = ' + l.StateCode + ' ; Owner = ' + l.OwnerId );
					update l; //this gets us past the stupid duplicate email trigger problem - ks
					
Utility.JimDebug(null, 'WebQuote: calling leadconvert ' );
					/*
mail = new Messaging.SingleEmailMessage();
toAddresses = new String[] {'james.appenzeller@a-stechnologies.com', 'kristian.stout@gmail.com'}; 
mail.setToAddresses( toAddresses );
mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
mail.setSenderDisplayName('CreateWebQuote Messager');
mail.setSubject(' CreateWebQuote debug message '  );
mail.setBccSender(false);
mail.setUseSignature(false);
mail.setPlainTextBody( 'WebQuote: calling leadconvert ' );
mail.setHtmlBody( 'WebQuote: calling leadconvert ' );
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
					*/
					
					Database.LeadConvert lc = new database.LeadConvert();
		            lc.setDoNotCreateOpportunity( true );
		            lc.setLeadId(l.Id);
		            lc.setAccountId(a.Id);
		            lc.setOverwriteLeadSource(false);
		            lc.setSendNotificationEmail(false);
		            
		            LeadStatus convertstatus = [select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
		            lc.setConvertedStatus(convertStatus.MasterLabel);
		        	line ='before convert';
		            Database.LeadConvertResult result = Database.convertLead(lc);
		            line ='after convert';
		            c = [SELECT id, OwnerId FROM Contact WHERE id = :result.getContactId()];
Utility.JimDebug(null, 'WebQuote: after convert owner of Contact =   '+ c.OwnerId );
		            
		            c.MailingStreet = l.Street;
		            c.MailingCity = l.City;
		            c.MailingStateCode = l.StateCode;
		            c.MailingPostalCode = l.PostalCode;
		            c.MailingCountryCode = l.CountryCode;


		            c.OtherStreet = l.Street;
		            c.OtherCity = l.City;
		            c.OtherStateCode = l.StateCode;
		            c.OtherPostalCode = l.PostalCode;
		            c.OtherCountryCode = l.CountryCode;

//		            c.Address_1__c = l.Address_1__c;
//		            c.Address_2__c = l.Address_2__c;
//		            c.City__c = l.nrCity__c;
//		            c.State__c = l.nrState__c;
//		            c.Zip__c = l.Zip__c;
//		            c.Country__c = l.nrCountry__c;
		            
		            c.LeadSource = l.LeadSource;
		        //    c.NanaID__c = l.NanaID__c;
		            c.Reg_Number__c = l.Reg_Number__c;
		            c.Source_Date__c = l.Source_Date__c;
		            c.Newsletter__c = l.Newsletter__c;
		           
		            c.Office_Ext__c = l.Office_Ext__c;
		            c.HomePhone = l.HomePhone__c;
		            c.OtherPhone = l.OtherPhone__c;
		            c.Interest__c = l.Interest__c;
		            c.LeadType__c=l.Type__c;
		            c.Please_Contact__c = l.Please_Contact__c;
		            c.How_did_you_hear_about_us__c = l.How_did_you_hear_about_us__c;
		            c.Mail_Info__c = l.Mail_Info__c;
		            c.Please_enter_questions_requests_or_comm__c = l.Please_enter_questions_requests_or_comm__c;
		            c.Email_Newsletter__c = l.Email_Newsletter__c;
		            c.NanaWall_Applications_of_Interest__c = l.NanaWall_Applications_of_Interest_y__c;                              
		            c.Send_Booklet__c = l.Send_Booklet__c;
		            c.Which_best_describes_role__c = l.Which_best_describes_role__c;
		            c.Target_Date_for_Project__c = l.Name_of_Project__c;
		            c.Description = l.Description;
		            c.MobilePhone = l.MobilePhone__c;
		            c.OwnerId = l.OwnerId;
		            c.email = correctemail;
		            
		            update c;
		           // Utility.FutureCallContactWebService(c.id);
		            wq.Contact__c = c.Id;
				} else
				{
Utility.JimDebug(null, 'WebQuote: lead was already converted:  ' + l.ConvertedContactId);
					
					/*
mail = new Messaging.SingleEmailMessage();
toAddresses = new String[] {'james.appenzeller@a-stechnologies.com', 'kristian.stout@gmail.com'}; 
mail.setToAddresses( toAddresses );
mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
mail.setSenderDisplayName('CreateWebQuote Messager');
mail.setSubject(' CreateWebQuote debug message '  );
mail.setBccSender(false);
mail.setUseSignature(false);
mail.setPlainTextBody(  'WebQuote: lead was already converted:  ' + l.ConvertedContactId );
mail.setHtmlBody( 'WebQuote: lead was already converted:  ' + l.ConvertedContactId );
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
					*/
					
					wq.Contact__c = l.ConvertedContactId;
					//ConvertedAccountId,ConvertedContactId,IsConverted
				}
			}



			if (xmld.getElementByTagName('Name') !=null)
            	wq.Project_Name__c = xmld.getElementByTagName('Name').getAttribute('Value');
            else
            	wq.Project_Name__c = 'default name';
            if (xmld.getElementByTagName('Address')!=null)
            	wq.Project_Address__c=xmld.getElementByTagName('Address').getAttribute('Value');
            if (xmld.getElementByTagName('City')!=null)	
				wq.Project_City__c = xmld.getElementByTagName('City').getAttribute('Value');
			if (xmld.getElementByTagName('State')!=null)
				wq.Project_State__c = xmld.getElementByTagName('State').getAttribute('Value');
			if (xmld.getElementByTagName('Zip')!=null)
				wq.Project_Zip__c = xmld.getElementByTagName('Zip').getAttribute('Value');
			if (xmld.getElementByTagName('Country')!=null)
				wq.Project_Country__c = xmld.getElementByTagName('Country').getAttribute('Value');
			if (xmld.getElementByTagName('Type')!=null)
				wq.Project_Type__c = xmld.getElementByTagName('Type').getAttribute('Value');
			if (xmld.getElementByTagName('Comments')!=null)
				wq.Project_Comments__c = xmld.getElementByTagName('Comments').getAttribute('Value');
		}
		/*
		catch (exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
			        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
        mail.setSenderDisplayName('quotegateway error');
        mail.setSubject(' quotegateway error '  );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' converting lead problem ' + ex.getMessage());
        mail.setHtmlBody(' converting lead problem '  + ex.getMessage());
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
	//		Utility.JimDebug(ex, 'converting lead problem' + line);
		}
*/		
		if(wq.Contact__c == null )
		{ //we do not want to insert web quotes with null contacts
Utility.JimDebug(null, 'WebQuote: webquote contact was null. Return an error. ');
			
			/*
mail = new Messaging.SingleEmailMessage();
toAddresses = new String[] {'james.appenzeller@a-stechnologies.com', 'kristian.stout@gmail.com'}; 
mail.setToAddresses( toAddresses );
mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
mail.setSenderDisplayName('CreateWebQuote Messager');
mail.setSubject(' CreateWebQuote debug message '  );
mail.setBccSender(false);
mail.setUseSignature(false);
mail.setPlainTextBody(  'WebQuote: webquote contact was null. Return an error. ' );
mail.setHtmlBody( 'WebQuote: webquote contact was null. Return an error. ' );
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
		*/
		
			if( accountCreated && a != null )
				delete a; //we inserted the account in this pass and need to clean it up because we found out the contact is null
			
			ret='<Root><ReturnCode Value="1" Error="The Contact was null"/></Root>';
//			Utility.JimDebug(null,'inserting web quote'); //can i do this with null ?
			return ret;
		}
		
//		try
		{
Utility.JimDebug(null, 'WebQuote: inserting web quote ');
			/*
mail = new Messaging.SingleEmailMessage();
toAddresses = new String[] {'james.appenzeller@a-stechnologies.com', 'kristian.stout@gmail.com'}; 
mail.setToAddresses( toAddresses );
mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
mail.setSenderDisplayName('CreateWebQuote Messager');
mail.setSubject(' CreateWebQuote debug message '  );
mail.setBccSender(false);
mail.setUseSignature(false);
mail.setPlainTextBody(  'WebQuote: inserting web quote ');
mail.setHtmlBody( 'WebQuote: inserting web quote ' );
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
		*/
		
		Insert(wq);
		}
		/*
		catch (exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
									        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
        mail.setSenderDisplayName('quotegateway error');
        mail.setSubject(' quotegateway error '  );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' web quote problem ' + ex.getMessage());
        mail.setHtmlBody(' web quote problem '  + ex.getMessage());
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
		}	
		*/
		
		string ev=''; 
//		try
		{
			Web_Quote__c wq2 = [select id,ownerid from web_quote__c where id =: wq.id limit 1]; 
			for (XMLDom.Element elem : xmld.getElementsByTagName('ID'))
			{
				line='1';
				ev = elem.getAttribute('Value');
				double d = double.valueOf(elem.getAttribute('Value'));
				line='2';
				Web_Quote_Detail__c wqd = [select id from Web_Quote_Detail__c where NanaID__c =:d];
				wqd.Web_Quote__c = wq.Id;
				wqd.OwnerId = wq2.OwnerId; 
				Upsert wqd;
			}
		}
		/*
		catch (exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
						        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
        mail.setSenderDisplayName('quotegateway error');
        mail.setSubject(' quotegateway error '  );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' web quote detail problem ' + ex.getMessage());
        mail.setHtmlBody(' web quote detail problem '  + ex.getMessage());
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
			//Utility.JimDebug(ex,'trying to update web quote details ' + ev + ' ' + line);
		}
		*/
		
Utility.JimDebug(null, 'WebQuote: all done.  ' );
		/*
mail = new Messaging.SingleEmailMessage();
toAddresses = new String[] {'james.appenzeller@a-stechnologies.com', 'kristian.stout@gmail.com'}; 
mail.setToAddresses( toAddresses );
mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
mail.setSenderDisplayName('CreateWebQuote Messager');
mail.setSubject(' CreateWebQuote debug message '  );
mail.setBccSender(false);
mail.setUseSignature(false);
mail.setPlainTextBody( 'WebQuote: all done.  ');
mail.setHtmlBody( 'WebQuote: all done.  ' );
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
		*/
		
		if (ret=='')
			ret='<Root><ReturnCode Value="0" Error=""/><ContactID Value="' + wq.Contact__c + '"/><WebQuoteID Value="' + wq.Id + '"/></Root>';
		return ret;
	} 
	
	webservice static string CreateWebQuote_old(string input)
	{
		string line='';	
		string ret='';
		XMLDom xmld = null;
		try
		{
			xmld = new XMLDom(input);
		}
		catch (Exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
			Utility.JimDebug(ex, 'xml parse error');
		}
		string personid = '';
		string iscontact='';
		try
		{
			personid = xmld.getElementByTagName('LeadID').getAttribute('Value');
			iscontact = xmld.getElementByTagName('LeadID').getAttribute('IsContact');
		}
		catch (Exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
			Utility.JimDebug(ex, 'leadid does not exist');
		}
				
		Web_Quote__c wq = new Web_Quote__c();
		Account a = null;
		Boolean accountCreated = false;
		Contact c= null;
		try
		{
			if (iscontact=='True')
			{
				wq.Contact__c = personid;
			}
			else
			{
				accountCreated = true;
				Lead l = [select id,company,name,OwnerID,Zip__c,nrCountry__c,Phone,Address_1__c,
				Address_2__c,nrCity__c,nrState__c,LeadSource,
				Reg_Number__c,Source_Date__c,Newsletter__c,
				Competitor__c,Office_Ext__c,HomePhone__c,OtherPhone__c,
				Interest__c,Type__c,Please_Contact__c,How_did_you_hear_about_us__c,
				Mail_Info__c,Please_enter_questions_requests_or_comm__c,
				Email_Newsletter__c,NanaWall_Applications_of_Interest_y__c,
				Send_Booklet__c,Which_best_describes_role__c,Name_of_Project__c,
				Description,MobilePhone__c, Email, 
				ConvertedAccountId,ConvertedContactId,IsConverted 
				FROM Lead where id= :personid];
				
				if( !l.isconverted )
				{
					a = new Account();
					if (l.company !=null && l.company !='')
		            	a.Name =  l.company;
		           	else
		           	{
		           		a.Name = l.name;
		           		l.company = l.name;
		           		update l;
		           	}          
	
		            a.OwnerId = l.OwnerId;
		            a.Zip__c = l.Zip__c;
		            a.Country__c = l.nrCountry__c;
		            a.DoNotAutoAssignOwner__c = true;
		            a.Phone = l.Phone;
		            a.Competitor__c = l.Competitor__c;
					insert a;
			//		Utility.FutureCallAccountWebService(a.Id);
					
					string correctemail = l.email;
//					l.email = '';
					l.Is_Converting__c = true;

					update l; //this gets us past the stupid duplicate email trigger problem - ks
					
					Database.LeadConvert lc = new database.LeadConvert();
		            lc.setDoNotCreateOpportunity( true );
		            lc.setLeadId(l.Id);
		            lc.setAccountId(a.Id);
		            lc.setOverwriteLeadSource(false);
		            lc.setSendNotificationEmail(false);
		            
		            LeadStatus convertstatus = [select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
		            lc.setConvertedStatus(convertStatus.MasterLabel);
		        	line ='before convert';
		            Database.LeadConvertResult result = Database.convertLead(lc);
		            line ='after convert';
		            c = [SELECT id FROM Contact WHERE id = :result.getContactId()];
		            c.Address_1__c = l.Address_1__c;
		            c.Address_2__c = l.Address_2__c;
		            c.City__c = l.nrCity__c;
		            c.State__c = l.nrState__c;
		            c.Zip__c = l.Zip__c;
		            c.Country__c = l.nrCountry__c;
		            c.LeadSource = l.LeadSource;
		        //    c.NanaID__c = l.NanaID__c;
		            c.Reg_Number__c = l.Reg_Number__c;
		            c.Source_Date__c = l.Source_Date__c;
		            c.Newsletter__c = l.Newsletter__c;
		           
		            c.Office_Ext__c = l.Office_Ext__c;
		            c.HomePhone = l.HomePhone__c;
		            c.OtherPhone = l.OtherPhone__c;
		            c.Interest__c = l.Interest__c;
		            c.LeadType__c=l.Type__c;
		            c.Please_Contact__c = l.Please_Contact__c;
		            c.How_did_you_hear_about_us__c = l.How_did_you_hear_about_us__c;
		            c.Mail_Info__c = l.Mail_Info__c;
		            c.Please_enter_questions_requests_or_comm__c = l.Please_enter_questions_requests_or_comm__c;
		            c.Email_Newsletter__c = l.Email_Newsletter__c;
		            c.NanaWall_Applications_of_Interest__c = l.NanaWall_Applications_of_Interest_y__c;                              
		            c.Send_Booklet__c = l.Send_Booklet__c;
		            c.Which_best_describes_role__c = l.Which_best_describes_role__c;
		            c.Target_Date_for_Project__c = l.Name_of_Project__c;
		            c.Description = l.Description;
		            c.MobilePhone = l.MobilePhone__c;
		            c.OwnerId = l.OwnerId;
		            c.email = correctemail;
		            
		            update c;
		           // Utility.FutureCallContactWebService(c.id);
		            wq.Contact__c = c.Id;
				} else
				{
					wq.Contact__c = l.ConvertedContactId;
					//ConvertedAccountId,ConvertedContactId,IsConverted
				}
			}



			if (xmld.getElementByTagName('Name') !=null)
            	wq.Project_Name__c = xmld.getElementByTagName('Name').getAttribute('Value');
            else
            	wq.Project_Name__c = 'default name';
            if (xmld.getElementByTagName('Address')!=null)
            	wq.Project_Address__c=xmld.getElementByTagName('Address').getAttribute('Value');
            if (xmld.getElementByTagName('City')!=null)	
				wq.Project_City__c = xmld.getElementByTagName('City').getAttribute('Value');
			if (xmld.getElementByTagName('State')!=null)
				wq.Project_State__c = xmld.getElementByTagName('State').getAttribute('Value');
			if (xmld.getElementByTagName('Zip')!=null)
				wq.Project_Zip__c = xmld.getElementByTagName('Zip').getAttribute('Value');
			if (xmld.getElementByTagName('Country')!=null)
				wq.Project_Country__c = xmld.getElementByTagName('Country').getAttribute('Value');
			if (xmld.getElementByTagName('Type')!=null)
				wq.Project_Type__c = xmld.getElementByTagName('Type').getAttribute('Value');
			if (xmld.getElementByTagName('Comments')!=null)
				wq.Project_Comments__c = xmld.getElementByTagName('Comments').getAttribute('Value');
		}
		catch (exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
			        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
        mail.setSenderDisplayName('quotegateway error');
        mail.setSubject(' quotegateway error '  );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' converting lead problem ' + ex.getMessage());
        mail.setHtmlBody(' converting lead problem '  + ex.getMessage());
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
	//		Utility.JimDebug(ex, 'converting lead problem' + line);
		}
		
		if(wq.Contact__c == null )
		{ //we do not want to insert web quotes with null contacts
			
			if( accountCreated && a != null )
				delete a; //we inserted the account in this pass and need to clean it up because we found out the contact is null
			
			ret='<Root><ReturnCode Value="1" Error="The Contact was null"/></Root>';
//			Utility.JimDebug(null,'inserting web quote'); //can i do this with null ?
			return ret;
		}
		
		try
		{
		Insert(wq);
		}
		catch (exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
									        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
        mail.setSenderDisplayName('quotegateway error');
        mail.setSubject(' quotegateway error '  );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' web quote problem ' + ex.getMessage());
        mail.setHtmlBody(' web quote problem '  + ex.getMessage());
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
		}	
		string ev=''; 
		try
		{
			Web_Quote__c wq2 = [select id,ownerid from web_quote__c where id =: wq.id limit 1]; 
			for (XMLDom.Element elem : xmld.getElementsByTagName('ID'))
			{
				line='1';
				ev = elem.getAttribute('Value');
				double d = double.valueOf(elem.getAttribute('Value'));
				line='2';
				Web_Quote_Detail__c wqd = [select id from Web_Quote_Detail__c where NanaID__c =:d];
				wqd.Web_Quote__c = wq.Id;
				wqd.OwnerId = wq2.OwnerId; 
				Upsert wqd;
			}
		}
		catch (exception ex)
		{
			ret='<Root><ReturnCode Value="1" Error="' + ex.getMessage()  + '"/></Root>';
						        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('james.appenzeller@a-stechnologies.com');   
        mail.setSenderDisplayName('quotegateway error');
        mail.setSubject(' quotegateway error '  );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' web quote detail problem ' + ex.getMessage());
        mail.setHtmlBody(' web quote detail problem '  + ex.getMessage());
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
			//Utility.JimDebug(ex,'trying to update web quote details ' + ev + ' ' + line);
		}
		if (ret=='')
			ret='<Root><ReturnCode Value="0" Error=""/><ContactID Value="' + wq.Contact__c + '"/><WebQuoteID Value="' + wq.Id + '"/></Root>';
		return ret;
	} 
}