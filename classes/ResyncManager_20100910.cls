global class ResyncManager_20100910 {
//global class ResyncManager_20100910 implements Schedulable {

/*
object to create in production: 
Application_Setting__c
	Setting_Name__c
	Setting_Value__c 
	

Resync_Job__c
	object_type__c
	object_id__c
	finished__c
	CreatedDate 


*/

/*
	global class ResyncException extends Exception {
		public string section = '';
		public void setSection( string s ) { section = s ; }
		public string getSection() { return section; }
		
		public string Description = '';
		public void setDescription( string s ) { description = s; }
		public string getDescription() { return description; }
		
		public Exception originalException = null;
		public void setOriginalException( Exception ex ) { originalException = ex; }
		public Exception getOriginalException() { return originalException; }
	}


	global static void emailException( list<ResyncException> exceptions ){
	
		string summary = '';
		for( ResyncException ex : exceptions )
		{
			summary += 'Section: ' + ex.getSection() + '<br />\n' ;
			summary +=  ex.getTypeName() + '<br />\n' ;
			summary += ex.getMessage() + '<br />\n' ;
			summary += ex.getCause() + '<br />\n';
			summary += ex.getDescription() + '<hr width="100%" />';
		}
	
			//this should not happen. 
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
			mail.setToAddresses( toAddresses );
			mail.setReplyTo('admin@a-stechnologies.com');   
			mail.setSenderDisplayName('Salesforce - Nana Sync Department');
			mail.setSubject('ResyncManager_20100910.execute() encountered a problem during it\'s run at ' + DateTime.now().formatLong()  );
			mail.setBccSender(false);
			mail.setUseSignature(false);
			mail.setPlainTextBody(' Exception Information <br /><hr width="100%" /><br /> ' + summary   );
			mail.setHtmlBody(' Exception Information <br /><hr width="100%" /><br /> ' + summary );
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });            

	}
	
	@future (callout=true)
	global static void callWebService( string ObjectType, string ObjectID, string JobID ) {

		try {		
			if( ObjectType == 'Contact' )
			{ 
				WebServiceCaller.CallContactWebService( ObjectID );
	
			} else if( ObjectType == 'Opportunity' )
			{
				WebServiceCaller.CallOpportunityWebService(ObjectID, false);
			
			} else if( ObjectType == 'Account' )
			{
		            WebServiceCaller.CallAccountWebService(ObjectID);
			}
			Resync_Job__c j = [ SELECT id FROM Resync_Job__c WHERE id = :JobID ];			
			j.finished__c = true;
			update j;
		} catch( Exception ex ) {
			ResyncException re = new ResyncException();
			re.setOriginalException( ex);
			re.setSection('@future WebService call ');
			re.setdescription( ex + ' '  );
				
			ResyncManager_20100910.emailException( new ResyncException[] { re } );		
		}
	}

	private static string cronKey = 'ResyncManager_20100910';
	public static string getcronkey() { return cronkey; }
	global void execute(SchedulableContext SC) { 

//ResyncException tracer = new ResyncException();

		//maximum of 10 web service calls at a time
		//select objecttype, objectid from resyncqueue
		//do 10
		list<Resync_Job__c> jobs = new List<REsync_job__c>();
		string trace = '';
		list<ResyncException> exceptions = new List<ResyncException>();
		
		try {
			jobs = [ SELECT id, object_type__c, object_id__c, finished__c, CreatedDate FROM Resync_Job__c WHERE Finished__c = false ORDER BY CreatedDate DESC LIMIT 20 ];
		} catch( Exception ex )
		{
			//the sync still failed, dont update it to finished so it will re-run
			ResyncException re = new ResyncException();
			re.setOriginalException( ex);
			re.setSection(' looking for jobs to process ');
			re.setdescription( ex + ' '  );
			exceptions.add(  re  );
			
			trace += ex + '<br />';
		}		
		integer totalJobs = jobs.size();
		integer jobsRun = 0;
		for( Resync_Job__c j : jobs )
		{			
			try 
			{
				ResyncManager_20100910.callWebService( j.Object_Type__c, j.Object_ID__c, j.id );

				if( jobsRun++ >= 20 ) break;
			} catch(Exception ex ) 
			{
				//the sync still failed, dont update it to finished so it will re-run
				ResyncException re = new ResyncException();
				re.setOriginalException( ex);
				re.setSection('firing off of webservice call ');
				re.setdescription( ex + ' '  );
				exceptions.add(  re  );
				
				trace += ex + '<br />';
			}
		}
		
 		
		try {
			
			//the below should kill the currentluy scheduled 
			Application_Setting__c cronSetting = [SELECT Setting_Name__c, Setting_Value__c FROM Application_Setting__c WHERE Setting_Name__c = :ResyncManager_20100910.getcronKey() ];

			if( cronSetting != null )
			{ 	//this should only be triggered when there is no Setting for the job
				//this will get recreated byt he insertScheduler call below
				System.abortJob( cronSetting.setting_value__c );		
				delete cronSetting;
			}
		} catch(Exception ex ) {
			ResyncException re = new ResyncException();
			re.setOriginalException( ex);
			re.setSection('Killing old cronKey Application_Setting__c');
			re.setdescription( ex + '  ');
			exceptions.add(  re  );
			trace += ex + '<br />';			
		
		}

		try {

//			if( jobs.size()  > 0 ) 
			if( (totalJobs-jobsRun) > 0  )   
			{ //this will keep running until the jobs list is 0 length which will happen after all of the @future's successfully complete
				trace +=  'found at least ' + (jobs.size() ) + ' more job(s) to process. reinserting scheduler now. <br />' ;				
				ResyncManager_20100910.insertScheduler(); //this means there is AT LEAST 1 job left to run in three minutes 
			}else {
				try { 
					System.abortJob( ResyncManager_20100910.getcronkey() );
				} catch( exception ex) {}
			}
		}catch(Exception ex) {
			ResyncException re = new ResyncException();
			re.setOriginalException( ex);
			re.setSection('Resetting Scheduler');
			re.setdescription( ex + '  ');
			exceptions.add(  re  );
			trace += ex + '<br />';			
		}	

		if( exceptions.size() > 0 )
			ResyncManager_20100910.emailException(exceptions);
			
		Application_Setting__c resyncLog = [SELECT id FROM application_setting__c WHERE Setting_Name__c = 'RESYNC_TRACE' ];
		resyncLog.setting_value__c = trace;
		update resyncLog;
	}

	global static void insertScheduler() {
		DateTime nextRunTime = datetime.now().addMinutes( 10 );
		String jobID = System.schedule( ResyncManager_20100910.getcronkey(),'0 '+nextRunTime.minute()+' * * * ?', new ResyncManager_20100910() );
		Application_Setting__c cronSetting = new Application_Setting__c();
		cronSetting.Setting_Name__c = ResyncManager_20100910.getcronkey();
		cronSetting.setting_value__c = jobid;
		insert cronSetting;	
	}
	
	global static void QueueResync( string objecttype, id objectid ) {
		
		boolean createJob = true;
		boolean startScheduler = true;
 
		try {
			Resync_Job__c job = [ SELECT id FROM Resync_Job__c WHERE Object_Type__c = :objecttype AND Object_ID__c = :objectid AND Finished__c = false ];
			if( job != null ) createJob = false;
		} catch( Exception ex ) {
			//i think the SOQL above should throw a "No rows for assignment" type of error if the entry isnt in either table
			//in which case we do want the job to get scheduled			
		}	

		try { 
			Application_Setting__c cronSetting = [SELECT Setting_Name__c, Setting_Value__c FROM Application_Setting__c WHERE Setting_Name__c = :ResyncManager_20100910.getcronkey() ];
			if( cronSetting.Setting_Value__c != null && cronSetting.Setting_Value__c != ''  )
			{ //this should only be triggered when there is no Setting for the job
				startScheduler = false;
			}
		}catch(Exception ex) {
			//i think the SOQL above should throw a "No rows for assignment" type of error if the entry isnt in either table
			//in which case we do want the job to get scheduled
		}	
	
		if( createJob )
		{
			Resync_Job__c job = new Resync_Job__c();
			job.Object_Type__c	= objecttype;
			job.object_id__c	= objectid;
			job.finished__c		= false;
			insert job; 
		}		
    
		if( startScheduler ) ResyncManager_20100910.insertScheduler();
	}
		*/
}