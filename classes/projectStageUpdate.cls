public class projectStageUpdate {
    public static boolean skipOppTrigger = false;
    public static void updateRelatedOpps(list < id > lstPrj) {
        integer counter = 0; 
        List < Opportunity > updateList = new List < Opportunity > ();
        List < Project__c > projList = [Select Id, Ordering_Account__c, Stage__c, Amount__c, (Select Id, recordTypeId, Amount, AccountId, StageName from Opportunities__r) from Project__c WHERE ID IN: lstPrj];
        
        
        for (Project__c prj: projList) {
            if (prj.stage__c == 'Closed Lost - Project Lost' || prj.stage__c == 'Closed Lost - Project Cancelled') {
                for (Opportunity opp: prj.Opportunities__r) {
                
                    if (opp.StageName != UtilityClass.opportunityWonStatus) {
                           System.debug('----Label value--'+Label.Influencer_Opportunity_RecordTypeId);
                           System.debug('######ReType--'+opp.recordTypeId); 
                   if (Label.Influencer_Opportunity_RecordTypeId.containsIgnoreCase(String.valueOf(opp.recordTypeId).substring(0,15))) {
                            System.debug('----Label value--'+Label.Influencer_Opportunity_RecordTypeId);
                            System.debug('######ReType--'+opp.recordTypeId);
                        opp.StageName = 'Influencer Closed/Lost';
                        opp.Reason_Opportunity_Lost__c ='Project Cancelled';
                        updateList.add(opp);
                        utilityClass.updateFromQuoteTrigger = true;
                    }
                    
                    else{
                        opp.StageName = UtilityClass.getStringValue('LeadClosedLostStatus');
                        opp.Reason_Opportunity_Lost__c = UtilityClass.getStringValue('LeadCloseLostReason');
                        updateList.add(opp);
                        }
                  }
                  else{counter = counter + 1;}
                  
                   
                }
            } else if (prj.stage__c == 'Closed - Inactivity') {
                for (Opportunity opp: prj.Opportunities__r) {
                
                    if (opp.StageName != UtilityClass.opportunityWonStatus) {

                        opp.StageName = 'Closed/Inactivity';

                        updateList.add(opp);
                    }
                    else{counter = counter + 1;}
                    
                    
                }
            } 
        }
        if (updateList.size() > 0 && counter == 0) {
            //Updating relevant Opportunities
            Database.saveresult[] sr = Database.update(updateList, False); 
            ErrorLogUtility.processErrorLogs(sr, updateList, 'projectStageUpdate', 'updateRelatedOpps', 'Opportunity', 'Update');
        }
     System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
    }
    
    /* This method is added for SF Support Ticket # 37. This method will perform a blank update on all Opps which are
     * linked to any Project/Account whose name is updated. This blank update then fires workflow rule on Opps which
     * processes and updates the Opp Name.
     */
    public static void updateOppNames(list < id > listId, String objName) {
        List <Opportunity> updateList = new List <Opportunity> ();
        if(objName=='Project'){
        updateList = [SELECT Id, Name FROM Opportunity WHERE Project_Name__c IN :listId];
         System.debug('63-Number of Queries used in this apex code so far: ' + Limits.getQueries());

        }
        else if(objName=='Account'){
            updateList = [SELECT Id, Name FROM Opportunity WHERE AccountId IN :listId];
             System.debug('66-Number of Queries used in this apex code so far: ' + Limits.getQueries());

        }
        if (updateList.size() > 0) {
            //Set the Boolean Skip Variable so that Opp trigger is not fired
            skipOppTrigger = true;
            //Updating relevant Opportunities
            Database.saveresult[] sr = Database.update(updateList, False); 
            ErrorLogUtility.processErrorLogs(sr, updateList, 'projectStageUpdate', 'updateOppNames', 'Opportunity', 'Update');
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
    }
    /*****************************************************
     Added by Satish lokinindi 
    Method Name: validateProjectStageonClosedWonOppBeforeCancel
    This Method is added to validate the projects before the stages are set to project cancelled and to throw error 
    if there are any Closed won Opportunities 
    ******************************************************/
    public static void validateProjectStageonClosedWonOppBeforeCancel (set<Project__c> projSet){
        set<ID> setId = new set<Id>();
        map<id, id> projOppMap= new map<id, id>();
        for(Project__c pr: projSet)
        {
            setId.add(pr.id);
        }
         //query over opportunity  to find any closed won opps on the same project    
        list<Opportunity>  oppList = [Select Id ,Project_Name__c, StageName from Opportunity  WHERE Project_Name__c IN: setId AND StageName ='Closed/Won'];
         //store in map 
         for(Opportunity opp: oppList)
         {
                projOppMap.put(opp.Project_Name__c, opp.id);
         }

         System.debug('86.Number of Queries used in this apex code so far: ' + Limits.getQueries());
         //lopp over incoming projects and find if that exists in the map to diplay an error 
         for(Project__c pr: projSet)
         {
            if(projOppMap.containsKey(pr.id))
            {
            //error message
                pr.adderror('There is an Closed Won Opportunity on the project');   
            }
         }
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries()); 
    }
}