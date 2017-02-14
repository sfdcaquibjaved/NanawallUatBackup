trigger Shipping_Order_Trigger on Shipping_Order__c (after update, before update) {

    if( trigger.isUpdate && trigger.isBefore )
    {
        
        list<Id> orderIds = new list<Id>();
        for( Shipping_Order__c so : trigger.new ) 
            orderIds.add( so.Order__c );
        
        map<Id, list<Manufacturing_Order__c>> manufacturingOrderMap = new map<Id, list<Manufacturing_Order__c>>();
        map<Id, list<Shipping_Order__c>> shippingOrderMap = new map<Id, list<Shipping_Order__c>>();
        
        for( Manufacturing_Order__c mo : [SELECT Id, Order__c, Factory_Completion_Date__c, Status__c, Work_Order_Sent__c,Work_Order_Received__c FROM Manufacturing_Order__c WHERE Order__c = :orderIds ])
        {
            if( !manufacturingOrderMap.containsKey( mo.Order__c) )
            {
                manufacturingOrderMap.put( mo.Order__c, new list<Manufacturing_Order__c>() );
            }
            manufacturingOrderMap.get(mo.Order__c).add( mo ); 
        } 

          
        for( Shipping_Order__c so : [SELECT Id,Order__c, Status__c,  Actual_Pickup_Date__c,Actual_Delivery_Date__c, ETA_Jobsite__c, Freight_ETA_Jobsite__c, Freight_Tracking_Number__c,Revised_ETA_Jobsite__c  FROM Shipping_Order__c WHERE Order__c = :orderIds ])
        {
            if(trigger.newMap.containsKey(so.Id ) )
                so = trigger.newMap.get(so.Id); //we want the updating one
            
            if( !shippingOrderMap.containsKey( so.Order__c) )
            {
                shippingOrderMap.put( so.Order__c, new list<Shipping_Order__c>() );
            }
            shippingOrderMap.get(so.Order__c).add( so );
        }
        
        
        list<Order> orders = [SELECT Id, Status, Order_Finalized_Date__c, Balance_Received_Date__c, Stage__c, IN_Actual_Pickup_Date_c__c,IN_Actual_Delivery_Date_c__c, IN_ETA_Jobsite_c__c, IN_Freight_ETA_Jobsite_c__c, IN_Freight_Tracking_Number_c__c, IN_Revised_ETA_Jobsite_c__c FROM Order WHERE Id = :orderids];
        list<Manufacturing_Order__c> manufacturingOrdersToUpdate = new list<Manufacturing_Order__c>();
        list<Order> ordersToUpdate = new list<Order>();
        list<Id> orderIdsToUpdate = new list<Id>();
        for( Order o : orders ) 
        {
//          if( o.Stage__c != 'On Hold'
//              && o.Stage__c != 'Cancelled')
            {           
                Order_Trigger_Helper.OrderStageAggregate osa = new Order_Trigger_Helper.OrderStageAggregate();
                osa.o = o;
                osa.oldO = o;
                osa.manufacturingOrders = manufacturingOrderMap.get( o.Id );
                osa.shippingOrders = shippingOrderMap.get( o.Id );
                
                Order_Trigger_Helper.SetStages( osa );
                
				// need to push the most recent dates for certain fields back up to the Order level because  ... we have no good reason and like to write code i guess
				//this block detects if a change is needed, and tells the Order_Trigger_Helper to do it
				boolean set_IN_Actual_Delivery_Date = false;
				boolean set_IN_ETA_Jobsite = false;
				boolean set_IN_Freight_ETA_Jobsite = false;
				boolean set_IN_Freight_Tracking_Number = false;
				boolean set_IN_Revised_ETA_Jobsite = false;
				boolean set_IN_Actual_Pickup_Date  = false;
				for( Shipping_Order__c so : shippingOrderMap.get( o.Id ) ) 
				{
					if( so.Actual_Delivery_Date__c != null )
						set_IN_Actual_Delivery_Date = true;

					if( so.ETA_Jobsite__c != null )
						set_IN_ETA_Jobsite = true;

					if( so.Freight_ETA_Jobsite__c != null )
						set_IN_Freight_ETA_Jobsite = true;

					if( so.Freight_Tracking_Number__c != null )
						set_IN_Freight_Tracking_Number = true;

					if( so.Revised_ETA_Jobsite__c != null )
						set_IN_Revised_ETA_Jobsite = true;

					if( so.Actual_Pickup_Date__c != null )
						set_IN_Actual_Pickup_Date = true;
				}

				boolean ordersNeedUpdating  = ( set_IN_Actual_Delivery_Date || set_IN_ETA_Jobsite || set_IN_Freight_ETA_Jobsite || set_IN_Freight_Tracking_Number || set_IN_Revised_ETA_Jobsite || set_IN_Actual_Pickup_Date);
				// end of pipeline push
system.debug('** SO: ordersNeedUpdating: ' + ordersNeedUpdating );
                
                
                if( osa.orderNeedsUpdating || ordersNeedUpdating ) 
                {
system.debug('**SO: orders need updating');                   
                    ordersToUpdate.add(o);
                    orderIdsToUpdate.add( o.Id );
                }
                if(  osa.mfrOrdersNeedUpdating)
                {
                     manufacturingOrdersToUpdate.addAll( osa.manufacturingOrders);
                    orderIdsToUpdate.add( o.Id );
                }
            }
        }
        if(ordersToUpdate.size() > 0  && !Order_Trigger_Helper.futureMethodRunning)
        {
            	Order_Trigger_Helper.doOrderUpdates(orderIdsToUpdate);
system.debug('** SO: Doing the order update');
        } else 
        {
system.debug('** SO: Skipping save ( '+ordersToUpdate.size()+' ; '+Order_Trigger_Helper.futureMethodRunning+') ');
        }
        
        if(manufacturingOrdersToUpdate.size() > 0 && !Order_Trigger_Helper.futureMethodRunning)
            Order_Trigger_Helper.doMfrOrderUpdates(orderIdsToUpdate);

    }
    
}