public with sharing class ascent_AjaxResponseController 
{


	public void lookup_FieldsForObject( string API_Name ) 
	{

		Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

		//get the selected fields on this object
		set<string> selectedFields = new set<string>();
		list<ascent_Object__c> aoBjs = [SELECT Id, API_Name__c, API_Label__c, SelectedFields__c FROM ascent_Object__c WHERE API_Name__c = :API_Name ];
		if( aoBjs.size() > 0 )
		{
			ascent_Object__c ao = aoBjs[0];
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
		}


		
		JSONGenerator gen = JSON.createGenerator(true); 

		gen.writeStartObject();
		gen.writeStringField('API_Name', API_Name ) ;
		gen.writeFieldName('Field_List'); //start baseobjects array
		gen.writeStartArray() ; //start the array
		
		
		if( globalDescribe.containsKey(API_Name) )
		{
			Schema.SObjectType so = globalDescribe.get(API_Name);
			Schema.DescribeSObjectResult od = so.getDescribe();
			
			Map<String,Schema.sObjectField> fieldMap = od.fields.getMap();
				
			list<string> sortedFieldNames = new list<string>();
			for(Schema.sObjectField field : fieldMap.values())
			{
				sortedFieldNames.add( field.getDescribe().getName() );
			}				
			sortedFieldNames.sort();
			
//			for(Schema.sObjectField field : fieldMap.values()){
			for( string fieldName : sortedFieldNames )
			{
				Schema.sObjectField field = fieldMap.get( fieldName );
  		
  				Schema.DescribeFieldResult fd = field.getDescribe();
  
//  				if(fd.getType()==Schema.DisplayType.String)
  				{

  					gen.writeStartObject();
  					gen.writeStringField( 'API_Name', fd.getName() );
  					gen.writeStringField( 'Label', fd.getLabel() );
  					gen.writeBooleanField( 'IsSelected', selectedFields.contains(fd.getName()) );
  					gen.writeEndObject();

  				}
  		
  			}			
		}

		gen.writeEndArray();
		gen.writeEndObject();
		
		result = gen.getAsString();
	}

    /** invoked on an Ajax request */    
    public void doAjaxRequest() {
        Map<string,string> params = ApexPages.currentPage().getParameters();

		if( params.get('method') == 'GetFieldsForObject'  )
		{
			//do something
			lookup_FieldsForObject( params.get('object_apiname') );
		}
    }


    // Returns the JSON result string
    public String result {
		get;
		set;
    }

}