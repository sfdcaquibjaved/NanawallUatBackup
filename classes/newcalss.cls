public class newcalss {
    public void newmethod1(){
        
    
Id devRecordTypeId = Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify_Service_Quote__c').getRecordTypeId();
        system.debug(devRecordTypeId);
}
}