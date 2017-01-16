public with sharing class ProjectMapController {
 
     public string selectedTerritory = '';
     public string getSelectedTerritory() { return selectedTerritory; }
     public void setSelectedTerritory( string terr ) { selectedTerritory = terr; }
	 public List<SelectOption> getTerritories() {
		List<SelectOption> options = new List<SelectOption>();
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
 public ProjectMapController(ApexPages.StandardController controller)
 {
 	
 	if( !initd )
 	{
 		dummyOpportunity = new Opportunity();
 		dummyOpportunity2 = new Opportunity();
	 	generateArray();
	 	projectname = '';
 		initd = true;
 	}
 	 
 }
 
 
 	public Opportunity dummyOpportunity { get; set; }
 	public Opportunity dummyOpportunity2 { get; set; }
 
 private string center = '';
 public string getCenter()
 {
 	try
 	{
	 	Opportunity opp = Database.query(getSoqlQuery( ) + 'limit 1');
	 	return opp.lat__c + ','+opp.lng__c; 
 	} catch(Exception ex ) 
 	{
 		return ''; //this is an icky way to do this jim; when you come up with 0 results, you get an exception
 	}
 }
 
	public string projectname { get; set; }
 
 
	public string arraydata = '';
 
	public string getArray()
	{
		return arraydata;
	}
    
	
    
    string soqlQuery = null;
    private string getSoqlQuery() 
    {
//    	if( soqlquery == null )
    	{
    		soqlQuery = '';
    		map<id,string> uidToTerrLookup = new map<id,string>();
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
			
	    	
	    	soqlQuery = 'SELECT name,lat__c,lng__c,max_email_date__c,max_finalized_date__c FROM opportunity WHERE Id != null and lat__c > 0 ';
	    	
			if( projectname != null && projectname != '' )
			{
				soqlQuery += ' AND name like \'%'+projectname+'%\' ';
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
				soqlQuery += ' AND OwnerID IN ('+uidList+') ';
			}
			
			if( dummyOpportunity.Nana_Create_Date__c != null && dummyOpportunity2.Nana_Create_Date__c != null)
			{           	//dummyOpp.Nana_Create_Date__c -> dummyOpp.Nana_Edit_Date__c // hackadelic to get a rane of date
				DateTime d1 = dummyOpportunity.Nana_Create_Date__c;
				DateTime d2 = dummyOpportunity2.Nana_Create_Date__c;
	
				soqlQuery += ' AND CreatedDate > '+d1.format('yyyy-MM-dd')+'T00:00:00Z  AND CreatedDate < '+d2.format('yyyy-MM-dd')+'T00:00:00Z   ';
			}
			else if(dummyOpportunity.Nana_Create_Date__c != null)
			{
				DateTime d1 = dummyOpportunity.Nana_Create_Date__c;
				soqlQuery += ' AND CreatedDate > '+d1.format('yyyy-MM-dd')+'T00:00:00Z';
			}
			
			if( dummyOpportunity.CloseDate != null && dummyOpportunity2.CloseDate != null)
			{           	//dummyOpp.Nana_Create_Date__c -> dummyOpp.Nana_Edit_Date__c // hackadelic to get a rane of date
				DateTime d1 = dummyOpportunity.CloseDate;
				DateTime d2 = dummyOpportunity2.CloseDate;
	
				soqlQuery += ' AND CloseDate > '+d1.format('yyyy-MM-dd')+'  AND CloseDate < '+d2.format('yyyy-MM-dd')+'   ';
			}
			else if(dummyOpportunity.CloseDate != null)
			{
				DateTime d1 = dummyOpportunity.CloseDate;
				soqlQuery += ' AND CloseDate > '+d1.format('yyyy-MM-dd');
			}
			
			
//dummyOpportunity.CloseDate	
//dummyOpportunity2.closedate
			

//ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Info, soqlQuery ) );	    
    	}
    	
    	return soqlQuery;
    }
    
	public void generateArray() 
    {
    	
        arraydata ='';
        center = '';
        integer projcount = 0;
        for( Opportunity ocr : Database.query( getSoqlQuery( ) + ' limit 500') )  
        {

        	string color='';
        	if (ocr.Max_Finalized_Date__c != null)
        		color='r';
        	else if(ocr.Max_Email_Date__c != null)
        		color='y';
        	else
        		color='g';
        	
      		arraydata  = arraydata + '["'+ocr.name+'",'+ocr.lat__c+','+ocr.lng__c+',"'+color+'"],';
      		projcount++;
        }    
        
        if (arraydata.length() > 0)
        {
        	arraydata = arraydata.substring(0,arraydata.length()-1);
        }
        
ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.Info, 'Found ' + projcount + ' projects.' ) );	    
        
//        return ret;
    }
    
	public pagereference refreshdata() 
	{
	
		generateArray();
		
		return null;
	}
    
}