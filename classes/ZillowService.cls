public class ZillowService {
	
	public String serviceName {get ; private set ; }
	
	public ZillowService( String serviceName ){
		this.serviceName = serviceName ;
	}
	
	public ZillowService() {
	}  
	
	public ZillowTypes.PropertySearchResponse searchZillow( String street, String City, String state, String zip ){
				
		return searchZillow( street, city+ ' ' + state + ' ' + zip ) ;
	}
	
	public ZillowTypes.PropertySearchResponse searchZillow( String street, String City, String state ){
				
		return searchZillow( street, city+ ' ' + state ) ;
	}
	
	 
	public ZillowTypes.PropertySearchResponse searchZillow( String address, String citystatezip ){
		// construct the URL		
		String endpointURL = ZillowConfig.PROPERTY_SEARCH_URL + ZillowConfig.ZWSID + '&address=' + 	EncodingUtil.urlEncode(address, 'UTF-8') + '&citystatezip=' + EncodingUtil.urlEncode(citystatezip, 'UTF-8') ;						
		ZillowTypes.PropertySearchResponse searchResponse = null ;		
		try{			
			HttpResponse response = invokeZillow( 'GET', endpointURL ) ;
			XMLDom responseXML = new XMLDom( response.getBody() ) ;
			String code = responseXML.getElementByTagName('code').nodeValue ;
			if( code == ZillowTypes.CODE_SUCCESS){
				searchResponse = new ZillowTypes.PropertySearchResponse( responseXML.getElementByTagName('response') ) ;
			}
			else{
				throw new ZillowTypes.ZillowException( 'Error in Zillow response - code = '+code +' Description : ' +ZillowTypes.PropertySearchResponseCode.get(code) );	
			}
		}
		catch( System.Exception e){
			string error = 'Error ' + e;
			System.debug( error) ;
			//Utility.JimDebug(e,'Search Zillow');
			throw e ;
		} 
		
		return searchResponse ;
		
	}
	
	// Web service call out 
	private HttpResponse invokeZillow( String method, String url ){		 	
	    HttpRequest  req = new HttpRequest();   
		HttpResponse response = null;
		try {
			if( method != 'GET' ){
				throw new ZillowTypes.ZillowException('ZillowService::invokeZillow - only GET supported  '+method +' is not supported') ;
			}	
		   	req.setEndpoint(url); 
		   	req.setMethod(method) ;
			Http http = new Http();
			response = http.send(req);
		}
		catch( System.Exception e){			
				throw new ZillowTypes.ZillowException('Error sending HTTP message - ERROR: '+ e) ;
		}					
		if (response.getStatusCode() != 200) { 
			throw  new ZillowTypes.ZillowException('Error in HTTP Response - STATUS: ' +response.getStatus() + 'STATUS_CODE:'+ response.getStatusCode()) ;	
		}				 
	    return response ;
	}
	
	 
}

/*****use this fragment to test from IDE or debugger


try{
ZillowService p = new ZillowService() ;
ZillowTypes.PropertySearchResponse r = p.searchZillow( '2114 Bigelow Ave', 'Seattle, WA') ;
Double d = r.getZEstimateAmount() ;
System.debug( '**** HOME VALUATION RETURNED = ' +d ) ;
}
catch( ZillowTypes.ZillowException e){
System.debug( '**** Caught Exception' +e ) ;
}
***********/