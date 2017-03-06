public with sharing class nrAccount_ProjectListController {


	private final Account a;
	public nrAccount_ProjectListController(ApexPages.StandardController stdController) {
		this.a = (Account)stdController.getRecord();
		
	}
	private List<nrOpportunityContactRole__c> projects = null;
	public List<nrOpportunityContactRole__c> getProjects() {
		if( projects == null )
		{
			projects = new List<nrOpportunityContactRole__c>();
			for(  nrOpportunityContactRole__c otm : [Select Opportunity__c,Contact__r.FirstName, Contact__r.LastName, n.Opportunity__r.Id, n.Opportunity__r.CreatedDate, n.Opportunity__r.Name, n.Opportunity__r.City__c, n.Opportunity__r.state__c,n.Opportunity__r.Postal_Code__c from nrOpportunityContactRole__c n WHERE n.Contact__r.AccountId = :a.id ] )
			{
				projects.add( otm );
			}
		}
		return projects;
	}
	
}