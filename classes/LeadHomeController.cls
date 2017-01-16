public with sharing class LeadHomeController
 { 
     
    public LeadHomeController(){
        //    Apexpages.addMessage( new ApexPages.message( apexpages.Severity.ERROR,'constructor') );
         sortexp=' order by name asc';
         previoussortfield='name';
         country='united states';
                           List<Lead> dummylist = new List<Lead>();
         mycontroller=
             new ApexPages.StandardSetController(dummylist);
    }
    
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    public String sortexp{get;set;}

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
    
        public string Company
        {
        get 
        {
            return Company;
        }
        set
        {
            Company=value;
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
    
    
    
    public ApexPages.StandardSetController mycontroller
    {
        get
        {
            if (mycontroller==NULL){
            mycontroller=
             new ApexPages.StandardSetController(Database.getQueryLocator(GetQuery()));
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
        
    public string GetQuery()
    {
        string query = 'select name,address_1__c,nrstate__c,zip__c,nrcountry__c,' +
        ' nrcity__c,company from Lead where converteddate=null ';
        if (State != NULL && State !='')
            query = query + ' and nrstate__c = \'' + State +'\'';
        if (Country!=NULL && Country!='')
            query = query + ' and nrcountry__c = \'' + Country+'\'';    
        if (FirstName !=NULL && FirstName!='')
            query = query + ' and FirstName like \'%' + FirstName+'%\'';
        if (LastName !=NULL && LastName!='')
            query = query + ' and LastName like \'%' + LastName+'%\'';    
        if (Address!=NULL && Address!='')
            query = query + ' and address_1__c like \'%' + Address+'%\''; 
        if (Company!=NULL && Company!='')
            query = query + ' and Company like \'%' + Company+'%\''; 
        if (City!=NULL && City!='')
            query = query + ' and nrcity__c like \'%' + City+'%\''; 
        if (Zip!=NULL && Zip!='')
            query = query + ' and Zip__c like \'%' + Zip + '%\''; 
        if (Phone!=NULL && Phone!='')
            query = query + ' and phone like \'%' + Phone+'%\''; 
        if (Email!=NULL && Email!='')
            query = query + ' and Email like \'%' + Email+'%\'';
        if (Interest!=NULL && Interest!='')
            query = query + ' and Interest__c like \'' + Interest+'\'';
        if (LeadType!=NULL && LeadType!='')
            query = query + ' and Type__c like \'' + LeadType+'\'';
        if (LeadSource!=NULL && LeadSource!='')
            query = query + ' and LeadSource like \'' + LeadSource+'\'';
        if (RegNumber!=NULL && RegNumber!='')
            query = query + ' and Reg_Number__c like \'%' + RegNumber+'%\'';

        query = query + sortexp + ' limit 2000';
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

    public void myaction()
    {
      
        mycontroller=null;
    }
             
    public List<Lead> getmyLeads() {
         return (List<Lead>) mycontroller.getRecords();
    }
    
    public List<SelectOption> getStates() {
        return Utility.StateOptions();
    }
    
    public List<SelectOption> getCountries() {
       List<SelectOption> options = new List<SelectOption>();

		Schema.DescribeFieldResult f = Schema.sObjectType.Lead.fields.nrCountry__c;
		
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
        Schema.Describesobjectresult result = Schema.Sobjecttype.Lead;
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