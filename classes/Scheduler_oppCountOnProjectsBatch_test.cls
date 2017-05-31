@isTest
public class Scheduler_oppCountOnProjectsBatch_test {
static testmethod void test1() {       
        Test.startTest();
        String sched = '0 00 10 * * ?';
        Scheduler_class_oppCountOnProjectsBatch sch_OppCntProj = new Scheduler_class_oppCountOnProjectsBatch();
        //String schede = Scheduler_class_oppCountOnProjectsBatch.sched;
        system.schedule('Test oppCountOnProjectsBatch Schedule Job', sched, sch_OppCntProj);
        Test.stopTest();
}
    
static testmethod void test2(){
        test.StartTest();       
        Scheduler_class_oppCountOnProjectsBatch.scheduleMe();
        test.StopTest();
    }
}