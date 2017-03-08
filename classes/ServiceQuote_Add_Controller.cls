public with sharing class ServiceQuote_Add_Controller {
		public Service_Quote__c getServiceQuote() { return thisServiceQuote; }
	public void setServiceQuote( Service_Quote__c c) { thisServiceQuote = c; }
	
	boolean val=false;
	string uaddress='';
	private  Service_Quote__c thisServiceQuote;

	private boolean initd = false;
	public ServiceQuote_Add_Controller(ApexPages.StandardController controller) {
		thisServiceQuote = (Service_Quote__c)controller.getrecord();
		case ca =[ select id,quote__c, quote__r.discount__c from case where id =: thisServiceQuote.case__c];
		thisServiceQuote.Quote__c = ca.quote__c;
		
		if( !initd )
		{
			if(ca.Quote__r.Discount__c > 0 )
			{
				thisServiceQuote.Discount__c = ca.Quote__r.Discount__c;
			}
			initd = true;
		}
    }
    
    public pagereference cancel(){ return new PageReference('/'+thisServiceQuote.Case__c); }
    
    public string getTestVal()
    {
    		return uaddress;
    }
    
    public PageReference setaddress()
    {
    	if (uaddress=='Order')
    	{
    		Quote__c q = [select id,address__c,city__c,state__c,zip__c,country__c from quote__C where id =: thisservicequote.quote__c];
    		thisserviceQuote.Ship_To_Address__c = q.address__c;	
    		thisserviceQuote.Ship_To_City__c = q.City__c;
    		thisserviceQuote.Ship_To_State__c = q.state__c;
    		thisserviceQuote.Ship_To_Zip__c = q.Zip__c;
    		thisServiceQuote.Ship_To_Country__c = q.Country__c;
    		thisserviceQuote.Ship_To_Phone__c = '';
    		thisserviceQuote.Ship_To_Fax__c = '';
    		thisserviceQuote.Ship_To_Email__c = '';	
    		thisserviceQuote.Ship_To_Company_Name__c ='';
    	}
    	else if (uaddress!='-SELECT-')
    	{
    		contact c = [select id,address_1__c,Address_2__c,City__c,state_abbr__C,State__c,Zip__c,Country__c,Phone,Fax,Email,account.name from contact where id =:uaddress];
    		thisserviceQuote.Ship_To_Address__c = c.address_1__c;
    		thisserviceQuote.Ship_To_Address_2__c = c.Address_2__c;
    		thisserviceQuote.Ship_To_City__c = c.City__c;
    		thisserviceQuote.Ship_To_State__c = c.state__C;
    		thisserviceQuote.Ship_To_Zip__c = c.Zip__c;
    		thisServiceQuote.Ship_To_Country__c = c.Country__c;
    		thisserviceQuote.Ship_To_Phone__c = c.Phone;
    		thisserviceQuote.Ship_To_Fax__c = c.Fax;
    		thisserviceQuote.Ship_To_Email__c = c.Email;	
    		thisserviceQuote.Ship_To_Company_Name__c =c.account.name;
    		thisservicequote.ship_to_lead__c = uaddress;
    	}
    	else
    	{
    		thisserviceQuote.Ship_To_Address__c='';
    	}
    	
    	
    	return null;
    }
    
    public String getUseAddress()
    {
    	return uaddress;
    }
    
    public void setUseAddress(String s)
    {
    	uaddress=s;
    }
    
    
        public List<SelectOption> getContacts()
    {
    	List<SelectOption> options = new List<SelectOption>();
    	case ca =[ select id,quote__c from case where id =: thisServiceQuote.case__c];
    	quote__c a = [select id,opportunity__c from quote__c where id =:ca.quote__c limit 1];
    	id oppid = a.opportunity__c;
    	for (nrOpportunityContactRole__c c : [ select id, contact__r.id,contact__r.name from nrOpportunityContactRole__c where opportunity__c =:oppid])
    	{
    		if( c.contact__r != null)
    		{
	    		SelectOption so = new SelectOption(c.contact__r.id,c.contact__r.name);
	    		options.add(so);
    		}
    	}
    	return options;
    }
    

    
}