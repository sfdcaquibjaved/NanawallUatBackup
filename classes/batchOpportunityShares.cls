global class batchOpportunityShares implements Database.Batchable < sObject > {
        String query;
        list<Community_Users__c> myCS1 = Community_Users__c.getall().values();
    // Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
       // String filters = '005A0000000N1l5IAC';//old Brad Burden ID
        set<Id> oldids = new set<Id>();
        for(Community_Users__c c:myCS1){
            oldids.add(c.OldUserId__c);
        }
        String testid = '';//for testing
        Query = 'Select id, Rowcause, OpportunityId, UserorGroupId, OpportunityAccessLevel from OpportunityShare WHERE UserorGroupId =:oldids and Id=:testid';
        system.debug('Value of Query' + Query);
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC, List < OpportunityShare > oppsharelist) {
        List<OpportunityShare> OppToShare = new list<OpportunityShare>();
        Map<String,String> userids= new map<String,String>();
        for(Community_Users__c cu:myCS1){
        userids.put(cu.OldUserId__c, cu.NewUserID__c);
        }
        for(OpportunityShare os:oppsharelist){
        OpportunityShare OppShare = new OpportunityShare ();
                 OppShare.OpportunityAccessLevel = os.OpportunityAccessLevel;
                 OppShare.OpportunityID = os.OpportunityID ;
                 OppShare.RowCause = os.Rowcause;
                 OppShare.UserOrGroupId = userids.get(os.UserorGroupId);//Custom setting value
                 OppToShare.add(OppShare);
            /*
             OpportunityShare newoppshare = os.clone(false,false,false,false);
             newoppshare.UserorGroupID = userids.get(os.UserorGroupId);
             OppToShare.add(newoppshare);
             */
        }
        System.debug('list to insert'+OppToShare);
        try{
            if(!oppsharelist.isEmpty()){
               delete oppsharelist;
               System.debug('Success delete');
            }
         if(!OppToShare.isEmpty()){
            System.debug('Success!');
            insert OppToShare ;
         }
        }
        catch(Exception e){
            System.debug('Exception is:'+e);
        }
    }
    global void finish(Database.BatchableContext BC) {

    }

}