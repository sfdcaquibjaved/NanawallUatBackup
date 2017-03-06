global class Lead_Batch_Fullcircle implements Database.Batchable < sObject > {
  
   //Global Variable
    global String query;
    
   global Lead_Batch_Fullcircle() {
      
    }
    
     //Start method of the batch class
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
                
        this.query = 'select id, owner.profile.name, Status, CFCR_Status_Age__c from lead where Is_Converting__c=FALSE';
      
        return Database.getQueryLocator(query);
    }
    
    //Execute method of the batch class
    global void execute(Database.BatchableContext BC, List <Lead> records) {
      
      
        set<string> setProfile= new set<string>();
        list<SLA_Expiration_Profiles__c> SLAList =[select Current_Status__c, Active__c from SLA_Expiration_Profiles__c where Active__c= TRUE];
        //SLAList =[select Current_Status__c, Active__c from SLA_Expiration_Profiles__c where Active__c= TRUE];
         for(SLA_Expiration_Profiles__c slList : SLAList){
         setProfile.add(slList.current_Status__c);
         }
         
        list<SLAExpirationTimeFrames__c> SLAExpirationlist = new list<SLAExpirationTimeFrames__c>();
        SLAExpirationlist =[select Current_Status__c, New_Status__c, Status_Reason__c, Timeframe__c from SLAExpirationTimeFrames__c];
        list<lead> leadlist = new list<lead>();
        
        for(lead l: records)
        {
           if(setProfile.contains(l.owner.profile.name))
           {
                for(integer i=0; i<SLAExpirationlist.size(); i++)
                {    
                    if(l.Status==SLAExpirationlist[i].Current_Status__c && l.CFCR_Status_Age__c>=SLAExpirationlist[i].Timeframe__c)
                    {
                        l.status=SLAExpirationlist[i].New_Status__c;
                        
                        l.Status_Reason__c=SLAExpirationlist[i].Status_Reason__c;
                        
                        leadlist.add(l);
                    }
                }
            }
        }
        
         if(leadlist.size()>0){
         database.update(leadlist);
         }
        
        
        
      
            
    }
    
     //Finish method of the batch class
    global void finish(Database.BatchableContext BC) {

    }
    
   


}