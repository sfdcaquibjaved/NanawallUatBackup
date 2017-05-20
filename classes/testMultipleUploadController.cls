@isTest
public class testMultipleUploadController {
    static testmethod void method1(){
        
//Split string 'file' in to two chunks, first chunk must be divisible by 3 for base64 encode with no padding
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
        list<Installation__c> acct = TestDataUtility.createInsTestData();
        for(Integer i=0;i<acct.size();i++){
            acct[i].Project__c = prolist.id;
        }
        insert acct;
        Blob b = Blob.valueOf('Test Data');        
        //Start the test
        Test.startTest();
    	
        list<Attachment> att = new list<Attachment>();
    	Attachment attachment = new Attachment();
    	attachment.ParentId = acct[0].Id;
    	attachment.Name = 'INS_CompleteTest Attachment for Parent';
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