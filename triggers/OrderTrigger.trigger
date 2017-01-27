trigger OrderTrigger on Order (before update, after update, after insert) {
 

    
    if( trigger.isAfter && trigger.isInsert )
    {


    	//do the ridiculous order number thing
    	/*
    	Custom_Order_Number__c[] orderNumbers = [SELECT Id, US_Order_Number__c, Canadian_Order_Number__c FROM Custom_Order_Number__c LIMIT 1 FOR UPDATE];
    	Custom_Order_Number__c con = null;
    	//if it dont exist, make it. though it shoudl exist. 
    	if( orderNumbers.size() < 1 )
    	{
    		con = new Custom_Order_Number__c();
    		con.US_Order_Number__c = 1;
    		con.Canadian_Order_Number__c = 10000;
    		insert con;
    	} else 
    	{
    		con = orderNumbers[0];
    	}
*/
        // end the ridiculous order number thing
        
        map<Id, string> ordernumbermap = new map<Id, string>();
        map<Id, Id> orderidmap = new map<Id, Id>();
        list<Id> nanaquoteids = new list<Id>();         
        list<Quote__c> nanaQuotesToUpdate = new list<Quote__c>();
        list<Order> ordersToUpdate  = new list<Order>();
        for( Order o : trigger.new )
        {
            nanaquoteids.add(o.Nana_Quote_ID__c);
//            ordernumbermap.put(o.Nana_Quote_ID__c, o.OrderNumber);
system.debug('***ORDERTRIGGER: Order number/name:  ' + o.Name  + ' ; ' + o.Hidden_Another_Auto_Number__c );
            ordernumbermap.put(o.Nana_Quote_ID__c, o.Hidden_Another_Auto_Number__c);
            orderidmap.put(o.Nana_Quote_ID__c, o.Id);
            
            //ridicuous order number range thing
            /*
            if( o.ShippingCountryCode == 'CA')
            {
            	o.Ranged_Order_Number__c = con.Canadian_Order_Number__c;
            	con.Canadian_Order_Number__c++;
            } else
            {
            	o.Ranged_Order_Number__c = con.US_Order_Number__c;
            	con.US_Order_Number__c++;
            
            }
            
            ordersToUpdate.add(o);
            */
        }
        for( Quote__c nq: [SELECT Id, Order_Number__c FROM Quote__c WHERE Id = :nanaquoteids] )
        {
        	//turn off for backfill
            nq.Order_Number__c  = Decimal.valueOf(ordernumbermap.get(nq.Id) ); 

            nq.Ordered__c  = true;
            nq.Order__c = orderidmap.get(nq.Id);

System.debug('***ORDERTRIGGER:Updated NQ from Order trigger. Order Number: ' + ordernumbermap.get(nq.Id) + ' (= '+nq.Order_Number__c+') ; Order__c = ' + orderidmap.get(nq.Id) );
            nanaQuotesToUpdate.add( nq );
System.debug('***ORDERTRIGGER:UPDATED!');            
        }

        //during data backfill this needs to be disabled 
        if( nanaQuotesToUpdate.size() > 0 )
            update nanaQuotesToUpdate;
            
 		// now to do the updates for the ridiculous order range thing
 		/*
 		if( ordersToUpdate.size() > 0  )
 		{
			update ordersToUpdate;
			update con;
 		} 
 		*/          
            
            
    } else  if( trigger.isAfter && trigger.isUpdate ) 
    {
        
        Contact dummyContact  = [SELECT Id FROM Contact WHERE LastName = 'CAD EMAIL RECIPIENT' LIMIT 1];
        
        map<Id, Order> NanaQuotesIdsToUpdate = new map<Id,Order>();
        list<Task> tasksToInsert = new list<Task>(); 
        map< Id, Account> pipelineEmails = new map<id, Account>();

        for( Order o : trigger.new )
        {
            
            if( o.Test_GUID__c != trigger.oldMap.get(o.Id).Test_GUID__c )
            { //the order finalized date was set
                
/*                if( !pipelineEmails.containsKey(o.Id) 
                    || pipelineEmails.get(o.Id) == null
                    || pipelineEmails.get(o.Id).Company_Email__c == null  )
                    */
                    if( 
                    o == null
                    || o.Installer_Email__c == null)
                    {
                        system.debug('No installer email found for order ' + o.Id );
                        continue;
                    }
                    
                system.debug('sending CAD email to  ' + pipelineEmails.get(o.Id) );
//Quote.Nana_Quote__r.Installer__r.Company_Email__c             
				try
				{
	                pp_EmailFlowUtility.sendTemplatedEmail( new string[]{ o.Installer_Email__c  }, new string[]{  'jurgen@nanawall.com', 'gabepaulson@yahoo.com' }, 'Quote_2_0_CAD_EMAIL_TEMPLATE', dummyContact.Id, o.Id,  '0D2A0000000TNUg' , false, null );//setting System as WhoId to get past stupid limitations
	                Task tsk = new Task();
	                tsk.WhatId = pipelineEmails.get(o.Id).Id;
	                tsk.OwnerID = pipelineEmails.get(o.Id).OwnerID;
	                tsk.Subject = 'CAD Email Sent for Order ' + o.Name;
	                tsk.Description = '';
	                
	                tasksToInsert.add( tsk ); 
	                
				}catch (Exception ex )
				{
					system.debug('** Order Trigger: An exception occurred when trying to send an installer email: ' + ex );
				}
//              pp_EmailFlowUtility.sendTemplatedEmail( new string[]{ pipelineEmails.get(o.Id).Company_Email__c }, new string[]{}, 'Quote_2_0_CAD_EMAIL_TEMPLATE', dummyContact.Id, o.Id,  '0D2A0000000TNUg' , false, null );//setting System as WhoId to get past stupid limitations
                
            }
           
            system.debug('QuoteID: ' + o.QuoteId+'  ; NanaQuote: ' + o.Nana_Quote_ID__c);           
            
            if( o.Nana_Quote_ID__c !=  null )
                NanaQuotesIdsToUpdate.put(o.Nana_Quote_ID__c,o);
                
        }
        if( tasksToInsert.size() > 0 )
            insert tasksToInsert;
        
        system.debug(NanaQuotesIdsToUpdate.keySet().size() + ' quotes need syncing.');
        if( NanaQuotesIdsToUpdate.keySet().size() > 0 )
        {
            list<Quote__c> quotesToUpdate = new list<Quote__c>();
            for( Quote__c q : [SELECT  Average_Discount__c, Balanced_Received_Date__c, Calculated_City__c, Calculated_State__c, Contact__c, Deposit_Date__c, Deposit_Received_Date__c, Invoices_Sent_Date__c, Order_Confirmation_Started__c, Order_Finalized_Date__c, Order_Number__c, ordered__c , Panel_Count__c, Project__c, Quote_ID__c, SubTotal__c FROM Quote__c WHERE ID = :NanaQuotesIdsToUpdate.keySet() ] )
            {
    
                Order o = NanaQuotesIdsToUpdate.get(q.Id);
    
                q.Balanced_Received_Date__c = o.Balance_Received_Date__c;
                q.Deposit_Date__c = o.Deposit_Date__c;
                q.Deposit_Received_Date__c = o.Deposit_Received_Date__c;
                q.Invoices_Sent_Date__c = o.Invoices_Sent_Date__c;
                q.Order_Finalized_Date__c = o.Order_Finalized_Date__c;
                q.Order_Number__c = Integer.valueOf(o.Name);
                quotesToUpdate.add(q);

            }
            //during data backfill this needs to be disabled
           //update quotesToUpdate;
 
        }

        
    } else  if( trigger.isBefore && trigger.isUpdate )
    {
        map<Id, list<Manufacturing_Order__c>> manufacturingOrderMap = new map<Id, list<Manufacturing_Order__c>>();
        map<Id, list<Shipping_Order__c>> shippingOrderMap = new map<Id, list<Shipping_Order__c>>();
        
        integer totalmfs = 0;
        for( Manufacturing_Order__c mo : [SELECT Id, Order__c, Factory_Completion_Date__c, Status__c, Work_Order_Sent__c,Work_Order_Received__c FROM Manufacturing_Order__c WHERE Order__c = :trigger.new ])
        { 
            if( !manufacturingOrderMap.containsKey( mo.Order__c) )
            {
                manufacturingOrderMap.put( mo.Order__c, new list<Manufacturing_Order__c>() );
            }
            manufacturingOrderMap.get(mo.Order__c).add( mo );
            totalmfs++;
        }
        
        system.debug('ORDERTRIGGER: Got ' + manufacturingOrderMap.size() + ' orders with manufacturingorders and ' + totalmfs + ' total manufacturing orders'  );
        
        for( Shipping_Order__c so : [SELECT Id,Order__c,Actual_Delivery_Date__c, Actual_Pickup_Date__c, Status__c FROM Shipping_Order__c WHERE Order__c = :trigger.new ])
        {
            if( !shippingOrderMap.containsKey( so.Order__c) )
            {
                shippingOrderMap.put( so.Order__c, new list<Shipping_Order__c>() );
            }
            shippingOrderMap.get(so.Order__c).add( so );
        }
        
        list<Shipping_Order__c> shippingOrdersToUpdate = new list<Shipping_Order__c>();
        list<Manufacturing_Order__c> manufacturingOrdersToUpdate = new list<Manufacturing_Order__c>();      
        list<Id> orderIdsToUpdate = new list<Id>();
        
        for( Order o : trigger.new )
        {
System.debug('***ORDERTRIGGER: In the o loop:  ' + o.Quote_Name__c );
            //pipeline updates 
            Order_Trigger_Helper.OrderStageAggregate osa = new Order_Trigger_Helper.OrderStageAggregate();
            osa.o = o;
            osa.oldO = trigger.oldMap.get(o.Id);
            osa.manufacturingOrders = manufacturingOrderMap.get( o.Id );
            osa.shippingOrders = shippingOrderMap.get( o.Id );
            system.debug('setting stages for order ' + o.Id);
            Order_Trigger_Helper.SetStages( osa );
            system.debug('done setting stages for order ' + o.Id);
            
            if( o.Stage__c != trigger.oldMap.get(o.Id).Stage__c )
            {
                osa.mfrOrdersNeedUpdating = true;
                osa.shippingOrdersNeedUpdating = true;
            }
            
            if(  osa.mfrOrdersNeedUpdating)
            {
                 manufacturingOrdersToUpdate.addAll( osa.manufacturingOrders);
                 orderIdsToUpdate.add(o.Id);
            }
            if(  osa.shippingOrdersNeedUpdating)
            {
                 shippingOrdersToUpdate.addAll( osa.shippingOrders);
                 orderIdsToUpdate.add(o.Id);
            }
            // end pipeline updates         
            
            if( o.Order_Finalized_Date__c != null && trigger.oldMap.get(o.Id).Order_Finalized_Date__c == null )
            { //the order finalized date was set
                 
                //(1) update GUUID
                Blob aes = Crypto.generateAesKey(128);
                String hex = EncodingUtil.convertToHex(aes);                
                
                o.Test_GUID__c = hex;
                                
                //(2) Tell nana about the GUUID
System.debug('***ORDERTRIGGER: About to call the doCallout Method  ' + o.Quote_Name__c );
                
                pp_EmailFlowUtility.doCallout(o.Quote_Name__c, hex);
            }
        }

        //look for fields that need to be update on the nana quote -- need these for the Total Order Report
        map<Id, Order> OrderUpdateMap = new map<Id,Order>();
        for( Order o : trigger.new )
        {
            if( 
                o.Invoices_Sent_Date__c != trigger.oldMap.get(o.Id).Invoices_Sent_Date__c 
                || o.Deposit_Date__c != trigger.oldMap.get(o.Id).Deposit_Date__c 
                || o.Balance_Received_Date__c != trigger.oldMap.get(o.Id).Balance_Received_Date__c 
                || o.Deposit_Received_Date__c != trigger.oldMap.get(o.Id).Deposit_Received_Date__c 
                || o.Order_Confirmation_Started__c != trigger.oldMap.get(o.Id).Order_Confirmation_Started__c 
            ) {
                OrderUpdateMap.put( o.Nana_Quote_ID__c, o);
            }
            
        }

        if(OrderUpdateMap.keySet().size() > 0 )
        {
            list<Quote__c> nanaQuoteUpdates = [ SELECT Id,Invoices_Sent_Date__c,Deposit_Date__c,Balanced_Received_Date__c,Deposit_Received_Date__c,Order_Confirmation_Started__c,Order_Finalized_Date__c FROM Quote__c WHERE Id = :OrderUpdateMap.keySet() ];
            for( Quote__c q : nanaQuoteUpdates )
            {
                Order o = OrderUpdateMap.get(q.Id);
                q.Invoices_Sent_Date__c = o.Invoices_Sent_Date__c ;
                q.Deposit_Date__c = o.Deposit_Date__c; 
                q.Balanced_Received_Date__c = o.Balance_Received_Date__c; 
                q.Deposit_Received_Date__c = o.Deposit_Received_Date__c;
                q.Order_Confirmation_Started__c = o.Order_Confirmation_Started__c;
                q.Order_Finalized_Date__c = o.Order_Finalized_Date__c;
            } 
             
            update nanaQuoteUpdates;
        } 
        
        //end updating nanaquote


        //flag pipeline updates
        if(manufacturingOrdersToUpdate.size() > 0 && !Order_Trigger_Helper.futureMethodRunning)
            Order_Trigger_Helper.doMfrOrderUpdates(orderIdsToUpdate);

        if(shippingOrdersToUpdate.size() > 0  && !Order_Trigger_Helper.futureMethodRunning)
             Order_Trigger_Helper.doShippingOrderUpdates( orderIdsToUpdate );
    
    } else if( trigger.isBefore && trigger.isInsert )
    {
 
    	
        for( Order o : trigger.new )
        {
            //this needs to be commented out for backfill
            o.Status = 'Order Created';
            

           
        }
    }
    
   
   
    
       
    
}