global with sharing class ascent_Scheduler implements Schedulable
{



//	private static string cronKey = 'Ascent_DataScheduler';
	public static string cronkey { get { return 'Ascent_DataScheduler'; } set; }

//	private static string pageProcessedKey = 'Ascent_LastPageProcessed';
	public static string PageProcessedKey {  get { return 'Ascent_LastPageProcessed';  } set;}
	public static string LastStageKey {  get { return 'Ascent_LastStage';  } set;}

	global static void cancelNextRun() 
	{
		Ascent_Application_Setting__c cronSetting = null;		
		try {
			cronSetting = [SELECT Setting_Name__c, Setting_Value__c FROM Ascent_Application_Setting__c WHERE Setting_Name__c = :cronKey ];
		} catch( Exception ex ) 
		{

		}
		
		if( cronSetting != null )
		{ 	//this should only be triggered when there is no Setting for the job
			//this will get recreated byt he insertScheduler call below
				try
				{
					System.abortJob( cronSetting.setting_value__c );		
				} catch(Exception ex )
				{}
				delete cronSetting;
		}
	
	}

	global static void insertScheduler(integer nextRun) {
		
		//1. kill the currently scheduled job
		ascent_Scheduler.cancelNextRun();
		
		//2. reschedule the run for 10 minutes from now
		DateTime nextRunTime = datetime.now().addMinutes( nextRun );
//system.debug( 'reschedulign for '+nextRun +' minutes: ');
        String chron_exp = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year();

//		String jobID = System.schedule( ascent_Scheduler.getcronkey(),'0 '+nextRunTime.minute()+' * * * ?', new ascent_Scheduler() );
		String jobID = System.schedule( ascent_Scheduler.cronkey,chron_exp, new ascent_Scheduler() );
		Ascent_Application_Setting__c cronSetting = new Ascent_Application_Setting__c();
		cronSetting.Setting_Name__c = ascent_Scheduler.cronkey;
		cronSetting.setting_value__c = jobid;
		insert cronSetting;	
	}


	global static void doGetRequest()  
	{


		//1. Get the data from the server  
		ascent_Communication.GetDataFromServer('BaseObjects');
		
	}
	
	global static  void parseGetRequest() 
	{
		//look up results
		Ascent_Application_Setting__c getResults_AppSetting = null;		
		for(  Ascent_Application_Setting__c setting : [SELECT Setting_Name__c, Setting_Value__c FROM Ascent_Application_Setting__c WHERE Setting_Name__c = 'ASCENT_GETRESULTS' ] )
		{
		    if( setting.Setting_Name__c == 'ASCENT_GETRESULTS')
			    getResults_AppSetting = setting;
		}    
		if(getResults_AppSetting != null)
		{
			ascent_Scheduler.parseGetRequest_args(getResults_AppSetting.Setting_Value__c );
		}
	}
	global static  void parseGetRequest_args( string body ) 
	{
	
		system.debug('PARSING: ' + body );
		//2. When the scheduler runs, parse the data and insert its results		
		//build the fieldmap based on the objects selected for inclusion 
		Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
		map< string, Map<String,Schema.sObjectField> > object_fieldmap = new  map< string, map<string, Schema.sObjectField> >();
		for( ascent_Object__c aoBj : [SELECT Id, API_Name__c, API_Label__c, SelectedFields__c FROM ascent_Object__c   ] )
		{
		    Schema.SObjectType so = globalDescribe.get(aObj.API_Name__c);
		    Schema.DescribeSObjectResult od = so.getDescribe();
		    Map<String,Schema.sObjectField> fieldMap = od.fields.getMap();
		    
			object_fieldmap.put( aObj.API_Name__c.toLowerCase(), fieldMap );
		}
		
		
		if( body != null )
		{ 	
		    //if we have results, build the Sobject list for update
		    list<ascent_Communication.Ascent_ObjectResponseObject> parsed = 
		        ascent_Communication.getServerResponseAsObject( body );
		    
		    map<Id,Sobject> updatemap = new map<Id,Sobject>();
		    for( ascent_Communication.Ascent_ObjectResponseObject p : parsed )
		    {
		        system.debug( '**** OBJECT: ' + p.ObjectType +  ' ; ' + p.ObjectID);
		        Id oid  = (Id)( p.ObjectID);
		        SObject so = oid.getSObjectType().newSObject(oid);
		
		        for( string fieldName : p.fieldMap.keySet() )
		        {
		            system.debug('==> ' + fieldName + ' = ' + p.fieldMap.get(fieldName) );   
		            if(!object_fieldmap.containsKey(p.ObjectType.toLowerCase()) )
		            {
		                system.debug(' ERROR! Object '+p.ObjectType+' not in the describe object result. ');
		            } else 
		                if( object_fieldmap.get(p.ObjectType.toLowerCase()).containsKey(fieldName) )
		            {
			            Schema.DescribeFieldResult fieldDescribe = object_fieldmap.get(p.ObjectType.toLowerCase()).get(fieldName).getDescribe();
System.debug('DEBUG: ' + fieldName +' is a ' + fieldDescribe.getType() );
		
						if( fieldDescribe.getType() == Schema.DisplayType.Boolean )
		                {
							so.put( fieldName, Boolean.valueOf(p.fieldMap.get(fieldName)));
		                } else if( fieldDescribe.getType() == Schema.DisplayType.DOUBLE )
		                {
							so.put( fieldName, Double.valueOf(p.fieldMap.get(fieldName)));
		                    
		                } else if( fieldDescribe.getType() == Schema.DisplayType.INTEGER )
		                {
							so.put( fieldName, Integer.valueOf(p.fieldMap.get(fieldName)));                    
		                }  else 
		                { //parse as a string by default                    
							so.put( fieldName, String.valueOf(p.fieldMap.get(fieldName)));                    
		                }
		                
		            }            
		        }
		        updateMap.put( so.Id, so);
		    }
		    if( updateMap.keySet().size() > 0 )
			    update updatemap.values();
		}




	
	}


    global void execute(SchedulableContext SC) 
    {

		integer pushPageSize = 500;


		// update the ascent_appsetting to the last push page processed.
		Ascent_Application_Setting__c lastPage_AppSetting = null;		
		Ascent_Application_Setting__c lastProcessStage_AppSetting = null;		
		for(  Ascent_Application_Setting__c setting : [SELECT Setting_Name__c, Setting_Value__c FROM Ascent_Application_Setting__c   ] )
		{
			if(setting.Setting_Name__c == PageProcessedKey )
				lastPage_AppSetting = setting;
			else if( setting.Setting_Name__c == LastStageKey )
				lastProcessStage_AppSetting = setting;
		}		
			
		if( lastPage_AppSetting == null )
		{ 	
			lastPage_AppSetting = new Ascent_Application_Setting__c();
			lastPage_AppSetting.Setting_Name__c = PageProcessedKey;
			lastPage_AppSetting.Setting_Value__c = '0';
		}
		
		if( lastProcessStage_AppSetting == null )
		{ 	
			lastProcessStage_AppSetting = new Ascent_Application_Setting__c();
			lastProcessStage_AppSetting.Setting_Name__c = LastStageKey;
			lastProcessStage_AppSetting.Setting_Value__c = 'push';
		}
		


		if( lastProcessStage_AppSetting.Setting_Value__c == 'push')
		{
system.debug('** INSIDE the push block');			
			
			//do the work - depending on governor limits, in particular callout size, we may need to chunk this. 
			list<sObject> pushItems = new list<sObject>();
			map<string, list<string>> fieldMap = new map<string, list<string>>();			
			for( ascent_Object__c ao : [SELECT Id, API_Name__c, API_Label__c, SelectedFields__c FROM ascent_Object__c ] )
			{
				list<string> selectedFields = new list<string>();
				if(ao.SelectedFields__c != null && ao.SelectedFields__c != '' )
				{
					JSONParser parser = JSON.createParser(ao.SelectedFields__c);
					while (parser.nextToken() != null) {
						if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
					    {
							String fieldName = parser.getText();
							parser.nextToken();
							if(fieldName == 'fieldList') 
					        {
								if(parser.getCurrentToken() == JSONToken.START_ARRAY)
					            {
					                while(parser.nextToken() != null)
					                {
					                    if(parser.getCurrentToken() == JSONToken.VALUE_STRING )
					                    {
					
					                        selectedFields.add( parser.getText() );
					                    }
					                    else if(parser.getCurrentToken() == JSONToken.END_ARRAY)
					                    {
					                        break;	
					                    }
					                }
					            }
					   		}
						}
					}			
				}
				pushItems.addAll(ascent_ObjectLookup.getObjectData(  ao.API_Name__c, selectedFields));
				fieldMap.put( ao.API_Name__c, selectedFields);
			}
	
	
			double cpuLimit = Limits.getLimitCpuTime() *.7;
			integer lastPageProcessed = 0;
			integer startPageProcess = Integer.valueOf(lastPage_AppSetting.Setting_Value__c);
			list< list<Sobject> > pages = ascent_Communication.CreatePagesForServerPush(pushItems, pushPageSize);
			for( list<Sobject> slist : pages  )
			{
				lastPageProcessed++;			
				if( lastPageProcessed <= startPageProcess )
					continue;
	
				ascent_Communication.PushDataToServer( ascent_Communication.getServerFormatForBaseObjectPush(slist,fieldMap), 'baseobjects' );
				if( Limits.getCpuTime() > cpuLimit )
				{
	                
	                system.debug('Too close to CPU limit, breaking.');
					break;
				}
			}
	
			system.debug('Finished up to page ' + lastPageProcessed + ' out of ' + pages.size() );
			if( lastPageProcessed < pages.size() )
			{
	
			
				lastPage_AppSetting.Setting_Value__c = string.valueOf( lastPageProcessed );		
				//insert the scheduler, need to queue up another push in 1 minute
				ascent_Scheduler.insertScheduler(1);
			} else 
			{
				lastPage_AppSetting.Setting_Value__c = '0';
				lastProcessStage_AppSetting.Setting_Value__c = 'get';
				ascent_Scheduler.insertScheduler(1);
			}		
			
		} else if( lastProcessStage_AppSetting.Setting_Value__c == 'get' )
		{
system.debug('** INSIDE the get block');			
			ascent_Scheduler.doGetRequest();
			lastProcessStage_AppSetting.Setting_Value__c = 'parse'; //once the data comes back, we need to parse it. give it three minutes
			ascent_Scheduler.insertScheduler(3); 
			
		} else
		{
system.debug('** INSIDE the parse block');			
			ascent_Scheduler.parseGetRequest();
			lastProcessStage_AppSetting.Setting_Value__c = 'push'; //when it runs tomorrow, it should do a push
			ascent_Scheduler.insertScheduler(1380); //tomorrow less one hour
			
		}


		upsert lastPage_AppSetting;
		upsert lastProcessStage_AppSetting;

				

    }

	
}