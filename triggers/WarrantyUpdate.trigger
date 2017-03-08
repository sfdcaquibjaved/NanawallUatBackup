/*************************************************************************\
    @ Author        : Durga Pulagam
    @ Date          : June 2016
    @ Test File     : WarrantyUpdate_Test
    Function        : Apex Trigger for updating the warranties based on products
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/
trigger  WarrantyUpdate on Entitlement (before insert,after Insert,after Update) {

    try{
    //Calling the warrantyCreation method in warrantyReduction class whenever the entitlement is inserted
    if(trigger.isAfter && trigger.isInsert){
        warrantyReduction.warrantyCreation(trigger.new); 
    }
     //Calling the warrantyUpdation method in warrantyReduction class whenever the entitlement is updated   
    if(trigger.isUpdate && trigger.isAfter){
        List<Entitlement> entitleList = [select Name,Product_Name__c,Warranty_Years__c,/*Order_Product__c,*/Contacts__c,/*Order__c,*/Certified_Installer__c,Nana_Quote__c,Quote_Detail__c from  Entitlement where id IN:trigger.new];
        //List<Entitlement> entitlelist1 = new List<Entitlement>();
        List<Entitlement> entitlelist2 = new List<Entitlement>();
        List<Entitlement> entitlelist3 = new List<Entitlement>();
        for(Entitlement ent:entitleList){
             if(!(ent.Name.contains('Roll') || ent.Product_Name__c.contains('Screen')) ){ //Entitlement name should not contain Roll and the product name not equal to screen
                 if(trigger.oldmap.get(ent.id).certified_Installer__c != ent.certified_Installer__c){ 
                    //To make the warranty to normal if the installer is changed from certified to non certified
                    if(ent.certified_Installer__c==False && trigger.oldmap.get(ent.id).Warranty_Years__c==ent.Warranty_Years__c)
                    {                       
                        entitlelist2.add(ent);
                    }
                    //To make the warranty double if the installer is certified 
                    if(ent.certified_Installer__c==TRUE && trigger.oldmap.get(ent.id).Warranty_Years__c==ent.Warranty_Years__c){
                       entitlelist3.add(ent);
                    }
                 }
              }
        }
            
            if(entitlelist2.size()>0)
            warrantyReduction.warrantyUpdation(entitlelist2);//Calling the warrantyUpdation method in Warranty Reduction class
            
            if(entitlelist3.size()>0){
            warrantyReduction.warrantyUpdationforCertified(entitlelist3);
            }
        
        
    }
        
        
        //Added by Aquib javed - for creating Entitlement Contact
         List < Entitlement > EntitlementList = new List < Entitlement > ();
        for(entitlement e : trigger.new){
         if(((Trigger.isAfter) && (trigger.isInsert)) && (e.nana_Quote__c != null)){ 
            
                EntitlementList.add(e);
             
    }
   }
         EntitlementTriggerHelper.CreateEntitlementContact(EntitlementList) ; 
        
    }catch(exception e){}
}