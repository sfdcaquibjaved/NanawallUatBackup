@isTest
public class EntitlementBatch_Test {
   
    public static list < Zip_Codes_Master__c > territorymaster;
    
    public static list <Account> accounts;
    public static list <Contact> contacts;
    public static list <Project__c> projects;
    public static list <Opportunity> Oppos;
    
    public static testMethod void UnitTest1() {
        
        string query = 'select id,Name, Balanced_Received_Date__c FROM Quote__c where Balanced_Received_Date__c !=null';
       
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        
       accounts = TestDataUtility.createAccountTestData();
       insert accounts;
        
         
        contacts = TestDataUtility.createConTestData();
        Contacts[0].Accountid=accounts[0].id;
      	Contacts[1].Accountid=accounts[1].id;
       	Contacts[2].Accountid=accounts[2].id;
        insert contacts;
       
    
        projects = TestDataUtility.createProjectTestData();
        insert projects;
        
        
        
        Oppos = TestDataUtility.createOppTestData();
        Oppos[0].Accountid = accounts[0].id;
        Oppos[0].Project_Name__c = projects[0].id;
        insert Oppos;
        
        
        Test.startTest(); 
        list<Quote__c> lstQuote = new list <Quote__C>();
        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = oppos[0].id;
        q.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q.Actual_Delivery_Date__c = date.today();
        q.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q.Contact__c = contacts[0].id;
        q.Balanced_Received_Date__c = Date.today();
        lstQuote.add(q);
        
        
        
        Quote__c q1 = new Quote__c();
        q1.Name = 'Test Quote';
        q1.Opportunity__c = Oppos[1].id;
        q1.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q1.Actual_Delivery_Date__c = date.today();
        q1.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q1.Contact__c = contacts[1].id;
        q1.Balanced_Received_Date__c = Date.today()-1;
        lstQuote.add(q1);
        insert lstQuote;
        
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
      
        qd.Model__c = 'CERO'; 
        qd.quote__c = lstQuote[0].id;
        qDetail.add(qd);    
        insert qDetail;
        
        warranties__c entwar =  new warranties__c(Name='CERO');
        insert entwar;
        
 
       
       entitlementBatch en = new entitlementBatch();
       Database.executeBatch(en);

        
        
       Test.stopTest();
           
    }
    
