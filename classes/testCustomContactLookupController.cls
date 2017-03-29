@isTest
public class testCustomContactLookupController {
    static testmethod void method1(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        list<Account> acclist = TestDataUtility.createAccountTestData();
        insert acclist;
        list<Contact> conlist = TestDataUtility.createConTestData();
        insert conlist;
        test.startTest();
        PageReference pageRef = Page.CustomContactLookup;
        ApexPages.currentPage().getParameters().put('searchString', 'foo');
        Test.setCurrentPage(pageRef);
        CustomContactLookupController controller = new CustomContactLookupController();
        controller.runSearch();
        controller.performSearch('foo');
        controller.getFormTag();
        controller.getTextBox();
        controller.search();
        controller.contact = conlist[0];
        //controller.saveContact();
        controller.exitAction();
        test.stopTest();

    }
}