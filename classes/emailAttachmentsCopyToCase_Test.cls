@isTest
public class emailAttachmentsCopyToCase_Test {
    public static list < Case > cases;
    public static list < Account > accounts;
    public static list < Contact > contacts;
    public static list < CaseComment > ccList;
    //public static list < EmailMessage > emailList;
    public static Integer testDataSize = 20;

    public static testMethod void emailToCase1() {

        list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
        z = TestDataUtility.getTerritoryMaster();
        insert z;

        User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
        insert testUser;

        User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
        insert testUser1;
        //System.runAs(testUser) {

        list < Account > Acc = new list < Account > ();
        Acc = TestDataUtility.createAccountTestData();
        insert Acc[0];

        list < Contact > Con = new list < Contact > ();
        Con = TestDataUtility.createConTestData();
        Con[0].Accountid = Acc[0].id;
        insert Con[0];

        Profile pf = [Select Id from Profile where Name = 'Standard User'];

        User u1 = new User();
        //u.FirstName = 'Test';
        u1.LastName = 'Nicomatic22';
        u1.Email = 'test1@gmail.com.sandbox';
        u1.CompanyName = 'tes1t.com';
        u1.Title = 'Test User1';
        u1.Username = 'test1@gmail.com.sandbox';
        u1.Alias = 'ni1';
        u1.CommunityNickname = 'ni1';
        u1.TimeZoneSidKey = 'America/Mexico_City';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.ProfileId = pf.Id;
        u1.LanguageLocaleKey = 'en_US';
        insert u1;

        cases = TestDataUtility.createCaseTestData();
        //cases[0].Who_is_Calling__c = 'Architect';
        cases[0].AccountId = acc[0].id;
        cases[0].ContactId = con[0].id;
        cases[0].Dummy__c = false;
        // cases[0].Caller_contact__c = con[1].id;
        // cases[0].Ship_To__c = 'Caller Contact';

        try {
            insert cases;
        } catch (Exception e) {
            system.debug('Exception is:' + e);
        }

		
        /***Creating Case comments for a case***/
        ccList = TestDataUtility.createCaseCommentTestData();
        ccList[0].ParentId = cases[0].id;
        ccList[0].IsPublished = true;
        try{
        insert ccList;
        }catch(Exception e){
        system.debug('Exception is:' + e);
        }
        
        
        Task t1 = New Task(Subject = 'test', Priority = 'Normal', Status = 'Not started');
        t1.OwnerId = u1.Id;
        insert t1;
        t1.status = 'Need identified';
        update t1;

        list < emailmessage > emlist = new list < emailmessage > ();
        set < emailmessage > emset = new set < emailmessage > ();
        emailmessage em = new emailmessage();
        em.fromaddress = 'Test@test.com';
        em.toaddress = 'test1@test.com';
        em.subject = 'Test Email';
        em.textbody = 'testing';
        em.parentid = cases[0].id;
        emset.add(em);
        emlist.addall(emset);
        //test.starttest();
        try {
            insert emlist;
        } catch (Exception e) {
            system.debug('Exception is:' + e);
        }

        //test.stoptest();  
        list < Account > a = new list < Account > ();
        //Account a = new Account(Name='newAcct'); 
        //Test.startTest(); 

        A = TestDataUtility.createAccountTestData();
        insert a[0];
        //Test.stopTest();

        Attachment attach = new Attachment();
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId = emlist[0].Id;
        attach.ContentType = 'application/msword';
        attach.IsPrivate = false;
        attach.Description = 'Test';
        insert attach;

        //emailAttachmentsCopyToCase emailAttach = new emailAttachmentsCopyToCase();
        emailAttachmentsCopyToCase.copyEmailAttachmentsToCase(emset);

    }
}