@IsTest
public class CaseIntegrate_Test {
    public static List < Contact > olstContact;
    public static testMethod void testMyController() {
        PageReference pageRef = Page.IntegrateCase;
        Test.setCurrentPage(pageRef);
        
        Case c1=new Case();
        c1.Status='New';
        insert c1;
               
        CaseIntegrate cint=new CaseIntegrate();
        cint.searchEmail='test@gmail.com';
        cint.searchstring='00079806';
        
        cint.search();
        cint.searchEmail1='testa@gmail.com';
        cint.searchServiceQuote='SQ28952';
        cint.search1();   
    }
    
    public static testMethod void testMyController2() {
          
        PageReference pageRef = Page.IntegrateCase;
        Test.setCurrentPage(pageRef);
        
        
        Case c1=new Case();
        c1.Status='New';
        insert c1;
        
        CaseIntegrate cint=new CaseIntegrate();
        cint.searchEmail='test@gmail.com';
        //cint.searchstring='00079806';
        
        cint.search();
        //cint.searchEmail1='testa@gmail.com';
        cint.searchServiceQuote='OL28952';
        cint.search1(); 
        
    }
    public static testMethod void testMyController3() {
        PageReference pageRef = Page.IntegrateCase;
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
        PageReference pageRef = Page.IntegrateCase;
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