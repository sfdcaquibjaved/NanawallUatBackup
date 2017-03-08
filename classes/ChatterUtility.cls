global without sharing class ChatterUtility implements Schedulable {


	public static boolean FeedItemInsertTriggerCalled = false;

	public static boolean FeedCommentInsertTriggerCalled = false;

	public static map<Id,User> userMap = null;
	public static map<Id, User> getUserMap()
	{
		if(userMap != null )
			return userMap; 
			
		userMap = new map<Id, User>();
		
		
		for( User u : [SELECT Id, FirstName, LastName, Email FROM User ] )
		{
			userMap.put( u.Id, u);
		}
		
		return userMap;
	}

	public static void doCrossCommenting()
	{
		ChatterUtility.FeedCommentInsertTriggerCalled = true;
		
		map<Id,User> userLookup = ChatterUtility.getUserMap();
		
		
		list<Chatter_Comment_Join__c> triggerNew = [SELECT Id,Internal_FeedItemID__c, Communities_FeedItemID__c, Internal_Comment_ID__c, Communities_Comment_ID__c, Internal_ParentID__c, Communities_ParentID__c, Needs_Sync__c,OwnerId FROM Chatter_Comment_Join__c WHERE Needs_Sync__c = true];	
		set<Id> feedCommentIds = new set<Id>();
		map<Id, Chatter_Comment_Join__c> commentToJoinMap = new map< Id, Chatter_Comment_Join__c>();
		list<Id> postIds = new list<id>();
		for( Chatter_Comment_Join__c commentJoin : triggerNew )
		{
			commentJoin.Needs_Sync__c = false;
			if( commentJoin.Internal_Comment_ID__c != null && commentJoin.Communities_Comment_ID__c != null )
			{
				
				continue;  //if its already got two comments, we have no use for it.
			}
			if( commentJoin.Internal_Comment_ID__c != null  && !feedCommentIds.contains(commentJoin.Internal_Comment_ID__c) )
			{
				feedCommentIds.add( commentJoin.Internal_Comment_ID__c);
				commentToJoinMap.put( commentJoin.Internal_Comment_Id__c, commentJoin );
				postIds.add( commentJoin.Internal_FeedItemID__c );
				
			}	
			if( commentJoin.Communities_Comment_ID__c != null  && !feedCommentIds.contains(commentJoin.Communities_Comment_ID__c) )
			{
				
				feedCommentIds.add( commentJoin.Communities_Comment_ID__c);
				commentToJoinMap.put( commentJoin.Communities_Comment_ID__c, commentJoin );
				postIds.add( commentJoin.Communities_FeedItemID__c );
				
				
			}
				
		}
		
		
		map<Id, Chatter_Post_Join__c> feedItemToPostJoinMap = new map<Id, Chatter_Post_Join__c>();
		for( Chatter_Post_Join__c postJoin : [SELECT ID,Internal_Post_ID__c,Communities_Post_ID__c From Chatter_Post_Join__c WHERE Internal_Post_ID__c = :postIds OR Communities_Post_ID__c = :postIds] )
		{
			
			feedItemToPostJoinMap.put( postJoin.Internal_Post_ID__c, postJoin);
			feedItemToPostJoinMap.put( postJoin.Communities_Post_ID__c, postJoin);
			postIds.add( postJoin.Communities_Post_ID__c );//
		}

		//look up the postJoins of all the comments; need the networkScope of the other Post, not this parent
		map<Id, string> postToNetworkScopeMap = new map<Id, string>();
		for( FeedItem feedItem : [ SELECT Id, NetworkScope FROM FeedItem WHERE id = :postIds AND NetworkScope != null   ] )
		{
			postToNetworkScopeMap.put( feedItem.Id, feedItem.NetworkScope );
		}
		
		
		list<Chatter_Comment_Join__c> commentJoinsToUpdate = new list<Chatter_Comment_Join__c>();
//if(feedCommentIds.size() > 0 )
	system.debug( 'FeedComments: '+ feedCommentIds );		
	
		list<Exception> exceptions = new list<Exception>();
	
		for( FeedComment comment : [SELECT Id, CommentBody, CreatedById, RelatedRecordId FROM FeedComment WHERE Id = : feedCommentIds] )
		{
			Chatter_Comment_Join__c commentJoin = commentToJoinMap.get( comment.Id );		
			
			
			try
			{
				

				if( commentJoin != null )
				{ //we found a join on the post this comment is tacked on to
				
				
					// if the comment was added to the internal org, add a corresponding one to the community and update
	
	
	
					if( commentJoin.Communities_Comment_ID__c == null )
					{
	
	
						string commFeedItemID = feedItemToPostJoinMap.get( commentJoin.Internal_FeedItemID__c).Communities_Post_ID__c;					
						ConnectApi.Comment response = null;
	system.debug('checking comment: ' + comment.Id + ' ; ' + comment.RelatedRecordId );					
						if( comment.RelatedRecordId != null )
						{
							ContentVersion vers = [SELECT Id, FileType,VersionData, Description, Title,FileExtension FROM ContentVersion WHERE Id = :comment.RelatedRecordId ];
							
							ConnectApi.CommentInput input = new ConnectApi.CommentInput();
							ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
							ConnectApi.TextSegmentInput textSegment;
							
							textSegment = new ConnectApi.TextSegmentInput();
							textSegment.text = comment.CommentBody;
							
							messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
							messageInput.messageSegments.add(textSegment);
							
							input.body = messageInput;
							
							ConnectApi.NewFileAttachmentInput attachmentInput = new ConnectApi.NewFileAttachmentInput();
							attachmentInput.description = vers.Description;
							attachmentInput.title = vers.Title;
							input.attachment = attachmentInput;
							
	//						Blob fileBlob = Blob.valueOf(fileContents);
							Blob fileBlob = vers.VersionData;
	system.debug('a');						
							ConnectApi.BinaryInput binaryInput = new ConnectApi.BinaryInput(fileBlob, vers.FileType, vers.Title + '.' + vers.FileExtension );
							
							response = ConnectApi.ChatterFeeds.postComment(postToNetworkScopeMap.get( commFeedItemID ), commFeedItemID, input, binaryInput);
							
						} else 
						{
	system.debug('b');						
							response = ConnectApi.ChatterFeeds.postComment( postToNetworkScopeMap.get( commFeedItemID ), commFeedItemID,  comment.CommentBody);						
						}
	
	
						commentJoin.Communities_Comment_ID__c = response.Id;
						
					} else 
					{
						User u = userLookup.get(comment.CreatedById);
						
						ConnectApi.Comment response = null;
						if( comment.RelatedRecordId != null )
						{
							ContentVersion vers = [SELECT Id, FileType,VersionData, Description, Title,FileExtension FROM ContentVersion WHERE Id = :comment.RelatedRecordId ];
							
							ConnectApi.CommentInput input = new ConnectApi.CommentInput();
							ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
							ConnectApi.TextSegmentInput textSegment;
							
							textSegment = new ConnectApi.TextSegmentInput();
							textSegment.text = 'Posted on behalf of '+ u.FirstName + ' ' + u.LastName+' ('+u.Email+'):\n\n' + comment.CommentBody;
							
							messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
							messageInput.messageSegments.add(textSegment);
							
							input.body = messageInput;
							
							ConnectApi.NewFileAttachmentInput attachmentInput = new ConnectApi.NewFileAttachmentInput();
							attachmentInput.description = vers.Description;
							attachmentInput.title = vers.Title;
							input.attachment = attachmentInput;
							
							Blob fileBlob = vers.VersionData;
	system.debug('a');						
							ConnectApi.BinaryInput binaryInput = new ConnectApi.BinaryInput(fileBlob, vers.FileType, vers.Title + '.' + vers.FileExtension );
							
							response = ConnectApi.ChatterFeeds.postComment(null, feedItemToPostJoinMap.get( commentJoin.Communities_FeedItemID__c).Internal_Post_ID__c, input, binaryInput);					
						} else 
						{
							response = ConnectApi.ChatterFeeds.postComment( null, feedItemToPostJoinMap.get( commentJoin.Communities_FeedItemID__c).Internal_Post_ID__c, 'Posted on behalf of '+ u.FirstName + ' ' + u.LastName+' ('+u.Email+'):\n\n' +comment.CommentBody);	
						
						}
						commentJoin.Internal_Comment_ID__c = response.Id;
	
					}
				
					commentJoinsToUpdate.add(commentJoin);
				
				
				} else 
				{
					system.debug('commentjoin is null. hmmm');
				}
			} catch( Exception ex )
			{
				exceptions.add(ex);
			
			}
		}



		try
		{
			if( commentJoinsToUpdate.size() > 0 )
				update commentJoinsToUpdate;
		} catch (Exception ex )
		{
			exceptions.add(ex);
		}		
			
		try
		{
			update triggerNew; // this should flag all of the incoming comments as not needing a sync
		} catch (Exception ex )
		{
			exceptions.add(ex);
		}		
			
	
		if(exceptions.size() > 0 )
		{
			string exstring = '';
			for( Exception ex : exceptions )
			{
				exstring += ex+'\n';
			}
			
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
	        mail.setToAddresses( toAddresses );
	        mail.setReplyTo('admin@a-stechnologies.com');   
	        mail.setSenderDisplayName('Salesforce - ChatterUtility');
	        mail.setSubject('Salesforce - ChatterUtility Comment Exceptions' );
	        mail.setBccSender(false); 
	        mail.setUseSignature(false);
	        mail.setPlainTextBody( '  The following exceptions occurred when trying to insert comments: ' + exstring);
	        mail.setHtmlBody('  The following exceptions occurred when trying to insert comments: ' + exstring);
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
			
		}
			
			
	}

	public static void doCrossPosting() 
	{
	
	ChatterUtility.FeedItemInsertTriggerCalled = true;
		list<Chatter_Post_Join__c> triggerNew = [SELECT Id, Internal_Post_ID__c, Communities_Post_ID__c, Needs_Sync__c,OwnerId FROM Chatter_Post_Join__c WHERE Needs_Sync__c = true];	
	 
system.debug('cross posting ');
		map<Id,User> userLookup = ChatterUtility.getUserMap();

			list<Exception> exceptions = new list<Exception>();
	
			//load up the map of all groups on the system
			map<string, map<string,CollaborationGroup>> groupMap = new map<string, map<string,CollaborationGroup>>();
			map<string, CollaborationGroup> allGroupsMap = new map<string, CollaborationGroup>();
			list<Chatter_Post_Join__c> postJoins = new list<Chatter_Post_Join__c>();
			
			for( CollaborationGroup g : [SELECT Id,NetworkId, Name  FROM CollaborationGroup])
			{
				if( !groupMap.containsKey( g.Name) )
				{
					groupMap.put( g.Name, new map<string,CollaborationGroup>() );
				}
				
				groupMap.get(g.Name).put( g.NetworkId, g );
				allGroupsMap.put( g.Id, g );

			}
	
			list<Id> feedItemIds = new list<Id>();
			map<Id, Chatter_Post_Join__c> postIdToJoinMap = new map<Id, Chatter_Post_Join__c>();
			for( Chatter_Post_Join__c pj : triggerNew)
			{
				
			
				if( 
					(pj.Internal_Post_ID__c != null 
						&& pj.Communities_Post_ID__c != null) 
					|| !pj.Needs_Sync__c )
					{
						pj.Needs_Sync__c = false;
						postJoins.add(pj);
						continue; // the point of this trigger is to make sure the posts are correlated. if they are already connected, dont work on them
					}
				if( pj.Internal_Post_ID__c != null )
				{
					feedItemIds.add(pj.Internal_Post_ID__c);
					postIdToJoinMap.put( pj.Internal_Post_ID__c, pj);
				} else 
				{
					feedItemIds.add(pj.Communities_Post_ID__c);
					postIdToJoinMap.put( pj.Communities_Post_ID__c, pj);
				}
				pj.Needs_Sync__c = false;
			}
			list<FeedItem> feedItems = [ SELECT Id, ParentId, Body,ContentData,ContentType,ContentFileName,NetworkScope, ContentDescription, LinkUrl FROM FeedItem WHERE Id = :feedItemIds];
	
			map<Id,Id> newFeedItemIDs = new map<Id,Id>();
			list<FeedItem> feeditemUpdates = new list<FeedItem>();
			
			
			set<Id> feedItemsSeen = new set<Id>();
			set<Id> postJoinsSeen = new set<Id>();
			for( FeedItem feedItem : feedItems )
			{
				if( feedItemsSeen.contains(feedItem.Id) )
					continue;
			
				try 
				{
					feedItemsSeen.add(feedItem.Id);
	
					CollaborationGroup incomingGroup = allGroupsMap.get( feedItem.ParentId );			
					
					if( incomingGroup != null)
					{
	
						CollaborationGroup chattergroup = null;
						
						for( string key : groupMap.get(incomingGroup.Name).keySet()  )
						{
							
							//this will run in system context in the workflow; need to look up the network id of the feeditem in question
							/*
						if (
							(Network.getNetworkId() == null && key != null) 
							|| ( Network.getNetworkId() != null && key == null)
						) {
							chattergroup = groupMap.get(incomingGroup.Name).get(key );
							break;
						} 				
						*/
							if (
								( feeditem.NetworkScope == null && key != null) 
								|| ( feedItem.NetworkScope != null && key == null)
							) {
								chattergroup = groupMap.get(incomingGroup.Name).get(key );
								break;
							} 				
	
							
						}			 
						
						if( chattergroup != null )
						{
							Chatter_Post_Join__c postJoin = postIdToJoinMap.get(feedItem.Id);
	
							if( postJoinsSeen.contains(postJoin.Id) )
								continue;
								
							postJoinsSeen.add(postJoin.Id); 
	
							ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
							
							ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
	
							List<ConnectApi.MessageSegmentInput> segmentList = new List<ConnectApi.MessageSegmentInput>();
							ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
							
							if( chatterGroup.NetworkId  == null )
							{	//we are posting from a community to internal, wont have a valid userid
								User u = userLookup.get(postJoin.OwnerId);
								textSegment.text = 'Posted on behalf of '+ u.FirstName + ' ' + u.LastName+' ('+u.Email+'):\n\n' +feedItem.Body;
								
							} else
							{
								if( feedItem.Body != null )
									textSegment.text = feedItem.Body;
								else textSegment.text = '';
							}
							
							segmentList.add((ConnectApi.MessageSegmentInput)textSegment);
	
	
							if( feedItem.LinkUrl != null )
							{
								ConnectApi.LinkSegmentInput linkSegment = new ConnectApi.LinkSegmentInput();
								linkSegment.url = feedItem.LinkUrl;
								segmentList.add( (ConnectApi.MessageSegmentInput)linkSegment);
							}
							body.messageSegments = segmentList;
	
							input.body = body;
	
							
	
	
							// POST FILE_FEED_ITEM
							ConnectApi.BinaryInput v_feedBinary = null;
							
	
							if( feedItem.ContentData != null )
							{
								ConnectApi.NewFileAttachmentInput v_fileIn = new ConnectApi.NewFileAttachmentInput();
								v_fileIn.title = feedItem.ContentFileName;
								v_fileIn.description = feedItem.ContentDescription;
		
								input.attachment = v_fileIn;
		
								v_feedBinary = new ConnectApi.BinaryInput(feedItem.ContentData, feedItem.ContentType, feedItem.ContentFileName);
							}
							
	
							ConnectApi.FeedItem response = ConnectApi.ChatterFeeds.postFeedItem(chatterGroup.NetworkId, ConnectApi.FeedType.Record, chatterGroup.Id, input, v_feedBinary);
	
							
							newFeedItemIDs.put(response.Id, postJoin.OwnerId);
							
							if( feeditem.NetworkScope == null )
							{
								postJoin.Communities_Post_ID__c = response.Id;
							} else 
							{
								postJoin.Internal_Post_ID__c = response.Id;
							}
	
							postJoin.Needs_Sync__c = false;
							postJoins.add(postJoin);
							
	
						}
						
					}
					
				} catch( Exception ex )
				{
					exceptions.add(ex);
				}		
					
			}
			
			try
			{
				if( postJoins.size() > 0 )
					update postJoins;
			} catch( Exception ex )
			{
				exceptions.add(ex);			
			}				
			
			if(exceptions.size() > 0 )
			{
				string exstring = '';
				for( Exception ex : exceptions )
				{
					exstring += ex+'\n';
				}
				
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
		        mail.setToAddresses( toAddresses );
		        mail.setReplyTo('admin@a-stechnologies.com');   
		        mail.setSenderDisplayName('Salesforce - ChatterUtility');
		        mail.setSubject('Salesforce - ChatterUtility Post Exceptions' );
		        mail.setBccSender(false); 
		        mail.setUseSignature(false);
		        mail.setPlainTextBody( '  The following exceptions occurred when trying to insert posts: ' + exstring);
		        mail.setHtmlBody('  The following exceptions occurred when trying to insert posts: ' + exstring);
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
				
			}			
			
	}

	//scheduling maintenance code
	private static string cronKey = 'ChatterUtility_20141002';
	public static string getcronkey() { return cronkey; }
	

	private static boolean ChatterUtilityRunning = false;
	global void execute(SchedulableContext SC) {

		if( !ChatterUtilityRunning )
		{
			ChatterUtilityRunning = true;
			//this is where the automation will be called
	
			ChatterUtility.doCrossPosting();
			ChatterUtility.doCrossCommenting();
			
			try
			{
				//clean up the scheduler
				list<Application_Setting__c> settingsToDelete = new list<Application_Setting__c>();
				for(Application_Setting__c cronSetting: [SELECT Setting_Name__c, Setting_Value__c FROM Application_Setting__c WHERE Setting_Name__c = :ChatterUtility.getcronKey() ])
				{
					//this should only be triggered when there is no Setting for the job
					//this will get recreated byt he insertScheduler call below
					try {
						System.abortJob(  cronSetting.Setting_Value__c );		
						
					} catch(Exception ex )
					{}
					settingsToDelete.add(cronSetting);		
				}
				delete settingsToDelete;
			} catch ( Exception ex )
			{
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
		        mail.setToAddresses( toAddresses );
		        mail.setReplyTo('admin@a-stechnologies.com');   
		        mail.setSenderDisplayName('Salesforce - Chatter Utility');
		        mail.setSubject('Chatter Utility - Scheduler exception' );
		        mail.setBccSender(false); 
		        mail.setUseSignature(false);
		        mail.setPlainTextBody('  got an exception when trying to clean up the settings: ' + ex );
		        mail.setHtmlBody('  got an exception when trying to clean up the settings: ' + ex );
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
			
			}			
	
			try
			{
				//reschedule it for one minute more
				ChatterUtility.insertScheduler();			
			} catch( Exception ex )
			{
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
		        mail.setToAddresses( toAddresses );
		        mail.setReplyTo('admin@a-stechnologies.com');   
		        mail.setSenderDisplayName('Salesforce - Chatter Utility');
		        mail.setSubject('Chatter Utility - Scheduler exception' );
		        mail.setBccSender(false); 
		        mail.setUseSignature(false);
		        mail.setPlainTextBody('  got an exception when trying to insert a new scheduler: ' + ex );
		        mail.setHtmlBody('  got an exception when trying to insert a new scheduler:' + ex );
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
			
			}
			
	
	        
		
		}



		 
	}
	
	global static void insertScheduler() {
		DateTime nextRunTime = datetime.now().addMinutes( 1 );
		String jobID = System.schedule( ChatterUtility.getcronKey(),'0 '+nextRunTime.minute()+' * * * ?', new ChatterUtility() );
		
		Application_Setting__c cronSetting = new Application_Setting__c();
		cronSetting.Setting_Name__c = ChatterUtility.getcronKey();
		cronSetting.setting_value__c = jobid;
		insert cronSetting;	

	}
	

}