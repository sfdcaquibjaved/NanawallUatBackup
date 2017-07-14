/**********************************************************************
Apex Class: projectUpdateEmail_Controller
Description: This class works as a controller for projectUpdateEmail VF page 
Author David: Aquib Javed
Created Date: 12th July,2017            
***********************************************************************/

public class projectUpdateEmail_Controller {
  
    public String ProjectId {get;set;}
    public String ResponseCode {get;set;}
    
    /*************************************************
    Method Name: projectUpdateEmail_Controller
    Description: Constructor of this class
    Input Parameter: N/A    
    *************************************************/
    
    public projectUpdateEmail_Controller () {
        ProjectId = ApexPages.currentPage().getParameters().get('ProjectId');
        ResponseCode = ApexPages.currentPage().getParameters().get('ResponseCode');
    }
    
    /*************************************************
    Method Name: InitPage
    Description: This method will be called when user clicks on button in EMail 
                 It updates the project stage as per user input
    Input Parameter: N/A    
    *************************************************/
    public void InitPage() {
        
        //Code not bulkified as we will only be dealing with one project at a time based on Reps input. 
        
        List<Project__c> RepReply = [SELECT Id, Stage__c FROM Project__c WHERE Id=:ProjectId LIMIT 1]; 
        
        if(!RepReply.IsEmpty()){
            
            if(ResponseCode == 'Lost' ){
                 
                RepReply[0].Stage__c= 'Closed Lost - Project Lost';
                RepReply[0].Reason_Project_Lost__c = 'None';
            }
            
            else if(ResponseCode == 'Cancelled' ){
                 
                RepReply[0].Stage__c= 'Closed Lost - Project Cancelled';
                RepReply[0].Reason_Project_Lost__c = 'None';
                
            }
            
            else if(ResponseCode == 'Inactive'){
                
                 RepReply[0].Stage__c= 'Closed - Inactivity';
            }
           
            //DMLs inside try block
            try{
                    UPDATE RepReply;
            }
            catch(exception e){
                system.debug('Exception is:' +e.getMessage());
            }
        }
    }
}