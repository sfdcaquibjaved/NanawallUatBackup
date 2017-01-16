public with sharing class installerorder_createssq_controller {
	//methods
    
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
    	

		if( newcase.Quote__c != null )
		{
	    	quote__c a = [select id,opportunity__c from quote__c where id =:newcase.Quote__c limit 1];
	    	id oppid = a.opportunity__c;
	    	
	    	for (nrOpportunityContactRole__c c : [ select id, contact__r.id,contact__r.name from nrOpportunityContactRole__c where opportunity__c =:oppid ORDER BY contact__r.LastName, contact__r.FirstName ])
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
    		Quote__c q = [select id,address__c,Office_Phone__c,city__c,state__c,zip__c, Calculated_Email__c from quote__C where id =: newcase.Quote__c ];
 			newcase.Other_Last_Name__c = '';
 			newcase.Other_First_Name__c = '';
    		
    		newcase.Other_Phone__c = q.Shipping_Phone__c;
    		newcase.Other_Email__c = q.Calculated_Email__c;	
    		
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
	    			
	    			newcase.Other_First_Name__c = c.FirstName;
	    			newcase.Other_Last_Name__c = c.LastName;
		    		newcase.Other_Phone__c = c.Phone;
		    		newcase.Other_Email__c = c.Email;	
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
		    			newcase.Other_First_Name__c = u.FirstName;
		    			newcase.Other_Last_Name__c = u.LastName;
		    			newcase.Other_Email__c = u.Email;
		    			newcase.Other_Phone__c = u.Phone;
		    			
		    			newcase.ContactId = c.id;
	    			} else 
	    			{
//						Apexpages.addMessage( new Apexpages.Message( apexpages.Severity.INFO,'null contact' ));    			
	    			}
    			} catch (Exception ex ) {
//					Apexpages.addMessage( new Apexpages.Message( apexpages.Severity.INFO,'null contact' ));    			
    			}
    		}
    		
    		if( c == null && u == null && useAddress != null && useAddress != '' && useAddress != '-SELECT-')
    		{ //it aint a contact, it aint a user, maybe its an installer!
    			Account a = [SELECT id, Name,Address_1__c,Company_Email__c,Phone FROM Account WHERE id = :useAddress ];
    			if( a != null )
    			{

	    			newcase.Other_First_Name__c = a.Name;
	    			newcase.Other_Last_Name__c = '';
	    			newcase.Other_Email__c = a.Company_Email__c;
	    			newcase.Other_Phone__c = a.Phone;
	    			
	    			newcase.AccountId = a.id;
    			
    			}
    		}
    	}
    	else
    	{
    		newcase.Other_First_Name__c = '';
			newcase.Other_Last_Name__c = '';
			newcase.Other_Email__c = '';
			newcase.Other_Phone__c = '';
			
			selectedContact = null;
    	}
    	return null;
    }



	//properties
    public string txtCaseComment { get; set; }
    public String UseAddress { get; set; }     
	
	public Case newcase 
	{
		get 
		{
			if( newcase == null )
				newcase = new Case();
				
			return newcase;
		}
		set;
	}

	public Service_Quote__c newsq 
	{
		get 
		{
			if( newsq == null )
				newsq = new Service_Quote__c();
				
			return newsq;
		}
		set;
	}


	public pagereference docreate() 
	{
		
		list<Installer_Order_Position__c> positions = [SELECT Id,Quantity__c,Service_Part__c FROM Installer_Order_Position__c WHERE Installer_Order__c = :this.io.Id ];

		insert newcase;		
		
		newsq = new Service_Quote__c();
		newsq.Case__c = newcase.Id;
		newsq.Ship_To_Address__c = this.io.Shipping_Address__c;
		newsq.Ship_To_City__c = this.io.Shipping_City__c;
		newsq.Ship_To_State__c = this.io.Shipping_State__c;
		newsq.Ship_To_Zip__c = this.io.Shipping_Zip__c;
		newsq.Ship_To_Phone__c = this.io.Shipping_Phone__c;
		newsq.Shipping_Method__c = this.io.Shipping_Method__c;
		
		newsq.Other_Bill_To_Address__c = this.io.Billing_Address__c;
		newsq.Other_Bill_To_City__c = this.io.Billing_City__c;
		newsq.Other_Bill_To_State__c = this.io.Billing_State__c;
		newsq.Other_Bill_To_Zip__c = this.io.Billing_Zip__c;
		
		newsq.Discount__c = 20;
		map<string,TaxRate__c> taxRates = Utility.GetTaxRates();
		
System.debug('project state: ' + this.io.Project_State__c );
		if( !taxRates.containsKey(this.io.Project_State__c ) )
		{
			newsq.TaxRate__c = 0;
		} else 
		{
System.debug('tax rate: ' + taxRates.get(this.io.Project_State__c).Service_Quote_Tax_Rate__c );
			newsq.TaxRate__c = taxRates.get(this.io.Project_State__c).Service_Quote_Tax_Rate__c;
		}
		insert newsq;
		
		
		
		list<Service_Quote_Detail__c> details = new list<Service_Quote_Detail__c>();
		Integer posCount = 1;
		for( Installer_Order_Position__c pos : positions )
		{
			Service_Quote_Detail__c det = new Service_Quote_Detail__c();
			det.Quantity__c =  pos.Quantity__c;
			det.Position__c = posCount++;
			det.Service_Part__c = pos.Service_Part__c;
			det.Service_Quote__c = newsq.Id;
			
			details.add(det);
		}
		
		if(details.size() > 0  )
			insert details;

		this.io.Case_Created__c = true;
		this.io.Case__c = newcase.Id;
		this.io.Service_Quote__c = newsq.Id;
		update this.io;
				
		return new PageReference('/' + newsq.id);


	}

	public pagereference cancel() 
	{
		return new PageReference('/' + this.io.Id );
	}


	private boolean initd = false;
    private final Installer_Order__c io;

    public installerorder_createssq_controller(ApexPages.StandardController stdController) {
        this.io = (Installer_Order__c)stdController.getRecord();
        
        if( !this.initd )
        {
			//init code in here 
	        initd = true;
        }
    }

}