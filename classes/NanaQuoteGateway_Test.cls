public with sharing class NanaQuoteGateway_Test {


	@isTest(SeeAllData=false)
	public static  void TestQuoteGateway() {

		//call the class constructors	
		NanaQuoteGateway gw = new NanaQuoteGateway();
		NanaQuoteGateway.GetAllUserNamesResponse_element el1 = new NanaQuoteGateway.GetAllUserNamesResponse_element();
		NanaQuoteGateway.GetUserXmlByUsernameResponse_element el2 = new NanaQuoteGateway.GetUserXmlByUsernameResponse_element();
		NanaQuoteGateway.GetSolidworksSingleResponse_element el3 = new NanaQuoteGateway.GetSolidworksSingleResponse_element();
		NanaQuoteGateway.Get3DFormatsResponse_element el4 = new NanaQuoteGateway.Get3DFormatsResponse_element();
		NanaQuoteGateway.GetSolidworks_element el5 = new NanaQuoteGateway.GetSolidworks_element();
		NanaQuoteGateway.GetAllUsersXML_element el6 = new NanaQuoteGateway.GetAllUsersXML_element();
		NanaQuoteGateway.GetQuoteByID2Response_element el7  = new NanaQuoteGateway.GetQuoteByID2Response_element();
		NanaQuoteGateway.AvailableProjectTypesResponse_element el8 = new NanaQuoteGateway.AvailableProjectTypesResponse_element();
		NanaQuoteGateway.wsoQuote wq = new NanaQuoteGateway.wsoQuote();
		NanaQuoteGateway.ArrayOfWsoQuoteDetail wsqdArray = new NanaQuoteGateway.ArrayOfWsoQuoteDetail();
		NanaQuoteGateway.QuoteRequestInput_element el9 = new NanaQuoteGateway.QuoteRequestInput_element();
		NanaQuoteGateway.UpdateLead_element el10 = new NanaQuoteGateway.UpdateLead_element();
		NanaQuoteGateway.GetQuoteByID2_element el11 = new NanaQuoteGateway.GetQuoteByID2_element();
		NanaQuoteGateway.GetUserXmlByUsernameResult_element el12 = new NanaQuoteGateway.GetUserXmlByUsernameResult_element();
		NanaQuoteGateway.GetWebQuoteByID_element el13 = new NanaQuoteGateway.GetWebQuoteByID_element();
		NanaQuoteGateway.wsoChoice el14 = new NanaQuoteGateway.wsoChoice();
		NanaQuoteGateway.GetQuoteDetailByIDResponse_element el15 = new NanaQuoteGateway.GetQuoteDetailByIDResponse_element();
		NanaQuoteGateway.HandleQuoteRequestResult_element el16 = new NanaQuoteGateway.HandleQuoteRequestResult_element();
		NanaQuoteGateway.GetSolidworksLinkResponse_element el17 = new NanaQuoteGateway.GetSolidworksLinkResponse_element();
		NanaQuoteGateway.GetQuoteByIDResponse_element el18 = new NanaQuoteGateway.GetQuoteByIDResponse_element();
		NanaQuoteGateway.HandleQuoteRequestResponse_element el19 = new NanaQuoteGateway.HandleQuoteRequestResponse_element();
		NanaQuoteGateway.UpdateUser_element el20 = new NanaQuoteGateway.UpdateUser_element();
		NanaQuoteGateway.EQuoteMetric_element el21 = new NanaQuoteGateway.EQuoteMetric_element();
		NanaQuoteGateway.GetQuoteByID2Result_element el22 = new NanaQuoteGateway.GetQuoteByID2Result_element();
		NanaQuoteGateway.HandleQuoteRequest_element el23 = new NanaQuoteGateway.HandleQuoteRequest_element();
		NanaQuoteGateway.ArrayOfWsoQuote el24 = new NanaQuoteGateway.ArrayOfWsoQuote();
		NanaQuoteGateway.EQuoteMetricResult_element el25 = new NanaQuoteGateway.EQuoteMetricResult_element();
		NanaQuoteGateway.wsoLead el26 = new NanaQuoteGateway.wsoLead();
		NanaQuoteGateway.HandleQuoteRequest2_element el27 = new NanaQuoteGateway.HandleQuoteRequest2_element();
		NanaQuoteGateway.ArrayOfWsoLead el28 = new NanaQuoteGateway.ArrayOfWsoLead();
		NanaQuoteGateway.GetProjectsByLeadIDResponse_element el29 = new NanaQuoteGateway.GetProjectsByLeadIDResponse_element();
		NanaQuoteGateway.GetQuoteDetailsByIDResponse_element el30 = new NanaQuoteGateway.GetQuoteDetailsByIDResponse_element();
		NanaQuoteGateway.CreateQuote_element el31 = new NanaQuoteGateway.CreateQuote_element();
		NanaQuoteGateway.ArrayOfString el32 = new NanaQuoteGateway.ArrayOfString();
		NanaQuoteGateway.AuthenticateUserResponse_element el33 = new NanaQuoteGateway.AuthenticateUserResponse_element();
		NanaQuoteGateway.AvailableProjectTypes_element el34 = new NanaQuoteGateway.AvailableProjectTypes_element();
		NanaQuoteGateway.wsoAddress el35 = new NanaQuoteGateway.wsoAddress();
		NanaQuoteGateway.GetQuoteDetailsByID_element el36 = new NanaQuoteGateway.GetQuoteDetailsByID_element();
		NanaQuoteGateway.GetAllUsersXMLResponse_element el37 = new NanaQuoteGateway.GetAllUsersXMLResponse_element();
		NanaQuoteGateway.AuthenticateUserResult_element el38 = new NanaQuoteGateway.AuthenticateUserResult_element();
		NanaQuoteGateway.GetWebQuoteByIDResult_element el39 = new NanaQuoteGateway.GetWebQuoteByIDResult_element();
		NanaQuoteGateway.GetQuoteDetailByIDResult_element el40 = new NanaQuoteGateway.GetQuoteDetailByIDResult_element();
		NanaQuoteGateway.ArrayOfWsoChoice el41 = new NanaQuoteGateway.ArrayOfWsoChoice();
		NanaQuoteGateway.AssociateLead_element el42 = new NanaQuoteGateway.AssociateLead_element();
		NanaQuoteGateway.GetQuoteByID_element el43 = new NanaQuoteGateway.GetQuoteByID_element();
		NanaQuoteGateway.GetUserXmlByUsername_element el44 = new NanaQuoteGateway.GetUserXmlByUsername_element();
		NanaQuoteGateway.GetQuoteDetailByID_element el45 = new NanaQuoteGateway.GetQuoteDetailByID_element();
		NanaQuoteGateway.GetQuotesByProjectID_element el46 = new NanaQuoteGateway.GetQuotesByProjectID_element();
		NanaQuoteGateway.GetAllUserNames_element el47 = new NanaQuoteGateway.GetAllUserNames_element();
		NanaQuoteGateway.ArrayOfWsoProject el48 = new NanaQuoteGateway.ArrayOfWsoProject();
		NanaQuoteGateway.wsoProjectType el49 = new NanaQuoteGateway.wsoProjectType();
		NanaQuoteGateway.HandleQuoteRequest2Response_element el50= new NanaQuoteGateway.HandleQuoteRequest2Response_element();
		NanaQuoteGateway.GetSolidworksSingle_element el51 = new NanaQuoteGateway.GetSolidworksSingle_element();
		NanaQuoteGateway.GetAllUsersXMLResult_element el52 = new NanaQuoteGateway.GetAllUsersXMLResult_element();
		NanaQuoteGateway.wsoProject el53 = new NanaQuoteGateway.wsoProject();
		NanaQuoteGateway.Get3DFormats_element el54 = new NanaQuoteGateway.Get3DFormats_element();
		NanaQuoteGateway.wsoQuoteDetail el55 = new NanaQuoteGateway.wsoQuoteDetail();
		NanaQuoteGateway.ArrayOfInt el56 = new NanaQuoteGateway.ArrayOfInt();
		NanaQuoteGateway.XML_element el57 = new NanaQuoteGateway.XML_element();
		NanaQuoteGateway.settings_element el58 = new NanaQuoteGateway.settings_element();
		NanaQuoteGateway.GetSolidworksLink_element el59 = new NanaQuoteGateway.GetSolidworksLink_element();
		NanaQuoteGateway.ArrayOfWsoProjectType el60 = new NanaQuoteGateway.ArrayOfWsoProjectType();
		NanaQuoteGateway.GetWebQuoteByIDResponse_element el61 = new NanaQuoteGateway.GetWebQuoteByIDResponse_element();
		NanaQuoteGateway.GetProjectsByLeadID_element el62 = new NanaQuoteGateway.GetProjectsByLeadID_element();
		NanaQuoteGateway.GetSolidworksResponse_element el63 = new NanaQuoteGateway.GetSolidworksResponse_element();
		NanaQuoteGateway.AssociateLeadResponse_element el64 = new NanaQuoteGateway.AssociateLeadResponse_element();
		NanaQuoteGateway.EQuoteMetricResponse_element el65 = new NanaQuoteGateway.EQuoteMetricResponse_element();
		NanaQuoteGateway.ArrayOfWsoRep el66 = new NanaQuoteGateway.ArrayOfWsoRep();
		NanaQuoteGateway.GetQuotesByProjectIDResponse_element el67 = new NanaQuoteGateway.GetQuotesByProjectIDResponse_element();
		NanaQuoteGateway.wsoRep el68 = new NanaQuoteGateway.wsoRep();
		NanaQuoteGateway.AuthenticateUser_element el69 = new NanaQuoteGateway.AuthenticateUser_element();
		NanaQuoteGateway.UpdateUserResponse_element el70 = new NanaQuoteGateway.UpdateUserResponse_element();
		NanaQuoteGateway.UpdateLeadResponse_element el71 = new NanaQuoteGateway.UpdateLeadResponse_element();
		NanaQuoteGateway.CreateQuoteResponse_element el72 = new NanaQuoteGateway.CreateQuoteResponse_element();
		
		NanaQuoteGateway.QuoteGatewaySoap qgw = new NanaQuoteGateway.QuoteGatewaySoap();
		
		//need to wrap the calls, because you will get failures on every callout
		try {
			qgw.GetUserXmlByUsername('');
		} catch( Exception ex ){}
		
		try {
			qgw.GetQuoteByID(1);
		} catch( Exception ex ){}
		
		try {
			NanaQuoteGateway.QuoteRequestInput_element QuoteRequestInput = new NanaQuoteGateway.QuoteRequestInput_element();
			qgw.HandleQuoteRequest(QuoteRequestInput);
		} catch( Exception ex ){}
		
		try {
			qgw.GetSolidworks(1);
		} catch( Exception ex ){}
		
		try {
			qgw.UpdateLead('', new NanaQuoteGateway.settings_element() );
		} catch( Exception ex ){}
		
		try {
			qgw.CreateQuote('' );
		} catch( Exception ex ){}
		
		try {
			qgw.UpdateUser('', new NanaQuoteGateway.settings_element() );
		} catch( Exception ex ){}
	
		try {
			qgw.GetWebQuoteByID(1 );
		} catch( Exception ex ){}
	
		try {
			qgw.GetSolidworksLink( '' );
		} catch( Exception ex ){}
	
		try {
			qgw.AuthenticateUser( '', '', '');
		} catch( Exception ex ){}
	
		try {
			qgw.GetAllUserNames();
		} catch( Exception ex ){}
	
		try {
			qgw.Get3DFormats();
		} catch( Exception ex ){}
	
		try {
			qgw.GetQuotesByProjectID(1);
		} catch( Exception ex ){}
	
		try {
			qgw.GetQuoteDetailsByID(1);
		} catch( Exception ex ){}
	
		try {
			qgw.GetAllUsersXML();
		} catch( Exception ex ){}
	
		try {
			qgw.GetQuoteByID2(1);
		} catch( Exception ex ){}
	
		try {
			qgw.GetQuoteDetailByID(1);
		} catch( Exception ex ){}
	
		try {
			qgw.HandleQuoteRequest2('');
		} catch( Exception ex ){}
	
		try {
			qgw.AssociateLead( 1, 1, 1, '') ;
		} catch( Exception ex ){}
	
		try {
			qgw.GetProjectsByLeadID( 1);
		} catch( Exception ex ){}
	
		try {
			qgw.AvailableProjectTypes();
		} catch( Exception ex ){}
	
		try {
			qgw.GetSolidworksSingle( 1, false );
		} catch( Exception ex ){}
	
		try {
			qgw.EQuoteMetric( '', 1, 1 );
		} catch( Exception ex ){}
	
		
		
	}
}