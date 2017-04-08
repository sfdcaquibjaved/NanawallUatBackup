@isTest
public class testMultipleUploadController {
    static testmethod void method1(){
        
//Split string 'file' in to two chunks, first chunk must be divisible by 3 for base64 encode with no padding
        
        list<Installation__c> acct = TestDataUtility.createInsTestData();
        insert acct;
        Blob b = Blob.valueOf('Test Data');        
        //Start the test
        Test.startTest();
    	
        list<Attachment> att = new list<Attachment>();
    	Attachment attachment = new Attachment();
    	attachment.ParentId = acct[0].Id;
    	attachment.Name = 'Test Attachment for Parent';
    	attachment.Body = b;
    	att.add(attachment);
        insert att;
        //Send first part of the file to be uploaded
         PageReference pageRef = Page.MultipleAttachmentsVFPage;
        Test.setCurrentPage(pageRef);
        MultipleUploadController controller = new MultipleUploadController();
        list<attachment>atta = controller.getAttachments();
        controller.sobjId = acct[0].id;
        controller.attachments = att;
        //Send the second piece of the file to be uploaded
        controller.saveAttachments();
        Test.stopTest();
        
    }
}