trigger FeedItem_Inserted on FeedItem (after insert, before insert) {


    if(trigger.isAfter)
    {
        if( !ChatterUtility.FeedItemInsertTriggerCalled )
        {  //we need to avoid infinite recursion with this flag
            ChatterUtility.FeedItemInsertTriggerCalled = true;


            set<id> existingJoins = new set<Id>();
            for( Chatter_Post_Join__c postJoin : [SELECT Id FROM Chatter_Post_Join__c WHERE Internal_Post_ID__c = :trigger.newMap.keySet() OR Communities_Post_ID__c = :trigger.newMap.keySet() ] )
            {
                existingJoins.add( postJoin.Communities_Post_ID__c );
                existingJoins.add( postJoin.Internal_Post_ID__c );
            }


            list<Chatter_Post_Join__c> postJoins = new list<Chatter_Post_Join__c>();
            for( FeedItem item : trigger.new )
            {
                
                if( existingJoins.contains(item.Id) )
                    continue;
                
                
                Chatter_Post_Join__c postJoin = new Chatter_Post_Join__c();
                postJoin.Needs_Sync__c = true; //when the workflow switches this to true, a trigger will be called
                if( Network.getNetworkId() == null )
                {
                    postJoin.Internal_Post_ID__c = item.Id;
    //              postJoin.Communities_Post_ID__c = response.Id;
                } else 
                {
                    postJoin.Communities_Post_ID__c = item.Id;
    //              postJoin.Internal_Post_ID__c = response.Id;
                }
                
                postJoins.add(postJoin);
            }           
            insert postJoins;



            if( Network.getNetworkId() == null )
            {
                //we can sync immediately for internal posts, because they have permission
                ChatterUtility.doCrossPosting();
            } else
            {
                //insert a scheduled job for a second from now. hopefully that works in the system context
/*
                String hour = String.valueOf(Datetime.now().hour());
                String min = String.valueOf(Datetime.now().minute() + 1); String ss = String.valueOf(Datetime.now().second());
                
                //parse to cron expression
                String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';

                System.schedule( 'ChatterPostSync',nextFireTime, new ChatterUtility() );
*/
            }
        }
            
        

         
        
    
    
    }


}