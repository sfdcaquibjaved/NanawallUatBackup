public with sharing class UtilityTEst {

	@isTest(SeeAllData=false)
	static  void RunTests () {
		Utility.getUserForTerritory('USA', '31999');
		/*
		Utility.getUserForTerritory('USA', '96199'); 
		Utility.getUserForTerritory('USA', '89899');
		Utility.getUserForTerritory('USA', '07699');
		Utility.getUserForTerritory('USA', '07999');
		Utility.getUserForTerritory('USA', '12799');
		Utility.getUserForTerritory('USA', '02799');
		Utility.getUserForTerritory('USA', '02999');
		Utility.getUserForTerritory('USA', '03899');
		Utility.getUserForTerritory('USA', '04999');
		Utility.getUserForTerritory('USA', '05999');
		Utility.getUserForTerritory('USA', '06999');
		Utility.getUserForTerritory('USA', '61999');
		Utility.getUserForTerritory('USA', '62399');
		Utility.getUserForTerritory('USA', '62799');
		Utility.getUserForTerritory('USA', '53999');
		Utility.getUserForTerritory('USA', '54599');
		Utility.getUserForTerritory('USA', '43299');
		Utility.getUserForTerritory('USA', '43999');
		Utility.getUserForTerritory('USA', '45799');
		Utility.getUserForTerritory('USA', '45799');
		Utility.getUserForTerritory('USA', '16899');
		Utility.getUserForTerritory('USA', '17299');
		Utility.getUserForTerritory('USA', '19699');
		Utility.getUserForTerritory('USA', '17199');
		Utility.getUserForTerritory('USA', '08999');
		Utility.getUserForTerritory('USA', '07799');
		Utility.getUserForTerritory('USA', '78999');
		Utility.getUserForTerritory('USA', '79999');
		Utility.getUserForTerritory('USA', '76899');
		Utility.getUserForTerritory('USA', '74999');
		Utility.getUserForTerritory('USA', '79699');
		Utility.getUserForTerritory('USA', '19999');
		Utility.getUserForTerritory('USA', '21999');
		Utility.getUserForTerritory('USA', '24699');
		Utility.getUserForTerritory('USA', '26899');
		Utility.getUserForTerritory('USA', '48999');
		Utility.getUserForTerritory('USA', '49199');
		Utility.getUserForTerritory('USA', '49299');
		Utility.getUserForTerritory('USA', '49599');
		Utility.getUserForTerritory('USA', '48999');
		Utility.getUserForTerritory('USA',  '83199');
		Utility.getUserForTerritory('USA',  '59399');
		Utility.getUserForTerritory('USA',  '88999');
		Utility.getUserForTerritory('USA',  '59599');
		Utility.getUserForTerritory('USA',  '34199');
		Utility.getUserForTerritory('USA',  '34999');
		Utility.getUserForTerritory('USA',  '33999');
		Utility.getUserForTerritory('USA', '32971');
		Utility.getUserForTerritory('USA', '33499');
		Utility.getUserForTerritory('USA', '56999');
		Utility.getUserForTerritory('USA', '54099');
		Utility.getUserForTerritory('USA', '54899');
		Utility.getUserForTerritory('USA', '58999');
		Utility.getUserForTerritory('USA', '57999');
		Utility.getUserForTerritory('USA', '44799');
		Utility.getUserForTerritory('USA', '44999');
		Utility.getUserForTerritory('USA', '43699');
		Utility.getUserForTerritory('USA', '45899');
		Utility.getUserForTerritory('USA', '44599');
		Utility.getUserForTerritory('USA', '83999');
		Utility.getUserForTerritory('USA', '96999');
		Utility.getUserForTerritory('USA', '59499');
		Utility.getUserForTerritory('USA', '59999');
		Utility.getUserForTerritory('USA', '97999');
		Utility.getUserForTerritory('USA', '99499');
		Utility.getUserForTerritory('USA', '99999');
		Utility.getUserForTerritory('USA', '29999');
		Utility.getUserForTerritory('USA', '34100');
		Utility.getUserForTerritory('USA', '34399');
		Utility.getUserForTerritory('USA', '67999');
		Utility.getUserForTerritory('USA', '93599');
		Utility.getUserForTerritory('USA', '11999');
		Utility.getUserForTerritory('USA', '32299');
		Utility.getUserForTerritory('USA', '32959');
		Utility.getUserForTerritory('USA', '34799');
		Utility.getUserForTerritory('USA', '32959');
		Utility.getUserForTerritory('USA', '32999');
		Utility.getUserForTerritory('USA', '54599');
		Utility.getUserForTerritory('USA', '45799');
		Utility.getUserForTerritory('USA', '48999');
		Utility.getUserForTerritory('USA', '34100');
		Utility.getUserForTerritory('USA', '32959');
		 
		Utility.getUserForTerritory('USA', '12001');
		Utility.getUserForTerritory('USA', '12801');
		Utility.getUserForTerritory('USA', '27001');
		Utility.getUserForTerritory('USA', '32301');
		Utility.getUserForTerritory('USA', '32401');
		Utility.getUserForTerritory('USA', '32601');
		Utility.getUserForTerritory('USA', '32901');
		Utility.getUserForTerritory('USA', '33501');
		Utility.getUserForTerritory('USA', '34201');
		Utility.getUserForTerritory('USA', '32901');
		Utility.getUserForTerritory('USA', '34401');
		Utility.getUserForTerritory('USA', '34601');
		Utility.getUserForTerritory('USA', '35001');
		Utility.getUserForTerritory('USA', '36501');
		Utility.getUserForTerritory('USA', '36701');
		Utility.getUserForTerritory('USA', '37301');

		Utility.getUserForTerritory('USA', '32901');
		Utility.getUserForTerritory('USA', '37601');
		Utility.getUserForTerritory('USA', '38601');
		Utility.getUserForTerritory('USA', '37001');
		Utility.getUserForTerritory('USA', '37501');
		Utility.getUserForTerritory('USA', '38001');
		Utility.getUserForTerritory('USA', '39001');
		Utility.getUserForTerritory('USA', '32901');
		Utility.getUserForTerritory('USA', '39701');
		Utility.getUserForTerritory('USA', '40001');
		Utility.getUserForTerritory('USA', '46001');
		Utility.getUserForTerritory('USA', '49601');
		Utility.getUserForTerritory('USA', '50001');
		Utility.getUserForTerritory('USA', '54901');
		Utility.getUserForTerritory('USA', '62301');
		Utility.getUserForTerritory('USA', '62501');
		Utility.getUserForTerritory('USA', '63001');
		Utility.getUserForTerritory('USA', '68001');
		Utility.getUserForTerritory('USA', '69001');
		Utility.getUserForTerritory('USA', '70001');

			
		Utility.getUserForTerritory('canada', 'v4v');
		Utility.getUserForTerritory('canada', 'v99');
		Utility.getUserForTerritory('canada', '4v');
		Utility.getUserForTerritory('canada', 'tv');
		Utility.getUserForTerritory('canada', 'jv');
		Utility.getUserForTerritory('canada', 'lv');
		Utility.getUserForTerritory('canada', 'xv');
			
		//utiliy get user special cases
		Utility.getUserForTerritory('USA', '1');
		Utility.getUserForTerritory('TEST', '1');
*/

	try {
//		ResyncManager.ResyncException ex = new ResyncManager.ResyncException();
//		ResyncManager.callWebService( 'Account', 'test', 'test');
	} catch( exception e ){
	}   

try {		
		Utility.getUserForTerritory( null, null );
} catch( Exception ex ){
	//whatever
}		
		Utility.HostName();
		Utility.NanaServerAddress();

		GlobalStrings.CatchallUserIDForAssignment();
		GlobalStrings.CaribbeanUserID();
		GlobalStrings.NewSaleTeamMemberLink('');
		GlobalStrings.DefaultOrgWideEmailAddressID();
		
		map<string,string>  testmap = Utility.GetCountryCodeMap_ByCountryName();
		Utility.GetCountryCodeMap();
		Utility.GetStateCodeMap_ByStateName('US');
		Utility.GetStateCodeMap('US');
		Utility.GetStateCodeMap('AU');
		Utility.GetStateCodeMap('CA');
		Utility.GetStateCodeMap('MX');
		
		
		try {		
			Profile p = [SELECT id FROM Profile LIMIT 1];
			User u2 = [SELECT id from User WHERE ProfileId = :p.Id AND isactive = true LIMIT 1 ];		
			Utility.HasAccess( u2.Id, new Set<Id> { u2.id } );
			User u3 = [SELECT id from User WHERE ProfileId = :Utility.RequiredProfileID() AND isactive = true LIMIT 1 ];		
			Utility.HasAccess( u3.Id, new Set<Id> { u3.id } );
			
		} catch(Exception ex) {
			System.debug(ex);		
		}
	}
}