public with sharing class oppContactRoleControllerOverride {
	
	public nrOpportunityContactRole__c custOppContRole ;
	
	public oppContactRoleControllerOverride(ApexPages.StandardController controller) {
		
	  //To avoid SOQL 
         if (!Test.isRunningTest()) {
            //Adding these fields to avoid additional SOQL query.
            controller.addFields(new List < String > {
                'Opportunity__c'
            });
        }
	  
	  custOppContRole = (nrOpportunityContactRole__c) controller.getRecord(); 
		
	}
	
	public pageReference redirect(){
	  
	  String url = '/apex/oppConRolePage?id=' + custOppContRole.Opportunity__c ;
      PageReference redUrl = new PageReference(url);
      redUrl.setRedirect(true);
      return redUrl ;
	}

}