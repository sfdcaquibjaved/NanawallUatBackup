@isTest
Private class TestZillowProject{
 public static List<Account> olstTestAccount;
  public static List<Lead> olstTestLead;
  public static List<Project__c> olstTestProject;
  public static List<Contact> olstTestContact;
  public static List<Opportunity> olstTestOpp;
 Static testMethod void Zillow(){
 
 olstTestAccount=TestDataUtility.createAccountTestData();
     try{
 insert olstTestAccount;
     }
     catch(Exception e){}
 olstTestLead=TestDataUtility.createLeadTestData();
     try{
     insert olstTestLead;
     }
     catch(Exception e){}
 olstTestContact=TestDataUtility.createConTestData();
     try{
 insert olstTestContact;
     }
     catch(Exception e){}
 olstTestOpp=TestDataUtility.createOppTestData();
     try{
 insert olstTestOpp;
     }
     catch(Exception e){}
 olstTestProject=TestDataUtility.createProjectTestData();
 olstTestProject[0].Project_State__c='California';
 olstTestProject[0].Project_City__c='San Jose';
 olstTestProject[0].Project_Country__c='United States';
 olstTestProject[0].Project_Street_Address__c='Blossom Hill Road';
     try{
     insert olstTestProject;
     }
     catch(Exception e){}
 Test.startTest();
 ApexPages.StandardController controller = new ApexPages.StandardController(olstTestProject[0]);
    ZillowController nCustom = new ZillowController(controller);
    nCustom.MyEstimate();
    nCustom.getobjtype();
   
     
 Test.StopTest();
 }
    Static testMethod void Zillow2(){
        
        list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'San jose';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'California';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode;
        
        
       list<Account> accountlst = new list<Account>();
       Account a = new Account();
        a.Name = 'Test account';
        a.Phone = '(123) 456-7890';
        //a.Name = 'Test account';
        a.BillingState = 'Maine';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'stow';
        a.Type='Interior Designer';
        accountlst.add(a);
       insert accountlst;
        
        /*List<Opportunity> oppslist = new List<Opportunity>();
       
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.Project_Name__c = projlst[0].Id;
        o.StageName = 'Proposal/Price Quote';
        o.Amount=1000;
        oppslist.add(o);  
            insert oppslist;*/
        
        List<Contact> conlist = new List<Contact>();
       Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo' ;
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        conlist.add(con);
        insert conlist;
        
        List<Lead> leadlist = new List<Lead>();
        Lead l = new Lead();
        l.Phone = '(123) 456-7890';
        l.project_name__c = 'Test Proj';
        l.FirstName = 'testfirst' ;
        l.LastName = 'testlast';
        l.PostalCode = '12345';
        l.CountryCode = 'US';
        l.Type_of_record__c = 'Commercial';
        l.Project_Application_Industry__c = 'Automotive';
        l.Project_Application__c = 'Dealership';
        l.Project_Site_Zip_Code__c= '12345';
        leadlist.add(l); 
        insert leadlist;
        
        list<Project__c> projlst = new list<Project__c>();
            Project__c p1 = new Project__c();
            //p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_State__c='California';
             p1.Project_City__c='San Jose';
             p1.Project_Country__c='United States';
             p1.Project_Street_Address__c='Blossom Hill Road';
             
        projlst.add(p1);
        insert projlst;
        
        List<Opportunity> oppslist = new List<Opportunity>();
       
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.Project_Name__c = projlst[0].Id;
        o.StageName = 'Proposal/Price Quote';
        o.Amount=1000;
        oppslist.add(o);  
            insert oppslist;
        
        
        Test.startTest();
 ApexPages.StandardController controller = new ApexPages.StandardController(projlst[0]);
    ZillowController nCustom = new ZillowController(controller);
    nCustom.MyEstimate();
    nCustom.getobjtype();
     
     //MyEstimate E=new MyEstimate();   
      //E.getZEstimateAmount();
      //System.currentPageReference().getParameters().put('searchZillow','US','sanjose','california');
      // ZillowController.LocationDetailsLink= 'test';
      System.currentPageReference().getParameters().put('LocationDetailsLink','test');
      System.currentPageReference().getParameters().put('LocationValueString','test');
        System.currentPageReference().getParameters().put('LocationValue','10');
        System.currentPageReference().getParameters().put('address','test');
            System.currentPageReference().getParameters().put('state','california');
                System.currentPageReference().getParameters().put('city','San Jose');
     
 Test.StopTest();
        
        
        
        
        
    }
      
 }