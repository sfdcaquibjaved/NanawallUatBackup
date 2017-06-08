/**********************************************************************
Apex Class: OpportunityHelper
Description: This class is used to write all business logic related to 
             Opportuntiy Trigger
Created Date: 27thMarch,2014            
***********************************************************************/
public class OpportunityHelper {

    /*************************************************
    Method Name: UpdateRelatedOpportunities
    Description: This method is used to update all the related opportunities
                of Project to Closed/Lost if any one opportunity is Closed/Won
    Input Parameter: Set of Ids         
    *************************************************/
    public static boolean runOppTeamSharingOnce = true;
    
    public static void UpdateRelatedOpportunities(Set < Id > projIds,Map<id,Decimal> mapWonAmount) {
        //Declaration of Variables
        List < Opportunity > updateList = new List < Opportunity > ();
        map < Id, Project__c > mapupdateProject = new map < Id, Project__c > ();

        //Query over Project with Related Opportunities
        List < Project__c > projList = [Select Id, Ordering_Account__c, Stage__c, Amount__c, (Select Id, recordtypeID, Amount, AccountId, Bal_received_date_from_quotes__c, Order_Final_Date_from_quote__c, StageName from Opportunities__r) from Project__c WHERE ID IN: projIds];
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        //Loop over Project
        for (Project__c prj: projList) {
            //Loop over related Opportunities
            Integer counter = 0;
            Decimal sum = 0;
            for (Opportunity opp: prj.Opportunities__r) {
            if (opp.StageName == UtilityClass.opportunityWonStatus) {
           
            system.debug('oppfinaldate'+opp.Order_Final_Date_from_quote__c);
                    system.debug('oppbalreceived'+opp.Bal_received_date_from_quotes__c);
                
                    /*if (opp.Order_Final_Date_from_quote__c && !opp.Bal_received_date_from_quotes__c) {
                    system.debug('oppfinaldate1'+opp.Order_Final_Date_from_quote__c);
                    system.debug('oppbalreceived1'+opp.Bal_received_date_from_quotes__c);
                        prj.stage__c = 'Closed Won - Order In Process';
                    } else if (opp.Bal_received_date_from_quotes__c && opp.Order_Final_Date_from_quote__c) {
                    system.debug('oppfinaldate2'+opp.Order_Final_Date_from_quote__c);
                    system.debug('oppbalreceived2'+opp.Bal_received_date_from_quotes__c);
                        prj.stage__c = 'Closed Complete - Ordered - Paid';
                    } else {
                        //Setting Ordering Account on Project to Account of Opportunity Closed/Won
                        prj.Ordering_Account__c = opp.AccountId;
                        system.debug('oppfinaldate3'+opp.Order_Final_Date_from_quote__c);
                       system.debug('oppbalreceived3'+opp.Bal_received_date_from_quotes__c);
                        
                        //Set the Project Status to Project In Progress - Order for all Closed/Won opps
                        prj.Stage__c = 'Closed Won - Order Signed';
                        
                       
                       
                    }*/
                     if (opp.Amount != null) {
                            prj.Amount__c = opp.Amount;
                        }
                    mapupdateProject.put(prj.Id, prj);
            }

               else if (opp.StageName != UtilityClass.opportunityWonStatus) {
                    system.debug('STAGECHECK'+opp.recordTypeId);
                    //Setting stage name and reason for other Opportunities related to Proj
                    if (Label.Influencer_Opportunity_RecordTypeId.containsIgnoreCase(String.valueOf(opp.recordTypeId).substring(0,15) )){
                        opp.StageName = 'Influencer Closed/won';
                        opp.Amount =mapWonAmount.get(prj.id);
                        system.debug('STAGECHECK'+opp.StageName);
                        utilityClass.updateFromInfluencer = true;
                        updateList.add(opp);
                    } else {
                        opp.StageName = UtilityClass.getStringValue('RelatedOppClosed-Lost');
                        opp.Reason_Opportunity_Lost__c = UtilityClass.getStringValue('LeadCloseLostReason');
                        //opp.StageName = 'Closed/Won';
                        //opp.stagename= UtilityClass.getStringvalue('opportunityWonStatus');
                        system.debug('the stage is' + opp.stageName + UtilityClass.getStringvalue('opportunityWonStatus'));
                    updateList.add(opp);
                    }
                    //updateList.add(opp);
                } 

            }

        }

        if (updateList.size() > 0) {
            //Updating relevant Opportunities
            Database.saveresult[] sr = Database.update(updateList, False); 
            ErrorLogUtility.processErrorLogs(sr, updateList, 'OpportunityHelper', 'UpdateRelatedOpportunities', 'Opportunity', 'Update');
        }

        if (mapupdateProject.values().size() > 0) {
            //Updating Project
            Database.saveresult[] sr = Database.update(mapupdateProject.values(), False); 
            ErrorLogUtility.processErrorLogs(sr, mapupdateProject.values(), 'OpportunityHelper', 'UpdateRelatedOpportunities', 'Project__c', 'Update');
        }

    }

