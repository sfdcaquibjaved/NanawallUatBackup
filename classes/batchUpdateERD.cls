global class batchUpdateERD implements Database.Batchable < sObject >  {
String query;
// Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
        String filters ='a1sA000000392vMIAQ';
        List<String> projstages = new list<String>{'Closed Won - Order In Process','Closed Won - Order Signed','Closed Complete - Ordered - Paid',
            'Closed Lost - Project Lost','Closed Lost - Project Cancelled','Closed/Won - Order Paid'};
        Query = 'SELECT ID, Name, Stage__c,Close_Date__c FROM Project__c WHERE Id =: filters and Stage__c Not in:projstages';
        system.debug('Value of Query' + Query);
        return Database.getQueryLocator(query);
    }
// Execute Method of Batch class
    global void execute(Database.BatchableContext BC, List < Project__c > projlist) {
     System.debug('Query list'+projlist);
        Set<id> projIds = new set<Id>();
        for(Project__c pr:projlist){
            projIds.add(pr.Id);
        }
        System.debug('Set of project ids'+projIds);
      List<Quote__c> nanaquotes = [Select id,Name,Order_Number__c,LastModifiedDate,Project__c,Project__r.Close_Date__c from Quote__c where Project__c in: projIds order by LastModifiedDate Desc Limit 1];  
        System.debug('Quotes list'+nanaquotes);
        Map<Id,Project__c> toupdate = new Map<Id,Project__c>();
        toupdate = new Map<Id,Project__c>(projlist);
        if(nanaquotes.size()>0){
        for(Quote__c qu:nanaquotes){
            if(qu.Order_Number__c != null && qu.Order_Number__c != 0){
               Datetime erd = qu.LastModifiedDate.addDays(60);
               Project__c p = toupdate.get(qu.Project__c);
               p.Close_Date__c = date.newInstance(erd.year(),erd.month(),erd.day());
            }
            else{
              Datetime erd = qu.LastModifiedDate.addDays(180);
              Project__c p = toupdate.get(qu.Project__c);
              p.Close_Date__c = date.newInstance(erd.year(),erd.month(),erd.day());            
            }
        }
      }
        System.debug('projects map'+toupdate);
        if(toupdate.size()>0){
            try{
                update toupdate.values();
                System.debug('Success');
            }
            catch(Exception e){
                System.debug('The Exception is'+e);
            }
        }
    }
    global void finish(Database.BatchableContext BC) {

    }
}