@istest
public class testServiceQuoteTrigger {
    static testmethod void method1(){
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        list<Account> acclist = TestDataUtility.createAccountTestData();
        insert acclist;
        list<Contact> conlist = TestDataUtility.createConTestData();
        insert conlist;
        list<Project__c> projlist = TestDataUtility.createProjectTestData();
        insert projlist;
        list<Opportunity>  opplist = TestDataUtility.createOppTestData();
        insert opplist;
        test.startTest();
        list<Quote__c> quotlist = TestDataUtility.createQuoteRecords(opplist);
        quotlist[0].order_number__c = 896593;
        insert quotlist;
        
        list<Case> caselist = TestDataUtility.createCaseTestData();
        for(Integer i=0;i<quotlist.size();i++){
            caselist[i].Quote__c = quotlist[i].id;
        }
        insert caselist;
        
        list<Service_Quote__c> sqlist = TestDataUtility.createServiceQuoteTestData();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Service_Quote__c' and Name = 'Shopify Service Quote'].Id;
        for(Integer j=0;j<sqlist.size();j++){
            sqlist[j].Case__c = caselist[j].id;
            sqlist[j].Quote__c = quotlist[j].id;
            sqlist[j].recordTypeId = strRecordTypeId;
        }
        insert sqlist;
       
        sqlist[0].Quote__c = quotlist[1].id;
        update sqlist[0];
        test.stopTest();
    }
}