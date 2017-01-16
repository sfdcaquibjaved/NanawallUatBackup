public with sharing class ProjectSplitPageControllerOverRide {
  
  public project_split__c custProjSplit ;
  
  public ProjectSplitPageControllerOverRide(ApexPages.StandardController controller) {
    
    //To avoid SOQL 
         if (!Test.isRunningTest()) {
            //Adding these fields to avoid additional SOQL query.
            controller.addFields(new List < String > {
                'Project__c'
            });
        }
    
    custProjSplit = (project_split__c) controller.getRecord(); 
    
  }
  
  public pageReference redirect(){
    
    String url = '/apex/ProjectSplitPage?id=' + custProjSplit.Project__c ;
      PageReference redUrl = new PageReference(url);
      redUrl.setRedirect(true);
      return redUrl ;
  }

}