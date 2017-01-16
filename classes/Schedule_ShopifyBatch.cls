/**********************************************************************
Apex Class: Schedule_ShopifyBatch
Description: This Scheduler class is used to Schedule the Shopify Batch Class
Created Date: 26th April,2016            
***********************************************************************/
global class Schedule_ShopifyBatch implements Schedulable{

    public static String sched = '0 0 01 * * ?'; //Every day at 1AM

    global static String scheduleMe() {
        Schedule_ShopifyBatch LF = new Schedule_ShopifyBatch();
        return System.schedule('Shopify Batch Job', sched, LF);
    }

    global void execute(SchedulableContext LF) {

       ShopifyBatch sb = new ShopifyBatch();
        ID batchprocessid = Database.executeBatch(sb,50);           
    }
}