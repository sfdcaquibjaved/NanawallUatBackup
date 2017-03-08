public with sharing class OpportunityHomeController
 { 
 	public boolean getOfficeUser()
	{
		return userinfo.getProfileID() != '00eA0000000Qn2VIAS' && userinfo.getProfileID() != '00eA0000000RgW3IAK';
	}
	
	public String[] models { 
		get; 
		set; 
		}
	private set<string> excludedModels = new set<String>{ 'hsw 50', 'hsw 55', 'sl 35l', 'sl 35us', 'sl 45us', 'sl 50', 'sl 50l', 'sl 50us', 'sl 68l', 'sl 72', 'sl 72l', 'sl 78f', 'sl 78l', 'sl 78tt', 'vsw 50', 'wd 75' };

public string getOldModelsChecked() {
		if( ( Apexpages.currentPage().getParameters().get('useOldModels') != null ) ) return ' checked="checked" ';
		else return '';

}
	public string getOldModelsToggleValue() {
		if( ( Apexpages.currentPage().getParameters().get('useOldModels') != null ) ) return '';
		else return 'useOldModels=true';
	}

	public List<SelectOption> getModelOptions() {
		
        List<SelectOption> options = new List<SelectOption>();

//        options.add(new SelectOption('US','US'));

		Schema.DescribeFieldResult f = Schema.sObjectType.Opportunity.fields.Models__c;
		boolean useOldModels = ( Apexpages.currentPage().getParameters().get('useOldModels') != null );
// Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO,( useOldModels ? 'set' : 'not set' ) ) );
		
		for( Schema.Picklistentry entry : f.getPicklistValues( ))
		{
			if( !useOldModels && this.excludedModels.contains(entry.getValue().toLowerCase() ) ) continue;
			
			options.add( new Selectoption(entry.getvalue(), entry.getlabel() ));
		}


        return options;	
	}
	
          
     static map<id,string> uidToTerrLookup = new map<id,string>();
     
     public string selectedTerritory = '';
     public string getSelectedTerritory() { return selectedTerritory; }
     public void setSelectedTerritory( string terr ) { selectedTerritory = terr; }
	 public List<SelectOption> getTerritories() {
		List<SelectOption> options = new List<SelectOption>();
	/*
		set<string> terrs = new set<string>();
		for( User u : [SELECT id, UserRoleName__c FROM User] )
		{
		if( u.UserRoleName__c == null ) continue;

			list<string> parts = u.UserRoleName__c.split('\\s+');			
			string terr = ( parts.size() > 0 ? parts.get(0) : 'missing'  );
		
			if(terr == 'West' || terr.contains('Admin') 
			|| terr.contains('Marketing') || terr == 'National'
			|| terr == 'Office' || terr == 'Executives' 
			|| terr == 'Midwest' ) continue;

			terrs.add(terr);
			uidToTerrLookup.put( u.id, terr);
			
		}
		list<string> sortedTerrs = new List<string>();
		sortedTerrs.addAll(terrs);
		sortedTerrs.sort();
		for( string t : sortedTerrs )
		{
			options.add( new SelectOption( t, t ) );
		
		}
		*/
		options.add(new SelectOption('AZ-NVsouth','AZ-NVsouth'));
		options.add(new SelectOption('CanadaON','CanadaON'));
		options.add(new SelectOption('CanadaBC','CanadaBC'));
		options.add(new SelectOption('Can-MidWest','Can-MidWest'));
		options.add(new SelectOption('CAnorth-NVnorth','CAnorth-NVnorth'));
		options.add(new SelectOption('CanadaQC','CanadaQC'));
		options.add(new SelectOption('CAsouth','CAsouth'));
		options.add(new SelectOption('CO-WY-NM-MTeast','CO-WY-NM-MTeast'));
		options.add(new SelectOption('FL-AL-TN','FL-AL-TN'));
		options.add(new SelectOption('FL-Car','FL-Car'));
		options.add(new SelectOption('FLsouth-ne','FLsouth-ne'));
		options.add(new SelectOption('FLwest-nw','FLwest-nw'));
		options.add(new SelectOption('GA','GA'));
		options.add(new SelectOption('IL-WI','IL-WI'));
		options.add(new SelectOption('KY-OH-PA','KY-OH-PA'));
		options.add(new SelectOption('MX','MX'));
		options.add(new SelectOption('MI','MI'));
		options.add(new SelectOption('MN-WIwest-ND-SD','MN-WIwest-ND-SD'));
		options.add(new SelectOption('MO-KS-IL-IA-NE','MO-KS-IL-IA-NE'));
		options.add(new SelectOption('NAEastern','NAEastern'));
		options.add(new SelectOption('NC-SC','NC-SC'));
		options.add(new SelectOption('NJ-PNeast','NJ-PNeast'));
		options.add(new SelectOption('NorthWest-HI','NorthWest-HI'));
		options.add(new SelectOption('NY-NJ','NY-NJ'));
		options.add(new SelectOption('OH-MI-IN','OH-MI-IN'));
		options.add(new SelectOption('OK-TX','OK-TX'));
		options.add(new SelectOption('RI-ME-CO-MA-NH-VE','RI-ME-CO-MA-NH-VE'));
		options.add(new SelectOption('TN-MS-AR','TN-MS-AR'));
		options.add(new SelectOption('TX-LA-MA-AL','TX-LA-MA-AL'));
		options.add(new SelectOption('UT','UT'));
		options.add(new SelectOption('VA-MD-DE-WV-DC','VA-MD-DE-WV-DC'));
		
		return options; 
	}     
     
     private boolean initd = false;
    public OpportunityHomeController(){
        //    Apexpages.addMessage( new ApexPages.message( apexpages.Severity.ERROR,'constructor') );
         sortexp=' order by name asc';
         previoussortfield='name';
         country='united states';
         List<Opportunity> dummylist = new List<Opportunity>();
         mycontroller=
             new ApexPages.StandardSetController(dummylist);
             
             if( !initd )
             {
             	if( dummyopp2 == null ) dummyopp2 = new Opportunity();
				dummyopp2.CloseDate = null;
             	initd = true;
             }
    }
    
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    public String sortexp{get;set;}

	public PageReference reset() {
	
		State = '';
		Country = '';
		Name = '';
		Address = '';
		City = '';
		Zip = '';
		Stage = '';
		Application = '';
		ChainAccount = false;
		Ordered = false;
		AmountLow = '';
		AmountHigh = '';

		dummyOpp = new Opportunity();
      List<Opportunity> dummylist = new List<Opportunity>();
      
         mycontroller=
             new ApexPages.StandardSetController(dummylist);
	
//		mycontroller = null;
return null;
	}
	
	public Opportunity dummyOpp2 { get; set; }
	
	private Opportunity dummyOpp = new Opportunity();
	public Opportunity getDummyOpportunity() {  return dummyOpp; }
	public void setDummyOpportunity( Opportunity o ) { dummyOpp = o; } 

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
    
        public string Stage
        {
        get 
        {
            return Stage;
        }
        set
        {
            Stage=value;
        }
    } 
    
            public string Application
        {
        get 
        {
            return Application;
        }
        set
        {
            Application=value;
        }
    } 
    
                public string AmountLow
        {
        get 
        {
            return AmountLow;
        }
        set
        {
            AmountLow=value;
        }
    }
    
    public string AmountHigh
        {
        get 
        {
            return AmountHigh;
        }
        set
        {
            AmountHigh=value;
        }
    }
    
    public boolean ChainAccount
            {
        get 
        {
            return ChainAccount;
        }
        set
        {
            ChainAccount=value;
        }
    } 
    
        public boolean Ordered
            {
        get 
        {
            return Ordered;
        }
        set
        {
            Ordered=value;
        }
    } 
    
    public ApexPages.StandardSetController mycontroller
    {
    	
        get
        {
        	
            if (mycontroller==NULL){
	//            mycontroller= new ApexPages.StandardSetController(Database.getQueryLocator(GetQuery()));
            	if(dummyOpp.Description !=NULL && dummyOpp.Description!='')
            	{
            		string whereQuery = GetQuery(true);

//					List<List<SObject>> searchList =  [FIND :dummyAccount.Description IN ALL FIELDS  RETURNING Account (  id, name,address_1__c,state__c,zip__c,country__c,city__c )  ];
					List<List<SObject>> searchList =  search.query( 'FIND \''+dummyOpp.Description+'\' IN ALL FIELDS  RETURNING Opportunity (  id,  name,site_address__c,state__c,postal_code__c,country__c,city__c,models__c '+whereQuery+' )  ');
//Apexpages.addMessage( new ApexPages.message( apexpages.Severity.INFO, 'FIND \''+dummyAccount.Description+'\' IN ALL FIELDS  RETURNING Account (  id, name,address_1__c,state__c,zip__c,country__c,city__c '+whereQuery+' )  ') );
	            	mycontroller = new ApexPages.StandardSetController( (list<Opportunity>)searchList[0]  );
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

    public PageReference primeSearch() {
    
		Database.query('SELECT id, name  FROM Opportunity LIMIT 2000 ');
	    return null;
    }
        
    public static List<Opportunity> GetSearchResults( string State, string Country, string Name, string AltName, string Address, string City,string Zip, string Stage, string Application, boolean ChainAccount,boolean Ordered,string  AmountLow,string  AmountHigh, list<string> models,string  ReviewCode,boolean  NIS,date  CreatedDateLow,date  CreatedDateHigh,date  CloseDateLow,date  CloseDateHigh,string  SelectedTerritory, string sortexp, boolean ResidentialVertical ) {
    	
    	//this method is used for other code that wants to call the project search code
    	return (List<Opportunity>)Database.query( buildSOQLQuery(false, State, Country, Name, AltName, Address, City, Zip, Stage, Application, ChainAccount, Ordered, AmountLow, AmountHigh, models, ReviewCode, NIS, CreatedDateLow, CreatedDateHigh, CloseDateLow, CloseDateHigh, SelectedTerritory, sortexp, ResidentialVertical) );
    }
        
	        
    public string GetQuery(boolean whereOnly )
    {
    
    	return buildSOQLQuery(whereOnly, State, Country, Name, dummyOpp.Name, Address, City, Zip, Stage, Application, ChainAccount,Ordered, AmountLow, 
    		AmountHigh, models, dummyOpp.Review_Code__c, dummyOpp.NIS__c, dummyOpp.Nana_Create_Date__c, dummyOpp.Nana_Edit_Date__c,
    		dummyOpp.CloseDate, dummyOpp2.CloseDate, selectedTerritory, sortexp, dummyOpp.Residential_Vertical__c );
    }
    public static string buildSOQLQuery(boolean whereOnly, string State, string Country, string Name, string AltName, 
    	string Address, string City, string Zip, string Stage, string Application, boolean ChainAccount, boolean Ordered,
    	string AmountLow, string AmountHigh, list<string> models, string ReviewCode, boolean NIS, date CreatedDateLow, date CreatedDateHigh,
    	date CloseDateLow, date CloseDateHigh, string SelectedTerritory, string sortexp, boolean ResidentialVertical  ) {

    			
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
    	if( !whereonly )
	         query = 'select name,site_address__c,state__c,postal_code__c,country__c,city__c, models__c, IsWon, Max_Email_Date__c, CreatedDate from Opportunity where id!=\'\'  ';
     	else query = ' WHERE id != \'\' ';
        
        if (State != NULL && State !='')
            query = query + ' and state__c = \'' + State +'\'';
        if (Country!=NULL && Country!='')
            query = query + ' and country__c = \'' + Country+'\'';    
        
        string nameQuery = '';
        string addlNameQuery = '';    
        if (Name !=NULL && Name!='')
        {
            nameQuery = '  name like \'%' + String.escapeSingleQuotes( Name ) +'%\'';    
        }
        if( AltName != NULL && AltName != '' )
        {
        	addlNameQuery = ' name like \'%'+String.escapeSingleQuotes( AltName )+'%\' ';
        }

		if( nameQuery != '' && addlNameQuery != '' )
			query += ' and ( '+nameQuery+' AND '+addlNameQuery+' ) ';        
		else if( nameQuery != '' )
			query += ' and ' + nameQuery;
		else if( addlNameQuery != '' )
			query += ' and ' + addlNameQuery;
			
        if (Address!=NULL && Address!='')
            query = query + ' and site_address__c like \'%' + Address+'%\''; 
        if (City!=NULL && City!='')
            query = query + ' and city__c like \'%' + City+'%\''; 
        if (Zip!=NULL && Zip!='')
            query = query + ' and postal_code__c like \'%' + Zip + '%\''; 
        if (Stage!=NULL && Stage!='')
            query = query + ' and StageName  = \'' + Stage + '\'';
        if (Application!=NULL && Application!='')
            query = query + ' and Application__c = \'' + Application + '\'';
        if ( ChainAccount != NULL && ChainAccount )
            query = query + ' and Chain_Account__c = ' + ChainAccount ;
        if ( Ordered != null && Ordered )
            query = query + ' and Order_Amount__c > 0 ';
        if (AmountLow!=NULL && AmountLow!='')
            query = query + ' and Amount >= ' + AmountLow;
		if (AmountHigh!=NULL && AmountHigh!='')
            query = query + ' and Amount <= ' + AmountHigh;



		if( models != null && models.size() > 0)
		{
//models

			string modelQuery = '';

			for( string s : models )
			{
				if( modelQuery != '' )
					modelQuery += ', ';
				modelQuery += '\'' + s+ '\'';
			
			}
			query = query += ' AND Models__c includes ('+modelQuery+')  ';
		
		}           


		if( ReviewCode != null && ReviewCode != '' )
			query += ' AND Review_code__c =  \''+ReviewCode+'\' ';
		if( NIS )
			query += ' AND NIS__c = true  ';
		if( ResidentialVertical )
			query += ' AND Residential_Vertical__c = true ';

		if( CreatedDateLow != null && CreatedDateHigh != null)
		{           	//dummyOpp.Nana_Create_Date__c -> dummyOpp.Nana_Edit_Date__c // hackadelic to get a rane of date
			DateTime d1 = (DateTime)CreatedDateLow;
			DateTime d2 = (DateTime)CreatedDateHigh;

			query += ' AND CreatedDate > '+d1.format('yyyy-MM-dd')+'T00:00:00Z  AND CreatedDate < '+d2.format('yyyy-MM-dd')+'T00:00:00Z   ';
		}

		if( CloseDateLow != null && CloseDateHigh != null)
		{           	
			DateTime d1 = (Date)CloseDateLow;
			DateTime d2 = (Date)CloseDateHigh;

			query += ' AND CloseDate > '+d1.format('yyyy-MM-dd')+'  AND CloseDate < '+d2.format('yyyy-MM-dd')+'    ';
		}


		if( SelectedTerritory != null && SelectedTerritory != '')
		{
			string uidList = '';
			for( Id i : uidToTerrLookup.keySet() )
			{
				if( uidToTerrLookup.get(i) == SelectedTerritory )
				{
					uidList += '\'' +i + '\',';
				}
			}
			uidList = uidList.substring(0,uidList.length()-1);
			query += ' AND OwnerID IN ('+uidList+') ';
		}

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
             
    public List<Opportunity> getmyOpportunitys() {
         return (List<Opportunity>) mycontroller.getRecords();
    }
    
    public List<SelectOption> getStates() {
        return Utility.StateOptions();
    }
    
        public List<SelectOption> getStages() {
        return Utility.StageOptions();
    }
    
    public List<SelectOption> getCountries() {
        return Utility.CountryOptions();
    }
    
    public List<SelectOption> getApplications() {

//        return Utility.ApplicationOptions();


//Account.Foobar__c.getDescribe().getPickListValues();
		List<SelectOption> options = new List<SelectOption>();
		        
		Schema.DescribeFieldResult fieldResult = Opportunity.Application__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		        
		for( Schema.PicklistEntry f : ple)
		{
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}       
		
//		options.add(new SelectOption('Commercial (retail, storefront, office)', 'Commercial (retail, storefront, office)'));
		
		return options;
		
    }

      
    public PageReference gotonew() 
    {
        Schema.Describesobjectresult result = Schema.Sobjecttype.Opportunity;
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