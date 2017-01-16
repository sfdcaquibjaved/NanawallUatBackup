public with sharing class AjaxResponseController {

	public JsonObject json { get; set;}


    public void lookup_TotalOrderReportData(Datetime startdate, Datetime enddate, string LastNDays) 
    {
  
  		string soql = ' SELECT Chain_Account__c,Commission_Total__c,Commission__c, '
  					+ 'Contact__c,CreatedById,CreatedDate,Credit1__c,Credit__c,Date_Finalized__c,Discount__c,Id, ' 
  					+ 'Invoice_Sent_Date__c, NIS__c,Opportunity__c,'
  					+ 'Order_Number__c,OwnerId,Panelcount__c,Project_Is_Split__c,Quote_Subtotal__c,Quote__c, '
  					+ 'Shipping_State__c,Territory__c,Unique_Key__c,User__c, '
  					+ ' Opportunity__r.id '//SELECT Id,Opportunity__c, Opportunity__r.id FROM Report_Total_Order_Report_Data_Point__c
  					+ 'FROM Report_Total_Order_Report_Data_Point__c '
  					+ 'WHERE ';
		if( LastNDays != null )
		{
			soql += ' Date_Finalized__c >= last_n_days:'+LastNDays+' ';
		} else if( startdate != null && enddate != null )
		{			
			soql +=  ' ( Date_Finalized__c >=   '+startdate.format('yyyy-MM-dd') +
					' 			AND Date_Finalized__c <= '+ enddate.format('yyyy-MM-dd') +
					+' )';
		} else soql += '  Date_Finalized__c = last_n_days:7 '; 	

system.debug('soql: ' + soql );
		List<Report_Total_Order_Report_Data_Point__c> points = (list<Report_Total_Order_Report_Data_Point__c>)Database.query(soql);

		json = new JsonObject();
        List<JSONObject.value> values = new List<JSONObject.value>(); 
		
		for( Report_Total_Order_Report_Data_Point__c point : points )
    	{
			JSONObject ojson = new JSONObject();
			ojson.putOpt('Chain_Account__c', new JSONObject.value(point.Chain_Account__c));
			ojson.putOpt('Commission_Total__c', new JSONObject.value(point.Commission_Total__c));
			ojson.putOpt('Commission__c', new JSONObject.value(point.Commission__c));
			ojson.putOpt('Contact__c', new JSONObject.value(point.Contact__c));
			ojson.putOpt('CreatedById', new JSONObject.value(point.CreatedById));
			ojson.putOpt('CreatedDate', new JSONObject.value(point.CreatedDate.format('yyyy-MM-dd')));
			ojson.putOpt('Credit1__c', new JSONObject.value(point.Credit1__c));
			ojson.putOpt('Credit__c', new JSONObject.value(point.Credit__c));
			ojson.putOpt('Date_Finalized__c', new JSONObject.value( string.valueOf(point.Date_Finalized__c)));
			ojson.putOpt('Discount__c', new JSONObject.value(point.Discount__c));
			ojson.putOpt('Id', new JSONObject.value(point.Id));
			ojson.putOpt('Invoice_Sent_Date__c', new JSONObject.value( string.valueOf(point.Invoice_Sent_Date__c) ));
			ojson.putOpt('NIS__c', new JSONObject.value(point.NIS__c));
			ojson.putOpt('Opportunity__c', new JSONObject.value(point.Opportunity__c));
			ojson.putOpt('Order_Number__c', new JSONObject.value(point.Order_Number__c));
			ojson.putOpt('OwnerId', new JSONObject.value(point.OwnerId));
			ojson.putOpt('Panelcount__c', new JSONObject.value(point.Panelcount__c));
			ojson.putOpt('Project_Is_Split__c', new JSONObject.value(point.Project_Is_Split__c));
			ojson.putOpt('Quote_Subtotal__c', new JSONObject.value(point.Quote_Subtotal__c));
			ojson.putOpt('Quote__c', new JSONObject.value(point.Quote__c));
			ojson.putOpt('Shipping_State__c', new JSONObject.value(point.Shipping_State__c));
			ojson.putOpt('Project_Is_Split__c', new JSONObject.value(point.Project_Is_Split__c));
			ojson.putOpt('Territory__c', new JSONObject.value(point.Territory__c));
			ojson.putOpt('Unique_Key__c', new JSONObject.value(point.Unique_Key__c));
			ojson.putOpt('User__c', new JSONObject.value(point.User__c));
			
    	}

		json.putOpt('totalorderreport_searchresults', new JSONObject.value(values));

    	return;
    }
	class SalesCommissionMovingSumChart_ResponseObject {
		
		public list<string> headers = new List<string>(); //format ['Date','Rep1 Name', 'Rep2 Name']
		list<list<string>> data = new list<list<string>>(); //format  { ['9/1/2012','123345','23023'] }
	}
	boolean useJsonSerializedObject = false;    
    private string jsonSerializedObject = '';
    public void lookup_RepSalesCommissionMovingSumChartData(Date fromDate, Date toDate, Integer chartResolution) {
    	useJsonSerializedObject = true;

		SalesCommissionMovingSumChart_ResponseObject res = new SalesCommissionMovingSumChart_ResponseObject();
		
		map<id, User> userMap = new Map<id, User>();
		for( User u : [SELECT id, firstname, lastname, profileId FROM User WHERE ( ProfileID = '00eA0000000Qn2V' OR ProfileID = '00eA0000000RgW3' )] )
		{
			userMap.put( u.id, u);
		}

		
		list<Report_RepSalesCommission_DataPoint__c> dataPoints = [SELECT Id, Sum__c, User__c, Date__c, Unique_Key__c FROM Report_RepSalesCommission_DataPoint__c WHERE Date__c >= :fromDate AND Date__c <= :toDate ORDER BY Date__c];



		set<string> uniqueUsers = new set<string>();
		set<string> uniqueDates = new set<string>();
		map<string,decimal> keyToValues = new map<string,decimal>();
		for( Report_RepSalesCommission_DataPoint__c point : dataPoints )
		{
			string strDate = string.valueof( point.date__c);
			if( !uniqueUsers.contains(point.User__c) )
				uniqueUsers.add( point.User__c );
			if( !uniqueDates.contains( strDate ) )
				uniqueDates.add( strDate );
				
			if( !keyToValues.containsKey(  point.User__c+ '_' +  strDate   ) )
				keyToValues.put( point.User__c+ '_' +  strDate, point.Sum__c );
		}
		list<string> listDates = new list<string>( uniqueDates );
		listDates.sort();

		res.headers = new List<string>{ 'Date'};
		for( string uid : uniqueUsers )
		{
			User u = userMap.get(uid);
			if( u == null ) continue;
			res.headers.add( u.firstname + ' ' + u.lastname  );
		}
		integer i = 0;

		for( string pointDate : listDates )
		{
			if(Math.mod( i++,chartResolution) != 0 ) 
				continue;

			
			list<string> vals = new List<string>();
			vals.add(pointDate);
			for( string uid : uniqueUsers )
			{
				if( userMap.get(uid) == null ) continue;

				vals.add(  string.valueOf( keyToValues.get( uid+ '_' +  string.valueOf(pointDate)  ))   );
			}
			
			res.data.add(vals );
			
		}
		jsonSerializedObject = System.Json.serialize(res);
    }
    
    //ServicePartItem_NameList
    public void lookup_ServicePartItem(string PartID ) {
        json = new JsonObject();


		JSONObject response = new JSONObject();

		Service_Part__c spi = [SELECT id, name, Part_Name__c, stocked__c, Retail_Cost__c,Number_Stocked__c FROM Service_Part__c WHERE Id = :PartID];
		response.putOpt('name', new JSONObject.value(spi.Part_Name__c.replace('\'','').replace('"','') + ' ('+spi.name+')' /*+ ' (' + o.CreatedDate+')'*/ ) );
		response.putOpt('id', new JSONObject.value(spi.id));
		response.putOpt('stocked', new JSONObject.value(spi.stocked__c));
		response.putOpt('price', new JSONObject.value(spi.Retail_Cost__c));
		response.putOpt('numberstocked', new JSONObject.value(spi.Number_Stocked__c) );

    
    	decimal qtyPromised = 0;
    	for( Service_Part_Inventory_Lock__c lock : [SELECT Id, Quantity__c FROM Service_Part_Inventory_Lock__c WHERE Service_Part__c = :PartID AND ( Status__c = 'Active' OR Status__c = 'Pending' ) ] )
    	{
    		if( lock.Quantity__c != null)
	    		qtyPromised += lock.Quantity__c;
    	}
    	response.putOpt('promisedquantity', new JSONObject.value(qtyPromised) );
    	
		json.putOpt('ServicePartData', new JSONObject.value(response));
    	
    }
         
    public void lookup_ServicePartItem_NameList(string PartName ) {
        json = new JsonObject();

        List<JSONObject.value> values = new List<JSONObject.value>(); 
        PartName = PartName.replace('*', '%');
		for( Service_Part__c spi : [SELECT id, name, Part_Name__c, stocked__c, Retail_Cost__c, Vendor_Cost__c FROM Service_Part__c WHERE name like :'%'+PartName+'%' OR Part_Name__c like :'%'+PartName+'%'   ORDER BY Part_Name__c DESC LIMIT 50 ] )
		{
			if( spi.Part_Name__c == null || spi.name == null )
				continue;
//			spi.Retail_Cost__c
			JSONObject ojson = new JSONObject();
			ojson.putOpt('name', new JSONObject.value(spi.Part_Name__c.replace('\'','').replace('"','') + ' ('+spi.name+')' /*+ ' (' + o.CreatedDate+')'*/ ) );
			ojson.putOpt('id', new JSONObject.value(spi.id));
			ojson.putOpt('stocked', new JSONObject.value(spi.stocked__c));
			ojson.putOpt('retail_cost', new JSONObject.value(spi.Retail_Cost__c));
			ojson.putOpt('vendor_cost', new JSONObject.value(spi.Vendor_Cost__c));
			
			values.add(new JSONObject.value(ojson));			
		}		    
    
		json.putOpt('servicepartitems', new JSONObject.value(values));
    	
    }
         
    public void lookup_Opportunity_NameList(string ProjectName ) {
        json = new JsonObject();

		if( ProjectName.length() < 3 ) 
		{
			List<JSONObject.value> emptyvalues = new List<JSONObject.value>(); 
			json.putOpt('opportunities', new JSONObject.value(emptyvalues));
			return;
		}
        List<JSONObject.value> values = new List<JSONObject.value>(); 
        ProjectName = ProjectName.replace('*', '%');
		for( Opportunity o : [SELECT id,name, CreatedDate FROM Opportunity WHERE name like  :'%'+ProjectName+'%' ORDER BY CreatedDate DESC LIMIT 10 ] )
		{
			JSONObject ojson = new JSONObject();
			ojson.putOpt('name', new JSONObject.value(o.name.replace('\'','').replace('"','') /*+ ' (' + o.CreatedDate+')'*/ ) );
			ojson.putOpt('id', new JSONObject.value(o.id));
			values.add(new JSONObject.value(ojson));			
		}		    
    
		json.putOpt('opportunities', new JSONObject.value(values));

    }  
    
    /** invoked on an Ajax request */    
    public void doAjaxRequest() {
        Map<string,string> params = ApexPages.currentPage().getParameters();

		if( params.get('method') == 'Opportunity_NameList'  )
		{
			lookup_Opportunity_NameList(params.get('lookupvalue'));
		} else if( params.get('method') == 'ServicePartItem' )
		{
			lookup_ServicePartItem(params.get('lookupvalue'));
		} else if( params.get('method') == 'ServicePartItem_NameList')
		{
			lookup_ServicePartItem_NameList(params.get('lookupvalue') ); 
		} else if( params.get('method') == 'RepSalesCommissionMovingSumChartData' ) {
			Date fromDate = Date.parse(params.get('fromDate'));
			Date toDate = Date.parse(params.get('toDate'));
			Integer chartResolution = integer.valueOf( params.get('chartResolution') );
				
			lookup_RepSalesCommissionMovingSumChartData( fromDate, toDate, chartResolution );
		} else if( params.get('method') == 'TotalOrderReport_Lookup' )
		{
			Datetime startdate = null;
			DateTime enddate = null;

			lookup_TotalOrderReportData( startdate, enddate, params.get('LastNDays') );
		}
    }

    // Returns the JSON result string
    public String getResult() {
    	if( useJsonSerializedObject ) return jsonSerializedObject;
        else return json.ValuetoString();
    }
    
}