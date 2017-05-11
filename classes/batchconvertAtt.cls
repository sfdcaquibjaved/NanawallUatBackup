/* Class: batchconvertAtt
 * Purpose: To convert all existing attachments on Installation object to Files
 * Date Created: May 2017
 */
global class batchconvertAtt implements Database.Batchable < sObject >  {
String query;
// Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
        String filters ='a4kQ00000006Gu1';
        Query = 'SELECT ID, Name, Body ,ParentId FROM Attachment WHERE ParentId =: filters';
        system.debug('Value of Query' + Query);
        return Database.getQueryLocator(query);
    }
// Execute Method of Batch class
    global void execute(Database.BatchableContext BC, List < Attachment > attlist) 
    {
        set<Id> attachmentdelete = new set<Id>();
        list<ContentVersion> ContentVersionInsert = new list<ContentVersion>();
        //Iterating over the list of attachments
        for(Attachment a:attlist) {
                System.debug('in here');
                ContentVersion cont = new ContentVersion();
                cont.versionData = a.Body;
                cont.title = a.Name;
                cont.ParentId__c = a.ParentId; //Here we are storing the Parent RecordId in a custom text field
                cont.pathOnClient = '/'+ a.Name;
                
                ContentVersionInsert.add(cont);
                attachmentdelete.add(a.id);
        }
                insert ContentVersionInsert;
        List <FeedItem> FeedItemContentList = new List <FeedItem> () ;
        
        for(ContentVersion C : ContentVersionInsert ){
                    //Attaching FeedItem to ContentVersion and InstallationForm
                    //Here we give the Parent RecordId to the FeedItem to relate it to the record
                    FeedItem elm = new FeedItem(Body = 'Post with related document body', ParentId = c.ParentId__c, RelatedRecordId = c.ID, Type = 'ContentPost');
                    FeedItemContentList.add(elm);
                    
                }
            
        
        
        try{
            if(FeedItemContentList.size() > 0){
            system.debug('In here FeedItemContentList' +FeedItemContentList);
            insert FeedItemContentList ;
            }
            
            delete [select id from attachment where id in:attachmentdelete];
                System.debug('size of att'+attachmentdelete.size());
            }
        
            catch(Exception e){
                System.debug('e '+e);
            } 
    }
    global void finish(Database.BatchableContext BC) {

    }
}