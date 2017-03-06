public with sharing class Contact_VerifyEmail {
    private final Contact c;
    public Contact_VerifyEmail(ApexPages.StandardController stdController) {
        this.c = (Contact)stdController.getRecord();
    }
	public string getFieldColor() {
		string status = getVerifyEmail();
		
		if( status == 'OK' )
		{
			return 'green';
		} else if( status == 'REJECTED' )
		{
			return 'red';
		} else return 'darkyellow';
	}
	public string emailStatus {get;set;}
	public string getVerifyEmail() {
		
		if( emailStatus == null )
		{
			try {
			VerifyEmailAddresses.VerifyEmailAddressSoap v = new VerifyEmailAddresses.VerifyEmailAddressSoap();
			emailStatus = v.GetEmailStatus(c.email );
			
			
//emailStatus = c.EmailVerificationStatus__c;
			} catch( exception ex ) {
			emailStatus = 'Lookup failed. Try again later please';
			}
		}				
		
		return emailStatus;
		
	}
	
}