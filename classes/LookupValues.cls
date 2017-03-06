global with sharing class LookupValues {

	webservice static string ContactRoles()
	{
		string ret ='<Root>';
		ret += '<Selections>';
		List<List<string>> items=Utility.LeadTypes();
		for (List<string> item: items)
		{
			ret += '<Selection Key="' + item[0] + '" Value="' + item[1] + '" />';
		}

 		ret += '</Selections>';
 		ret += '</Root>';
		
		return ret;
	}
	 
		webservice static string Countries()
	{
		string ret ='<Root>';
		ret += '<Selections>';
		List<List<string>> items=Utility.Countries();
		for (List<string> item: items)
		{
			ret += '<Selection Key="' + item[0] + '" Value="' + item[1] + '" />';
		}

 		ret += '</Selections>';
 		ret += '</Root>';
		
		return ret;
	}
	
		webservice static string States()
	{
		string ret ='<Root>';
		ret += '<Selections>';
		List<List<string>> items=Utility.States();
		for (List<string> item: items)
		{
			ret += '<Selection Key="' + item[0] + '" Value="' + item[1] + '" />';
		}

 		ret += '</Selections>';
 		ret += '</Root>';
		 
		return ret;
	}
	 
	webservice static string StatesbyCountry(string country)
	{
		string ret ='<Root>';
		ret += '<Selections>';
		List<List<string>> items=new List<List<string>>();
		if (country=='United States')
		{  
			items = Utility.UnitedStates_States();
		} 
		else if (country=='Canada')
		{  
			items = Utility.Canada_States();
		}
		
		else if (country=='Mexico')
		{  
			items = Utility.Mexico_States();
		}
		for (List<string> item: items)
		{
			ret += '<Selection Key="' + item[0] + '" Value="' + item[1] + '" />';
		}

 		ret += '</Selections>';
 		ret += '</Root>';
		
		return ret;
	}
	 
	webservice static string ProjectTypes()
	{
		string ret ='<Root>';
		ret += '<Selections>';
		List<List<string>> items=Utility.ApplicationTypes();
		for (List<string> item: items)
		{
			ret += '<Selection Key="' + item[0] + '" Value="' + item[1] + '" />';
		}

 		ret += '</Selections>';
 		ret += '</Root>';
		
		return ret;
	}
	
		@future (callout=true)
	public static void FutureUpdateShowroom(string id,Boolean del)
	{
		UpdateShowroom(id,del);
	}
	
	static void UpdateShowroom(string id,Boolean del)
	{
		NanaLookupValues.LookupTablesSoap nlv = new NanaLookupValues.LookupTablesSoap();
		Showroom__c sr = [select name,street1__c,street2__c,city__c,state__c,zip__c,country__c,primary_phone__c,secondary_phone__c from showroom__c where id=:id];
		
		string xml = '<Root>';
		// lame, but don't feel like screwing with the boolean right now
		if (del)
			xml += '<Delete Value="True" />';
		else
			xml += '<Delete Value="False" />';
		xml += '<ID Value="' + id + '" />'; 
		xml += '<Street1 Value="' + sr.Street1__c + '" />';
		xml += '<Street2 Value="' + sr.Street2__c + '" />';
		xml += '<City Value="' + sr.City__c + '" />';
		xml += '<State Value="' + sr.State__c + '" />';
		xml += '<Zip Value="' + sr.Zip__c + '" />';
		xml += '<Country Value="' + sr.Country__c + '" />';
		xml += '<Phone1 Value="' + sr.primary_phone__c + '" />';
		xml += '<Phone2 Value="' + sr.secondary_phone__c + '" />';
		xml += '<Name Value="' + sr.Name + '" />';
		xml += '</Root>';
		
		string resp = nlv.UpdateShowroom(xml);
		
	}
}