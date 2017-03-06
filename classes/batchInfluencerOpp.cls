/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : January-2017
    @ Description   : Batch Class to Create Influencer Opportunity if Architect account is filled on Project
    @ Audit Trial   : 
    @ Test Class    : 
    @ Last Modified Date : 30-Jan-2017
  
****************************************************************************/
global class batchInfluencerOpp implements Database.Batchable < sObject > {
	String query;
	string InfluencerID = label.Influencer_Opportunity_RecordTypeId ; 
    
    // Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
        //Query all projects where Architect account is filled
        
       
        Query = 'SELECT ID, Name , Architect_Account__c , Architect_Account__r.Name , Close_Date__c FROM Project__c WHERE Architect_Account__c != null AND Influencer_Count__c != 0 ' ; 
   		 return Database.getQueryLocator(query);
      }
    
     //Execute Method of Batch class
    global void execute(Database.BatchableContext BC, List < Project__c > pro) 
    {
        system.debug('The value of pro is %%%%' +pro);
        List<opportunity> lstOppInsert = new List <opportunity> () ;
         map<ID , ID > mapProjectArchitect = new map <ID,ID> ();

          //Create a map to hold project ID and it's Architect account ID
        for(Project__c p : pro){

            mapProjectArchitect.put(p.ID , p.Architect_Account__c) ; 
        }


        map <ID , set <ID > > mapProjectIdOppID = new map <ID , set <ID> > () ;
 
        
            
            for(opportunity opp: [select id,accountid,project_name__c , OwnerId from opportunity where project_name__c in:mapProjectArchitect.keyset() AND recordtypeId=:InfluencerID]){
               
          
           if (mapProjectIdOppID != null && !mapProjectIdOppID.containsKey(opp.project_name__c)) {
               system.debug('I am here with mapProjectIdOppID' +mapProjectIdOppID);
               Set < Id > setAccId = new Set < Id > ();
               if(opp.AccountID != null)
               setAccId.add(opp.AccountId);
               mapProjectIdOppID.put(opp.project_name__c, setAccId);
           } 
            else if (mapProjectIdOppID.containsKey(opp.project_name__c)) {
               system.debug('The value of Account on Opportunity' + opp.AccountID );
               Set < Id > setAccId = new Set < Id > ();
               setAccId = mapProjectIdOppID.get(opp.project_name__c);
                if(opp.AccountID != null)
               setAccId.add(opp.AccountId);
               mapProjectIdOppID.put(opp.project_name__c, setAccId);
           }
                
        
            }
                
                   system.debug('Value of mapProjectIdOppID' +mapProjectIdOppID);         
       
       for (Project__c p : pro) {
            if(mapProjectIdOppID.containsKey(p.id) && mapProjectArchitect.containsKey(p.id) && ! mapProjectIdOppID.get(p.ID).contains(mapProjectArchitect.get(p.ID))) {
                  system.debug('I am here Inside IF');
                System.debug('proidoppid'+mapProjectIdOppID.containsKey(p.id));
                System.debug('projarchi'+mapProjectArchitect.containsKey(p.id));
          Opportunity opp = new Opportunity () ; 
            opp.project_name__c = p.ID ; 
            opp.AccountID = p.Architect_Account__c ; 
            opp.Name = p.Name + '-' + p.Architect_Account__r.Name  ;
            opp.StageName = 'Drawings - Requested' ; 
            opp.CloseDate = p.Close_Date__c ;
            opp.ForecastCategoryName = 'Pipeline';
            opp.recordTypeID = InfluencerID ; 
            lstOppInsert.add(opp) ; 
            }
       }


       try{
                if(lstOppInsert.size() > 0 ){
                    
                    system.debug('Inside Try lstOppInsert' +lstOppInsert) ; 
                     Database.saveresult[] sr = Database.insert(lstOppInsert, False); 

                  }
        }

    catch(exception e){

        system.debug('Exception is:' +e.getMessage());
    }


    }
    
      global void finish(Database.BatchableContext BC) {

    }
    
}