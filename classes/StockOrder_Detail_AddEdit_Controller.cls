public with sharing class StockOrder_Detail_AddEdit_Controller {

    public Stock_Order__c stockOrder { get; set; }
    public Stock_Order_Detail__c stockOrderDetail { get; set; }
   

    private void loadStockOrder( string soid ) 
    {    
        system.debug('I am here');
        stockOrder = [SELECT id FROM Stock_Order__c WHERE Id = :soid ]; 
        system.debug('The value of stockOrder ' + stockOrder );
    }


    public StockOrder_Detail_AddEdit_Controller(ApexPages.StandardController controller) {
   
        if( controller.getrecord() != null && controller.getRecord().Id != null)
        {
            stockOrderDetail = (Stock_Order_Detail__c)controller.getrecord();
            if(stockOrderDetail.Service_Part__c != null)
            {
                Service_Part__c sp = [SELECT Id, Part_Name__c FROM Service_Part__c WHERE id =:stockOrderDetail.Service_Part__c];
                system.debug('The value of sp' + sp);
                ServicePartItemID = sp.Id;
                ServicePartName = sp.Part_Name__c;
            } else {
                ServicePartItemID = '';
                ServicePartName = '';  

            }
            loadStockOrder( stockOrderDetail.Stock_Order__c );
            
        } else 
        {    
            string FieldID = label.Stock_Order_Field_ID ;
            string soId = Apexpages.currentPage().getParameters().get(FieldID);
            system.debug('Value of soid' + soid);
            if( soId == null || soId == '' )
            {//if this is coming in from a related list, we wont have the param we need.
            
              
               
                string temp = Apexpages.currentPage().getParameters().get('retURL');
                soId = temp.substring(1,temp.length() );
                system.debug('inside if value of soid' + soid);
            
            }
            loadStockOrder( soId);
            
            stockOrderDetail = new Stock_Order_Detail__c();         
            stockOrderDetail.Quantity__c = 1;
//          stockOrderDetail.Discount__c = stockOrder.Discount__c;
            stockOrderDetail.Stock_Order__c = stockOrder.id;
            
            Decimal defaultPosition = 1;
            for( Stock_Order_Detail__c sod : [SELECT Position__c FROM Stock_Order_Detail__c WHERE Stock_Order__c = :soId] )
            {
               system.debug('The value of sod' + sod);
                if( sod.Position__c >= defaultPosition )
                    defaultPosition = sod.Position__c +1;
            }
            
            stockOrderDetail.Position__c = defaultPosition;
            
        }
    }
    public string ServicePartItemID { get; set; }
    public string ServicePartName { get; set; }
    
    public PageReference cancel() {
        return new PageReference('/' +  stockOrderDetail.Stock_Order__c);
    }
    
    public PageReference save() {
        if( ServicePartItemID == null 
        || ServicePartItemID == '' )
        {
            ApexPages.addMessage(new Apexpages.Message( apexpages.Severity.ERROR, 'Error! You must select a service part item in order to continue.') );        
            return null;
        }
        

        stockOrderDetail.Service_Part__c = ServicePartItemID;

        if(stockOrderDetail.Id == null )
            insert stockOrderDetail;
        else update stockOrderDetail;

        return new PageReference('/' + stockOrderDetail.Stock_Order__c);

    }
}