     public static testMethod void UnitTest2() {
        
        string query = 'select id,Name, Balanced_Received_Date__c FROM Quote__c where Balanced_Received_Date__c !=null';
       
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
       /* countrys = TestDataUtility.getTestCountryCodes();
        insert countrys;

        states = TestDataUtility.getTestStateCodes();
        insert states;*/
   
       accounts = TestDataUtility.createAccountTestData();
       insert accounts;
        
      
        
        contacts = TestDataUtility.createConTestData();
        Contacts[0].Accountid=accounts[0].id;
      	Contacts[1].Accountid=accounts[1].id;
       	Contacts[2].Accountid=accounts[2].id;
        insert contacts;
        
        
        
        projects = TestDataUtility.createProjectTestData();
        insert projects;
        
        
        
        Oppos = TestDataUtility.createOppTestData();
        Oppos[0].Accountid = accounts[0].id;
        Oppos[0].Project_Name__c = projects[0].id;
        insert Oppos;
        
        
         Test.startTest(); 
        list<Quote__c> lstQuote = new list <Quote__C>();
        Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = oppos[0].id;
        q.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q.Actual_Delivery_Date__c = date.today();
        q.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q.Contact__c = contacts[0].id;
        q.Balanced_Received_Date__c = Date.today();
        lstQuote.add(q);
        
        
        
        Quote__c q1 = new Quote__c();
        q1.Name = 'Test Quote';
        q1.Opportunity__c = Oppos[1].id;
        q1.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q1.Actual_Delivery_Date__c = date.today();
        q1.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q1.Contact__c = contacts[1].id;
        q1.Balanced_Received_Date__c = Date.today()-1;
        lstQuote.add(q1);
        insert lstQuote;
        
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
        //qd.quoteName__c = lstQuote.Name;
        //qd.Model__c = 'CERO'; 
        qd.quote__c = lstQuote[0].id;
        qDetail.add(qd); 
         
        Quote_Detail__c qd1 = new Quote_Detail__c();
        //qd.quoteName__c = lstQuote.Name;
        qd1.Model__c = 'HSW66'; 
        qd1.quote__c = lstQuote[0].id;
        qDetail.add(qd1);
        insert qDetail;
       
       entitlementBatch en = new entitlementBatch();
       Database.executeBatch(en);

        
        
       Test.stopTest();
           
    }
    
    
     public static testMethod void UnitTest3() {
        
        //string query = 'select id,Name, Balanced_Received_Date__c FROM Quote__c where Balanced_Received_Date__c !=null';
       
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        
       accounts = TestDataUtility.createAccountTestData();
       insert accounts;
        
         
        contacts = TestDataUtility.createConTestData();
        Contacts[0].Accountid=accounts[0].id;
      	Contacts[1].Accountid=accounts[1].id;
       	Contacts[2].Accountid=accounts[2].id;
        insert contacts;
       
        projects = TestDataUtility.createProjectTestData();
        insert projects;
        
        Oppos = TestDataUtility.createOppTestData();
        Oppos[0].Accountid = accounts[0].id;
        Oppos[0].Project_Name__c = projects[0].id;
        insert Oppos;  
        
        Test.startTest(); 
        list<Quote__c> lstQuote = new list <Quote__C>();
     /*   Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = oppos[0].id;
        q.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q.Actual_Delivery_Date__c = date.today();
        q.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q.Contact__c = contacts[0].id;
        q.Balanced_Received_Date__c = Date.today();
        lstQuote.add(q);*/
       
         
         
        Quote__c q1 = new Quote__c();
        q1.Name = 'Test Quote';
        q1.Opportunity__c = oppos[0].id;
        q1.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q1.Actual_Delivery_Date__c = date.today();
        q1.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q1.Contact__c = contacts[0].id;
        //q1.Balanced_Received_Date__c = Date.today();
        
         
       // lstQuote.add(q1);
        insert q1;
         
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'CERO'; 
        qd.quote__c = q1.id;
        qDetail.add(qd); 
        insert qDetail;
          
        warranties__c entwar =  new warranties__c(Name='HSW66');
        insert entwar;
         
        q1.Balanced_Received_Date__c = Date.today();
        update q1;
    
       
        
         
      /*  Quote_Detail__c qd1 = new Quote_Detail__c();
        qd1.Model__c = 'CERO'; 
        qd1.quote__c = q1.id;
        qDetail.add(qd1);  
         */
         
       
      
        
       
       
        entitlementBatch en = new entitlementBatch();
        Database.executeBatch(en);

        
        
       Test.stopTest();
           
    }
    
    
   public static testMethod void UnitTest4() {
        
        //string query = 'select id,Name, Balanced_Received_Date__c FROM Quote__c where Balanced_Received_Date__c !=null';
       
        
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
        
       accounts = TestDataUtility.createAccountTestData();
       insert accounts;
        
         
        contacts = TestDataUtility.createConTestData();
        Contacts[0].Accountid=accounts[0].id;
      	Contacts[1].Accountid=accounts[1].id;
       	Contacts[2].Accountid=accounts[2].id;
        insert contacts;
       
        projects = TestDataUtility.createProjectTestData();
        insert projects;
        
        Oppos = TestDataUtility.createOppTestData();
        Oppos[0].Accountid = accounts[0].id;
        Oppos[0].Project_Name__c = projects[0].id;
        insert Oppos;  
        
        Test.startTest(); 
        list<Quote__c> lstQuote = new list <Quote__C>();
     /*   Quote__c q = new Quote__c();
        q.Name = 'Test Quote';
        q.Opportunity__c = oppos[0].id;
        q.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q.Actual_Delivery_Date__c = date.today();
        q.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q.Contact__c = contacts[0].id;
        q.Balanced_Received_Date__c = Date.today();
        lstQuote.add(q);*/
       
         
         
        Quote__c q1 = new Quote__c();
        q1.Name = 'Test Quote';
        q1.Opportunity__c = oppos[0].id;
        q1.Primary_Quote__c=True;
        //q.Contact_Account_ID__c = 
        q1.Actual_Delivery_Date__c = date.today();
        q1.Install_Date__c = date.today()-2;
        //q.Accountid =accounts[0].id;
        q1.Contact__c = contacts[0].id;
        //q1.Balanced_Received_Date__c = Date.today();
        
         
       // lstQuote.add(q1);
        insert q1;
         
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'HSW66'; 
        qd.quote__c = q1.id;
        qDetail.add(qd); 
        insert qDetail;
          
        warranties__c entwar =  new warranties__c(Name='HSW66');
        insert entwar;
         
        q1.Balanced_Received_Date__c = Date.today();
        update q1;
    
       
        
         
      /*  Quote_Detail__c qd1 = new Quote_Detail__c();
        qd1.Model__c = 'CERO'; 
        qd1.quote__c = q1.id;
        qDetail.add(qd1);  
         */
         
       
      
        
       
       
        entitlementBatch en = new entitlementBatch();
        Database.executeBatch(en);

        
        
       Test.stopTest();
           
    }
    
    
}