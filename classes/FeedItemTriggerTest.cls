@IsTest
public class FeedItemTriggerTest {

static testMethod void FeedItemTriggerTestMethod1()
{
    
        Installation__c instNew = new Installation__c();
       instNew.Status__c = 'Open';
       
       instNew.Installation_Date__c = system.today() ; 
       insert instNew;       
    FeedItem post = new FeedItem();
    post.Body = 'Test Body';
    post.Visibility = 'AllUsers';
    post.ParentId = instNew.id ;  
    
    test.startTest();
    insert post;
    test.stopTest();
}
}