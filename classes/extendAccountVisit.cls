public class extendAccountVisit {

//public List<Site_Visit1__c> sites{get; set;}

//public Opportunity Site_Visit1__c{get; set;}
public List<Account> ProjSiteList{get;set;}



 public extendAccountVisit(ApexPages.StandardController con) {
ProjSiteList = new List<Account>();
   //   currentRecord = [SELECT Id, Name, AccoutID FROM site_visit1__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')]; // this will return current record object(child) detail from that you can use parent Id (here Account is parent so accoutId)
ProjSiteList = [Select name from account where parentid =:ApexPages.CurrentPage().getparameters().get('id')]; 
     

 // sites = [SELECT id, Time_and_Date__c, name, AccountId FROM site_visit1__c WHERE AccountId=:currentRecord.accountId];

 }



}