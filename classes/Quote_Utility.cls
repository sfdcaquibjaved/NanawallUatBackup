public with sharing class Quote_Utility {

	public static list<Contact> GetQuoteCountContactUpdates( Set<Id> ContactIDs )
	{
		Map<ID,Contact> contMap = new Map<ID,Contact>([select id,quote_count__c, order_count__c from Contact where id in :ContactIDs]);
		list<AggregateResult> contAgg = new list<AggregateResult>();
	
		try 
		{
			contAgg= [ SELECT count(quote_id__c) quotecount, contact__c FROM quote__c WHERE contact__c in:ContactIDs group by rollup (quote__c.contact__c) ];
System.debug('looked up aggregate contact thing in quote_utility.getquotecountcontactupdated ');			
		} catch( Exception ex )
		{
			System.debug('Caught an exception in Quote_Utility.UpdateQuoteCountFIelds when doing the contacts agg lookup: ' + ex );
		}
		 
		boolean updateContacts = false;
		for( AggregateResult ar : contAgg )
		{
			if ( ar.get('contact__c')==null) continue;
			try { 
				integer count = Integer.valueOf(ar.get('quotecount'));
				ID contID = String.valueOf(ar.get('contact__c'));
				if( contMap.get( contID ).quote_count__c != count )
				{
					contMap.get( contID ).quote_count__c = count;
					updateContacts = true;
				}
			} catch( Exception ex )
			{
				system.debug('Caught an exception when trying to get the quotecount on a contact in Quote_Utility.UpdateQuoteCountFIelds, line 74 '+ ex );
			}	
		}
	
		try 
		{
			contAgg= [ SELECT count(quote_id__c) ordercount, contact__c FROM quote__c WHERE contact__c in:ContactIDs AND Order_Finalized_Date__c != null   group by rollup (quote__c.contact__c) ];
		} catch( exception ex ) 
		{
			System.debug('Caught an exception in Quote_Utility.UpdateQuoteCountFIelds when doing the 2d contacts agg lookup: ' + ex );	
		}
		for( AggregateResult ar : contAgg )
		{
			if ( ar.get('contact__c')==null) continue;
			try {
				integer count = Integer.valueOf(ar.get('ordercount'));
				ID contID = String.valueOf(ar.get('contact__c'));
			
				if( contMap.get( contID ).order_count__c != count )
				{
					contMap.get( contID ).order_count__c = count;
					updateContacts = true;
				}
			} catch( Exception ex )
			{
				system.debug('Caught an exception when trying to get the  ordercount on a contact in Quote_Utility.UpdateQuoteCountFIelds, line 74 '+ ex );
			}	
		}
		if( updateContacts && contMap.values().size() > 0 )
		{
				return contMap.Values();
		} else return new list<Contact>();
	}
	
	public static list<Contact> GetQuoteCountContactUpdates_optimized( Set<Id> ContactIDs, map<Id,Contact> contMap )
	{
//		Map<ID,Contact> contMap = new Map<ID,Contact>([select id,quote_count__c, order_count__c from Contact where id in :ContactIDs]);
		list<AggregateResult> contAgg = new list<AggregateResult>();
	
		try 
		{
			//find the total quote count for each contact on the incoming quotes
			contAgg= [ SELECT count(quote_id__c) quotecount, contact__c FROM quote__c WHERE contact__c in:ContactIDs group by rollup (quote__c.contact__c) ];
		} catch( Exception ex )
		{
			System.debug('Caught an exception in Quote_Utility.UpdateQuoteCountFIelds when doing the contacts agg lookup: ' + ex );
		}
		
		boolean updateContacts = false;
		for( AggregateResult ar : contAgg )
		{
			if ( ar.get('contact__c')==null) continue;
			try { 
				integer count = Integer.valueOf(ar.get('quotecount'));
				ID contID = String.valueOf(ar.get('contact__c'));
				if( contMap.get( contID ).quote_count__c != count )
				{
					contMap.get( contID ).quote_count__c = count;
					updateContacts = true;
				}
			} catch( Exception ex )
			{
				system.debug('Caught an exception when trying to get the quotecount on a contact in Quote_Utility.UpdateQuoteCountFIelds, line 74 '+ ex );
			}	
		}
	
		try 
		{
			contAgg= [ SELECT count(quote_id__c) ordercount, contact__c FROM quote__c WHERE contact__c in:ContactIDs AND Order_Finalized_Date__c != null   group by rollup (quote__c.contact__c) ];
		} catch( exception ex ) 
		{
			System.debug('Caught an exception in Quote_Utility.UpdateQuoteCountFIelds when doing the 2d contacts agg lookup: ' + ex );	
		}
		for( AggregateResult ar : contAgg )
		{
			if ( ar.get('contact__c')==null) continue;
			try {
				integer count = Integer.valueOf(ar.get('ordercount'));
				ID contID = String.valueOf(ar.get('contact__c'));
			
				if( contMap.get( contID ).order_count__c != count )
				{
					contMap.get( contID ).order_count__c = count;
					updateContacts = true;
				}
			} catch( Exception ex )
			{
				system.debug('Caught an exception when trying to get the  ordercount on a contact in Quote_Utility.UpdateQuoteCountFIelds, line 74 '+ ex );
			}	
		}
		if( updateContacts && contMap.values().size() > 0 )
		{
				return contMap.Values();
		} else return new list<Contact>();
	}

}