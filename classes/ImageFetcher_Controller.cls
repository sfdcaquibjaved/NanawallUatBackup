public class ImageFetcher_Controller {

	public pagereference getImage() {
		
		try {


			 string emailtype = Apexpages.currentPage().getParameters().get('emailtype');
			 
			 if(emailtype == 'installer')
			 {
		 		string quoteid = Apexpages.currentPage().getParameters().get('quoteid');
		 		string email = Apexpages.currentPage().getParameters().get('email');
		 		
		 		Quote__c q = [SELECT id,Opportunity__c, Installer_Email_Viewed__c FROM Quote__c WHERE id = :quoteid ];
		 		Opportunity o = [SELECT id, Installer_Email_Viewed__c FROM Opportunity WHERE id = :q.Opportunity__c ];
		 		
		 		Task t = new Task();
		 		t.WhatId = quoteid;
		 		t.Description =  email;
		 		t.subject = 'Installer Email Opened';
		 		t.Status = 'Completed';
		 		t.ActivityDate = Date.today();
		 		
		 		q.Installer_Email_Viewed__c = true;
		 		o.Installer_Email_Viewed__c = true;
		 		
		 		update q;
		 		update o;
		 		insert t;
		 		
			 } else {
				Utility.RegisterQuoteEmailView(Apexpages.currentPage().getParameters().get('quoteid'), false, '', emailtype  );
			 }
		} catch( Exception ex ) {
			utility.JimDebug(ex, 'image fetch controller');
			System.debug('Got an exception in image fetch: ' + ex );
		}

		return null;
	}
}