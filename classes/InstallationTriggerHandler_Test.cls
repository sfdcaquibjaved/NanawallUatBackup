/*************************************************************************
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : June-2016
    @ Description   : 
    @ Audit Trial   : 
    @ Last Modified Date : 02-June-2016
  
****************************************************************************/
@isTest(SeeAllData = false)
public class InstallationTriggerHandler_Test {
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

    public static testMethod void myUnitTest() {
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
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
        accounts[0].certified_installer__c = true;
       insert accounts;
       test.startTest();
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
       inst.Account__c =  accounts[0].id ;
       instalList.add(inst);
       insert instalList;       
       instalList[0].Status__c = 'Accepted by Installer' ;
       instalList[0].Installation_Date__c = system.today(); 
       update instalList[0];   
        
        
       Installation__c instNew = new Installation__c();
       instNew.Status__c = 'Open';
       instNew.Account__c =  accounts[0].id ;
       instNew.Installation_Date__c = system.today() ; 
       insert instNew;       
       instNew.Status__c = 'Accepted by Installer' ;
       instNew.Installation_Date__c = system.today(); 
       update instNew ;
       test.stopTest();
        
        
        
        
      mOrderList = testDataUtility.createManufacturingOrder();
        try{
            insert mOrderList ; 
        }
        catch (exception e){
            System.debug('Exception is:' +e);
        }
        
        mOrderList[0].Factory_Completion_Date__c =system.today() ; 
        try{
            update mOrderList ;
        }
        catch(exception e){
            system.debug('Exception is:' +e.getMessage());
        }
        
      sOrderList = testDataUtility.createShippingOrderData() ;  
        try{
            insert sOrderList ; 
        }
        catch (exception e){
            System.debug('Exception is:' +e);
        }
        
        sOrderList[0].Estimated_Pickup_Date__c = system.today() ; 
        try{
            update sOrderList ;
        }
        catch(exception e){
            system.debug('Exception is:' +e.getMessage());
        }
    }
  
