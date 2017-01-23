trigger Quote_AggregateTrigger on Quote__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

if(Limits.getQueries()<50){
System.debug('I am here with limit in Aggregate Trigger' + Limits.getQueries());
    if(Trigger.isAfter && Trigger.isInsert) { //After Insert
        //Quote_TriggerCode.handleAfterInsert(Trigger.new);
    }  else if(Trigger.isBefore && Trigger.isInsert) { //Before Insert
        //Quote_TriggerCode.handleBeforeInsert(Trigger.new);   
    } else if(Trigger.isAfter && Trigger.isUpdate) { // After Update
        Quote_TriggerCode.handleAfterUpdate(Trigger.new, Trigger.old);
    }  else if(Trigger.isBefore && Trigger.isUpdate) { //Before Update
       // Quote_TriggerCode.handleBeforeUpdate(Trigger.new, Trigger.old);
    }
    }
}