trigger updateQuoteStageTrigger on Order (before insert,after insert , after update) {
    
    /********************
    Added by satish Lokinindi
    Created to Update stages on Quote/Opportunity/Project object based on Changes on Order object
    *********************/
   if(trigger.isAfter){
        Set<ID> qIdList = new Set<ID>();
         Set<ID> pSetIds = new Set<ID>();
         Set<ID> oSetIds = new Set<ID>();
         
        map<Id,String> mapStatus = new  map<Id,String>();
        for(Order ord : trigger.New){
        if(trigger.isInsert || (trigger.isUpdate && trigger.oldMap !=  null && trigger.oldMap.get(ord.id).Status!=ord.Status ) ){
        system.debug('HEREYOUARE');
        system.debug('The status is::'+ord.Status);
        //Check for orders that are activated
             if(((ord.Status!=null||ord.Status!='')&& ord.Status != 'Draft') ){
                 qIdList.add(ord.NanaQuote__c);
                 pSetIds.add(ord.Project__c);
                 oSetIds.add(ord.OpportunityID);
                 mapStatus.put(ord.id,ord.Status);
             }
           }
        }
        //To update the stages on Opportunity ,Project and Quote based on changes in Order
        system.debug('The mapstatus is::'+mapStatus);
        system.debug('The oSetIds is:'+oSetIds);
        //Null Check
        if(qIdList.size()>0 && oSetIds.size()>0 && pSetIds.size()>0 ){
        OrderTriggerStagesHelper.UpdateQuoteStages(qIdList,mapStatus);//method to update the Quote stage ,passing params quote id and map of stages
        OrderTriggerStagesHelper.UpdateOppStages(oSetIds,mapStatus);//method to update the Opp stage ,passing params Opp id and map of stages
        OrderTriggerStagesHelper.UpdateProjStagesFromOpportunity(pSetIds,mapStatus);//method to update the Project stage ,passing params Project id and map of stages
        }
         
         
        
    }
    
    // for  creating Installation if Order finalized date is filled
    // Added by Aquib Javed
      List < order > OrderList = new List < Order > ();
      List < order > updateInstallationList = new List < Order > ();
      set< ID > newOrderID = new set <ID > () ;
    if((trigger.isUpdate && trigger.isAfter) || ((trigger.isInsert)&&(trigger.isAfter)) ){
        for(Order o : trigger.new){
            if(((trigger.isUpdate && trigger.isAfter) && (trigger.oldMap.get(o.ID).Order_Finalized_Date__c !=o.Order_Finalized_Date__c) && (trigger.oldMap.get(o.ID).Order_Finalized_Date__c == null) ) || ((trigger.isInsert)&&(trigger.isAfter)&&(o.Order_Finalized_Date__c != null))){
                OrderList = Trigger.newMap.values();
                system.debug('Inside After update');
            }
            if((trigger.isUpdate && trigger.isAfter) && (trigger.oldMap.get(o.ID).Order_Finalized_Date__c != null) && (trigger.oldMap.get(o.ID).Order_Finalized_Date__c != o.Order_Finalized_Date__c )  ){
                updateInstallationList = Trigger.newMap.values();
                newOrderID = Trigger.newMap.keyset();
            }
            
        }
        if(OrderList.size() > 0 ){
        //trigger this method to create installation if order finalized date is changed from null
            OrderTriggerHandler.CreateInstallation(OrderList);
        }
        if((updateInstallationList.size() > 0)  && (newOrderID.size() > 0) ){
        //trigger this method to update installation if order finalized date is changed in value
            OrderTriggerHandler.UpdateInstallation(newOrderID , updateInstallationList) ;       
         }
     }
    
    
    
    //*********CODE COMMENTED************//
    //Below logic is for creating Entitlements when the order is Delivered and Balance amount is received
   //Added by Durga
   
   /*
   try{
     set<id> orderidset = new set<id>();
     if((trigger.isAfter && trigger.isUpdate)||(trigger.isAfter && trigger.isInsert)){
        for(Order od:trigger.new){           
            if(trigger.oldmap.get(od.id).Status != null && trigger.oldmap.get(od.id).status != 'Paid/Delivered' && od.Status == 'Paid/Delivered' && od.Balance_Received_Date__c != null){
                orderidset.add(od.id);
            }
        }     
        //Checking null pointer exception
        if(orderidset.size()>0){
          OrderHandler.createEntitlement(orderidset); //Calling the createEntitlement method by passing the orders as parameters
        }
     }    
    }catch(Exception e){} 
    */
    //*********CODE COMMENTED************//
    
    //Method to update
    //Added by Satish lokin
   if(trigger.isBefore && trigger.isInsert){
      //OrderTriggerStagesHelper.updateOrderNumber(trigger.new);
      OrderTriggerStagesHelper.updateOrderNumberBasedonManufacturing(trigger.new);
   }
   
    
}