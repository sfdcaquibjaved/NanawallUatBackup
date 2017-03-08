@isTest
public class testCorporateProjectlistCont {
        /*public static list < Zip_Codes_Master__c > territorymaster;
    static testmethod void method1(){
        territorymaster = TestDataUtility.getTerritoryMaster();
         insert territorymaster;
         list<Account> acclist = TestDataUtility.createAccountTestData();        
         insert acclist;
         list<Contact> conlist = TestDataUtility.createConTestData();
         insert conlist;
         list<Project__c> projlist = TestDataUtility.createProjectTestData();
        for(integer i=0;i<projlist.size();i++){
            projlist[i].Architect_Account__c = acclist[i].id;
        }
         insert projlist;
        Test.StartTest(); 
  PageReference pageRef = Page.CorporateAccountProjectList; // Add your VF page Name here
  pageRef.getParameters().put('objAcc', String.valueOf(acclist[0].Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
  CorporateAccountProjectListController lan = new CorporateAccountProjectListController(sc);
  lan.Proj = projlist[0].id;
  lan.showPenetration = false;
 Test.StopTest();
    }*/
}