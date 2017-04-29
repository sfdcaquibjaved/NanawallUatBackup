@isTest
public class testmultiAttachment_newController {
static testmethod void method1(){
        
//Split string 'file' in to two chunks, first chunk must be divisible by 3 for base64 encode with no padding
        
        list<Project__c> projectlist = TestDataUtility.createProjectTestData();
        insert projectlist;
        Blob b = Blob.valueOf('Test Data');        
        //Start the test
        Test.startTest();
    	list<Attachment> att = new list<Attachment>();
    	Attachment attachment = new Attachment();
    	attachment.ParentId = projectlist[0].Id;
    	attachment.Name = 'Test Attachment for Parent';
    	attachment.Body = b;
    	att.add(attachment);
        insert att;
        list<ContentVersion> cvv = new list<ContentVersion>();
    	COntentVersion c = new COntentVersion();
    	//c.ParentId = acct[0].Id;
    	c.Title = 'Test Attachment for Parent.png';
    	c.versionData = att[0].body;
        c.PathOnClient = 'Test Attachment for Parent.png';
    	cvv.add(c);
        //Send first part of the file to be uploaded
         PageReference pageRef = Page.multiAttachment_newvf;
        Test.setCurrentPage(pageRef);
        multiAttachment_newController controller = new multiAttachment_newController();
        controller.sobjId = projectlist[0].id;
        controller.SaveFiles();
        controller.newfiles = cvv;
        controller.cc = cvv[0];
        //Send the second piece of the file to be uploaded
        controller.goBack();
        Test.stopTest();
        
    }
}