public with sharing class ascent_Communication {


	public static boolean doCallouts { get { if(doCallouts  == null ) { doCallouts = true; } return doCallouts; } set; }
	public static void testPush() 
	{
			system.debug('starting test push');
		
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
			list< list<Sobject> > pages = ascent_Communication.CreatePagesForServerPush(pushItems, 500);
			for( list<Sobject> slist : pages  )
			{
	
				string serverformat = ascent_Communication.getServerFormatForBaseObjectPush(slist, fieldMap);
				if( doCallouts )
				{
					ascent_Communication.PushDataToServer( serverformat, 'baseobjects' );				
				} else system.debug('NOT doing callouts.');
				
				if( Limits.getCpuTime() > cpuLimit )
				{
	                
	                system.debug('Too close to CPU limit, breaking.');
					break;
				}
			}
		
		system.debug('finished test push');
	}
	

	public static list< list<Sobject> > CreatePagesForServerPush(list<Sobject> incoming, integer pagesize) 
	{
		list< list<Sobject> > response = new list< list<Sobject> >();
		

		list<Sobject> temp = new list<Sobject>();
		for( integer i=0; i<incoming.size(); i++ )
		{
			
			temp.add( incoming[i] );
			if( temp.size() >= pagesize )
			{
				response.add( temp );
				temp = new list<Sobject>();
			}
		}
		if( temp.size() > 0 )
		{
			response.add( temp );
		}
				
		
		return response;
	}


	public class Ascent_ObjectResponseObject
	{
		public string ObjectID {get; set; }
		public string ObjectType { get; set; }
		public string ScoreHistory { get; set; }
		public string ImprovementSuggestions { get; set; }		
		public string RelatedProjects { get; set; }		
		public map<string,string> fieldMap {get; set; }
	}

	public static list<Ascent_ObjectResponseObject> getServerResponseAsObject( string JSONstr ) 
	{
	
		list<Ascent_ObjectResponseObject> returnlist = new list<Ascent_ObjectResponseObject>();
		Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(JSONstr);
	    List<Object> items = (List<Object>)root.get('BaseObjects');
	    for (Object item : items) 
	    {
	        Map<String, Object> i = (Map<String, Object>)item;
	        Ascent_ObjectResponseObject oro = new Ascent_ObjectResponseObject();
	        oro.ObjectID = String.valueOf(i.get('externalid'));
	        oro.ObjectType = String.valueOf(i.get('objecttype'));
	        oro.ImprovementSuggestions = String.valueOf(i.get('improvementsuggestions'));

	        oro.fieldMap = new map<string, string>();
			map<string,Object> fieldMap = (Map<String, Object>)i.get('fields');
			for( string k : fieldMap.keyset() )
			{
				if( k == 'ascent_history__c' )
				{
					oro.ScoreHistory = '';
                    string historyStr = '';
                    for( Object  o : (List<Object>)fieldMap.get(k))
                    {
                        Map<String, Object> obj = (Map<String, Object>)o;

                        if( historyStr != '' ) historyStr += ',';
                        historyStr += '{ "date": "'+obj.get('date')+'", "value": "'+obj.get('value')+'"}';

                    }
                    historyStr =  '['+historyStr+']';
                    oro.ScoreHistory = historyStr;
					oro.fieldMap.put( k, oro.ScoreHistory );
                    system.debug(historyStr);

					
					/*
					for( Object o :  ( list<Object>)fieldMap.get(k) )
					{
						system.debug('____ history ___');
						system.debug(o);
						oro.ScoreHistory += (oro.ScoreHistory != '' ? ';' : '') + string.valueOf(o);

					}
					
					oro.fieldMap.put( k, oro.RelatedProjects );
*/
				} else if( k == 'ascent_related_objects__c' )
				{
					oro.RelatedProjects = '';
					for( Object o :  ( list<Object>)fieldMap.get(k)  )
						oro.RelatedProjects +=  (oro.RelatedProjects != '' ? ';' : '') +  string.valueOf(o );

					oro.fieldMap.put( k, oro.RelatedProjects );
				} else
				{
					oro.fieldMap.put( k, string.valueOf(fieldMap.get(k) ) );
				}
			}
			

			
			
			returnlist.add(oro);
	    }
	
	
		system.debug( returnlist );
		
		return returnlist;
	}
 
	public static string getServerFormatForBaseObjectPush( list<sobject> dataToSend, map<string, list<string>> fieldMap )
	{
		JSONGenerator gen = JSON.createGenerator(true); 
//		gen.writeObject(dataToSend);

		list<Ascent_Configuration__c> config = [SELECT Ascent_Token__c, Ascent_Userid__c  FROM Ascent_Configuration__c];


		gen.writeStartObject();
		gen.writeNumberField('customerid', config[0].Ascent_Userid__c ) ;
		gen.writeStringField('customertoken', config[0].Ascent_Token__c ) ;
		gen.writeFieldName('baseobjects'); //start baseobjects array
		gen.writeStartArray() ; //start the array
		
		for( sObject so : dataToSend )
		{
			
			string objecttype = so.getSObjectType().getDescribe().getName();
			gen.writeStartObject(); // {
			gen.writeStringField('externalid',so.Id);
//			gen.writeNumberField('id', 0);
			gen.writeStringField('objecttype',objecttype);
			gen.writeFieldName('fields');
			gen.writeStartObject(); // { start the field object


			Map<String, Schema.SObjectField> M = so.getSObjectType().getDescribe().fields.getMap();
			
			String ser = JSON.serialize(so);
			// Deserialize it back into a key/value map
//system.debug('*** pre-deserialization: ' + ser );			
			Map<String,Object> obj = (Map<String,Object>) JSON.deserializeUntyped(ser);
			set<string> keys = new set<string>();			
			for( string s : fieldMap.get(objecttype) )
				keys.add( s.toLowerCase() );
//			for( string s : obj.keySet() )
//				keys.add( s.toLowerCase() );
//system.debug( '*** DEBUG KEYSET: ' + keys );
			for( String s :  M.keySet() )
			{
//system.debug( '**** DEBUG: '+ s );				
				if( keys.contains(s) )
				{
//					accountfields.add( new FieldObj( s, m.get(s),  string.valueOf(sA.get( s )), this.getfieldmap().get(s) ) );					
					string val;
//system.debug( '###### VALUE: for   ' + s + ' = ' + so.get(s) );					
					if( so.get( s ) == null ) val = '';
					else val = string.valueOf( so.get( s ));
					gen.writeStringField( s,val);
				}
			}
			
			
			gen.writeEndObject();// } end the field object
			gen.writeEndObject(); // } //end the baseobject
			
		}
		gen.writeEndArray();//end the array of baseobjects 
		
		gen.writeEndObject();

		String prettyFormat = gen.getAsString();
//		system.debug('******** JSON FORMAT ***********');
//		system.debug( prettyFormat );
		
		
		/*
		Need this format: 
{
        "customerid": 1,
        "baseobjects": [
        {
            "externalid": "sfid1", "id": "0", "objecttype": "project__c",
            fields: { "field1": "field1value", "field2": "field2value", “ascent_history__c”: [ { "date": "2015-09-12", "value": 1},{ "date": "2015-09-03", "value": 1},{ "date": "2015-08-31", "value": 2},{ "date": "2015-08-15", "value": 3} ] }
        },
        {
            "externalid": "sfid2", "id": "1", "objecttype": "contact",
            fields: { "fieldx": "fieldxvalue", "fieldy": "fieldyvalue", “ascent_history__c”: [ { "date": "2015-09-12", "value": 1},{ "date": "2015-09-03", "value": 1},{ "date": "2015-08-31", "value": 2},{ "date": "2015-08-15", "value": 3} ] }
        }
        ]
    }		
		
		*/
	
	
		return prettyFormat;
	}

//	private static string ascent_serveruri = 'ec2-52-7-70-172.compute-1.amazonaws.com';
	private static string ascent_serveruri = 'ec2-52-7-69-65.compute-1.amazonaws.com';
	
	private static string ascent_getResultApplicationSetting = 'ASCENT_GETRESULTS';

	@future(callout=true)
	public static void GetDataFromServer(string method)
	{
		HttpRequest  req = new HttpRequest();   
		HttpResponse response = null;
		Http http = new Http();
		req.setEndpoint('http://'+ascent_serveruri+'/api/' + method  );
		req.setMethod('GET') ;
		response = http.send(req);
	
		system.debug('*** DEBUG RESPONSE: ' + response);
		
		Ascent_Application_Setting__c getResults_AppSetting = null;		
		for(  Ascent_Application_Setting__c setting : [SELECT Setting_Name__c, Setting_Value__c FROM Ascent_Application_Setting__c WHERE Setting_Name__c = :ascent_getResultApplicationSetting ] )
			getResults_AppSetting = setting;
		if( getResults_AppSetting == null )
		{ 	
			getResults_AppSetting = new Ascent_Application_Setting__c();
			getResults_AppSetting.Setting_Name__c = ascent_getResultApplicationSetting;
		}
//		getResults_AppSetting.Setting_Value__c = response.getBody();
		
//		upsert getResults_AppSetting;
	
		ascent_Scheduler.parseGetRequest_args( response.getBody() );
		
	}

	@future(callout=true)
	public static void PushDataToServer(string jsonToSend, string method )
	{

//		system.debug('***** SENDING JSON: ' + jsonToSend);
		HttpRequest  req = new HttpRequest();   
		HttpResponse response = null;
		Http http = new Http();
		req.setEndpoint('http://'+ascent_serveruri+'/api/' + method  );
		req.setMethod('POST') ;
		system.debug('*** Base 64 Encode: ' + Encodingutil.base64Encode(blob.valueOf(jsonToSend)));
		req.setBody('='+Encodingutil.base64Encode(blob.valueOf(jsonToSend)) ); //JSON string
		response = http.send(req);
		
		system.debug('*** DEBUG RESPONSE: ' + response);
	}

}