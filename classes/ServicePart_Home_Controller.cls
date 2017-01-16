public with sharing class ServicePart_Home_Controller {


	class SearchContainer {
	
		public string PartName { get; set; } 
		public string Location { get; set; }
		public string PartNumber { get; set; }
		public string VendorCost { get; set; }
		public string RetailCost { get; set; }
		public string NumberStocked { get; set; }
		public string ReorderLevel { get; set; }
		public boolean IsStocked { get; set; }
		public string Type { get; set; }
		
	}
	public SearchContainer SearchFields { get; set; }
	
	public List<SelectOption> getTypes() {
        List<SelectOption> options = new List<SelectOption>();

//		options.add(new Selectoption('','- select -') );
		options.add(new Selectoption('stock','Stock') );
		options.add(new Selectoption('nonstock','Non-Stock') );
//		options.add(new Selectoption('neither','Not Classified') );

        return options;	
		
	}	
	/*
	public List<SelectOption> getLocations() {
		
        List<SelectOption> options = new List<SelectOption>();

		Schema.DescribeFieldResult f = Schema.sObjectType.Service_Part__c.fields.Location__c;
		
		options.add(new Selectoption('','- select -') );
		for( Schema.Picklistentry entry : f.getPicklistValues( ))
		{
			options.add( new Selectoption(entry.getvalue(), entry.getlabel() ));
		}

        return options;	
	}
*/
    public pagereference dosort() {
		return null;
    }
	
	
	private boolean initd = false;
    public ServicePart_Home_Controller(){
    	
    	if( !initd)
    	{
    		SearchFields = new SearchContainer();
    		ResultText = '';
			searchResults = new List<Service_Part__c>();
    	}

    }

	public list<Service_Part__c> searchResults { get; set; }

	public string ResultText { get; set; }
	public PageReference  searchParts() {
		searchResults = new List<Service_Part__c>();

		string soql = ' SELECT Name,Stocked__c,Reorder_Level__c,Number_Stocked__c,Part_Name__c, Id, Location__c, Vendor_Cost__c,Retail_Cost__c FROM Service_Part__c WHERE Id != null ';

		if( SearchFields.PartName != null && SearchFields.PartName != '' )
			soql += ' AND Part_Name__c like \'%'+SearchFields.PartName+'%\'  ';

		if( SearchFields.Location != null && SearchFields.Location != '' )
			soql += ' AND Location__c = '+SearchFields.Location+'  ';
			
		if( SearchFields.PartNumber != null && SearchFields.PartNumber != '' )
			soql += ' AND Name like \'%'+SearchFields.PartNumber+'%\' ';
			
		if( SearchFields.VendorCost != null && SearchFields.VendorCost != '' )
			soql += ' AND Vendor_Cost__c = '+SearchFields.VendorCost+' ';
			
		if( SearchFields.RetailCost != null && SearchFields.RetailCost != '' )
			soql += ' AND Retail_Cost__c = '+SearchFields.RetailCost+' ';
			
		if( SearchFields.NumberStocked != null && SearchFields.NumberStocked != '' )
			soql += ' AND Number_Stocked__c = '+SearchFields.NumberStocked+' ';
			
		if( SearchFields.ReorderLevel != null && SearchFields.ReorderLevel != '' )
			soql += ' AND Reorder_Level__c = '+SearchFields.ReorderLevel+' ';
			
//		if( SearchFields.IsStocked != null && SearchFields.IsStocked )
//			soql += ' AND Stocked__c = true ';
			
		if( SearchFields.Type != null && SearchFields.Type == 'stock' )
		{
			soql += ' AND Stocked__c = true ';
		}	else if( SearchFields.Type != null && SearchFields.Type == 'nonstock' )
		{
			soql += ' AND Stocked__c = false ';
		}
			
			
		soql += ' LIMIT 1000 ';
system.debug( soql );		
    	Sobject[] results = Database.query(soql);
    	for( Sobject so : results )
    	{
			Service_Part__c part = (Service_Part__c)so;
			searchResults.add(part);
    	}			
    	resulttext = results.size() + ' matches found.';	
    	
		return null;
	}

}