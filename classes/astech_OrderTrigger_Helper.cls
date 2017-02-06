public with sharing class astech_OrderTrigger_Helper {
 
 
	public static void handleBeforeInsert( list<Order> orders ) 
	{
		list<Order> oldOrdersToUpdate = new list<Order>();
		for( Order o : orders  )
		{
			Quote q = [SELECT Id, Dupe_Order__c, Order_Generated__c, AccountID, OpportunityID,Pricebook2Id, Name, ContactId,Order_Number__c,Subtotal,Tax,ShippingHandling,Expedited_Shipping__c,First_Threshold__c,Nana_Quote__c,GrandTotal,First_Threshold_Price__c,Drawing_Price__c,Packaging__c,Canada_Tax__c,Canada_Tax_Label__c,Ship_Label__c,Keyed_Alike__c,Grand_total__c,Shipping_Address__c,Shipping_Address_2__c, Shipping_City__c, Shipping_Country__c, Shipping_State__c, Shipping_Zip__c,Subtotal__c, Opportunity.AccountID, Opportunity.CloseDate, Opportunity.OwnerID, Opportunity.Project_Name__c, Opportunity.Account.BillingStreet, Opportunity.Account.BillingCity,Opportunity.Account.BillingState,Opportunity.Account.BillingPostalCode,Opportunity.Account.BillingCountry,Opportunity.Account.ShippingStreet,Opportunity.Account.ShippingCity,Opportunity.Account.ShippingState,Opportunity.Account.ShippingPostalCode,Opportunity.Account.ShippingCountry FROM Quote WHERE Id = :o.QuoteID ];
	
	
			//assign the order fields
			o.AccountId = q.Opportunity.AccountId;
			o.EffectiveDate = date.today();
			o.Pricebook2Id = q.Pricebook2Id;
			o.BillingStreet = q.Account.BillingStreet;
			o.BillingCity = q.Account.BillingCity;
			o.BillingState = q.Account.BillingState;
			o.BillingPostalCode = q.Account.BillingPostalCode;
			o.BillingCountry = q.Account.BillingCountry;
			o.ShippingStreet =  ( q.Shipping_Address__c != null ? q.Shipping_Address__c : '' ) + ( q.Shipping_Address_2__c != null? '\n' + q.Shipping_Address_2__c : '');
			o.ShippingCity = q.Shipping_City__c;
			o.ShippingStateCode = q.Shipping_State__c;
			o.ShippingPostalCode = q.Shipping_Zip__c;
			o.ShippingCountryCode = ( q.Shipping_Country__c == null || q.Shipping_Country__c == 'US' || q.Shipping_Country__c == 'USA' || q.Shipping_Country__c == 'United States' || q.Shipping_Country__c == 'UNITED STATES' || q.Shipping_Country__c == 'united states' ? 'US' : 'CA' );
			o.Name = string.valueOf(q.Order_Number__c);
			o.Contact__c = q.ContactId;
			o.OwnerId = q.Opportunity.OwnerId;
			o.Subtotal__c = q.Subtotal__c;
			o.Tax__c = q.Tax;
			o.Freight__c = q.ShippingHandling;
			o.Project__c = q.Opportunity.Project_Name__c;
			o.Expedited_Shipping__c = q.Expedited_Shipping__c;
			o.First_Threshold__c = q.First_threshold__c;
			o.NanaQuote__c = q.Nana_Quote__c;
			o.Grand_total__c = q.Grand_Total__c;
			o.First_threshold_Price__c = q.First_Threshold_Price__c;
			o.Drawing_Price__c = q.Drawing_Price__c;
			o.Packaging__c = q.Packaging__c;
			o.Canada_Tax__c = q.Canada_Tax__c;
			o.Canada_Tax_Label__c = q.Canada_Tax_Label__c;
			o.Ship_Label__c = q.Ship_Label__c;
			o.Bill_to_Contact__c = q.ContactId;
			o.Status = 'Order Created'; //or Draft
			o.OpportunityId = q.OpportunityId;
			o.QuoteId = q.Id;		
			
			
			//check if we are cloning an order -- 
	        if( q.Dupe_Order__c != null )
			{
	        	Order oldOrder = [SELECT Id, Name,notes__c, Order_Confirmation_Started__c, Invoices_Sent_Date__c, Balance_Received_Date__c, Complete_Signoff_Date__c,Deposit_Date__c, Deposit_Received_Date__c, Order_Finalized_Date__c FROM Order WHERE Id = :q.Dupe_Order__c];
	        	
	        	o.Name = oldOrder.Name;
				o.Order_Confirmation_Started__c = oldOrder.Order_Confirmation_Started__c;
				o.Invoices_Sent_Date__c = oldOrder.Invoices_Sent_Date__c;
				o.Balance_Received_Date__c = oldOrder.Balance_Received_Date__c;
				o.Complete_Signoff_Date__c = oldOrder.Complete_Signoff_Date__c;
				o.Deposit_Date__c = oldOrder.Deposit_Date__c;
				o.Deposit_Received_Date__c = oldOrder.Deposit_Received_Date__c;
				o.Order_Finalized_Date__c = oldOrder.Order_Finalized_Date__c;
				o.notes__c = oldOrder.notes__c;
				
	        	oldOrder.Status = 'Cancelled';
	        	oldOrder.Name = '0';
				oldOrdersToUpdate.add(oldOrder);
			}	
		}		
		
		if( oldOrdersToUpdate.size() > 0  )
			update oldOrdersToUpdate;

		return;
	}
 
	public static void handleAfterInsert( list<Order> orders ) 
	{
		
		/* get all the QuoteLineItems that should be associated with the Order*/
		list<Id> QuoteIds = new list<Id>();
		map< id,Order> QuoteId_To_Order_Map = new map<Id,Order>();
		for( Order o : orders)
		{
			QuoteIds.add( o.QuoteId );
			QuoteId_To_Order_Map.put( o.QuoteId, o);
		}
		map< id, list<QuoteLineItem> > Order_QuoteLineMap = new map<Id, list<QuoteLineItem> >();
		for( QuoteLineItem qLineItem : [ SELECT Id FROM QuoteLineItem WHERE QuoteID = :QuoteIds] )
		{
			Order o = QuoteId_To_Order_Map.get( qLineItem.QuoteID);
			if( !Order_QuoteLineMap.containsKey(o.Id) )
			{
				Order_QuoteLineMap.put( o.Id, new list<QuoteLineItem>() );
			}
			
			Order_QuoteLineMap.get( o.Id).add( qLineItem );
		}
		
		/* now create the list of order line items */
		list<OrderItem> newOrderItems = new list<OrderItem>();
		
		for( Order o : orders )
		{
			for( QuoteLineItem qLineItem : Order_QuoteLineMap.get(o.Id) )
			{
				OrderItem oi = new OrderItem();
				oi.OrderId = o.Id;
				oi.ActiveSide_Description__c = qLineItem.ActiveSide_Description__c;
				oi.ActiveSide_Notes__c = qLineItem.ActiveSide_Notes__c;
				oi.ActiveSide__c = qLineItem.ActiveSide__c;
				oi.Aluminum_Description__c  = qLineItem.Aluminum_Description__c; 
				oi.Aluminum_Lookup_Price__c = qLineItem.Aluminum_Lookup_Price__c;
				oi.Aluminum_Notes__c = qLineItem.Aluminum_Notes__c;
				oi.Aluminum_Quoted_Price__c  = qLineItem.Aluminum_Quoted_Price__c;
				oi.Aluminum__c = qLineItem.Aluminum__c;
				oi.AngleChanges_Description__c= qLineItem.AngleChanges_Description__c; 
				oi.AngleChanges_Lookup_Price__c  = qLineItem.AngleChanges_Lookup_Price__c;
				oi.AngleChanges_Notes__c  = qLineItem.AngleChanges_Notes__c;
				oi.AngleChanges_Quoted_Price__c  = qLineItem.AngleChanges_Quoted_Price__c;
				oi.AngleChanges__c = qLineItem.AngleChanges__c;
				oi.Base_Lookup_Price__c = qLineItem.Base_Lookup_Price__c;
				oi.Base_Quoted_Price__c = qLineItem.Base_Quoted_Price__c;
				oi.BottomRail_Description__c  = qLineItem.BottomRail_Description__c;
				oi.BottomRail_Notes__c  = qLineItem.BottomRail_Notes__c;
				oi.BottomRail__c = qLineItem.BottomRail__c;
				oi.CEROType_Description__c = qLineItem.CEROType_Description__c;
				oi.CEROType_Notes__c = qLineItem.CEROType_Notes__c;
				oi.CEROType__c = qLineItem.CEROType__c;
				oi.Code__c  = qLineItem.Code__c;
				oi.CornerFinish_Description__c  = qLineItem.CornerFinish_Description__c;
				 oi.CornerFinish_Notes__c  = qLineItem.CornerFinish_Notes__c;
				 oi.CornerFinish__c  = qLineItem.CornerFinish__c;
				 oi.CustodialHardware_Description__c  = qLineItem.CustodialHardware_Description__c;
				 oi.CustodialHardware_Lookup_Price__c  = qLineItem.CustodialHardware_Lookup_Price__c;
				 oi.CustodialHardware_Notes__c  = qLineItem.CustodialHardware_Notes__c;
				 oi.CustodialHardware_Quoted_Price__c  = qLineItem.CustodialHardware_Quoted_Price__c;
				 oi.CustodialHardware__c  = qLineItem.CustodialHardware__c;
				 oi.Description  = qLineItem.Description;
				 oi.Direction_Description__c  = qLineItem.Direction_Description__c;
				 oi.Direction_Notes__c  = qLineItem.Direction_Notes__c;
				 oi.Direction__c = qLineItem.Direction__c;
				 oi.Discount__c  = qLineItem.Discount__c;
				 oi.Extended_SubTotal__c  = qLineItem.Extended_SubTotal__c;
				 oi.Florida_Approved__c  = qLineItem.Florida_Approved__c;
				 oi.FoldFlat_Description__c  = qLineItem.FoldFlat_Description__c;
				 oi.FoldFlat_Notes__c  = qLineItem.FoldFlat_Notes__c;
				 oi.FoldFlat__c  = qLineItem.FoldFlat__c;
				 oi.GlazingDesignation_Description__c  = qLineItem.GlazingDesignation_Description__c;
				 oi.GlazingDesignation_Notes__c  = qLineItem.GlazingDesignation_Notes__c;
				 oi.GlazingDesignation__c  = qLineItem.GlazingDesignation__c;
			//	 oi.Glazing_Description__c 
				 oi.Glazing_Lookup_Price__c  = qLineItem.Glazing_Lookup_Price__c;
				 oi.Glazing_Notes__c  = qLineItem.Glazing_Notes__c;
				 oi.Glazing_Quoted_Price__c  = qLineItem.Glazing_Quoted_Price__c;
				 oi.Glazing__c  = qLineItem.Glazing__c;
				 oi.HandleFinish_Description__c  = qLineItem.HandleFinish_Description__c;
				 oi.HandleFinish_Notes__c  = qLineItem.HandleFinish_Notes__c;
				 oi.HandleFinish__c  = qLineItem.HandleFinish__c;
				 oi.HardwareColor_Description__c  = qLineItem.HardwareColor_Description__c;
				 oi.HardwareColor_Notes__c  = qLineItem.HardwareColor_Notes__c;
				 oi.HardwareColor__c  = qLineItem.HardwareColor__c;
				 oi.HardwareHeight_Description__c  = qLineItem.HardwareHeight_Description__c;
				 oi.HardwareHeight_Notes__c  = qLineItem.HardwareHeight_Notes__c;
				 oi.HardwareHeight__c  = qLineItem.HardwareHeight__c;
				 oi.Hardware_Description__c  = qLineItem.Hardware_Description__c;
				 oi.Hardware_Lookup_Price__c  = qLineItem.Hardware_Lookup_Price__c;
				 oi.Hardware_Notes__c  = qLineItem.Hardware_Notes__c;
				 oi.Hardware_Quoted_Price__c  = qLineItem.Hardware_Quoted_Price__c;
				 oi.Hardware__c  = qLineItem.Hardware__c;
				 oi.Height_Denominator__c  = qLineItem.Height_Denominator__c;
				 oi.Height_Feet__c = qLineItem.Height_Feet__c;
				 oi.Height_Inches__c  = qLineItem.Height_Inches__c;
				 oi.Height_MM__c  = qLineItem.Height_MM__c;
				 oi.Height_Numerator__c  = qLineItem.Height_Numerator__c;
				 oi.HingeFinish_Description__c  = qLineItem.HingeFinish_Description__c;
				 oi.HingeFinish_Notes__c  = qLineItem.HingeFinish_Notes__c;
				 oi.HingeFinish__c  = qLineItem.HingeFinish__c;
				 oi.HingePin_Description__c  = qLineItem.HingePin_Description__c;
				 oi.HingePin_Notes__c  = qLineItem.HingePin_Notes__c;
				 oi.HingePin__c  = qLineItem.HingePin__c;
				 oi.HingeType_Description__c  = qLineItem.HingeType_Description__c;
				 oi.HingeType_Notes__c  = qLineItem.HingeType_Notes__c;
				 oi.HingeType__c  = qLineItem.HingeType__c;
				 oi.IncorpSwingDoor_Description__c  = qLineItem.IncorpSwingDoor_Description__c;
				 oi.IncorpSwingDoor_Lookup_Price__c  = qLineItem.IncorpSwingDoor_Lookup_Price__c;
				 oi.IncorpSwingDoor_Notes__c  = qLineItem.IncorpSwingDoor_Notes__c;
				 oi.IncorpSwingDoor_Quoted_Price__c  = qLineItem.IncorpSwingDoor_Quoted_Price__c;
				 oi.IncorpSwingDoor__c  = qLineItem.IncorpSwingDoor__c;
				 oi.Kickplate_Description__c  = qLineItem.Kickplate_Description__c;
				 oi.Kickplate_Lookup_Price__c = qLineItem.Kickplate_Lookup_Price__c; 
				 oi.Kickplate_Notes__c  = qLineItem.Kickplate_Notes__c;
				 oi.Kickplate_Quoted_Price__c  = qLineItem.Kickplate_Quoted_Price__c;
				 oi.Kickplate__c  = qLineItem.Kickplate__c;
				 oi.LeftStack_Description__c = qLineItem.LeftStack_Description__c;
				 oi.LeftStack_Notes__c  = qLineItem.LeftStack_Notes__c;
				 oi.LeftStack__c  = qLineItem.LeftStack__c;
//				 oi.ListPrice  = qLineItem.ListPrice;
				 oi.Lites_Description__c  = qLineItem.Lites_Description__c;
				 oi.Lites_Lookup_Price__c  = qLineItem.Lites_Lookup_Price__c;
				 oi.Lites_Notes__c  = qLineItem.Lites_Notes__c;
				 oi.Lites_Quoted_Price__c  = qLineItem.Lites_Quoted_Price__c;
				 oi.Lites__c  = qLineItem.Lites__c;
				 oi.Mounting_Description__c  = qLineItem.Mounting_Description__c;
				 oi.Mounting_Notes__c  = qLineItem.Mounting_Notes__c;
				 oi.Mounting__c  = qLineItem.Mounting__c;
				 oi.NFRC__c = qLineItem.NFRC__c;
				 oi.Number__c  = qLineItem.Panels__c;
				 oi.ParkingBay_Description__c  = qLineItem.ParkingBay_Description__c;
				 oi.ParkingBay_Lookup_Price__c  = qLineItem.ParkingBay_Lookup_Price__c;
				 oi.ParkingBay_Notes__c  = qLineItem.ParkingBay_Notes__c;
				 oi.ParkingBay_Quoted_Price__c  = qLineItem.ParkingBay_Quoted_Price__c;
				 oi.ParkingBay__c  = qLineItem.ParkingBay__c;
				 oi.Position_Subtotal__c  = qLineItem.Position_Subtotal__c;
				 oi.Position__c  = qLineItem.Position__c;
				 oi.PricebookEntryId  = qLineItem.PricebookEntryId;
//				 oi.Product2_ID__c  = qLineItem.Product2Id;
				 oi.Quantity  = qLineItem.Quantity;
				 oi.QuoteLineItemId  = qLineItem.Id;
				 oi.ReinforcedLocking_Description__c  = qLineItem.ReinforcedLocking_Description__c;
				 oi.ReinforcedLocking_Lookup_Price__c  = qLineItem.ReinforcedLocking_Lookup_Price__c;
				 oi.ReinforcedLocking_Notes__c  = qLineItem.ReinforcedLocking_Notes__c;
				 oi.ReinforcedLocking_Quoted_Price__c  = qLineItem.ReinforcedLocking_Quoted_Price__c;
				 oi.ReinforcedLocking__c  = qLineItem.ReinforcedLocking__c;
				 oi.RightStack_Description__c  = qLineItem.RightStack_Description__c;
				 oi.RightStack_Notes__c  = qLineItem.RightStack_Notes__c;
				 oi.RightStack__c  = qLineItem.RightStack__c;
				 oi.ScreenFinish_Description__c  = qLineItem.ScreenFinish_Description__c;
				 oi.ScreenFinish_Notes__c  = qLineItem.ScreenFinish_Notes__c;
				 oi.ScreenFinish__c  = qLineItem.ScreenFinish__c;
				 oi.ScreenOneConfiguration_Description__c  = qLineItem.ScreenOneConfiguration_Description__c;
				 oi.ScreenOneConfiguration_Notes__c  = qLineItem.ScreenOneConfiguration_Notes__c;
				 oi.ScreenOneConfiguration__c  = qLineItem.ScreenOneConfiguration__c;
				 oi.ScreenOneFinish_Description__c  = qLineItem.ScreenOneFinish_Description__c;
				 oi.ScreenOneFinish_Notes__c  = qLineItem.ScreenOneFinish_Notes__c;
				 oi.ScreenOneFinish__c  = qLineItem.ScreenOneFinish__c;
				 oi.ScreenOneMesh_Description__c  = qLineItem.ScreenOneMesh_Description__c;
				 oi.ScreenOneMesh_Notes__c  = qLineItem.ScreenOneMesh_Notes__c;
				 oi.ScreenOneMesh__c  = qLineItem.ScreenOneMesh__c;
				 oi.ScreenOneNumber_Description__c  = qLineItem.ScreenOneNumber_Description__c;
				 oi.ScreenOneNumber_Notes__c  = qLineItem.ScreenOneNumber_Notes__c;
				 oi.ScreenOneNumber__c  = qLineItem.ScreenOneNumber__c;
				 oi.ScreenType_Description__c  = qLineItem.ScreenType_Description__c;
				 oi.ScreenType_Lookup_Price__c  = qLineItem.ScreenType_Lookup_Price__c;
				 oi.ScreenType_Notes__c  = qLineItem.ScreenType_Notes__c;
				 oi.ScreenType_Quoted_Price__c  = qLineItem.ScreenType_Quoted_Price__c;
				 oi.ScreenType__c  = qLineItem.ScreenType__c;
				 oi.Screen_Description__c  = qLineItem.Screen_Description__c;
				 oi.Screen_Notes__c  = qLineItem.Screen_Notes__c;
				 oi.Screen__c  = qLineItem.Screen__c;
				 oi.SHGC_Label__c  = qLineItem.SHGC_Label__c;
				 oi.SillColor_Description__c  = qLineItem.SillColor_Description__c;
				 oi.SillColor_Notes__c  = qLineItem.SillColor_Notes__c;
				 oi.SillColor__c  = qLineItem.SillColor__c;
				 oi.Sill_Description__c  = qLineItem.Sill_Description__c;
				 oi.Sill_Lookup_Price__c  = qLineItem.Sill_Lookup_Price__c;
				 oi.Sill_Notes__c  = qLineItem.Sill_Notes__c;
				 oi.Sill_Quoted_Price__c  = qLineItem.Sill_Quoted_Price__c;
				 oi.Sill__c  = qLineItem.Sill__c;
				 oi.SlidingPanel_Description__c  = qLineItem.SlidingPanel_Description__c;
				 oi.SlidingPanel_Notes__c  = qLineItem.SlidingPanel_Notes__c;
				 oi.SlidingPanel__c  = qLineItem.SlidingPanel__c;
				 oi.Socket_Description__c  = qLineItem.Socket_Description__c;
				 oi.Socket_Notes__c  = qLineItem.Socket_Notes__c;
				 oi.Socket__c  = qLineItem.Socket__c;
				 oi.SpacerBar_Description__c  = qLineItem.SpacerBar_Description__c;
				 oi.SpacerBar_Notes__c  = qLineItem.SpacerBar_Notes__c;
				 oi.SpacerBar__c  = qLineItem.SpacerBar__c;
				 oi.StackingDirection_Description__c  = qLineItem.StackingDirection_Description__c;
				 oi.StackingDirection_Notes__c  = qLineItem.StackingDirection_Notes__c;
				 oi.StackingDirection__c  = qLineItem.StackingDirection__c;
				 oi.Stile_Description__c  = qLineItem.Stile_Description__c;
				 oi.Stile_Lookup_Price__c  = qLineItem.Stile_Lookup_Price__c;
				 oi.Stile_Notes__c  = qLineItem.Stile_Notes__c;
				 oi.Stile_Quoted_Price__c  = qLineItem.Stile_Quoted_Price__c;
				 oi.Stile__c  = qLineItem.Stile__c;
				 oi.SwingDoorHinge_Description__c  = qLineItem.SwingDoorHinge_Description__c;
				 oi.SwingDoorHinge_Notes__c  = qLineItem.SwingDoorHinge_Notes__c;
				 oi.SwingDoorHinge__c  = qLineItem.SwingDoorHinge__c;
				 oi.SwingPanelWidth_Description__c  = qLineItem.SwingPanelWidth_Description__c;
				 oi.SwingPanelWidth_Notes__c  = qLineItem.SwingPanelWidth_Notes__c;
				 oi.SwingPanelWidth__c  = qLineItem.SwingPanelWidth__c;
				 oi.SwingPanel_Description__c  = qLineItem.SwingPanel_Description__c;
				 oi.SwingPanel_Notes__c  = qLineItem.SwingPanel_Notes__c;
				 oi.SwingPanel__c  = qLineItem.SwingPanel__c;
				 oi.UnitPrice  = qLineItem.UnitPrice;
				 oi.Units__c  = qLineItem.Units__c;
				 oi.Unit_Base_Price__c  = qLineItem.Unit_Base_Price__c;
				 oi.Unit_Subtotal__c  = qLineItem.Unit_Subtotal__c;
				 oi.UValue_Label__c = qLineItem.UValue_Label__c;
				 oi.Weight__c  = qLineItem.Weight__c;
				 oi.Width_Denominator__c = qLineItem.Width_Denominator__c;
				 oi.Width_Feet__c  = qLineItem.Width_Feet__c;
				 oi.Width_Inches__c  = qLineItem.Width_Inches__c;
				 oi.Width_MM__c  = qLineItem.Width_MM__c;
				 oi.Width_Numerator__c  = qLineItem.Width_Numerator__c;
				 oi.WoodFinish_Description__c  = qLineItem.WoodFinish_Description__c;
				 oi.WoodFinish_Lookup_Price__c  = qLineItem.WoodFinish_Lookup_Price__c;
				 oi.WoodFinish_Notes__c  = qLineItem.WoodFinish_Notes__c;
				 oi.WoodFinish_Quoted_Price__c  = qLineItem.WoodFinish_Quoted_Price__c;
				 oi.WoodFinish__c  = qLineItem.WoodFinish__c;
				 oi.Wood_Description__c  = qLineItem.Wood_Description__c;
				 oi.Wood_Lookup_Price__c  = qLineItem.Wood_Lookup_Price__c;
				 oi.Wood_Notes__c  = qLineItem.Wood_Notes__c;
				 oi.Wood_Quoted_Price__c  = qLineItem.Wood_Quoted_Price__c;
				 oi.Wood__c = qLineItem.Wood__c;


				newOrderItems.add( oi );
			}
		}
		
		
		//look up the quote to update 
		list<Quote> quotesToUpdate = new list<Quote>();
		for (Quote q : [SELECT Id, Order__c FROM Quote WHERE Id = :QuoteIds ] )
		{
			Order o = QuoteId_To_Order_Map.get( q.Id );
			q.Order__c = o.Id;
			q.Order_Generated__c = true;
			quotesToUpdate.add( q );
		}
		
		
		//now insert/update the objects
		if( newOrderItems.size() > 0  )
			insert newOrderItems;
		
		if( quotesToUpdate.size() > 0 )
			update quotesToUpdate;
		
	}    
}