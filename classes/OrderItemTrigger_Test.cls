@isTest
public class OrderItemTrigger_Test {

    
    public static list < Project__c > olstProject;
    public static list < Opportunity > olstOpportunity;
    public static list < Quote__c > olstQuote;
    public static list < Account > accounts;
    public static list < Zip_Codes_Master__c > territorymaster;
    public static User testUser;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Contact> contacts;
    public static list < Project__c > projects;
    public static list < Order > ordersList;
    public static list < Product2> productList;
    public static list < orderItem > orderItemList;
    public static List < Installation__c > Installation = new List < Installation__c > ();
    public static list < Manufacturing_Order__c> mOrderList;
    public static list < Manufacturing_Order_Position__c > morderPositonList;
    public static list < Shipping_Order__c > sOrderList;
    
    
    Static TestMethod Void OrderItemTrigger()
    {
                
        //creating test data for territorymaster
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
       accounts[0].Certified_Installer__C = TRUE;
       insert accounts;
       
       //Creating test data for contacts
       /*contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       insert contacts;*/
       
       List<contact> con =new list<contact>();
       contact co=new contact();
         //con.Name='test contact';
         co.Accountid=accounts[0].id;
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
         insert con; 
       
       //Creating test data for projects
       list<Project__c> Pro= new list<Project__c>();
       Pro=TestDataUtility.createProjectTestData();
       insert Pro[0];
        
        //Creating test data for Opportunities 
        olstOpportunity = TestDataUtility.createOppTestData();
            olstOpportunity[0].Accountid=accounts[0].id;
            olstOpportunity[0].Project_Name__c =Pro[0].Id ;
            olstOpportunity[0].OwnerId=testuser.id;
            insert olstOpportunity;
        system.assert(olstOpportunity.size()>0);
           
        //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
                
        test.starttest();

       //Creating test data for products
       productList = TestDataUtility.createProductData();
       productList[0].Name = 'WA67';
       insert productList;
        system.assert(productList.size()>0);
      
       //Creating test data for Pricebook
       Pricebook2 pb2 = new Pricebook2();
       pb2.Name = 'Models';
       insert pb2;
       
       //Create test data for Orders
       Order o = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            //Status = 'Draft',
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()
        
        );
        insert o;
        
        
        
       
       //Creating test data for PriceBookEntry
       PricebookEntry pbe = new PricebookEntry();
       pbe.Product2Id = productList[0].id;
       pbe.UnitPrice = 7092;
       pbe.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe;
       
        //creating test data for installation
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
       inst.Order__c = o.id;
       inst.Installer_Account__c = accounts[0].id;
       instalList.add(inst);
       Installation__c inst1 = new Installation__c();
       inst1.Status__c = 'Open';
       inst1.Order__c = o.id;
       inst1.Installer_Account__c = accounts[0].id;
       instalList.add(inst1);
       insert instalList;  
        
        //Creating test data for OrderItem
       OrderItem otm = new orderitem();
       otm.OrderId = o.id;
       otm.PricebookEntryId = pbe.id;
       otm.Quantity = 1;
       otm.UnitPrice = 5532;
       otm.Installation__c = instalList[0].id;
       insert otm;
        
        
        
        //Creating test data for Installation 
                      
       /* otm.Installation__c = instalList[0].id;
        update otm;*/
        otm.Installation__c = instalList[1].id;
        update otm;
        
