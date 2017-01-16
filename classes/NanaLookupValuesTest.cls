@isTest
global class NanaLookupValuesTest  {
       static testMethod void myUnitTest(){    
        NanaLookupValues.wsoProjectType NPT = new NanaLookupValues.wsoProjectType();
            NanaLookupValues.ValidCountries_element NVC = new NanaLookupValues.ValidCountries_element();
        NanaLookupValues.ArrayOfWsoCountry NAW = new NanaLookupValues.ArrayOfWsoCountry();
NanaLookupValues.wsoCountry NC = new NanaLookupValues.wsoCountry();
NanaLookupValues.AvailableProjectTypes_element NAP = new NanaLookupValues.AvailableProjectTypes_element();
            NanaLookupValues.UpdateShowroomResponse_element NUS = new  NanaLookupValues.UpdateShowroomResponse_element();
        	NanaLookupValues.States_element NSE = new NanaLookupValues.States_element();
            NanaLookupValues.ArrayOfWsoProjectType NAWP = new NanaLookupValues.ArrayOfWsoProjectType();
            NanaLookupValues.AvailableProjectTypesResponse_element NAPT = new NanaLookupValues.AvailableProjectTypesResponse_element();
            NanaLookupValues.StatesResponse_element NSR = new NanaLookupValues.StatesResponse_element();
            NanaLookupValues.LookupTablesSoap NLTS = new NanaLookupValues.LookupTablesSoap();
            string xml ='foo bar';
                
         
           
           // Test.setMock(WebServiceMock.class, new NanaLookupValues());
 			//  NanaLookupValues.ArrayOfWsoCountry output = NLTS.ValidCountries();

           // NLTS.ValidCountries();
         //  NLTS.UpdateShowroom(xml);
          NanaLookupValues.UpdateShowroom_element NUSE = new NanaLookupValues.UpdateShowroom_element();
            NanaLookupValues.wsoState NS = new NanaLookupValues.wsoState();
            NanaLookupValues.ArrayOfWsoState NAWS = new NanaLookupValues.ArrayOfWsoState();
            NanaLookupValues.ValidCountriesResponse_element NVCR = new NanaLookupValues.ValidCountriesResponse_element();
        }
}