    /*****
     Method:myUnitTest2
     Purpose: To cover the code coverage for Installation trigger
     *****/
    public static testMethod void myUnitTest2(){
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
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
        
        //creating test data for territorymaster
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
      
        
        
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
        accounts[0].certified_installer__c = true;
        accounts[0].Territory__c = 'New York' ; 
      
       insert accounts;
       
       //Creating test data for contacts
       /*contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       insert contacts;*/
       
       
       list<contact> con=new list<contact>();
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
         co.Email='test123@noemail.com';
         co.Phone='125869';
         co.Country__c='Aruba';
        co.Title = 'Certified Nana Installer' ; 
         con.add(co);
         insert con;
       
//          Id p = [select id from profile where name='Partner Community User'].id;
        
        //Creating test data for user
        User testUser1 = TestDataUtility.createUser('Partner Community Login User', 'testUserName@testing.com');
            testUser1.email='test123@noemail.com' ; 
             testUser1.emailencodingkey='UTF-8' ; 
                             testUser1.lastname='Testing' ;  
                             testUser1.languagelocalekey='en_US' ; 
                             testUser1.localesidkey='en_US' ; 
                             testUser1.country='United States' ; 
                             testUser1.IsActive =true ;
                             testUser1.ContactId = con[0].Id ; 
                             testUser1.timezonesidkey='America/Los_Angeles' ; 
   
        try {
            insert testUser1;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
       //Creating test data for projects
       list<Project__c> Pro= new list<Project__c>();
       Pro=TestDataUtility.createProjectTestData();
       Pro[0].TerritoryName__c = 'New York' ; 
       insert Pro[0];
        
        
        //Creating test data for Opportunities 
        olstOpportunity = TestDataUtility.createOppTestData();
            olstOpportunity[0].Accountid=accounts[0].id;
            olstOpportunity[0].Project_Name__c =Pro[0].Id ;
           // olstOpportunity[0].OwnerId=testuser1.id;
            insert olstOpportunity;
        system.assert(olstOpportunity.size()>0);
           
        //Creating test data for Quote
        list<quote__c> Quo = new list<Quote__c>() ; 
            Quo = TestDataUtility.createQuoteRecords(olstOpportunity) ; 
            Quo[0].City__c = 'Test City';
            Quo[0].Country__c='India';
            Quo[0].State__c = 'Test State';
            Quo[0].Address__c = 'Test Address' ; 
            Quo[0].Zip__c ='12345';
            insert quo[0] ; 
        
             Quote q1 = new Quote();
             q1.Name = 'Test Quote';
             q1.OpportunityId = olstOpportunity[0].Id;
             q1.Nana_Quote__c = Quo[0].Id;
             q1.First_Threshold_Price__c = 1;        
             q1.ContactId = con[0].id;
             q1.Tax = 1.0;
             q1.Order_Number__c = 12345;
             insert q1;
        
          list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
          QuoteDetailList[0].Quote__C=quo[0].id;
            insert QuoteDetailList[0] ; 
    
        
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
        
        Quote q = new Quote();
         q.Name = 'Test Quote';
        //q.AccountId = accounts[0].id;
        q.OpportunityId = olstOpportunity[0].id;
        q.ContactId = con[0].id;
       insert q;
            //Create test data for Orders
       Order o = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
           QuoteId = q.id,
            Balance_Received_Date__c = system.today()       
        );
        insert o;
       
       //Creating test data for PriceBookEntry
       PricebookEntry pbe = new PricebookEntry();
       pbe.Product2Id = productList[0].id;
       pbe.UnitPrice = 7092;
       pbe.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe;
           
        //Creating test data for OrderItem
       OrderItem otm = new orderitem();
       otm.OrderId = o.id;
       otm.PricebookEntryId = pbe.id;
       otm.Quantity = 1;
       otm.UnitPrice = 5532;
     //  insert otm;
        
        //Creating test data for entitlements
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = accounts[0].id;
        ent.StartDate = system.today();
  //      ent.Order__c = o.id;
     //   ent.Order_Product__c = otm.id;
        insert ent;
        
       //Creating test data for Installation 
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
        inst.Installation_Address__c = 'Other Address';
       inst.Account__c = accounts[0].id ; 
       inst.Order__c = o.id;
       inst.Quote_Name__c = quo[0].ID ;
       inst.contact__c = con[0].id ; 
       inst.Installer_Account__c = accounts[0].id;
       inst.Installer_Contact__c = con[0].Id ;
       inst.Assigned_to__c = testUser1.ID ;
       inst.Project__c = Pro[0].Id ;
        inst.Street_Address__c = 'Test street address';
        inst.City__c ='Test City';
        inst.State__c = 'Alabama' ; 
        inst.Country__c = 'United States' ;
        inst.Zip_Postal_Code__c = '12345' ;
       instalList.add(inst);
       insert instalList;       
       instalList[0].Installation_Date__c =system.today();
       //update instalList[0];   
       
        //Updating the order item
       otm.Installation__c = instalList[0].id;
      // update otm;        
   }
    /*****
     Method:myUnitTest3
     Purpose: To cover the code coverage for Entitlement part in Installation trigger
     *****/
    public static testMethod void myUnitTest3(){
    insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
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
        accounts[0].certified_installer__c = False;
       insert accounts;
       
       //Creating test data for contacts
       /*contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       insert contacts;*/
       
       
       list<contact> con=new list<contact>();
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
       /*Order o = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()       
        );
        insert o;*/
       
       //Creating test data for PriceBookEntry
       PricebookEntry pbe = new PricebookEntry();
       pbe.Product2Id = productList[0].id;
       pbe.UnitPrice = 7092;
       pbe.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe;
           
        //Creating test data for OrderItem
       OrderItem otm = new orderitem();
       //otm.OrderId = o.id;
       otm.PricebookEntryId = pbe.id;
       otm.Quantity = 1;
       otm.UnitPrice = 5532;
      // insert otm;
        
        //Creating test data for entitlements
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = accounts[0].id;
        ent.StartDate = system.today();
       // ent.Order__c = o.id;
       // ent.Order_Product__c = otm.id;
        insert ent;
        
       //Creating test data for Installation 
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
       //inst.Order__c = o.id;
       inst.Installer_Account__c = accounts[0].id;
       instalList.add(inst);
       insert instalList;       
       instalList[0].Installation_Date__c =system.today();
       update instalList[0];   
       
        //Updating the order item
       otm.Installation__c = instalList[0].id;
    //   update otm;        
   }
   /*****
     Method:myUnitTest3
     ******/
    