        List<Entitlement> entityList = new List<Entitlement>();
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = accounts[0].id;
        ent.StartDate = system.today();
        ent.Order__c = o.id;
        ent.Order_Product__c = otm.id;
        //entityList.add(e)
        insert ent; 
        Entitlement ent1 = new Entitlement();
        ent1.Name = '0001sl';
        ent1.AccountId = accounts[0].id;
        ent1.StartDate = system.today();
        ent1.Order__c = o.id;
        ent1.Order_Product__c = otm.id;
        insert ent1; 
        
    }
    
  
    Static TestMethod Void OrderItemTrigger1(){
       
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
         
       Test.startTest();
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
       accounts[0].Certified_Installer__C = TRUE;
       accounts[1].Certified_Installer__C = TRUE;
       accounts[2].Certified_Installer__C = TRUE;
       insert accounts;
       
       //Creating test data for contacts
       /*contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       insert contacts;*/
       
       List<contact> con =new list<contact>();
       contact co=new contact();
         //con.Name='test contact';
         co.Accountid=accounts[0].id;
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
        
       
       //Creating test data for projects
       list<Project__c> Pro= new list<Project__c>();
       Pro=TestDataUtility.createProjectTestData();
       insert pro;
        
        //Creating test data for Opportunities 
        olstOpportunity = TestDataUtility.createOppTestData();
            olstOpportunity[0].Accountid=accounts[0].id;
            olstOpportunity[0].Project_Name__c =Pro[0].Id ;
            olstOpportunity[0].OwnerId=testuser.id;
             
           
          /*  olstOpportunity[1].Accountid=accounts[1].id;
            olstOpportunity[1].Project_Name__c =Pro[1].Id ;
            olstOpportunity[1].OwnerId=testuser.id;*/
            insert olstOpportunity;
            system.assert(olstOpportunity.size()>0);
         
           
        //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
                
       

       //Creating test data for products
       productList = TestDataUtility.createProductData();
       productList[0].Name = 'WA67';
       productList[1].Name = 'screenone';
       productList[2].Name = 'screenclassic';
       productList[3].Name = 'hsw75';
       insert productList;
      system.assert(productList.size()>0);
      
       //Creating test data for Pricebook
       Pricebook2 pb2 = new Pricebook2();
       pb2.Name = 'Models';
       insert pb2;
      
       
        
        //Create test data for Orders
        list<Order> o = new list<Order>();
        Order o1 = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            //Status = 'Draft',
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()
        
        );
        o.add(o1);
        
         Order o2 = new Order(
            AccountId = accounts[1].id,
            EffectiveDate = system.today(),
            //Status = 'Draft',
            OpportunityId = olstOpportunity[2].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()
        
        );
        o.add(o2);
        
        insert o;
        
        
               
       //Creating test data for PriceBookEntry
       PricebookEntry pbe = new PricebookEntry();
       pbe.Product2Id = productList[0].id;
       pbe.UnitPrice = 7092;
       pbe.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe;
        
       PricebookEntry pbe1 = new PricebookEntry();
       pbe1.Product2Id = productList[1].id;
       pbe1.UnitPrice = 7092;
       pbe1.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe1;
        
       PricebookEntry pbe2 = new PricebookEntry();
       pbe2.Product2Id = productList[2].id;
       pbe2.UnitPrice = 7092;
       pbe2.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe2; 
       
        //creating test data for installation
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
       inst.Order__c = o[0].id;
       inst.Installer_Account__c = accounts[0].id;
       instalList.add(inst);
       
       Installation__c inst1 = new Installation__c();
       inst1.Status__c = 'Open';
       inst1.Order__c = o[1].id;
       inst1.Installer_Account__c = accounts[1].id;
       instalList.add(inst1);
       insert instalList;  
        
        //Creating test data for OrderItem
       OrderItem otm = new orderitem();
       otm.OrderId = o[0].id;
       otm.PricebookEntryId = pbe.id;
       otm.Quantity = 1;
       otm.UnitPrice = 5532;
       otm.Installation__c = instalList[0].id;
       insert otm;
        
       OrderItem otm1 = new orderitem();
       otm1.OrderId = o[1].id;
       otm1.PricebookEntryId = pbe1.id;
       otm1.Quantity = 1;
       otm1.UnitPrice = 5532;
       otm1.Installation__c = instalList[1].id;
       insert otm1; 
        
         Test.stopTest();
        
        //Creating test data for Installation 
                      
       /* otm.Installation__c = instalList[0].id;
        update otm;*/
        //otm.Installation__c = instalList[1].id;
       // update otm;
        
        List<Entitlement> entityList = new List<Entitlement>();
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = accounts[0].id;
        ent.StartDate = system.today();
        ent.Order__c = o[0].id;
        ent.Order_Product__c = otm.id;
        //entityList.add(e)
        insert ent; 
       
        Entitlement ent1 = new Entitlement();
        ent1.Name = '0001sl';
        ent1.AccountId = accounts[1].id;
        ent1.StartDate = system.today();
        ent1.Order__c = o[1].id;
        ent1.Order_Product__c = otm.id;
        insert ent1; 
        
        
        
        mOrderList=TestDataUtility.createManufacturingOrder();
        insert mOrderList;
        
        morderPositonList = TestDataUtility.createManufacturingOrderPosition();
        insert morderPositonList;
        
        sOrderList = TestDataUtility.createShippingOrderData();
        insert sOrderList;
        
        Manufacturing_Order__c pdt = new Manufacturing_Order__c();
        //pdt.Name = 'Test1';
        insert pdt;
        
        Manufacturing_Order__c pdt1 = new Manufacturing_Order__c();
        //pdt1.Name = 'Test2';
        insert pdt1;    
    
        Manufacturing_Order_Position__c mPosition = new Manufacturing_Order_Position__c();
        //mPosition.Name = 'Test1';
        insert mPosition;   
    
        Manufacturing_Order_Position__c mPosition1 = new Manufacturing_Order_Position__c();
        mPosition.Name = 'Test2';
        insert mPosition1;
        
       
        
    }
   
        
        
    
     Static TestMethod Void OrderItemTrigger2()
    {
                
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
         
       Test.startTest();
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
       accounts[0].Certified_Installer__C = TRUE;
       accounts[1].Certified_Installer__C = TRUE;
       accounts[2].Certified_Installer__C = TRUE;
       insert accounts;
       
       //Creating test data for contacts
       /*contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       insert contacts;*/
       
       List<contact> con =new list<contact>();
       contact co=new contact();
         //con.Name='test contact';
         co.Accountid=accounts[0].id;
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
        
       
       //Creating test data for projects
       list<Project__c> Pro= new list<Project__c>();
       Pro=TestDataUtility.createProjectTestData();
       insert pro;
        
        //Creating test data for Opportunities 
        olstOpportunity = TestDataUtility.createOppTestData();
            olstOpportunity[0].Accountid=accounts[0].id;
            olstOpportunity[0].Project_Name__c =Pro[0].Id ;
            olstOpportunity[0].OwnerId=testuser.id;
             
           
          /*  olstOpportunity[1].Accountid=accounts[1].id;
            olstOpportunity[1].Project_Name__c =Pro[1].Id ;
            olstOpportunity[1].OwnerId=testuser.id;*/
            insert olstOpportunity;
            system.assert(olstOpportunity.size()>0);
         
           
        //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
                
       

       //Creating test data for products
       productList = TestDataUtility.createProductData();
       productList[0].Name = 'screenclassic';
       /*productList[1].Name = 'screenone';
       productList[2].Name = '';
       productList[3].Name = 'hsw75';*/
       insert productList;
      system.assert(productList.size()>0);
      
       //Creating test data for Pricebook
       Pricebook2 pb2 = new Pricebook2();
       pb2.Name = 'Models';
       insert pb2;
      
       
        
        //Create test data for Orders
        list<Order> o = new list<Order>();
        Order o1 = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            //Status = 'Draft',
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()
        
        );
        o.add(o1);
        
        Order o2 = new Order(
            AccountId = accounts[1].id,
            EffectiveDate = system.today(),
            //Status = 'Draft',
            OpportunityId = olstOpportunity[2].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()
        
        );
        o.add(o2);
        
        insert o;
        
        
               
       //Creating test data for PriceBookEntry
       PricebookEntry pbe = new PricebookEntry();
       pbe.Product2Id = productList[0].id;
       pbe.UnitPrice = 7092;
       pbe.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe;
        
       /*PricebookEntry pbe1 = new PricebookEntry();
       pbe1.Product2Id = productList[1].id;
       pbe1.UnitPrice = 7092;
       pbe1.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe1;
        
       PricebookEntry pbe2 = new PricebookEntry();
       pbe2.Product2Id = productList[2].id;
       pbe2.UnitPrice = 7092;
       pbe2.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe2;*/ 
       
        //creating test data for installation
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
       inst.Order__c = o[0].id;
       inst.Installer_Account__c = accounts[0].id;
       instalList.add(inst);
       
       Installation__c inst1 = new Installation__c();
       inst1.Status__c = 'Open';
       inst1.Order__c = o[0].id;
       inst1.Installer_Account__c = accounts[0].id;
       instalList.add(inst1);
       insert instalList;  
        
        //Creating test data for OrderItem
       OrderItem otm = new orderitem();
       otm.OrderId = o[0].id;
       otm.PricebookEntryId = pbe.id;
       otm.Quantity = 1;
       otm.UnitPrice = 5532;
       otm.Installation__c = instalList[0].id;
       insert otm;
        
       /*OrderItem otm1 = new orderitem();
       otm1.OrderId = o[1].id;
       otm1.PricebookEntryId = pbe1.id;
       otm1.Quantity = 1;
       otm1.UnitPrice = 5532;
       otm1.Installation__c = instalList[1].id;
       insert otm1;*/ 
        
         Test.stopTest();
        
        //Creating test data for Installation 
                      
       /* otm.Installation__c = instalList[0].id;
        update otm;*/
        //otm.Installation__c = instalList[1].id;
       // update otm;
        
        List<Entitlement> entityList = new List<Entitlement>();
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = accounts[0].id;
        ent.StartDate = system.today();
        ent.Order__c = o[0].id;
        ent.Order_Product__c = otm.id;
        //entityList.add(e)
        insert ent; 
       
        Entitlement ent1 = new Entitlement();
        ent1.Name = '0001sl';
        ent1.AccountId = accounts[0].id;
        ent1.StartDate = system.today();
        ent1.Order__c = o[0].id;
        ent1.Order_Product__c = otm.id;
        insert ent1; 
        
        
        
        mOrderList=TestDataUtility.createManufacturingOrder();
        insert mOrderList;
        
        morderPositonList = TestDataUtility.createManufacturingOrderPosition();
        insert morderPositonList;
        
        sOrderList = TestDataUtility.createShippingOrderData();
        insert sOrderList;
        
        Manufacturing_Order__c pdt = new Manufacturing_Order__c();
        //pdt.Name = 'Test1';
        insert pdt;
        
        Manufacturing_Order__c pdt1 = new Manufacturing_Order__c();
        //pdt1.Name = 'Test2';
        insert pdt1;    
    
        Manufacturing_Order_Position__c mPosition = new Manufacturing_Order_Position__c();
        //mPosition.Name = 'Test1';
        insert mPosition;   
    
        Manufacturing_Order_Position__c mPosition1 = new Manufacturing_Order_Position__c();
       // mPosition.Name = 'Test2';
        insert mPosition1;
        
       
    }
    
   Static TestMethod Void OrderItemTrigger4()
    {
                
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
         
       Test.startTest();
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
       accounts[0].Certified_Installer__C = TRUE;
       accounts[1].Certified_Installer__C = TRUE;
       accounts[2].Certified_Installer__C = TRUE;
       insert accounts;
       
       //Creating test data for contacts
       /*contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       insert contacts;*/
       
       List<contact> con =new list<contact>();
       contact co=new contact();
         //con.Name='test contact';
         co.Accountid=accounts[0].id;
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
        
       
       //Creating test data for projects
       list<Project__c> Pro= new list<Project__c>();
       Pro=TestDataUtility.createProjectTestData();
       insert pro;
        
        //Creating test data for Opportunities 
        olstOpportunity = TestDataUtility.createOppTestData();
            olstOpportunity[0].Accountid=accounts[0].id;
            olstOpportunity[0].Project_Name__c =Pro[0].Id ;
            olstOpportunity[0].OwnerId=testuser.id;
             
           
          /*  olstOpportunity[1].Accountid=accounts[1].id;
            olstOpportunity[1].Project_Name__c =Pro[1].Id ;
            olstOpportunity[1].OwnerId=testuser.id;*/
            insert olstOpportunity;
            system.assert(olstOpportunity.size()>0);
         
           
        //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
                
       

       //Creating test data for products
       productList = TestDataUtility.createProductData();
       productList[0].Name = 'WSL';
       /*productList[1].Name = 'screenone';
       productList[2].Name = '';
       productList[3].Name = 'hsw75';*/
       insert productList;
      system.assert(productList.size()>0);
      
       //Creating test data for Pricebook
       Pricebook2 pb2 = new Pricebook2();
       pb2.Name = 'Models';
       insert pb2;
      
       
        
        //Create test data for Orders
        list<Order> o = new list<Order>();
        Order o1 = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            //Status = 'Draft',
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()
        
        );
        o.add(o1);
        
        Order o2 = new Order(
            AccountId = accounts[1].id,
            EffectiveDate = system.today(),
            //Status = 'Draft',
            OpportunityId = olstOpportunity[2].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()
        
        );
        o.add(o2);
        
        insert o;
        
        
               
       //Creating test data for PriceBookEntry
       PricebookEntry pbe = new PricebookEntry();
       pbe.Product2Id = productList[0].id;
       pbe.UnitPrice = 7092;
       pbe.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe;
        
       /*PricebookEntry pbe1 = new PricebookEntry();
       pbe1.Product2Id = productList[1].id;
       pbe1.UnitPrice = 7092;
       pbe1.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe1;
        
       PricebookEntry pbe2 = new PricebookEntry();
       pbe2.Product2Id = productList[2].id;
       pbe2.UnitPrice = 7092;
       pbe2.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe2;*/ 
       
        //creating test data for installation
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
       inst.Order__c = o[0].id;
       inst.Installer_Account__c = accounts[0].id;
       instalList.add(inst);
       
       Installation__c inst1 = new Installation__c();
       inst1.Status__c = 'Open';
       inst1.Order__c = o[0].id;
       inst1.Installer_Account__c = accounts[0].id;
       instalList.add(inst1);
       insert instalList;  
        
        //Creating test data for OrderItem
       OrderItem otm = new orderitem();
       otm.OrderId = o[0].id;
       otm.PricebookEntryId = pbe.id;
       otm.Quantity = 1;
       otm.UnitPrice = 5532;
       otm.Installation__c = instalList[0].id;
       insert otm;
        
       /*OrderItem otm1 = new orderitem();
       otm1.OrderId = o[1].id;
       otm1.PricebookEntryId = pbe1.id;
       otm1.Quantity = 1;
       otm1.UnitPrice = 5532;
       otm1.Installation__c = instalList[1].id;
       insert otm1;*/ 
        
         Test.stopTest();
        
        //Creating test data for Installation 
                      
       /* otm.Installation__c = instalList[0].id;
        update otm;*/
        //otm.Installation__c = instalList[1].id;
       // update otm;
        
        List<Entitlement> entityList = new List<Entitlement>();
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = accounts[0].id;
        ent.StartDate = system.today();
        ent.Order__c = o[0].id;
        ent.Order_Product__c = otm.id;
        //entityList.add(e)
        insert ent; 
       
        Entitlement ent1 = new Entitlement();
        ent1.Name = '0001sl';
        ent1.AccountId = accounts[0].id;
        ent1.StartDate = system.today();
        ent1.Order__c = o[0].id;
        ent1.Order_Product__c = otm.id;
        insert ent1; 
        
        
        
       /* mOrderList=TestDataUtility.createManufacturingOrder();
        insert mOrderList;
        
        morderPositonList = TestDataUtility.createManufacturingOrderPosition();
        insert morderPositonList;
        
        sOrderList = TestDataUtility.createShippingOrderData();
        insert sOrderList;
        
        Manufacturing_Order__c pdt = new Manufacturing_Order__c();
        pdt.Name = 'Test1';
        insert pdt;
        
        Manufacturing_Order__c pdt1 = new Manufacturing_Order__c();
        pdt1.Name = 'Test2';
        insert pdt1;    
    
        Manufacturing_Order_Position__c mPosition = new Manufacturing_Order_Position__c();
        mPosition.Name = 'Test1';
        insert mPosition;   
    
        Manufacturing_Order_Position__c mPosition1 = new Manufacturing_Order_Position__c();
        mPosition.Name = 'Test2';
        insert mPosition1;*/
        
       
    }
       
    Static TestMethod Void OrderItemTrigger3()
    {
                
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
        
        //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
         
       Test.startTest();
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
       accounts[0].Certified_Installer__C = TRUE;
       accounts[1].Certified_Installer__C = TRUE;
       accounts[2].Certified_Installer__C = TRUE;
       insert accounts;
       
       //Creating test data for contacts
       /*contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       insert contacts;*/
       
       List<contact> con =new list<contact>();
       contact co=new contact();
         //con.Name='test contact';
         co.Accountid=accounts[0].id;
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
        
       
       //Creating test data for projects
       list<Project__c> Pro= new list<Project__c>();
       Pro=TestDataUtility.createProjectTestData();
       insert pro;
        
        //Creating test data for Opportunities 
        olstOpportunity = TestDataUtility.createOppTestData();
            olstOpportunity[0].Accountid=accounts[0].id;
            olstOpportunity[0].Project_Name__c =Pro[0].Id ;
            olstOpportunity[0].OwnerId=testuser.id;
             
           
          /*  olstOpportunity[1].Accountid=accounts[1].id;
            olstOpportunity[1].Project_Name__c =Pro[1].Id ;
            olstOpportunity[1].OwnerId=testuser.id;*/
            insert olstOpportunity;
            system.assert(olstOpportunity.size()>0);
         
           
        //Creating test data for countrys
        countrys = TestDataUtility.getTestCountryCodes();
        try {
            insert countrys;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for States
        states = TestDataUtility.getTestStateCodes();
        try {
            insert states;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
                
       

       //Creating test data for products
       productList = TestDataUtility.createProductData();
       productList[0].Name = 'hsw75';
       /*productList[1].Name = 'screenone';
       productList[2].Name = '';
       productList[3].Name = 'hsw75';*/
       insert productList;
      system.assert(productList.size()>0);
      
       //Creating test data for Pricebook
       Pricebook2 pb2 = new Pricebook2();
       pb2.Name = 'Models';
       insert pb2;
      
       
        
        //Create test data for Orders
        list<Order> o = new list<Order>();
        Order o1 = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            //Status = 'Draft',
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()
        
        );
        o.add(o1);
        
         Order o2 = new Order(
            AccountId = accounts[1].id,
            EffectiveDate = system.today(),
            //Status = 'Draft',
            OpportunityId = olstOpportunity[2].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()
        
        );
        o.add(o2);
        
        insert o;
        
        
               
       //Creating test data for PriceBookEntry
       PricebookEntry pbe = new PricebookEntry();
       pbe.Product2Id = productList[0].id;
       pbe.UnitPrice = 7092;
       pbe.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe;
        
       /*PricebookEntry pbe1 = new PricebookEntry();
       pbe1.Product2Id = productList[1].id;
       pbe1.UnitPrice = 7092;
       pbe1.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe1;
        
       PricebookEntry pbe2 = new PricebookEntry();
       pbe2.Product2Id = productList[2].id;
       pbe2.UnitPrice = 7092;
       pbe2.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe2;*/ 
       
        //creating test data for installation
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
       inst.Order__c = o[0].id;
       inst.Installer_Account__c = accounts[0].id;
       instalList.add(inst);
       
       Installation__c inst1 = new Installation__c();
       inst1.Status__c = 'Open';
       inst1.Order__c = o[0].id;
       inst1.Installer_Account__c = accounts[0].id;
       instalList.add(inst1);
       insert instalList;  
        
        //Creating test data for OrderItem
       OrderItem otm = new orderitem();
       otm.OrderId = o[0].id;
       otm.PricebookEntryId = pbe.id;
       otm.Quantity = 1;
       otm.UnitPrice = 5532;
       otm.Installation__c = instalList[0].id;
       insert otm;
        
       /*OrderItem otm1 = new orderitem();
       otm1.OrderId = o[1].id;
       otm1.PricebookEntryId = pbe1.id;
       otm1.Quantity = 1;
       otm1.UnitPrice = 5532;
       otm1.Installation__c = instalList[1].id;
       insert otm1;*/ 
        
         Test.stopTest();
        
        //Creating test data for Installation 
                      
       /* otm.Installation__c = instalList[0].id;
        update otm;*/
        //otm.Installation__c = instalList[1].id;
       // update otm;
        
        List<Entitlement> entityList = new List<Entitlement>();
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = accounts[0].id;
        ent.StartDate = system.today();
        ent.Order__c = o[0].id;
        ent.Order_Product__c = otm.id;
        //entityList.add(e)
        insert ent; 
       
        Entitlement ent1 = new Entitlement();
        ent1.Name = '0001sl';
        ent1.AccountId = accounts[0].id;
        ent1.StartDate = system.today();
        ent1.Order__c = o[0].id;
        ent1.Order_Product__c = otm.id;
        insert ent1; 
        
        
        
       /* mOrderList=TestDataUtility.createManufacturingOrder();
        insert mOrderList;
        
        morderPositonList = TestDataUtility.createManufacturingOrderPosition();
        insert morderPositonList;
        
        sOrderList = TestDataUtility.createShippingOrderData();
        insert sOrderList;
        
        Manufacturing_Order__c pdt = new Manufacturing_Order__c();
        pdt.Name = 'Test1';
        insert pdt;
        
        Manufacturing_Order__c pdt1 = new Manufacturing_Order__c();
        pdt1.Name = 'Test2';
        insert pdt1;    
    
        Manufacturing_Order_Position__c mPosition = new Manufacturing_Order_Position__c();
        mPosition.Name = 'Test1';
        insert mPosition;   
    
        Manufacturing_Order_Position__c mPosition1 = new Manufacturing_Order_Position__c();
        mPosition.Name = 'Test2';
        insert mPosition1;*/
        
       
    }
    
    
    
}