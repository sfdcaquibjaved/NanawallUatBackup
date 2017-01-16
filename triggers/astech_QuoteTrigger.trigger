trigger astech_QuoteTrigger on Quote__c (after update, before update) {


	if( trigger.isBefore && trigger.isUpdate )
	{
 	} else if( trigger.isAfter && trigger.isUpdate )
	{
		
		list<Task> newTasks = new list<Task>();		
		
		Set<Id> quotesToLookupForPerformanceLabelTasks = new Set<Id>();
		for (Quote__c q : trigger.new)
		{
			
			
			if( q.Order_Finalized_Date__c != null
			&& trigger.oldMap.get(q.ID).Order_Finalized_Date__c == null )
			{	//Order finalized date going from null to non-null
					
				if( !quotesToLookupForPerformanceLabelTasks.contains(q.id) )
				{
					quotesToLookupForPerformanceLabelTasks.add(q.id);
				}
			}
		}
		
		for( Quote_Detail__c qd : [SELECT id, Quote__c,UValue__c, SHGC__c, Units__c,Glazing_Notes__c  FROM Quote_Detail__c WHERE Quote__c in :quotesToLookupForPerformanceLabelTasks] )
		{
			if( qd.UValue__c != null && qd.UValue__c != 0 
			&& qd.SHGC__c != null && qd.SHGC__c != 0 
			&& (qd.Glazing_Notes__c == null || qd.Glazing_Notes__c == '' ) )
			{
			
				for( integer i = 0; i< qd.Units__c; i++ )
				{
					Task tsk = new Task();
					tsk.WhatId = qd.id;
					if( GlobalStrings.NanaServerAddress().contains('nanareps'))  
						tsk.OwnerId = '005A0000000M8pi';
					else tsk.OwnerID = '005A0000000M8pi';
					tsk.Subject = 'Performance Label';
					tsk.Description = 'Unit_'+(i+1);
					newTasks.add( tsk);	
				
				}

			}
		}

		if( newTasks.size() > 0 )
			insert newTasks;
		
		
				
	}

}