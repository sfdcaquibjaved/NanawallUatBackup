public with sharing class Order_MultiSearch_Controller {
 
 /*
 
BLS66
CERO2
ClimaClear
CSW75
FSW75C
FSW75F
HSW45L
HSW50
HSW55
HSW60
HSW65
HSW66
HSW67
HSW75
NanaGlass750
PrivaSee
ScreenClassic
ScreenOne
SL25
SL25R
SL25XXL
SL35
SL35L
SL35US
SL45
SL45IL
SL45L
SL48F
SL48L
SL48TT
SL50
SL50L
SL50US
SL60
SL60F
SL60L
SL60TT
SL68F
SL68L
SL68TT
SL70
SL70C
SL70CL
SL70HR
SL70HRL
SL70L
SL70R
SL70RL
SL72
SL72L
SL73L
SL78F
SL80
SL81
SL82
SL88F
SL88TT
SS66
VSW35
VSW50
VSW65
WA67
WA68F
WA68TT
WD65
WD66
WD68F
WD68TT

*/
 
     public List<SelectOption> getModels() {


		string[] models = new string[]{
										'BLS66', 
										'CERO2', 
										'ClimaClear', 
										'CSW75', 
										'FSW75C', 
										'FSW75F', 
										'HSW45L', 
										'HSW50', 
										'HSW55', 
										'HSW60', 
										'HSW65', 
										'HSW66', 
										'HSW67', 
										'HSW75', 
										'NanaGlass750', 
										'PrivaSee', 
										'ScreenClassic', 
										'ScreenOne', 
										'SL25', 
										'SL25R', 
										'SL25XXL', 
										'SL35', 
										'SL35L', 
										'SL35US', 
										'SL45', 
										'SL45IL', 
										'SL45L', 
										'SL48F', 
										'SL48L', 
										'SL48TT', 
										'SL50', 
										'SL50L', 
										'SL50US', 
										'SL60', 
										'SL60F', 
										'SL60L', 
										'SL60TT', 
										'SL68F', 
										'SL68L', 
										'SL68TT', 
										'SL70', 
										'SL70C', 
										'SL70CL', 
										'SL70HR', 
										'SL70HRL', 
										'SL70L', 
										'SL70R', 
										'SL70RL', 
										'SL72', 
										'SL72L', 
										'SL73L', 
										'SL78F', 
										'SL80', 
										'SL81', 
										'SL82', 
										'SL88F', 
										'SL88TT', 
										'SS66', 
										'VSW35', 
										'VSW50', 
										'VSW65', 
										'WA67', 
										'WA68F', 
										'WA68TT', 
										'WD65', 
										'WD66', 
										'WD68F', 
										'WD68TT'};

		List<SelectOption> options = new List<SelectOption>();
		        
		        
		for( string m  : models)
		{
			options.add(new SelectOption(m, m));
		}       
		
		return options;
		
    }
    
 	// necessary controller methods
	public void previous() { mycontroller.previous(); }
    public void next() { mycontroller.next(); }
    public boolean hasprevious
    {
        get{ return mycontroller.gethasprevious();}
        set;
    }
    
    public boolean hasnext
    {
        get{ return mycontroller.gethasnext(); }
        set;
    }
    
    public List<Order> getMyOrders() {
         return (List<Order>) mycontroller.getRecords();
    }
    public void myaction() { mycontroller=null; }
    
    
     
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    public String sortexp{get;set;}
    public string Total
    {
        get{return Total;}
        set{Total=value;}
    }
    public List<SelectOption> getStates() {
        return Utility.StateOptions();
    }
    public void doSort(){
        String order = 'asc';
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
        sortexp=' order by ' + sortfield + ' ' + order ;

        myaction();
    }    
	//end necessary controller methods
	
	//search fields
    public string QuoteNumber { get; set; }	
    public string OrderNumber { get; set; }	
    public string Model { get; set; }	
    public string PanelsL { get; set; }	
    public string PanelsR { get; set; }	
    public string PanelsCount { get; set; }	
    public string ProjectName { get; set; }	
    public string ProjectState { get; set; }	
    public string ProjectZip { get; set; }	
    public string ContactFirstName { get; set; }	
    public string ContactLastName { get; set; }	
    public string ContactEmail { get; set; }	
    public string ContactPhone { get; set; }	
    public string DepositAmountLo { get; set; }	
    public string DepositAmountHi { get; set; }	
    public string BalanceReceivedAmountLo { get; set; }	
    public string BalanceReceivedAmountHi { get; set; }	
    public string FreightTrackingNumber { get; set; }	
	
 	public Order dummyOrder { get; set; }
 	public Order dummyOrder2 { get; set; }
	
	//end search fields



    public string GetQuery()
    {
    	
        string query = 'SELECT Id, EffectiveDate, Order_Finalized_Date__c, IN_ETA_Jobsite_c__c, Deposit_Amount__c, Balance_Received_Amount__c, Quote_Name__c, Name, Project__r.Name, Project__r.Project_State__c, Project__r.Project_Zip_Code__c, Contact__r.FirstName, Contact__r.LastName, Contact__r.Phone, Contact__r.Email FROM ORDER WHERE Name != \'0\' AND id !=\'\' ';
        
        if(QuoteNumber != null ) QuoteNumber = QuoteNumber.replace(',','');
        if( QuoteNumber != null && QuoteNumber != '' )	query = query + ' AND Quote_Name__c = \''+ QuoteNumber +'\' ';
        
        if(OrderNumber != null ) OrderNumber = OrderNumber.replace(',','');
        if( OrderNumber != null && OrderNumber != '' )	query = query + ' AND Name = \''+ OrderNumber +'\' ';
        
        if(ProjectName != null ) ProjectName = ProjectName.replace(',','');
        if( ProjectName != null && ProjectName != '' )	query = query + ' AND Project__r.Name LIKE \'%'+ ProjectName +'%\' ';
        
        if(ProjectState != null ) ProjectState = ProjectState.replace(',','');
        if( ProjectState != null && ProjectState != '' )	query = query + ' AND Project__r.Project_State__c LIKE \'%'+ ProjectState +'%\' ';
        
        if(ProjectZip != null ) ProjectZip = ProjectZip.replace(',','');
        if( ProjectZip != null && ProjectZip != '' )	query = query + ' AND Project__r.Project_Zip_Code__c = \''+ ProjectZip +'\' ';
        
        if(ContactFirstName != null ) ContactFirstName = ContactFirstName.replace(',','');
        if( ContactFirstName != null && ContactFirstName != '' )	query = query + ' AND Contact__r.FirstName LIKE \'%'+ ContactFirstName +'%\' ';
        
        if(ContactLastName != null ) ContactLastName = ContactLastName.replace(',','');
        if( ContactLastName != null && ContactLastName != '' )	query = query + ' AND Contact__r.LastName LIKE \'%'+ ContactLastName +'%\' ';
        
        if(ContactEmail != null ) ContactEmail = ContactEmail.replace(',','');
        if( ContactEmail != null && ContactEmail != '' )	query = query + ' AND Contact__r.Email LIKE \'%'+ ContactEmail +'%\' ';
        
        if(ContactPhone != null ) ContactPhone = ContactPhone.replace(',','');
        if( ContactPhone != null && ContactPhone != '' )	query = query + ' AND Contact__r.Phone LIKE \'%'+ ContactPhone +'%\' ';

        if(DepositAmountLo != null ) DepositAmountLo = DepositAmountLo.replace(',','');
        if( DepositAmountLo != null && DepositAmountLo != '' )	query = query + ' AND Deposit_Amount__c >= '+ DepositAmountLo +' ';
        
        if(DepositAmountHi != null ) DepositAmountHi = DepositAmountHi.replace(',','');
        if( DepositAmountHi != null && DepositAmountHi != '' )	query = query + ' AND Deposit_Amount__c <= '+ DepositAmountHi +' ';
        
        if(BalanceReceivedAmountLo != null ) BalanceReceivedAmountLo = BalanceReceivedAmountLo.replace(',','');
        if( BalanceReceivedAmountLo != null && BalanceReceivedAmountLo != '' )	query = query + ' AND Balance_Received_Amount__c >= '+ BalanceReceivedAmountLo +' ';
        
        if(BalanceReceivedAmountHi != null ) BalanceReceivedAmountHi = BalanceReceivedAmountHi.replace(',','');
        if( BalanceReceivedAmountHi != null && BalanceReceivedAmountHi != '' )	query = query + ' AND Balance_Received_Amount__c <= '+ BalanceReceivedAmountHi +' ';
        
        if(FreightTrackingNumber != null ) FreightTrackingNumber = FreightTrackingNumber.replace(',','');
        if( FreightTrackingNumber != null && FreightTrackingNumber != '' )	query = query + ' AND IN_Freight_Tracking_Number_c__c LIKE \'%'+ FreightTrackingNumber +'%\' ';
        

		if( dummyOrder.EffectiveDate != null )
		{           	
			DateTime d1 = (Date)dummyOrder.EffectiveDate;
			query += ' AND EffectiveDate >= '+d1.format('yyyy-MM-dd');
		}
		
		if( dummyOrder2.EffectiveDate != null )
		{           	
			DateTime d1 = (Date)dummyOrder2.EffectiveDate;
system.debug( 'date: ' + dummyOrder2.EffectiveDate);			
system.debug( 'd1: ' + d1);			
			query += ' AND EffectiveDate <= '+d1.format('yyyy-MM-dd');
		}
		
		if( dummyOrder.Order_Finalized_Date__c != null )
		{           	
			DateTime d1 = (Date)dummyOrder.Order_Finalized_Date__c;
			query += ' AND Order_Finalized_Date__c >= '+d1.format('yyyy-MM-dd');
		}
		
		if( dummyOrder2.Order_Finalized_Date__c != null )
		{           	
			DateTime d1 = (Date)dummyOrder2.Order_Finalized_Date__c;
			query += ' AND Order_Finalized_Date__c <= '+d1.format('yyyy-MM-dd');
		}
		
		if( dummyOrder.IN_ETA_Jobsite_c__c != null )
		{           	
			DateTime d1 = (Date)dummyOrder.IN_ETA_Jobsite_c__c;
			query += ' AND IN_ETA_Jobsite_c__c >= '+d1.format('yyyy-MM-dd');
		}
		
		if( dummyOrder2.IN_ETA_Jobsite_c__c != null )
		{           	
			DateTime d1 = (Date)dummyOrder2.IN_ETA_Jobsite_c__c;
			query += ' AND IN_ETA_Jobsite_c__c <= '+d1.format('yyyy-MM-dd');
		}
		
		if ( Model != null && Model != '' )
		{
			query += ' AND Id IN ( SELECT OrderID FROM OrderItem WHERE Product_Name__c = \''+Model+'\' ) ';
		}

		// 

		query = query + sortexp + ' limit 2000';
	
        
        
        /*
        
		if( CloseDateLow != null && CloseDateHigh != null)
		{           	
			DateTime d1 = (Date)CloseDateLow;
			DateTime d2 = (Date)CloseDateHigh;

			query += ' AND CloseDate > '+d1.format('yyyy-MM-dd')+'  AND CloseDate < '+d2.format('yyyy-MM-dd')+'    ';
		}        
*/

        return query;
    }
    

 
    public Order_MultiSearch_Controller(){

         sortexp=' order by name asc';
         previoussortfield='name';
                  List<Order> dummylist = new List<Order>();
         mycontroller=
             new ApexPages.StandardSetController(dummylist);
             
             dummyOrder = new Order();
             dummyOrder2 = new Order();
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
        

}