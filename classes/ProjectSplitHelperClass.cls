/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : July 2015
    @ Test File     : NA
    Function        : Helper Class for Project Split Trigger
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/

public with sharing class ProjectSplitHelperClass {
	
	 /******************************************************************************************************************
      Method Name: validateProjectSplit
      Description: The method Validates the total of any Project Split is equal to 100.
      Input Parameter: NA       
    *******************************************************************************************************************/
	
	public static void validateProjectSplit(list<Project_Split__c> projSplitllist){
		
		map<Id, decimal> existSplitMap = new map<Id, decimal>(); // Map to store the Split Amount
		set<Id> projIds = new set<Id>();
		set<Id> splitIds = new set<Id>();
		
		for (Project_Split__c pSplit : projSplitllist){
			projIds.add(pSplit.Project__c);
			splitIds.add(pSplit.Id);
		}
		
		//Populating the Map
		for (Project_Split__c pSplit : [Select Id, Project__c, Split__c from Project_Split__c where Project__c =: projIds and isDeleted = false and Id Not In: splitIds]){
			
			if (!existSplitMap.containsKey(pSplit.Project__c)){
				existSplitMap.put(pSplit.Project__c,pSplit.Split__c);
			}
			else{
				if(existSplitMap.get(pSplit.Project__c) != null){
				Decimal total = existSplitMap.get(pSplit.Project__c) ;
				If (pSplit.Split__c != null){
				 total = total + pSplit.Split__c;
				}
				existSplitMap.put(pSplit.Project__c,total);
			 }
			}
		}
	   
	 	for (Project_Split__c pSplit : projSplitllist){
			
			if (existSplitMap.get(pSplit.Project__c) != 100){
			 pSplit.addError('The Split percentage should be set to 0 before deleting it');
			 }	
			
		}
	}
}