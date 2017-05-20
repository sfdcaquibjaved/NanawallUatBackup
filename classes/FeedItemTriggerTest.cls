@IsTest
public class FeedItemTriggerTest {

static testMethod void FeedItemTriggerTestMethod1()
{
    list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
    insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        Project__c prolist = new Project__c();
        prolist.Project_Zip_Code__c = '94040';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Installation__c> instlist = TestDataUtility.createInsTestData();
        for(Integer i=0;i<instlist.size();i++){
            instlist[i].Project__c = prolist.id;
        }
        insert instlist;
        Installation__c instNew = new Installation__c();
       instNew.Status__c = 'Open';
       instNew.project__c = prolist.id;
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