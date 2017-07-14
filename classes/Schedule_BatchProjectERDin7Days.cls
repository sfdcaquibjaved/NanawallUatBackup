/************************************************************
  * Name             : Schedule_BatchProjectERDin7Days 
  * Description      : schedule class for BatchProjectERDin7Days
  * Created Date     : 12th July 2017                  
  * Input Parameters : NA
  * Return           : NA
  ************************************************************/  

global class Schedule_BatchProjectERDin7Days  implements Schedulable{

    public static String sched = '0 0 10 * * ?'; //Every day at 10AM

    global static String scheduleMe() {
        Schedule_BatchProjectERDin7Days  BE = new Schedule_BatchProjectERDin7Days ();
        return System.schedule('Batch Project notification Job', sched, BE);
    }

    global void execute(SchedulableContext BE) {

       batchProjectERDin7Days sbe = new batchProjectERDin7Days();
       ID batchprocessid = Database.executeBatch(sbe,20);  
             
    }
}