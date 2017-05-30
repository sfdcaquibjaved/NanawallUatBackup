public class RecordWithoutProjectController {
  public List <Account> AccSiteList{get;set;}  
  public integer size {get;set;} 
  public integer siz {get;set;} 
  
  Public Integer noOfRecords{get;set;} 
  public string accountid = ApexPages.currentPage().getParameters().get('ID');
  public List<SelectOption> paginationSizeOptions{get;set;}
    
  public RecordWithoutProjectController(ApexPages.StandardController con)
  
{
        size=50;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('75','75'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        paginationSizeOptions.add(new SelectOption('150','150'));
        paginationSizeOptions.add(new SelectOption('200','200'));
        paginationSizeOptions.add(new SelectOption('250','250'));
       
        
    }
    public ApexPages.StandardSetController setCon 
    {
        get {
            if(setCon == null) {                
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [SELECT Account.Name FROM Account WHERE parent.id=:ApexPages.currentPage().getParameters().get('ID') AND Account.Id NOT IN (SELECT project__C.End_Customer_Account__c FROM project__c)]));
              //   siz=setcon.size();
                setCon.setPageSize(size);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
         }
        set;
    }
     //Changes the size of pagination
    public PageReference refreshPageSize() {
         setCon.setPageSize(size);
         return null;
    }
 
    // Initialize setCon and return a list of record    
     
    public List<Account> getOpportunities() {
         return (List<account>) setCon.getRecords();
    }
  public PageReference ActionGoBack()
  {

    // create case, etc.

    PageReference pr = new PageReference('/apex/AccountHierarchyWithProjects_Nishant?ID='+ApexPages.currentPage().getParameters().get('ID'));
    pr.setRedirect(true);
    return pr;
}  
   
    
}