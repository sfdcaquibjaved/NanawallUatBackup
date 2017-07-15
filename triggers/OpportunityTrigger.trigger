/*********************************************************************************************************************
Trigger Name: OpportunityTrigger
Events: after insert,after update,before insert and before update
Description: This trigger is split in 2 parts, one which runs when Opportunity is updated / inserted manually from UI
             and the other part which executes when the Opportunity is updated via Quote Trigger
**********************************************************************************************************************/
/* =====================================================================================================================================================
 * START <-- OPPORTUNITY UPDATED MANUALLY / FROM UI / DATA LOADER --> START
 * =====================================================================================================================================================
 */
trigger OpportunityTrigger on Opportunity(after insert, after update, before insert,after delete, before update) {

   /*if(!Org_Default_Settings__c.getInstance().OpportunityTrigger__c){
     return;
   }*/
   
   if(Limits.getQueries()<50){
   System.debug('I am here with Limit in opportunity'+Limits.getQueries());
    if(!projectStageUpdate.skipOppTrigger){
        //Declaration of Collections and Variables
        Set<Id> projIds = new Set<Id>();
        Set<Id> projIds2 = new Set<Id>();
        Set<Id> projIds5 = new Set<Id>();
        Set<Id> projIds6 = new Set<Id>();
        Set<Id> projIds7 = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        Set<Id> optyIds = new Set<Id>();
        Set<Id> oppIds2 = new Set<Id>();
        Set<Id> oppIds3 = new Set<Id>();
        Set<Id> accId = new Set<Id>();
        
        Map<Id,String> mpAccIDType = new Map<Id,String>();
        
        //Datetime myDate = datetime.newInstance(2015, 4, 18, 0, 30, 12);
        
        
    
        /*** BEFORE INSERT / BEFORE UPDATE ***/
        if (trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
            
            set<Id> accountId = new set<Id>();
            set<Id> acctId = new set<Id>();
            boolean check;
            for (Opportunity opp: Trigger.new) {
            if (trigger.isInsert){
                accountId.add(opp.AccountId);
            }
            if (trigger.isUpdate){
              if (opp.AccountId != trigger.oldMap.get(opp.Id).AccountId){
                 accountId.add(opp.AccountId);
                 
              }
                System.debug('automatic update erd'+opp.AutomaticUpdateERD__c);
                System.debug('dummy'+opp.Dummy_ManualchangeERD__c);
                  
             if((trigger.oldMap.get(opp.id).CloseDate!=opp.CloseDate) && (Trigger.oldMap.get(opp.id).Quote_Count__c>0) && (Trigger.oldMap.get(opp.id).ManualChangeOfERD__c==false) && (opp.AutomaticUpdateERD__c==false) && (opp.Dummy_ManualchangeERD__c==false))
             {
               opp.ManualChangeOfERD__c=true;
                 
                 
             }
             System.debug('OldCloseddate'+trigger.oldMap.get(opp.id).CloseDate);
             System.debug('ClosedDate'+opp.CloseDate);
               System.debug('mapold manual'+Trigger.oldMap.get(opp.id).ManualChangeOfERD__c);
                System.debug('mapnew manual'+opp.ManualChangeOfERD__c);
                System.debug('quote count trige'+Trigger.oldMap.get(opp.id).Quote_Count__c);
                  System.debug('quote count trige2'+opp.Quote_Count__c);
               if((trigger.oldMap.get(opp.id).Quote_Count__c!=opp.Quote_Count__c) && Trigger.oldMap.get(opp.id).ManualChangeOfERD__c==true && check==false )
             {
                System.debug('quote count trige'+Trigger.oldMap.get(opp.id).Quote_Count__c);
                  System.debug('quote count trige2'+opp.Quote_Count__c);
                        opp.ManualChangeOfERD__c=false;                     
                
                 
             }  
                 if((trigger.oldMap.get(opp.id).Quote_Count__c==opp.Quote_Count__c) && opp.ManualChangeOfERD__c==true)
             {
                System.debug('quote count trige55'+Trigger.oldMap.get(opp.id).Quote_Count__c);
                  System.debug('quote count trige56'+opp.Quote_Count__c);
      
                       check=true;
                 opp.AutomaticUpdateERD__c=false;
                     opp.Dummy_ManualchangeERD__c=false;
        
             }  
              /*if((trigger.oldMap.get(opp.id).CloseDate==opp.CloseDate) && (Trigger.oldMap.get(opp.id).ManualChangeOfERD__c==true) )
              {
                  opp.ManualChangeOfERD__c=true;
              }*/
                
                if(trigger.oldMap.get(opp.id).Quote_Count__c!=opp.Quote_Count__c)
                {
                     opp.AutomaticUpdateERD__c=false;
                     opp.Dummy_ManualchangeERD__c=false;
                }
                   if((trigger.oldMap.get(opp.id).Quote_Count__c==opp.Quote_Count__c) && trigger.oldMap.get(opp.id).ManualChangeOfERD__c==false)
                   {
                       opp.AutomaticUpdateERD__c=false;
                   }
                /*if(trigger.oldMap.get(opp.id).ManualChangeOfERD__c==true)
                {
                        opp.ManualChangeOfERD__c=true;                    
                }
                
                if(trigger.oldMap.get(opp.id).ManualChangeOfERD__c==true && trigger.oldMap.get(opp.id).CloseDate<=System.today())
                {
                    opp.ManualChangeOfERD__c=false; 
                }*/
             }
           
            }
            for (Opportunity opp: Trigger.new) {
            if (trigger.isInsert){
                acctId.add(opp.AccountId);
            }
            if (trigger.isUpdate){
              if (opp.AccountId != trigger.oldMap.get(opp.Id).AccountId||opp.Budget_Quote__c!=trigger.oldMap.get(opp.Id).Budget_Quote__c){
                 acctId.add(opp.AccountId);
                 
              } 
             }
            }
            
            if(accountId.size()>0){
                OpportunityHelper.updateOpportunityOwner(accountId, trigger.new);
                
              }
            if(acctId.size()>0 && UtilityClass.doNotRunOnRecTypeChange){
                
                OpportunityHelper.checkBudgetQuote(acctId,Trigger.New);
              }
          /*   set<ID> setProjID = new set<ID>(); 
              set<ID> setAccID = new set<ID>();           
            for(Opportunity opp:trigger.new){
            setProjID.add(opp.Project_Name__c);
            setAccID.add(opp.AccountID);
            }
            List<Opportunity> oppp =[select id ,Project_Name__c ,AccountID from Opportunity Where Project_Name__c IN:setProjID AND AccountID IN:setAccID];
            system.debug('doNotRunonTransfer'+UtilityClass.doNotRunonTransfer);
            
            if(oppp.size()>0 && UtilityClass.doNotRunonTransfer){
            OpportunityHelper.checkAccOnOpp(trigger.new);
            }*/
            if(UtilityClass.doNotRunonTransfer){
            OpportunityHelper.checkAccOnOpp(trigger.new);
            UtilityClass.doNotRunonTransfer = false ; 
            }
          set<ID> ProjId=new Set<ID>();
          map<id,Boolean> proMap =new map<id,Boolean>();
          set<ID> OCheckID =new Set<ID>();
          
          for(Opportunity opp:trigger.new){
            ProjId.add(opp.Project_Name__c);
          }
          list<Project__c> newProjlist = [select id ,Corporate_Account__c from Project__c where Id =:ProjId];
          if(ProjId.size()>0){
             for (project__c pro: newProjlist){
              if(pro.Corporate_Account__c==true){
                proMap.put(pro.id,pro.Corporate_Account__c) ;
               }
             }
           }
            
           if (trigger.isBefore && Trigger.isInsert) {
                if(proMap.size()>0){
                /*****testing*********/
                //for(Opportunity opp:trigger.new){
                //if(proMap.get(opp.Project_Name__c)==true){
                /*******testing*******/
                   OpportunityHelper.CheckOppCorpAccFromNewOpportunityProject(trigger.new,proMap);
                }
                for(opportunity o : trigger.new){
                o.stagename='Considered';
                }
            //}
            //}
          }
           for (Opportunity opp: Trigger.new) {
              if (trigger.isBefore && Trigger.isUpdate) {
                if(trigger.oldMap.get(opp.Id).Chain_Account__c!=true){
                   OCheckID.add(opp.id);  
                 }
               }
            }
              
            if(proMap.size()>0){
              if(OCheckID.size()>0){      
                OpportunityHelper.CheckOppCorpAccFromNewOpportunityProject(trigger.new,proMap);
              }
             }

            /*** Skip the entire logic of Opportunity Trigger if the update is via Quote Trigger.
             *** Whenever the Opportunities are updated via Quote trigger, then we process them separately.
             ***/
            if (!UtilityClass.updateFromQuoteTrigger) {
                for (Opportunity opp: Trigger.new) {
                    /*** Throw error on Opportunity if User tries to update the Amount field on Opportunity
                     *** manually when there are Quotes associated with an Opportunity. If a quote is
                     *** present on the Opportunity, then the Amount field is locked down for edit by user
                     ***/
                     if(trigger.isUpdate){
                    if (Trigger.oldMap != null && Trigger.oldMap.get(opp.Id) != null && Trigger.NewMap.get(opp.Id).Amount != Trigger.oldMap.get(opp.Id).Amount) {
                        oppIds.add(opp.Id);
                    }
                    }
                    //if ( trigger.oldmap!=null && trigger.oldMap.get(opp.chain_account__c) !=trigger.newMap.get(opp.chain_account__c))
                       //oppIds4.add(opp.Id);
                     //  
                    
                    /*** Check if Opportunity Status is Closed/Won. If an Opportunity has been selected as
                     *** Closed/Won by the user then set the "Primary Opportunity" flag to TRUE
                     *** When Opportunity Stage is manually set to ‘Closed/Won’, Opportunity Close 
                     *** trigger fires, and first validation confirms that ‘Primary Quote’ flag is checked 
                     ***/
                    if(trigger.isInsert){
                    if (opp.StageName == UtilityClass.opportunityWonStatus ) {
                        oppIds2.add(opp.Id);
                     }
                    }
                    if(trigger.isUpdate){
                    if (opp.StageName == UtilityClass.opportunityWonStatus && trigger.oldMap.get(opp.Id).StageName != UtilityClass.opportunityWonStatus) {
                        oppIds2.add(opp.Id);
                     }  
                    }
                  }
                  
                if (oppIds2.size() > 0 && (UtilityClass.runQuoteTrigger == TRUE)) {
                    OpportunityHelper.checkPrimaryQuotes(oppIds2, Trigger.newMap);
                }
    
                   if (oppIds.size() > 0) {
                    //OpportunityHelper.checkRelatedQuotes(oppIds, Trigger.newMap);
                }
        }         
        }
        /*************************************************************************************/
        if(Trigger.isAfter && (trigger.isInsert || Trigger.isUpdate || Trigger.isDelete || Trigger.isUndelete)){
           set<Id> setOppidsForOppTeamInsert = new set<Id>();
           set<Id> setOppTeamToUpdate = new set<Id>();
           set<Id> oppOwnerCheckId = new set<Id>();
           set<Id> setProjIdsForFc = new set<Id>();
           set<Id> setProjIdsForFcUpdate = new set<id>();
           set<Id> setOppDelProj = new set<id>();
           set<Id> setProjIdsForERD= new set<Id>();
           set<Id> setProjIdsForERDUpdate = new set<Id>();
           set<Id> setProjIdsForERDDelete = new set<Id>();
           if(trigger.isInsert || trigger.isUpdate){
            for (Opportunity opp: Trigger.new) {
              If(opp.project_name__c != null )
              {
                
                    setOppidsForOppTeamInsert.add(opp.project_name__c);
                    if(trigger.isInsert )
                    {
                    setProjIdsForFc.add(opp.project_name__c);
                    if(opp.RecordTypeID != label.Influencer_Opportunity_RecordTypeId ){}
                    setProjIdsForERD.add(opp.project_name__c);
                    }
                 
                    if((trigger.isUpdate && Trigger.oldMap.get(opp.id).CloseDate!=opp.CloseDate) && (opp.RecordTypeID != label.Influencer_Opportunity_RecordTypeId))

                    {
                    setProjIdsForERDUpdate.add(opp.project_name__c);             
                    }
                    
                    
              }
              
              if(trigger.isUpdate && (trigger.oldMap.get(opp.Id).OwnerId != opp.ownerId ||  trigger.oldMap.get(opp.Id).Project_Name__c != opp.Project_Name__c)){
                oppOwnerCheckId.add(opp.Id);
              } 
              if(trigger.isUpdate &&  ((trigger.oldMap.get(opp.Id).Project_Name__c != opp.Project_Name__c) || ( trigger.oldMap.get(opp.Id).recordTypeId != opp.recordTypeId))){
                setProjIdsForFcUpdate.add(opp.Project_Name__c);
                if(trigger.oldMap.get(opp.Id).Project_Name__c != null){
                setProjIdsForFcUpdate.add(trigger.oldMap.get(opp.Id).Project_Name__c);  
                }
              } 
              if (trigger.isInsert){
                oppOwnerCheckId.add(opp.Id);
              }
               if(trigger.isUpdate && (trigger.oldMap.get(opp.Id).OwnerId != opp.ownerId ||  trigger.oldMap.get(opp.Id).Project_Name__c != opp.Project_Name__c)){
                    setOppTeamToUpdate.add(opp.project_name__c);
                }
                if(trigger.isInsert && opp.chain_account__c){
                projIds5.add(opp.Project_Name__c);
            } else if (trigger.isUpdate && utilityClass.runUpdateCorpAcc){
                if(trigger.oldMap!=null && (!trigger.oldMap.get(opp.id).chain_account__c && opp.chain_account__c)){
                projIds5.add(opp.project_name__c);
                }
            }
            if(trigger.isInsert && opp.Preliminary_Drawlings__c){
                projIds7.add(opp.Project_Name__c);
            } else if (trigger.isUpdate && utilityClass.runUpdatePrelims){
                if(trigger.oldMap!=null && (!trigger.oldMap.get(opp.id).Preliminary_Drawlings__c && opp.Preliminary_Drawlings__c)){
                projIds7.add(opp.project_name__c);
                }
            }
            if(trigger.isInsert && opp.Residential_Vertical__c){
                projIds6.add(opp.Project_Name__c);
            } else if (trigger.isUpdate && utilityClass.runUpdateResident){
                if(trigger.oldMap!=null && (!trigger.oldMap.get(opp.id).Residential_Vertical__c && opp.Residential_Vertical__c)){
                projIds6.add(opp.project_name__c);
                }
            }
         
          }
        }
             
            if (trigger.isDelete){
                for (opportunity oppDel : trigger.old){
                    if((oppDel.project_name__c != null) && (oppDel.RecordTypeID != label.Influencer_Opportunity_RecordTypeId )){
                        setOppDelProj.add(oppDel.project_name__c);
                        setProjIdsForERDDelete.add(oppDel.project_name__c);  
                    }
                }
            }
             
              if(oppOwnerCheckId.size()>0 &&  UtilityClass.oppUpdateOppTeam == TRUE ) {
                OpportunityHelper.updateOppTeam(oppOwnerCheckId);
                UtilityClass.oppUpdateOppTeam = FALSE ; 
              }
              if(projIds5.size()>0) {
              
                OpportunityHelper.updateCorpAccField(projIds5);
              }
              if(projIds6.size()>0) {
                  
                 OpportunityHelper.updateResidentialVerticalField(projids6);
              }
              if(projIds7.size()>0) {
                  
                 OpportunityHelper.updateProjectPrelimDrawingCheckbox(projids7);
              }

            
              if(setOppidsForOppTeamInsert.size()>0 && trigger.isInsert){
                oppTeamHelper.syncOpportunityTeamMember(setOppidsForOppTeamInsert);
                opportunityHelper.opportunityCountFC(setProjIdsForFc);
              }
              if(setProjIdsForFc.size()>0 && trigger.isInsert){
                opportunityHelper.opportunityCountFC(setProjIdsForFc);
              }
              if(setProjIdsForERD.size()>0 && trigger.isInsert) {
                OpportunityHelper.UpdateERDDate(setProjIdsForERD);
              }
          
              if(setProjIdsForFcUpdate.size()>0 && trigger.isUpdate){
                opportunityHelper.opportunityCountFC(setProjIdsForFcUpdate);
              }
              if(setProjIdsForERDUpdate.size()>0 && trigger.isUpdate){
                OpportunityHelper.UpdateERDDate(setProjIdsForERDUpdate);
              }
              if(setOppTeamToUpdate.size()>0 && trigger.IsUpdate){
                oppTeamHelper.syncOpportunityTeamMember(setOppTeamToUpdate);
              }
              if(setOppDelProj.size() > 0 && trigger.isdelete){
                opportunityHelper.opportunityCountFC(setOppDelProj);
              }
             if(setProjIdsForERDDelete.size()>0 && trigger.isdelete){
                OpportunityHelper.UpdateERDDate(setProjIdsForERDDelete);
              }
              
      }
    /********************************************************************************************************/
      // This Method is Added to Change the Stage name Based on Influencer Record Type Change 
       /*list<Opportunity> UpdateOppList = new list<Opportunity>();
       if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
           for(Opportunity opp :[SELECT id,RecordTypeID,StageName FROM Opportunity WHERE Id IN :Trigger.Newmap.keyset()]){
               if(trigger.isAfter && (trigger.isInsert || (trigger.isUpdate && (trigger.oldmap.get(opp.id).RecordTypeID != opp.RecordTypeID) &&  (opp.RecordTypeID == label.Influencer_Opportunity_RecordTypeId) ))){
                    if((opp.RecordTypeID == label.Influencer_Opportunity_RecordTypeId) && (opp.StageName!= 'Budget Quote - Requested') && (opp.StageName!= 'Budget Quote - Provided') && (opp.StageName!= 'Drawings - Requested')){
                        opp.StageName = 'Considered';
                        UpdateOppList.add(opp);
                    }
                    
                
               }
           }
       }
       if (UpdateOppList.size() > 0) {
           
            Database.saveresult[] sr = Database.update(UpdateOppList, False); 
            ErrorLogUtility.processErrorLogs(sr, UpdateOppList, 'OpportunityTrigger', '', 'Opportunity', 'Update');
        }
       
       */
    /********************************************************************************************************/
    /********************************************************************************************************/
    if (trigger.isAfter && Trigger.isUpdate){
       for (Opportunity opp: Trigger.new) {
       if ( ( Trigger.oldMap.get(opp.ID).Project_Name__c != opp.Project_Name__c)){
                     optyIds.add(opp.id);
                     }
               }
               if(optyIds.size()>0){
             OpportunityHelper.updateQuoteProj(optyIds);
              }
        }
    /**************************************************************************************************************/
               
        /*** AFTER INSERT / AFTER UPDATE ***/
        if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
            /*** Skip the entire logic of Opprtunity Trigger if the update is via Quote Trigger.
             *** Whenever the Opportunities are updated via Quote trigger, then we process them separately.
             ***/
              map<ID, Decimal > mapWonAmount =new map<ID, Decimal >();
            system.debug('coming from quote trigger' + UtilityClass.updateFromQuoteTrigger);
            //if (!UtilityClass.updateFromQuoteTrigger) 
                for (Opportunity opp: Trigger.new) {
                    /*** Check if Opportunity Status is Closed/Won. If yes, then get the Project Id and
                     *** update Project Amount with amount from this "Primary Opportunity" and Project Status 
                     *** will be set to "In Progress - Order". Also all the other opportunities related to the
                     *** same project are set to "Closed/Lost" with "Reason Opportunity Lost" field updated
                     *** to value "Related Opportunity - Closed/Won"
                     ***/
                   // if (opp.StageName == UtilityClass.opportunityWonStatus && opp.createdDate > mydate && trigger.oldMap != null && trigger.oldMap.get(opp.Id).StageName != UtilityClass.opportunityWonStatus) 
                      if (opp.StageName == UtilityClass.opportunityWonStatus  && trigger.oldMap != null ) {
                        projIds.add(opp.Project_Name__c);
                        mapWonAmount.put(opp.Project_Name__c,opp.Amount);
                    }
    
                    /*** If the stage of the Opportunity has been set to "Qualification", then get the Project Id
                     *** and for all such projects, "Project Status" is auto-updated to "Project Specified" and 
                     *** "Project Amount" is updated with average of Amounts from all associated Opportunities.
                     */
                    if (opp.StageName != NULL && opp.stageName != 'Closed/Lost' && opp.stageName != 'Closed/Inactivity' && opp.stageName != 'On Hold' && opp.stageName != 'Closed/Won' && opp.stageName !='Bid Unsuccessful' && opp.stageName !='Cancelled'  && trigger.oldMap!=null && ((trigger.oldMap.get(opp.Id).StageName != opp.StageName) || (opp.stageName == 'Quote - Requested')) && opp.stageName!='Influencer Closed/Won' ) {
                        projIds2.add(opp.Project_Name__c);
                    }
                }
            
    
            /*** Skip the entire logic of Opprtunity Trigger if the update is via Quote Trigger.
             *** Whenever the Opportunities are updated via Quote trigger, then we process them separately.
             ***/
            /*** if(!UtilityClass.updateFromQuoteTrigger)***/
            /*** The collections have now been populated in the above sections as per the conditions and business
             *** requirements. Now we'll pass these collections to the OpportunityHelper class methods where
             *** the actual business logic is implemented.
             ***/
            //if (!UtilityClass.updateFromQuoteTrigger) 
                system.debug('check updateQuiteTrigger' + projids +projids2);
                if (projIds.size() > 0 && !utilityClass.updateFromInfluencer) {
                    //Call method from OpportunityHelper Utility class
                    OpportunityHelper.UpdateRelatedOpportunities(projIds,mapWonAmount);
                }
                if (projIds2.size() > 0 && utilityClass.doNotRunOnOrderOppUpdate ) {
                    //Call method from OpportunityHelper Utility class
                   OpportunityHelper.UpdateProjectStagesFromOppStages(projIds2);
                   utilityClass.doNotRunOnOrderOppUpdate = FALSE ; 
                }   
        }
    }
    
    if(trigger.isAfter && trigger.isInsert){
        OpportunityHelper.checkoppContactRole(trigger.newMap.keySet()) ;
        OpportunityHelper.createProjectBidderSplit(trigger.new);
       
    }
    
    
    /**************************************************************************************************************/
    /*** AFTER INSERT / AFTER UPDATE ***/
    if(trigger.isAfter && (trigger.isInsert||trigger.isUpdate))
    {
        list<opportunity> OppList = new list<Opportunity>();
        list<opportunity> oppList2 = new list<Opportunity>();
        for(opportunity opp:Trigger.new){
        if((trigger.isinsert) || (trigger.isUpdate && trigger.oldmap.get(opp.id).Discounts__c !=opp.Discounts__c)){
        OppList.add(opp);
        }
        
        if(((trigger.isinsert) || (trigger.isUpdate && trigger.oldmap.get(opp.id).StageName !=opp.StageName)) && opp.StageName =='Closed/Lost'){
        oppList2.add(opp);
        }
        }
           if(OppList.size()>0){
           OpportunityHelper.UpdateDiscountOnProject(OppList);
           } 
           if(oppList2.size()>0){
           OpportunityHelper.UpdateProjectStagetoClosedLost(OppList);
           }
           
    }
    /**************************************************************************************************************/
   
 
    
    /**************************************************************************************************************/
    /*** AFTER INSERT / AFTER UPDATE ***/
    
     if((trigger.isUpdate || trigger.isInsert) && trigger.isAfter)
    {
        List<Opportunity> lstNewOpp = Trigger.new;
        Map<Id,Opportunity> mapOldOpp = Trigger.oldMap;
       
        //for adding architect account on related project

        List<Opportunity> lstOpp = new List<opportunity> ();

        for(Opportunity opp : Trigger.new){
            system.debug('Inside trigger for') ; 
            if(opp.RecordTypeID == label.Influencer_Opportunity_RecordTypeId){
                system.debug('Inside trigger if') ;  
                lstOpp.add(opp) ; 
            }
        }

        //Function to add architect account on related project
        if((lstOpp.size() > 0 )&& (UtilityClass.firstRun == TRUE)){
            OpportunityHelper.UpdateProjectArchitect(lstOpp);
             
        }

        //Creates the Project Share records whenever the Opportunity is created or updated
         //Testing
        for (Opportunity opps: lstNewOpp) {
            //On Update
            if (trigger.isUpdate) {
                Opportunity oldOpp = mapOldOpp.get(opps.Id);
                //Only if the OwnerId is changed
                If((oldOpp.OwnerId) != opps.OwnerId && OpportunityHelper.runOppTeamSharingOnce) {
                    //OppIds.add(opp.Id);
                    //runOppTeamSharingOnce = false;
                    OpportunityHelper.createProjShareOnOppInsertOrUpdate(lstNewOpp , mapOldOpp);
                }
            } 
            }
            //On Insert
       // OpportunityHelper.createProjShareOnOppInsertOrUpdate(lstNewOpp , mapOldOpp);
        
        
        Set<Id> oppId = new Set<Id>();
        Set<Id> deluserId = new Set<Id>();
        List<Opportunity> oppOwnerChangeList = new list<Opportunity>();
        List<Opportunity> oppProjectChangeList = new list<Opportunity>();
        list<Opportunity> oppArchitech = new list<Opportunity>();
        
        if (trigger.isInsert){
         oppArchitech.addAll(trigger.new);
         if(oppArchitech.size() >0){
            OpportunityHelper.createProjSplitSpecifier(oppArchitech);
         }
        }
        
        if (trigger.isUpdate){
            
         //Update the Bidder Split to Purchaser 
         if(UtilityClass.updateProjectBidderSplit == TRUE ) {
             OpportunityHelper.updateProjectBidderSplit(trigger.new, trigger.oldMap);
                UtilityClass.updateProjectBidderSplit = FALSE ;
            }
         for (Opportunity opp : trigger.new ){
            if (opp.OwnerId != trigger.oldMap.get(opp.Id).OwnerId){
                oppId.add(opp.Id);
                deluserId.add(trigger.oldMap.get(opp.Id).OwnerId);
                oppOwnerChangeList.add(opp);
            }
            if(opp.AccountId != trigger.oldMap.get(opp.Id).AccountId){
                oppArchitech.add(opp);
            }
            if(opp.Project_Name__c != trigger.oldMap.get(opp.Id).Project_Name__c){
                oppProjectChangeList.add(opp);
            }
         }
         
         if (oppId.size() > 0 && deluserId.size() > 0){
            Project_Sharing.delete_Owner_Sharing(oppId, delUserId);
         }
         
         if(oppOwnerChangeList.size() >0){
           OpportunityHelper.createProjectBidderSplit(oppOwnerChangeList);
         }
         
         if(oppProjectChangeList.size() >0){
            OpportunityHelper.createProjectBidderSplit(oppProjectChangeList);
         }
         
         if(oppArchitech.size() >0){
            OpportunityHelper.createProjSplitSpecifier(oppArchitech);
         }
       }
    }
    
     /**************************************************************************************************************/
    }
}