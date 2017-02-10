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
		
	}
   
    
}