    /*************************************************
    Method Name: UpdateQuoteProj
    Description: This method is used to update project field on the quote record when on the opportunity for the same quote
    has been updated with a different project
    Input Parameter: Set of Ids         
    *************************************************/
    public static void updateQuoteProj(set < ID > opptyIds) {
        List < quote__c > updateQuotes = new List < Quote__c > ();
        for (Opportunity opp: [Select Id, project_name__c, (Select Id, Project__c from Quotes1__r) from Opportunity where Id IN: opptyIds]) {
            
            for (Quote__c qt: opp.Quotes1__r) {
                if (qt.Project__c != opp.project_name__c) {
                    qt.project__c = opp.project_name__c;
                    updateQuotes.add(qt);
                }
            }
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        if (updateQuotes.size() > 0) {
            Database.saveresult[] sr = Database.update(updateQuotes, False); 
            ErrorLogUtility.processErrorLogs(sr, updateQuotes, 'OpportunityHelper', 'updateQuoteProj', 'Quote__c', 'Update');
        }
    }

    /*************************************************
    Method Name: checkAccOnOpp
    Description: This method is used to check if the 2 opportunities under a same project does not have 
    same account on them .will run on 'Before insert & before update'
    Input Parameter: Trigger.new opp values       
    *************************************************/
    public static void checkAccOnOpp(list < Opportunity > oppAcc) {
        set < ID > oppIds = new set < ID > ();
        set < ID > projIds = new set < ID > ();
        map < ID, set < ID >> mapPrjAcc = new map < ID, set < ID >> ();
        Datetime donotCheckDate = datetime.newInstance(2015, 7, 1, 0, 30, 12);
        for (opportunity opp: oppAcc) {
            //system.debug('###'+ opp.project_name__r.createdDate);
            if (opp.project_name__c != null)
                projIds.add(opp.project_name__c);
            if (opp.Id != null)
                oppIds.add(opp.Id);
        }
        for (opportunity opp: [select id,createdDate, AccountId, project_name__c from opportunity where project_name__c IN: projIds AND Id NOT IN: oppIds AND project_name__r.createdDate>:donotCheckDate]) {
            if (mapPrjAcc != null && !mapPrjAcc.containsKey(opp.project_Name__c)) {
                Set < Id > setAccId = new Set < Id > ();
                setAccId.add(opp.AccountId);
                mapPrjAcc.put(opp.Project_Name__c, setAccId);
            } else if (mapPrjAcc.containsKey(opp.Project_Name__c)) {
                Set < Id > setAccId = new Set < Id > ();
                setAccId = mapPrjAcc.get(opp.Project_Name__c);
                setAccId.add(opp.AccountId);
                mapPrjAcc.put(opp.Project_Name__c, setAccId);
            }
            System.debug('--Count should be 3--');
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        System.debug('----' + mapPrjAcc.size() + '---values--' + mapPrjAcc.values());
        for (opportunity opp: oppAcc) {
        //system.debug('##################'+opp.project_name__r.createdDate+'&&&&&&&&&&&&'+donotCheckDate);
            if (opp.accountid != null && opp.project_name__c != null && mapPrjAcc.containsKey(opp.project_name__c)) {
                if (mapPrjAcc.get(opp.project_name__c).contains(opp.AccountId)) {
                    system.debug('---AccountId--' + opp.AccountId);
                 opp.adderror('There is already an opportunity with the same account name');
                }
            }
        }
    }

    /*************************************************
    Method Name: UpdateCorpAccField
    Description: This method is used to update the corporate acc field on project
    Input Parameter: Set of Ids         
    *************************************************/
    public static void updateCorpAccField(set < Id > setPrjIds) {
        map < ID, project__c > mapUpdatePrj = new map < ID, project__c > (); 
        List < Project__c > projList = [Select Id, corporate_account__c from Project__c WHERE ID IN: setPrjIds];
       
        for (project__c prj: projlist) {
            if(!prj.corporate_account__c){
                prj.corporate_account__c= True;
                utilityClass.runUpdateCorpAcc=False;
                mapUpdatePrj.put(prj.id, prj);
              }   
            }
        if (mapUpdatePrj.values().size() > 0) {
            //Updating Project
            Database.saveresult[] sr = Database.update(mapUpdatePrj.values(), False); 
            ErrorLogUtility.processErrorLogs(sr, mapUpdatePrj.values(), 'OpportunityHelper', 'updateCorpAccField', 'Project__c', 'Update');
        }
        
        
    }
     /*************************************************
    Method Name: updateProjectPrelimDrawingCheckbox
    Description: This method is used to update the corporate acc field on project
    Input Parameter: Set of Ids         
    *************************************************/
    public static void updateProjectPrelimDrawingCheckbox(set < Id > setPrjIdss) {
        map < ID, project__c > mapUpdateProj = new map < ID, project__c > (); 
        List < Project__c > prjList = [Select Id, Preliminary_Drawings__c from Project__c WHERE ID IN: setPrjIdss];
        System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        for (project__c prj: prjlist) {
            if(!prj.Preliminary_Drawings__c){
                prj.Preliminary_Drawings__c = True;
                utilityClass.runUpdatePrelims =False;
                mapUpdateProj.put(prj.id, prj);
              }   
            }
        if (mapUpdateProj.values().size() > 0) {
            //Updating Project
            Database.saveresult[] sr = Database.update(mapUpdateProj.values(), False); 
            ErrorLogUtility.processErrorLogs(sr, mapUpdateProj.values(), 'OpportunityHelper', 'updateProjectPrelimDrawingCheckbox', 'Project__c', 'Update');
        }
        
        
    }
/*************************************************
    Method Name: UpdateResidentialVerticalField
    Description: This method is used to update the Residential Vertical field on project
    Input Parameter: Set of Ids         
    *************************************************/
    public static void updateResidentialVerticalField(set < Id > setPrjResId) {
        
        map < ID, project__c > mapUpdateResident = new map < ID, project__c > ();
        List < Project__c > projList2 = [Select Id, Residential_Vertical__c from Project__c WHERE ID IN: setPrjResId];
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        for (project__c prj2: projList2) {
            if(!prj2.Residential_Vertical__c){
                prj2.Residential_Vertical__c= True;
                utilityClass.runUpdateResident=False;
                mapUpdateResident.put(prj2.id, prj2);
              }   
            }
        if (mapUpdateResident.values().size() > 0) {
            //Updating Project
            Database.saveresult[] sr = Database.update(mapUpdateResident.values(), False); 
            ErrorLogUtility.processErrorLogs(sr, mapUpdateResident.values(), 'OpportunityHelper', 'updateResidentialVerticalField', 'Project__c', 'Update');
        }
    }


    /*************************************************
    Method Name: UpdateProjectAmount
    Description: This method is used to update Amount field on Project based
                 on Amount values in related Opportunities
    Input Parameter: Set of Ids         
    *************************************************/
    public static void UpdateProjectAmount(Set < Id > projectIds) {

            List < Project__c > updateProjList = new List < Project__c > ();
            //Query over Project with Related Opportunities
            List < Project__c > projList = [Select Id, Amount__c, Stage__c, (Select Id, Amount, AccountId, StageName from Opportunities__r) from Project__c WHERE ID IN: projectIds];
             System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

            //Loop over Project
            for (Project__c prj: projList) {
                Integer counter = 0;
                Decimal sum = 0;
                //Loop over related Opportunities to get the average of Amount
                for (Opportunity opp: prj.Opportunities__r) {
                    if (opp.StageName == 'Quote - Requested') {
                        if (opp.Amount != null) {
                            counter++;
                            sum += opp.Amount;
                        }
                    }
                }
                //Set the Project Amount to the average amount of all Opps
                if (counter > 0 && sum > 0) {
                    prj.Amount__c = sum / counter;
                    updateProjList.add(prj);
                }
            }
                
                //Set the Project Status to Project Specified for all Qualified opps


                if (updateProjList.size() > 0) {
                    //Updating Project
                   Database.saveresult[] sr = Database.update(updateProjList, False); 
                   ErrorLogUtility.processErrorLogs(sr, updateProjList, 'OpportunityHelper', 'UpdateProjectAmount', 'Project__c', 'Update');
                }

            

        }
        /*******************************************************************************************
    public static void updateResolutionDate(set < ID > stProj) {
            list < project__c > lstProjdateUpdate = new list < project__c > ();
            Date minDt, primeDt;
            for (project__c oppToUpdateDate: [SELECT id, ownerID, close_date__c, (SELECT id, ownerID, Primary_Opportunity__c, closeDate, StageName from Opportunities__r) from project__c where ID in : stProj]) {
                for (Opportunity op: oppToUpdateDate.opportunities__r) {
                    if (op.primary_opportunity__c) {
                        primeDt = op.CloseDate;
                    } else if (op.closeDate != null) {
                        if (minDt == null) {
                            minDt = op.closeDate;
                        } else if (op.closeDate < minDt) {
                            minDt = op.closeDate;
                        }
                    }

                    if (primeDt != null) {
                        oppToUpdateDate.Close_date__c = primeDt;
                    } else {
                        oppToUpdateDate.Close_date__c = minDt;
                    }
                }
                lstProjdateUpdate.add(oppToUpdateDate);
            }
            if (lstProjdateUpdate.size() > 0) {
                //Updating Project
                Database.update(lstProjdateUpdate, false);
            }
        }
        /********************************************************************************************/
    public static void updateOppTeam(set<Id> oppIdSet) {
            List < OpportunityTeamMember > updateOppTeamList = new List < OpportunityTeamMember > ();
            
            for (Opportunity opp : [Select Id,OwnerId, Project_Name__r.OwnerId from Opportunity where Id =: oppIdSet]){
                if (opp.Project_Name__r.OwnerId != null && opp.ownerID != opp.Project_Name__r.OwnerId) {
                 OpportunityTeamMember oppTeam = new OpportunityTeamMember();
                 oppTeam.OpportunityId = opp.Id;
                 oppTeam.UserId = opp.Project_Name__r.OwnerId;
                 updateOppTeamList.add(oppTeam);
                }
            }
           
            if (updateOppTeamList.size() > 0) {
                try {
                  Database.saveresult[] sr = Database.insert(updateOppTeamList, False);
                  ErrorLogUtility.processErrorLogs(sr, updateOppTeamList, 'OpportunityHelper', 'updateOppTeamList', 'OpportunityTeamMember', 'Insert');
                } catch (exception ex) {
                    System.Debug('>>> Error in updateOppTeam method. Error is :: ' + ex.getMessage());
                }
            }
        }
        /********************************************************************************************/

    public static void checkBudgetQuote(Set< ID > AccId,list < opportunity > lstOppIdsToUpdate) {
        
        Map < Id, String > MpAccIDType = new Map < Id, String > ();
       
       //map id with Account Type 
        if (AccId.size() >0){
            for (Account acc: [Select Type from Account Where Id IN: Accid]) {
                MpAccIDType.put(acc.Id, acc.Type);
            }
        }
       //loop over Opportunity and Assign the Record type based on Account type or Budget Quote
        for (Opportunity opp: lstOppIdsToUpdate) {
            If(MpAccIDType.get(opp.AccountId) == 'Architecture Firm' || MpAccIDType.get(opp.AccountId) == 'Cost Consulting Firm' || MpAccIDType.get(opp.AccountId) == 'Interior Designer'|| opp.Budget_Quote__c ==True) {
                opp.recordTypeID = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Influencer Opportunity').getRecordTypeId();
                opp.Budget_Quote__c =True;
            }
        }
         
     }


    

    /*******************************************************************************************/
    public static void UpdateProjectStagesFromOppStages(Set < Id > projectIds) {
    System.debug('Entering the method');
        map < String, Integer > mapStageInt = new map < String, Integer > ();
        Integer i = 1;
        Schema.DescribeFieldResult f = Schema.sObjectType.Opportunity.fields.StageName;
        for (Schema.Picklistentry entry: f.getPicklistValues()) {
            mapStageInt.put(entry.getValue(), i);
            System.debug('---map of Opp Stages--' + entry.getValue() + '--label--' + entry.getLabel());
            i++;
        }
       // System.debug('---map of Opp Stages--' + mapStageInt);
        List < Project__c > updateProjList = new List < Project__c > ();
        map < ID, Opportunity > projectStageMap = new map < ID, Opportunity > ();
        //Query over Project with Related Opportunities
        List < Project__c > projList = [Select Id, Amount__c, Stage__c, Award_date__c, Bid_date__c, (Select Id, Amount, AccountId, Bal_received_date_from_quotes__c, Order_Final_Date_from_quote__c, StageName from Opportunities__r) from Project__c WHERE ID IN: projectIds];
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        //Loop over Project
        for (Project__c prj: projList) {
            Integer max = 0;
            Opportunity oppRec = new Opportunity();
            for (Opportunity opp: prj.Opportunities__r) {
                if (opp.stageName != NULL && opp.stageName!= UtilityClass.getStringValue('LeadClosedLostStatus')&& opp.stageName!= UtilityClass.getStringValue('RelatedOppClosed-Lost' ) &&  opp.stageName!= 'Closed/Won' && opp.stageName!= 'Order - Negotiation/Review' && opp.stageName!= 'Order - Provided' && opp.stageName!= 'Order - Requested' && opp.stageName!= 'On Hold' && opp.stageName!= 'Cancelled' && opp.stageName!= 'Closed/Inactivity' && opp.stageName!= 'Influencer Closed/Won') {
                    System.debug('*****Stage--Opp***' + opp.StageName);
                    if (mapStageInt.containsKey(opp.StageName) && mapStageInt.get(opp.StageName) > max) {
                       System.debug('-----' + mapStageInt.get(opp.StageName));
                        max = mapStageInt.get(opp.StageName);
                        System.debug('--Max Stage--' + max);
                        //oppRec = opp;
                        projectStageMap.put(prj.ID, opp);
                    }
                }
            }
            //projectStageMap.put(prj.ID,oppRec);
        }
        map < String, Integer > mapStageProj = new map < String, Integer > ();
        Integer k = 1;
        Schema.DescribeFieldResult G = Schema.sObjectType.Project__c.fields.Stage__c;
        for (Schema.Picklistentry entry: G.getPicklistValues()) {
            mapStageProj.put(entry.getValue(), k);
            System.debug('---map of Project Stages--' + entry.getValue() + '--label--' + entry.getLabel());
            k++;
        }
        for (Project__c proj: projList) {
        System.debug('Entering the for loop'+ proj.id);
        System.debug(projectStageMap);
        System.debug(mapStageProj);
        //system.debug(mapStageProj.get(opp_proj_stages__c.getinstance(projectStageMap.get(proj.ID).stageName).proj_stages__c));
        if(projectStageMap != null && projectStageMap.containskey(proj.ID) && mapStageProj != null && mapStageProj.containsKey(proj.stage__c) && mapStageProj.get(opp_proj_stages__c.getinstance(projectStageMap.get(proj.ID).stageName).proj_stages__c) > 0 && mapStageProj.get(proj.stage__c) < mapStageProj.get(opp_proj_stages__c.getinstance(projectStageMap.get(proj.ID).stageName).proj_stages__c)){
            system.debug('project stage is' + proj.id + proj.stage__c);
            system.debug('#################'+mapStageProj.get(proj.stage__c));
            system.debug('#################'+mapStageProj.get(opp_proj_stages__c.getinstance(projectStageMap.get(proj.ID).stageName).proj_stages__c));
            //if () {
                system.debug('the stage of opp is  ' + projectStageMap.get(proj.ID).StageName);
                if ((projectStageMap.get(proj.ID).StageName.equalsignorecase('Quote - Provided') || projectStageMap.get(proj.ID).StageName.equalsIgnoreCase('Quote - Negotiation/Review'))) {
                    string str = opp_proj_stages__c.getinstance(projectStageMap.get(proj.ID).StageName).proj_stages__c;
                    string[] arr = str.split(',');
                    system.debug('********' + arr[0] + '*********' + arr[1]);
                    system.debug('***' + proj.stage__c + '****' + proj.award_date__c + '*****' + system.today());
                    if (proj.bid_date__c >= system.today()) {
                        proj.stage__c = arr[0];
                        system.debug('***' + proj.stage__c + '****' + proj.award_date__c + '*****' + system.today());
                    } else if (proj.Award_date__c < system.today() && proj.bid_date__c < system.today()) {
                        proj.stage__c = arr[1];
                    }
                } else {
                
                    proj.stage__c = opp_proj_stages__c.getinstance(projectStageMap.get(proj.ID).stageName).proj_stages__c;
                    system.debug('the stage is' + proj.stage__c);
                    system.debug('&&&&&&&&&&&&' + projectStageMap.get(proj.ID).stageName);

                }
                updateProjList.add(proj);
            //}
              System.debug('You are here');
           }

           else if(proj.stage__c == 'Cancelled' || proj.stage__c == 'Closed - Inactivity' || proj.stage__c == 'Project On Hold'){
             System.debug('You are inside else:'+proj.stage__c);
              proj.stage__c = opp_proj_stages__c.getinstance(projectStageMap.get(proj.ID).stageName).proj_stages__c;
              updateProjList.add(proj);
           }
        }



        if (updateProjList.size() > 0) {
            //Updating Project
            Database.saveresult[] sr = Database.update(updateProjList, False); 
            ErrorLogUtility.processErrorLogs(sr, updateProjList, 'OpportunityHelper', 'UpdateProjectStagesFromOppStages', 'Project__c', 'Update');
        }

    }



    /******************************************************************************************
    Method Name: checkRelatedQuotes
    Description: This method is used to check if Quotes are present on an Opportunity
                and Amount is changed from front end, then display error message.
    Input Parameter: Set of Ids         
    *******************************************************************************************/
   /* public static void checkRelatedQuotes(Set < Id > oppIds, Map < Id, Opportunity > newRecMap) {
        //Reset the static boolean flag which helps in distinguishing if it
        //is a manual update OR an update by Quote trigger
        UtilityClass.updateFromQuoteTrigger = false;

        for (Opportunity opp: [Select Id, Amount,StageName,(Select Id, SubTotal__c, Primary_Quote__c from Quotes1__r) from Opportunity where Id IN: oppIds]) {
            //Adding the below line to be able to use .addError method
            Opportunity tempOpp = newRecMap.get(opp.Id);
              if (opp.Quotes1__r != null && opp.Quotes1__r.size() > 0 ) {
                tempOpp.addError('You Cannot update Opportunity Amount manually when there are Quote(s) on Opportunity.');
            }
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());


    }*/

    /******************************************************************************************
    Method Name: checkPrimaryQuotes
    Description: This method is used to check if a Primary Quote is present on an Opportunity
                while it is bein set as Closed/Won
    Input Parameter: Set of Ids         
    *******************************************************************************************/
    public static void checkPrimaryQuotes(Set < Id > oppIds, Map < Id, Opportunity > newRecMap) {
        //Reset the static boolean flag which helps in distinguishing if it
        //is a manual update OR an update by Quote trigger
        UtilityClass.updateFromQuoteTrigger = false;
        Integer counter = 0;
        for (Opportunity opp: [Select Id, recordtypeID, StageName, (Select Id, SubTotal__c,Order_Number__c, Primary_Quote__c from Quotes1__r) from Opportunity where Id IN: oppIds]) {
            //Adding the below line to be able to use .addError method

            Opportunity tempOpp = newRecMap.get(opp.Id);

            for (Quote__c qt: opp.Quotes1__r) {
                if (qt.Order_Number__c > 0) {
                    counter++;
                }
            }


            if (counter == 0 && opp.recordTypeID != Label.Influencer_Opportunity_RecordTypeId) {
                tempOpp.addError('Opportunity cannot be set as Closed/Won as there is no Order associated to this Opportunity.');
            } else if (tempOpp.StageName == UtilityClass.opportunityWonStatus && counter > 0) {
                tempOpp.Primary_Opportunity__c = true;
            }
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());


    }

    /******************************************************************************************
        Method Name: checkoppContactRole
        Description: This method is used to check if an Opportunity is created from the contact 
                     page. If it gets created from contact page , standard opportunity Contact Role
                     record will be created. The method makes sure that standard Opportunity Contact
                     Role is in sync with custom Opportunity Contact Role.
        Input Parameter: list of Opportunity         
    *******************************************************************************************/

    public static void checkoppContactRole(Set < Id > oppIdSet) {

        list < Opportunity > opplst = [Select Id, (Select ContactId, IsPrimary, OpportunityId, Role from OpportunityContactRoles) from Opportunity where Id = : oppIdSet];
        list < nrOpportunityContactRole__c > custOppConRolelstToInsert = new list < nrOpportunityContactRole__c > ();

        for (Opportunity opp: opplst) {
            for (OpportunityContactRole oppConRole: opp.OpportunityContactRoles) {
                nrOpportunityContactRole__c custOppConRole = new nrOpportunityContactRole__c();
                custOppConRole.Contact__c = oppConRole.ContactId;
                custOppConRole.Opportunity__c = oppConRole.OpportunityId;
                custOppConRole.Primary__c = oppConRole.IsPrimary;
                custOppConRolelstToInsert.add(custOppConRole);
            }
        }

        if (custOppConRolelstToInsert.size() > 0) {
            try {
                 Database.saveresult[] sr = Database.insert(custOppConRolelstToInsert, False);
                 ErrorLogUtility.processErrorLogs(sr, custOppConRolelstToInsert, 'OpportunityHelper', 'checkoppContactRole', 'OpportunityContactRole', 'Insert');
            } catch (Exception e) {
                System.debug('Error on Insert' + e.getMessage());
            }
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());


    }


    /*************************************************
    Method Name: createProjShareOnOppInsertOrUpdate
    Description: This method creates the Project Share record whenever a User is added to a OpportunityTeam via either by Creating a new Opportunity
                 or by updating the Owner of the Opportunity
    Input Parameter: Trigger.new and Trigger.oldMap         
    *************************************************/
    public static void createProjShareOnOppInsertOrUpdate(List < Opportunity > lstNewOpp, Map < Id, Opportunity > mapOldOpp) {
        
        runOppTeamSharingOnce = false;
        List < Id > OppIds = new List < Id > ();
        List < OpportunityTeamMember > changedRecsIdList = new List < OpportunityTeamMember > ();

        //Populate the User id's into a list
        for (Opportunity opp: lstNewOpp) {
            //On Update
            if (trigger.isUpdate) {
                Opportunity oldOpp = mapOldOpp.get(opp.Id);
                //Only if the OwnerId is changed
                If((oldOpp.OwnerId) != opp.OwnerId) {
                    OppIds.add(opp.Id);
                }
            }
            //On Insert
            else {
                OppIds.add(opp.Id);
            }
        }
        system.debug('Checking for the opps'+OppIds);
        //Query the OpportunityTeamMembers to create a corresponding Share record
        changedRecsIdList = [select id, OpportunityId, UserId from OpportunityTeamMember where OpportunityId = : OppIds];
        //Null Check
        if (changedRecsIdList.size() > 0)
            Project_Sharing.share_record(changedRecsIdList);
    }
    
      public static void updateOpportunityOwner (set<Id> accountSetId , list<Opportunity> opplst){
        
        map<Id,Id> ownerMap = new map<Id, Id>();
        list<Account> accountlst = [Select Id,OwnerId from Account where Id =: accountSetId];
        for (Account acc : accountlst){
        ownerMap.put(acc.Id , acc.OwnerId) ;
        
            for (Opportunity opp : opplst){
                if (ownerMap.containsKey(opp.AccountId)){
                  if (opp.OwnerId != ownerMap.get(opp.AccountId)){
                    opp.OwnerId = ownerMap.get(opp.AccountId) ;
                }
               } 
            }
        }
     }
     
    /***************************************************************************************************************************************************
    Method Name: createProjectBidderSplit
    Description: This method creates the Project Split Bidder/Purchase record whenever an opportunity is created.
    Input Parameter: list of opportunity   
    ***************************************************************************************************************************************************/
     
     public static void createProjectBidderSplit(list<Opportunity> opplist){
        
        set<Id> projId = new set<Id>();
        map<String,Project_Split__c> mapProjSplit = new map<String,Project_Split__c>();
        list<Project_Split__c> projSplitToInsert = new list<Project_Split__c>();
        list<Project_Split__c> projSplitToUpdate = new list<Project_Split__c>();
        
        for (Opportunity opp : opplist){
            projId.add(opp.Project_Name__c);
        }
        
        list<Project_Split__c> splitToQuery = [Select Id,Project__c,Project_Rep__c,Account__c,Role__c from Project_Split__c where Project__c =: projId ];
        
        for (Project_Split__c pSplit : splitToQuery){
            mapProjSplit.put(pSplit.Project__c + '#' + pSplit.Project_Rep__c + '#' + pSplit.Account__c + '#' + pSplit.Role__c,pSplit);
        }
        
        for (Opportunity opp : opplist){
          if(opp.StageName != UtilityClass.opportunityWonStatus){
          
           if (!mapProjSplit.containsKey(opp.Project_Name__c + '#' + opp.OwnerId + '#' + opp.AccountId + '#' +'Bidder')){
            
            Project_Split__c pSplit = new Project_Split__c();
            pSplit.Project__c = opp.Project_Name__c ;
            pSplit.Project_Rep__c = opp.OwnerId ;
            pSplit.Account__c = opp.AccountId ;
            pSplit.Split__c = 0 ;
            pSplit.Role__c  = 'Bidder';
            projSplitToInsert.add(pSplit);
            }
            }
            else{
            if (!mapProjSplit.containsKey(opp.Project_Name__c + '#' + opp.OwnerId + '#' + opp.AccountId + '#' +'Purchaser')){
            
            Project_Split__c pSplit = new Project_Split__c();
            pSplit.Project__c = opp.Project_Name__c ;
            pSplit.Project_Rep__c = opp.OwnerId ;
            pSplit.Account__c = opp.AccountId ;
            pSplit.Split__c = 0 ;
            pSplit.Role__c  = 'Purchaser';
            projSplitToInsert.add(pSplit);
            }
            else{
        if(mapProjSplit.containsKey(opp.Project_Name__c + '#' + opp.OwnerId)){
            Project_Split__c pSplitWon = mapProjSplit.get(opp.Project_Name__c + '#' + opp.OwnerId);
            pSplitWon.Role__c  = 'Purchaser';
            projSplitToUpdate.add(pSplitWon);
            }
            }
          }
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        if(projSplitToInsert.size() >0){
        Database.saveresult[] sr = Database.insert(projSplitToInsert, False);
        ErrorLogUtility.processErrorLogs(sr, projSplitToInsert, 'OpportunityHelper', 'createProjectBidderSplit', 'Project_Split__c', 'Insert');
        }
        
        if(projSplitToUpdate.size() >0){
         Database.saveresult[] sr = Database.update(projSplitToUpdate, False);
         ErrorLogUtility.processErrorLogs(sr, projSplitToUpdate, 'OpportunityHelper', 'createProjectBidderSplit', 'Project_Split__c', 'Update');
        }
     }
     
    /***************************************************************************************************************************************************
     Method Name: updateProjectBidderSplit
     Description: This method update the Project Split Bidder record to Purchaser whenever  an opportunity is closed won
     Input Parameter: list of opportunity   
    ***************************************************************************************************************************************************/
     
     public static void updateProjectBidderSplit(List<Opportunity> opplist, map<Id,Opportunity> oldMapTrigger){
        
        //local variable
        Set<Id> projectIdSet = new Set<Id>();
        Set<Id> repIdSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        
        for (Opportunity opp : opplist){
            if (opp.StageName == UtilityClass.opportunityWonStatus && opp.StageName != oldMapTrigger.get(opp.Id).StageName){
            projectIdSet.add(opp.Project_Name__c);
            repIdSet.add(opp.ownerId);
            accountIdSet.add(opp.AccountId);
            }
        }
        
        if (projectIdSet.size() > 0 && repIdSet.size() > 0 && accountIdSet.size() >0){
        
        list<Project_Split__c> pSplitToUpdate = [Select Id,Role__c from Project_Split__c where Project__c =: projectIdSet and Project_Rep__c =: repIdSet and Account__c =: accountIdSet and Role__c = 'Bidder'];
        
        for (Project_Split__c pSplit : pSplitToUpdate){
            pSplit.Role__c = 'Purchaser';
            
        }
        
        if (pSplitToUpdate.size() >0){
         Database.saveresult[] sr = Database.update(pSplitToUpdate, False);
         ErrorLogUtility.processErrorLogs(sr, pSplitToUpdate, 'OpportunityHelper', 'updateProjectBidderSplit', 'Project_Split__c', 'Update');
         }
       }
     }
     
       /****************************************************************************************************************************************
      Method Name: createProjSplitSpecifier
      Description: The method adds the Project Split record whenever an Opportunity is created/updated with an architech account.
      Input Parameter: List of projects       
    *****************************************************************************************************************************************/
    
    public static void createProjSplitSpecifier(list<Opportunity> opplst){
        
        list<Project_Split__c> splitToInsert = new list<Project_Split__c>();
        set<Id> oppId = new set<Id>();
        set<Id> projId = new set<Id>();
        map<String,Project_Split__c> mapProjSplit = new map<String,Project_Split__c>();
        
        for (Opportunity opp : opplst){
            oppId.add(opp.Id);
            projId.add(opp.Project_Name__c);
        }
        
        list<Opportunity> querylist = [Select Id,AccountId,Project_Name__c, Account.OwnerId, Account.Type from Opportunity where Id =: oppId and (Account.Type = 'Architecture Firm' OR Account.Type ='Interior Designer')];
        
        list<Project_Split__c> splitToQuery = [Select Id,Project__c,Account__c,Project_Rep__c,Role__c from Project_Split__c where Project__c =: projId ];
        
        for (Project_Split__c pSplit : splitToQuery){
            mapProjSplit.put(pSplit.Project__c + '#' + pSplit.Project_Rep__c + '#' + pSplit.Account__c + '#' + pSplit.Role__c,pSplit);
        }
        system.debug('#########'+querylist);
        for (Opportunity opp :  querylist){
            
             if (!mapProjSplit.containsKey(opp.Project_Name__c + '#' + opp.Account.OwnerId + '#' + opp.AccountId + '#' + 'Specifier')){
             
             Project_Split__c projSplit = new Project_Split__c();
             projSplit.Project__c = opp.Project_Name__c ;
             projSplit.Project_Rep__c = opp.Account.OwnerId ;
             projSplit.Account__c = opp.AccountId ;
             projSplit.Split__c = 0 ;
             projSplit.Role__c = 'Specifier';
             splitToInsert.add(projSplit);
          }  
        }
        
        if(splitToInsert.size() > 0){
            Database.saveresult[] sr = Database.insert(splitToInsert, False); 
            ErrorLogUtility.processErrorLogs(sr, splitToInsert, 'ProjectHelper', 'createProjSplitSpecifier', 'Project_Split__c', 'Insert');
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        
    }
    
       /****************************************************************************************************************************************
      Method Name: createProjSplitSpecifier
      Description: The method adds the Project Split record whenever an Opportunity is created/updated with an architech account.
      Input Parameter: List of projects       
    *****************************************************************************************************************************************/
    
    public static void CheckOppCorpAccFromNewOpportunityProject(list<Opportunity> opplist ,map<id,Boolean> proMap2 ){
        
        //map<id,Boolean> proMap =new map<id,Boolean>();
 
        if(proMap2.size()>0){
         for(Opportunity opp:opplist){
            if(proMap2.get(opp.Project_Name__c)==true){
            opp.Chain_Account__c=true;
            }
         }
        }
        
    }
    
/*
    
  public static void checkdate(list<Quote__c> qtlist){
  
  set<id> quoteid= new set<id>();
  list<Opportunity> oppsToUpdate = new list<opportunity>();
  
  for(Quote__c q: qtlist){
  quoteid.add(q.Opportunity__c);
  }
  
  list<opportunity> opps=[select id,StageName,Bal_received_date_from_quotes__c,Order_Final_Date_from_quote__c from opportunity where Id IN: quoteid];

   for(opportunity op:opps){
  
  if(op.Stagename== UtilityClass.opportunityWonStatus)
  {
      op.Bal_received_date_from_quotes__c=true;
     // op.Order_Final_Date_from_quote__c=true;
      oppsToUpdate.add(op);
      system.debug('oppfinaldatenew'+op.Order_Final_Date_from_quote__c);
      system.debug('oppbalreceivednew'+op.Bal_received_date_from_quotes__c);
            }
        }
        if(oppsToUpdate.size()>0){
        update oppsToUpdate ;
            }
    }*/
    
       /****************************************************************************************************************************************
      Method Name: checkdate2
      Description: The method 
      Input Parameter: List of Quote Record       
    *****************************************************************************************************************************************/
   /* public static void checkdate2(list<Quote__c> qtlist){
  
  set<id> quoteid= new set<id>();
  list<Opportunity> oppsToUpdate = new list<opportunity>();
  
  for(Quote__c q: qtlist){
  quoteid.add(q.Opportunity__c);
  }
  
  list<opportunity> opps=[select id,StageName,Bal_received_date_from_quotes__c,Order_Final_Date_from_quote__c from opportunity where Id IN: quoteid];

   for(opportunity op:opps){
  
  if(op.Stagename== UtilityClass.opportunityWonStatus)
  {
     // op.Bal_received_date_from_quotes__c=true;
      op.Order_Final_Date_from_quote__c=true;
      oppsToUpdate.add(op);
      system.debug('oppfinaldatenew'+op.Order_Final_Date_from_quote__c);
      system.debug('oppbalreceivednew'+op.Bal_received_date_from_quotes__c);
            }
        }
        if(oppsToUpdate.size()>0){
        update oppsToUpdate ;
            }
    }*/
    
    
       /****************************************************************************************************************************************
      Method Name: opportunityCountFC
      Description: The method is used to count and update the number of opportunities on 
                    project record.
      Input Parameter: Set of project Ids     
    *****************************************************************************************************************************************/
    public static void opportunityCountFC(set <Id> projListCount){
        
        map < ID, set < ID >> mapComResOpps = new map < ID, set < ID >> ();
        map < ID, set < ID >> mapInfluOpps = new map < ID, set < ID >> ();
        list < Project__c > listProjToUpdateCount = new list < Project__c > ();
        
        for(opportunity oppCount : [select id,recordTypeId,Project_Name__c from opportunity where Project_Name__c IN : projListCount]){
                            

            if (!Label.Influencer_Opportunity_RecordTypeId.containsIgnoreCase(String.valueOf(oppCount.recordTypeId).substring(0,15) )){
                if (mapComResOpps != null && !mapComResOpps.containsKey(oppCount.project_Name__c)) {
                Set < Id > setOppId = new Set < Id > ();
                setOppId.add(oppCount.Id);
                mapComResOpps.put(oppCount.Project_Name__c, setOppId);
                } else if (mapComResOpps.containsKey(oppCount.Project_Name__c)) {
                Set < Id > setOppId = new Set < Id > ();
                setOppId = mapComResOpps.get(oppCount.Project_Name__c);
                setOppId.add(oppCount.Id);
                mapComResOpps.put(oppCount.Project_Name__c, setOppId);
                }
            } else if (Label.Influencer_Opportunity_RecordTypeId.containsIgnoreCase(String.valueOf(oppCount.recordTypeId).substring(0,15) )) {
                if (mapInfluOpps != null && !mapInfluOpps.containsKey(oppCount.project_Name__c)) {
                Set < Id > setOppId = new Set < Id > ();
                setOppId.add(oppCount.Id);
                mapInfluOpps.put(oppCount.Project_Name__c, setOppId);
                } else if (mapInfluOpps.containsKey(oppCount.Project_Name__c)) {
                Set < Id > setOppId = new Set < Id > ();
                setOppId = mapInfluOpps.get(oppCount.Project_Name__c);
                setOppId.add(oppCount.Id);
                mapInfluOpps.put(oppCount.Project_Name__c, setOppId);
                }
            }
        }
        
        for(Project__c prjToUpdate : [Select id,Influencer_Count__c,Opportunity_Count__c from project__c where Id IN : projListCount]){
            if(mapComResOpps.containsKey(prjToUpdate.Id)){
                prjToUpdate.Opportunity_Count__c = mapComResOpps.get(prjToUpdate.Id).size();
                
            }
            
            if(mapInfluOpps.containsKey(prjToUpdate.Id)){
                prjToUpdate.Influencer_Count__c = mapInfluOpps.get(prjToUpdate.Id).size();
            }
            
            if(!mapComResOpps.containsKey(prjToUpdate.Id)){
                prjToUpdate.Opportunity_Count__c = 0;
            }
            if(!mapInfluOpps.containsKey(prjToUpdate.Id)){
                prjToUpdate.Influencer_Count__c = 0;
            }
            
                listProjToUpdateCount.add(prjToUpdate);
            
        }
        if(listProjToUpdateCount.size()>0){
            database.update(listProjToUpdateCount);
        }
        
        
        
    }
    
    /******************************************************************************************************************
    Method Name: UpdateERDDate 
    Description: The method is used to fill the ERD date in project by taking inputs from Opportunities
    Input Parameter: Set of ProjectId's       
    *******************************************************************************************************************/
    public static void UpdateERDDate(set<Id> projId){
        if(UtilityClass.doNotRunTwiceOfERDCode==true){
        UtilityClass.doNotRunTwiceOfERDCode=false;
        list<project__c> plist = new list<Project__c>();
        map<ID, DATE> oppMap= new map<ID, DATE>();
        map<ID, String> oppMap2 = new map<ID, String>();
        map<ID, DATE> oppMap3 = new map<ID, DATE>();

        

        for(Opportunity opp: [select id, CloseDate, StageName, Project_Name__c FROM Opportunity where Project_Name__c =: projId  ORDER BY CloseDate LIMIT 1  ])
        {
            if(opp.CloseDate!=null)
            {
                oppMap.put(opp.project_name__c,opp.CloseDate);
            }       
            
        }
        for(Opportunity opp2: [select id, CloseDate, StageName, Project_Name__c FROM Opportunity where StageName =: 'Closed/Won' AND Project_Name__c =: projId ])
        {
            if(opp2.StageName!=null)
            {
                oppMap2.put(opp2.project_name__c,opp2.StageName);

            }
            if(opp2.CloseDate!=null)
            {
                oppMap3.put(opp2.project_name__c,opp2.CloseDate);
            }
                        
            
        }
        System.debug('oppmap'+oppmap);
        list<Project__c> proList = [select id, Close_Date__c FROM Project__c where id IN: projId];
        for(Project__c p: proList)
        {
            if(oppMap2.get(p.id)=='Closed/Won')
            {
                p.Close_Date__c=oppMap3.get(p.id);
                plist.add(p);
            }
            else
            {
                p.Close_Date__c=oppMap.get(p.id);
                plist.add(p);
            }
            
        }
        update plist;
        }
        }
        
         /******************************************************************************************************************
    Method Name: UpdateERDDateOfOpp 
    Description: The method is used to fill the ERD date in Opportunities by taking inputs from Quotes
    Input Parameter: Set of OpportunityId's       
    *******************************************************************************************************************/
    public static void UpdateERDDateOfOpp(set<Id> QuoteIds)
    {
        list<Opportunity> oppLists= new list<Opportunity>(); 
         list<Opportunity> oppList2= new list<Opportunity>();    
        map<ID, DATE> QuoteMap= new map<ID, DATE>();
        map<ID, Decimal> QuoteMap2= new map<ID, Decimal>();
        id OppId;
        for(Quote__c q: [select id, Createddate, Opportunity__c, Order_Number__c from Quote__c where id=: QuoteIds])
        {
            if(q.CreatedDate!=null)
            {
                QuoteMap.put(q.Opportunity__c,q.Createddate.date());
            }
            
            if(q.Order_Number__c != null && q.order_number__c >0){
            QuoteMap2.put(q.Opportunity__c,q.Order_Number__c);
            }
            OppId=q.Opportunity__c;
            
        }
        
        for(Opportunity oppty: [select id, CloseDate, Quote_Count__c from Opportunity where id=:OppId])
        {
            if(oppty.Quote_Count__c==0)
            {
                oppty.CloseDate=System.today()+180;
                oppList2.add(oppty);
                System.debug('new trigeerrrr'+oppList2);
            }
            
        }
        update oppList2;
        
        for(Opportunity opp: [select id, CloseDate, ManualChangeOfERD__c, Quote_Count__c, Dummy_ManualchangeERD__c, AutomaticUpdateERD__c, RecordTypeId, Createddate from Opportunity where id=: OppId])
        {
            
            System.debug('Test-----'+opp.Quote_Count__c);
            System.debug('Test Maual chnage-----'+opp.ManualChangeOfERD__c);
            System.debug('Closedate------'+opp.CloseDate);
                    /*Datetime a = QuoteMap.get(opp.id);
                    System.debug('date value-----'+a);
                    System.debug('Opp.RecordTypeId@@@@@@@@@@@'+Opp.RecordTypeId);
                    Date b2 =  date.newinstance(a.year(), a.month(), a.day());
                    System.debug('dateeeeeeeeeeee'+b2);
                    System.debug('closedate opppp'+opp.CloseDate);*/
          if(opp.ManualChangeOfERD__c==true && opp.CloseDate>System.today())
            {
                        
            }
              else
              {
                  System.debug('countttttttt'+opp.Quote_Count__c);
                  System.debug('orderr no'+QuoteMap2.get(opp.id));
                if(opp.Quote_Count__c>0 && (QuoteMap2.get(opp.id)==0 || QuoteMap2.get(opp.id)==null))
                {
                    Datetime a3 = QuoteMap.get(opp.id);
                    Date b3 =  date.newinstance(a3.year(), a3.month(), a3.day());
                    Integer days=b3.daysbetween(opp.CloseDate);
                    System.debug('Days-@@@@@@'+days);
                     
                    
                        
                        System.debug('Opp.RecordTypeId@@@@@@@@@@@'+Opp.RecordTypeId);
                        
                        if(opp.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial Opportunity').getRecordTypeId())
                        {
                            ERDCommercial__c ErdC = ERDCommercial__c.getOrgDefaults();
                            decimal d = ErdC.No_of_days__c;
                            System.debug('Decimal--'+d);
                            System.debug('Closeddate of opp-------'+opp.CloseDate);
                            Integer integerValue = Integer.valueOf(d);
                            if(days>=integerValue)
                            {
                            }
                           else
                            {
                            Opp.CloseDate=b3+integerValue;
                                Opp.ManualChangeOfERD__c=false;
                                Opp.Dummy_ManualchangeERD__c=true;
                            oppLists.add(opp);
                            }
                         }
                        
                        else if(opp.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId())
                        {
                            ERDResidential__c ErdR = ERDResidential__c.getOrgDefaults();
                            decimal d2 = ErdR.No_of_days__c;
                            Integer integerValue2 = Integer.valueOf(d2);
                             if(days>=integerValue2)
                             {
                             }
                             else
                             {
                                Opp.CloseDate=b3+integerValue2;
                                 Opp.ManualChangeOfERD__c=false;
                                 Opp.Dummy_ManualchangeERD__c=true;
                                oppLists.add(opp);
                             }
                        }   
                
                }
                
              
                
                if(opp.Quote_Count__c >1 &&  (QuoteMap2.get(opp.id)>0 && QuoteMap2.get(opp.id)!=null))
                {
                    System.debug('Test2-----'+opp.Quote_Count__c);
                    Datetime a2 = Quotemap.get(opp.id);
                    System.debug('date value2-----'+a2);
                    Date b = a2.date();
                    System.debug('date value3-----'+b);
                    Integer days2 =b.daysBetween(opp.CloseDate);
                    
                        
                        if(opp.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial Opportunity').getRecordTypeId())
                        {
                            ERDCommercial_OrderNo__c ErdC_Order = ERDCommercial_OrderNo__c.getOrgDefaults();
                            decimal d3 = ErdC_Order.No_of_days__c;
                            Integer integerValue3 = Integer.valueOf(d3);
                            if(days2>=integerValue3)
                            {
                            }
                            else
                            {
                                Opp.CloseDate=Opp.CloseDate+integerValue3;
                                Opp.ManualChangeOfERD__c=false;
                                Opp.AutomaticUpdateERD__c=true;
                                oppLists.add(opp);
                            }
                         }
                        
                        else if(opp.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId())
                        {
                            ERDResidential_OrderNo__c ErdR_Order = ERDResidential_OrderNo__c.getOrgDefaults();
                            decimal d4 = ErdR_Order.No_of_days__c;
                            Integer integerValue4 = Integer.valueOf(d4);
                            if(days2>=integerValue4)
                            {
                            }
                            else
                            {
                            Opp.CloseDate=Opp.CloseDate+integerValue4;
                                Opp.ManualChangeOfERD__c=false;
                                Opp.AutomaticUpdateERD__c=true;
                            oppLists.add(opp);
                            }
                        }
                }
                  
                  
            }               
        }   
                            update oppLists;
    }
    
    /*************************************************
    Method Name: UpdateDiscountOnOpportunities
    Description: This method is used to update the opportunities with quote discount
    Input Parameter: Set of Ids         
    *************************************************/
    
    public static void UpdateDiscountOnOpportunities(list <quote__c> quotelist) {
    
    //Local Variables
    set<id> Opportunityid = new set<id>();
    decimal avgquotedis_Primary;
    decimal avgquotedis;
    boolean primarycheck;
    boolean recentcheck;
    integer countprimary;
    list<Opportunity> OppUpdatelist= new list<Opportunity>();
    
    //Populating discount on Opportunity
        for(quote__c qt: quotelist)
        {
            Opportunityid.add(qt.Opportunity__c);
        }
         
         list<Quote__c> QuoteFullList= [select id, opportunity__c, Primary_Quote__c, Average_Quote_Discount__c, discount__c from Quote__c where opportunity__c IN: Opportunityid ORDER BY Createddate DESC]; 
         list<Opportunity> OpportunityList = [select id, discounts__c from Opportunity where id IN: Opportunityid];
         
         for(Opportunity Opp: OpportunityList)
         {
             primarycheck=false;
             recentcheck=false;
             avgquotedis_Primary=0;
             countprimary=0;
             for(Quote__c quote: QuoteFullList)
             {
                 if(quote.opportunity__c==Opp.id)
                 {
                     if(quote.Primary_Quote__c==TRUE)
                     {
                     system.debug('%%%%%%%%%%%%%%'+avgquotedis_Primary+'###########'+quote.Average_Quote_Discount__c);
                     if(quote.Average_Quote_Discount__c==null)
                         avgquotedis_Primary=avgquotedis_Primary;
                     else{
                         avgquotedis_Primary=avgquotedis_Primary+quote.Average_Quote_Discount__c;
                         primarycheck=true;
                         countprimary=countprimary+1;
                       }  
                     }
                     else if(recentcheck==false)
                     {
                        if(quote.Average_Quote_Discount__c!=null)
                         avgquotedis=quote.Average_Quote_Discount__c;  
                        
                        recentcheck=true;
                     }
                    
                 }
                
             }
              if(primarycheck==TRUE)
                 {
                     Opp.discounts__c=(avgquotedis_Primary/countprimary);
                     OppUpdatelist.add(Opp);
                 }
                 else
                 {
                     Opp.discounts__c=avgquotedis;
                     OppUpdatelist.add(Opp);
                 }    
         }
         
         if(OppUpdatelist.size()>0)
         {
             update OppUpdatelist;
         }
       
      
  }
  
  /*************************************************
    Method Name: UpdateDiscountOnQuote
    Description: This method is used to update the Quotes with quote detail average discount
    Input Parameter: Set of Ids         
    *************************************************/
    
    public static void UpdateDiscountOnQuote(set<id> quoteid) {
    
        
        list<quote__c> QuoteUpdatetlist = new list<quote__c>();
        list<quote__c> Quotelist = [select id, Average_Quote_Discount__c from quote__c where id IN: quoteid];
        list<Quote_Detail__c> Quotedetaillist= [select id, Price__c, Quote__c, Discount__c from Quote_Detail__c where Quote__c IN: quoteid];
        for(quote__c q: Quotelist)
        {
            decimal discountsum=0;
            decimal pricetotal=0;
            decimal total=0;
            decimal averagequotediscount=0;
          for(Quote_Detail__c qd: Quotedetaillist)
          {
            if(qd.Quote__c==q.id)
            {
                discountsum= discountsum+qd.Price__c;
                pricetotal = (100*qd.Price__c)/(100-qd.Discount__c);
                total=total+pricetotal;
            }           
          } 
          averagequotediscount = ((1-(discountsum/total))*100);
          q.Average_Quote_Discount__c=averagequotediscount ;
          QuoteUpdatetlist.add(q);
        }
        update QuoteUpdatetlist;
    }
    
   /*************************************************
    Added by satish Lokinindi
    Method Name: UpdateCEROCheck
    Description: This method is used to update the Opportunity CERO Check based on Quote deatails
    Input Parameter: Set of Ids of Quote        
    *************************************************/   
    public static void UpdateCEROCheck(set<ID> quoteIdSet)
    {
        //Local Variables
        //set<Id> opportunityIdSet =  new set<Id>();
        list<Opportunity> opportunityUpdateList = new list<Opportunity>();
        
        for(Quote__c q: [select id,Project__c, Opportunity__r.Id,Opportunity__r.CERO__c from Quote__c where ID IN : quoteIdSet])
        {
            opportunity opp = q.Opportunity__r;
            opp.CERO__c = TRUE;
            opportunityUpdateList.add(opp);
            //opportunityIdSet.add(q.Opportunity__c);
        }
        
       /* for(Opportunity opp: [select id, CERO__c from Opportunity where ID IN: opportunityIdSet])
        {
            opp.CERO__c = TRUE;
            opportunityUpdateList.add(opp);
        }*/
        
        if(opportunityUpdateList.size()>0)
        {
            Database.saveresult[] sr = Database.update(opportunityUpdateList, False);
            ErrorLogUtility.processErrorLogs(sr, opportunityUpdateList, 'Opportunity Helper', 'UpdateCEROCheck', 'Opportunity', 'Update');
        }
    }
    /***************************************************
    Method Name: UpdateProjectStagetoClosedLost
    Description: This method is used to update the project Stage to Closed lost when Opp is set to closed/Lost
    Input Parameter: opportunity list 
    
    ***************************************************/
    public static void UpdateProjectStagetoClosedLost(list<Opportunity> opplist){
        set<id> projIds = new set<id>();
        for(opportunity opp:opplist){
            projIds.add(opp.Project_Name__c);
        }
        list<Project__c> projList = [select id,stage__c ,(select id from Opportunities__r) from Project__c where id IN :projIds ];
        list<Project__c> updateProList = new list<Project__c>();
            for(Project__c pro:projList){
                if(pro.Opportunities__r.size()==1){
                    pro.stage__c = 'Closed Lost - Project Lost';
                    pro.Reason_Project_lost__c ='None';
                    updateProList.add(pro);
                }
            }
        if(updateProList.size()>0){
            
            Database.saveresult[] sr = Database.update(updateProList, False);
            ErrorLogUtility.processErrorLogs(sr, updateProList, 'Opportunity Helper', 'UpdateProjectStagetoClosedLost', 'Project__c', 'Update');
        }   
        
    }

    
    /*************************************************
    Method Name: UpdateProjectDiscount
    Description: This method is used to update the project discount based on opportunity Average discount
    Input Parameter: Set of Ids    
    *************************************************/   
    public static void UpdateDiscountOnProject(List < opportunity > oppRec) {
    //try{
    List < Project__c > updateProjList = new List < Project__c > ();
    set < id > projectIDs = new set < id > ();
       for (opportunity opp: oppRec) {
        projectIDs.add(opp.Project_Name__c);
    }
     //Query over Project with Related Opportunities
    List < Project__c > projList = [Select Id, Average_Discount__c, Amount__c, Stage__c, (Select Id, Discounts__c, Amount, AccountId, StageName from Opportunities__r) from Project__c WHERE ID IN: projectIDs];
    system.debug('@@@@@@@@@@@@@@'+projList);
    //Loop over Project
    for (Project__c prj: projList) {
        Integer counter = 0;
        Decimal sum = 0;
        Integer counter1 = 0;
        Decimal sum1 = 0;
        //Loop over related Opportunities to get the average of Amount
        for (Opportunity opp: prj.Opportunities__r) {
            if (opp.StageName == 'Closed/Won') {
                if (opp.Discounts__c != null) {
                    counter++;
                    sum += opp.Discounts__c;
                    system.debug('suuuuuuuuuuuuuuum'+sum);
                }

            }

            if (opp.StageName != 'Closed/Won') {
                if (opp.Discounts__c != null) {
                    counter1++;
                    sum1 += opp.Discounts__c;
                    system.debug('summmmmmmmmm1'+sum1);
                }

            }
        }
        //Set the Project Discount to the average discount of all Opps
        if (counter > 0 && sum > 0) {
            prj.Average_Discount__c = sum;
            system.debug('#########'+prj.Average_Discount__c);
            updateProjList.add(prj);
        }
        //Set the Project Discount to the average discount of all Opps
        if (counter1 > 0 && sum1 > 0) {
            prj.Average_Discount__c = sum1 / counter1;
            system.debug('$$$$$$$$$$$'+prj.Average_Discount__c);
            updateProjList.add(prj);
        }
    }
    system.debug('updatelisttt'+updateProjList);
    //Set the Project Status to Project Specified for all Qualified opps
    if (updateProjList.size() > 0) {
        //Updating Project
        update updateProjList;
       // Database.saveresult[] sr = Database.update(updateProjList, False);
    }
    //}catch(exception e){}
    }

/*************************************************
    Method Name: UpdateProjectArchitect
    Description: This method is used to update the project Architect account based on opportunity Account if it is of type Influencer
    Input Parameter: List of opportunities    
    *************************************************/  
public static void UpdateProjectArchitect (List < opportunity > oppRec) {

    system.debug('I am here') ; 
    List < Project__c > updateProjList = new List < Project__c > ();
    map<ID , ID> mapProjectAccount = new map <ID , ID > () ;

       for (opportunity opp: oppRec) {
                mapProjectAccount.put(opp.Project_Name__c , opp.AccountID);
                
    }
    system.debug('Value of mapProjectAccount' + mapProjectAccount) ; 
    // Query related projects

    for(project__c pro: [SELECT ID, Architect_Account__c FROM Project__c WHERE ID IN: mapProjectAccount.keyset() AND Architect_Account__c = null]) {

        pro.Architect_Account__c =  mapProjectAccount.get(Pro.ID);
        updateProjList.add(pro) ; 
    }   
    
   

     try{
        // Updating Project
         system.debug('Inside try' + updateProjList ) ; 
         if(updateProjList.size() > 0){
        UtilityClass.firstRun = FALSE ;
         Database.saveresult[] sr = Database.update(updateProjList, False);
     }
     }
     catch(exception e){

     }

}



    
}