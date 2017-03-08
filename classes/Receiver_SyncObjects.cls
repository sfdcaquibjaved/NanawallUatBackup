global public class Receiver_SyncObjects {


	WebService static boolean SyncAccounts( list<Id> accountIds) {
		/*
    */
	    try {
			set<Id> ids = new set<Id>();    	
			for( String i : accountIds )
			{
				if( i != null && i != '' )
					ids.add( i );
			}
			Async_WebServiceCaller.SynchronizeAccounts( ids ); 
			
			return true;
	    } catch( Exception ex )
	    {
	    	/*
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
			mail.setToAddresses( toAddresses );
			mail.setReplyTo('admin@a-stechnologies.com');   
			mail.setSenderDisplayName('Salesforce - Nana ASync Department');
			mail.setSubject('Bulk Account Sync Failure');
			mail.setBccSender(false);
			mail.setUseSignature(false);
			mail.setPlainTextBody( '' + ex);
			mail.setHtmlBody( '' + ex  );
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });     			
			*/
			Utility.JimDebug(ex, 'async flush accounts');
			
	    	return false;
	    }
	    
	}
	
	WebService static boolean SyncContacts( list<Id> contactIds) {
		try {
			set<Id> ids = new set<Id>();
	  			
			for( String i : contactIds )
			{
				if( i != null && i != '' )
					ids.add( i );
			}
			Async_WebServiceCaller.SynchronizeContacts(ids );
			
			return true;
		} catch( Exception ex )		
		{
			/*
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
			mail.setToAddresses( toAddresses );
			mail.setReplyTo('admin@a-stechnologies.com');   
			mail.setSenderDisplayName('Salesforce - Nana ASync Department');
			mail.setSubject('Bulk Contact Sync failure');
			mail.setBccSender(false);
			mail.setUseSignature(false);
			mail.setPlainTextBody( ''+ex );
			mail.setHtmlBody( ''+ ex );
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   	
*/
			Utility.JimDebug(ex, 'async flush contacts' );
		
			return false;
		}
	}	
}