@IsTest
public class UpdateTaskToAttchements_test {
	
    static testMethod void testMethod1() {
        
        User testUser = TestDataUtility.createUser('admin1' , 'testUser1@testing.com');
        insert testUser;
        
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
      
        project__c p1= new project__c();
        p1.Name = 'Test Projecttest';
        p1.Application__c = 'Automotive';             
        p1.Project_Zip_Code__c = '12345' ;
        p1.Project_Country__c='United States';
        p1.Stage__c='Quote - Provided';
        insert p1;
        
        Task tsk = new Task();
        tsk.Subject = 'Email:1';
        tsk.Description = 'Test Description1';
        tsk.WhatId=p1.id;
        insert tsk;
        tsk.Subject = 'Email:2';
        update tsk;
        
        Attachment attach = new Attachment();
        attach.Name = 'Att1';
        attach.ContentType='text/plain';
        attach.ParentId = p1.id;
        attach.Body = Blob.valueOf('Unit Test Attachment Body');
        insert attach;
        
        
}
}