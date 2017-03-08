global class Contact_Batch_Fullcircle implements Database.Batchable < sObject > {
  
   //Global Variable
    global String query;
    
   global Contact_Batch_Fullcircle() {
      
    }
    
     //Start method of the batch class
    global Database.QueryLocator start(Database.BatchableContext BC) {
    
                this.query = 'select id, owner.profile.name, FCRM__FCR_Status__c, CFCR_Status_Age__c from contact';
      
        return Database.getQueryLocator(query);
    }
    
    //Execute method of the batch class
    global void execute(Database.BatchableContext BC, List <Contact> records) {
      
      
        set<string> setProfile= new set<string>();
        list<SLA_Expiration_Profiles__c> SLAList =[select Current_Status__c, Active__c from SLA_Expiration_Profiles__c where Active__c= TRUE];
        for(SLA_Expiration_Profiles__c slList : SLAList)
        {
         setProfile.add(slList.current_Status__c);
        }
         
         
        list<SLAExpirationTimeFrames__c> SLAExpirationlist = new list<SLAExpirationTimeFrames__c>();
        SLAExpirationlist =[select Current_Status__c, New_Status__c, Status_Reason__c, Timeframe__c from SLAExpirationTimeFrames__c];
        list<Contact> Contactlist = new list<Contact>();
        for(Contact con: records)
        {
            if(setProfile.contains(con.owner.profile.name))
           {
                for(integer i=0; i<SLAExpirationlist.size(); i++)
                {
                    if(con.FCRM__FCR_Status__c==SLAExpirationlist[i].Current_Status__c && con.CFCR_Status_Age__c>=SLAExpirationlist[i].Timeframe__c)
                    {
                        con.FCRM__FCR_Status__c=SLAExpirationlist[i].New_Status__c;
                        con.Status_Reason__c=SLAExpirationlist[i].Status_Reason__c;
                        Contactlist.add(con);
                    }
                }
           }
        }
         update Contactlist;
        
        
        
      
            
    }
    
     //Finish method of the batch class
    global void finish(Database.BatchableContext BC) {

    }
    
    



}