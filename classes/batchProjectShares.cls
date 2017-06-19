global class batchProjectShares implements Database.Batchable < sObject > {
     String query;
      public  list<Community_Users__c> myCS1 = Community_Users__c.getall().values();
    // Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
       // String filters = '005A0000000N1l5IAC';//old Brad Burden ID
        set<Id> oldids = new set<Id>();
        for(Community_Users__c c:myCS1){
            oldids.add(c.OldUserId__c);
        }
        String testid = '02cA000005BkzzGIAR';//for testing
        Query = 'Select id, Rowcause, ParentId, UserorGroupId, AccessLevel from Project__Share where UserorGroupId in: oldids';
        system.debug('Value of Query' + Query);
        System.debug('Returned record'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC, List < Project__Share > prosharelist) {
        System.debug('In execute'+prosharelist);
         List<Project__Share> ShareProject = new List<Project__Share>();
        Map<String,String> userids= new map<String,String>();
        for(Community_Users__c cu:myCS1){
            System.debug('In map'+myCS1);
        userids.put(cu.OldUserId__c, cu.NewUserID__c);
        }
        for(Project__Share ps:prosharelist){
            System.debug('In final for');
                 Project__Share ProShare = new Project__Share ();
                 ProShare.AccessLevel = ps.AccessLevel;
                 ProShare.ParentID = ps.ParentID ;
                 ProShare.RowCause = ps.Rowcause;
                 ProShare.UserOrGroupId = userids.get(ps.UserorGroupId);//Custom setting value
                 ShareProject.add(ProShare);
            /*
             Project__Share newproshare = ps.clone(false,false,false,false);
             newproshare.UserorGroupID = userids.get(ps.UserorGroupId);
             ShareProject.add(newproshare);
             */
        }
        System.debug('list to insert'+ShareProject);
        try{
            if(!prosharelist.isEmpty()){
               //delete prosharelist;
               System.debug('Success delete');
            }
        }
        catch(Exception e){
            System.debug('Exception is:'+e);
        }
        try{if(!ShareProject.isEmpty()){
            System.debug('Success!');
            insert ShareProject ;
         }
        }
        catch(Exception e){
            System.debug('Exception is:'+e);
        }
    }
    global void finish(Database.BatchableContext BC) {

    }

}