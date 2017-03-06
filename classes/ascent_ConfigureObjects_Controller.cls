public with sharing class ascent_ConfigureObjects_Controller {

	// ---  wrappers for selection objects and fields 
	public class ObjectOption
	{
		public string Id { get; set; }
		public string Name { get; set; }
		public string Label { get; set; }
		public string selectedFields { get; set; }
		public string displayFieldSelector { get { return (IsActive ? 'display: block' : 'display: none' ); } }
		
		
		public boolean IsActive { get; set; }
		
		public ObjectOption( string id, string name, string label, string selectedFields, boolean isactive)
		{
			this.Id = id;
			this.Name = name;
			this.selectedFields = selectedFields;
			this.Label = label;
			this.IsActive = isactive;
		}
	}

	private  list<ObjectOption> objectoptions = null;
	public void setObjectOptions( list<ObjectOption> opts )
	{
		objectoptions = opts;
	}
	public list<ObjectOption> getObjectOptions() 
	{
		
		if(objectoptions == null )
		{
			map<string, ascent_Object__c> allObjs = new map<string, ascent_Object__c>();			
			for( ascent_Object__c ao : [SELECT Id, API_Name__c, API_Label__c, SelectedFields__c FROM ascent_Object__c ] )
			{
				allObjs.put( ao.API_Name__c, ao );
			}
			
			objectoptions = new list<ObjectOption>();
			
			List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values(); 
	
			for(Schema.SObjectType f : gd)
			{
				
				Schema.DescribeSObjectResult od = f.getDescribe();
				if( !od.fields.getMap().containsKey('LastModifiedDate') )
				{
					system.debug('LastModifiedDate IS MISSING from   ' +f.getDescribe().getName() );
					continue;
				} else
				{
					system.debug('LastModifiedDate exists on  ' +f.getDescribe().getName() );
				}
				//jigsaw_clean__JSToken__Tag
				objectoptions.add(
					new ObjectOption(  
						( allObjs.containsKey(f.getDescribe().getName()) ? allObjs.get(f.getDescribe().getName()).Id : null ),  
						f.getDescribe().getName(),
						f.getDescribe().getLabel(),
						( allObjs.containsKey(f.getDescribe().getName()) ? allObjs.get(f.getDescribe().getName()).SelectedFields__c : null ),
						( allObjs.containsKey(f.getDescribe().getName()) ? true : false )
					)
				);
			}
		}
		


		
		return objectoptions;
	}

	public boolean skipCallouts { get{ if(skipCallouts == null) { skipCallouts = false; } return skipCallouts; } set; }
	public PageReference saveObjectSettings() 
	{
		if(objectoptions != null )
		{
			
			map<id, ascent_Object__c> allObjs = new map<id, ascent_Object__c>();
			for( ascent_Object__c ao : [SELECT Id, API_Name__c, API_Label__c FROM ascent_Object__c ] )
			{
				allObjs.put( ao.Id, ao );
			}
			
			list<Ascent_Configuration__c> config = [SELECT Ascent_Token__c, Ascent_Userid__c  FROM Ascent_Configuration__c];
			list<ascent_Object__c> objsToDelete = new list<ascent_Object__c>();
			list<ascent_Object__c> objsToSave = new list<ascent_Object__c>();
			string jsonToPush = '{ "customerid": "'+config[0].Ascent_Userid__c+'", "customertoken": "'+config[0].Ascent_Token__c+'", "DataObjects": [ ';
			boolean useComma = false;
			for( ObjectOption o : objectoptions )
			{
				if( o.IsActive )
				{
					ascent_Object__c obj = new ascent_Object__c();
					obj.API_Name__c = o.Name;
					obj.API_Label__c = o.Label;
					obj.SelectedFields__c = o.selectedFields;
					obj.Id = o.Id;
					objsToSave.add(obj);
					jsonToPush +=  (useComma ? ',' : '') + ' { "API_Name__c": "'+o.Name+'", "API_Label__c": "'+o.Label+'", "externalid": "'+o.Id+'",  "SelectedFields": '+o.selectedFields+' } ';
					useComma = true;
				} else if( o.Id != null && allObjs.containsKey(o.Id) )
				{
					objsToDelete.add( allObjs.get(o.Id) );
				}
			}
			jsonToPush += ']}';
			
			if( objsToDelete.size() > 0 )
				delete objsToDelete;
			
			if(objsToSave.size() > 0  )
			{
				if(!skipCallouts)
				{
					ascent_Communication.PushDataToServer( jsonToPush, 'dataobjectconfig' );
				}
				upsert objsToSave API_Name__c;
				
				
				
			}
		}
		
		
		
		return null;
	}
	
	
	@future
	public static void  pushData(string datatopush){ascent_Communication.PushDataToServer( datatopush, 'dataobjectconfig' );}

    public ascent_ConfigureObjects_Controller( ) 
    {
				
    }
	

}