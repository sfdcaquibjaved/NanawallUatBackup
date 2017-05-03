global class orderAmountsCleanupBatch implements Database.Batchable < sObject > {
  
   //Global Variable
    global String query;
    global string status1 ='Draft';
    global string status2 ='On Hold';
    global string status3 ='Cancelled';
   
    
     //Start method of the batch class
    global Database.QueryLocator start(Database.BatchableContext BC) {
      
        this.query = 'SELECT Id,Name,TotalAmount,Opportunityid,project__c from order WHERE status!=:status1 AND status!=:status2 AND status!=:status3';
      
        return Database.getQueryLocator(query);
    }
    
    //Execute method of the batch class
    global void execute(Database.BatchableContext BC, List < order > records) {
      set<Id> proIds = new set<Id>();
      set<Id> oppIds = new set<Id>();
      
     for(order o:records){
         oppIds.add(o.OpportunityID);
         proIds.add(o.Project__c);
     
     }
     list<Opportunity> oppList = [select id,Amount,StageName,Project_Name__c,(select id ,TotalAmount,OpportunityID ,Status From Orders Where status!=:status1 AND status!=:status2 AND status!=:status3) from Opportunity Where ID IN:oppIds] ;
      list<opportunity> updateOppList =new list<opportunity>();
     //list<order> orderOppList = [select id,TotalAmount,OpportunityID,Opportunity.Amount from order where OpportunityID IN: oppIds];
     for(Opportunity opp:oppList){
     decimal sum =0;
      for(order o:opp.Orders){
      sum += o.TotalAmount;
           
      
      }
      if(sum >0 && opp.Amount!=sum){
      opp.amount =sum;
      updateOppList.add(opp);
      }
      
      }
      database.update( updateOppList);
      
      list<project__c> updateProList =new list<project__c>();
      list<Project__c> proList = [select id ,Amount__c,Stage__c,(select id ,TotalAmount, Status,NanaQuote__c,Project__c from Orders__r where status!=:status1 AND status!=:status2 AND status!=:status3) from Project__c where id IN : proIds];
      for(project__c pro: proList){
      decimal sum =0;
      for(order o:pro.Orders__r){
      sum += o.TotalAmount;    
      }
          if(sum >0 && pro.Amount__c!=sum){
          pro.Amount__c=sum;
          updateProList.add(pro);
          }     
      }
      database.update( updateProList);
      
    }
    
     //Finish method of the batch class
    global void finish(Database.BatchableContext BC) {

    }


}