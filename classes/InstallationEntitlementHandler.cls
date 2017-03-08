public class InstallationEntitlementHandler{
    /*public static void updateEntitlement(List<Installation__c> instalList){
        List<Installation__c> installationList = [select id,Installation_Date__c,Shipping_Order__C,Shipping_Order__r.Actual_Delivery_Date__c,Order_Number__c, Assigned_to__c,Rejected_By_Customer__c, Rejected_by_Installer__c,Actual_Delivery_Date__c from Installation__c where id IN:instalList];
        system.debug('The instalList is::::::'+instalList);
        set<id> shippingIds = new set<id>();
        for(installation__c instal:installationList){
            shippingIds.add(instal.Shipping_Order__c);
        }
        system.debug('The shippingIds are:::'+shippingIds);
        List<Manufacturing_Order_Position__c> mlist = [select id, Product__c, Order__c from Manufacturing_Order_Position__c where Manufacturing_Order__c IN(select Manufacturing_Order__c from Shipping_Order__C where id in:shippingIds)];
        system.debug('The morder is:::::::'+mlist);
        List<string> mlist2 = new List<string>(); 
        set<id> orderids = new set<id>(); 
        for(Manufacturing_Order_Position__c mlist1:mlist){
            string digi = mlist1.Product__c;           
            mlist2.add(digi.substring(0, 15));
            orderids.add(mlist1.Order__c);
          }   
        system.debug('The Orders are:::::::'+orderids);
        system.debug('The Order products are::::::::'+mlist2);   
        
       List<OrderItem> oProduct = [select id, Product2_id__c,Order.id, OrderId,Order.AccountId,Product_Name__c,Order.Name from OrderItem where (Product2_id__c in:mlist2 AND OrderId in:orderids)];
       system.debug('Order products are::::::::'+oproduct);
       List<Entitlement> entList = [select StartDate,Order_Product__c,Order__c from Entitlement where Order_Product__c IN:oProduct]; 
       system.debug('The entitlements are::::::::'+entList); 
       }  */
}