public with sharing class Account_Org_Chart_Controller {
    private final Account acc;
    public Account_Org_Chart_Controller(ApexPages.StandardController stdController) 
    {    
        this.acc = (Account)stdController.getRecord();    
    }
    
    public List<Account> getAccounts()
    {
    	return Utility.AccountTreetoList(acc.id).values();
    }
    
}