@IsTest
public class DataCleanupTest {
    static testmethod void testmethod1() {
        DataCleanup.cleanupPerformanceTasks();
        DataCleanup dc=new DataCleanup();
        String sch='0 0 23 * * ?';
        system.schedule('Test status Check',sch,dc);
        //DataCleanup.execute(SchedulableContext SC);
    }
}