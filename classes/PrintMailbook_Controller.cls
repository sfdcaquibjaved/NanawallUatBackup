public with sharing class PrintMailbook_Controller {

	private final Task t;
    public PrintMailbook_Controller(ApexPages.StandardController stdController) {
        this.t = (Task)stdController.getRecord();
        
    }
    
    public PageReference checkType() {


		Task task = [SELECT id, recordtypeid FROM Task where id = :Apexpages.currentPage().getparameters().get('id') ];    	

		if( task.recordtypeid == Schema.SObjectType.Task.getRecordTypeInfosByName().get('Mailbook').getrecordtypeid() )
		{
	        if( getRenderMode() == 'pdf' )
	        {
	        	CloseTask();
	        }			
			return null;
		} else 
		{
			PageReference p =  new Pagereference('/'+task.id+'/e'  );
	    
	    	p.getParameters().put('nooverride','1');
	    	p.getParameters().put('close','1');
	    	p.getParameters().put('retURL',getretURL() );
	    	
	    	return p;
		}

    }

	public boolean getrenderContent() {
        if( getRenderMode() == 'pdf' )
			return true;
		else return false;
	}
    
    private contact c = null;
    public Contact getContact() {
    	if( c==null)
    	{
    		try {
    		c = [SELECT c.id, c.OwnerId, c.Owner.FirstName, c.Owner.LastName, c.Owner.Phone, c.Address_1__c,c.address_2__c, c.City__c, c.State__c, c.Zip__c, c.title, c.firstname, c.lastname, c.accountid, c.account.name FROM Contact c WHERE id = :t.WhoId ];
    		} catch(Exception e ){
    			c = new Contact();
    		}
    	}

    	return c;
    }
    
    public string getcontactstreet() {
    	return getContact().Address_1__c;
  	}
    
    public string getcontactcity() {
		return getcontact().City__c;
    }
    
    public string getcontactstate() {
    	return getcontact().State__c;
    }

	private Quote__c q = null;
	public Quote__c getQuote() {
		if( q == null )
		{
			try {
			q = [SELECT q.id, q.name, q.Opportunity__c, q.Opportunity__r.Name,q.Opportunity__r.Application__c, q.Quote_ID__c FROM Quote__c q WHERE q.id = :t.WhatId];
			} catch(Exception e ){
				q = new Quote__c();
			}
		}

		return q;
	}
	
	public string getquotenumber() {
		return getquote().quote_id__c + '';
	} 
	
	public string getrepname() {
		return getcontact().owner.firstname + ' ' + getcontact().owner.lastname;
	}
	public string getrepphonenumber() {
		return getcontact().owner.phone;
	}
	
	public string getProjectName() {
		Quote__c quote = getQuote();

		try {
			return quote.Opportunity__r.name;
		} catch( Exception e ) {
			return '';
		}		
	}    
	public string getProjectApplication() {
		Quote__c quote = getQuote();

		return quote.Opportunity__r.Application__c;
		
	}    
	public string getMailbookCode() {
		
		string app = '';
		
		try {
			app = getProjectApplication().toLowerCase();
		} catch (Exception ex ) {}
				
		string ret = '';
		
		if( app == 'single family residential - new' 
		|| app == 'single family residential - remodel' 
		|| app == 'multifamily'
		|| app == 'retail' 
		|| app == 'other')
		{//Residential
			ret = '(R)';
		} else if( app == 'restaurants' 
		|| app == 'recreation/entertainment' 
		|| app == 'hotels'
		|| app == 'health care/assisted living'  
		|| app == 'offices/interiors' ) 
		{//Hospitality
			ret = '(H)';
		} else if( app == 'sports venue' 
		|| app == 'religious institutions'
		|| app == 'recreation/entertainment' 
		|| app == 'education' )
		{ //Education
			ret = '(E)';
		}
		return ret;
	}
	
    public string getcontactzip() {
    	return getcontact().Zip__c;
    }
    
    public string getcontactname() {

		try {
			Contact cont = getcontact();
			
			if( cont.Title != null && cont.Title != ''
			&& cont.Title.length() > 0  ) return cont.Title + ' ' + cont.LastName;
			else return cont.FirstName + ' ' + cont.LastName;
		}catch (Exception ex ) {
			return ex + '';
		}
    }

	public boolean gethascompanyname() { 
		Contact c = getContact();
		
		return ( c.account.name != null && c.account.name != '' ? true : false); 
	}
	public string getcompanyname() { return c.account.name; }
    
    public string getdate() { return date.today().month()+' - '+date.today().day()+' - '+date.today().year(); }
    
    
    
    private void CloseTask() {
		//use this method to actually close the task
		Task t = this.t;
		t.Status = 'Completed';

		update t;
    }
     
	public string getID() { return this.t.id; }
	public string getRenderMode() {
		String mode = ApexPages.currentPage().getParameters().get('mode');
		
		if( mode != null && mode == 'pdf' ) return 'pdf';
		else return '';
	}
	
	public boolean gethasContactstreet2() {
		return ( getcontact().address_2__c != null && getcontact().address_2__c != '' ? true : false);
	}
	public string getcontactstreet2() {
		Contact c = getcontact();
		if( c.address_2__c.length() > 0    )
		{
			return c.address_2__c;
		}
		return '';	
	}
	
	public string getretURL() {
		String retURL = ApexPages.currentPage().getParameters().get('retURL');

		if( retURL != null && retURL != '' ) return encodingutil.urlDecode(retURL,'UTF-8');
		else return '';
	}
}