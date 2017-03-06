global with sharing class GetUserService {

webservice static string GetUser(string country,string zip)
	{
		return GetUserFromAddress.GetUser(country, zip);
	}
}