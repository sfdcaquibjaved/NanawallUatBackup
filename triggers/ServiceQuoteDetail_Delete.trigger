trigger ServiceQuoteDetail_Delete on Service_Quote_Detail__c (after delete, before delete) {

    /*
    trigger options
        service quote trigger for handling deletes
    */
    if( trigger.isAfter )
    {
        
        /* adjust the position__c of the other positions on the service quote*/
        list<id> serviceQuotes = new List<Id>();
        list<id> deletingServiceQuoteDetails = new List<Id>();
        
        
        map< Id, Decimal> sqBreakpoint = new map<Id, Decimal>();
        for( Service_Quote_Detail__c sqd :trigger.old)
        {
            serviceQuotes.add(sqd.Service_Quote__c);
            deletingServiceQuoteDetails.add( sqd.Id );
            
            //record the position number of the deleting position for later lookup
            sqBreakpoint.put( sqd.Service_Quote__c, sqd.Position__c );
            
        }

        list<Service_Quote_Detail__c> updateSqds = new List<Service_Quote_Detail__c>();
        for( Service_Quote_Detail__c sqd :   [SELECT Id, Position__c,Service_Quote__c FROM Service_Quote_Detail__c WHERE Service_Quote__c in :serviceQuotes AND Id not in :deletingServiceQuoteDetails ] )
        {
            if( sqd.Position__c > sqBreakpoint.get(sqd.Service_Quote__c) )
            {
                //only decrement the position__c if it is above the position__c of the deleted position on this service quote
                sqd.Position__c--;
                updateSqds.add(sqd);
            }
        }
        
        
        
        if( updateSqds.size() > 0 )
            update updateSqds;
        /* finish adjusting the position__c of the other position on the service quote */       
        
    } else
    {
        list<Service_Part_Inventory_Lock__c> partLocksToDelete = new List<Service_Part_Inventory_Lock__c>();
        
        partLocksToDelete = [SELECT Id FROM Service_Part_Inventory_Lock__c WHERE Service_Quote_Detail__c in :trigger.oldMap.keySet() ];
        
        if( partLocksToDelete.size() > 0)
            delete  partLocksToDelete;
    
    }

}