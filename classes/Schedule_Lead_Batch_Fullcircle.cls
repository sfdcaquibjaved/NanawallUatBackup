global class Schedule_Lead_Batch_Fullcircle implements Schedulable{

    public static String sched = '0 0 08 * * ?'; //Every day at 8AM

    global static String scheduleMe() {
        Schedule_Lead_Batch_Fullcircle LF = new Schedule_Lead_Batch_Fullcircle();
        return System.schedule('Lead_Batch_Fullcircle Schedule Job', sched, LF);
    }

    global void execute(SchedulableContext LF) {

       Lead_Batch_Fullcircle lbf = new Lead_Batch_Fullcircle();
        ID batchprocessid = Database.executeBatch(lbf,50);           
    }
}