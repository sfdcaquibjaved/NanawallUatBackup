@isTest
public class warrantyReduction_Test {
    public static list < Zip_Codes_Master__c > territorymaster;
    public static User testUser;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Account > accounts;
    public static list < Contact> contacts;
    public static list < Opportunity > olstOpportunity;
    public static list < Project__c > projects;
    public static list < Product2> productList;
    
    /*****
     Method:unitTest1
     Purpose: To create warranties for the glass products 
     *****/
    public static testMethod void unitTest1(){
    
        //Creating test data for Territory Master
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
        
        //Creating test data for Accounts 
       accounts = testDataUtility.createAccountTestData();
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
        
       //Creating test data for products
       productList = TestDataUtility.createProductData();
       productList[0].Name = 'WA67';
       insert productList;
       system.assert(productList.size()>0);
       
        //Creating test data for Pricebook
       Pricebook2 pb2 = new Pricebook2();
       pb2.Name = 'Models';
       insert pb2;
        system.assertequals('Models',pb2.Name);
       
        //Create test data for Orders
       Order o = new Order(
            AccountId = accounts[0].id,
            EffectiveDate = system.today(),
            Status = 'Draft',
            OpportunityId = olstOpportunity[0].id,
            Pricebook2Id = Test.getStandardPricebookId()
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
       insert otm;
        
        //Creating test data for Entitlement
        List<Entitlement> entitleList = new List<Entitlement>();
        Entitlement ent1 = new Entitlement();
        ent1.Name = 'Entitlement1';
        ent1.Accountid = accounts[0].id;
        ent1.certified_Installer__c = true;
        //ent1.Order_Product__c = otm.id;
        //ent1.Order__c = o.id;
        ent1.Warranty_Years__c = 5;                  
        insert ent1;
        ent1.certified_Installer__c = false;  
        ent1.Warranty_Years__c = 10;     
        update ent1;
        
        //system.assertEquals(10, ent1.Warranty_Years__c);
        
     }
}