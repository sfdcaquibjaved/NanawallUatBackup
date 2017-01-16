@isTest
public class OrderItemProductTrigger_Test {
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
    
    public static testMethod void unitTest1(){
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
       
       OrderOppStages__c op = new OrderOppStages__c();
       op.name = 'On Hold';
       op.OppStage__c ='On Hold';
       insert op;
       
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
            status= 'On Hold',
            Balance_Received_Date__c = system.today()
        
        );
        insert o;
      //olstOpportunity[0].stageName =  OrderOppStages__c.getinstance.get(o.id).OppStage__c;
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
}