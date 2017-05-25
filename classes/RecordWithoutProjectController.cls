public class RecordWithoutProjectController {
  public List <Account> AccSiteList{get;set;}  
  public integer siz{get;set;} 
    
  public RecordWithoutProjectController(ApexPages.StandardController con){
     AccSiteList = [SELECT Account.Name FROM Account WHERE parent.id=:ApexPages.currentPage().getParameters().get('ID') AND Account.Id NOT IN (SELECT project__C.End_Customer_Account__c FROM project__c)];
        siz=AccSiteList.size();
        
    }
  public PageReference ActionGoBack(){

    // create case, etc.

    PageReference pr = new PageReference('/apex/AccountHierarchyWithProjects_Nishant?ID='+ApexPages.currentPage().getParameters().get('ID'));
    pr.setRedirect(true);
    return pr;
}  
   
    
}