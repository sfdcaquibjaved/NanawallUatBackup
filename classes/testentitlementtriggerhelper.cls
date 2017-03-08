@isTest
public class testentitlementtriggerhelper {
    public static list < Zip_Codes_Master__c > territorymaster;
    static testmethod void helpermethod1(){
            User user1 = testdatautility.createUser('System Administrator','test@gughgvhfhv.com12');
    insert user1;
        
        string Query = 'Select id,Nana_Quote__c , Nana_Quote__r.Contact__c , Nana_Quote__r.Opportunity__c , Nana_Quote__r.Project__c , Nana_Quote__r.Project__r.Owner.Email from Entitlement  WHERE Nana_Quote__c != null ';
        
       territorymaster = TestDataUtility.getTerritoryMaster();
   insert territorymaster;
        
       
	        
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type ='Competitor Firm';
        insert a;
        
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
        con.email = 'one@testorg.com';
    
        insert con;
        
        System.runas(user1){
            
 			Project__c p1 = new Project__c();
           // p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Other';
             p1.Project_Zip_Code__c = '94040' ;
             p1.Project_Country__c = 'United States';
        
             //p1.ownerid = newUser.id ;
      
            insert p1;
        
        system.debug('inside test class P1' + P1 );
   
        Map <String,Schema.RecordTypeInfo> recordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();

         Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.RecordTypeId= recordTypeMap.get('Influencer Opportunity').getRecordTypeId();

        o.StageName = 'Need Analysis';
        o.CloseDate = Date.today();
        o.Country__c = 'United States';
        o.Postal_Code__c = '94040';
       o.Project_Name__c = p1.id;
        o.AccountId = a.id;
        o.ForecastCategoryName = 'Best Case';
        o.Expected_Resolution_Date_2__c = Date.today();
        
        
        //o.Type = 'Influencer Opportunity';
       // o.RecordTypeid = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName().get('Influencer Opportunity').getRecordTypeId();
        insert o;
		system.debug('Value of influencer opp' +o);
        system.debug('Record type of opp' +o.RecordTypeID);    
        
        Quote__c q = new Quote__c();
            q.Name = 'Test Quote';
            q.Opportunity__c = o.Id;
            q.Primary_Quote__c=True;
           q.contact__c = con.id;
          q.project__c = p1.id;
          
            insert q;
         
       /* Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
        qd.quote__c = q.id;
        
        insert qd;*/
        
        
          OpportunityContactRole oppConRole = new OpportunityContactRole();
         oppConRole.ContactId = con.Id ;
         oppConRole.OpportunityId = o.Id ;
        insert oppConRole;
        
        
        
        test.startTest();
        
         List<Entitlement> entitleList = new List<Entitlement>();
       Entitlement Entitle = new Entitlement();
       Entitle.nAME = 'test_name';
       //Entitle.accountid = qDetail[0].Quote__r.Contact_Account_ID__c ;
       Entitle.accountid = a.id;
      //Entitle.Contacts__c = con.id;
       Entitle.Nana_Quote__c = q.id;
       //Entitle.Quote_Detail__c = qDetail[0].id;
       //Entitle.StartDate = qDetail[0].Quote__r.Balanced_Received_Date__c;
       Entitle.SlaProcessId = system.Label.Sla_Process;                    
       entitleList.add(Entitle);
       insert entitleList;
            test.stopTest();
    }
    }}