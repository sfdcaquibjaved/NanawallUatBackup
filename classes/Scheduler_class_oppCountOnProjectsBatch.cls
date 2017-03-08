global class Scheduler_class_oppCountOnProjectsBatch implements Schedulable{

    public static String sched = '0 00 09 * * ?'; //Every day at 9AM

    global static String scheduleMe() {
        Scheduler_class_oppCountOnProjectsBatch SC = new Scheduler_class_oppCountOnProjectsBatch(); 
        return System.schedule('oppCountOnProjectsBatch Schedule Job', sched, SC);
    }

    global void execute(SchedulableContext sc) {

       oppCountOnProjectsBatchClass ocp = new oppCountOnProjectsBatchClass();
        ID batchprocessid = Database.executeBatch(ocp,50);           
    }
}