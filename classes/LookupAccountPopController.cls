public class LookupAccountPopController {
public List<Account> AccountList{get;set;}
public String passString { get; set; }
public PageReference passValue() {    
    PageReference pgref = new PageReference('/apex/AccountHierarchyWithProjects_demo');
  
    pgref.setRedirect(true);
    return pgref;
}    
    
    public LookupAccountPopController(ApexPages.StandardController con){
        AccountList = new List <Account>();
         AccountList = [Select name from account where parentid =:ApexPages.CurrentPage().getparameters().get('id')]; 
    }
}