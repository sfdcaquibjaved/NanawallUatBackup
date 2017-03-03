public with sharing class Order_MultiSearch_Controller {
 
     
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    public String sortexp{get;set;}
    public string Total
    {
        get{return Total;}
        set{Total=value;}
    }

    public string GetQuery()
    {
    	
        string query = 'select name,address__c,state__c,zip__c,country__c,city__c,order_number__c from Quote__c where id!=\'\' ';
        
        /*
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
*/

        return query;
    }
    

 
    public Order_MultiSearch_Controller(){

         sortexp=' order by name asc';
         previoussortfield='name';
                  List<Quote__c> dummylist = new List<Quote__c>();
         mycontroller=
             new ApexPages.StandardSetController(dummylist);
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