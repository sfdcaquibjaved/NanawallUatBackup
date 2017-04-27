global class AttachmentTOFileConversion implements Database.Batchable < sObject >
//implements Database.Batchable < sObject >
 {
  //Start method of the batch class
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name,Phone FROM Installation__c';
        return Database.getQueryLocator(query);
    }
    
    //Execute method of the batch class
     global void execute(Database.BatchableContext BC, List<Installation__c> scope)
    {
      List<attachment> attList=[select id,ParentId,Name,Body from attachment where ContentType=:'attachment'];
      
        for ( Installation__c inst : scope)
        {
         attachment a=new attachment();
         a.ParentId = inst.id;
         a.ContentType='File';
        }
        update scope;
    }  

    //Finish method of the batch class
    global void finish(Database.BatchableContext BC)
    {
    }
}