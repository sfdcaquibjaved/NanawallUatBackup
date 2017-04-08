@isTest
public class testfileUpload_Redirect {
    static testmethod void method1()
{
    list<Installation__c> ins = TestDataUtility.createInsTestData();
        insert ins;
         test.startTest();
         ApexPages.StandardController sc = new ApexPages.StandardController(ins[0]);
        fileUpload_Redirect objINS = new fileUpload_Redirect(sc);
        PageReference pageRef = Page.MultipleFileUpload_Redirect;
        system.Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getHeaders().put('USER-AGENT','.....iPhone....');
       
         objINS.redirect();
         test.stopTest();
    }
    
     static testmethod void method2()
{
    list<Installation__c> ins = TestDataUtility.createInsTestData();
        insert ins;
         test.startTest();
         ApexPages.StandardController sc = new ApexPages.StandardController(ins[0]);
        fileUpload_Redirect objINS = new fileUpload_Redirect(sc);
        PageReference pageRef = Page.MultipleFileUpload_Redirect;
        system.Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getHeaders().put('USER-AGENT','.....Android....');
       
         objINS.redirect();
         test.stopTest();
    }
    
}