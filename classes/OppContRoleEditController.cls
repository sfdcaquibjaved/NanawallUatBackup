public with sharing class OppContRoleEditController {


	public PageReference checkDelete() {
		
		if( UserInfo.getProfileId() == '00eA0000000QqGHIA0'
		|| UserInfo.getProfileId() == '00eA0000000RgOEIA0'
		|| UserInfo.getProfileId() == '00eA0000000RHCbIAO' )
		{

			nrOpportunityContactRole__c nrocr = [SELECT Id,Opportunity__c,Contact__c FROM nrOpportunityContactRole__c WHERE id = :ApexPages.currentPage().getParameters().get('id')];
			delete nrocr;
			string url = Encodingutil.urlDecode( ApexPages.currentPage().getParameters().get('retURL'), 'utf-8' );
			return new PageReference( url );

			
		} else
			return null;
	}

	private final nrOpportunityContactRole__c o;
	public OppContRoleEditController(ApexPages.StandardController stdController) {
		this.o = (nrOpportunityContactRole__c)stdController.getRecord();
	}


	public string getContactName() { 
		Contact c = [SELECT FirstName, LastName FROM Contact WHERE id = :o.Contact__c];
		return c.FirstName + ' ' + c.LastName; 
	}
	public void setContactName( string n ) {  }

	public PageReference Save(){


		update o;


		PageReference ref = new PageReference('/' + o.Opportunity__c );			
		ref.setRedirect(true);
		return ref;


	}
	public Pagereference Cancel() {
		PageReference ref = new PageReference('/' + o.Opportunity__c );			
		ref.setRedirect(true);
		return ref;
	
	}
}