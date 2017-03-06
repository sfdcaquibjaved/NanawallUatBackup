public with sharing class QuoteHomeController
 { 
     
    public QuoteHomeController(){
        //    Apexpages.addMessage( new ApexPages.message( apexpages.Severity.ERROR,'constructor') );
         sortexp=' order by name asc';
         previoussortfield='name';
         country='united states';
                  List<Quote__c> dummylist = new List<Quote__c>();
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
    
    public string OrderNumber
    {
    	get
    	{
    		return OrderNumber;
    	}
    	set
    	{
    		OrderNumber=value;
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
        
    public string GetQuery()
    {
        string query = 'select name,address__c,state__c,zip__c,country__c,city__c,order_number__c from Quote__c where id!=\'\' ';
        if( State != null)
	        State = State.replace(',','');
        if( Country != null )
	        Country = Country.replace(',','');
        if(Name != null)
        	Name = Name.replace(',','');
        if(Address != null )
        	Address = Address.replace(',','');
        if( City != null)
        	City = City.replace(',','');
        if( Zip != null)
        	Zip = Zip.replace(',','');
        if( OrderNumber != null )
        	OrderNumber = OrderNumber.replace(',','');
        
        if (State != NULL && State !='')
            query = query + ' and state__c = \'' + State +'\'';
        if (Country!=NULL && Country!='')
            query = query + ' and country__c = \'' + Country+'\'';    
        if (Name !=NULL && Name!='')
            query = query + ' and name like \'%' + Name+'%\'';    
        if (Address!=NULL && Address!='')
            query = query + ' and address__c like \'%' + Address+'%\''; 
        if (City!=NULL && City!='')
            query = query + ' and city__c like \'%' + City+'%\''; 
        if (Zip!=NULL && Zip!='')
            query = query + ' and Zip__c like \'%' + Zip + '%\'';
        if (OrderNumber!=NULL && OrderNumber!='')
            query = query + ' and Order_Number__c = ' + OrderNumber; 
        query = query + sortexp + ' limit 2000';

//Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO,query) );

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
             
    public List<Quote__c> getmyQuotes() {
         return (List<Quote__c>) mycontroller.getRecords();
    }
    
    public List<SelectOption> getStates() {
        return Utility.StateOptions();
    }
    
    public List<SelectOption> getCountries() {
        return Utility.CountryOptions();
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