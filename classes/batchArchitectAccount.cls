/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : January-2017
    @ Description   : Batch Class to add Architect account on Projects with Influencer Opportunity
    @ Audit Trial   : 
    @ Test Class    : 
    @ Last Modified Date : 28-Jan-2017
  
****************************************************************************/
global class batchArchitectAccount implements Database.Batchable < sObject > {
	String query;
	string InfluencerID = label.Influencer_Opportunity_RecordTypeId ; 
    
    // Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
    
        Query = 'SELECT ID, AccountID , RecordTypeID , Project_Name__c , Project_Name__r.Architect_Account__c FROM Opportunity WHERE RecordTypeID =: InfluencerID AND Project_Name__r.Architect_Account__c = null';
        system.debug('Value of Query' + Query);
        return Database.getQueryLocator(query);
        
    }
    //Execute Method of Batch class
    global void execute(Database.BatchableContext BC, List < Opportunity > opp) 
    {
		        system.debug('Value of opp %%%%%' +opp);
        		
        		List < Project__c > updateProjList = new List < Project__c > ();
    			map<ID , ID> mapProjectAccount = new map <ID , ID > () ;
        
        		for (opportunity o: opp) {
                    if(o.AccountId!=null)
                		mapProjectAccount.put(o.Project_Name__c , o.AccountID);
                
    			}
				
        		system.debug('Value of mapProjectAccount' + mapProjectAccount) ; 
        		
        		for(project__c pro: [SELECT ID, Architect_Account__c FROM Project__c WHERE ID IN: mapProjectAccount.keyset() AND Architect_Account__c = null]) {

                    pro.Architect_Account__c =  mapProjectAccount.get(Pro.ID);
                    updateProjList.add(pro) ; 
                }
        
        		try{
                    // Updating Project
                     system.debug('Inside try' + updateProjList ) ; 
                     if(updateProjList.size() > 0){
                     Database.saveresult[] sr = Database.update(updateProjList, False);
                		 }
    			 }
        
             catch(exception e){
        
             }
                            
    }
    
    global void finish(Database.BatchableContext BC) {

    }
    
    
    
    
}