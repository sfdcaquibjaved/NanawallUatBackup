@IsTest
public class UpdateTaskToAttchements_test {
    static testMethod void testMethod1() {
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser = TestDataUtility.createUser('admin1' , 'testUser1@testing.com');
        insert testUser;
        
        list<project__c> pro = new list<project__c>();
        
        project__c p1= new project__c();
        p1.Name = 'Test Projecttest';
        p1.Application__c = 'Automotive';             
        p1.Project_Zip_Code__c = '12345' ;
        p1.Project_Country__c='United States';
        //p1.Close_Date__c=Date.newInstance(2015, 12, 12);
        p1.Stage__c='Quote - Provided';
        pro.add(p1);
        
        project__c p2= new project__c();
        p2.Name = 'Test Projttest';
        p2.Application__c = 'Automotive';             
        p2.Project_Zip_Code__c = '12345' ;
        p2.Project_Country__c='United States';
        //p1.Close_Date__c=Date.newInstance(2015, 12, 12);
        p2.Stage__c='Quote - Provided';
        pro.add(p2);
        insert pro;
        
        //Inserting Account Data
        list<Account> acc = new list<account>();
        acc= TestDataUtility.createAccountTestData();
        acc[0].Type='Developer';
        acc[0].OwnerId=testUser.id;    
        insert acc;
        
        //Inserting Contact Data
        list<Contact> con = new list<Contact>();
        con = TestDataUtility.createConTestData();
        con[0].accountid=acc[0].id;
        con[0].FirstName = 'foo';
        con[0].LastName = 'bar';
        con[0].MailingStreet = 'street';
        insert con;
        
        //Inserting Opportunity Data
        list<opportunity> opp = new list<opportunity>();
        opp=TestDataUtility.createOppTestData();
        opp[0].Project_Name__c=pro[0].id;
        opp[0].accountid=acc[0].id;
        opp[0].ownerId=testUser.id;
        insert opp;
        /*
list<Task> tasklst = new list<Task>();
Task tsk = new Task();
tsk.Subject = 'Email:';
tsk.Description = 'Test Description';
tsk.WhatId=pro[0].id;
tasklst.add(tsk);

Task tsk1 = new Task();
tsk1.Subject = 'Email:1';
tsk1.Description = 'Test Description1';
tsk1.WhatId=pro[0].id;
tasklst.add(tsk1);

Task tsk2 = new Task();
tsk2.Subject = 'Email:2';
tsk2.Description = 'Test Description2';
tsk2.WhatId=pro[0].id;
tasklst.add(tsk2);
insert tasklst;
*/
        /*
list<Attachment> attachlist = new list<Attachment>();
Attachment attach = new Attachment();
attach.Name = 'Att1';
attach.ContentType='text/plain';
attach.ParentId = pro[0].id;
attach.Body = Blob.valueOf('Unit Test Attachment Body');
attachlist.add(attach);

Attachment attach2 = new Attachment();
attach2.Name = 'Att2';
attach2.ContentType='text/plain';
attach2.ParentId = pro[0].id;
attach2.Body = Blob.valueOf('Unit Test Attachment Body1');
attachlist.add(attach2);

// Test.startTest();
insert attachlist;
update attachlist;
// Test.stopTest();
*/
        // test.starttest();
        /*list<Task> tasklst = new list<Task>();
Task tsk = new Task();
tsk.Subject = 'Email:';
tsk.Description = 'Test Description';
tsk.WhatId=pro[0].id;
tasklst.add(tsk);


Task tsk1 = new Task();
tsk1.Subject = 'Email:';
tsk1.Description = 'Test Description';
tsk1.WhatId=pro[0].id;
tasklst.add(tsk1);*/
        
        list<Task> tasklst = new list<Task>();
        Task tsk2 = new Task();
        tsk2.Subject = 'Email:1';
        tsk2.Description = 'Test Description1';
        tsk2.WhatId=pro[0].id;
        tasklst.add(tsk2);
        //  insert tsk2;
        //insert tasklst;
        Task tsk3 = new Task();
        tsk3.Subject = 'Email:1';
        tsk3.Description = 'Test Description1';
        tsk3.WhatId=tsk2.id;
        tasklst.add(tsk3);
        insert tasklst;
        
        
        list<Attachment> attachlist = new list<Attachment>();
        Attachment attach = new Attachment();
        attach.Name = 'Att1';
        attach.ContentType='text/csv';
        attach.ParentId = tsk3.Id;
        attach.Body = Blob.valueOf('Unit Test Attachment Body');
        attachlist.add(attach); 
        insert attachlist;
        
        
        // system.debug('testtttttsttttttt......'+tsk.id);
        // system.debug('attachhhhhhhhhhh......'+attach);
        //attach.ParentId = tsk.id;
        // update attach;
        
        
        
        //delete tsk; 
        //
        //  test.stopTest();
    }
}