public with sharing class QuoteCase_Add_Controller {
	public Task newTask { get; set; }
	public boolean CreateNewTask{ get; set; } 
	
	
	public Case getcase() { return thisCase; }
	public void setcase( Case c) { thisCase = c; }
	
	private  Case thisCase;
	private boolean initd = false;
	public QuoteCase_Add_Controller(ApexPages.StandardController controller) {
		thisCase = (Case)controller.getrecord();
		thisCase.Quote__c = ApexPages.currentPage().getParameters().get('qid');

		if( !initd )
		{
			newTask = new Task();
			CreateNewTask = false;
			initd = true;
		}
	}
    
    public string txtCaseComment { get; set; }
    public String UseAddress { get; set; }     
    
    public list<selectOption> getReps() {
		List<SelectOption> options = new List<SelectOption>();


        for(User u :  [SELECT id, FirstName, LastName FROM User WHERE IsActive = true  AND profileid != '00eA0000000RSay' AND Profileid != '00eA0000000Rh8Q'  ORDER BY LastName, FirstName ] )
        {
	        options.add(new SelectOption(u.id, u.FirstName + ' ' + u.LastName ));        
        }

        return options;    
    }
    
    public List<SelectOption> getContacts()
    {
    	List<SelectOption> options = new List<SelectOption>();
    	

    	quote__c a = [select id,opportunity__c from quote__c where id =:thiscase.quote__c limit 1];
    	id oppid = a.opportunity__c;
    	
    	for (nrOpportunityContactRole__c c : [ select id, contact__r.id,contact__r.name from nrOpportunityContactRole__c where opportunity__c =:oppid ORDER BY contact__r.LastName, contact__r.FirstName ])
    	{
    		if( c != null && c.Contact__r != null )
    		{
	    		SelectOption so = new SelectOption(c.contact__r.id,c.contact__r.name);
	    		options.add(so);
    		}
    	}

    	return options;
    }
    
    public List<SelectOption> getInstallers()
    {
    	List<SelectOption> options = new List<SelectOption>();
    	
    	for (Account a : [ select id, Name from Account where Certified_Installer__c = true ORDER BY name ])
    	{
    		SelectOption so = new SelectOption(a.id,a.name);
    		options.add(so);
    	}

    	return options;
    }
    
    private Contact selectedContact = null;
    public PageReference setaddress()
    {
    	if (UseAddress=='Order')
    	{
    		Quote__c q = [select id,address__c,Office_Phone__c,city__c,state__c,zip__c, Calculated_Email__c from quote__C where id =: thisCase.Quote__c ];
 			thiscase.Other_Last_Name__c = '';
 			thiscase.Other_First_Name__c = '';
    		
    		thiscase.Other_Phone__c = q.Shipping_Phone__c;
    		thiscase.Other_Email__c = q.Calculated_Email__c;	
    		
    		selectedContact = null;
    	}
    	else if ( UseAddress != '-UseAddress-')
    	{

			Contact c = null;
			User u = null;
			try {
    		c = [select id,firstname,lastname,address_1__c,Address_2__c,City__c,state_abbr__C,State__c,Zip__c,Phone,Fax,Email, AccountID  from contact where id =:UseAddress];
    		selectedContact = c;
    		if( c != null )
    		{
	    			
	    			thiscase.Other_First_Name__c = c.FirstName;
	    			thiscase.Other_Last_Name__c = c.LastName;
		    		thiscase.Other_Phone__c = c.Phone;
		    		thiscase.Other_Email__c = c.Email;	
	    		}  else
	    		{
//					Apexpages.addMessage( new Apexpages.Message( apexpages.Severity.INFO,'null contact' ));    			
	    		}
			} catch(Exception ex ) {
//				Apexpages.addMessage( new Apexpages.Message( apexpages.Severity.INFO,'null contact' ));    			
			}
			
			if( c == null ) //if c is null, we got no contact. try the users
    		{
    			try {
	    			u = [SELECT id,FirstName,LastName, Email, Phone FROM User WHERE id = :UseAddress ORDER BY LastName ];
	    			if( u != null )
	    			{
		    			thiscase.Other_First_Name__c = u.FirstName;
		    			thiscase.Other_Last_Name__c = u.LastName;
		    			thiscase.Other_Email__c = u.Email;
		    			thiscase.Other_Phone__c = u.Phone;
		    			
		    			thisCase.ContactId = c.id;
	    			} else 
	    			{
//						Apexpages.addMessage( new Apexpages.Message( apexpages.Severity.INFO,'null contact' ));    			
	    			}
    			} catch (Exception ex ) {
//					Apexpages.addMessage( new Apexpages.Message( apexpages.Severity.INFO,'null contact' ));    			
    			}
    		}
    		
    		if( c == null && u == null )
    		{ //it aint a contact, it aint a user, maybe its an installer!
    			Account a = [SELECT id, Name,Address_1__c,Company_Email__c,Phone FROM Account WHERE id = :useAddress ];
    			if( a != null )
    			{

	    			thiscase.Other_First_Name__c = a.Name;
	    			thiscase.Other_Last_Name__c = '';
	    			thiscase.Other_Email__c = a.Company_Email__c;
	    			thiscase.Other_Phone__c = a.Phone;
	    			
	    			thisCase.AccountId = a.id;
    			
    			}
    		}
    	}
    	else
    	{
    		thiscase.Other_First_Name__c = '';
			thiscase.Other_Last_Name__c = '';
			thiscase.Other_Email__c = '';
			thiscase.Other_Phone__c = '';
			
			selectedContact = null;
    	}
    	return null;
    }
    
    public PageReference save() {
    
    
    	if( selectedContact != null )
    	{
    		thisCase.ContactId = selectedContact.Id;
    		if( selectedContact.AccountId != null )
    			thisCase.AccountId = selectedContact.AccountId;
    	}	

    	insert thisCase;
    	if( txtCaseComment != null &&txtCaseComment != '' )
		{
			CaseComment cc = new CaseComment();
			cc.CommentBody  = txtCaseComment;
			cc.ParentId = thisCase.Id;
			insert cc;
    	}
    	
    	if( CreateNewTask )
    	{
    		newTask.WhatId = thisCase.Id;
    		insert newTask;
    	}
    	
    	
    	return new PageReference('/' + thisCase.id);
    }
        
}