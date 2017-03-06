trigger StockOrder_Detail_Delete on Stock_Order_Detail__c (after delete, before delete) {

    if( trigger.isAfter )
    {
        
        /* adjust the position__c of the other positions on the service quote*/
        list<id> stockOrders = new List<Id>();
        list<id> deletingStockOrderDetails = new List<Id>();
        
        map< Id, Decimal> soBreakpoint = new map<Id, Decimal>();
        for( Stock_Order_Detail__c sqd :trigger.old)
        {
            stockOrders.add(sqd.Stock_Order__c);
            deletingStockOrderDetails.add( sqd.Id );
            
            //record the position number of the deleting position for later lookup
            soBreakpoint.put( sqd.Stock_Order__c, sqd.Position__c );
            
        }

        list<Stock_Order_Detail__c> updateSods = new List<Stock_Order_Detail__c>();
        for( Stock_Order_Detail__c sqd :   [SELECT Id, Position__c,Stock_Order__c FROM Stock_Order_Detail__c WHERE Stock_Order__c in :stockOrders AND Id not in :deletingStockOrderDetails ] )
        {
            if( sqd.Position__c > soBreakpoint.get(sqd.Stock_Order__c) )
            {
                //only decrement the position__c if it is above the position__c of the deleted position on this service quote
                sqd.Position__c--;
                updateSods.add(sqd);
            }
        }
        
        
        
        if( updateSods.size() > 0 )
            update updateSods;
        /* finish adjusting the position__c of the other position on the service quote */       
        
    } else if( trigger.isBefore )
    {
    
    }
}