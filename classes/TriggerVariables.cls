public with sharing class TriggerVariables {
	//global maps for all triggers
	public static map<id,Task> TaskMap_All = new map<id,Task>();	
	public static map<id,list<Task> > Quote_To_TaskMap = new map<id,list<Task>>();	
	public static list<Task> GetTasksFromQuoteIdList(list<Id> quoteIds) 
	{
		return [select id, WhoId, WhatId, Subject, Status from Task where whatid != null  and whatid in :quoteIds ];
	}
	
	
	public static map<id,Account> AccountMap_All = new map<id,Account>();	
	public static list<Account> GetAccountsFromIdList(list<Id> accIds) 
	{ 
		return [SELECT id,Type,ParentId, Franchise_Owner__c, Competitor__c, Name, Order_Count__c FROM Account WHERE id in :accIds];
	}
	 
	
	public static map<id,Lead> LeadMap_All = new map<id,Lead>();
	public static list<Lead> GetLeadsFromIdList(list<Id> ids) 
	{
		return [SELECT  id,Last_Booklet_Sent__c, Photo_Book_Selections__c FROM Lead WHERE id in :ids];
	}


	public static map<id,Contact> ContactMap_All = new map<id,Contact>();
	public static list<Contact> GetContactsFromIdList(list<Id> ids) 
	{
		return [SELECT  id,Photo_Book_Selections__c,Last_Booklet_Sent__c,LeadType__c, quote_count__c, order_count__c, Showroom_to_Visit__c, ShowroomInfo__c, accountid, ownerid FROM Contact WHERE id in :ids];
	}

	public static map<id,Opportunity> OpportunityMap_All = new map<id,Opportunity>();
	public static list<Opportunity> GetOpportunitiesFromIdList(list<Id> ids) 
	{
		return [SELECT  id,  Max_Finalized_Date__c, Attachment_List__c, Competitor_List__c,CAD_Viewed__c FROM Opportunity WHERE id in :ids];
	}


	public static map< Id, Service_Part__c> ServicePartMap_All = new map<Id,Service_Part__c>();
	public static list<Service_Part__c> GetServicePartsByIdList(list<Id> ids) 
	{
		return [Select s.Id, s.Number_Stocked__c, s.Stocked__c, s.name, s.Part_Name__c, s.Retail_Cost__c, s.Vendor_Cost__c  from Service_Part__c s WHERE ID in :ids];
	}
	
	public static map< Id, Service_Quote_Detail__c> ServiceQuoteDetailMap_All = new map<Id,Service_Quote_Detail__c>();
	public static list<Service_Quote_Detail__c> GetServiceQuoteDetailsFromServiceQuoteList(list<Id> ids) 
	{
		return [SELECT  Id, Service_Part__c,Quantity__c, Service_Quote__c FROM Service_Quote_Detail__c WHERE Service_Quote__c in :ids];
	}
	
	public static map<id,Quote__c> QuoteMap_All = new map<id,Quote__c>();
	public static list<Quote__c> GetQuotesByIdList( list<Id> Ids ) 
	{
		return [select id,Followup_Status__c,Order_Finalized_Date__c,Opportunity__c, Contact__c,SubTotal__c  from Quote__c where id in :Ids];
	}
	
	public static map< id, list<id>> Opportunity_To_ContactList = new map< id, list<id>>();
	public static map< id, list<id>> Opportunity_To_QuoteList = new map< id, list<id>>();
	
	public static list<nrOpportunityContactRole__c> GetnrOpportunityContactRolesByOpportunityIdList( list<Id> ids ) 
	{
		return [SELECT Id, Opportunity__c, Contact__c FROM nrOpportunityContactRole__c WHERE Opportunity__c in :ids ];
	}
	
	public static list<Quote__c> GetQuotesByOpportunityIdList(list<Id> ids ) {
		return [SELECT id,Followup_Status__c,Order_Finalized_Date__c,Opportunity__c, Contact__c, SubTotal__c FROM Quote__c WHERE Opportunity__c in :ids];
	}

	//trigger specific maps
	/******* nrOppContactRoleInsert ****/
	public static map<id,Contact> nrOppContactRoleInsert_ContactMap = null;
	public static map<id,Account> nrOppContactRoleInsert_AccountMap_FromContact = null;
	public static map<id,nrOpportunity_Account__c> nrOppContactRoleInsert_Project_To_nrOpportunity_Account_Map = null;
	public static set<string> nrOppContactRoleInsert_Existing_nrOpportunity_Accounts = null;
	public static list<nrOpportunity_Account__c> GetnrOpportunity_Account_ByProjectIds(list<Id> ids) 
	{
		return [SELECT Account__c, Opportunity__c FROM nrOpportunity_Account__c WHERE Opportunity__c in :ids ];
	}
	public static void nrOppContactRoleInsert_pushNew_nrOpportunity_Accounts(list<nrOpportunity_Account__c> oppAccs) 
	{
		if(nrOppContactRoleInsert_Project_To_nrOpportunity_Account_Map == null)
			nrOppContactRoleInsert_Project_To_nrOpportunity_Account_Map = new  map<id,nrOpportunity_Account__c>();
		
		if(nrOppContactRoleInsert_Existing_nrOpportunity_Accounts == null )
			nrOppContactRoleInsert_Existing_nrOpportunity_Accounts = new set<string>();
			
		for( nrOpportunity_Account__c oa : oppAccs )
		{
			nrOppContactRoleInsert_Project_To_nrOpportunity_Account_Map.put(oa.Opportunity__c, oa);
			if( !nrOppContactRoleInsert_Existing_nrOpportunity_Accounts.contains(oa.Opportunity__c + '_' + oa.Account__c) )
				nrOppContactRoleInsert_Existing_nrOpportunity_Accounts.add(oa.Opportunity__c + '_' + oa.Account__c);
		}
	}
	
	/**** Quote_PostSave *****/
	public static boolean Quote_PostSave_DataLoaded = false;
	
	
	/***** Quote_Delete *****/
	public static boolean Quote_Delete_DataLoaded = false;
	
	/**** LeadConvert *****/
	public static set<string> LeadConvert_existingOCRs = null;
	public static list<nrOpportunityContactRole__c> LeadConvert_getNrOpportunityContactRole_By_ContactIds(list<Id> ids ) 
	{
		return [ SELECT Id, Opportunity__c, Contact__c FROM nrOpportunityContactRole__c WHERE Contact__c IN :ids];
	}
	
	/** ServiceQuote_Upsert ***/
	public static boolean ServiceQuote_Upsert_DataLoaded = false;
	public static boolean ServiceQuote_Upsert_BeforeInsertRan = false;
	public static boolean ServiceQuote_Upsert_BeforeUpdateRan = false;

	/** Quote_Pipeline **/
	public static boolean Quote_Pipeline_DataLoaded = false;
	
	
	/** OpportunitySplit_Insert */
	public static set<string> OpportunitySplit_Insert_existingTeamMembers = new set<string>();
	
	
	/* OpportunityTeamMember_Insert */
	public static set<string> OpportunityTeamMember_Insert_existingSplits = new set<string>();
}