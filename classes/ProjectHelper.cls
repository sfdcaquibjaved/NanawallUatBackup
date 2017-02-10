/**********************************************************************
Apex Test Class: ProjectHelper
Description: This class is used to write all business logic related to Project Trigger .
Created Date: June 19th , 2015            
***********************************************************************/

public class ProjectHelper {
     /*************************************************
    Method Name: projSharingRecalOnInsertUpdate
    Description: T
    Input Parameter: Trigger.new and Trigger.OldMap        
    *************************************************/
    public static void projSharingRecalOnInsertUpdate(List<Project__c> lstNewProj , Map<Id,Project__c> mapOldProj) {
        map<Id,Project__c> projMap = new map<Id,Project__c>();
        for (Project__c proj : lstNewProj){
            if (mapOldProj.get(proj.Id).OwnerId != proj.OwnerId){
                projMap.put(proj.Id, proj);
            }
        } 
     
        if (projMap.values().size() > 0){
            projSharingRecal.projShare(projMap); 
       }
    }
    
    /*************************************************
    Method Name: updateCorpAccFrmProj
    Description: T
    Input Parameter: Set of project Ids       
    *************************************************/
    public static void updateCorpAccFrmProj(set<ID> prjIds){
        map<ID,Opportunity> oppMap= new map<Id,opportunity>();
        list<opportunity> listOpp=[Select id,chain_account__c from opportunity where project_name__c IN : prjIds];
        for(opportunity oppToUpdate : listOpp){
            if(!oppToUpdate.chain_account__c){
                oppToUpdate.chain_account__c=True;
                oppMap.put(oppToUpdate.id,oppToUpdate);
            } 
        }
        if(oppMap.values().size()>0){
            Database.saveresult[] sr = Database.update(oppMap.values(), False); 
            ErrorLogUtility.processErrorLogs(sr, oppMap.values(), 'ProjectHelper', 'updateCorpAccFrmProj', 'Opportunity', 'Update');
        }
    }
    
    /*************************************************
    Method Name: updateResidentialVerticalFrmProj
    Description: This method is used for updating opportunities when residential vertical field is changed 
    Input Parameter: Set of project Ids       
    *************************************************/
    public static void updateResidentialVerticalFrmProj(set<ID> prjIds2){
        map<ID,Opportunity> oppMap2= new map<Id,opportunity>();
        list<opportunity> listOpp=[Select id,Residential_Vertical__c from opportunity where project_name__c IN : prjIds2];
        for(opportunity oppToUpdate2 : listOpp){
            if(!oppToUpdate2.Residential_Vertical__c){
                oppToUpdate2.Residential_Vertical__c=True;
                oppMap2.put(oppToUpdate2.id,oppToUpdate2);
            } 
        }
        if(oppMap2.values().size()>0){
            Database.saveresult[] sr = Database.update(oppMap2.values(), False); 
            ErrorLogUtility.processErrorLogs(sr, oppMap2.values(), 'ProjectHelper', 'updateResidentialVerticalFrmProj', 'Opportunity', 'Update');
        }
    }
    
    /******************************************************************************************************************
    Method Name: createProjSplitLocation
    Description: The method adds the Project Split record whenever a Project is created.
    Input Parameter: List of projects       
    *******************************************************************************************************************/
    
    public static void createProjSplitLocation(list<Project__c> projlst){
        
        list<Project_Split__c> splitToInsert = new list<Project_Split__c>();
        map<String,Project_Split__c> mapProjSplit = new map<String,Project_Split__c>();
        set<Id> projId = new set<Id>();
        
        for (Project__c proj : projlst){
            projId.add(proj.Id);
        }
        
        list<Project_Split__c> splitToQuery = [Select Id,Project__c,Project_Rep__c,Role__c from Project_Split__c where Project__c =: projId ];
        
        for (Project_Split__c pSplit : splitToQuery){
            mapProjSplit.put(pSplit.Project__c + '#' + pSplit.Project_Rep__c + '#' + pSplit.Role__c,pSplit);
        }
        
        for (Project__c proj :  projlst){
            
             if (!mapProjSplit.containsKey(proj.Id + '#' + proj.OwnerId + '#' + 'Location')){
             
             Project_Split__c projSplit = new Project_Split__c();
             projSplit.Project__c = proj.Id ;
             projSplit.Project_Rep__c = proj.OwnerId ;
             projSplit.Role__c = 'Location';
             if(trigger.isInsert){
             projSplit.Split__c = 100 ;
             }
             else{
             projSplit.Split__c = 0 ;
             }
             splitToInsert.add(projSplit);
          } 
        }
        
        if(splitToInsert.size() > 0){
            Database.saveresult[] sr = Database.insert(splitToInsert, False); 
            ErrorLogUtility.processErrorLogs(sr, splitToInsert, 'ProjectHelper', 'createProjSplitLocation', 'Project_Split__c', 'Insert');
        }
        
    }
    
