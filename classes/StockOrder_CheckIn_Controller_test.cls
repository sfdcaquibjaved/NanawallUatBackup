@isTest
public class StockOrder_CheckIn_Controller_test {
    public static testMethod void myunittest1(){
        
      Stock_Order__c so = new Stock_Order__c();
        so.ETA__c = system.today();
        //so.Service_Quote__c = 'SQ19191'; 
        //so.Freight__c = 100;
        insert so;
        
        Service_Part__c sp = new Service_Part__c ();
        sp.Name = 'Testservice';
        sp.Part_Name__c = 'Testservice1';
        insert sp;
        
        Stock_Order_Detail__c sd = new Stock_Order_Detail__c();
        sd.Stock_Order__c = so.id;
        sd.Service_Part__c = sp.id;
        insert sd;
        
       Attachment attach = new Attachment();
  //  attach.body = ;
    attach.Name = 'Att1';
    attach.ParentId = sp.id;
    attach.Body = Blob.valueOf('Unit Test Attachment Body');
        
        
        insert attach;
                  
        
        test.startTest();
        PageReference Pcon = Page.StockOrder_CheckIn;
        Test.setCurrentPage(Pcon);
        ApexPAges.StandardController sc = new ApexPages.StandardController(so);
        StockOrder_CheckIn_Controller testcontroller = new StockOrder_CheckIn_Controller(sc);
        StockOrder_CheckIn_Controller.StockOrder_Detail_Wrapper WRAP = new StockOrder_CheckIn_Controller.StockOrder_Detail_Wrapper();
        testcontroller.backToStockOrder();
        testcontroller.doCheckIn_OverrideQty();
        test.stopTest();

        
    }

}