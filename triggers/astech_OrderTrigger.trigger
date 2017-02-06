trigger astech_OrderTrigger on Order (after insert, after update, before insert, before update) {


	if( trigger.isBefore && trigger.isInsert )
	{
//		astech_OrderTrigger_Helper.handleBeforeInsert( trigger.new);
	} if( trigger.isAfter && trigger.isAfter )
	{ 
//		astech_OrderTrigger_Helper.handleAfterInsert(  trigger.new);
		
	}
  
    
}