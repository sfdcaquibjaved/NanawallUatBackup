public with sharing class nrOppContact_RelatedList_Controller {

	private boolean adminAccess = null;
	private boolean HasAdminAccess() {
		
		if( adminAccess == null )
		{
			Profile p = [SELECT id FROM profile where id = :GlobalStrings.RequiredProfileIDForSharePool()];
			adminAccess = ( Userinfo.getProfileId() == p.id ? false : true ); //if they have the rep profile, they are invalid
		}	
		
		return adminAccess;
	}

	public boolean getHasDeleteAccess() {
		return HasAdminAccess();
	}
	public boolean getHasUpdateAccess() {
		return true;
	}

	public string NewOCRURL{ 
	
		get {		return 'http://'+GlobalStrings.HostName() + '/apex/nrOppContactRoleNew?CF00NA0000001O59J='+this.o.Name+'&CF00NA0000001O59J_lkid='+this.o.Id+'&retURL=%2F'+this.o.Id+'&save_new=1&sfdc.override=1'; }
		
		set{} 
	}

	public PageReference RedirectToNew() {
	
		return new PageReference('/apex/nrOppContactRoleNew?CF00NA0000001O59J='+this.o.Name+'&CF00NA0000001O59J_lkid='+this.o.Id+'&retURL=%2F'+this.o.Id+'&save_new=1&sfdc.override=1');
	}

	private final Opportunity o;
	public nrOppContact_RelatedList_Controller(ApexPages.StandardController stdController) {
		this.o = (Opportunity)stdController.getRecord();
		
	}
	
	public PageReference DoDelete() {
	
	
		list<nrOpportunityContactRole__c> deleteNrConts = null;
		set<nrOpportunityContactRole__c> deleteNrContsSet = new set<nrOpportunityContactRole__c>();
		
		for( nrOpportunityContactRole__c ocr :  [SELECT id FROM nrOpportunityContactRole__c WHERE id = :ActionId OR ( Contact__c = :DeleteContactId AND Opportunity__c = :DeleteOppId ) ] ) 
		{
			if(!deleteNrContsSet.contains(ocr) )
				deleteNrContsSet.add(ocr);
		}
		deleteNrConts = new List<nrOpportunityContactRole__c>(deleteNrContsSet);
		
		
		if( deleteNrConts.size() > 0 )
			delete deleteNrConts;
		return null;
	}
	
	public string ActionId { get; set; }
	public string DeleteOppId { get; set; }
	public string DeleteContactId { get; set; }

	
	public list<nrOpportunityContactRole__c> getOppContacts() 
	{
		list<nrOpportunityContactRole__c> ret = new list<nrOpportunityContactRole__c>();
		set<string> existingJoins = new set<string>();
		
		list<nrOpportunityContactRole__c> deleteJoins = new list<nrOpportunityContactRole__c>();
		for( nrOpportunityContactRole__c ocr :  [SELECT Id, Contact__r.FirstName, Contact__r.LastName, Contact__r.Phone, Contact__r.Account.Name, Role__c, Opportunity__c, Contact__c FROM nrOpportunityContactRole__c WHERE Opportunity__c = :o.Id] )
		{
 			if( existingJoins.contains(ocr.Opportunity__c + '_' + ocr.Contact__c) )
 			{
 				deleteJoins.add( ocr);
 				continue;
 			}
			ret.add(ocr);
			existingJoins.add(ocr.Opportunity__c + '_' + ocr.Contact__c);
		}
		
		
		if( deleteJoins.size() > 0 )
		{ //dont auto-delete right now. just hide the dupe
//			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'I need to clean up ' + deleteJoins.size() + ' join objects.'  ));		
		}

		
		
		return ret;
	}
	

}