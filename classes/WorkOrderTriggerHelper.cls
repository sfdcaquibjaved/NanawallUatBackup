/**********************************************************************
Apex Class: WorkOrderTriggerHelper
Description: This class is used to write all business logic related to 
             Work Order Trigger
Created Date: 27thApril,2014            
***********************************************************************/
public with sharing class WorkOrderTriggerHelper {

    /*************************************************
    Method Name: checkForOpportunitiesProject
    Description: This method is used to check for Project whose related Opportunities
                have work order present
    Input Parameter: Set of Ids         
    *************************************************/
    public static void checkForOpportunitiesProject(Set<Id> oppIds)
    {
        //Declaration of Variables
        Set<Id> projIds = new Set<Id>();
        Boolean check = false;
        
        //Check for Opportunities and get the associated Project
        List<Opportunity> oppList = [Select Id,Project_Name__c,(Select Id from Work_Orders__r) from Opportunity where ID IN:oppIds];
        for(Opportunity opp:oppList){
            if(opp.Work_Orders__r.size()>0){
            projIds.add(opp.Project_Name__c);
            check = true;
            }
            else{
                projIds.add(opp.Project_Name__c);
                check = false;
            }
        }
        
        //Call method to update the Project status
        if(projIds.size()>0)
        updateProjectStatus(projIds,check);
        
    }

    /*************************************************
    Method Name: updateProjectStatus
    Description: This method is used to update Project Status based on order present or not
    Input Parameter: Set of Ids,Boolean         
    *************************************************/
    public static void updateProjectStatus(Set<Id> projIds,Boolean check){
        //Declaration of Variables
        List<Project__c> updateProjList = new List<Project__c>();
        
        //Query over Project Object
        List<Project__c> projList = [Select Id,Stage__c from Project__c where ID IN:projIds];
        
        for(Project__c proj:projList){
            if(check)
            //If work order present then status is In Progress - Work Order
            proj.Stage__c = UtilityClass.getStringValue('ProjectWorkOrderStatus');
            else
            //if work order are deleted and no work order present then status is In Progress - Order
            proj.Stage__c = UtilityClass.getStringValue('ProjectOrderStatus');
            //add project records to list
            updateProjList.add(proj);   
        }
        
        //Update Project Records
        if(updateProjList.size()>0){
            update updateProjList;
        }
        
    }
}