/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : January-2017
    @ Description   : Batch Class to Create Influencer Opportunity if Architect account is filled and Influencer Count is zero on project
	@ Audit Trial   :
    @ Test Class    : 
    @ Last Modified Date : 30-Jan-2017
  
****************************************************************************/
global class batchNoInfluencerOnProject implements Database.Batchable < sObject > {
	String query;
	string InfluencerID = label.Influencer_Opportunity_RecordTypeId ; 

	  // Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
        //Query all projects where Architect account is filled
        
        Query = 'SELECT ID , Name ,  Architect_Account__c , Close_Date__c , Architect_Account__r.Name FROM Project__c WHERE Architect_Account__c != null AND Influencer_Count__c = 0 ' ; 
   		 return Database.getQueryLocator(query);
      }

      //Execute Method of Batch class
    global void execute(Database.BatchableContext BC, List < Project__c > pro) 
    {
        
        system.debug('The value of pro %%%%' +pro);
		
         List<opportunity> lstOppInsert = new List <opportunity> () ;
         
           for(Project__c p : pro ){

            Opportunity opp = new Opportunity () ; 
            
            opp.project_name__c = p.ID ; 
            opp.AccountID = p.Architect_Account__c ; 
            opp.Name = p.Name + '-' + p.Architect_Account__r.Name ;
            opp.StageName = 'Drawings - Requested' ; 
            opp.CloseDate = p.Close_Date__c ;
            opp.ForecastCategoryName = 'Pipeline';
            opp.recordTypeID = InfluencerID ; 
            lstOppInsert.add(opp) ; 


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