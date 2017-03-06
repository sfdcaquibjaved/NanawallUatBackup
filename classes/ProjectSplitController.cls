/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : July 2015
    @ Test File     : NA
    Function        : Apex Class for ProjectSplit Page
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/

public class ProjectSplitController {
	
	//Global Variables
	public Project__c project ; // Detail Record
	public list<Project_Split__c> projSplitlst {get; set;} //List which contains the already created records
	
	public Integer totalCount {get;set;}
    public Integer rowIndex {get;set;}
    public map<Id,String> addressMap {get;set;}
    
	 //Constructor
   public ProjectSplitController(ApexPages.StandardController controller) {
   	 
   	  project = (Project__c) controller.getRecord();    //Get Project from controller
   	  
   	  addressMap = new map<Id,String>();
   	  //Query to get the already created records
   	  projSplitlst = [Select Id,Notes__c,Project__c,Amount__c,Account__c,Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingState,Account__r.BillingPostalCode,Account__r.BillingCountry,Project_Rep__c,Role__c,Split__c from Project_Split__c where Project__c =: project.Id];
   	  
   	  for (Project_Split__c projSplit : projSplitlst){
   	  	
   	  	String address = '';
   	  	if (projSplit.Account__r.BillingStreet != null){
   	  		address = address+ 'Street :' + projSplit.Account__r.BillingStreet + '<br/>' ;
   	  	}
   	  	if (projSplit.Account__r.BillingCity != null){
   	  		address = address+ 'City :' + projSplit.Account__r.BillingCity + '<br/>' ;
   	  	}
   	  	
   	  	if (projSplit.Account__r.BillingState != null){
   	  		address = address+ 'State :' + projSplit.Account__r.BillingState + '<br/>' ;
   	  	}
   	  	if (projSplit.Account__r.BillingPostalCode != null){
   	  		address = address+ 'Postal Code :' + projSplit.Account__r.BillingPostalCode + '<br/>' ;
   	  	}
   	  	if (projSplit.Account__r.BillingCountry != null){
   	  		address = address+ 'Country :' + projSplit.Account__r.BillingCountry + '<br/>' ;
   	  	}
   	  	
   	  	addressMap.put(projSplit.Account__c, address);
   	  }
   	  
   	  addressMap.put(null,'Address Not Available');
   	  
   	  totalCount = projSplitlst.size() ;
    	
    }
    
   
    
    /******************************************************************************************************************
     Method Name: addRow
     Description: The method adds a new row to the list of Project Split shown on the page
     Input Parameter: NA       
    *******************************************************************************************************************/
    public void addRow(){
    	
	  projSplitlst.add(new Project_Split__c(Project__c = project.Id));
     
     }
     
     /******************************************************************************************************************
      Method Name: deleteRow
      Description: The method deletes a row from the list of Project Split shown on the page
      Input Parameter: NA       
    *******************************************************************************************************************/
     
     public void deleteRow(){
     	  
		 rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
		 Project_Split__c projSplitDel = projSplitlst.remove(rowIndex);
		 
	  }
	  
	/******************************************************************************************************************
      Method Name: Save
      Description: The method saves the records shown
      Input Parameter: NA       
    *******************************************************************************************************************/
	  
	  public PageReference Save(){
	  	 
	  	  if (validateProjectSplit(projSplitlst)){
            if(projSplitlst.size() >0){
	          try{
		      upsert projSplitlst;
		      update project ;
		      PageReference pageRef = new PageReference('/apex/ProjectSplitPage?id=' + project.Id);
		      pageRef.setRedirect(true);
		      return pageRef;
		      }
		      Catch (Exception ex){
		        }
               }
              }
		       else{
	          	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Total Project Split should be 100'));
	          }
	          return null ;
         }
	
	
	 /******************************************************************************************************************
      Method Name: validateProjectSplit
      Description: The method Validates the total of any Project Split is equal to 100.
      Input Parameter: NA       
    *******************************************************************************************************************/
	
	public boolean validateProjectSplit(list<Project_Split__c> projSplitllist){
		
		map<Id, decimal> currentSplitMap = new map<Id, decimal>(); // Map to store the Split Amount
		boolean validate = false;
		
		//Populating the Map
		for (Project_Split__c pSplit : projSplitllist){
			
			if(pSplit.Split__c != null){
			
			if (!currentSplitMap.containsKey(pSplit.Project__c)){
				currentSplitMap.put(pSplit.Project__c,pSplit.Split__c);
			}
			else{
				Decimal total = currentSplitMap.get(pSplit.Project__c) ;
				currentSplitMap.put(pSplit.Project__c,total + pSplit.Split__c);
		 	}
		  }	
		}
		
		System.debug('$$$$$$$$$$$' + currentSplitMap);
	   
	 	for (Project_Split__c pSplit : projSplitllist){
			
			if (currentSplitMap.get(pSplit.Project__c) == 100){
			  validate= true ;
			 }	
		}
		currentSplitMap.clear();
		return validate ;
	} 

}