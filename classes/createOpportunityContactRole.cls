/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : June 2015
    @ Test File     : NA
    Function        : Helper class for ProjectContact_Update Trigger
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/

public  class createOpportunityContactRole {
	
	/***********************************************************************************************************************************************
             * @author :- Nitish Kumar
             * @date  :-  June-2015
             * @description :- Static Void method which creates/updates standard Opportunity Team Member whenever a custom Opportunity Contact Role
                               is created. It also deletes the previous custom Opportunity Contact Role and inserts the new one. Keeps the custom and 
                               standard opportunity contact role in sync for insert/update operations.
             * @param :- NA
    ***********************************************************************************************************************************************/
	
	public static void createOppContactRole(list<nrOpportunityContactRole__c> custOppConRolelst){
		
	 map<String,nrOpportunityContactRole__c> custOppConRoleMap = new map<String,nrOpportunityContactRole__c>();
	 map<String,OpportunityContactRole> OppConRoleMap = new map<String,OpportunityContactRole>();
	 set<id> oppIdSet = new set<id>();
	 set<Id> conIds = new set<id>();
	 
	 list<OpportunityContactRole> oppConRoletoInsertlst = new list<OpportunityContactRole>();
	 list<OpportunityContactRole> oppConRoletoUpdatelst = new list<OpportunityContactRole>();
	 
	 for (nrOpportunityContactRole__c custoppConRole : custOppConRolelst){
	 	custOppConRoleMap.put(custoppConRole.Opportunity__c + '#' + custoppConRole.Contact__c,custoppConRole);
	 	oppIdSet.add(custoppConRole.Opportunity__c);
	 	conIds.add(custoppConRole.Contact__c);
	 }
	 
	 list<OpportunityContactRole> existOppConRolelst = [select ContactId,IsPrimary,OpportunityId,Role from OpportunityContactRole where OpportunityId =: oppIdSet ];
	 
	 for (OpportunityContactRole oppConRole : existOppConRolelst){
	 	OppConRoleMap.put(oppConRole.OpportunityId + '#' + oppConRole.ContactId,oppConRole);
	 }
	 
	 for (nrOpportunityContactRole__c custoppConRole : custOppConRolelst){
	 	 if (OppConRoleMap.containsKey(custoppConRole.Opportunity__c + '#' + custoppConRole.Contact__c)){
	 	 	 OpportunityContactRole oppConRoleUpd = OppConRoleMap.get(custoppConRole.Opportunity__c + '#' + custoppConRole.Contact__c) ;
	 	 	 oppConRoleUpd.IsPrimary = custoppConRole.Primary__c ;
	 	 	 oppConRoleUpd.Role = custoppConRole.Role__c ;
	 	 	 oppConRoletoUpdatelst.add(oppConRoleUpd);
	 	 }
	 	 else{
	 	 	OpportunityContactRole oppConRoleIns = new OpportunityContactRole();
	 	 	oppConRoleIns.Role = custoppConRole.Role__c ;
	 	 	oppConRoleIns.OpportunityId = custoppConRole.Opportunity__c ;
	 	 	oppConRoleIns.ContactId = custoppConRole.Contact__c ;
	 	 	oppConRoleIns.IsPrimary = custoppConRole.Primary__c ;
	 	 	oppConRoletoInsertlst.add(oppConRoleIns);
	 	 }
	 }
	 
	 if (oppConRoletoUpdatelst.size() > 0){
	 	 Database.saveresult[] sr = Database.update(oppConRoletoUpdatelst, False); 
         ErrorLogUtility.processErrorLogs(sr, oppConRoletoUpdatelst, 'createOpportunityContactRole', 'createOppContactRole', 'OpportunityContactRole', 'Update');
	 }
	 
	 if (oppConRoletoInsertlst.size() > 0){
	 	 Database.saveresult[] sr = Database.insert(oppConRoletoInsertlst, False);
         ErrorLogUtility.processErrorLogs(sr, oppConRoletoInsertlst, 'createOpportunityContactRole', 'createOppContactRole', 'OpportunityContactRole', 'Insert');
	 }
	 
	  Async_WebServiceCaller.SynchronizeContacts(conIds);
	}
	
	/***********************************************************************************************************************************************
             * @author :- Nitish Kumar
             * @date  :-  June-2015
             * @description :- Static Void method which deletes standard Opportunity Team Member whenever a custom Opportunity Contact Role
                               is deleted. 
             * @param :- NA
    ***********************************************************************************************************************************************/
	
	public static void deleteOppContactRole(list<nrOpportunityContactRole__c> custOppConRolelst){
		
	 map<String,nrOpportunityContactRole__c> custOppConRoleMap = new map<String,nrOpportunityContactRole__c>();
	 map<String,OpportunityContactRole> OppConRoleMap = new map<String,OpportunityContactRole>();
	 set<id> oppIdSet = new set<id>();
	 
	 list<OpportunityContactRole> oppConRoletoDeletelst = new list<OpportunityContactRole>();
	 
	 for (nrOpportunityContactRole__c custoppConRole : custOppConRolelst){
	 	custOppConRoleMap.put(custoppConRole.Opportunity__c + '#' + custoppConRole.Contact__c,custoppConRole);
	 	oppIdSet.add(custoppConRole.Opportunity__c);
	 }
	 
	 list<OpportunityContactRole> existOppConRolelst = [select ContactId,IsPrimary,OpportunityId,Role from OpportunityContactRole where OpportunityId =: oppIdSet order by CreatedDate asc];
	 
	 for (OpportunityContactRole oppConRole : existOppConRolelst){
	 	OppConRoleMap.put(oppConRole.OpportunityId + '#' + oppConRole.ContactId,oppConRole);
	   }
	   
	  for (nrOpportunityContactRole__c custoppConRole : custOppConRolelst){
	 	 if (OppConRoleMap.containsKey(custoppConRole.Opportunity__c + '#' + custoppConRole.Contact__c)){
	 	 	oppConRoletoDeletelst.add(OppConRoleMap.get(custoppConRole.Opportunity__c + '#' + custoppConRole.Contact__c));
	 	 }
	  }
	  
	  if (oppConRoletoDeletelst.size() > 0){
	  	Database.DeleteResult[] sr = Database.delete(oppConRoletoDeletelst, false);
        ErrorLogUtility.processDeleteErrorLogs(sr, oppConRoletoDeletelst, 'createOpportunityContactRole', 'deleteOppContactRole', 'OpportunityContactRole', 'Delete');
	  }	 
	   
	}	 

}