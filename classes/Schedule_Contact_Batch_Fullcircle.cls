global class Schedule_Contact_Batch_Fullcircle implements Schedulable{

    public Static String sched = '0 0 08 * * ?'; //Every day at 8AM

    global Static String scheduleMe() {
        Schedule_Contact_Batch_Fullcircle CF = new Schedule_Contact_Batch_Fullcircle();
        return System.schedule('Contact_Batch_Fullcircle Schedule Job', sched, CF);
    }

    global void execute(SchedulableContext CF) {

       Contact_Batch_Fullcircle cbf = new Contact_Batch_Fullcircle();
        ID batchprocessid = Database.executeBatch(cbf,50);           
    }
}