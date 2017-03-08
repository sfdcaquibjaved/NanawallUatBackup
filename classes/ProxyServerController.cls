public with sharing class ProxyServerController {

	public string result { get; set; }

	public void doProxyRequest() {
		result = '';
		Map<string,string> params = ApexPages.currentPage().getParameters();
		
		if( params.get('action') != null  )
		{
			if( params.get('action') == 'HandleProxyRequest' )
			{

					HttpRequest req = new HttpRequest(); 
					
					req.setMethod('POST');
					string targetUrl = Encodingutil.base64Decode(params.get('encodedTarget').replace('|equals|','=').replace('|plus|','+') ).toString();
					req.setEndpoint(targetUrl);

					list<string> headers = Encodingutil.base64Decode( params.get('encodedHeaders').replace('|equals|','=').replace('|plus|','+')).toString().split('&');
					for( string pair : headers)
					{
						if( pair != null && pair != '' )
						{
							list<string> vars = pair.split('=');
							req.setHeader(vars[0], vars[1]);
						}
					}
			
					string body =Encodingutil.base64Decode(params.get('encodedEnvelope').replace('|equals|','=').replace('|plus|','+')).toString();
					req.setBody(body );		
					
					Http http = new Http();
					HTTPResponse res = http.send(req); 
					result = '{ "result": "'+Encodingutil.base64Encode(blob.valueof(res.getBody()) )+'"}';	
					
			}
		}
	}
	public ProxyServerController() {
		
	}
}