@isTest
public class Attachment_Trigger_on_Project_Test {
    static testmethod void unitest1(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
        
        //Inserting Project Data
        list<project__c> pro = new list<project__c>();

         project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';             
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             //p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             p1.Stage__c='Quote - Provided';
             
             pro.add(p1);
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
        //Inserting Quote Data
       // list<Quote__c> qt = new list<Quote__c>();
        Quote__c q = new Quote__c();
           q.Name = 'Test Quote3';
           q.Opportunity__c = opp[0].Id;  
           //qt.add(q);
           insert q;
        //inserting docusign
      /*  list < dsfs__DocuSign_Status__c > dslist = new list < dsfs__DocuSign_Status__c >();
            dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
            //ds.dsfs__Company__c = acc[0].name;
            //ds.Project_Name__c = pro[0].Name; 
            //ds.Nana_Quote__r.Project__c =  pro[0].name;
            ds.dsfs__DocuSign_Envelope_ID__c = 'test01';
            ds.Nana_Quote__c = qt[0];
            //ds.parentid = qt[0].id;
            dslist.add(ds);           
            insert dslist;*/
        dsfs__DocuSign_Status__c ds= new dsfs__DocuSign_Status__c();
        ds.Nana_Quote__c=q.id;
        insert ds;
        //Inserting Attachments
    list<Attachment> attachlist = new list<Attachment>();
    Attachment attach = new Attachment();
  //  attach.body = ;
    attach.Name = 'Att1';
    attach.ParentId = opp[0].id;
    attach.Body = Blob.valueOf('Unit Test Attachment Body');
        attachlist.add(attach);
        Test.startTest();
        insert attachlist;
        test.stopTest();             
    }
    
    static testmethod void unitest2(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
        
        //Inserting Project Data
        list<project__c> pro = new list<project__c>();

         project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';             
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             //p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             p1.Stage__c='Quote - Provided';
             
             pro.add(p1);
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
        //Inserting Quote Data
       // list<Quote__c> qt = new list<Quote__c>();
        Quote__c q = new Quote__c();
           q.Name = 'Test Quote3';
           q.Opportunity__c = opp[0].Id;  
           //qt.add(q);
           insert q;
        //inserting docusign
      /*  list < dsfs__DocuSign_Status__c > dslist = new list < dsfs__DocuSign_Status__c >();
            dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
            //ds.dsfs__Company__c = acc[0].name;
            //ds.Project_Name__c = pro[0].Name; 
            //ds.Nana_Quote__r.Project__c =  pro[0].name;
            ds.dsfs__DocuSign_Envelope_ID__c = 'test01';
            ds.Nana_Quote__c = qt[0];
            //ds.parentid = qt[0].id;
            dslist.add(ds);           
            insert dslist;*/
        dsfs__DocuSign_Status__c ds= new dsfs__DocuSign_Status__c();
        ds.Nana_Quote__c=q.id;
        insert ds;
        //Inserting Attachments
    list<Attachment> attachlist = new list<Attachment>();
    Attachment attach = new Attachment();
  //  attach.body = ;
    attach.Name = 'Att1';
    attach.ParentId = opp[0].id;
    attach.Body = Blob.valueOf('Unit Test Attachment Body');
        attachlist.add(attach);
        Test.startTest();
        insert attachlist;
        delete attachlist[0];
        test.stopTest();        
    }
    
    static testmethod void unitest3(){
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
        
        //Inserting Project Data
        list<project__c> pro = new list<project__c>();

         project__c p1= new project__c();
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';             
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             //p1.Close_Date__c=Date.newInstance(2015, 12, 12);
             p1.Stage__c='Quote - Provided';
             
             pro.add(p1);
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
        //Inserting Quote Data
       // list<Quote__c> qt = new list<Quote__c>();
        Quote__c q = new Quote__c();
           q.Name = 'Test Quote3';
           q.Opportunity__c = opp[0].Id;  
           //qt.add(q);
           insert q;
        /*inserting docusign
        dsfs__DocuSign_Status__c ds= new dsfs__DocuSign_Status__c();
        ds.Nana_Quote__c=q.id;
        insert ds; */
        //Inserting Attachments
        list<Attachment> attachlist = new list<Attachment>();
        Attachment attach = new Attachment();
  //  attach.body = ;
        attach.Name = 'Att1';
        attach.ParentId = opp[0].id;
        attach.Body = Blob.valueOf('Unit Test Attachment Body');
        attachlist.add(attach);
        Test.startTest();
        insert attachlist;
        update opp;
        test.stopTest();        
    }
    
}