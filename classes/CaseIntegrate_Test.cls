@IsTest
public class CaseIntegrate_Test {
    public static List < Contact > olstContact;
public static testMethod void testMyController() {
 PageReference pageRef = Page.CaseIntegration;
 Test.setCurrentPage(pageRef);
  
    Case c1=new Case();
    c1.Status='New';
    insert c1;
    
    /*Service_Quote__c sq=new Service_Quote__c();
    sq.Status__c='Order Paid';
    sq.Shopify_Order_NO__c='testnumber';
    sq.Send_Quote_To_Email__c='testa@gmail.com';
    insert sq;*/
    
    CaseIntegrate cint=new CaseIntegrate();
    cint.searchEmail='test@gmail.com';
    cint.searchstring='00079806';
    
    cint.search();
    cint.searchEmail1='testa@gmail.com';
    cint.searchServiceQuote='SQ28952';
    cint.search1();   
}
    
 public static testMethod void testMyController2() {
 PageReference pageRef = Page.CaseIntegration;
 Test.setCurrentPage(pageRef);
    Case c1=new Case();
    c1.Status='New';
    insert c1;
    
    CaseIntegrate cint=new CaseIntegrate();
    cint.search();
    cint.search1();
    
}
   public static testMethod void testMyController3() {
 PageReference pageRef = Page.CaseIntegration;
 Test.setCurrentPage(pageRef);
    
    
    Case c1=new Case();
    c1.Status='New';
    insert c1;
    
    CaseIntegrate cint=new CaseIntegrate();
    cint.searchEmail='test@gmail.com';
    cint.searchstring='00079806';
    
    cint.search();
    cint.searchEmail1='testa@gmail.com';
    cint.searchServiceQuote='OL28952';
    cint.search1();   
}
    public static testMethod void testMyController4() {
 PageReference pageRef = Page.CaseIntegration;
 Test.setCurrentPage(pageRef);
   
    
    Case c1=new Case();
    c1.Status='New';
    insert c1;
    
    CaseIntegrate cint=new CaseIntegrate();
    cint.searchEmail='test@gmail.com';
    cint.searchstring='00079806';
    
    cint.search();
    cint.searchEmail1='';
    cint.searchServiceQuote='';
    cint.search1();   
}
}