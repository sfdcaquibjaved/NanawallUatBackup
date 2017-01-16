public with sharing class ServiceQuote_PositionList_Controller {


	public PageReference deletePosition()
	{
		
		try
		{
			Service_Quote_Detail__c det = [SELECT Id FROM Service_Quote_Detail__c WHERE id = :delPosID];
			
			delete det;
		} catch(Exception ex )
		{
		}	
		details = null;
		this.getDetails();
		return null;
	}

	public string InventoryFill_PositionID {
		
		get;
		set;
	}
	
	public string delPosID 
	{
		get; 
		set;
	}

	public PageReference fillInventory() {
	
		Service_Quote_Detail__c sqd = [SELECT Id,Notes__c, Quantity__c, Service_Part__c, Service_Quote__c FROM Service_Quote_Detail__c WHERE Id = :InventoryFill_PositionID ];		
		Service_Part__c part = [SELECT Id, Number_Stocked__c, Name FROM Service_Part__c WHERE Id = :sqd.Service_Part__c ];
		
		part.Number_Stocked__c += sqd.Quantity__c;
		sqd.Notes__c = ( sqd.Notes__c != null ? sqd.Notes__c + '\n' : '' ) + Datetime.now().format('dd/MM/yyyy HH:mm') +': ' + sqd.Quantity__c +' added to OH for ' + part.Name;
		
		update part;
		update sqd;
		
		details = null;

		Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info,sqd.Quantity__c +' added to OH for ' + part.Name) );


		
		return null;
	}


	private list<Service_Quote_detail__c> details = null;
	public list<Service_Quote_detail__c> getDetails() {
		if( details == null )
		{
			details =  [SELECT Id, Service_Quote__r.Id,ThumbnailURL__c, Quantity__c,Ship_From_Stock__c,Notes__c,Position__c,Name, Service_Part__r.Description__c, Service_Part__r.Name, Service_Part__r.Part_Name__c, Service_Part__r.Stocked__c,Unit_Price__c,Freight__c,subtotal__c, discount__c FROM Service_Quote_Detail__c WHERE Service_Quote__c = :sq.id ORDER BY Position__c];
			set<Id> partIds_set = new set<Id>();
			
			for(Service_Quote_Detail__c sqd : details )
			{
				if( sqd.Service_Part__c != null && !partIds_set.contains(sqd.Service_Part__c) )
				{
					partIds_set.add(sqd.Service_Part__c);
				}
			}
			list<Id> partIds = new list<Id>(partIds_set);
			map<Id, Attachment> partImageMap = new map<Id,Attachment>();
			
			for( Attachment a :[SELECT Body,BodyLength,Id,ParentId FROM Attachment WHERE ParentID IN :partIds] )
			{
				if( !partImageMap.containsKey(a.ParentId) )
					partImageMap.put( a.ParentID, a );
			}
			for(Service_Quote_Detail__c sqd : details )
			{ //now go back over hte details and set the part thumb URL where appropriate
				if( partImageMap.containsKey(sqd.Service_Part__c) )
					sqd.ThumbnailURL__c = '/servlet/servlet.FileDownload?file='+partImageMap.get(sqd.Service_Part__c).Id;
			}
			
			
		}
		return details;	 
	}


    private final Service_Quote__c sq;
    public ServiceQuote_PositionList_Controller(ApexPages.StandardController stdController) {
        this.sq = (Service_Quote__c)stdController.getRecord();

    }
	public string refreshCode { get; set; }
	public PageReference SetPositionOrders() {
	
		update details;
		details = null;
		getDetails();
		
		Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info,'Position orders saved.') );
		
		refreshcode = 'setTimeout( function() {document.location.href = "'+ApexPages.currentPage().getUrl()+'";}, 2000); ';
		return null;
	}
	
	public PageReference AddNewPosition() {
	
		return null;
//		return new Pagereference('/apex/Service_Quote_Detail_AddEdit?CF00NQ0000000sU0G=22&CF00NQ0000000sU0G_lkid='+sq.Id+'&scontrolCaching=1&retURL=%2F'+sq.Id+'&sfdc.override=1');
	}
	
}