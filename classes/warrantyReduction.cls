/*************************************************************************\
    @ Author        : Durga Pulagam
    @ Date          : June 2016
    @ Test File     : WarrantyUpdate_Test
    Function        : Apex Class for updating the warranties based on products
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/

public class warrantyReduction{   
    /*
    Method: warrantyUpdation
    Purpose: By chance if the installer is changed from certified to Non-certified installer then actual warranty will replace the doubled warranty
    */
    public static void warrantyUpdation(List<Entitlement> entList){
        try{
        List<Entitlement> entList1 = new List<Entitlement>();
        for(Entitlement ent:entList){
            ent.Warranty_Years__c = (ent.Warranty_Years__c)/2;
            entList1.add(ent);
            system.debug('The entList1 is:::::'+entList1);
        }
        if(entList1.size()>0){
            Database.SaveResult[] srList = Database.update(entList1, false);
            ErrorLogUtility.processErrorLogs(srList, entList1,'warrantyReduction','warrantyUpdation','Entitlement','update');
            //update entList1;
        }
        }catch(Exception e){}
    }
    
    /*
    Method:warrantyCreation
    Purpose:Assiging warranty to the products
    */
    public static void warrantyCreation(List<Entitlement> entityList){
        try{
        List<Entitlement> entitleList = [select Name,Product_Name__c,Warranty_Years__c,/*Order_Product__c,*/ Contacts__c,/*Order__c*/ Nana_Quote__c,Quote_Detail__c from  Entitlement where id IN:entityList];
        system.debug('The entitleList is::::'+entitleList);
        List<id> orderItemids = new list<id>();
        List<id> instalids = new List<id>();
        List<id> accountIds = new List<id>();
        List<Entitlement> updatingEntitlements = new List<Entitlement>();
     /*  FOR(Entitlement entity:entitleList){
            orderItemids.add(entity.Order_Product__c);          
        }
        List<OrderItem> oItems = [select id,Installation__c from OrderItem where id IN:orderItemids];
        system.debug('The orderproducts are:::'+oItems);
            for(OrderItem ot:oItems){
            instalids.add(ot.Installation__c);
        }
        system.debug('the instalids are:::'+instalids);
        List<Installation__c> inst = [select id,Installer_Account__c from Installation__c where id in:instalids];
        for(Installation__c instal: inst){
            accountIds.add(instal.Installer_Account__c);
            system.debug('The accids is::'+accountIds);
        }
        List<Account> acts = [select id,Certified_Installer__c from Account where id in:accountIds];
        for(Entitlement entity:entitleList){
            for(Account act:acts){
                 if(act.Certified_Installer__c == true){
                entity.Certified_Installer__c = true; //updating the certified installer on entitlement
                updatingEntitlements.add(entity);
                }
                else{
                entity.Certified_Installer__c = false;
                updatingEntitlements.add(entity);
                }
            }
        } */ 
        
        //Below logic is for assigning the warranties based on the products
            List<Entitlement> entList = new list<Entitlement>();
            for(Entitlement ent:entitleList){
                if(ent.Name.contains(System.Label.Glass_Rollers_Model)){
                    ent.Warranty_Years__c = Integer.valueof(System.Label.Warranty_for_Glass_Rollers);
                    entList.add(ent);
                }
                else if(ent.Product_Name__c.contains(System.Label.Screen_Models)){
                    ent.Warranty_Years__c = Integer.valueof(System.Label.Warranty_for_Screens);
                    entList.add(ent);
                }
                else{
                    ent.Warranty_Years__c =Integer.valueof(System.Label.Warranty_for_Models);
                    entList.add(ent);
                }
            
                system.debug('The entList is::::::'+entList);
            }
            if(entList.size()>0){
               Database.SaveResult[] srList = Database.update(entList, false);
               ErrorLogUtility.processErrorLogs(srList, entList,'warrantyReduction','warrantyCreation','Entitlement','update');
            }
            if(updatingEntitlements.size()>0){
                update updatingEntitlements;
            }
           }catch(Exception e){}
        
     }
     /**********************************
     Method Name:warrantyUpdationforCertified
     Purpose:To double the warranties based on the installer type
     ***********************************/
     public static void warrantyUpdationforCertified(List<Entitlement> entList){
       try{
        List<Entitlement> entList1 = new List<Entitlement>();
        for(Entitlement ent:entList){
            ent.Warranty_Years__c = (ent.Warranty_Years__c)*2;
            entList1.add(ent);
            system.debug('The entList1 is:::::'+entList1);
        }
        if(entList1.size()>0){
            Database.SaveResult[] srList = Database.update(entList1, false);
            ErrorLogUtility.processErrorLogs(srList, entList1,'warrantyReduction','warrantyUpdationforCertified','Entitlement','update');
            //update entList1;
        }
        }catch(Exception e){}  
     }
 }