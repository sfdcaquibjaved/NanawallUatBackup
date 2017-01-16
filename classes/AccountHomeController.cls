public with sharing class AccountHomeController
 { 
     
    public AccountHomeController(){
        //    Apexpages.addMessage( new ApexPages.message( apexpages.Severity.ERROR,'constructor') );
         sortexp=' order by name asc';
         previoussortfield='name';
         country='united states';
         List<Account> dummylist = new List<Account>();
         mycontroller=
             new ApexPages.StandardSetController(dummylist);
    }
    public PageReference primeSearch() {
    
		Database.query('SELECT id, name  FROM Account LIMIT 2000 ');
	    return null;
    }
    
    
    Account dummyAccount = new Account();
    public Account getDummyAccount() { return dummyAccount; }
    public void setDummyAccount( Account a ) { dummyAccount = a; }
	public PageReference reset() {
	
	    State = '';

		Country = '';
 		Name= '';
 		Address = '';
 		City = '';
 		Zip = '';
 		Phone = '';
 		Email = '';

		dummyAccount = new Account();
      List<Account> dummylist = new List<Account>();
      
         mycontroller=
             new ApexPages.StandardSetController(dummylist);
	
//		mycontroller = null;
return null;
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
    
        public string Name
    {
        get
        {
            return Name;
        }
        set
        {
            Name=value;
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
    
    
    
    public ApexPages.StandardSetController mycontroller
    {
        get
        {
            if (mycontroller==NULL){
            	
            	if(dummyAccount.Description !=NULL && dummyAccount.Description!='')
            	{
            		string whereQuery = GetQuery(true);

//					List<List<SObject>> searchList =  [FIND :dummyAccount.Description IN ALL FIELDS  RETURNING Account (  id, name,address_1__c,state__c,zip__c,country__c,city__c )  ];
					List<List<SObject>> searchList =  search.query( 'FIND \''+dummyAccount.Description+'\' IN ALL FIELDS  RETURNING Account (  id, name,address_1__c,state__c,zip__c,country__c,city__c '+whereQuery+' )  ');
//Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO, 'FIND \''+dummyAccount.Description+'\' IN ALL FIELDS  RETURNING Account (  id, name,address_1__c,state__c,zip__c,country__c,city__c '+whereQuery+' )  ') );
	            	mycontroller = new ApexPages.StandardSetController( (list<account>)searchList[0]  );
            	} else mycontroller=  new ApexPages.StandardSetController(Database.getQueryLocator(GetQuery(false)));
            	
            	
            
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
        
    public string GetQuery(boolean whereonly )
    {
    	string query = '';
	    	
	    	if( !whereonly )
		         query = 'select name,address_1__c,state__c,zip__c,country__c,city__c from account where id!=\'\' ';
         	else query = ' WHERE id != \'\' ';
	        if (State != NULL && State !='')
	            query = query + ' and state__c = \'' + State +'\'';
	        if (Country!=NULL && Country!='')
	            query = query + ' and country__c = \'' + Country+'\'';    
	        if (Name !=NULL && Name!='')
	            query = query + ' and name like \'%' + Name+'%\'';    
	        if (Address!=NULL && Address!='')
	            query = query + ' and address_1__c like \'%' + Address+'%\''; 
	        if (City!=NULL && City!='')
	            query = query + ' and city__c like \'%' + City+'%\''; 
	        if (Zip!=NULL && Zip!='')
	            query = query + ' and Zip__c like \'%' + Zip + '%\''; 
	        if (Phone!=NULL && Phone!='')
	            query = query + ' and phone like \'%' + Phone+'%\''; 
	        if (Email!=NULL && Email!='')
	            query = query + ' and company_email__c like \'%' + Email+'%\''; 
            if( dummyAccount.Type != NULL && dummyAccount.Type != '' )
            	query = query + ' AND Type = \''+dummyAccount.Type+'\' ';

            if( !whereonly )
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
             
    public List<Account> getmyAccounts() {
         return (List<Account>) mycontroller.getRecords();
    }
    
    public List<SelectOption> getStates() {
        return Utility.StateOptions();
    }
    
    public List<SelectOption> getCountries() {
        return Utility.CountryOptions();
    }
    
 
    
    public PageReference gotonew()
    {
        Schema.Describesobjectresult result = Schema.Sobjecttype.Account;
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