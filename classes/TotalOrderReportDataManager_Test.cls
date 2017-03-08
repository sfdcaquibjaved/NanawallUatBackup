@isTest
public class TotalOrderReportDataManager_Test {
    public static testMethod void myunitTest(){
        string LastBuildResult='test';
        test.startTest();
        PageReference Pcon = Page.TotalOrderReportDataManager;
        Test.setCurrentPage(Pcon);
        //ApexPAges.StandardController sc = new ApexPages.StandardController(sd);
        TotalOrderReportDataManager_Controller testcontroller = new TotalOrderReportDataManager_Controller();
        testcontroller.YearToRun=string.valueof(1);
        testcontroller.YearSegmentToRun=string.valueof(1);
        testcontroller.rebuildData();
        //testcontroller.rescheduleCron();
        
        
        //testcontroller.LastBuildResult='INIT';
        //testcontroller.YearSegmentToRun='test';
        //testcontroller.TotalOrderReportManager2.ActualRun(1,1);
        //testcontroller.LastBuildResult='';
        //testcontroller.rescheduleCron();
        //testcontroller.TotalOrderReportManager2.ActualRun();
        //testcontroller.TotalOrderReportManager2.ActualRun();
        //testcontroller.rescheduleCron();
        test.stopTest();
    }
    
   public static testMethod void myunitTest1(){
        string LastBuildResult='test';
        test.startTest();
        PageReference Pcon = Page.TotalOrderReportDataManager;
        Test.setCurrentPage(Pcon);
        //ApexPAges.StandardController sc = new ApexPages.StandardController(sd);
        TotalOrderReportDataManager_Controller testcontroller = new TotalOrderReportDataManager_Controller();
        testcontroller.rebuildData();
        //testcontroller.LastBuildResult='INIT';
        //testcontroller.YearSegmentToRun='test';
        test.stopTest();
    }
}