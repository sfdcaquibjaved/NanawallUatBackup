public with sharing class ContactHomeController
 { 
     
     map<id,string> uidToTerrLookup = new map<id,string>();
     
     public string selectedTerritory = '';
     public string getSelectedTerritory() { return selectedTerritory; }
     public void setSelectedTerritory( string terr ) { selectedTerritory = terr; }
	 public List<SelectOption> getTerritories() {
		List<SelectOption> options = new List<SelectOption>();

		options.add(new SelectOption('AZ-NVsouth','AZ-NVsouth')); //OK
		options.add(new SelectOption('CanadaON','CanadaON')); //NOT IN LIST
		options.add(new SelectOption('CanadaBC','CanadaBC')); //OK
		options.add(new SelectOption('Can-MidWest','Can-MidWest')); //OK
		options.add(new SelectOption('CAnorth-NVnorth','CAnorth-NVnorth')); //OK
		options.add(new SelectOption('CanadaQC','CanadaQC')); //OK
		options.add(new SelectOption('CAsouth','CAsouth'));  //OK
		options.add(new SelectOption('CO-WY-NM-MTeast','CO-WY-NM-MTeast')); //OK
		options.add(new SelectOption('FL-AL-TN','FL-AL-TN')); //OK
		options.add(new SelectOption('FL-Car','FL-Car')); //OK
		options.add(new SelectOption('FLsouth-ne','FLsouth-ne')); //OK
		options.add(new SelectOption('FLwest-nw','FLwest-nw')); //OK
		options.add(new SelectOption('GA','GA')); //OK
//		options.add(new SelectOption('IL-WI','IL-WI')); // NOT OK   IL-  is its own now
		options.add(new SelectOption('IL-','IL-WI')); // NOT OK   IL-  is its own now. turns out whoever set this up put a blank space in between the dash and WI. this is a hack to fix it
		options.add(new SelectOption('KY-OH-PA','KY-OH-PA')); //OK
		options.add(new SelectOption('MX','MX')); //OK
		options.add(new SelectOption('MI','MI'));  // OK
		options.add(new SelectOption('MN-WIwest-ND-SD','MN-WIwest-ND-SD')); //OK
//		options.add(new SelectOption('MO-KS-IL-IA-NE','MO-KS-IL-IA-NE'));  //IA-NE is separate from the rest, MO-KS-IL are separate
		options.add(new SelectOption('MO-KS-IL','MO-KS-IL'));  //IA-NE is separate from the rest, MO-KS-IL are separate
		options.add(new SelectOption('IA-NE','IA-NE'));  //IA-NE is separate from the rest, MO-KS-IL are separate
		options.add(new SelectOption('NAEastern','NAEastern')); //OK
		options.add(new SelectOption('NC-SC','NC-SC')); //OK
		options.add(new SelectOption('NJ-PNeast','NJ-PNeast')); //OK
		options.add(new SelectOption('NorthWest-HI','NorthWest-HI')); //OK
		options.add(new SelectOption('NY-NJ','NY-NJ')); //OK
		options.add(new SelectOption('OH-MI-IN','OH-MI-IN')); //OK
		options.add(new SelectOption('OK-TX','OK-TX')); //OK
		options.add(new SelectOption('RI-ME-CO-MA-NH-VE','RI-ME-CO-MA-NH-VE'));
		options.add(new SelectOption('TN-MS-AR','TN-MS-AR')); // OK
		options.add(new SelectOption('TX-LA-MA-AL','TX-LA-MA-AL'));  //OK
		options.add(new SelectOption('UT','UT')); //OK
		options.add(new SelectOption('VA-MD-DE-WV-DC','VA-MD-DE-WV-DC')); //OK


		return options;
	}
             
    public ContactHomeController(){
        //    Apexpages.addMessage( new ApexPages.message( apexpages.Severity.ERROR,'constructor') );
         sortexp=' order by name asc';
         previoussortfield='name';
         country='united states';
                  List<Contact> dummylist = new List<Contact>();
         mycontroller=
             new ApexPages.StandardSetController(dummylist);
             
             
    }
    

     
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    public String sortexp{get;set;}

	public boolean getOfficeUser()
	{
		return userinfo.getProfileID() != '00eA0000000Qn2VIAS' && userinfo.getProfileID() != '00eA0000000RgW3IAK';
	}
	
    public boolean getTools()
    {
    	id id1 = userinfo.getProfileId();
		if (id1 == '00eA0000000QOwuIAG' ||
			id1=='00eA0000000QqGHIA0' ||
			id1=='00eA0000000QmslIAC'  ||
			id1=='00eA0000000QryBIAS')
			
    		return true;
    	return false;
    }
    
    public string State
    {
        get 
        {
            return State;
        }
        set
        {
            State=value;
        }
    }  
    
    public string LeadType
    {
    	get
    	{
    		return LeadType;
    	}
    	set
    	
    	{
    		LeadType=value;
    	}
    }
        public string LeadSource
    {
    	get
    	{
    		return LeadSource;
    	}
    	set
    	
    	{
    		LeadSource=value;
    	}
    }
    
    public string Address
    {
        get
        {
            return Address;
        }
        set
        {
            Address=value;
        }
    }
    
        public string City
    {
        get
        {
            return City;
        }
        set
        {
            City=value;
        }
    }
    
        public string Zip
    {
        get
        {
            return Zip;
        }
        set
        {
            Zip=value;
        }
    }
    
        public string FirstName
    {
        get
        {
            return FirstName;
        }
        set
        {
            FirstName=value;
        }
    }
    
            public string LastName
    {
        get
        {
            return LastName;
        }
        set
        {
            LastName=value;
        }
    }
         
    
    public string Country
        {
        get 
        {
            return Country;
        }
        set
        {
            Country=value;
        }
    } 
    
    public string Phone
        {
        get 
        {
            return Phone;
        }
        set
        {
            Phone=value;
        }
    } 
    
    public string Email
        {
        get 
        {
            return Email;
        }
        set
        {
            Email=value;
        }
    } 
    
        public string AccountName
        {
        get 
        {
            return AccountName;
        }
        set
        {
            AccountName=value;
        }
    } 
    
        
        public string Interest
        {
        get 
        {
            return Interest;
        }
        set
        {
            Interest=value;
        }
    } 
    
            public string RegNumber
        {
        get 
        {
            return RegNumber;
        }
        set
        {
            RegNumber=value;
        }
    } 
    
                public string Description
        {
        get 
        {
            return Description;
        }
        set
        {
            Description=value;
        }
    } 
    

    
            
        public string PhoneExt
        {
	        get 
	        {
	            return PhoneExt;
	        }
	        set
	        {
	            PhoneExt=value;
	        }
    	} 
    
          public string Address2
        {
	        get 
	        {
	            return Address2;
	        }
	        set
	        {
	            Address2=value;
	        }
    	} 
    	
    	
    	public Date CreateDate_min {
			get;
			set;
    	}
    	
		Contact dummyCont = new Contact();
		public Contact getDummyContact() { return dummyCont; }
		public void setDummyContact(Contact c ) { dummyCont = c; }

    	public string CreateDateMax
        {
	        get 
	        {

	            return CreateDateMax;
	        }
	        set
	        {
	            CreateDateMax=value;
	        }
    	} 
    	
    	public boolean Competitor
        {
	        get 
	        {
	            return Competitor;
	        }
	        set
	        {
	            Competitor=value;
	        }
    	} 
    
    public PageReference primeSearch() {
    
		Database.query('SELECT id, firstname, lastname FROM Contact LIMIT 2000 ');
	    return null;
    }
    
    public ApexPages.StandardSetController mycontroller
    {
        get
        {
            if (mycontroller==NULL){
            	if(dummyCont.Description !=NULL && dummyCont.Description!='')
            	{
//					List<List<SObject>> searchList =  [FIND :dummyCont.Description IN ALL FIELDS  RETURNING Contact ( id, name,address_1__c,state__c,zip__c,country__c,repeat_customer__c, city__c,account.name)  ];

            		string whereQuery = GetQuery(true);
					List<List<SObject>> searchList =  search.query('FIND \''+dummyCont.Description+'\' IN ALL FIELDS  RETURNING Contact ( id, name,address_1__c,state__c,zip__c,country__c,repeat_customer__c, city__c,account.name '+whereQuery+')  ');
	            	mycontroller = new ApexPages.StandardSetController( (list<contact>)searchList[0]  );
            	} else mycontroller= new ApexPages.StandardSetController(Database.getQueryLocator(GetQuery(false)));

             
                if (mycontroller.getResultSize() ==2000)
                {
                    Total= '2000+ Records';
                }
                else
                    Total=mycontroller.getResultSize() + ' Records';
                             }
             return mycontroller;
            
        }
        set;
    }
        
    public string GetQuery(boolean whereonly)
    {
		for( User u : [SELECT id, UserRoleName__c FROM User] )
		{
		if( u.UserRoleName__c == null ) continue;

			list<string> parts = u.UserRoleName__c.split('\\s+');			
			string terr = ( parts.size() > 0 ? parts.get(0) : 'missing'  );
		
			if(terr == 'West' || terr.contains('Admin') 
			|| terr.contains('Marketing') || terr == 'National' || terr=='Jurgen'
			|| terr == 'Office' || terr == 'Executives' 
			|| terr == 'Midwest' ) continue;

			uidToTerrLookup.put( u.id, terr);
		}
		
		
		
    	string query = '';
/*    	
		if (dummyCont.Description !=NULL && dummyCont.Description!='')
		{
            //query = query + ' and Description like \'%' + Description+'%\'';
		} else {
  */  	
  
	    	if( !whereonly )
	        query = 'select name,address_1__c,state__c,zip__c,country__c,repeat_customer__c, city__c,account.name from Contact where id!=\'\' ';
         	else query = ' WHERE id != \'\' ';

	        if (State != NULL && State !='')
	            query = query + ' and state__c = \'' + State +'\'';
	        if (Country!=NULL && Country!='')
	            query = query + ' and country__c = \'' + Country+'\'';    
	        if (FirstName !=NULL && FirstName!='')
	            query = query + ' and FirstName like \'%' + FirstName+'%\'';
	        if (LastName !=NULL && LastName!='')
	            query = query + ' and LastName like \'%' + LastName+'%\'';    
	        if (Address!=NULL && Address!='')
	            query = query + ' and address_1__c like \'%' + Address+'%\''; 
	        if (Address2!=NULL && Address2!='')
	            query = query + ' and address_2__c like \'%' + Address2+'%\'';
	        if (AccountName!=NULL && AccountName!='')
	            query = query + ' and account.name like \'%' + AccountName+'%\''; 
	        if (City!=NULL && City!='')
	            query = query + ' and city__c like \'%' + City+'%\''; 
	        if (Zip!=NULL && Zip!='')
	            query = query + ' and Zip__c like \'%' + Zip + '%\''; 
	        if (Phone!=NULL && Phone!='')
	            query = query + ' and phone like \'%' + Phone+'%\''; 
	        if (PhoneExt!=NULL && PhoneExt!='')
	            query = query + ' and Office_Ext__c like \'%' + PhoneExt+'%\''; 
	        if (Email!=NULL && Email!='')
	            query = query + ' and Email like \'%' + Email+'%\'';
	        if (Interest!=NULL && Interest!='')
	            query = query + ' and Interest__c like \'' + Interest+'\'';
	        if (LeadType!=NULL && LeadType!='')
	            query = query + ' and LeadType__c like \'' + LeadType+'\'';
	        if (LeadSource!=NULL && LeadSource!='')
	            query = query + ' and LeadSource like \'' + LeadSource+'\'';
	        if (RegNumber!=NULL && RegNumber!='')
	            query = query + ' and Reg_Number__c like \'%' + RegNumber+'%\'';
	        if (Competitor==true)
	            query = query + ' and Competitor__c =' + Competitor;
			if( dummyCont.Nana_Create_Date__c != null && dummyCont.Nana_Edit_Date__c != null)
			{           	//dummyCont.Nana_Create_Date__c -> dummyCont.Nana_Edit_Date__c // hackadelic to get a rane of date
				DateTime d1 = (DateTime)dummyCont.Nana_Create_Date__c;
				DateTime d2 = (DateTime)dummyCont.Nana_Edit_Date__c;

				query += ' AND CreatedDate > '+d1.format('yyyy-MM-dd')+'T00:00:00Z  AND CreatedDate < '+d2.format('yyyy-MM-dd')+'T00:00:00Z   ';
				
			}
			if( dummyCont.Source_Date__c != null  )
			{
				Date d1 = (Date)dummyCont.Source_Date__c;
				DateTime d2 = datetime.newInstance( d1.year(), d1.month(), d1.day() );
//		        ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, ' AND Source_Date__c = '+d2.format('yyyy-MM-dd')+'  ' ));
				
				query += ' AND Source_Date__c = '+d2.format('yyyy-MM-dd')+'  ';
			}
			if( selectedTerritory != null && selectedTerritory != '')
			{
				
				string uidList = '';
				for( Id i : uidToTerrLookup.keySet() )
				{
system.debug( uidToTerrLookup.get(i));				
					if( uidToTerrLookup.get(i) == selectedTerritory )
					{
						uidList += '\'' +i + '\',';
					}
				}
				uidList = uidList.substring(0,uidList.length()-1);
				query += ' AND OwnerID IN ('+uidList+') ';
			}
			
//	        query = query + sortexp + ' limit 2000';
            if( !whereonly )
		        query = query + sortexp + ' limit 2000';
//		}
        return query;
    }
    
    public string Total
    {
        get{return Total;}
        set{Total=value;}
    }
    public void doSort(){
        String order = 'asc';
        
        /*This checks to see if the same header was click two times in a row, if so 
        it switches the order.*/
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
        sortexp=' order by ' + sortfield + ' ' + order ;
        //Apexpages.addMessage( new ApexPages.message( apexpages.Severity.ERROR,sortexp) );

        myaction();
    }

	public PageReference reset() {
	
//		return new PageReference('/apex/ContactHome');
	
		State = '';
		Country = '';
		FirstName = '';
		LastName = '';
		Address = '';
		Address2 = '';
		AccountName = '';
		City = '';
		Zip = '';
		Phone = '';
		PhoneExt = '';
		Email = '';
		Interest = '';
		LeadType = '';
		LeadSource = '';
		RegNumber = '';
		dummyCont = new Contact();
	                  List<Contact> dummylist = new List<Contact>();
         mycontroller=
             new ApexPages.StandardSetController(dummylist);
	
//		mycontroller = null;
return null;
	}

    public void myaction()
    {
      
        mycontroller=null;
    }
             
    public List<Contact> getmyContacts() {
         return (List<Contact>) mycontroller.getRecords();
    }
    
    public List<SelectOption> getStates() {
        return Utility.StateOptions();
    }
    
    public List<SelectOption> getCountries() {
       List<SelectOption> options = new List<SelectOption>();

		Schema.DescribeFieldResult f = Schema.sObjectType.Contact.fields.Country__c;
		
//		options.add(new Selectoption('','- select -') );
		for( Schema.Picklistentry entry : f.getPicklistValues( ))
		{
			options.add( new Selectoption(entry.getvalue(), entry.getlabel() ));
		}

    	
    	return options;	
    	
//        return Utility.CountryOptions();
    }
    
    public List<SelectOption> getLeadTypes()
    {
    	return Utility.LeadTypeOptions();
    }
    
        public List<SelectOption> getLeadInterests()
    {
    	return Utility.LeadInterestOptions();
    }

        public List<SelectOption> getLeadSources()
    {
    	return Utility.LeadSourceOptions();
    }
     
    public PageReference gotonew()
    {
        Schema.Describesobjectresult result = Schema.Sobjecttype.Contact;
        ApexPages.Pagereference ref = new PageReference('/' + result.getKeyPrefix() + '/e');
        ref.setredirect(true);
        return ref;
    }
    
      
    public void previous()
    {
        mycontroller.previous();
    }
    
    public void next()
    {
        mycontroller.next();
    }
     
    public boolean hasprevious
    {
        get{
        return mycontroller.gethasprevious();}
        set;
    }
    
    public boolean hasnext 
    {
        get{
        return mycontroller.gethasnext();
        }
        set;
    }
}