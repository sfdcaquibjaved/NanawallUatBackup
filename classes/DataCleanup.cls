global class DataCleanup implements Schedulable{

	public static void cleanupPerformanceTasks() 
	{
		 //clean up any dupliucate performance label tasks
		 date d = system.today().addDays(-5); 
		 list<Task> perfTasks = [SELECT Id, Subject, WhoId, WhatId, Description FROM Task WHERE Subject = 'Performance Label' AND CreatedDate > :d	 ];
		 map<string, list<Task> > perfTaskMap = new map<string, list<Task>>();
		 for( Task t: perfTasks ) 
		 {
		 	if( !perfTaskMap.containsKey(t.WhatId+'_'+t.Description) )
		 		perfTaskMap.put( t.WhatId+'_'+t.Description, new list<Task>() );
		 		
	 		perfTaskMap.get(t.WhatId+'_'+t.Description).add(t);
		 }
		 System.debug( perfTaskMap.keySet().size() + ' quote details to check for dupes. ' );
	
		list<Task> perfTasksToDelete = new list<Task>();
		for( string i : perfTaskMap.keySet()  )
		{
			if( perfTaskMap.get(i).size() > 1 )
			{
				integer tasksSeen = 0;
				for( Task t : perfTaskMap.get(i) )
				{
					if( tasksSeen++ > 0 )
						perfTasksToDelete.add( t );
				}
			}
		}
		
		System.debug('Got '  + perfTasksToDelete.size() +' tasks need to be deleted.');
		
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
	        mail.setToAddresses( toAddresses );
	        mail.setReplyTo('admin@a-stechnologies.com');   
	        mail.setSenderDisplayName('Salesforce - perf task cleaner');
	        mail.setSubject('Cleaning performance tasks -- i cleaned ' + perfTasksToDelete.size() + ' total tasks' );
	        mail.setBccSender(false); 
	        mail.setUseSignature(false); 
	        mail.setPlainTextBody(' There were ' +  perfTaskMap.keySet().size()+ ' total quote details involved and ' + perfTasksToDelete.size() + ' total tasks'  );
	        mail.setHtmlBody('  '  );
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
		
		delete perfTasksToDelete;
	}
	
	
	global void execute(SchedulableContext SC) {
		
		
		cleanupPerformanceTasks();
		
		
		 List<Task> tl = [select id,subject,status,createddate from task  
		 	where  createddate < last_n_days:13 and (subject='quote rep followup' 
		 	or subject='quote office followup') and status ='not started'];
		for (Task t : tl)
		{
			t.Status='Completed';  
		} 
		 //update tl; 
	 
		/*
	 try
	 {
	 	//clean up any opporrunity's whose accounts are no longer principals
	 	list<Opportunity> oppsToBlankAccountID = new list<Opportunity>(); 
	 	for( Opportunity o : [SELECT Id, AccountID, Account.Type FROM Opportunity WHERE Account.Type != 'Principal' AND Account.Type != NULL] )
	 	{
	 		o.AccountID = null;
	 		oppsToBlankAccountID.add(o);
	 	}
	 	if( oppsToBlankAccountID.size() > 0 )
	 		update oppsToBlankAccountID;
	 } catch(Exception ex )
	 {
	 	
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
	        mail.setToAddresses( toAddresses );
	        mail.setReplyTo('admin@a-stechnologies.com');   
	        mail.setSenderDisplayName('Salesforce - DateCleanup');
	        mail.setSubject('I hit an exception trying to blank out AccountIDs on opportunities' );
	        mail.setBccSender(false); 
	        mail.setUseSignature(false); 
	        mail.setPlainTextBody(' ' + ex  );
	        mail.setHtmlBody('  ' + ex );
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
	 }
	 
	 
		try {  
			List<Opportunity> closingOpps = [SELECT id, iswon, isclosed FROM opportunity WHERE closedate < last_n_days:100 AND StageName !='Closed - Inactivity' AND StageName !='Order Process Started' and isclosed = false AND Is_A_Dupe__c = false LIMIT 100];
		 	for( Opportunity o : closingOpps ) 
		 	{	 		
		 		o.stagename = 'Quotes Passed Expected Resolution Date';
		 		//o.Reason_Opportunity_Lost__c = 'Other';
		 	}
		 	update closingOpps; 
		 } catch( Exception ex )
		 {
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
	        mail.setToAddresses( toAddresses );
	        mail.setReplyTo('admin@a-stechnologies.com');   
	        mail.setSenderDisplayName('Salesforce - create trigger');
	        mail.setSubject('Cron Close Date - Problem closing old projects ' );
	        mail.setBccSender(false); 
	        mail.setUseSignature(false); 
	        mail.setPlainTextBody(' ' + ex  );
	        mail.setHtmlBody('  ' + ex );
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
		 }	 
		 */
		try {  
			
			List<Service_Part_Inventory_Lock__c> expiredLocks = [SELECT id FROM Service_Part_Inventory_Lock__c WHERE CreatedDate < LAST_N_DAYS:30 AND ( Status__c = 'Active' OR Status__c = 'Pending' OR Status__c = 'Pendings')   ];
		 	for( Service_Part_Inventory_Lock__c lock : expiredLocks )
		 	{	 		
				lock.Status__c = 'Dismissed';
		 	}
		 	
		 	if( expiredLocks.size() > 0 )
		 	{
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
		        mail.setToAddresses( toAddresses );
		        mail.setReplyTo('admin@a-stechnologies.com');   
		        mail.setSenderDisplayName('Salesforce - Data Cleanup');
		        mail.setSubject('Salesforce service part locks. ' + expiredLocks.size() +' were dismissed.' );
		        mail.setBccSender(false); 
		        mail.setUseSignature(false);
		        mail.setPlainTextBody('  ' + expiredLocks.size() + ' locks were dismissed.');
		        mail.setHtmlBody('  ' + expiredLocks.size() + ' locks were dismissed.');
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
		        
			 	update expiredLocks;

		 	} else
		 	{
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
		        mail.setToAddresses( toAddresses );
		        mail.setReplyTo('admin@a-stechnologies.com');   
		        mail.setSenderDisplayName('Salesforce - Data Cleanup');
		        mail.setSubject('Salesforce service part locks. NO LOCKS FOUND' );
		        mail.setBccSender(false); 
		        mail.setUseSignature(false);
		        mail.setPlainTextBody(' NO LOCKS FOUND.');
		        mail.setHtmlBody('  NO LOCKS FOUND.');
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      		 	
		 	} 
		 } catch( Exception ex )
		 {
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
	        mail.setToAddresses( toAddresses );
	        mail.setReplyTo('admin@a-stechnologies.com');   
	        mail.setSenderDisplayName('Salesforce - Data Cleanup');
	        mail.setSubject('Data cleanup  - problem dismissing stale locks' );
	        mail.setBccSender(false); 
	        mail.setUseSignature(false);
	        mail.setPlainTextBody(' ' + ex  );
	        mail.setHtmlBody('  ' + ex );
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
		 }	 
		 
	}
}