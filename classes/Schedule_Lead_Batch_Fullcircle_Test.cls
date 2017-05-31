@isTest
public class Schedule_Lead_Batch_Fullcircle_Test {
    
    
    public static testMethod void testschedule1() {

    Test.StartTest();
    Schedule_Lead_Batch_Fullcircle sh1 = new Schedule_Lead_Batch_Fullcircle();
    String sched = '0 0 08 * * ?'; 
    system.schedule('Lead_Batch_Fullcircle Schedule Job', sched, sh1);
    Test.stopTest(); 
    
    }
    
    public  static testmethod void testschedule2(){
        test.StartTest();
         Schedule_Lead_Batch_Fullcircle.scheduleMe();
        test.StopTest();
    }

 
}