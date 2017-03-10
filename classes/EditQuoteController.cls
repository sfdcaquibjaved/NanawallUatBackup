<<<<<<< HEAD
public with sharing class EditQuoteController
{
//    private ApexPages.StandardController controller;    
    private Quote__c q;    
    public EditQuoteController(ApexPages.StandardController controller)    
    {//        this.controller = controller;
                 q = (Quote__c)controller.getRecord();
    }  
         
    public String getUserID()
    {        
    	string ret;
    	try
    	{
    	ret = UserInfo.getUserId();
    	}
    	catch (Exception ex)
    	{
    		ret='';
    	}
        return ret;
    }
=======
public with sharing class EditQuoteController
{
//    private ApexPages.StandardController controller;    
    private Quote__c q;    
    public EditQuoteController(ApexPages.StandardController controller)    
    {//        this.controller = controller;
                 q = (Quote__c)controller.getRecord();
    }  
         
    public String getUserID()
    {        
    	string ret;
    	try
    	{
    	ret = UserInfo.getUserId();
    	}
    	catch (Exception ex)
    	{
    		ret='';
    	}
        return ret;
    }
>>>>>>> 38d5474048e4349e5fb1b806274e5d38ea1dc1fc
}