public with sharing class PositionEditor_Controller {


	public boolean useDevFiles = false;
	public string serverUrl{ 
		get {
			if( useDevFiles )
				return '69.39.237.113';
			else return 'www.nanareps.com';
		}
	}

	public string proxyUrl{ 
		get {
			if( useDevFiles )
				return 'https://c.cs3.visual.force.com/apex/ProxyServer';
			else return 'https://c.na7.visual.force.com/apex/ProxyServer';
		}
	}

	public string CSSIncludes { get; set; }
	public string JSIncludes { get; set; }

	public string scriptResource1 {get; set; }
	public string scriptResource2 {get; set; }
	public string scriptResource3 {get; set; }
	public string scriptResource4 {get; set; }
	public string scriptResource5 {get; set; }
	public string scriptResource6 {get; set; }
	public string scriptResource7 {get; set; }

	public string cssResource1 { get; set; }

	public string getLookup_QuoteDetailFromSFID() { 
			
			try {
		string sfQuoteDetailID = Apexpages.currentPage().getParameters().get('SFQuoteDetailID');
		Quote_detail__c qd = [SELECT id, name FROM quote_detail__c WHERE id = :sfQuoteDetailID ];
		
		return qd.Name;
			} catch(Exception ex ) { return ''; }
	 }


	public PositionEditor_Controller() {
			String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');

		
	
	        if(userAgent.contains('iPhone')
	        || userAgent.contains('iPad') 
	        || userAgent.contains('Android')) 
			{
				
				if( useDevFiles )
				{
					//enable the four below for development
					JSIncludes = '<script src="http://www.sendaframe.com/mobile/jquery-1.6.4.min.js"></script>';	
					JSIncludes += '<script src="http://www.sendaframe.com/mobile/jquery.colorSwatchPicker.js"></script>';	
					scriptResource1 = 'dummy.js';
					scriptResource2 = 'dummy.js';				
				} else
				{				
					CSSIncludes = '<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.css" />';
					JSIncludes = '<script src="http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.js"></script>';	
					
					//disable the four below for development
					scriptResource1 = 'position_builder_library/jquery-1.6.4.min.js';
					scriptResource2 = 'position_builder_library/jquery.colorSwatchPicker.js';				
					scriptResource3 = 'position_builder_library/dummy.js';
					scriptResource4 = 'position_builder_library/dummy.js';
	
					cssResource1 = 'position_builder_library/dummy.css';
				}
			}else
			{
				
				//enable the nine below for dev
				if( useDevFiles )
				{
					CSSIncludes = '<link rel="stylesheet" href="https://www.sendaframe.com/mobile/PositionEditor.css" />';
					
					JSIncludes = '<script src="https://www.sendaframe.com/mobile/jquery-1.6.4.min.js"></script>\n';	
					JSIncludes += '<script src="https://www.sendaframe.com/mobile/jquery.colorSwatchPicker.js"></script>\n';	
					JSIncludes += '<script src="https://www.sendaframe.com/mobile/jquery.blockUI.min.js"></script> \n';	
					
					JSIncludes += '<script src="https://www.sendaframe.com/mobile/PositionBuilder.js"></script> \n';	
					JSIncludes += '<script src="https://www.sendaframe.com/mobile/PositionBuilder.Utility.js"></script>\n ';	
					JSIncludes += '<script src="https://www.sendaframe.com/mobile/PositionBuilder.NanaObjects.js"></script>\n ';	
					JSIncludes += '<script src="https://www.sendaframe.com/mobile/PositionBuilder.Browser.js"></script> \n';	
					scriptResource1 = 'dummy.js';
					scriptResource2 = 'dummy.js';				
					scriptResource3 = 'dummy.js';
					scriptResource4 = 'dummy.js';				
					scriptResource5 = 'dummy.js';				
					scriptResource6 = 'dummy.js';				
					scriptResource7 = 'dummy.js';				

				} else 
				{
					//disable the five below for dev		
					scriptResource1 = 'position_builder_library/jquery-1.6.4.min.js';
					scriptResource2 = 'position_builder_library/jquery.colorSwatchPicker.js';				
					scriptResource3 = 'position_builder_library/jquery.blockUI.min.js';
					scriptResource4 = 'position_builder_library/PositionBuilder.js';
					scriptResource5 = 'position_builder_library/PositionBuilder.Utility.js';
					scriptResource6 = 'position_builder_library/PositionBuilder.NanaObjects.js';
					scriptResource7 = 'position_builder_library/PositionBuilder.Browser.js';
					cssResource1 = 'position_builder_library/PositionEditor.css';
				}
			}
	}
		public string getUserID() { return Userinfo.getUserId(); }//100
	

}