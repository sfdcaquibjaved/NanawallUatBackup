@isTest
public class testNanaquote_create_order_controller {
    static testmethod void createordercon(){
         list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
     Project__c p1 = new Project__c();
           // p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
        insert p1;
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
            insert acct; 
         contact co=new contact();
         co.Accountid = acct.id;
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
        insert co;
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        //o.Project_id__c = p1.id;
        o.Postal_Code__c = 'TEST';
        insert o;
         Quote__c q = new Quote__c();
            q.Name = 'Test Quote';
            q.Opportunity__c = o.Id;
            q.Contact__c= Co.id;
            q.Primary_Quote__c=True;
        insert q;
         Quote qu = new Quote();
         qu.Name = 'Test Quote';
         qu.OpportunityId = o.Id;
         qu.Nana_Quote__c = q.Id;
         qu.First_Threshold_Price__c = 1;
         qu.ContactId = Co.id;
         qu.Tax = 1.0;
         qu.Order_Number__c = 12345;
        insert qu;
            
       order ord = new order();
            ord.Status = 'draft';
            ord.EffectiveDate = system.today();
            ord.accountid = acct.id;
            ord.nanaquote__c = q.id;
        insert ord;
 
       
     // if (myFlow == null) return null;
       //lan.existingOrder = (id)(myFlow.getVariableValue('orderId'));
    Test.StartTest(); 
  PageReference pageRef = Page.NanaQuote_Create_Order; // Add your VF page Name here
  pageRef.getParameters().put('id', String.valueOf(q.Id));
  Test.setCurrentPage(pageRef);
  ApexPages.StandardController sc = new ApexPages.StandardController(q);
  NanaQuote_Create_Order_Controller lan = new NanaQuote_Create_Order_Controller(sc);
  lan.existingOrder = ord.id;
  //Flow.Interview.Quote_to_Order myFlow;
  lan.doTest = false;
  //lan.existingOrder = (id)(myFlow.getVariableValue('orderId'));
  //Flow.Interview.Quote_to_Order convertFlow = new Flow.Interview.Quote_to_Order(q.id);
 // myFlow.start();
  //lan.CreateOrder();
 
   
  //testAccPlan.save(); call all your function here
 Test.StopTest();
            
    }
}