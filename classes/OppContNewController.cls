public class OppContNewController {

	private final nrOpportunityContactRole__c o;
	public OppContNewController(ApexPages.StandardController stdController) {
		this.o = (nrOpportunityContactRole__c)stdController.getRecord();
	}

 
	public nrOpportunityContactRole__c dummyOCR;
	public nrOpportunityContactRole__c getOCR() {
		return dummyOCR;
	}




	public string getContactName() { 
		Contact c = [SELECT FirstName, LastName FROM Contact WHERE id = :o.Contact__c];
		return c.FirstName + ' ' + c.LastName; 
	}
	public void setContactName( string n ) {  }

	

	public PageReference Save(){

		Opportunity opp = [SELECT id, ownerid, (SELECT User__c FROM nrOpportunityTeamMembers__r t) FROM opportunity WHERE id = :o.Opportunity__c];	
		Contact c = [SELECT c.id, c.ownerid,c.AccountId, c.Account.Chain_Account__c FROM Contact c WHERE id = :o.Contact__c  ];
		insert o;
 

		if( c.account.chain_account__c ) opp.Chain_Account__c = true;
		opp.IsDirty__c = true;
		update opp;

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