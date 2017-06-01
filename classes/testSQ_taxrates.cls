@isTest
public class testSQ_taxrates {
static testmethod void taxratesmethod(){
     list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
     insert tmList;
    taxrate__c t1 = new taxrate__c();
    t1.state__c = 'Arizona';
    t1.Service_Quote_Tax_Rate__c = 5.600;
    insert t1;
    taxrate__c t2 = new taxrate__c();
    t2.state__c = 'Alabama';
    t2.Service_Quote_Tax_Rate__c = 4.000;
     insert t2;
    taxrate__c t3 = new taxrate__c();
    t3.state__c = 'Arkansas';
    t3.Service_Quote_Tax_Rate__c = 6.500;
     insert t3;
    taxrate__c t4 = new taxrate__c();
    t4.state__c = 'colorado';
    t4.Service_Quote_Tax_Rate__c = 2.900;
    insert t4;
   list<Account> acclist = TestDataUtility.createAccountTestData();
     acclist[0].ShippingPostalCode='12345';
        acclist[0].ShippingCountryCode='US';
        acclist[0].ShippingStreet = 'xyz street';
        acclist[0].ShippingCity = 'new va';
        insert acclist;
   list<Contact> conlist = TestDataUtility.createConTestData();
        insert conlist;
       
    list<case> caseList =  new list<case>();
         case c = new case ();
         c.Origin = 'Phone';
         c.accountid = acclist[0].id;
         c.contactid = conlist[0].id;
         c.Status = 'New';
         c.Priority = 'Medium';
         c.Send_Quote_To__c = 'End Customer';
         c.Ship_To__c = 'End Customer';
         c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.billing_zipcode__c ='19044';
         c.Description = 'Test Description'; 
         caseList.add(c);
         insert caselist;
         caselist[0].billing_zipcode__c ='08619';
       update caselist[0];
  
    list<Service_Quote__c> sqlist1 =  new list<Service_Quote__c>();
        
        Service_Quote__c sq1 = new Service_Quote__c();
        sq1.Total_Amount__c = 134;
        sq1.Discount__c = 20;
    sq1.case__c = caseList[0].id;
    sq1.Ship_To_State__c = 'Arizona';
    sq1.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Custom Service Quote').getRecordTypeId();
        sqlist1.add(sq1);       
        
        insert sqList1;  
    Service_Quote__c sq5 = [select id, recordtype.name from Service_Quote__c where id =: sqList1[0].id];
    System.debug('Testtt'+sq5);
    
    List<Service_Quote_Detail__c> sqList = new List<Service_Quote_Detail__c>();
        Service_Quote_Detail__c sq = new Service_Quote_Detail__c();
        sq.Discount__c = 10;
        sq.Freight__c = 20;
        sq.Unit_Price__c = 120;
        sq.Quantity__c = 1;
        sq.service_quote__c = sq1.id;
        sqList.add(sq);  
        
        test.startTest();
         insert sqList;
    sqList1[0].Ship_To_State__c = 'Alabama';
    update sqList1;
        test.stopTest();
        
}
    static testmethod void taxratesmethod2(){
     list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
    taxrate__c t1 = new taxrate__c();
    t1.state__c = 'Arizona';
    t1.Service_Quote_Tax_Rate__c = 5.600;
    insert t1;
    taxrate__c t2 = new taxrate__c();
    t2.state__c = 'Alabama';
    t2.Service_Quote_Tax_Rate__c = 4.000;
     insert t2;
    taxrate__c t3 = new taxrate__c();
    t3.state__c = 'Arkansas';
    t3.Service_Quote_Tax_Rate__c = 6.500;
     insert t3;
    taxrate__c t4 = new taxrate__c();
    t4.state__c = 'colorado';
    t4.Service_Quote_Tax_Rate__c = 2.900;
    insert t4;
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
     a.ShippingState = '';
     a.ShippingPostalCode='12345';
    a.ShippingCountryCode='US';
       
        a.ShippingStreet = 'xyz street';
        a.ShippingCity = 'new va';
    insert a;
    Contact con = new Contact();
       // con.SyncInProgress__c = false;
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
        insert con;
    list<case> caseList =  new list<case>();
         case c = new case ();
         c.Origin = 'Phone';
         c.accountid = a.id;
         c.contactid = con.id;
         c.Status = 'New';
         c.Priority = 'Medium';
         c.Send_Quote_To__c = 'Caller Contact';
         c.Ship_To__c = 'Caller Contact';
         c.Bill_To__c = 'Caller Contact'; 
         c.subject = 'Test';
         c.billing_zipcode__c ='19044';
         c.Description = 'Test Description'; 
         caseList.add(c);
         insert caselist;
         caselist[0].billing_zipcode__c ='08619';
       update caselist[0];
   list<Service_Quote__c> sqlist1 =  new list<Service_Quote__c>();
        
        Service_Quote__c sq1 = new Service_Quote__c();
        sq1.Total_Amount__c = 134;
        sq1.Discount__c = 20;
        sq1.Shopify_Ship_to_State__c = 'Alabama';
    sq1.case__c = caseList[0].id;
    sq1.RecordTypeId=Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId();
        sqlist1.add(sq1);       
        
        insert sqList1;   
    
    List<Service_Quote_Detail__c> sqList = new List<Service_Quote_Detail__c>();
        Service_Quote_Detail__c sq = new Service_Quote_Detail__c();
        sq.Discount__c = 10;
        sq.Freight__c = 20;
        sq.Unit_Price__c = 120;
        sq.Quantity__c = 1;
        sq.service_quote__c = sq1.id;
        sqList.add(sq);  
         
        test.startTest();
        insert sqList;
        sq1.Shopify_Ship_to_State__c = 'colorado';
        update sq1;
        test.stopTest();
        
}
    
}