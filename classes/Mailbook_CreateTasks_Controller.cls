public with sharing class Mailbook_CreateTasks_Controller 
{

	class ContactCleanupObject 
	{
		public Contact contact;
		public list<Task> taskList = new list<Task>();
		
	}

	class MailbookItem 
	{
		public integer recordNumber { get; set; }
		public boolean MakeTask { get; set;}
		public Contact Contact { get; set; }
		public Quote__c Quote { get; set; }
	}


	private list<MailbookItem> items = null;	
	public list<MailbookItem> mailbookItems {
		set { items = value; }
		
		get 
		{
			list<Contact> contactsToUpdate = new List<Contact>();
			
			if(items == null)
			{
				items = new list<MailbookItem>();
				
				//load up the last 180days of orders - need to make sure that no contact recieves a mailbook if they have ordered anything 
				//in the last 180 days
				set<Id> ContactIdsSeen = new set<Id>();
				for( Quote__c q : [SELECT Id, Quote_ID__c, Contact__c  FROM Quote__c WHERE Ordered__c = true AND CreatedDate >= LAST_N_DAYS:180  ] )
				{
					if( !ContactIdsSeen.contains(q.Contact__c))
						ContactIdsSeen.add(q.Contact__c);
				}
				
				list<Quote__c> quoteList = [SELECT Id,OpportunityName__c, CreatedDate,  Quote_ID__c, Contact__c, Contact__r.Id, Contact__r.Last_Mailbook_Sent__c,Contact__r.Last_Booklet_Sent__c,Contact__r.Last_Binder_Sent__c,Contact__r.FirstName, Contact__r.LastName,Contact__r.Address_1__c, Contact__r.City__c, Contact__r.State__c, Contact__r.Zip__c FROM Quote__c WHERE Printed__c = true AND CreatedDate >= LAST_N_DAYS:14 AND Contact__c in (SELECT Id FROM Contact WHERE (Last_Mailbook_Sent__c < LAST_N_DAYS:180 OR Last_Mailbook_Sent__c = null) AND (Last_Booklet_Sent__c < LAST_N_DAYS:180 OR Last_Booklet_Sent__c = null) AND Send_Booklet__c != true )];
				
				//one-offs keep making it through our net because of our merge. thus we need to do another check to find any stragglers
				list<Id> contactsToCheck = new list<Id>();
				map<id, ContactCleanupObject> contactCheckMap = new map<id, ContactCleanupObject>();
				for( Quote__c q : quoteList )
				{
					contactsToCheck.add(q.Contact__c);
					
					if( !contactCheckMap.containsKey(q.Contact__c) )
					{
						ContactCleanupObject contObj = new ContactCleanupObject();
						contObj.contact = q.Contact__r;
						contactCheckMap.put( q.Contact__c, contObj );
					}
				}
				
				for( Task t : [SELECT Id, WhoId, CreatedDate FROM Task WHERE WhoID = :contactsToCheck AND Subject = 'Send Mailbook' ] )
				{
					if( contactCheckMap.containsKey(t.WhoId) )
					{
						contactCheckMap.get( t.WhoId).taskList.add(t);
					}
				}
				//end the drag net to find the stragglers that make it through our system
				
				
				integer recordNumber = 1;
				//now look at last 2 weeks of quotes for quotes taht should receive a mailbook
				
				for( Quote__c q : quoteList )
				{
					
					if( ContactIdsSeen.contains(q.Contact__c))
						continue;
					else if( q.Contact__r.Address_1__c == null || q.Contact__r.Address_1__c == ''
					|| q.Contact__r.City__c == null || q.Contact__r.City__c == '' 
					//|| q.Contact__r.State__c == null || q.Contact__r.State__c == '' 
					|| q.Contact__r.Zip__c == null || q.Contact__r.Zip__c == '' )
						continue; //without a valid address, ther eis no point
						
					//look over all of the tasks in the list, finding the highest date
					DateTime createdDate = null;
					for( Task t : contactCheckMap.get( q.Contact__c ).taskList  )
					{
						if( createdDate == null
						|| t.CreatedDate > createdDate ) //if we havent found a createDate yet, 
							createdDate = t.CreatedDate; 
					}
					if( createdDate > q.Contact__r.Last_Mailbook_Sent__c )
					{
						Contact c = contactCheckMap.get( q.Contact__c ).contact;
						c.Last_Mailbook_Sent__c = createdDate;
						contactsToUpdate.add(c);
						continue;//we dont want this one
					}
					//

					ContactIdsSeen.add(q.Contact__c);
					
						
						
					MailbookItem mbi = new MailbookItem();
					mbi.Contact = q.Contact__r;
					mbi.Quote = q;
					mbi.recordNumber = recordNumber++;
										
					items.add(mbi);
				}
			}
			
			if( contactsToUpdate.size() >0 )
			{
				try
				{
					update contactsToUpdate;
				} catch (Exception ex )
				{
					Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.ERROR, ex + '' ) );
				}
				
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
		        mail.setToAddresses( toAddresses );
		        mail.setReplyTo('admin@a-stechnologies.com');   
		        mail.setSenderDisplayName('Salesforce - Mailbook Create Tasks');
		        mail.setSubject('Please make sure these contacts mailbook dates are correct' );
		        mail.setBccSender(false); 
		        mail.setUseSignature(false); 
		        mail.setPlainTextBody(contactsToUpdate.size() + ' contacts shouldnt be on here and need to be updated.' + contactsToUpdate  );
		        mail.setHtmlBody(contactsToUpdate.size() + ' contacts shouldnt be on here and need to be updated.' + contactsToUpdate);
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      

				//Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.INFO, contactsToUpdate.size() + ' contacts shouldnt be on here and need to be updated.' + contactsToUpdate ) );
				
			}
			
			return items;			
		}
	}

	public PageReference SelectAll() 
	{
		for( MailbookItem item : mailbookItems )
		{
			item.MakeTask = true;
		}	
		
		return null;
	}

	public PageReference MakeTasks() 
	{
	
		list<Task> newTasks = new list<Task>();
		set<Contact> contactsToUpdate = new set<Contact>();

		list<Id> contsToCheck = new list<Id>();
		for( MailbookItem item : mailbookItems )
			contsToCheck.add(item.Quote.contact__c);
		

		set<Id> ContactIdsCreated = new set<Id>();
		for( Contact c : [SELECT Id FROM Contact WHERE (Last_Mailbook_Sent__c >= LAST_N_DAYS:180 AND Id = :contsToCheck) ] )
		{//pick out contacts in this list who have been created recently
			if( !ContactIdsCreated.contains(c.Id) )
				ContactIdsCreated.add(c.Id);
		}



		for( MailbookItem item : mailbookItems )
		{
			
			if( item.MakeTask && !ContactIdsCreated.contains(item.Quote.contact__c))
			{
				Task t = new Task();
				t.whatid = item.Quote.Id;
				t.whoid = item.Quote.contact__c;
				t.activitydate = date.today().addDays(7);
				t.ownerid= GlobalStrings.MailBookResponsibleRep();
				t.subject = 'Send Mailbook';
				t.Description = '** created from Mailbook_CreateTasks tool'; 
				t.recordtypeid = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Mailbook').getrecordtypeid();
				
				
				newTasks.add(t);			

				if( !contactsToUpdate.contains( item.Contact ) )
				{
					item.Contact.Last_Mailbook_Sent__c = Datetime.now();
					contactsToUpdate.add(item.Contact );
				}
			}
		}
	

		if( newTasks.size() > 0 )	
		{
			Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.INFO, 'Successfully created '+newTasks.size()+' tasks.' ) );
			insert newTasks;
			
			if( contactsToUpdate.size() > 0 )
			{
				list<Contact> list_contactsToUpdate = new list<Contact>( contactsToUpdate);
				
				
				try
				{
					update list_contactsToUpdate;
				} catch (Exception ex )
				{
					Apexpages.addMessage( new Apexpages.Message( Apexpages.Severity.ERROR, ex + '' ) );
				}
				
				
			}		
		}
		
		mailbookItems = null; //trigger a new lookup
	
		return null;
	}

}