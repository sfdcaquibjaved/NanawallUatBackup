/*************************************************************************\
    @ Author        : Nitish Kumar
    @ Date          : July 2015
    @ Test File     : NA
    Function        : Trigger on Project Split
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/

trigger ProjectSplitTrigger on Project_Split__c (before delete) {

    if (trigger.isBefore && trigger.isDelete){
           ProjectSplitHelperClass.validateProjectSplit(trigger.old);
    }

}