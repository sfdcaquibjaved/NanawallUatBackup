trigger astech_OrderTrigger on Order (after insert, after update, before insert, before update) {

system.debug('astech_OrderTrigger: entered');       

    if( trigger.isBefore && trigger.isInsert )
    {
system.debug('astech_OrderTrigger: before insert');     
        astech_OrderTrigger_Helper.handleBeforeInsert( trigger.new);
    } if( trigger.isAfter && trigger.isInsert )
    { 
system.debug('astech_OrderTrigger: after insert');      
        astech_OrderTrigger_Helper.handleAfterInsert(  trigger.new);
    } else if( trigger.isAfter && trigger.isUpdate ) 
    {
        astech_OrderTrigger_Helper.handleAfterUpdate( trigger.oldMap, trigger.new); 
    } else if( trigger.isBefore && trigger.isUpdate )
    {
       astech_OrderTrigger_Helper.handleBeforeUpdate( trigger.oldMap, trigger.new); 
    }
   
   
   System.debug('**ASTECH: Total SOQL Queries: ' + Limits.getQueries() );
    
}