/*********************************************************************************************************************
Trigger Name: ProjectTrigger
Events: after insert,after update
Description: This trigger is run when there are Updates on Project and also when a new Project is being created
            It contains all the new Business Logic of Project.
**********************************************************************************************************************/

trigger Project_Trigger on Project__c (before insert, before update,after insert, after update) {
    
    /************************************************************************************************
     Trigger on Before Insert and Before Update for Project Owner assignment and validating the Zip 
     Code and after insert for approval process. 
    *************************************************************************************************/
       //Added by Satish Lokinindi 
       if(Limits.getQueries()<50){
       System.debug('I am here with Limit in project'+Limits.getQueries());
       if(trigger.isUpdate && trigger.isAfter)
       {
            for(project__c pro: Trigger.new){
            //invoke the approval process
                    if(Trigger.oldMap.get(pro.id).Send_for_Approval__c!=pro.Send_for_Approval__c)
                    {        
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setComments('Approval Process using Trigger');
                        req.setObjectId(pro.Id);
                        Approval.ProcessResult result;
                        try{
                        // submit the approval request for processing
                        result = Approval.process(req);
                        }catch(Exception e){
                        System.debug('No approval process has been setup yet.');
                        }
                    }
                        
                    //Basis on approval status ,send out mails 
                    if(Trigger.oldMap.get(pro.Id).Approval_Status__c!=pro.Approval_Status__c){
                         projectOwnerAssignment.sendApprovalRejectMails(Trigger.New);
                    }
                         
                     
             }
        }

    //Validate the zip before the assigning ownership 
         list<Project__c> lstProjects= new list<Project__c>();
         if(trigger.isbefore)
         {
             for(Project__c ProRec : trigger.New)
             {
               if((Trigger.isInsert || (Trigger.isUpdate &&
               (Trigger.oldMap.get(ProRec.Id).project_zip_code__c!=ProRec.project_zip_code__c || Trigger.oldMap.get(ProRec.Id).project_state__c!=ProRec.project_state__c || Trigger.oldMap.get(ProRec.Id).Project_Country__c!=ProRec.Project_Country__c )))&&
               projectOwnerAssignment.validateZip(ProRec))
               {
                 lstProjects.add(ProRec);
               }
             }
          
         //null check    
         if(lstProjects!=null && lstProjects.size()>0)
            {
            //method to assign ownership once it passes through zip validations
              projectOwnerAssignment.assignOwner(lstProjects);
             }
          }
          
    /************************************************************************************************
     Added by Satish Lokinindi
     Trigger on Before Update
     This Is added to validate the Project stage before Setting it to Project cancelled 
    *************************************************************************************************/  
    if(trigger.isBefore && trigger.isUpdate){
        set<Project__c> projectSet = new set<Project__c>();
        for(Project__c pr : trigger.new){
            //Check for project closed lost stages and if manually set to lost ,then validate for any closed won Opportunities under the project
            if(pr.stage__c == 'Closed Lost - Project Lost' || pr.stage__c == 'Closed Lost - Project Cancelled' || pr.stage__c == 'Closed - Inactivity' ){
              projectSet.add(pr);
            }
        }
        //null check
        if(projectSet.size()>0)
        {
        //Method to validate when the project is set to closed lost stages
          projectStageUpdate.validateProjectStageonClosedWonOppBeforeCancel(projectSet);
        }
    }
    
    
    /************************************************************************************************
     Trigger on After Insert and After Update
    *************************************************************************************************/
    if (trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        
        if(Trigger.isInsert){
            ProjectHelper.createProjSplitLocation(trigger.new);
            
            projectOwnerAssignment.createReadOnlyAccessonProjectCreation(trigger.new);
        }
        
        List<Project__c> projOppList = new List<Project__c>();
        List<Id> lstProjIds = new List<Id>();
        List<Id> lstProjIdsToUpdateOpps = new List<Id>();
        Set<Id> setProjIds= new set<Id>();
        Set<Id> setProjIds2= new set<Id>();
        Map<Id,Id> projIdArchitectIdMap = new Map<Id,Id>();
        Map<Id,Id> architectIdOwnerIdMap = new Map<Id,Id>();
        List<OpportunityTeamMember> otmList = new List<OpportunityTeamMember>(); 
        list<Project__c> projListforOwnerChange = new list<Project__c>();
        list<Project__c> projListArchitech = new list<Project__c>();
        
        /*** When Architect Account is added to Project, then the 'Owner'
         *** of the Architect Account record to the Opportunity Team as Member
         *** Role = Architect Owner (in picklist).
         ***/
        for(Project__c prj : Trigger.new){
         
            if(Trigger.isUpdate && prj.Architect_Account__c != null && prj.Architect_Account__c != Trigger.oldMap.get(prj.Id).Architect_Account__c){   
                projIdArchitectIdMap.put(prj.Id,prj.Architect_Account__c);
                projListArchitech.add(prj);
            }
            if(Trigger.isInsert && prj.Architect_Account__c != null){
                projIdArchitectIdMap.put(prj.Id,prj.Architect_Account__c);
                 projListArchitech.add(prj);
            }
            if(Trigger.isUpdate && (prj.Stage__c=='Closed Lost - Project Lost'|| prj.stage__c=='Closed Lost - Project Cancelled' || prj.stage__c=='Closed - Inactivity') && prj.Stage__c != Trigger.oldMap.get(prj.Id).stage__c){
                 lstProjIds.add(prj.id);
            }
            if(Trigger.isUpdate && (prj.Name != Trigger.oldMap.get(prj.Id).Name)){
                lstProjIdsToUpdateOpps.add(prj.Id);
            }
            if (Trigger.isUpdate && (prj.OwnerId != Trigger.oldMap.get(prj.Id).OwnerId)){
                projListforOwnerChange.add(prj);
            }
            if(Trigger.isAfter && Trigger.isInsert && prj.corporate_account__c){
                setProjIds.add(prj.Id);
            }
            if(Trigger.isAfter && Trigger.isUpdate && (!trigger.oldMap.get(prj.id).corporate_account__c) && prj.corporate_account__c){
                setProjIds.add(prj.Id);
            }
            if(Trigger.isAfter && Trigger.isInsert && prj.Residential_Vertical__c){
                setProjIds2.add(prj.Id);
            }
            if(Trigger.isAfter && Trigger.isUpdate && (!trigger.oldMap.get(prj.id).Residential_Vertical__c) && prj.Residential_Vertical__c){
                setProjIds2.add(prj.Id);
            }
            
        }
        
        try{
            if (lstProjIds.size()>0){
                projectStageUpdate.updateRelatedOpps(lstprojIds);
            }
            if (setProjIds.size()>0){
                projectHelper.updateCorpAccFrmProj(setProjIds);
            }
            if (setProjIds2.size()>0){
                projectHelper.updateResidentialVerticalFrmProj(setProjIds2);
            }
            if(lstProjIdsToUpdateOpps.size()>0){
                projectStageUpdate.updateOppNames(lstProjIdsToUpdateOpps,'Project');
            }
            
            if (projListforOwnerChange.size() >0){
                 projectOwnerAssignment.updateOppTeam(projListforOwnerChange);
                 
                 projectHelper.createProjSplitLocation(projListforOwnerChange);
            }
            
            if(projListArchitech.size() > 0){
                ProjectHelper.createProjSplitSpecifier(projListArchitech);
            }
            
            if(!projIdArchitectIdMap.isEmpty()){
                for(Account archAcc : [SELECT Id, Name, OwnerId FROM Account WHERE Id IN :projIdArchitectIdMap.values()]){
                    architectIdOwnerIdMap.put(archAcc.Id,archAcc.OwnerId);
                }
            
                for(Project__c prj : [SELECT Id, (SELECT Id, Amount FROM Opportunities__r) FROM Project__c WHERE Id IN :projIdArchitectIdMap.keySet()]){
                    for(Opportunity opp : prj.Opportunities__r){
                        if(architectIdOwnerIdMap.get(projIdArchitectIdMap.get(prj.Id)) != null){
                            OpportunityTeamMember otm = new OpportunityTeamMember();
                            otm.OpportunityId = opp.Id;
                            otm.UserId = architectIdOwnerIdMap.get(projIdArchitectIdMap.get(prj.Id));
                            otm.TeamMemberRole = 'Architect Owner';
                            otmList.add(otm);
                        }
                    }
                }
                
                if(otmList.size() > 0){
                    Database.saveresult[] sr = Database.insert(otmList, False);
                    ErrorLogUtility.processErrorLogs(sr, otmList, 'Project_Trigger', 'updateOppTeam', 'OpportunityTeamMember', 'Insert');
                }
            }
        }
        catch(Exception ex){
            System.Debug('Error in Project_Trigger. Error is :: ' + ex.getMessage());
        }
    }
    
    /**************************************************************************************************************/
    /*** AFTER INSERT / AFTER UPDATE ***/
    if (trigger.isAfter && trigger.isUpdate){
    
        List<Project__c> lstNewProj = Trigger.new;
        Map<Id,Project__c> mapOldProj = Trigger.oldMap;
        
        //For Recalculating the Apex SHaring on Insert of Project Sharing records
        if(UtilityClass.projSharingRecalOnInsertUpdate==TRUE ){ 
            ProjectHelper.projSharingRecalOnInsertUpdate(lstNewProj, mapOldProj);
            UtilityClass.projSharingRecalOnInsertUpdate = FALSE ;
        }
     }
    /**************************************************************************************************************/
    }
}