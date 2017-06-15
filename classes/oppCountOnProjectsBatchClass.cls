global class oppCountOnProjectsBatchClass implements Database.Batchable < sObject >
 {
    
    global String query;
    
    
     //Start method of the batch class
     global Database.QueryLocator start(Database.BatchableContext BC) {
        String filters = 'a1sQ00000077b8sIAA';
        this.query = 'SELECT Id from Project__c Order By CreatedDate desc';
        
        return Database.getQueryLocator(query);
    }
    
    
    //Execute method of the batch class
    global void execute(Database.BatchableContext BC, List < Project__c > records) {
        
        Set<Id> projIdSet = new Set<Id>();
        map < ID, set < ID >> mapComResOpps = new map < ID, set < ID >> ();
        map < ID, set < ID >> mapInfluOpps = new map < ID, set < ID >> ();
        list < Project__c > listProjToUpdateCount = new list < Project__c > ();
        
        oppTeamHelper.runoppTeamUpdate = false;
        
        for (Project__c proj : records){
            projIdSet.add(proj.Id);
        }
        
        
        for(opportunity oppCount : [select id,recordTypeId,Project_Name__c from opportunity where Project_Name__c IN : projIdSet]){
            
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
            } else if(Label.Influencer_Opportunity_RecordTypeId.containsIgnoreCase(String.valueOf(oppCount.recordTypeId).substring(0,15) )){
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
        
        for(Project__c prjToUpdate : [Select id,Influencer_Count__c,Opportunity_Count__c from project__c where Id IN : projIdSet]){
            if(mapComResOpps.containsKey(prjToUpdate.Id)){
                prjToUpdate.Opportunity_Count__c = mapComResOpps.get(prjToUpdate.Id).size();
                
            }else{
                prjToUpdate.Opportunity_Count__c = null;
            }
            
            if(mapInfluOpps.containsKey(prjToUpdate.Id)){
                prjToUpdate.Influencer_Count__c = mapInfluOpps.get(prjToUpdate.Id).size();
            }else{
                prjToUpdate.Influencer_Count__c = null;
            }
            
            if(mapComResOpps.containsKey(prjToUpdate.Id) || mapInfluOpps.containsKey(prjToUpdate.Id)){
                listProjToUpdateCount.add(prjToUpdate);
            }
        }
        if(listProjToUpdateCount.size()>0){
            database.update(listProjToUpdateCount);
        }
        
        
    }
     
      //Finish method of the batch class
    global void finish(Database.BatchableContext BC) {

    }
    

}