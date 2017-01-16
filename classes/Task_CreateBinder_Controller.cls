public with sharing class Task_CreateBinder_Controller {

	string objType = '';
	string objID = '';
	
	public Task newTask { get { if(newTask == null ) { newTask = new Task(); } return newTask; } set; }
	
	boolean initd =false;
    public Task_CreateBinder_Controller() 
    {
		if( !initd )
		{ 
			initd = true; 

			newTask.OwnerId = '005A0000000MOJS';		
			newTask.Subject = 'Send Binder';	
		
			string contactID = ApexPages.currentPage().getParameters().get('ContactID');
			string leadID = ApexPages.currentPage().getParameters().get('LeadID');
			
			if( contactID != null && contactID != '' )
			{
				objType = 'contact';
				objID = contactID;
			} else
			{
				objType = 'lead';
				objID = leadID;
			
			}
			
			newTask.WhoId = objID;
		}
    }
    
    public PageReference save() 
    {
    	
    	try 
    	{
	    	insert newTask;
	    	return new PageReference('/' + objID);
	    	
    	}catch (exception ex )
    	{
			Apexpages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, ex.getMessage() +'') );	
    	}
    
    	return null;
    }
}