@isTest
public class updateQuoteStageTriggerTest {
    

     public static List<Account> olstTestAccount;
     public static User testUser1;  
     public static List<Opportunity> TestOpp;
     public static List<Project__c> TestProject;
     public static List <Quote> TestQuote;

     
     static  testmethod void updateQuoteStageTriggerTest() {
         list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
         insert tmList; 
         Set<ID> qList = new Set<ID>();
         Set<ID> plist = new Set<ID>();
         Set<ID> olist = new Set<ID>();
    
          
        User testUser = TestDataUtility.createUser('System Administrator', 'testUser@testing.com');
        insert testUser;

          
         Account a = new Account();
         a.Name = 'Test 1';
         a.BillingCountry = 'United States';
         a.BillingPostalCode = '04037';
         //a.ContactId = co[0].id;
         insert a; 
          
         list<contact> con=new list<contact>();
         contact co=new contact();
         co.Accountid = a.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
         con.add(co);
         insert con ;

         

         
         Project__c p = new Project__c();
         p.Name ='Test p';
         p.Application__c ='Multifamily New';
         p.Application_2__c='Bed/Bath'; 
         p.Stage__c = 'Quoted';
         p.Project_zip_code__c = '12345';
         insert p;
          plist.add(p.id);
         
         Opportunity opp = new Opportunity();
         opp.AccountId = a.Id;
         opp.Name = 'Test Opp CompetitorHelper_Test1';
        opp.StageName = 'Qualification';
        opp.CloseDate = Date.today();
         //opp.Project_ID__c = p.id;
         insert opp;
         olist.add(opp.id);
         
          
         quote__c qu = new quote__c();
         qu.Name = 'TestQuote';
         qu.Contact__c = co.id;
         //qu.stage__c = 'Order Confirmed';
         qu.Opportunity__c = opp.Id;
         insert qu; 
       
         Quote q = new Quote();
         q.Name = 'Test Quote';
         q.OpportunityId = opp.Id;
         q.Nana_Quote__c = qu.Id;
         q.First_Threshold_Price__c = 1;
        
         q.ContactId = Con[0].id;
         q.Tax = 1.0;
         q.Order_Number__c = 12345;
         insert q;
         qlist.add(q.id); 
         
        /* List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';
         qd.units__c = 1;
         qd.quote__c = qu.id;
         
        qDetail.add(qd);                  
        insert qDetail;*/
          
         Test.startTest ();
         
         order or1= new order();
         //or1.Order_Number__c = 12345;
         or1.NanaQuote__c = qu.id;
         //or1.Status ='Paid/Delivered';
         or1.Status = 'draft';
         or1.EffectiveDate = system.today();
         or1.Accountid = a.id;
         Insert or1;
          
         // or1.Status ='Paid/Delivered';
          //update or1;
          map<Id,String> mapSt = new  map<Id,String>();
          mapSt.put(or1.id ,or1.Status);
                                          
          OrderTriggerStagesHelper.UpdateQuoteStages(qlist,mapSt);
          OrderTriggerStagesHelper.UpdateOppStages(olist,mapSt);
          OrderTriggerStagesHelper.UpdateProjStagesFromopportunity(plist,mapSt);
          
        
          Test.stopTest();
                 
           
          
          
          
      }



}