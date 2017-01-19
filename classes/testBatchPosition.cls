@isTest
public class testBatchPosition {
    public static list < Zip_Codes_Master__c > territorymaster;
    static testmethod void method1(){
         territorymaster = TestDataUtility.getTerritoryMaster();
         insert territorymaster;
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
         insert quotlist;
         /*list<Order> orderlist = TestDataUtility.createOrderTestData();
         for(Integer i=0;i<orderlist.size();i++){
         orderlist[i].AccountId = acclist[i].id;
         orderlist[i].Nanaquote__c = quotlist[i].id;
        }
        insert orderlist;*/
        list<Quote_Detail__c> quotedetaillist = TestDataUtility.createQuoteDetailData();
        for(Integer j=0;j<quotedetaillist.size();j++)
        {
            quotedetaillist[j].Quote__c = quotlist[j].id;
        }
        insert quotedetaillist;
        list<Installation__c> inslist = TestDataUtility.createInsTestData();
        for(Integer k=0;k<inslist.size();k++){
            inslist[k].Quote_Name__c = quotlist[k].id;
            //inslist[k].NUMBER_OF_POSITIONS__C = 0;
        }
        insert inslist;
        BatchPosition en = new BatchPosition();
        Database.executeBatch(en);
        test.stopTest();
    }
}