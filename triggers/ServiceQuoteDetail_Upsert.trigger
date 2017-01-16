trigger ServiceQuoteDetail_Upsert on Service_Quote_Detail__c (before insert, before update, after insert, after update) {

    list<Service_Part_Inventory_Lock__c> locks = new list<Service_Part_Inventory_Lock__c>();
    list<Service_Part_Inventory_Lock__c> updatelocks = new list<Service_Part_Inventory_Lock__c>();
    
    if( trigger.isBefore && trigger.isInsert )
    {
        set<Id> ServiceQuotesToCountPositions = new set<Id>();
        list<Service_Quote_Detail__c> ServiceQuotesToAutoNumber = new list<Service_Quote_Detail__c>();
        for(Service_Quote_Detail__c sqd : trigger.new )
        {
            if( sqd.Position__c == null || sqd.Position__c == 0  )
            {
                ServiceQuotesToCountPositions.add(sqd.Service_quote__c);
                ServiceQuotesToAutoNumber.add(sqd);
                sqd.Position__c = 1;
            }
        }
        
//      for( AggregateResult res : [SELECT MAX(Position__c), Service_Quote__c FROM Service_Quote_Detail__c WHERE Service_Quote__c in :ServiceQuotesToCountPositions GROUP BY Service_Quote__c ])
        for( Service_Quote_Detail__c sqd_old : [SELECT Position__c, Service_Quote__c FROM Service_Quote_Detail__c WHERE Service_Quote__c in :ServiceQuotesToCountPositions  ])
        {
            for( Service_Quote_Detail__c sqd : ServiceQuotesToAutoNumber ) 
            {
                if( sqd.Service_Quote__c == sqd_old.Service_Quote__c && sqd_old.Position__c >= sqd.Position__c)
                    sqd.Position__c = sqd_old.Position__c + 1;
            }
        }
    }

    if( trigger.isInsert && trigger.isAfter )
    {
system.debug('creating service part inventory locks ...');      
        //insert the itme part locks
        for( Service_Quote_Detail__c sqd : trigger.new )
        {
            if(sqd.Ship_From_Stock__c )
            {
                Service_Part_Inventory_Lock__c lock = new Service_Part_Inventory_Lock__c();
                lock.Quantity__c = sqd.Quantity__c;
                lock.Service_Part__c = sqd.Service_Part__c;
                lock.Service_Quote_Detail__c = sqd.Id;
                lock.Service_Quote__c = sqd.Service_Quote__c;
                lock.Status__c = ( sqd.SQ_Stock_Responsibility__c == 'nana' || sqd.SQ_Final_Payment_Date__c != null ? 'Active' : 'Pending' );

                locks.add(lock);
system.debug('added a lock for ' + sqd.Id +'; ' + sqd.Service_Quote__c + '; ' + sqd.SQ_Stock_Responsibility__c);        

            }
        }
    } else if( trigger.isAfter && trigger.isUpdate )
    {
system.debug('running after-update');       
        map<id, Service_Quote_Detail__c> sqdPartLocksToLookup = new map<id, Service_Quote_Detail__c>();
        for( Service_Quote_Detail__c sqd : trigger.new )
        {   
            Service_Quote_Detail__c oldSQD = trigger.oldMap.get( sqd.id );
            if( 
                (sqd.Quantity__c != oldSQD.Quantity__c 
                    || sqd.Ship_from_stock__c != oldSQD.Ship_From_Stock__c )
                && !sqdPartLocksToLookup.containsKey(sqd.Id)
            )
            {//OR final payment date changed ; SQ_Stock_Freight_Tracking_Number__c ; SQ_Final_Payment_Date__c
System.debug('picked up a change in the sqd');              
                sqdPartLocksToLookup.put( sqd.Id, sqd);
            }
        }
        
        if( sqdPartLocksToLookup.size() > 0 )
        {
            list<id> sqdToLockIds = new list<id>( sqdPartLocksToLookup.keySet() );
            for( Service_Part_Inventory_Lock__c lock : [SELECT Id, Quantity__c, Service_Quote_Detail__c, Service_Part__c FROM Service_Part_Inventory_Lock__c WHERE Service_Quote_Detail__c in :sqdToLockIds ] )
            {
                string Status = '';
                Service_Quote_Detail__c sqd = sqdPartLocksToLookup.get(lock.Service_Quote_Detail__c);
                if(!sqd.Ship_From_stock__c)
                {
                    status = 'Dismissed';
                }  else if(sqd.SQ_Stock_Responsibility__c == 'nana' 
                    && (sqd.SQ_Stock_Freight_Tracking_Number__c == null || sqd.SQ_Stock_Freight_Tracking_Number__c == '' ) )
                {
                    status = 'Active';
                } else
                {//SQ_Stock_Freight_Tracking_Number__c ; SQ_Final_Payment_Date__c
                    if( sqd.SQ_Stock_Freight_Tracking_Number__c != null && sqd.SQ_Stock_Freight_Tracking_Number__c != '' )
                        status = 'Committed';
                    else if( sqd.SQ_Final_Payment_Date__c != null )
                        status = 'Active';
                    else status = 'Pending';
                }
                
                lock.Status__c = status;
                lock.Quantity__c = sqd.Quantity__c;
                
                updatelocks.add(lock);
                
            }
        }
    } else
    { //the below code is from before i started doing after inserts -- need to group it to make sure stuff ain't broken; i think this should be just for BEFORE INSERT
        set<id> servicePartItemIDs = new set<id>();
        for( Service_Quote_Detail__c sqd : trigger.new )
        {
            if( !servicePartItemIDs.contains(sqd.Service_Part__c) )
                servicePartItemIDs.add(sqd.Service_Part__c );
            
        }
    
        list<id> lookupList = new list<id>(servicePartItemIDs);
        map< id, Service_Part__c> partLookup = new map<id, Service_Part__c>();
        for( Service_Part__c part : [SELECT id, Price_Overrideable__c, Retail_Cost__c FROM Service_Part__c WHERE id in :lookupList] )
        {
            partLookup.put( part.id, part);
        } 
        
        for( Service_Quote_Detail__c sqd : trigger.new )
        {
            if( sqd.service_part__c != null
            && partLookup != null
            && partLookup.containsKey(sqd.service_part__c) 
            && ( !partLookup.get(sqd.service_part__c).Price_Overrideable__c) || sqd.Unit_price__c == null )
            {
                try {
                    sqd.Unit_Price__c = partLookup.get(sqd.service_part__c).Retail_Cost__c;
                } catch( Exception ex ) 
                {
                }
            }
        }
    }
    
    
    if( locks.size() > 0 )
        insert locks;
        
    if( updatelocks.size() > 0 )
        update updatelocks;
}