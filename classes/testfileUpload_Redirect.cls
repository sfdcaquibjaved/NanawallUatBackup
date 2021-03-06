@isTest
public class testfileUpload_Redirect {
    static testmethod void method1()
{
    list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        Project__c prolist = new Project__c();
        prolist.Project_Zip_Code__c = '94040';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Installation__c> instlist = TestDataUtility.createInsTestData();
        for(Integer i=0;i<instlist.size();i++){
            instlist[i].Project__c = prolist.id;
        }
        insert instlist;
         test.startTest();
         ApexPages.StandardController sc = new ApexPages.StandardController(instlist[0]);
        fileUpload_Redirect objINS = new fileUpload_Redirect(sc);
        PageReference pageRef = Page.MultipleFileUpload_Redirect;
        system.Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getHeaders().put('USER-AGENT','.....iPhone....');
       
         objINS.redirect();
         test.stopTest();
    }
    
     static testmethod void method2()
{
    list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;    
    insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        Project__c prolist = new Project__c();
        prolist.Project_Zip_Code__c = '94040';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Installation__c> instlist = TestDataUtility.createInsTestData();
        for(Integer i=0;i<instlist.size();i++){
            instlist[i].Project__c = prolist.id;
        }
        insert instlist;
         test.startTest();
         ApexPages.StandardController sc = new ApexPages.StandardController(instlist[0]);
        fileUpload_Redirect objINS = new fileUpload_Redirect(sc);
        PageReference pageRef = Page.MultipleFileUpload_Redirect;
        system.Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getHeaders().put('USER-AGENT','.....Android....');
       
         objINS.redirect();
         test.stopTest();
    }
    static testmethod void method3()
{
    list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
    list<case> cas = TestDataUtility.createCaseTestData();
        insert cas;
         test.startTest();
         ApexPages.StandardController sc = new ApexPages.StandardController(cas[0]);
        fileUpload_RedirectCase objCAS = new fileUpload_RedirectCase(sc);
        PageReference pageRef = Page.MultipleFileUpload_RedirectCase;
        system.Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getHeaders().put('USER-AGENT','.....iPhone....');
       
         objCAS.redirect();
         test.stopTest();
    }
    static testmethod void method4()
{
    list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
    list<Case> cas = TestDataUtility.createCaseTestData();
        insert cas;
         test.startTest();
         ApexPages.StandardController sc = new ApexPages.StandardController(cas[0]);
        fileUpload_RedirectCase objCAS = new fileUpload_RedirectCase(sc);
        PageReference pageRef = Page.MultipleFileUpload_RedirectCase;
        system.Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getHeaders().put('USER-AGENT','.....Android....');
       
         objCAS.redirect();
         test.stopTest();
    }
}