     /****************************************************************************************************************************************
      Method Name: createProjSplitSpecifier
      Description: The method adds the Project Split record whenever a Project is created/updated with an architech account.
      Input Parameter: List of projects       
    *****************************************************************************************************************************************/
    
    public static void createProjSplitSpecifier(list<Project__c> projlst){
        
        list<Project_Split__c> splitToInsert = new list<Project_Split__c>();
        set<Id> projId = new set<Id>();
        map<String,Project_Split__c> mapProjSplit = new map<String,Project_Split__c>();
        
        for (Project__c proj : projlst){
            projId.add(proj.Id);
        }
        
        list<Project__c> querylist = [Select Id,Architect_Account__c, Architect_Account__r.OwnerId from Project__c where Id =: projId];
        
        list<Project_Split__c> splitToQuery = [Select Id,Project__c,Account__c,Project_Rep__c,Role__c from Project_Split__c where Project__c =: projId ];
        
        for (Project_Split__c pSplit : splitToQuery){
            mapProjSplit.put(pSplit.Project__c + '#' + pSplit.Project_Rep__c + '#' + pSplit.Account__c + '#' + pSplit.Role__c,pSplit);
        }
        
        for (Project__c proj :  querylist){
            
             if (!mapProjSplit.containsKey(proj.Id + '#' + proj.Architect_Account__r.OwnerId + '#' + proj.Architect_Account__c + '#' + 'Specifier')){
            
             Project_Split__c projSplit = new Project_Split__c();
             projSplit.Project__c = proj.Id ;
             projSplit.Project_Rep__c = proj.Architect_Account__r.OwnerId ;
             projSplit.Account__c = proj.Architect_Account__c ;
             projSplit.Role__c = 'Specifier';
             projSplit.Split__c = 0 ;
             splitToInsert.add(projSplit);
          }  
        }
        
        if(splitToInsert.size() > 0){
            Database.saveresult[] sr = Database.insert(splitToInsert, False); 
            ErrorLogUtility.processErrorLogs(sr, splitToInsert, 'ProjectHelper', 'createProjSplitLocation', 'Project_Split__c', 'Insert');
        }
        
    }
        /****************************************************************************************************************************************
      Method Name: projCeroCheck
      Description: The method Checks the CERO Checkbox  whenever a Related Quote Detail is created/updated with an CERO  Model.
      Input Parameter: Set Ids of Quotes      
    *****************************************************************************************************************************************/
     public static void projCeroCheck(Set<ID> quoteIds){
       List<Quote__c> quoList = [select id,Project__c,Opportunity__c from Quote__c where ID =:quoteIds ];
         Set<ID> proIds = new Set<ID>();
         list<Project__c> ProjUpdateList = new list<Project__c>();
         for (Quote__c quo: quoList) {
                proIds.add(quo.Project__c);
           }
          if (proIds.size() >0){
            for (Project__c proj: [Select Id,CERO__c  from Project__c Where Id IN: proIds]) {
              proj.CERO__c = true;
              system.debug('ProjectCERO'+proj.CERO__c);
              ProjUpdateList.add(proj);
            }
            if(ProjUpdateList.size()>0){
               Database.saveresult[] sr = Database.update(ProjUpdateList, False); 
                 ErrorLogUtility.processErrorLogs(sr, ProjUpdateList, 'ProjectHelper', 'projCeroCheck', 'Project', 'Update');
            }
          }
     }

}