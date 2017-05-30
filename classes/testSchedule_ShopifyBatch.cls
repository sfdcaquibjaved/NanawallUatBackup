@isTest
public class testSchedule_ShopifyBatch {
    static testmethod void method1(){
        test.StartTest();
        Schedule_ShopifyBatch sh1 = new Schedule_ShopifyBatch();
        String sch = '0 0 01 * * ?'; 
        system.schedule('Shopify Batch Job', sch, sh1); 
        Test.stopTest(); 
    }
    static testmethod void method2(){
        test.StartTest();
        Schedule_ShopifyBatch.scheduleMe();
        test.StopTest();
    }
}