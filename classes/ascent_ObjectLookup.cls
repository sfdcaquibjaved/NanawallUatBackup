public with sharing class ascent_ObjectLookup {

	
	
	public static list<Sobject> getObjectData( string ObjectName, list<string> ObjectFields ) 
	{
		
		list<Sobject> response = new list<Sobject>();
		
		string soql = ' SELECT ';
		boolean addComma = false;
		for( string s : ObjectFields )
		{
			soql += ( addComma ? ',': '' )+s;
			addComma = true;
		}
		soql += ' FROM ' + ObjectName + ' WHERE LastModifiedDate >= LAST_N_DAYS:1 ';
		if( ObjectName.toLowerCase() == 'project__c')
			soql += ' AND closed__c  = 0 ';
		else if(ObjectName.toLowerCase() == 'opportunity' )
			soql += '  AND Opportunity.Project_Name__r.Closed__c = 0 ';
System.debug('Trying to lookup for ' + ObjectName + ': ' + soql);

		return Database.query(soql);

	}

}