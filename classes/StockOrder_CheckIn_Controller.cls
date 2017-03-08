public with sharing class StockOrder_CheckIn_Controller {


	public class StockOrder_Detail_Wrapper
	{
		public Stock_Order_Detail__c stockOrderDetail { get; set; }
		public integer Quantity_CheckingIn { get; set; }
		
//
//
//Service_Part__c
//ThumbnailURL__c
//		
	}
	
	
	list<StockOrder_Detail_Wrapper> details = null;
	public list<StockOrder_Detail_Wrapper> getDetails() 
	{
		if( details == null )
		{
			details = new list<StockOrder_Detail_Wrapper>();
			
			for( Stock_Order_Detail__c det : [SELECT Id, Checked_In_Quantity__c, Discount__c, Freight__c,Notes__c,Position__c,Quantity__c,Service_Part__c,Service_Part__r.Id,Service_Part__r.Number_Stocked__c, Stock_Order__c,SubTotal__c,ThumbnailURL__c,Unit_Price__c FROM Stock_Order_detail__c WHERE Stock_Order__c = :so.Id ORDER By Position__c] )
			{
				
				StockOrder_Detail_Wrapper wrapper = new StockOrder_Detail_Wrapper();
				wrapper.stockOrderDetail = det;
				wrapper.Quantity_CheckingIn = 0;
				if(det.Checked_In_Quantity__c == null )
					det.Checked_In_Quantity__c = 0;
								
				details.add(wrapper);		
			}
		
			set<Id> partIds_set = new set<Id>();
			
			for(StockOrder_Detail_Wrapper sod : details )
			{
				if( sod.stockOrderDetail.Service_Part__c != null && !partIds_set.contains(sod.stockOrderDetail.Service_Part__c) )
				{
					partIds_set.add(sod.stockOrderDetail.Service_Part__c);
				}
			}
			list<Id> partIds = new list<Id>(partIds_set);
			map<Id, Attachment> partImageMap = new map<Id,Attachment>();
			
			for( Attachment a :[SELECT Body,BodyLength,Id,ParentId FROM Attachment WHERE ParentID IN :partIds] )
			{
				if( !partImageMap.containsKey(a.ParentId) )
					partImageMap.put( a.ParentID, a );
			}
			for(StockOrder_Detail_Wrapper sod : details )
			{ //now go back over hte details and set the part thumb URL where appropriate
				if( partImageMap.containsKey(sod.stockOrderDetail.Service_Part__c) )
					sod.stockOrderDetail.ThumbnailURL__c = '/servlet/servlet.FileDownload?file='+partImageMap.get(sod.stockOrderDetail.Service_Part__c).Id;
			}
		}
		
		
		return details;
	}

	boolean overrideQtyProblem = false;
	public boolean showQtyConfirmationScreen {get; set; }

	public PageReference doCheckIn_OverrideQty() 
	{
		overrideQtyProblem = true;
		return doCheckIn();
	}
	public PageReference doCheckIn() 
	{
	
		if( !overrideQtyProblem )
		{
			showQtyConfirmationScreen = false;
			for( StockOrder_Detail_Wrapper wrapper : getDetails() )
			{
				if(wrapper.Quantity_CheckingIn == null || wrapper.Quantity_CheckingIn == 0  )
					continue;
					
				decimal qtyAfterCheckedIn = wrapper.stockOrderDetail.Checked_In_Quantity__c + wrapper.Quantity_CheckingIn;
				
				if( qtyAfterCheckedIn > wrapper.stockOrderDetail.Quantity__c )
				{
					showQtyConfirmationScreen = true;
				}
			}
		} else showQtyConfirmationScreen = false;
		if( showQtyConfirmationScreen ) return null;
		
		list<Service_Part__c> partsToUpdate =  new list<Service_Part__c>();
		list<Stock_Order_Detail__c> detailsToUpdate =  new list<Stock_Order_Detail__c>();
		for( StockOrder_Detail_Wrapper wrapper : getDetails() )
		{
			if( wrapper.Quantity_CheckingIn != null
			&& wrapper.Quantity_CheckingIn > 0 )
			{
				//1.  add to stock level
				Service_Part__c part = wrapper.stockOrderDetail.Service_Part__r;
				if( part.Number_Stocked__c == null )
					part.Number_Stocked__c = 0;
				part.Number_Stocked__c += wrapper.Quantity_CheckingIn;
				partsToUpdate.add(part);

				//2. flag the checked in total quantity on the Stock Order
				Stock_Order_Detail__c detail = wrapper.stockOrderDetail;
				if( detail.Checked_In_Quantity__c == null )
					detail.Checked_In_Quantity__c = wrapper.Quantity_CheckingIn;
				else detail.Checked_In_Quantity__c += wrapper.Quantity_CheckingIn;
				detailsToUpdate.add(detail);
			}
		}
		
		
		if( partsToUpdate.size() > 0 && detailsToUpdate.size() > 0 )
		{
			update partsToUpdate;
			update detailsToUpdate;
			return backToStockOrder();
		} else
		{
			Apexpages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, 'Warning! You did not add any quantities to check in. There is nothing to do.'));
		}
		
		

	
		return null;
	}
	
	public PageReference backToStockOrder() {
	
		return new PageReference('/'+ this.so.Id);
	}

    private final Stock_Order__c so;
    private boolean initd = false;
    public StockOrder_CheckIn_Controller(ApexPages.StandardController stdController) {
        this.so = (Stock_Order__c)stdController.getRecord();
        
        if( !initd )
        {
	        showQtyConfirmationScreen = false;
	        initd = true;
        }
    }


}