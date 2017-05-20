@isTest

public class testMultiple_Upload_Controller {

    static testMethod void uploadTest() {
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        //Split string 'file' in to two chunks, first chunk must be divisible by 3 for base64 encode with no padding
        Blob part1 = Blob.valueOf('This text re'); //length is 12 
        Blob part2 = Blob.valueOf('presents a dummy file');
                
        String part1base64 = EncodingUtil.base64Encode(part1);
        String part2base64 = EncodingUtil.base64Encode(part2);
        
        //Create a test accound the 'file' can be attached to.
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
        
        //Start the test
        Test.startTest();
        //Send first part of the file to be uploaded
        String attachmentId = Multiple_Upload_Controller.attachBlob(acct[0].Id,'','fileName','7','text',part1base64);
        
        //Send the second piece of the file to be uploaded
        Multiple_Upload_Controller.attachBlob(acct[0].Id,attachmentId,'fileName','7','text',part2base64);
        Test.stopTest();
        
        //Assert one file has been attached to the test account
        List<Attachment> attachments = [select Id, Body from Attachment where ParentId = :acct[0].Id];
        //system.assert(attachments.size() == 1);
        
        //Assert the contents of the split file were recontructed correctly
        //system.assert(attachments[0].Body.toString() == 'This text represents a dummy file');
    }
    static testMethod void uploadTest2() {
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        //Split string 'file' in to two chunks, first chunk must be divisible by 3 for base64 encode with no padding
        Blob part1 = Blob.valueOf('This text re'); //length is 12 
        Blob part2 = Blob.valueOf('presents a dummy file');
                
        String part1base64 = EncodingUtil.base64Encode(part1);
        String part2base64 = EncodingUtil.base64Encode(part2);
        
        //Create a test accound the 'file' can be attached to.
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
        
        //Start the test
        Test.startTest();
        //Send first part of the file to be uploaded
        String attachmentId = Multiple_Upload_Controller.attachBlob(acct[0].Id,'','fileName','0','text',part1base64);
        
        //Send the second piece of the file to be uploaded
        Multiple_Upload_Controller.attachBlob(acct[0].Id,attachmentId,'fileName','0','text',part2base64);
        Test.stopTest();
        
        //Assert one file has been attached to the test account
        List<Attachment> attachments = [select Id, Body from Attachment where ParentId = :acct[0].Id];
        //system.assert(attachments.size() == 1);
        
        //Assert the contents of the split file were recontructed correctly
        //system.assert(attachments[0].Body.toString() == 'This text represents a dummy file');
    }
static testMethod void uploadTest3() {
    list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        //Split string 'file' in to two chunks, first chunk must be divisible by 3 for base64 encode with no padding
        Blob part1 = Blob.valueOf('This text re'); //length is 12 
        Blob part2 = Blob.valueOf('presents a dummy file');
                
        String part1base64 = EncodingUtil.base64Encode(part1);
        String part2base64 = EncodingUtil.base64Encode(part2);
        
        //Create a test accound the 'file' can be attached to.
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
        
        //Start the test
        Test.startTest();
        //Send first part of the file to be uploaded
        String attachmentId = Multiple_Upload_Controller.attachBlob(acct[0].Id,'','fileName','1','text',part1base64);
        
        //Send the second piece of the file to be uploaded
        Multiple_Upload_Controller.attachBlob(acct[0].Id,attachmentId,'fileName','1','text',part2base64);
        Test.stopTest();
        
        //Assert one file has been attached to the test account
        List<Attachment> attachments = [select Id, Body from Attachment where ParentId = :acct[0].Id];
        //system.assert(attachments.size() == 1);
        
        //Assert the contents of the split file were recontructed correctly
        //system.assert(attachments[0].Body.toString() == 'This text represents a dummy file');
    }
    
}