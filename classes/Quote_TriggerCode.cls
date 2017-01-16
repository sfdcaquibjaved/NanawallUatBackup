public with sharing class Quote_TriggerCode {

	public static map< Id, list<Quote__c> > opportunityQuoteMap = new map<Id, list<Quote__c>>();
	public static map<Id, list<Quote__c> > GetOpportunityQuoteMap( list<Id> OpportunityIds ) 
	{
		list<id> oppIdsToQuery = new list<Id>();
		for( id i : OpportunityIds )
		{
			if( !opportunityQuoteMap.containsKey(i) )
				oppIdsToQuery.add(i);
		}
		
		if( oppIdsToQuery.size() > 0 )
		{
			for( Quote__c q : [SELECT id,Followup_Status__c,Order_Finalized_Date__c,Opportunity__c, Contact__c, SubTotal__c FROM Quote__c WHERE Opportunity__c in :oppIdsToQuery] )
			{
				if( !opportunityQuoteMap.containsKey(q.Opportunity__c))	
					opportunityQuoteMap.put( q.Opportunity__c, new list<Quote__c> () );
					
				opportunityQuoteMap.get( q.Opportunity__c).add(q); 
			}
		}
		
		map<Id, list<Quote__c> > returnMap = new map<Id, list<Quote__c> >();
		for( id i : OpportunityIds )
		{
			returnMap.put( i, opportunityQuoteMap.get(i) );
		}
		
		return returnMap;
	}

	public static map<Id, Opportunity> opportunityMap = new map<Id, Opportunity>();
	public static list<Opportunity> getOpportunities(list<Id> OpportunityIDs) 
	{
		
		list<Id> oppIdsToQuery = new list<Id>();
		for( Id i : OpportunityIds )
		{
			if( !opportunityMap.containsKey(i))
				oppIdsToQuery.add(i);
		}


		for( Opportunity o : [SELECT  id,  Max_Finalized_Date__c, Attachment_List__c, Chain_Account__c, Competitor_List__c,CAD_Viewed__c, application__c, CloseDate,StageName, (select id,role__c,contact__c from nropportunitycontactroles__r) FROM Opportunity WHERE Id = :oppIdsToQuery] )
		{
			//add any opportunities we havent already looked up
			opportunityMap.put( o.Id, o);
		}
		
		list<Opportunity> returnList = new list<Opportunity>();
		for( id i : OpportunityIds )
		{
			returnList.add( opportunityMap.get(i) );
		}
		
		return returnList;	
	}

	public static map<Id, Contact> contactMap = new map<Id, Contact>();
	public static list<Contact> getContacts(list<Id> ContactIDs) 
	{
		list<Id> contIdsToQuery = new list<Id>();
		for( Id i : ContactIds )
		{
			if( !contactMap.containsKey(i))
				contIdsToQuery.add(i);
		}
		
		for( Contact c : [select   id,Photo_Book_Selections__c,Last_Booklet_Sent__c,LeadType__c, quote_count__c, order_count__c, Showroom_to_Visit__c, ShowroomInfo__c, accountid, ownerid from Contact where id in :contIdsToQuery])
		{
			//add any opportunities we havent already looked up
			contactMap.put( c.Id, c);
		}
		
		list<Contact> returnList = new list<Contact>();
		for( id i : ContactIDs )
		{
			returnList.add( contactMap.get(i) );
		}
				
		
		return returnList;	
	}

	public static map<Id, Account> accountMap = new map<Id, Account>();
	public static list<Account> getAccounts(list<Id> AccountIDs) 
	{
		list<Id> AccountIdsToQuery = new list<Id>();
		for( Id i : AccountIds )
		{
			if( !AccountMap.containsKey(i))
				AccountIdsToQuery.add(i);
		}
		
		for( Account c : [select id,Type,ParentId, Franchise_Owner__c, Competitor__c, Name, Order_Count__c  from Account where id in :AccountIdsToQuery])
		{
			//add any opportunities we havent already looked up
			AccountMap.put( c.Id, c);
		}
		
		list<Account> returnList = new list<Account>();
		for( id i : AccountIDs )
		{
			returnList.add( AccountMap.get(i) );
		}
				
		
		return returnList;	
	}


	public static map< string, Zip_Lookup__c> zipMap = new map<string, Zip_Lookup__c>();
	public static list< Zip_Lookup__c> getZipList( list<string> ZipNames ) 
	{
		list<string> ZipNamesToQuery = new list<string>();
		for( string z : ZipNames )
		{
			if( !zipMap.containsKey(z))
				ZipNamesToQuery.add(z);
		}
		
		for( Zip_Lookup__c z : [select id, name, Showroom_Commission__c from Zip_Lookup__c where name=:ZipNamesToQuery])
		{
			//add any opportunities we havent already looked up
			zipMap.put( z.Name, z);
		}
		
		list<Zip_Lookup__c> returnList = new list<Zip_Lookup__c>();
		for( string z : ZipNames )
		{
			returnList.add( zipMap.get(z) );
		}
				
		
		return returnList;			
	}

	public static void handleBeforeInsert(list<Quote__c> triggerNew )
	{
		list<string> allIncomingZips = new list<String>();
		for( Quote__c q : triggerNew )
		{
			allIncomingZips.add( q.Zip__c);
		}

		map<string, Zip_Lookup__c> zipLookup = new map<string, Zip_Lookup__c>();
		for( Zip_Lookup__c z : Quote_TriggerCode.getZipList(allIncomingZips)  )
		{
			if( z == null )
				continue;
			zipLookup.put(z.name, z );
		}
		
	 	for (Quote__c q: triggerNew)
	 	{   
	 		try
	 		{
				Zip_Lookup__c z = zipLookup.get(q.Zip__c);
				if (z != null)
					q.Commission_Showroom__c = z.Showroom_Commission__c;
				if (q.State__c == 'Quebec')
				{
					q.Commission_Showroom__c='a0DA0000002wo64';
				}
			}
			catch (Exception ex)   
			{ 
			 	Utility.JimDebug(ex, 'get showroom for quote ' + q.Name ); 
			}
	 	} 

		
		//do any updates
	}

	public static void handleAfterInsert(list<Quote__c> triggerNew )
	{

		//Quote_AfterInsert
		/*
		trigger purpose
			Opportunity.Max_Quote_Contact__c  number should reflect the highest number of quotes a single contact is assigned to
		*/

		Set<ID> oppidsone=new Set<ID>();
		Set<ID> contidsone=new Set<ID>();
	
		for (Quote__c q : triggerNew)
		{
			if (!oppidsone.contains(q.opportunity__c))
			{
				oppidsone.add(q.opportunity__c);
			}
	
			if( !contidsone.contains(q.contact__c))
				contidsone.add(q.contact__c);		
		}

		Map<ID,Opportunity> AllTriggerOpportunities = new Map<ID,Opportunity>(Quote_TriggerCode.getOpportunities(new list<id>(oppidsone) ) );
		

		//find the Max_Quote_Contact__c - its the highest number of quotes assigned to a single contact
		//for each unique opportunity-contact pair, give me the count of quotes within our opportunity list
		AggregateResult[] results=[select count(name) cnt, opportunity__c,contact__c from quote__c where opportunity__c in:oppidsone group by rollup (quote__c.opportunity__c,quote__c.contact__c)];
		Map<ID,integer> opps= new Map<ID,integer>();
		string summary ='';
		for (AggregateResult ar : results)
		{
			integer count = Integer.valueOf(ar.get('cnt'));
			ID oppid = String.valueOf(ar.get('opportunity__c'));
			ID cont = String.valueOf(ar.get('contact__c'));
			if (ar.get('opportunity__c') == null || ar.get('contact__c')==null)
				continue;
				
			summary += 'opp='+oppid + ' count='+count + ' contact='+cont;
			decimal maxq=0;

			try
			{
				if (AllTriggerOpportunities.get(oppid).max_quote_contact__c!=null)
					maxq = AllTriggerOpportunities.get(oppid).max_quote_contact__c;
			}
			catch(Exception ex){}
			
			if (!opps.containsKey(oppid) && count>maxq)
			{ //if the count we just found in the aggregate is greater than the current highest max quote contact, and we havent flagged the opp for an updte, flag it
				opps.put(oppid,count);
			}
			else if(opps.containsKey(oppid))
			{ //if we have flagged the opp, check its current value, and give it our new value if its greater
				integer c = opps.get(oppid);
				if (count>c)
				{
					opps.put(oppid,count);
				}
			}
		}

		Map<ID,Opportunity> updates = new Map<ID,Opportunity>();
		for( Id i : opps.keySet() )
		{
			Opportunity o = AllTriggerOpportunities.get(i);
			o.Max_Quote_Contact__c = opps.get(i);
			updates.put( i, o );
		}

		//finish quote_AfterInsert
		
		/*
		Quote_Insert
		trigger purpose
			I THINK the only useful thing this does anymore is fix the stagenamewhen a user inserts a new quote with the stage as "Past  ERD"  			
		*/
		for( id oppId : AllTriggerOpportunities.keySet() ) 
		{
			
			Opportunity o = AllTriggerOpportunities.get(oppId);
			
			if( !updates.containsKey(o.Id) ) //make sure it gets updated
				updates.put(o.Id, o);
			
			Opportunity oToCheck = updates.get(o.Id);
			
			if ( oToCheck.StageName != null
				&& ( oToCheck.StageName == 'Quotes Passed Expected Resolution Date' ||
					oToCheck.StageName =='Closed - Lost' ) 
				)
			{
				oToCheck.StageName = 'Considered';
				oToCheck.Reason_Opportunity_Lost__c='';
			}
		}
		//End Quote Insert


		//updates section 
		update updates.Values();
		
	}


	public static void handleBeforeUpdate(list<Quote__c> triggerNew, list<Quote__c> triggerOld)
	{
		//data to update / insert
		map<Id, Quote__c> oldMap = new map<Id, Quote__c>();
		for( Quote__c q : triggerOld )
			oldMap.put( q.id, q);
		
		map<Id, Quote__c> newMap = new map<Id, Quote__c>();
		for( Quote__c q : triggerNew )
			newMap.put( q.id, q);
		
		// load data for the run
		Set<ID> oppidsone=new Set<ID>();
		for (Quote__c q : triggerNew)
		{
			if (!oppidsone.contains(q.opportunity__c))
			{
				oppidsone.add(q.opportunity__c);
			}
		}
		
		Map<ID,Opportunity> AllTriggerOpportunities = new Map<ID,Opportunity>();
		try
		{
			list<Id> oppidlist = new list<Id>();
			for( id i: oppidsone )
				oppidlist.add(i);
			
			AllTriggerOpportunities = new Map<ID,Opportunity>(  );
			list<Opportunity> oppList = Quote_TriggerCode.getOpportunities(oppidlist);
			for( Opportunity o : oppList )
			{
				if( o == null )
					continue; //i had to build this out because of some crazy bugs that were happening on release
				AllTriggerOpportunities.put( o.Id, o);
			}
			
		}  catch(Exception ex )
		{  
		}
		
	
		//Quote_ShowroomUpdate
		list<string> allIncomingZips = new list<String>();
		for( Quote__c q : triggerNew )
		{
			allIncomingZips.add( q.Zip__c);
		}

		map<string, Zip_Lookup__c> zipLookup = new map<string, Zip_Lookup__c>();
		for( Zip_Lookup__c z : Quote_TriggerCode.getZipList(allIncomingZips)  )
		{
			if( z == null )
				continue;
			zipLookup.put(z.name, z );
		}
		
	 	for (Quote__c q: triggerNew)
	 	{
	 		
	 		
	 		if(q.Order_Number__c != null && oldMap.get(q.Id).Order_Number__c == null )
	 		{ //Order number is going from non-null to null
	 		
	 		
				string zip = q.Zip__c.toLowerCase().replace(' ','').replace('-','');
				if (GetUserFromAddress.HasVanNessCommission(zip) ){
					//its a Van Ness quote
					
					q.Van_Ness_Commission__c = true;
				}
	 		}  
	 		   
	 		
/*Project Coordinator - Project_Coordinator__c
If opportunity.chain_account__c is true, use 005A0000000MOJS (frieda keeler)
else if quote__c.custom_drawing__c is false use 005A0000000NAYj (kathryn wilson)
else if quote__c.sub_total__c > 30k   use 005A0000000NAYj (kathryn wilson) kat is used twice because an employee left, one of these will be updated later
else use 005A0000000M8nP (matt thomas , marketing@nanawall)	 			
	 */
 			if( AllTriggerOpportunities.get( q.Opportunity__c) != null
 			&& AllTriggerOpportunities.get( q.Opportunity__c).Chain_Account__c == true )
 			{
 				q.Project_Coordinator__c = '005A0000000MOJS';
 			} else if( q.Custom_Drawing__c == false )
 			{
 				q.Project_Coordinator__c = '005A0000000MOJS';
 			} else if( q.SubTotal__c > 30000 )
 			{
 				q.Project_Coordinator__c = '005A0000000MOJS';
 			} else
 			{
 				q.Project_Coordinator__c = '005A0000000M8nP';
 			}
	 			
/*
Technical Supervisor Technical_Supervisor__c
if [Quote__c].Teuffel__c > 0 use 005A0000000MOJW (dirk/lora)
else  use 005A0000000MOPI (jurgen)
*/
 			if( q.Teuffel__c > 0  )
 			{
 				q.Technical_Supervisor__c = '005A0000000MOJW';
 			} else
 			{
 				q.Technical_Supervisor__c = '005A0000000MOPI';	 				
 			}
	 		
	 		
	 		// update Drawing Pipeline Category Name 2
			if(  q.drawing_pipeline_category_2__c == 1 )
			{
				q.Drawing_Pipeline_Category_Name_2__c = 'ordered';
			} else if (q.drawing_pipeline_category_2__c == 2)
			{
				q.Drawing_Pipeline_Category_Name_2__c = 'drawings started';
			
			} else if (q.drawing_pipeline_category_2__c == 3)
			{
				q.Drawing_Pipeline_Category_Name_2__c = 'deposit received';
			
			} else if (q.drawing_pipeline_category_2__c == 4)
			{
				q.Drawing_Pipeline_Category_Name_2__c = 'Final Drawings Sent';
			} else if (q.drawing_pipeline_category_2__c == 5)
			{
				q.Drawing_Pipeline_Category_Name_2__c = 'Final Drawings Signed';
			} else 
			{
				q.Drawing_Pipeline_Category_Name_2__c = 'Other';	
			}

	 		

			// update Drawing_PIpeline_Status_2__c
			if(q.drawing_pipeline_category_2__c == 5)
			{
				q.Drawing_Pipeline_Status_2__c = 'Received approved final order confirmation, final drawings and second payment(ready to place order)';			
			} else if(q.drawing_pipeline_category_2__c == 4
				&& q.Drawing_Order_Confirmation_Signoff__c == null 
				&& q.Drawing_Final_Signoff__c == null )
			{
				q.Drawing_Pipeline_Status_2__c = 'Received approval final drawings, waiting for approved final order confirmation and second payment';			
			} else  if(q.drawing_pipeline_category_2__c == 4
			&& q.Drawing_Final_Order_Confirmation__c == null  )
			{
				q.Drawing_Pipeline_Status_2__c = 'Received approved final drawings and second payment, waiting for approved order confirmation';			

			} else  if(q.drawing_pipeline_category_2__c == 4
			&& q.drawing_additional_payment_received__c == null  )
			{
				q.Drawing_Pipeline_Status_2__c = 'Received approval final order confirmation and second payment, waiting for approval final drawings';			

			} else  if(q.drawing_pipeline_category_2__c == 4
			&& q.drawing_final_signoff__c == null  )
			{
				q.Drawing_Pipeline_Status_2__c = 'Received approved final drawings and final order confirmation, waiting for second payment';			

			} else  if(q.drawing_pipeline_category_2__c == 4  )
			{
				q.Drawing_Pipeline_Status_2__c = 'Received approved final order confirmation, waiting for approved final drawings and second payment';			
				
			} else  if(q.drawing_pipeline_category_2__c == 3  )
			{
				q.Drawing_Pipeline_Status_2__c = 'Received all deposits and sign off.  Ready to send drawing to customer.';			
			} else  if(q.drawing_pipeline_category_2__c == 2  
			&& q.drawing_complete__c != null )
			{
				q.Drawing_Pipeline_Status_2__c = 'Drawings and order confirmation sent to customer, waiting for approval';			
			} else  if(q.drawing_pipeline_category_2__c == 2  
			&& q.drawing_deposit_amount__c == 0 )
			{
				q.Drawing_Pipeline_Status_2__c = 'Received customer drawings, waiting for initial payment, working on drawings';			
				
			} else  if(q.drawing_pipeline_category_2__c == 2  
			&& q.Drawing_Additional_Payment_Received__c != null )
			{//drawing_additional_payment__received__c
				q.Drawing_Pipeline_Status_2__c = 'Have 50% payment and customer drawings, Nana working on final drawings';			

			} else  if(q.drawing_pipeline_category_2__c == 2    )
			{
				q.Drawing_Pipeline_Status_2__c = 'Have payment and customer drawings, Nana working on final drawings';			

			} else  if(q.drawing_pipeline_category_2__c == 1   
			&&  q.Drawing_Additional_Payment_Received__c != null )
			{
				q.Drawing_Pipeline_Status_2__c = 'Have 50% payment, waiting on customer drawings';			

			} else  if(q.drawing_pipeline_category_2__c == 1   
			&&  q.drawing_deposit__c != null )
			{
				q.Drawing_Pipeline_Status_2__c = 'Have 20% payment, waiting on customer drawings';			

			} else  if(q.drawing_pipeline_category_2__c == 1    )
			{
				q.Drawing_Pipeline_Status_2__c = 'No Payment and no customer drawings';			
			}

	 		
	 		try
	 		{
	 			
	 
	 			
	 			if( q.Zip__c != oldMap.get(q.Id).Zip__c
	 			|| q.State__c == 'Quebec' ) 
	 			{
					Zip_Lookup__c z = zipLookup.get(q.Zip__c);
					if (z != null)
						q.Commission_Showroom__c = z.Showroom_Commission__c;
						
					if (q.State__c == 'Quebec')
					{
						q.Commission_Showroom__c='a0DA0000002wo64';
					}
	 			
	 			}
			}
			catch (Exception ex)   
			{ 
			 	Utility.JimDebug(ex, 'get showroom for quote ' + q.Name ); 
			}
	 	} 
		//Quote_ShowroomUpdate
		
		
	}

	public static void handleAfterUpdate(list<Quote__c> triggerNew, list<Quote__c> triggerOld)
	{
		//data to update / insert
		map<Id, Quote__c> oldMap = new map<Id, Quote__c>();
		for( Quote__c q : triggerOld )
			oldMap.put( q.id, q);
		
		map<Id, Quote__c> newMap = new map<Id, Quote__c>();
		for( Quote__c q : triggerNew )
			newMap.put( q.id, q);
		
		
		//objects to update/flush/send emails		
		map<Id, Opportunity> opportunitiesToUpdate = new map<Id,Opportunity>();
		map<Id, Contact> contactsToUpdate = new map<Id,Contact>();
		list<Task> newTasks = new list<Task>();		
		map<Id, Account> AccountsToUpdate = new map<Id, Account>();
		set<id> quoteIdsToFlush = new Set<id>();
		


		// load data for the run
		Set<ID> oppidsone=new Set<ID>();
		Set<ID> contidsone=new Set<ID>();
		Set<ID> accountidsone=new Set<ID>();
		
		for (Quote__c q : triggerNew)
		{
			if (!oppidsone.contains(q.opportunity__c))
			{
				oppidsone.add(q.opportunity__c);
			}
	
			if( !contidsone.contains(q.contact__c))
				contidsone.add(q.contact__c);		
				
			
		}
		
		Map<ID,Opportunity> AllTriggerOpportunities = new Map<ID,Opportunity>();
		try
		{
			list<Id> oppidlist = new list<Id>();
			for( id i: oppidsone )
				oppidlist.add(i);
			
			AllTriggerOpportunities = new Map<ID,Opportunity>(  );
			list<Opportunity> oppList = Quote_TriggerCode.getOpportunities(oppidlist);
			for( Opportunity o : oppList )
			{
				if( o == null )
					continue; //i had to build this out because of some crazy bugs that were happening on release
				AllTriggerOpportunities.put( o.Id, o);
			}
			
		}  catch(Exception ex )
		{
			string qids = '';
			for( Quote__c q : triggerNew )
			{
				qids += q.Id + ', ';
				
			}
			
			string oppidsonestr = '';
			for( string i : oppidsone )
				oppidsonestr += i +'; ';
			
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
			mail.setToAddresses( toAddresses );
			mail.setReplyTo('admin@a-stechnologies.com');   
			mail.setSenderDisplayName('Salesforce - Quote Aggregate Trigger Error ');
			mail.setSubject('Quotes had an error in the aggregate trigger.'  );
			mail.setBccSender(false);
			mail.setUseSignature(false);
			mail.setPlainTextBody('Quote IDs ' + qids + ' ; Opp Ids: ' + oppidsonestr  +  ' \n' + ex  + '\n' + ex.getLineNumber() );
			mail.setHtmlBody('Quote IDs ' + qids + ' ; Opp Ids: ' + oppidsonestr  +  ' \n' + ex   + '\n' + ex.getLineNumber() );
			//commented by Praveen------
			//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
			
		}
		
		
		list<Id> contidlist = new list<Id>();
		for( id i: contidsone )
			contidlist.add(i);
		
		map<Id, Contact> AllTriggerContacts = new Map<ID,Contact>(  );
		list<Contact> contList = Quote_TriggerCode.getContacts(contidlist);
		for( Contact c : contList )
		{
			if( c == null )
				continue; //i had to build this out because of some crazy bugs that were happening on release
			AllTriggerContacts.put( c.Id, c);
		}	
//		map<Id, Contact> AllTriggerContacts = new Map<Id, Contact>( Quote_TriggerCode.getContacts( new list<id>(contidsone) ));
	
		
		for( Contact c : AllTriggerContacts.values() )
		{
			if( !accountidsone.contains(c.AccountId) )
				accountidsone.add(c.AccountId);
		}
		map<Id,Account> AllTriggerAccounts = new Map<Id,Account>( Quote_TriggerCode.getAccounts(new list<Id>(accountidsone) ) );
		
		map<Id, list<Quote__c> > Opportunity_To_QuoteList = Quote_TriggerCode.GetOpportunityQuoteMap( new list<id>(oppidsone) );
		
		//end data lookup
		
		//Quote_Pipeline
		/*
		trigger purpose
			updates Most_Recently_Ordered_Account__c, Most_Recently_Ordered_Contact__c for i2c realtime scoring (quite a lot of code just for that); 
			
			creates performance label tasks; triggers contacts on opportunities to update their quote counts for I2C scoring (cascading code);
		*/


		Set<Id> quotesToLookupForPerformanceLabelTasks = new Set<Id>();
		for (Quote__c q : triggerNew)
		{
			if( q.Order_Finalized_Date__c != null
			&& oldMap.get(q.ID).Order_Finalized_Date__c == null )
			{	//Order finalized date going from null to non-null
					
				if( !quotesToLookupForPerformanceLabelTasks.contains(q.id) )
				{
					quotesToLookupForPerformanceLabelTasks.add(q.id);
				}
			}
			
			if( q.Order_Finalized_Date__c != oldMap.get(q.Id).Order_Finalized_Date__c )
			{  //order finalized data is just changing
				
				//detect whether we need to increment/decrement the account.order_count field
				if( q.Contact__c != null )
				{
					
					Account updateAcc = AllTriggerAccounts.get( AllTriggerContacts.get(q.Contact__c).AccountID );
					if( !AccountsToUpdate.containsKey(updateAcc.Id) )
					{ 
						if(updateAcc.Order_Count__c == null )
							updateAcc.Order_Count__c = 0;
						AccountsToUpdate.put( updateAcc.Id, updateAcc );
					}
					
				}				
				// end the account.order_count increment/decrement
				
				//the order finalized date changed, make sure the opportunity's most recent contacts and accounts are correct by looking at the whole quote list
				Opportunity o = AllTriggerOpportunities.get( q.Opportunity__c);
				
				Id mostRecentlyOrderedContact = null;
				Id mostRecentlyOrderedAccount = null;
				Date mostRecentDate = null;
				
				for( Quote__c q2 :  Opportunity_To_QuoteList.get(q.Opportunity__c) )
				{ //spin over each quote on an opportunity looking for the most recently ordered 
//					Quote__c q2 = triggerNew.get( QuoteId );
					
					if( mostRecentDate == null || q2.Order_Finalized_Date__c > mostRecentDate )
					{
						mostRecentDate = q2.Order_Finalized_Date__c;						
						mostRecentlyOrderedAccount = mostRecentlyOrderedContact = null;
						
						if( q2.Order_Finalized_Date__c != null )
						{
							Contact c = AllTriggerContacts.get( q2.Contact__c );
							if( c != null )
							{
								mostRecentlyOrderedContact = c.Id;
								mostRecentlyOrderedAccount = c.AccountId;
							}
						}
					}
				}
				
				o.Most_Recently_Ordered_Account__c  = mostRecentlyOrderedAccount;
				o.Most_Recently_Ordered_Contact__c  = mostRecentlyOrderedContact;
				
				opportunitiesToUpdate.put(o.Id, o);
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
						tsk.OwnerId = '005A0000000MOJS';
					else tsk.OwnerID = '005A0000000M8pi';
					tsk.Subject = 'Performance Label (ed) ';
					tsk.Description = 'Unit_'+(i+1) + ' ;  ' + qd.Glazing_Notes__c;
					newTasks.add( tsk);	
				
				}

			}
		}
		


		//update the order counts on the Accounts to update
		if(AccountsToUpdate.size() > 0 )
		{
			
			for( Id i : AccountsToUpdate.keySet() )
			{
				AccountsToUpdate.get(i).Order_Count__c = 0;
			}

			//lookup every order this account is associated with  -- is there a way to optimize this ? 
			for( Quote__c q : [SELECT Id, Contact__c, Contact__r.AccountID FROM Quote__c WHERE Order_Finalized_Date__c != NULL AND (Contact__r.AccountID = :AccountsToUpdate.keySet() OR Id = :newMap.keySet() ) ] )
			{

				if( AccountsToUpdate.containsKey(q.Contact__r.AccountID) )
				{
					AccountsToUpdate.get(q.Contact__r.AccountID).Order_Count__c++;					 
				}
			}
			
			for( Id i : AccountsToUpdate.keySet() )
			{
				
				AccountsToUpdate.get(i).Order_Count_String__c = String.valueOf(AccountsToUpdate.get(i).Order_Count__c);
			}

			

		}
		
		// end after Quote_Pipeline
		/*
		Quote_Printed
		trigger purpose
			if a quote is reprinted, reopens the stage; 		
			flags contacts for nurture type under these conditions; 
			
			this WAS a Before Insert -- seems better to do it after insert
			
		
	
		for(Quote__c q : triggerNew)
		{
			Quote__c oldquote = oldMap.get(q.Id);
			if ( (oldquote.Print_Date__c != q.Print_Date__c) && q.Printed__c==true)
			{
				//if a quote is reprinted on a passed resolution or closed project
				// re-open and push the close date
				
				Contact c = null;
				if( !contactsToUpdate.containsKey(q.Contact__c) )
				{
					c = AllTriggerContacts.get(q.Contact__c);
					contactsToUpdate.put( c.Id, c);
				} else c = contactsToUpdate.get(q.Contact__c );
				
				Opportunity o = null;
				if( !opportunitiesToUpdate.containsKey(q.Opportunity__c) )
				{
					o = AllTriggerOpportunities.get(q.opportunity__c);
					opportunitiesToUpdate.put(o.Id, o);
				} else  o = opportunitiesToUpdate.get( o.Id );
	
				c.Project_Type_Nurture__c = o.application__c;
				if (o.StageName == 'Quotes Passed Expected Resolution Date' || o.StageName == 'Closed - Inactivity' ||
					o.StageName == 'Closed - Lost')
				{
					o.StageName='Considered';
					o.Reason_Opportunity_Lost__c='';
				}
			}
		}	
		//end Quote_Printed
		
		if( contidsone.size() > 0 )
		{
			
			list<Contact> conts = Quote_Utility.GetQuoteCountContactUpdates_optimized(contidsone, AllTriggerContacts);
			if( conts.size() > 0 )
			{
				for( Contact c : conts )
				{ //add the contacats that come back from Quote_Utility to our update list
					//quote_count__c
					//order_count__c
					if( !contactsToUpdate.containsKey( c.Id))
						contactsToUpdate.put( c.Id, c );
					else
					{
						Contact updateC = contactsToUpdate.get(c.Id);
						updateC.quote_count__c = c.quote_count__c;
						updateC.order_count__c = c.order_count__c;
					}
					
				}
			
			}
		}

		/*
		Quote_UpdateStage
		trigger purpose
			only works on printed quotes; 			
			updates opp stage to Order Process Started when an order number is added; 
			flags an opp as considered, if it was passed ERD; 			
			does various stage updates based on OppCont Role
		
		for( Quote__c q : triggerNew )
		{
			if (q.Printed__c == False)
				continue;
			
			Opportunity o = AllTriggerOpportunities.get(q.Opportunity__c);
		 
			if (
				q != null && o != null
				&& q.Ordered__c != null
				&& q.Ordered__c==True 
				&& q.Order_Number__c > 0 
				&& o.StageName != 'Ordered - Paid' 
				&& q.Cancelled__c == false)
			{
				o.StageName = 'Order Process Started';

				if (!opportunitiesToUpdate.containsKey(o.id))
					opportunitiesToUpdate.put(o.id,o);
					
				continue;
			}


			if( o != null && o.nropportunitycontactroles__r != null )
			{
				for (nrOpportunityContactRole__c nocr : o.nropportunitycontactroles__r)
				{
					
					if (nocr.Contact__c!= q.Contact__c)
						continue;
				
					if (o.StageName == 'Quotes Passed Expected Resolution Date')
						o.StageName = 'Considered';
						
					if (nocr.Role__c == 'Architect')
					{
						if (o.StageName == 'Quoted Architect and Non-Architect' 
						|| o.StageName == 'Budget Quote to Architect')	
						{
							continue;
						}
						else if (o.StageName == 'Quote/Non-Architect')
						{
							o.StageName = 'Quoted Architect and Non-Architect';
							if (!opportunitiesToUpdate.containsKey(o.id))
								opportunitiesToUpdate.put(o.id,o);
	
						}
						else if (o.StageName == 'Considered' ||
							o.StageName == 'Specified' ||
							o.StageName == 'Quote Requested' ||
							o.StageName == 'Glazing Contractor')
							{
								o.StageName ='Budget Quote to Architect';
								if (!opportunitiesToUpdate.containsKey(o.id))
									opportunitiesToUpdate.put(o.id,o);
	
							}
					}
					else if( o != null )
					{
						if (o.StageName == 'Quoted Architect and Non-Architect' 
							||o.StageName == 'Quote/Non-Architect')	
						{
							continue;
						}
						else if (o.StageName == 'Budget Quote to Architect')
						{
							o.StageName = 'Quoted Architect and Non-Architect';
							if (!opportunitiesToUpdate.containsKey(o.id))
								opportunitiesToUpdate.put(o.id,o);
						}
						else if (o.StageName == 'Considered' ||
							o.StageName == 'Specified' ||
							o.StageName == 'Quote Requested'||
							o.StageName == 'Glazing Contractor')
							{
								o.StageName ='Quote/Non-Architect';
								if (!opportunitiesToUpdate.containsKey(o.id))
									opportunitiesToUpdate.put(o.id,o);
							}
					}
				}
				
			}
		}

		*/
		//end Quote_UpdateStage

		/*   Quote_PostSave
		trigger purpose
			flags opportunites as CAD viewed when their quotes are CAD viewed; sends a flush call to nana;  
			kicks off final invoice emails
			we also need to update the adjustd quote count field on the opportunity 
		*/
		list<string> QuoteNumbersToSendFinalInvoices = new list<string>();
		try 
		{
			set<Id> OppsToRecalc = new set<Id>();
			for( Quote__c q : triggerNew )
			{
				
				if( !OppsToRecalc.contains(q.Opportunity__c ) )
					OppsToRecalc.add(q.Opportunity__c);
				
				
				if( q.CAD_Viewed__c != null 
					&& q.CAD_Viewed__c != oldMap.get(q.id).CAD_Viewed__c )
				{
					Opportunity o =null;
					if( opportunitiesToUpdate.containsKey(q.Opportunity__c) )		
						o = opportunitiesToUpdate.get(q.Opportunity__c);
					else o = AllTriggerOpportunities.get(q.Opportunity__c);			

	
					o.CAD_Viewed__c = true;					
					opportunitiesToUpdate.put( o.id, o );
					
				}
				
				if( q.Final_Invoice_Amount__c != null 
					&& q.Final_Invoice_Amount__c > 0
					&& ( oldMap.get(q.id).Final_Invoice_Amount__c == null || oldMap.get(q.id).Final_Invoice_Amount__c < 1  )   )
				{
					QuoteNumbersToSendFinalInvoices.add(q.Name);
				}
			}
						
			for( id OppID :OppsToRecalc )
			{
			
				integer adjustedQuoteCount = 0;
				for( Quote__c q  : Opportunity_To_QuoteList.get(OppID) )
				{
					if( q.SubTotal__c > 0 )
					{
						adjustedQuoteCount++;
					}
					
				}
				
				//we do it this way so we can group together all of our updates and make sure we dont overwrite somethign
				Opportunity o =null;
				if( opportunitiesToUpdate.containsKey(OppId) )		
					o = opportunitiesToUpdate.get(OppId);
				else o = AllTriggerOpportunities.get(OppId);
				
				o.Adjusted_Quote_Count__c = adjustedQuoteCount;
				opportunitiesToUpdate.put( o.Id, o );
			}
						
							
		} catch( Exception ex )
		{
			System.debug('Got an exception when propagating the CAD View flag to the project level ' + ex);
		}
		
		
		for( Quote__c q : triggerNew )
		{
			if( 
				oldmap != null
				&& oldmap.get(q.id) != null
				&& oldmap.get(q.id).Contact__c != null
				&& q.Contact__c != null
				&& q.Contact__c != oldmap.get(q.id).Contact__c 
				) 
			{
				quoteIdsToFlush.add( q.id );
			} else if( 
				oldmap != null
				&& oldmap.get(q.id) != null
				&& oldmap.get(q.id).Opportunity__c != null
				&& q.Opportunity__c != null
				&& q.Opportunity__c != oldmap.get(q.id).Opportunity__c 			
			) 
			{
				quoteIdsToFlush.add( q.id );
			}
		}
		//Quote_PostSave



		//Any flush calls
		if( quoteIdsToFlush.size() > 0 )
			//Async_WebServiceCaller.FlushNanaCache(quoteIdsToFlush, 'Quote');

		//Any Email sends
		if( QuoteNumbersToSendFinalInvoices.size() > 0 )
			//Quote_SendFinalInvoice.SendBulkEmails(QuoteNumbersToSendFinalInvoices);

		//update / insert any necessary data		
		if( newTasks.size() > 0 )
			//commented by Praveen----
			//insert newTasks;
		
		if(opportunitiesToUpdate.values().size() > 0 )
		{
			try
			{ 
				update opportunitiesToUpdate.values();
			} catch( Exception ex )
			{
			 	Utility.JimDebug(ex, 'Couldnt update the opportunities in the Quote_TriggerCode / Aggregate call/ ' ); 				
			}
		}		
		if(AccountsToUpdate.size() > 0 )
			update AccountsToUpdate.values();
			
		if( ContactsToUpdate.size() > 0 )
		{
			try
			{
				update ContactsToUpdate.values();
			}
			 catch( Exception ex )
			{
			 	Utility.JimDebug(ex, 'Couldnt update the contacts in the Quote_TriggerCode / Aggregate call/ ' ); 							
			}
		}
		
	}


}