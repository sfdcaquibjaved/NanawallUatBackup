trigger Manufacturing_Order_Trigger2 on Manufacturing_Order__c (after update, before update) {
 
	if( trigger.isUpdate && trigger.isBefore )
	{
		
		list<Id> orderIds = new list<Id>(); 
		for( Manufacturing_Order__c mo : trigger.new )
			orderIds.add( mo.Order__c );
		
		map<Id, list<Manufacturing_Order__c>> manufacturingOrderMap = new map<Id, list<Manufacturing_Order__c>>();
		map<Id, list<Shipping_Order__c>> shippingOrderMap = new map<Id, list<Shipping_Order__c>>();
		
		for( Manufacturing_Order__c mo : [SELECT Id, Order__c, Factory_Completion_Date__c, Status__c, Work_Order_Sent__c,Work_Order_Received__c FROM Manufacturing_Order__c WHERE Order__c = :orderIds ])
		{
			if(trigger.newMap.containsKey(mo.Id ) )
				mo = trigger.newMap.get(mo.Id); //we want the updating one
				
			if( !manufacturingOrderMap.containsKey( mo.Order__c) )
			{
				manufacturingOrderMap.put( mo.Order__c, new list<Manufacturing_Order__c>() );
			}
			manufacturingOrderMap.get(mo.Order__c).add( mo );
		}		
		for( Shipping_Order__c so : [SELECT Id,Order__c, Status__c, Actual_Pickup_Date__c,Actual_Delivery_Date__c FROM Shipping_Order__c WHERE Order__c = :orderIds ])
		{
			if( !shippingOrderMap.containsKey( so.Order__c) )
			{ 
				shippingOrderMap.put( so.Order__c, new list<Shipping_Order__c>() );
			}
			shippingOrderMap.get(so.Order__c).add( so );
		}
		
		 
		list<Order> orders = [SELECT Id, Status, Order_Finalized_Date__c, Balance_Received_Date__c, Stage__c FROM Order WHERE Id = :orderids];
		list<Shipping_Order__c> shippingOrdersToUpdate = new list<Shipping_Order__c>();
		list<Order> ordersToUpdate = new list<Order>();
		for( Order o : orders )
		{
			if( o.Stage__c != 'On Hold'
				&& o.Stage__c != 'Cancelled')
			{
				Order_Trigger_Helper.OrderStageAggregate osa = new Order_Trigger_Helper.OrderStageAggregate();
				osa.o = o;
				osa.oldO = o;
				osa.manufacturingOrders = manufacturingOrderMap.get( o.Id );
				osa.shippingOrders = shippingOrderMap.get( o.Id );
				
				Order_Trigger_Helper.SetStages( osa );
				if( osa.orderNeedsUpdating ) 
				{
					ordersToUpdate.add(o);
				}
				if(  osa.shippingOrdersNeedUpdating)
				{
					 shippingOrdersToUpdate.addAll( osa.shippingOrders);
				}
			}
		}
		
		if(ordersToUpdate.size() > 0  && !Order_Trigger_Helper.futureMethodRunning)
			update ordersToUpdate;
		
		if(shippingOrdersToUpdate.size() > 0 && !Order_Trigger_Helper.futureMethodRunning)
			update shippingOrdersToUpdate;
		
		
		
		/* Below is a sample bit of code that will push an update from the Mfr order to the main Order
		map<Id, Manufacturing_Order__c> OrderUpdateMap = new map<Id,Manufacturing_Order__c>();
		for( Manufacturing_Order__c op : trigger.new )
		{
			if( op.Drawing_Final_Order_Confirmation__c != trigger.oldMap.get(op.Id).Drawing_Final_Order_Confirmation__c )
			{
				OrderUpdateMap.put( op.Order__c, op);
			}
		}
		
		if(OrderUpdateMap.keySet().size() > 0 )
		{
			list<Order> orderUpdates = [ SELECT Id,Final_Confirmation_Date__c FROM Order WHERE Id = :OrderUpdateMap.keySet() ];
			for( Order o : orderUpdates )
			{
				Manufacturing_Order__c op = OrderUpdateMap.get(o.Id);
				o.Final_Confirmation_Date__c = op.Drawing_Final_Order_Confirmation__c;
			}
			
			update orderUpdates;
		}
		*/
	}
    
}