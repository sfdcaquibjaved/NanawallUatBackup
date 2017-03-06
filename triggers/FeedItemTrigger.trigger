trigger FeedItemTrigger on FeedItem (before insert) {
		FeedItemTriggerHandler.FeedVisiblity(Trigger.new) ; 
}