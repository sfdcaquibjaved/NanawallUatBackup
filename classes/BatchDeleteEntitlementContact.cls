global class BatchDeleteEntitlementContact implements Database.Batchable<sObject>{
    String Query;
    

    global Database.QueryLocator start(Database.BatchableContext BC){
         Query = 'SELECT ID FROM EntitlementContact';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<EntitlementContact> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext BC){}
}