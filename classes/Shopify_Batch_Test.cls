@isTest(SeeAllData = false)
public class Shopify_Batch_Test {
    static testMethod void testDoPost() {

        //Insert test data
        case c = new
        case ();
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        c.Send_Quote_To__c = 'End Customer';
        c.Ship_To__c = 'End Customer';
        c.Bill_To__c = 'End Customer';
        insert c;

        case cc = [select id, CaseNumber from case where id = : c.id];
        Service_Quote__c sq = new Service_Quote__c();
        sq.Discount__c = 10;
        sq.Case__c = c.id;
        sq.shopify__c = true;
        sq.recordtypeid = Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId();
        sq.Status__c = 'Order Created';
        sq.Shopify_ID__c = '2853431619';
        sq.Total_Amount__c = 569;
        insert sq;
        test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_CustomerCreate());

        HttpResponse res = CalloutClass_ShopifyBatch.getInfoFromExternalService();
        Database.executeBatch(new ShopifyBatch(), 10);


        test.stopTest();
    }
}