/*********************************************************************************************************************
Trigger Name: LeadTrigger
Events: after update
Description: This trigger is used to perform operations on lead
**********************************************************************************************************************/
trigger LeadTrigger on Lead (after update) {
 
 //After Update
 if(Trigger.isAfter && Trigger.isUpdate){
 if(!UtilityClass.doNotRun){
        LeadsHelper.SetContactRoleDefaults(Trigger.new, Trigger.oldMap);
        }
    }

}