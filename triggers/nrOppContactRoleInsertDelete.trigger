trigger nrOppContactRoleInsertDelete on nrOpportunityContactRole__c ( before delete) 
{
	/*
	trigger purpose
		makes sure that underlying OppContRoles are deleted when the wrapper object is deleted
	*/
	
	list<OpportunityContactRole> ocrs = null;
	set<OpportunityContactRole> ocrsSet = new set<OpportunityContactRole>();
	for( nrOpportunityContactRole__c nrocr : trigger.old )
	{ 
		try {		
			for( OpportunityContactRole ocr : [SELECT id FROM OpportunityContactRole WHERE OpportunityId = :nrocr.Opportunity__c AND ContactID = :nrocr.Contact__c ])
			{
				if( !ocrsSet.contains(ocr) )
					ocrsSet.add( ocr );		 
			} 
		} catch( Exception ex )
		{
			system.debug( 'caught an exception when removing a contact from an opportunuty ' + ex );
		}
	} 
	ocrs = new list<OpportunityContactRole>( ocrsSet);
	if( ocrs.size() > 0 ) 
	{
		delete ocrs;
		system.debug('delete of OCR was successful');
	}
}