    public static testMethod void myUnitTest4(){
       
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
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
        mm.Name='SL 35L';
        mm.Manufacturer__c='Richmond';
        insert mm;
        
       
          territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
        accounts[0].certified_installer__c = true;
       insert accounts;
       
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
        insert co ; 
        
          //Creating test data for user
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        try {
            insert testUser;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
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
        
        Quote__c q = new Quote__c();
            q.Name = 'Test Quote' ;
         q.Opportunity__c = olstOpportunity[0].Id;
            q.Primary_Quote__c=True;
        insert q;
        
        Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId =olstOpportunity[0].Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
        
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Quote__c = q.id ; 
        qd.Model__c = 'SL 35L';  
        insert qd ; 
        
             Order o = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            NanaQuote__c=q.id,
            Balance_Received_Date__c = system.today()       
        );
       
        insert o;
       
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
       inst.Order__c = o.id; 
          test.startTest() ; 
       insert inst ; 
              Test.stopTest() ;  
        
    }  
    
    public static testMethod void myUnitTest5(){
    
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
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
        
        //creating test data for territorymaster
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
      
        
        
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
        accounts[0].certified_installer__c = true;
        accounts[0].Territory__c = 'New York' ; 
      
       insert accounts;
       
       //Creating test data for contacts
       /*contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       insert contacts;*/
       
       
       list<contact> con=new list<contact>();
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
         co.Email='test123@noemail.com';
         co.Phone='125869';
         co.Country__c='Aruba';
        co.Title = 'Certified Nana Installer' ; 
         con.add(co);
         insert con;
       
//          Id p = [select id from profile where name='Partner Community User'].id;
        
        //Creating test data for user
        User testUser1 = TestDataUtility.createUser('Partner Community Login User', 'testUserName@testing.com');
            testUser1.email='test123@noemail.com' ; 
             testUser1.emailencodingkey='UTF-8' ; 
                             testUser1.lastname='Testing' ;  
                             testUser1.languagelocalekey='en_US' ; 
                             testUser1.localesidkey='en_US' ; 
                             testUser1.country='United States' ; 
                             testUser1.IsActive =true ;
                             testUser1.ContactId = con[0].Id ; 
                             testUser1.timezonesidkey='America/Los_Angeles' ; 
   
        try {
            insert testUser1;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
       //Creating test data for projects
       list<Project__c> Pro= new list<Project__c>();
       Pro=TestDataUtility.createProjectTestData();
       Pro[0].TerritoryName__c = 'New York' ; 
       insert Pro[0];
        
        
        //Creating test data for Opportunities 
        olstOpportunity = TestDataUtility.createOppTestData();
            olstOpportunity[0].Accountid=accounts[0].id;
            olstOpportunity[0].Project_Name__c =Pro[0].Id ;
           // olstOpportunity[0].OwnerId=testuser1.id;
            insert olstOpportunity;
        system.assert(olstOpportunity.size()>0);
           
        //Creating test data for Quote
        list<quote__c> Quo = new list<Quote__c>() ; 
            Quo = TestDataUtility.createQuoteRecords(olstOpportunity) ; 
            Quo[0].City__c = 'Test City';
            Quo[0].Country__c='India';
            Quo[0].State__c = 'Test State';
            Quo[0].Address__c = 'Test Address' ; 
            Quo[0].Zip__c ='12345';
            insert quo[0] ; 
            
            Quote q1 = new Quote();
             q1.Name = 'Test Quote';
             q1.OpportunityId = olstOpportunity[0].Id;
             q1.Nana_Quote__c = quo[0].Id;
             q1.First_Threshold_Price__c = 1;        
             q1.ContactId = Con[0].id;
             q1.Tax = 1.0;
             q1.Order_Number__c = 12345;
             insert q1;
        
          list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
          QuoteDetailList[0].Quote__C=quo[0].id;
            insert QuoteDetailList[0] ; 
    
        
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
      /* Order o = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()       
        );
        insert o;*/
       
       //Creating test data for PriceBookEntry
       PricebookEntry pbe = new PricebookEntry();
       pbe.Product2Id = productList[0].id;
       pbe.UnitPrice = 7092;
       pbe.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe;
           
        //Creating test data for OrderItem
       OrderItem otm = new orderitem();
      // otm.OrderId = o.id;
       otm.PricebookEntryId = pbe.id;
       otm.Quantity = 1;
       otm.UnitPrice = 5532;
     //  insert otm;
        
        //Creating test data for entitlements
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = accounts[0].id;
        ent.StartDate = system.today();
  //      ent.Order__c = o.id;
     //   ent.Order_Product__c = otm.id;
        insert ent;
        
       //Creating test data for Installation 
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
        inst.Installation_Address__c = 'Other Address';
       inst.Account__c = accounts[0].id ; 
       //inst.Order__c = o.id;
       inst.Quote_Name__c = quo[0].ID ;
       inst.contact__c = con[0].id ; 
       inst.Installer_Account__c = accounts[0].id;
       inst.Installer_Contact__c = con[0].Id ;
       inst.Assigned_to__c = testUser1.ID ;
       inst.Project__c = Pro[0].Id ;
        inst.Street_Address__c = 'Test street address';
        inst.City__c ='Test City';
        inst.State__c = 'Alabama' ; 
        inst.Country__c = 'United States' ;
        inst.Zip_Postal_Code__c = '12345' ;
       instalList.add(inst);
       insert instalList;       
       instalList[0].Installation_Date__c =system.today();
       //update instalList[0];   
       
        //Updating the order item
      // otm.Installation__c = instalList[0].id;
      // update otm;        
   }
    
    public static testMethod void myUnitTest6(){
    
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
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
        
        //creating test data for territorymaster
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
      
        
        
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
        accounts[0].certified_installer__c = true;
        accounts[0].Territory__c = 'New York' ; 
      
       insert accounts;
       
       //Creating test data for contacts
       /*contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       insert contacts;*/
       
       
       list<contact> con=new list<contact>();
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
         co.Email='test123@noemail.com';
         co.Phone='125869';
         co.Country__c='Aruba';
        co.Title = 'Certified Nana Installer' ; 
         con.add(co);
         insert con;
       
//          Id p = [select id from profile where name='Partner Community User'].id;
        
        //Creating test data for user
        User testUser1 = TestDataUtility.createUser('Partner Community Login User', 'testUserName@testing.com');
            testUser1.email='test123@noemail.com' ; 
             testUser1.emailencodingkey='UTF-8' ; 
                             testUser1.lastname='Testing' ;  
                             testUser1.languagelocalekey='en_US' ; 
                             testUser1.localesidkey='en_US' ; 
                             testUser1.country='United States' ; 
                             testUser1.IsActive =true ;
                             testUser1.ContactId = con[0].Id ; 
                             testUser1.timezonesidkey='America/Los_Angeles' ; 
   
        try {
            insert testUser1;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
       //Creating test data for projects
       list<Project__c> Pro= new list<Project__c>();
       Pro=TestDataUtility.createProjectTestData();
       Pro[0].TerritoryName__c = 'New York' ; 
       insert Pro[0];
        
        
        //Creating test data for Opportunities 
        olstOpportunity = TestDataUtility.createOppTestData();
            olstOpportunity[0].Accountid=accounts[0].id;
            olstOpportunity[0].Project_Name__c =Pro[0].Id ;
           // olstOpportunity[0].OwnerId=testuser1.id;
            insert olstOpportunity;
        system.assert(olstOpportunity.size()>0);
           
        //Creating test data for Quote
        list<quote__c> Quo = new list<Quote__c>() ; 
            Quo = TestDataUtility.createQuoteRecords(olstOpportunity) ; 
            Quo[0].City__c = 'Test City';
            Quo[0].Country__c='India';
            Quo[0].State__c = 'Test State';
            Quo[0].Address__c = 'Test Address' ; 
            Quo[0].Zip__c ='12345';
            insert quo[0] ; 
            
            Quote q1 = new Quote();
             q1.Name = 'Test Quote';
             q1.OpportunityId = olstOpportunity[0].Id;
             q1.Nana_Quote__c = quo[0].Id;
             q1.First_Threshold_Price__c = 1;        
             q1.ContactId = Con[0].id;
             q1.Tax = 1.0;
             q1.Order_Number__c = 12345;
             insert q1;
        
          list<Quote_Detail__c> QuoteDetailList = TestDataUtility.createQuoteDetailData();
          QuoteDetailList[0].Quote__C=quo[0].id;
            insert QuoteDetailList[0] ; 
    
        
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
      /* Order o = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId(),
            status='Draft',
            Balance_Received_Date__c = system.today()       
        );
        insert o;*/
       
       //Creating test data for PriceBookEntry
       PricebookEntry pbe = new PricebookEntry();
       pbe.Product2Id = productList[0].id;
       pbe.UnitPrice = 7092;
       pbe.Pricebook2Id = Test.getStandardPricebookId();
       insert pbe;
           
        //Creating test data for OrderItem
       OrderItem otm = new orderitem();
       //otm.OrderId = o.id;
       otm.PricebookEntryId = pbe.id;
       otm.Quantity = 1;
       otm.UnitPrice = 5532;
     // insert otm;
        
        //Creating test data for entitlements
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = accounts[0].id;
        ent.StartDate = system.today();
  //      ent.Order__c = o.id;
     //   ent.Order_Product__c = otm.id;
        insert ent;
        
       //Creating test data for Installation 
       List<Installation__c> instalList = new List<Installation__c>();
       Installation__c inst = new Installation__c();
       inst.Status__c = 'Open';
        inst.Installation_Address__c = 'Other Address';
       inst.Account__c = accounts[0].id ; 
       //inst.Order__c = o.id;
       //inst.Quote_Name__c = quo[0].ID ;
       inst.contact__c = con[0].id ; 
       inst.Installer_Account__c = accounts[0].id;
       inst.Installer_Contact__c = con[0].Id ;
       inst.Assigned_to__c = testUser1.ID ;
       inst.Project__c = Pro[0].Id ;
        inst.Street_Address__c = 'Test street address';
        inst.City__c ='Test City';
        inst.State__c = 'Alabama' ; 
        inst.Country__c = 'United States' ;
        inst.Zip_Postal_Code__c = '12345' ;
       instalList.add(inst);
       insert instalList;       
       instalList[0].Installation_Date__c =system.today();
       //update instalList[0];   
       
        //Updating the order item
      // otm.Installation__c = instalList[0].id;
      // update otm;        
   }
    public static testMethod void myUnitTest7(){
  
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        list<Account> acclist = TestDataUtility.createAccountTestData();
        acclist[0].Certified_Installer__c = true;
        insert acclist;
        list<Contact> contest = TestDataUtility.createConTestData();
        contest[0].AccountId = acclist[0].id;
        insert contest;
        Project__c prolist = new Project__c();
        prolist.Project_Zip_Code__c = '94040';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Opportunity> opplist = TestDataUtility.createOppTestData();
        insert opplist;
        test.startTest();
        list<Quote__C> quolist = TestDataUtility.createQuoteRecords(opplist);
        insert quolist;
        User testUnew = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUnew;
        list<Installation__c> inst = TestDataUtility.createInsTestData();
        for(Integer i=0;i<inst.size();i++){
            inst[i].Bypass_Flow__c = true;
            inst[i].Project__c = prolist.id;
        }
        inst[0].Quote_Name__c = quolist[0].id;
        inst[0].Installer_Account__c = acclist[0].id;
        inst[0].contact__c = contest[0].id;
        inst[0].Assigned_to__c = testUnew.id;
       
        insert inst;
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = acclist[0].id;
        ent.StartDate = system.today();
        ent.Nana_Quote__c = quolist[0].id;
        insert ent;
        inst[0].Installer_Contact__c = contest[0].id;
        update inst[0];
        
        test.stopTest();
    }
    public static testMethod void myUnitTest8(){
  
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        list<Account> acclist = TestDataUtility.createAccountTestData();
        acclist[0].Certified_Installer__c = true;
        insert acclist;
        list<Contact> contest = TestDataUtility.createConTestData();
        contest[0].AccountId = acclist[0].id;
        insert contest;
        Project__c prolist = new Project__c();
        prolist.Project_Zip_Code__c = '94040';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Opportunity> opplist = TestDataUtility.createOppTestData();
        insert opplist;
                test.startTest();
        list<Quote__C> quolist = TestDataUtility.createQuoteRecords(opplist);
        insert quolist;
        User testUnew = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUnew;
        list<Installation__c> inst1 = TestDataUtility.createInsTestData();
        for(Integer i=0;i<inst1.size();i++){
            inst1[i].Bypass_Flow__c = true;
            inst1[i].Project__c = prolist.id;
        }
        inst1[0].Quote_Name__c = quolist[0].id;
        inst1[0].Installer_Account__c = acclist[0].id;
        inst1[0].contact__c = contest[0].id;
        inst1[0].Assigned_to__c = testUnew.id;
        inst1[0].Installation_Date__c = null;
        insert inst1;
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = acclist[0].id;
        ent.StartDate = system.today();
        ent.Nana_Quote__c = quolist[0].id;
        insert ent;
        inst1[0].Installer_Contact__c = contest[0].id;
        update inst1[0];
        //insert inst1;
        test.stopTest();
    }
    public static testMethod void myUnitTest9(){
  
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        list<Account> acclist = TestDataUtility.createAccountTestData();
        acclist[0].Certified_Installer__c = true;
        insert acclist;
        list<Contact> contest = TestDataUtility.createConTestData();
        contest[0].AccountId = acclist[0].id;
        insert contest;
        Project__c prolist = new Project__c();
        prolist.Project_Country__c = 'Canada';
        prolist.Project_Zip_Code__c = 'M6R2J5';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Opportunity> opplist = TestDataUtility.createOppTestData();
        insert opplist;
                test.startTest();
        list<Quote__C> quolist = TestDataUtility.createQuoteRecords(opplist);
        insert quolist;
        list<Quote_Detail__c> qdlist = TestDataUtility.createQuoteDetailData();
        for(Integer i=0;i<qdlist.size();i++){
        qdlist[i].Quote__c = quolist[i].id;
        }
        insert qdlist;
        User testUnew = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUnew;
        list<Installation__c> inst1 = TestDataUtility.createInsTestData();
        for(Integer j=0;j<inst1.size();j++){
          inst1[j].Quote_Name__c = quolist[j].id;
            inst1[j].Bypass_Flow__c = true;
            inst1[j].Project__c = prolist.id;
        }
        inst1[0].Installer_Account__c = acclist[0].id;
        inst1[0].contact__c = contest[0].id;
        inst1[0].Assigned_to__c = testUnew.id;
       // inst1[0].Project__c = prolist.id;
        inst1[0].Installation_Date__c = System.today();
        insert inst1;
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = acclist[0].id;
        ent.StartDate = system.today();
        ent.Nana_Quote__c = quolist[0].id;
        insert ent;
        inst1[0].Installer_Contact__c = contest[0].id;
        update inst1[0];
        
        test.stopTest();
    }
    public static testMethod void myUnitTest10(){
  
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        User newUser = TestDataUtility.createUser('System Administrator','newuser@gmail.com');
        insert newUser;
        list<Account> acclist = TestDataUtility.createAccountTestData();
        acclist[0].Certified_Installer__c = true;
        insert acclist;
        list<Contact> contest = TestDataUtility.createConTestData();
        contest[0].AccountId = acclist[0].id;
        insert contest;
        Project__c prolist = new Project__c();
        prolist.Project_Country__c = 'United States';
        prolist.Project_Zip_Code__c = '44030';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Opportunity> opplist = TestDataUtility.createOppTestData();
        insert opplist;
                test.startTest();
        list<Quote__C> quolist = TestDataUtility.createQuoteRecords(opplist);
        insert quolist;
        list<Quote_Detail__c> qdlist = TestDataUtility.createQuoteDetailData();
        for(Integer i=0;i<qdlist.size();i++){
        qdlist[i].Quote__c = quolist[i].id;
        }
        insert qdlist;
        User testUnew = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUnew;
        list<Installation__c> inst1 = TestDataUtility.createInsTestData();
        for(Integer j=0;j<inst1.size();j++){
          inst1[j].Quote_Name__c = quolist[j].id;
            inst1[j].Bypass_Flow__c = true;
           inst1[j].Project__c = prolist.id;
        }
        inst1[0].Installer_Account__c = acclist[0].id;
        inst1[0].contact__c = contest[0].id;
        inst1[0].Assigned_to__c = testUnew.id;
        //inst1[0].Project__c = prolist.id;
        inst1[0].Installation_Date__c = null;
        inst1[0].Assigned_To_Paul_Nalette__c = true;
        insert inst1;
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = acclist[0].id;
        ent.StartDate = system.today();
        ent.Nana_Quote__c = quolist[0].id;
        insert ent;
        inst1[0].OwnerId = newUser.id;
        update inst1[0];
        
        test.stopTest();
    }
    public static testMethod void myUnitTest11(){
  
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        User newUser = TestDataUtility.createUser('System Administrator','newuser@gmail.com');
        insert newUser;
        list<Account> acclist = TestDataUtility.createAccountTestData();
        acclist[0].Certified_Installer__c = true;
        insert acclist;
        list<Contact> contest = TestDataUtility.createConTestData();
        contest[0].AccountId = acclist[0].id;
        list<Case>caselist = TestDataUtility.createCaseTestData();
        insert caselist;
        insert contest;
        Project__c prolist = new Project__c();
        prolist.Project_Country__c = 'United States';
        prolist.Project_Zip_Code__c = '12345';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
        list<Opportunity> opplist = TestDataUtility.createOppTestData();
        insert opplist;
                test.startTest();
        list<Quote__C> quolist = TestDataUtility.createQuoteRecords(opplist);
        insert quolist;
        list<Quote_Detail__c> qdlist = TestDataUtility.createQuoteDetailData();
        for(Integer i=0;i<qdlist.size();i++){
        qdlist[i].Quote__c = quolist[i].id;
        }
        insert qdlist;
        User testUnew = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUnew;
        list<Installation__c> inst1 = TestDataUtility.createInsTestData();
        for(Integer j=0;j<inst1.size();j++){
          inst1[j].Quote_Name__c = quolist[j].id;
            inst1[j].Bypass_Flow__c = true;
           inst1[j].Project__c = prolist.id;
        }
        inst1[0].Installer_Account__c = acclist[0].id;
        inst1[0].contact__c = contest[0].id;
        inst1[0].Assigned_to__c = testUnew.id;
        //inst1[0].Project__c = prolist.id;
        inst1[0].Installation_Date__c = null;
        inst1[0].Assigned_To_Bill_Leon__c = true;
        insert inst1;
        Entitlement ent = new Entitlement();
        ent.Name = '0001sl';
        ent.AccountId = acclist[0].id;
        ent.StartDate = system.today();
        ent.Nana_Quote__c = quolist[0].id;
        insert ent;
        inst1[0].OwnerId = newUser.id;
        update inst1[0];
        
        test.stopTest();
    }
}