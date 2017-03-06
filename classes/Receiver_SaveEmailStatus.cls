global public class  Receiver_SaveEmailStatus {

	WebService static boolean SaveContactEmailStatus( Id ContactID, string EmailStatus) {
		
		Contact c = [SELECT id FROM Contact WHERE id = :ContactID ];

		c.EmailVerificationStatus__c =  EmailStatus;

		update c; 
						
		return true;
	} 

}