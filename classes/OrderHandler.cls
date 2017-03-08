/*************************************************************************\
    @ Author        : Durga Pulagam
    @ Date          : August 2016
    @ Test File     : N/A
    Function        : Apex Class for creating Entitlements
    Related triggers: updateQuoteStageTrigger
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/
public class OrderHandler{

    //To create entitlements for the order products
    public static void createEntitlement(set<id> orderset){
    
        List<Order> orderList = [select id, Accountid, Status, Balance_Received_Date__c from Order where id IN:orderset];
        //To fetch the order products based on the order id
        List<OrderItem> oItemList = [select id, Product2_id__c,Order.id, OrderId,Order.AccountId,Product_Name__c,Order.Name,OrderItemNumber,Order.Contact__r.id from OrderItem where OrderId IN:orderList];
        List<Entitlement> entitleList = new List<Entitlement>(); 
        
        //Custom setting for holding products which have rollers
        EntitlementWarranty__c entwar = EntitlementWarranty__c.getOrgDefaults();
        Map<string,EntitlementWarranty__c> mp = EntitlementWarranty__c.getAll();
        
        for(Order od:orderList){
        for(OrderItem oItem:oItemList){
        system.debug('The custom setting'+mp.containskey(oItem.Product_Name__c));
        //If the product is in custom setting of the rollers, create two entitlements for the two positions which have rollers
            if(mp.containskey(oItem.Product_Name__c)){                         
                Entitlement et = new Entitlement();
                et.Name= oItem.OrderItemNumber + ' '+oItem.Product_Name__c;
                et.accountid = oItem.Order.AccountId;
                et.Order_Product__c = oItem.id;
                et.Order__c = oItem.Order.id;
                et.Contacts__c = oItem.Order.Contact__r.id;
                et.StartDate = od.Balance_Received_Date__c;
                et.SlaProcessId = system.Label.Sla_Process;
                entitleList.add(et);
                         
                Entitlement Entitle1 = new Entitlement();
                Entitle1.nAME = oItem.OrderItemNumber + ' '+oItem.Product_Name__c + ' ' +'Roller';
                Entitle1.accountid =  oItem.Order.AccountId;
                Entitle1.Order_Product__c = oItem.id;
                Entitle1.Order__c = oItem.Order.id;  
                Entitle1.Contacts__c = oItem.Order.Contact__r.id;
                Entitle1.StartDate = od.Balance_Received_Date__c;  
                Entitle1.SlaProcessId = system.Label.Sla_Process;                    
                entitleList.add(Entitle1);
                system.debug('***********entitleList****'+entitleList);
             }  
             else{ //If the product doesn't have any rollers then create only one entitlement
                Entitlement Entitle2 = new Entitlement();
                Entitle2.Name = oItem.OrderItemNumber + ' '+oItem.Product_Name__c;
                Entitle2.accountid =  oItem.Order.AccountId;
                Entitle2.Order_Product__c = oItem.id;
                Entitle2.Order__c = oItem.Order.id;  
                Entitle2.Contacts__c = oItem.Order.Contact__r.id;  
                Entitle2.StartDate = od.Balance_Received_Date__c;  
                Entitle2.SlaProcessId = system.Label.Sla_Process;                    
                entitleList.add(Entitle2);
                }
         }
         }  
         system.debug('Entitlelist size is::'+entitleList.size());
          if(entitleList.size()>0){ //Null pointer check exception
              system.debug('*******::'+entitleList.size());
            //Database.SaveResult[] srList = Database.insert(entitleList, false);
            //ErrorLogUtility.processErrorLogs(srList, entitleList,'createEntitlement','createEntitlement','Entitlement','insert');          
           insert entitleList;
           }
    } 
}