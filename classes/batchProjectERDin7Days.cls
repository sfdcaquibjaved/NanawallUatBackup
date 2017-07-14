/************************************************************
  * Name             : batchProjectERDin7Days 
  * Description      : Batch class for checking the checkbox of Projects whose ERD in next 7 days 
  * Created Date     : 12th July 2017                  
  * Input Parameters : NA
  * Return           : NA
  ************************************************************/  

global class batchProjectERDin7Days Implements Database.Batchable <sObject> {
    
    //variable to be used in SOQL
    public Date today = system.today().addDays(6);
    
    
    //Query to get the list of project whose ERD is in next 6 Days and Mail Sent check box is FALSE 
    
            public String SOQL = 'SELECT Id, Mail_Sent__c FROM Project__c WHERE ((DAY_IN_MONTH(Close_Date__c) = ' + 
                      today.day() +  ' AND CALENDAR_MONTH(Close_Date__c) = ' + today.month() + ') AND CALENDAR_YEAR(Close_Date__c)=' + today.year() 
                            + ')AND Mail_Sent__c != TRUE'  ;
    
    // Start Method of Batch class 
    
    global Database.queryLocator start(Database.BatchableContext bc){
        
         return Database.getQueryLocator(SOQL);
        
    }
    
    // Execute Method of Batch class
    global void execute(Database.BatchableContext bc, List<Project__c> listProject) {
        
        List<Project__c> listProjectUpdate = new List<Project__c>();
        
        for(Project__c p : listProject){
            
                 P.Mail_Sent__c = TRUE ; 
                 listProjectUpdate.add(p);         
        }
        
        try{
            update listProjectUpdate ;
        }
        catch(exception e){
            system.debug('Exception is:' +e.getMessage());
        }
    }
    
    // Finish Method of Batch class
    global void finish(Database.BatchableContext bc) {
        
    }
    
}