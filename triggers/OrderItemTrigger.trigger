trigger OrderItemTrigger on OrderItem (after insert) {
 
 
 		//need to create work orders here because the positions dont exist after order insert
 		//on creation we need to create Work Orders and Shipment Orders based on the order

//			US doors -> US Work Order  (last character is an L)  (Richmond Record Type)
//			German Doors -> German Work Order (Solarlux Record Type)
//			Screens -> Screen Work Order (has a screen) (Teuffel Record Type) 		

 
 
	list<id> orderids = new list<id>();
	for( OrderItem oi : trigger.new )
	{
		orderids.add( oi.OrderId );
	}
	
	map<Id,  list<Manufacturing_Order__c>> existingWorkOrders = new map< Id, list<Manufacturing_Order__c>>();
	for( Manufacturing_Order__c wo : [SELECT Id, Order__c FROM Manufacturing_Order__c WHERE Order__c = :orderids ] )
	{
		if( !existingWorkOrders.containsKey(wo.Order__c) )
		{
			existingWorkOrders.put( wo.Order__c, new list<Manufacturing_Order__c>() );
		}
	}

	map<id, list<OrderItem> > richmondIds = new map<id, list<OrderItem>>();
	map<id, list<OrderItem> > teuffelIds = new map<id, list<OrderItem>>();
	map<id, list<OrderItem> > solarluxIds = new map<id, list<OrderItem>>();
	map<id, list<OrderItem> > wizardIds = new map<id, list<OrderItem>>();
	map<id, list<OrderItem> > seikiIds = new map<id, list<OrderItem>>();

	map< Id,string> mfoTypes = new map<Id, string>();

	for( OrderItem oi : trigger.new)
	{
system.debug('** OrderItemTrigger: checking product: ' + oi.Product_Name__c );
system.debug('** OrderItemTrigger: Opp ID = ' + oi.OrderId );
		string lastchar = oi.Product_Name__c.substring( oi.Product_Name__c.length()-1,oi.Product_Name__c.length() );
system.debug('last char: ' + lastchar);
		if( oi.Product_Name__c.toLowerCase() == 'screenone' )
		{
			//make sure a wizard WO doesnt already exist
			//Wizard_Work_Order
			if( !wizardIds.containsKey(oi.OrderId) )
			{
				wizardIds.put( oi.OrderId, new list<OrderItem>() );
			}
			wizardIds.get(oi.OrderId).add( oi );

system.debug('got a wizard');
		} else if( oi.Product_Name__c.toLowerCase() == 'screenclassic' )
		{
			if( !seikiIds.containsKey(oi.OrderId) )
			{
				seikiIds.put( oi.OrderId, new list<OrderItem>() );
			}
			seikiIds.get(oi.OrderId).add( oi );

system.debug('got a seiki');
			
			
		} else if ( oi.Product_Name__c.toLowerCase().contains('hsw75') 
		|| oi.Product_Name__c.toLowerCase().contains('csw75')
		|| oi.Product_Name__c.toLowerCase().contains('fsw75f')
		|| oi.Product_Name__c.toLowerCase().contains('fsw75c')
		|| oi.Product_Name__c.toLowerCase().contains('privasee')
		|| oi.Product_Name__c.toLowerCase().contains('climaclear')
		)
		{
			//make sure a teuffel WO doesnt already exist
			if( !teuffelIds.containsKey(oi.OrderId) )
			{
				teuffelIds.put( oi.OrderId, new list<OrderItem>() );
			}
			teuffelIds.get(oi.OrderId).add( oi );

system.debug('got a teuffel');
		} else if ( lastchar != null && lastchar.toLowerCase() == 'l' && oi.Product_Name__c.toLowerCase() != 'sl25xxl' )
		{
			//make sure a richmond WO doesnt already exist
			if( !richmondIds.containsKey(oi.OrderId) )
			{
				richmondIds.put( oi.OrderId, new list<OrderItem>() );
			}
			richmondIds.get(oi.OrderId).add( oi );
system.debug('got a richmond');
		} else
		{
			//make sure a solarlux WO doesnt already exist.
			if( !solarluxIds.containsKey(oi.OrderId) )
			{
				solarluxIds.put( oi.OrderId, new list<OrderItem>() );
			}
			solarluxIds.get(oi.OrderId).add( oi );

system.debug('got a solarlux'); 
		}
	}
		
	if( teuffelIds.size() > 0 || richmondIds.size() > 0 || solarluxids.size() > 0 || wizardIds.size() > 0 || seikiIds.size() > 0  )
	{
 
		
		map<Id, Order> orderMap = new map<Id, Order>();
		for( Order o : [SELECT Id, Opportunity.AccountId, Opportunity.OwnerId, Quote.Rush__c, Quote.AACO__c, Order.Project__c, Order.Payment_Type__c, Order.Quote.Shipping_Address__c, Order.Quote.Shipping_Address_2__c,    Order.Quote.Shipping_City__c, Order.Quote.Shipping_State__c, Order.Quote.Shipping_Zip__c, Order.Quote.Shipping_Country__c, Order.Quote.Nana_Quote__r.Expedited_Shipping__c, Order.Quote.ContactId, Order.Quote.Shipping_Min__c, Order.Quote.Shipping_Max__c, Order.Quote.First_threshold__c, Order.OwnerId  FROM Order WHERE Id in :teuffelIds.keySet() OR Id in :richmondIds.keySet() OR Id in :solarluxids.keySet() OR Id in :wizardIds.keySet() OR Id in :seikiIds.keySet() ] )
		{
system.debug('** OrderItemTrigger: Opportunity = ' + o.Id + ' ;  Owner = ' + o.Opportunity.OwnerId );			
			orderMap.put( o.Id, o);
		}   


		
		map<string,id> recordTypes = new map<string,id>();
     	for( RecordType rt :  [SELECT Id, DeveloperName FROM RecordType  WHERE SobjectType = 'Manufacturing_Order__c' ] )
    	{
System.debug('got a record type ' + rt.DeveloperName + ' ; ' + rt.Id);    		
    		recordTypes.put( rt.DeveloperName, rt.Id);
    	}
		list<Manufacturing_Order__c> workorderstocreate = new list<Manufacturing_Order__c>();
		list<Shipping_Order__c> shippingorderstocreate = new list<Shipping_Order__c>();
		
//		seikiIds
		for( Id OrderID : seikiIds.keySet() )
		{
			Order o = orderMap.get( OrderId );
			Manufacturing_Order__c wo = new Manufacturing_Order__c();
			wo.OwnerId = o.Opportunity.OwnerId;
			wo.Order__c = OrderId;
			wo.RecordTypeId = recordTypes.get('Seiki');
			wo.Project__c = o.Project__c;
			
			 
			mfoTypes.put(OrderID, ( mfoTypes.get(OrderID) != '' && mfoTypes.get(OrderID) != null ? mfoTypes.get(OrderID)+';' : '')+'Seiki' );
			
			//defaults
			wo.Account__c = o.Opportunity.AccountId;
			wo.Contact__c = o.Quote.ContactId;
			wo.AACO__c = o.Quote.AACO__c;

system.debug('using Seiki record type ' + recordTypes.get('Seiki') );			
			workorderstocreate.add(wo);
			
		}
		
		for( Id OrderID : wizardIds.keySet() )
		{
			Order o = orderMap.get( OrderId );
			Manufacturing_Order__c wo = new Manufacturing_Order__c();
			wo.OwnerId = o.Opportunity.OwnerId;
			wo.Order__c = OrderId;
			wo.RecordTypeId = recordTypes.get('Wizard');
			wo.Project__c = o.Project__c;
			
			mfoTypes.put(OrderID, (mfoTypes.get(OrderID) != '' && mfoTypes.get(OrderID) != null ? mfoTypes.get(OrderID)+';' : '')+'Wizard' );

			
			//defaults
			wo.Account__c = o.Opportunity.AccountId;
			wo.Contact__c = o.Quote.ContactId;
			wo.AACO__c = o.Quote.AACO__c;

system.debug('using Wizard record type ' + recordTypes.get('Wizard') );			
			workorderstocreate.add(wo);
			
		}
		
		for( Id OrderID : teuffelIds.keySet() )
		{
			Order o = orderMap.get( OrderId );
			Manufacturing_Order__c wo = new Manufacturing_Order__c();
			wo.OwnerId = o.Opportunity.OwnerId;
			wo.Order__c = OrderId;
			wo.RecordTypeId = recordTypes.get('Teuffel');
			wo.Project__c = o.Project__c;

			mfoTypes.put(OrderID,  ( mfoTypes.get(OrderID) != '' && mfoTypes.get(OrderID) != null ? mfoTypes.get(OrderID)+';' : '')+'Teuffel' );
			
			//defaults
			wo.Account__c = o.Opportunity.AccountId;
			wo.Contact__c = o.Quote.ContactId;
			wo.AACO__c = o.Quote.AACO__c;

system.debug('using Teuffel record type ' + recordTypes.get('Teuffel') );			
			workorderstocreate.add(wo);
			
		}
		
		for( Id OrderID : richmondIds.keySet() )
		{
			Order o = orderMap.get( OrderId );

			Manufacturing_Order__c wo = new Manufacturing_Order__c();
			wo.OwnerId = o.Opportunity.OwnerId;
			wo.Order__c = OrderId;
			wo.RecordTypeId = recordTypes.get('Richmond');
			wo.Project__c = o.Project__c;

			mfoTypes.put(OrderID, ( mfoTypes.get(OrderID) != '' && mfoTypes.get(OrderID) != null ? mfoTypes.get(OrderID)+';' : '')+'Richmond' );

			//defaults
			wo.Account__c = o.Opportunity.AccountId;
			wo.Contact__c = o.Quote.ContactId;
			wo.AACO__c = o.Quote.AACO__c;
			
system.debug('using Richmond record type ' + recordTypes.get('Richmond') );						
			workorderstocreate.add(wo);
			
		}
		
		for( Id OrderID : solarluxids.keySet() )
		{

			Order o = orderMap.get( OrderId );

			Manufacturing_Order__c wo = new Manufacturing_Order__c();
			wo.OwnerId = o.Opportunity.OwnerId;
			wo.Order__c = OrderId;
			wo.RecordTypeId = recordTypes.get('Solarlux');
			wo.Project__c = o.Project__c;
system.debug('using Solarlux record type ' + recordTypes.get('Solarlux') );
			
			mfoTypes.put(OrderID,   ( mfoTypes.get(OrderID) != '' && mfoTypes.get(OrderID) != null ? mfoTypes.get(OrderID)+';' : '')+'Solarlux' );
			
			//defaults
			wo.Account__c = o.Opportunity.AccountId;
			wo.Contact__c = o.Quote.ContactId;
			wo.AACO__c = o.Quote.AACO__c;
			
			workorderstocreate.add(wo);			
		}
		
		insert workorderstocreate;    


		list<Manufacturing_Order_Position__c> workorderlineitemstocreate = new list<Manufacturing_Order_Position__c>();
		map<Id, Shipping_Order__c> mfrOrderIdtoShippingOrder = new map<Id,Shipping_Order__c>();
		for( Manufacturing_Order__c wo  : workorderstocreate )
		{
			Order o = orderMap.get( wo.Order__c );
		
			Shipping_Order__c so = new Shipping_Order__c();
			so.OwnerID = o.Opportunity.OwnerID;
			so.Manufacturing_Order__c = wo.Id;
			so.Order__c = wo.Order__c;
			
			//defaults
			so.Project__c = wo.Project__c;
//			so.ETA_Jobsite__c = '';
			so.Shipping_Address__c = o.Quote.Shipping_Address__c;
			so.Shipping_Address_2__c = o.Quote.Shipping_Address_2__c;
			so.Shipping_City__c = o.Quote.Shipping_City__c;
			so.Shipping_State__c = o.Quote.Shipping_State__c;
			so.Shipping_Zip__c = o.Quote.Shipping_Zip__c;
			so.Ship_Country__c = o.Quote.Shipping_Country__c;
			
			so.Expedited__c = o.Quote.Nana_Quote__r.Expedited_Shipping__c;
			so.Shipping_Name__c = o.Quote.ContactId;
			
			so.Shipping_Time_Min__c	= o.Quote.Shipping_Min__c;
			so.Shipping_Time_Max__c = o.Quote.Shipping_Max__c;
			so.First_Threshold__c = o.Quote.First_threshold__c;
			so.Rush__c = o.Quote.Rush__c;
			
			shippingorderstocreate.add(so);
			
			mfrOrderIdtoShippingOrder.put( wo.Id, so);
			
		
		}
		
		if( shippingorderstocreate.size() > 0 )
			insert shippingorderstocreate;
			
		for( Manufacturing_Order__c wo  : workorderstocreate )
		{
			Order o = orderMap.get( wo.Order__c );
			Shipping_Order__c so = mfrOrderIdtoShippingOrder.get( wo.Id );
		
		
			list<OrderItem> orderLineItems = null;	
			if( wo.RecordTypeId == recordTypes.get('Seiki') )
			{
				orderLineItems = seikiIds.get( wo.Order__c);				
			} else if( wo.RecordTypeId == recordTypes.get('Wizard') )
			{
				orderLineItems = wizardIds.get( wo.Order__c);				
			} else if( wo.RecordTypeId == recordTypes.get('Solarlux') )
			{
				orderLineItems = solarluxIds.get( wo.Order__c);
			} else if ( wo.RecordTypeId == recordTypes.get('Richmond') )
			{
				orderLineItems = richmondIds.get(wo.Order__c);
			} else if( wo.RecordTypeId == recordTypes.get('Teuffel') )
			{
				orderLineItems = teuffelIds.get( wo.Order__c);
			}
			
			for( OrderItem oi :  orderLineItems)
			{
				Manufacturing_Order_Position__c newlineitem = new Manufacturing_Order_Position__c();
				newlineitem.Order__c = wo.Order__c;
				//newlineitem.PriceBookEntryId = oi.PriceBookEntryId;
				newlineitem.Product__c = oi.Product2_ID__c;
				newlineitem.Quantity__c = oi.Quantity;
				newlineitem.Unit_Price__c = oi.UnitPrice;
				newlineitem.Position__c = oi.Position__c;
				
				newlineitem.Manufacturing_Order__c = wo.Id;
				newlineitem.Shipping_Order__c = so.Id;
				
				workorderlineitemstocreate.add(newlineitem);	
				
			} 
		}			 

		//SOQL optimization -- this might be something we can optimize. not sure  though. - ks
		if( mfoTypes.keySet().size() > 0 ) 
		{
			list<Order> orderUpdates = new list<Order>();
			for( Order o : [SELECT Id, Selected_Manufacturing_Orders__c FROM Order WHERE ID = :mfoTypes.keySet() ] )
			{
				o.Selected_Manufacturing_Orders__c = mfoTypes.get( o.Id );
				orderUpdates.add(o);
			}
			
			if( orderUpdates.size() > 0 )
				update orderUpdates;

		}

			
			
			
		if( workorderlineitemstocreate.size() > 0 )
			insert workorderlineitemstocreate;		    	

	
	}		
	
}