global with sharing class Finder {

	
	webservice static Showroom__c GetShowroomByLatLong(decimal lat,decimal lon)
	{
		Map<id,Showroom__c> showrooms = new Map<id,showroom__c>([select id,name,latitude__c,longitude__c,city__c,country__c,primary_phone__c,secondary_phone__c,show_address__c,state__c,street1__c,street2__c,zip__c from Showroom__c]);
		double distance = 9999999;
		
		Showroom__c ret=showrooms.values()[0];
		for (Showroom__c showroom:showrooms.values())
		{
			double distance2 = Utility.Distance(lat,lon,showroom.latitude__c,showroom.longitude__c);
			if (distance2<distance)
			{
				ret=showroom;
				distance=distance2;
			}
		}
		if (distance>325)
		{
					HttpRequest req = new HttpRequest();
			req.setEndpoint('http://api.geonames.org/findNearbyPostalCodes?lat='+lat+'&lng='+lon+'&username=nanawall');
			req.setMethod('GET');
			Http http = new Http();
			HTTPResponse res = http.send(req);
			Dom.Document doc = res.getBodyDocument();
			Dom.XMLNode geonames = doc.getRootElement();
			
			String postalcode = geonames.getChildElement('code', null).getChildElement('postalcode', null).getText();
			String countrycode = geonames.getChildElement('code', null).getChildElement('countryCode', null).getText();
			string country='';
			if (countrycode=='US')
			{
				country='United States';
			}
			else if (countrycode=='CA')
			{
				country='Canada';
			}
			else if (countrycode=='MX')
			{
				country='Mexico';
			}
			ret =GetTerritoryShowroom( postalcode,country);
		}
		return ret;
	}
	
	//use this when you want to check the territory showroom only
	webservice static Showroom__c GetTerritoryShowroom(string zip, string country)
	{
		Showroom__c ret = new Showroom__c();
		if (zip=='' || country=='')
			return ret;
		if (country=='United States' || country=='USA')
		{
			Map<ID,Zip_Lookup__c> zipl = new Map<id,Zip_Lookup__c>([select id,showroom__c,showroom_bydistance__c from Zip_Lookup__c where name=:zip and country__c='USA']);
			
			if (zipl.size()>0 && zipl.values()[0].Showroom__c !=null)
				ret = [select id,name,latitude__c,longitude__c,city__c,country__c,primary_phone__c,secondary_phone__c,show_address__c,state__c,street1__c,street2__c,zip__c from showroom__c where id =: zipl.values()[0].Showroom__c];
		}
		else if (country=='Mexico' || country=='MEX')
		{
			Showroom__c showroom=[select id,name from showroom__c where country__c='MEX'];
			ret = showroom;
		}
		else if(country=='Canada' || country=='CAN')
		{
			string id = Utility.getUserForTerritory('canada', zip);
			if (id =='005A0000000N1jsIAC')	
			{
				//besner
				ret = [select id,name,latitude__c,longitude__c,city__c,country__c,primary_phone__c,secondary_phone__c,show_address__c,state__c,street1__c,street2__c,zip__c from showroom__c where country__c='CAN' and state__c='QC'];
			}
			else if(id =='005A0000000N1loIAC')
			{
				//van ness
				ret = [select id,name,latitude__c,longitude__c,city__c,country__c,primary_phone__c,secondary_phone__c,show_address__c,state__c,street1__c,street2__c,zip__c from showroom__c where country__c='CAN' and city__c='Vancouver'];	
			}
			//legasse
			else if (id=='005A0000000N7poIAC')
			{
				ret = [select id,name,latitude__c,longitude__c,city__c,country__c,primary_phone__c,secondary_phone__c,show_address__c,state__c,street1__c,street2__c,zip__c from showroom__c where country__c='CAN' and state__c='ON'];
			}
			//sanderson
			else if (id=='005A0000000O65SIAS')
			{
				ret = [select id,name,latitude__c,longitude__c,city__c,country__c,primary_phone__c,secondary_phone__c,show_address__c,state__c,street1__c,street2__c,zip__c from showroom__c where country__c='CAN' and city__c='Kelowna'];
			}
			 
		}
		
		return ret;
	}
	
	
	webservice static Showroom__c GetShowroomByZip(string zip,string country)
	{
		Showroom__c ret = new Showroom__c();
		if (zip=='' || country=='')
			return ret;
			
			HttpRequest req = new HttpRequest();
			string cc='';
			if (country=='United States' || country=='united states' || country=='USA')
			{
				cc='US';
			}
			else if (country=='Canada' || country=='canada' || country=='CAN')
			{
				cc='CA';
			}
			else if (country=='Mexico' || country=='mexico' || country=='MEX')
			{
				cc='MX';
			}
			req.setEndpoint('http://api.geonames.org/findNearbyPostalCodes?postalcode='+zip+'&country='+cc+'&username=nanawall');
			req.setMethod('GET');
			Http http = new Http();
			HTTPResponse res = http.send(req);
			Dom.Document doc = res.getBodyDocument();
			Dom.XMLNode geonames = doc.getRootElement();
			try
			{
				string lat = geonames.getChildElement('code', null).getChildElement('lat', null).getText();
				String lng = geonames.getChildElement('code', null).getChildElement('lng', null).getText();
				ret = GetShowroomByLatLong(Decimal.valueof(lat),decimal.valueof(lng));
			}
			catch (Exception ex)
			{
				ret = GetTerritoryShowroom(zip,country);
			}
			return ret;
	}
	
	webservice static User GetRepByZip(string zip,string country)
	{
		string id = Utility.getUserForTerritory(country, zip);
		User ret= [select id,name from user where id=:id];
		return ret;
	}
	
	webservice static User GetRepByLatLong(decimal lat,decimal lon)
	{
		HttpRequest req = new HttpRequest();
		
		string id='005A0000000MOJpIAO';
		try
		{
		req.setEndpoint('http://api.geonames.org/findNearbyPostalCodes?lat='+lat+'&lng='+lon+'&username=nanawall');
		req.setMethod('GET');
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Dom.Document doc = res.getBodyDocument();
		Dom.XMLNode geonames = doc.getRootElement();
		
		String postalcode = geonames.getChildElement('code', null).getChildElement('postalcode', null).getText();
		String countrycode = geonames.getChildElement('code', null).getChildElement('countryCode', null).getText();
		if (countrycode=='US')
		{
			id =Utility.getUserForTerritory('USA', postalcode);
		}
		else if (countrycode=='CA')
		{
			id = Utility.getUserForTerritory('CAN',postalcode);
		}
		else if (countrycode=='MX')
		{
			id = Utility.getUserForTerritory('MEX',postalcode);
		}
		}
		catch (Exception ex)
		{
			Utility.jimdebug(ex,'get rep by lat long ' + lat + ' ' + lon);
		}
		User ret= [select id,name from user where id=:id];
		return ret;
	}
	
}