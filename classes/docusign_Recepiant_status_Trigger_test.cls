@isTest
public class docusign_Recepiant_status_Trigger_test
{
    static testmethod void unittest1()
    {
        list<Zip_Codes_Master__c> territorymaster = new list<Zip_Codes_Master__c>();
        territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        list<Account> olstAccount = new list<Account>();
        list<Contact> olstContact = new list<Contact>();
        list<Opportunity> olstOpportunity  = new list<Opportunity >();
          //insert test Account records
          Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        olstAccount.add(a);
            insert olstAccount ;
    
      //Insert test contact records
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        
            insert olstContact ;
             
        list<Project__c> olstProject =new list<Project__c>();
        Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
       // p.Stage__c='Prospecting';
        p.Application__c = 'Automotive';
        p.Application_2__c = 'Dealership';

        olstProject.add(p);
        
        insert olstProject;
        
        
      //insert test Opportunity records 
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        olstOpportunity[0].Project_Name__c = olstProject[0].Id;
            insert olstOpportunity ;
            
        quote__c q= new quote__c();
        q.Name='Test Quote';
        q.Opportunity__c=olstOpportunity[0].id;
        q.Project__c = olstProject[0].id ;
        insert q;
       
        dsfs__DocuSign_Status__c ds= new dsfs__DocuSign_Status__c();
        ds.Nana_Quote__c=q.id;
        insert ds;
        ds.dsfs__Envelope_Status__c='test status';
        update ds;
        
        dsfs__DocuSign_Recipient_Status__c dr= new dsfs__DocuSign_Recipient_Status__c();
        dr.dsfs__Parent_Status_Record__c=ds.id;
        dr.dsfs__DocuSign_Recipient_Id__c='152';
        insert dr;
        
        dr.dsfs__Recipient_Status__c='test status';
        update dr;       
        
         Blob b = Blob.valueOf('Test Data'); 
         Attachment att = new Attachment();
                    att.body=b;
                    att.Name='test';
                    att.ParentId=ds.id;
                    insert att;
    }
}