@isTest
public class CaseAddressToShopifyOnCreationTest{
  
 static testmethod void method1(){
 
 Manufacturer_OrderNb__c mo = new Manufacturer_OrderNb__c();
        mo.Name = 'Richmond';
        //mo.LatestNumber__c = 40200;
        mo.LatestOrderNumber__c='40209';
        insert mo;
        
        Manufacturer_OrderNb__c mo1 = new Manufacturer_OrderNb__c();
        mo1.Name = 'Solarlux';
        //mo1.LatestNumber__c = 20001;
        mo1.LatestOrderNumber__c='20017';
        insert mo1;
        
        Manufacturer_OrderNb__c mo2 = new Manufacturer_OrderNb__c();
        mo2.Name = 'Teuffel';
        //mo2.LatestNumber__c = 75400;
        mo2.LatestOrderNumber__c='75401';
        insert mo2;
        
        Manufacturer_OrderNb__c mo3 = new Manufacturer_OrderNb__c();
        mo3.Name = 'Wizard';
        //mo3.LatestNumber__c = 97000;
        mo3.LatestOrderNumber__c='97001';
        insert mo3;
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
 
 
  list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
  insert tmList;
  
  Test.StartTest();
  
 Account acc=new Account();
 acc.Name='Test';
 acc.BillingCity='test';
 acc.BillingCountry='United States';
 acc.BillingPostalCode='12345';
 acc.BillingState='California';
 acc.BillingStreet='Test';
 acc.ShippingCity='Test';
 acc.ShippingCountry='United States';
 acc.ShippingPostalCode='12345';
 //acc.ShippingState='test';
 acc.ShippingStreet='test';
 acc.Phone='5432167';
 acc.Fax='444-5555';
 
 insert acc;
 
 Contact con=new Contact();
  con.Accountid = acc.id;
  con.FirstName = 'john';
  con.LastName = 'Test';
  con.MailingStreet = 'street';
  con.MailingCity = 'city'; 
  con.Mailingstate = 'Utah'; 
  con.MailingCountry='United States';
  con.MailingPostalCode = '12345';
  insert con;
 
 Project__c Pro=new Project__c();
  pro.Name = 'Test Project';
  pro.Application__c = 'Automotive';
  pro.Application_2__c = 'Dealership';
  pro.Stage__c = 'Considered';
  pro.Project_Country__c='United States';
  pro.Project_Zip_Code__c = '12345' ;
  insert pro;
 
 Opportunity o = new Opportunity();
  o.Name = 'Test ';
  o.StageName = 'Need Analysis';
  o.CloseDate = Date.today();
  o.project_name__c = pro.id;
  o.Accountid=acc.id;
  o.Country__c = 'United States';
  o.Postal_Code__c = '12345';
  insert o;
 
 Quote__c q=new Quote__c();
  q.Name = 'Test Quote';
  q.Opportunity__c = o.Id;
  q.Primary_Quote__c=True;
  q.Project__c = pro.id;
  q.Shipping_Min__c = 12;
   q.Order_Number__c = 12345;
  insert q;
  
  
  Quote q1 = new Quote();
 q1.Name = 'Test Quote';
 q1.OpportunityId = o.Id;
 q1.Nana_Quote__c = q.Id;
 q1.First_Threshold_Price__c = 1;        
 q1.ContactId = con.id;
 q1.Tax = 1.0;
 q1.Order_Number__c = 12345;
 insert q1;
 
 
 order ord = new order();
 ord.Status = 'draft';
 ord.Name='12345';
 ord.EffectiveDate = system.today();
 ord.AccountId = acc.id;
 ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
 ord.Nanaquote__c = q.id;
 insert ord;
         
 case c = new case ();
  c.Origin = 'Phone';
  c.Status = 'New';
  c.Priority = 'Medium';
 //c.Send_Quote_To__c = 'End Customer';
 //c.Ship_To__c = 'End Customer';
 //c.Bill_To__c = 'End Customer'; 
   c.subject = 'Test';
   c.Description = 'Test Description'; 
 //  c.Order__c = ord.id; 
   c.Category__c='';
   c.Sub_Category__c=''; 
   c.Other_Phone__c='';
   c.Other_Email__c=''; 
   c.Other_Shipping_Phone__c='';
   c.Other_Shipping_Email__c='';
   c.Billing_Street_End_Customer__c='';
   c.Shipping_Country__c=''; 
   c.Billing_Country__c='';
   c.Billing_Zipcode__c=''; 
   c.Billing_State__c='';
   c.Billing_City__c='';
   c.Shipping_Zip_End_Customer__c='';
   c.Shipping_City_EndCustomer__c='';
   c.Shipping_Street_End_Customer__c='';
   c.Shipping_State_End_Customer__c='';
insert c;       
 
   Service_Quote__c sq = new Service_Quote__c();
        sq.Case__c=c.id;
        sq.Quote__c=q.id;
        sq.Order__c=ord.id;
        sq.Total_Amount__c = 134;
        sq.Discount__c = 20;
        sq.shopify__c = true;
        sq.recordtypeid = Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId();
        sq.Status__c = 'Order Created';
        sq.Shopify_ID__c = '2853431619';
        
 
 insert sq;
 
 
 
 }
 
 }