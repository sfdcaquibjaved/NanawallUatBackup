public with sharing class StockOrder_ReportController {
	
	//purchase order specific methods
	public string ResponsibleRep {
		get {
			return  this.so.Responsible_Rep__c;
		}
	}
	
	public string ResponsibleRepInitials {
		get {
			if( this.so.Responsible_Rep__c == null ) return '';


			string[] names = this.so.Responsible_Rep__c.split(' ');			

					
			string initials = '';
			
			try {
				initials = names[0].substring(0,1) + ' ' + names[1].substring(0,1);
			} catch( Exception ex ) 
			{
			}

			return initials;
		}
	}
	
	public string PO_Shipmethod{
		get {
			return ApexPages.currentPage().getParameters().get('ShippingType');
		}
	}
	
	public Lead PO_Vendor {
	
		get{
			Lead l = new Lead();


			if( this.so2.Company__c == null ) return l;
				
			string company = this.so2.Company__c.toLowerCase();

			if( company == 'teufelbeschlage')
			{
				l.FirstName = 'Teufelbeschlag GmbH';
				l.Company = 'Teufelbeschlag GmbH';
				l.Address_1__c = 'Am brand 8';
				l.nrCity__c = 'Tuerkenfeld';
				l.nrState__c = 'Germany';
				l.Zip__c = 'D-82299';
				l.Phone = '0049 8193 9393 924';
				l.Fax = '0049 8193 93 93 99 ';
				l.Email = 'a.teichmann@teufelbeschlag.de';
				
				l.nrCountry__c  = 'Germany';
				
			} else  if( company == 'nanawall (mill valley)' )
			{
				l.FirstName = 'Nana Wall Systems Inc';
				l.Address_1__c = '100 Meadowcreek Drive Suite 250';
				l.nrCity__c = 'Corte Madera';
				l.nrState__c = 'CA';
				l.Zip__c = '94925';
				l.Phone = '800-873-5673 x256';
				l.Fax = '415-383-0312';
				l.Email = '';
				
			} else if( company == 'solarlux (bissendorf)' )
			{//dev = 003A0000005hE6l  prod  = 003A0000005hE6l

				if( GlobalStrings.HostName() == 'cs10.salesforce.com' )
				{ //dev
					Contact c = [SELECT FirstName, Phone, Fax, LastName,Email, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000005hE6l' ];
					l.FirstName = c.FirstName;
					l.LastName = c.LastName;
					l.Company = c.Account.Name;
					l.Address_1__c = c.Account.Address_1__c;
					l.nrCity__c = c.Account.City__c;
					l.nrState__c = c.Account.State__c;
					l.Zip__c = c.Account.Zip__c;
					l.Email = c.Email;
					l.Phone = c.Phone;
					l.Fax = c.Fax;
				} else if(GlobalStrings.HostName() == 'na7.salesforce.com' )
				{
					Contact c = [SELECT FirstName, LastName,Email,Phone, Fax,  Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000005hE6l' ];
					l.FirstName = c.FirstName;
					l.LastName = c.LastName;
					l.Company = c.Account.Name;
					l.Address_1__c = c.Account.Address_1__c;
					l.nrCity__c = c.Account.City__c;
					l.nrState__c = c.Account.State__c;
					l.Zip__c = c.Account.Zip__c;
					l.Email = c.Email;
					l.Phone = c.Phone;
					l.Fax = c.Fax;
				} else 
				{		
					l  = new Lead(	
							Company = 'Solarlux Aluminium Systeme GmbH', FirstName = 'Michael', LastName = 'Schmidt', 
							Address_1__c = 'Gewerbepark 9-11', nrCity__c = 'Bissendorf', nrState__c = '', Zip__c = '49143', 
							nrCountry__c = 'Germany',
							Phone = '+49-5402-400-0');
				}
			} else if ( company == 'solarlux (richmond)')
			{// dev = 003A0000005hFwk  prod = 003A0000005hFwk
				if( GlobalStrings.HostName() == 'cs10.salesforce.com' )
				{ //dev
					Contact c = [SELECT FirstName,Phone,Fax, LastName,Email, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000005hFwk' ];
					l.FirstName = c.FirstName;
					l.LastName = c.LastName;
					l.Company = c.Account.Name;
					l.Address_1__c = c.Account.Address_1__c;
					l.nrCity__c = c.Account.City__c;
					l.nrState__c = c.Account.State__c;
					l.Zip__c = c.Account.Zip__c;
					l.Email = c.Email;
					l.Phone = c.Phone;
					l.Fax = c.Fax;
				} else if(GlobalStrings.HostName() == 'na7.salesforce.com' )
				{
					Contact c = [SELECT FirstName, Phone,LastName,Fax,Email, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000005hFwk' ];
					l.FirstName = c.FirstName;
					l.LastName = c.LastName;
					l.Company = c.Account.Name;
					l.Address_1__c = c.Account.Address_1__c;
					l.nrCity__c = c.Account.City__c;
					l.nrState__c = c.Account.State__c;
					l.Zip__c = c.Account.Zip__c;
					l.Email = c.Email;
					l.Phone = c.Phone;
					l.Fax = c.Fax;
				} else 
				{		
					l  = new Lead(	
							Company = 'Solarlux (Richmond)', FirstName = 'Derek', LastName = 'Lee', 
							Address_1__c = '50 West Ohio', nrCity__c = 'Richmond', nrState__c = 'CA', Zip__c = '94804', 
							Phone = '510-231-0800', nrCountry__c = 'United States' );
				}
				
			}
			
			return l;
		}
		 
	}
	//end specific methods


	public string getOrderNumber() {
	
	
		if( so2.Order_Number__c != null )	
		{
			return so2.Order_Number__c;
		} else if( so2.Auto_Order_Number__c != null ) 
		{
			return so2.Auto_Order_Number__c;	
		} else 
		{
			return so2.Order_Number__c + '';
		}
	}


	private list<Stock_Order_detail__c> details = null;
	public list<Stock_Order_detail__c> getDetails() {
		if( details == null )
		{
			details =  [SELECT Id, Discount__c, Freight__c, Notes__c, Position__c, Quantity__c, Service_Part__c,Service_Part__r.Name,Service_Part__r.Part_Name__c, Stock_Order__c, SubTotal__c, ThumbnailURL__c, Unit_Price__c FROM Stock_Order_Detail__c WHERE Stock_Order__c = :so.id ORDER BY Position__c];
			set<Id> partIds_set = new set<Id>();
			
			for(Stock_Order_Detail__c sod : details )
			{
				if( sod.Service_Part__c != null && !partIds_set.contains(sod.Service_Part__c) )
				{
					partIds_set.add(sod.Service_Part__c);
				}
			}
			list<Id> partIds = new list<Id>(partIds_set);
			map<Id, Attachment> partImageMap = new map<Id,Attachment>();
			
			for( Attachment a :[SELECT Body,BodyLength,Id,ParentId FROM Attachment WHERE ParentID IN :partIds] )
			{
				if( !partImageMap.containsKey(a.ParentId) )
					partImageMap.put( a.ParentID, a );
			}
			for(Stock_Order_Detail__c sod : details )
			{ //now go back over hte details and set the part thumb URL where appropriate
				if( partImageMap.containsKey(sod.Service_Part__c) )
					sod.ThumbnailURL__c = '/servlet/servlet.FileDownload?file='+partImageMap.get(sod.Service_Part__c).Id;
			}
		}
		return details;	
	}


	public list<Stock_Order_Detail__c> getDetails_POItems() {
		list<Stock_Order_Detail__c> sods = new list<Stock_Order_Detail__c>();
			
		for( Stock_Order_Detail__c sod : getDetails() )
		{
//			if( !sqd.Ship_From_Stock__c  )
			{ //does it make sense to realy limit the parts put onto a stock order?
				sods.add(sod);
			}
		}
		return sods;
	}

	public decimal getTax() { 
//		if( so.Tax_Exempt__c) return 0;
		
		decimal tax = 0; 
		tax = so.Tax__c;
		return tax;
	}
	public decimal getTotal() { 

		decimal total = 0;
		return getTax() + getFreight() + getSubtotal();
		
	}

	public decimal getFreight() {

		decimal freight = 0;

		freight = so.freight__c;
		return freight;

	}

	public decimal getSubTotal() {
		
		decimal subtotal = 0;
		subtotal = so.subtotal__c;

		return subtotal;
	}


    private final Stock_Order__c so;
    private Stock_Order__c so2;
    public StockOrder_ReportController(ApexPages.StandardController stdController) {
        this.so = (Stock_Order__c)stdController.getRecord();

		so2 = [SELECT Id, Company__c,Responsible_Rep__c, ETA__c, Freight_Tracking_Number__c, Order_Number__c, Responsibility__c,Shipping_Method__c,TaxRate__c, Freight__c,SubTotal__c, Tax__c, Total__c, Auto_Order_Number__c FROM Stock_Order__c WHERE id = :so.id];

    }



}