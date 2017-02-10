trigger ServiceQuoteTrigger on Service_Quote__c (before insert,before Update,after insert ,after update) {

//added by Durga
//Trigger this method to update the tax rates based on ship to state field on both shopify and custom service quotes on update and insert
    

if (trigger.isAfter && (trigger.isUpdate || trigger.isInsert)) {
    List < Service_Quote__c > sqList = [select id, TaxRate__c, Case__c, RecordType.Name, Shopify_Ship_To_State__c, Ship_To_State__c from Service_Quote__c where id IN: trigger.new];
    
    if (sqList != null && sqList.size() > 0 && trigger.isUpdate)
        SQ_TaxRates.updateTaxRates(sqList, trigger.oldmap);

    if (sqList != null && sqList.size() > 0 && trigger.isInsert)
        SQ_TaxRates.updateTaxRatesbefore(sqList);

    system.debug('The sqlist1 is:::' + sqList);
}

//Added by satish lokin
//trigger this method to update quote on shopify service quote on insert
if (trigger.isBefore && trigger.isInsert) {
    list < Service_Quote__c > sqList2 = new list < Service_Quote__c > ();
    for (Service_Quote__c sq: trigger.new) {
    if(sq.recordtypeid == Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId()){
        sqList2.add(sq);
    }
    }
    if (sqList2.size() > 0) {
        CaseAddressToShopifyOnCreation.updateQuoteFromCase(sqList2);
    }

}
//added by satish
if (trigger.isBefore && trigger.isInsert) {
//trigger this method to update bill to and ship to address section on service quote on insert 
    CaseAddressToShopifyOnCreation.SqAdrsFromCase(trigger.new);
//trigger this method to update order based on quote on insert
    CaseAddressToShopifyOnCreation.updateOrderInfoBasedOnQuote(trigger.new);

}
//added by satish  
//trigger this method to update order info based on quote update on both custom and shopify service quotes on update

if (trigger.isBefore && trigger.isUpdate) {
    list < Service_Quote__c > sqList = new list < Service_Quote__c > ();
    for (Service_Quote__c sq: trigger.new) {
        if (trigger.isBefore && (trigger.isUpdate && (trigger.oldMap.get(sq.id).Quote__c != sq.Quote__c))) {
            sqList.add(sq);
        }
    }
    //null check if contains sq where quote lookup is changed
    if (sqList.size() > 0) {
    
        CaseAddressToShopifyOnCreation.updateOrderInfoBasedOnQuote(sqList);
    }
}

}