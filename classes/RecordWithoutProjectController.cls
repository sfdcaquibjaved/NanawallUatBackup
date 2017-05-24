public class RecordWithoutProjectController {
  public List <Account> AccSiteList{get;set;}  
    public integer siz{get;set;}  
    public string sortFullExp{get;set;}
    public string sortExpression{get;set;}
    public string sortDirection{get;set;}
    public String ordby;
    public string sortExp{get;set;}
    public RecordWithoutProjectController(ApexPages.StandardController con){
    AccSiteList = new List <Account>();
        siz=0;
        sortFullExp='';
        sortExpression='';
        sortDirection='';
        sortExp='';
    }
    
public PageReference ViewData()
        {
           sortFullExp = sortExpression  + ' ' + sortDirection;  
  
           if(sortExp.equalsIgnoreCase('AccName')){ noProjectAccounts(); ordby = 'End_Customer_Account__r.Name'; }
        
           else if (sortExp.equalsIgnoreCase('PrjName')) ordby = 'Name';
            
           else  if (sortExp.equalsIgnoreCase('Amount')) ordby = 'Amount__c';
            
           else if (sortExp.equalsIgnoreCase('Stage')) ordby = 'Stage__c';   
            
            else if (sortExp.equalsIgnoreCase('PCrtDt')) ordby = 'CreatedDate';
            
            else if (sortExp.equalsIgnoreCase('Arch')) ordby = 'Architect_Account__c';
            
            else if (sortExp.equalsIgnoreCase('Purch')) ordby = 'Purchaser_Account__c';
            
            else if (sortExp.equalsIgnoreCase('Ordering')) ordby = 'Ordering_Account__c';
            
            else if (sortExp.equalsIgnoreCase('City')) ordby = 'Project_City__c';
            
            else if (sortExp.equalsIgnoreCase('State')) ordby = 'Project_State__c';
            
            else if (sortExp.equalsIgnoreCase('Zipcode')) ordby = 'Project_Zip_Code__c';
            
            else if (sortExp.equalsIgnoreCase('AppIndustry')) ordby = 'Application__c';
                 
      // ProjectList.clear();
            
           // runQuery(ObjAcc.Id);
      
            //PageReference pr = new PageReference(ProjectList);
            
            return null;
     }    
public List<Account> noProjectAccounts(){
        /* ************** Query fetch the record which has no project**************** */
        AccSiteList = [Select Name, Id, (Select id from Projects1__r) from Account where parent.Id=:ApexPages.currentPage().getParameters().get('ID')]; //OR id=:string.valueOf(ObjAcc.Id).left(15) */
       
        siz = AccSiteList.size();
        
        List<Account> acctemp = new List<Account>();
        
        for(Account a: AccSiteList)
           if(a.Projects1__r.size()==0)
              acctemp.add(a);
        
        AccSiteList = acctemp; /* Assign acctemp list to AccSiteList which contain record without project*/
       
        return AccSiteList;
    }
}