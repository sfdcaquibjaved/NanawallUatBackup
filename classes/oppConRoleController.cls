/*************************************************************************************************
Class Name          : oppConRoleController
Version             : 1.0
Date Created        : 
Function            : This class acts as Controller of custom Opportunity Contact Role Creation VF page.
Modification Log    :
--------------------------------------------------------------------------------------------------
* Developer              Date                    Description
* ---------------        -----------             ----------------------------------------------
  Shubham          6/2/2014         Initial version of the class.
**************************************************************************************************/

public with sharing class oppConRoleController {
	
	public Opportunity opp ;
	public list<oppConRoleWrapper> results {get;set;}
	map<Id,nrOpportunityContactRole__c> conRoleMap {get;set;}
	public Boolean noPrimaryContact {get;set;}
	
	public oppConRoleController(ApexPages.StandardController controller) {
		
		//To avoid SOQL 
         if (!Test.isRunningTest()) {
            //Adding these fields to avoid additional SOQL query.
            controller.addFields(new List < String > {
                'AccountId' ,'Account.Name'
            });
        }
		
		opp = (Opportunity) controller.getRecord();    //Get Opportunity from controller
		
		list<Contact> contactlst = [Select Id,Name from Contact where AccountId =: opp.AccountId];
		
		list<nrOpportunityContactRole__c> existoppConRole = [Select Id,Contact__c,Primary__c,Opportunity__c,Role__c from nrOpportunityContactRole__c where Opportunity__c =: opp.Id];
		
		conRoleMap = new map<Id,nrOpportunityContactRole__c>();
		
		noPrimaryContact = true ;
		
		for (nrOpportunityContactRole__c custOppConRole : existoppConRole){
		if (custOppConRole.Primary__c == true){
			noPrimaryContact = false ;
		}
		conRoleMap.put(custOppConRole.Contact__c , custOppConRole);
		}
		
		results = new list<oppConRoleWrapper>();
		
		for (Contact con : contactlst){
			if (conRoleMap.containsKey(con.Id)){
				oppConRoleWrapper exstoppConWrapp = new oppConRoleWrapper(conRoleMap.get(con.Id),conRoleMap.get(con.Id).Primary__c);
				results.add(exstoppConWrapp);
			}
			else{
				nrOpportunityContactRole__c custOppConRole = new nrOpportunityContactRole__c();
				custOppConRole.Contact__c = con.Id ;
				custOppConRole.Opportunity__c = opp.Id ;
				oppConRoleWrapper oppConWrapp = new oppConRoleWrapper(custOppConRole,false);
				results.add(oppConWrapp);
			}
		}
	 }
	 
	 public pageReference saveRecords(){
	 	
	 	list<nrOpportunityContactRole__c> custOppConRoleToUpdate = new list<nrOpportunityContactRole__c>();
	 	list<nrOpportunityContactRole__c> custOppConRoleToInsert = new list<nrOpportunityContactRole__c>();
	 	
	 	map<Id,Contact> validconIdMap = new map<Id,Contact>();
	 	Boolean errorMessage = false ;
	 	
		list<Contact> contactlst = [Select Id, Name,Account.Name, AccountId from Contact where AccountId =: opp.AccountId];
		
		for (Contact con : contactlst){
			validconIdMap.put(con.Id,con);
		}
	 	
	 	for (oppConRoleWrapper opConRole : results){
	 		if(validconIdMap.containsKey(opConRole.oppConRole.Contact__c)){
	 		if (conRoleMap.containsKey(opConRole.oppConRole.Contact__c)){
	 			opConRole.oppConRole.Primary__c = opConRole.isPrimary ;
	 			custOppConRoleToUpdate.add(opConRole.oppConRole);
	 		}
	 		else{
	 			if (opConRole.oppConRole.Role__c != null){
	 				custOppConRoleToInsert.add(opConRole.oppConRole);
	 			}
	 		 }
	 		}
	 		else{
	 			errorMessage = true ;
	 		}
	 	}
	 	
	 	if (errorMessage){
	 	   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a contact from the contacts of the Account ' + opp.Account.Name));
	 	   return null ;
	 	}
	 	else{
	 	try{
	 	if (custOppConRoleToUpdate.size()>0){
	 		update custOppConRoleToUpdate ;
	 	}
	 	
	 	if(custOppConRoleToInsert.size() > 0){
	 		insert custOppConRoleToInsert ;
	 	}
	 	}
	 	Catch (Exception ex){
	 	}
	 	String url = '/' + opp.Id ;
	    PageReference redUrl = new PageReference(url);
	    redUrl.setRedirect(true); 
	    return redUrl ;
	 	
	 	}
	 	
	    
	 }
	 
	 public PageReference cancel(){
      String url = '/' + opp.Id ;
	  PageReference redUrl = new PageReference(url);
	  redUrl.setRedirect(true);
      return redUrl ;
    }
	
	
	public class oppConRoleWrapper {
		
      public Boolean isPrimary      {get;set;}
      public nrOpportunityContactRole__c oppConRole  {get;set;}
      
	  public oppConRoleWrapper(nrOpportunityContactRole__c opConRole , Boolean primary){
	  	this.oppConRole = opConRole ;
	  	this.isPrimary = primary ;
	  }
	}

}