/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 18-May-2016
    @ Description   : To handle reCaptcha functionality of web-to-case
    @ Audit Trial   : Added custom label refernce and comments
	@ Test Class    : recaptcha_Test
	@ Last Modified Date : 07-June-2016
  
****************************************************************************/
public class reCAPTCHA {

    /* Configuration */

   public reCAPTCHA (Apexpages.standardcontroller controller) 
   {
       
   }
    // The API endpoint for the reCAPTCHA service
    private static String baseUrl = label.reCaptcha_Endpoint; 

    // The keys you get by signing up for reCAPTCHA for your domain
    private static String privateKey = label.reCaptcha_private_key;
    public String publicKey { 
        get { return label.reCaptcha_public_key; }
    } 

    
    
    
    public String myName { get; set; }
    public String myEmail { get; set; }
    
   
    public String challenge { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_challenge_field');
        }
    }
    public String response  { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_response_field');
        }
    }
    
    // Whether the submission has passed reCAPTCHA validation or not
    public Boolean verified { get; private set; }
    
    public reCAPTCHA() {
        this.verified = false;
    }
       /*	
     	 Method Name    : verify
         Purpose        : To verify the captcha entered by user
		 Input Parameter: N/A 
         Created Date   : May 2016
         */
    public PageReference verify() {
        System.debug('reCAPTCHA verification attempt');
        // On first page load, form is empty, so no request to make yet
        if ( challenge == null || response == null ) { 
            System.debug('reCAPTCHA verification attempt with empty form');
            return null; 
        }
                    
        HttpResponse r = makeRequest(baseUrl,
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + response
        );
        
        if ( r!= null ) {
            this.verified = (r.getBody().startsWithIgnoreCase('true'));
        }
        
        if(this.verified) {
            return null;
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The reCAPTCHA code you entered was incorrect. Please try again'));
            // stay on page to re-try reCAPTCHA
            return null; 
        }
    }

    public PageReference reset() {
        return null; 
    }   

    /* Private helper methods */
   @TestVisible 
    private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('reCAPTCHA response: ' + response);
            System.debug('reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
        
    private String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }
}