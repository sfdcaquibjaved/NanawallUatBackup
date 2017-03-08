trigger ServiceQuote_Upsert on Service_Quote__c (before insert, before update, after update, after insert) {

/*
    trigger options
        service quote trigger for handling inserts and updates
*/
    //**** load up all the data that might be necessary for this trigger
    if( !TriggerVariables.ServiceQuote_Upsert_DataLoaded )
    {
        list<Id> partIdList = new list<Id>();
        if( trigger.newmap != null )
        {
            for( Service_Quote_Detail__c sqd : TriggerVariables.GetServiceQuoteDetailsFromServiceQuoteList( new list<Id>(trigger.newmap.keyset()) ) )   
            { 
                TriggerVariables.ServiceQuoteDetailMap_All.put( sqd.Id, sqd );
                partIdList.add(sqd.Service_Part__c);
            } 
        }       
        for (Service_Part__c sp : TriggerVariables.GetServicePartsByIdList(partIdList))
        {
            TriggerVariables.ServicePartMap_All.put( sp.Id, sp);
        }
        system.debug('&&&&'+TriggerVariables.ServicePartMap_All.size());
    
    }   
    
    
    //  *** these maps should be moved into the TriggerVariables to cut down on SOQL calls
    map<id,Integer> sqIdsToCheckForDecrement = new map<id,Integer>();
    map<id,boolean> sqIdsToDefintelyDecrement = new map<id,boolean>();
    map<id,Service_Part__c> partsToUpdate = new map<id,Service_Part__c>();
    list<Service_Part_Inventory_Lock__c> locksToUpdate = new list<Service_Part_Inventory_Lock__c>();

    map<Id,Service_Quote_Detail__c> serviceQuoteDetailsToUpdate = new map<Id,Service_Quote_Detail__c>(); // i put this in here to handle responsiblity changes, but it should be able to be a general container
    set<string> vendorPrice_responsibility = new Set<string>{ 'solarlux nana llc','solarlux faltsysteme', 'nanawall systems'}; //this set is the set of responsibility values that should trigger the vendor price to be used
            
    for( Service_Quote__c sq : trigger.new )
    {
        
        if( trigger.isAfter && trigger.isUpdate )
        {
            ///**** detect if the responsibility has changed
            if( sq.Responsibility__c != trigger.oldMap.get(sq.Id).Responsibility__c 
            || sq.NonStock_Responsibility__c != trigger.oldMap.get(sq.Id).NonStock_Responsibility__c )
            { //if it has changed, we need to update the prices on the service quote details
                string resp = ( sq.Responsibility__c != null ? sq.Responsibility__c.toLowerCase() : '' );
                string nonstockresp = ( sq.NonStock_Responsibility__c != null ? sq.NonStock_Responsibility__c.toLowerCase() : '' );
                boolean useVendorPrice =  ( vendorPrice_responsibility.contains(resp) || vendorPrice_responsibility.contains(nonstockresp) );
                
                for(Service_Quote_Detail__c sqd : TriggerVariables.ServiceQuoteDetailMap_All.values()  )
                {
                    if( sqd.Service_Quote__c == sq.Id)
                    { //this service quote detail is on this service quote
                        if( !serviceQuoteDetailsToUpdate.containsKey(sqd.Id) )
                        { //i am not entirely sure how these  lists are maintained; so i am making sure when we flag an update, we actually pull the object back out of the list, update it, and put it back in; i want to make sure any other updates performed in this trigger are preserved
                            serviceQuoteDetailsToUpdate.put(sqd.Id, sqd);
                        }
                        Service_Quote_Detail__c sqdUpdate = serviceQuoteDetailsToUpdate.get(sqd.Id);

                        Service_Part__c part = TriggerVariables.ServicePartMap_All.get( sqd.Service_Part__c); //pull the part out of the global map of all parts
                        if(part != null){
                        //if(part.Vendor_Cost__c !=null || part.Retail_Cost__c !=null){
                        sqdUpdate.Unit_Price__c = ( useVendorPrice ? part.Vendor_Cost__c : part.Retail_Cost__c);
                        serviceQuoteDetailsToUpdate.put(sqdUpdate.Id, sqdUpdate); //stick the updated part back into the update map. again, not sure if updating the reference updates the member in the list. no time to test it!
                       // }
                        }

                    }
                }
    
                
            }
            
            //****
                               
            if( (trigger.isInsert 
                && sq.Freight_Tracking_Number__c != null)
                || (trigger.isUpdate 
                    && ( trigger.oldMap.get(sq.id).Freight_Tracking_Number__c == null ||trigger.oldMap.get(sq.id).Freight_Tracking_Number__c == '')
                        && sq.Freight_Tracking_Number__c != null
                        && sq.Freight_Tracking_Number__c != '' ) 
                ) {
                if( !sqIdsToCheckForDecrement.containsKey(sq.id) )
                    sqIdsToCheckForDecrement.put(sq.id,-1);
                    
                sqIdsToDefintelyDecrement.put(sq.Id, true);
            } else if( trigger.isUpdate 
                && trigger.oldMap.get(sq.id).Freight_Tracking_Number__c != null 
                && trigger.oldMap.get(sq.id).Freight_Tracking_Number__c != ''
                && ( sq.Freight_Tracking_Number__c == null 
                    || sq.Freight_Tracking_Number__c == '' ) 
                ) {
                if( !sqIdsToCheckForDecrement.containsKey(sq.id) )
                    sqIdsToCheckForDecrement.put(sq.id,1);
                    
                sqIdsToDefintelyDecrement.put(sq.Id, true);
            } else if( trigger.isUpdate && sq.Final_Payment_Date__c != trigger.oldMap.get(sq.id).Final_Payment_Date__c ) 
            {
                sqIdsToCheckForDecrement.put(sq.id,1);          
                sqIdsToDefintelyDecrement.put(sq.Id, false); //we ONLY update the status on the lock at this point
            }       
        }   
    }
    
    if( trigger.isUpdate && trigger.isBefore && sqIdsToCheckForDecrement.keySet().size() > 0 )
    {

        map<id, Integer> partQuantities = new map<id, Integer>();
        set<id> partIdSet = new set<id>();
        list<id> sqIdsToCheckForDecrement_List = new list<id>( sqIdsToCheckForDecrement.keySet() );
        map<id,integer> serviceQuoteDetailsToUpdatePartLocks = new map<id,integer>();
        
        for( Service_Quote_Detail__c sqd : [SELECT Service_Part__c,Quantity__c, Service_Quote__c FROM Service_Quote_Detail__c WHERE Service_Quote__c in :sqIdsToCheckForDecrement_List] )
        { // right here you can loop over the sqIdsToCheckForDecrement_List and instead call the object out of the global TriggerVariable map. just saying.
            if( sqIdsToCheckForDecrement.containsKey(sqd.service_quote__c) )
            {
                integer sqQuantity = 0;
                if(sqd.Quantity__c != null  )
                {
                    sqQuantity = Integer.valueOf(sqd.Quantity__c);
                } else system.debug('no qunantity on this sqd');
                integer qty = sqQuantity * sqIdsToCheckForDecrement.get(sqd.service_quote__c);
            
                if(sqIdsToDefintelyDecrement.get(sqd.Service_Quote__c) == true)
                {//the sqIdsToDefintelyDecrement collection lets us know whether we are decrementing or just update the lock
    
                    if(!partQuantities.containsKey( sqd.Service_Part__c) )
                    {
                        partQuantities.put(sqd.Service_Part__c, qty);
                        partIdSet.add(sqd.Service_Part__c);
                    } else partQuantities.put( sqd.Service_Part__c,partQuantities.get( sqd.Service_Part__c) +qty );
                }

                if( !serviceQuoteDetailsToUpdatePartLocks.containsKey(sqd.Id) ) //this shouldnt happen anyway, but you never know
                    serviceQuoteDetailsToUpdatePartLocks.put( sqd.Id, qty );
            } else system.debug('SOmehow i looked up a servicequote detail without a service quote id ');
        }

        list<id> partIds_List = new list<Id>(partIdSet);
        for( Service_Part__c item : [Select s.Id, s.Number_Stocked__c, s.Stocked__c from Service_Part__c s WHERE ID in :partIds_List])
        {// right here you can look over partsIds_List and pull the object out of the global part map. just saying.
            if( item.Stocked__c && !partsToUpdate.containsKey(item.Id) && partQuantities.containsKey(item.Id) )
            {
                if( item.Number_Stocked__c == null )
                    item.Number_Stocked__c = 0;
                item.Number_Stocked__c += partQuantities.get(item.id);
                partsToUpdate.put( item.Id, item);                  
            } 
        }
        
        if( serviceQuoteDetailsToUpdatePartLocks.size() > 0 )
        {

            list<id> serviceQuoteDetailsToUpdatePartLocks_List = new List<Id>(serviceQuoteDetailsToUpdatePartLocks.keySet() );      
            for( Service_Part_Inventory_Lock__c lock : [SELECT Id,Service_Quote__c, Quantity__c, Service_Quote_Detail__c, Service_Part__c FROM Service_Part_Inventory_Lock__c WHERE Service_Quote_Detail__c in :serviceQuoteDetailsToUpdatePartLocks_List ] )
            {//need a global lookup in trigger variables for the locks  
                if(serviceQuoteDetailsToUpdatePartLocks.get(lock.Service_Quote_Detail__c) < 0 )
                    lock.Status__c = 'Committed';
                else if( trigger.newMap.get(lock.Service_Quote__c).Final_Payment_Date__c != null  
                    ||  ( trigger.newMap.get(lock.Service_Quote__c).Responsibility__c != null && trigger.newMap.get(lock.Service_Quote__c).Responsibility__c.toLowerCase().contains('nanawall systems') )
                )
                    lock.Status__c = 'Active';
                else lock.Status__c = 'Pending';

                lock.Quantity__c = Math.abs( serviceQuoteDetailsToUpdatePartLocks.get(lock.Service_Quote_Detail__c) ); //update it just in case it went out of sync
                locksToUpdate.add(lock);
            }
        }
    } 
    
    if(partsToUpdate.keySet().size() > 0 )
    {
        update partsToUpdate.values();
    }
    
    if( locksToUpdate.size() > 0 )
    {
        update locksToUpdate;
    }
    
    if(serviceQuoteDetailsToUpdate.keySet().size() > 0 )
    {
        update serviceQuoteDetailsToUpdate.values();
    }
    
 
  
}