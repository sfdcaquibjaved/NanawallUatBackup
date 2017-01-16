@isTest
public class testQuote_WizardController {
    
    public static list<Account> olstAccount ;
    public static list<Account> olstAccount1 ;
    public static list<Contact> olstContact ;
    public static list<Opportunity> olstOpportunity ;
    //public static list<Project__c> olstProject;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list<nrOpportunityContactRole__c> Contactroles;
    public static User testUser ;
    public static list<Zip_Codes_Master__c> territorymaster;
    public static boolean insufficentPrivilege ;
    
    static testmethod void method1(){
        // Insert Territory Details
       
        territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
      //Insert test Country codes
        countrys = TestDataUtility.getTestCountryCodes();
            insert countrys;
        
      //insert test  state codes
        states = TestDataUtility.getTestStateCodes();
            insert states;
        
      //insert test user 
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
            insert testUser;
        
      //insert test Account records
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
            insert olstAccount ;
    
      //insert test Task
        Task testTask = new Task(Subject  = 'Other' , priority = 'Normal' , Status = 'Not Started');
        insert testTask;
        
      //Insert test contact records
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        try{
            insert olstContact ;
        }catch(Exception e){}
        
        olstContact[1].MailingCountryCode='MX';
        olstContact[1].MailingStateCode='';
         try{
             insert olstContact[1];
            }
         catch(DmlException e) {
             
         }        
       /*
      //insert test project records
        olstProject = TestDataUtility.createProjectTestData();
        olstProject[0].Project_State__c ='';
        olstProject[0].Project_Country__c ='United States';
        olstProject[0].Close_Date__c = date.parse('07/27/2015');*/
            
        
        list<Project__c> olstProject =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
       // p.Stage__c='Prospecting';
        p.Application__c = 'Automotive';
        p.Application_2__c = 'Dealership';

        olstProject.add(p);
        try{
        insert olstProject;
        }catch(Exception e){}
        
      //insert test Opportunity records 
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        olstOpportunity[0].Project_Name__c = olstProject[0].Id;
            insert olstOpportunity ;
        system.debug('$$$'+olstOpportunity);
        
      //insert test Contact roles
        Contactroles = TestDataUtility.createOppConRTestData(olstOpportunity, olstContact);
            insert Contactroles;
        Test.StartTest();
        
        PageReference pageRef = Page.Quote_Wizard_CreateAccountContact;
         Test.setCurrentPageReference(pageRef);
        
        System.currentPageReference().getParameters().put('accountId',olstAccount[0].id);
        System.currentPageReference().getParameters().put('contactId',olstContact[0].id);
        System.currentPageReference().getParameters().put('projectId',olstProject[0].id);
        
        //System.currentPageReference().getParameters().put('rowId','1');
        System.currentPageReference().getParameters().put('accUrl',olstAccount[0].id);
        System.currentPageReference().getParameters().put('conUrl',olstContact[0].id);
        System.currentPageReference().getParameters().put('projUrl',olstProject[0].id);
        System.currentPageReference().getParameters().put('oppUrl',olstOpportunity[0].id);
        
        //System.currentPageReference().getParameters().put('oppUrl','');
        
        Quote_WizardController qwc = new Quote_WizardController();
            qwc.getContactOption();
            qwc.getAccountOption();
            qwc.getProjectOption();
            qwc.initializeContactCreateOption();
            qwc.initializeAccountCreateOption();
            qwc.initializeProjectCreateOption();
            qwc.CopyAddressFields();
            qwc.updateAddressNew();
            qwc.syncAccount();
            qwc.syncContact();
            qwc.syncProject();
            qwc.saveAndCreateQuote();
            
            //qwc.createQuoteonExistOpp();
           qwc.contactCreateOption = 'Existing Contact';
            qwc.initializeContactCreateOption();
            qwc.contactCreateOption = 'New Contact';
            qwc.initializeContactCreateOption();
            
            qwc.accountCreateOption = 'New Account';
            qwc.initializeAccountCreateOption();
            qwc.accountCreateOption = 'Attach To Existing Account';
            qwc.initializeAccountCreateOption();
            qwc.projectCreateOption = 'New Project';
            //qwc.proj.Project_State__c='';
            qwc.initializeProjectCreateOption();
            qwc.createOpportunityProjects();
            
            qwc.updateContactAddressNew();
            boolean vp = qwc.validateProjects();
            boolean vf = qwc.validateFields();
            boolean  t = qwc.validateZip('12345','US');
            qwc.goBack();
        Test.StopTest();
    }
    
    static testMethod void method2() {
      // Insert Territory Details
        territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
      //Insert test Country codes
        countrys = TestDataUtility.getTestCountryCodes();
            insert countrys;
        
      //insert test  state codes
        states = TestDataUtility.getTestStateCodes();
            insert states;
        
      //insert test user 
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
            insert testUser;
        
      //insert test Account records
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
            insert olstAccount ;
    
      //insert test Task
        Task testTask = new Task(Subject  = 'Other' , priority = 'Normal' , Status = 'Not Started');
        insert testTask;
        
      //Insert test contact records
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
         olstContact[0].Email='test@gmail.com';
        try{   
        insert olstContact ;
        }catch(Exception e){}
       
         
        
        list<Project__c> olstProject =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=date.today().addDays(180)+2;
        p.Stage__c='Closed Won - Order Signed';
        p.Application__c = 'Automotive';
        p.Application_2__c = 'Dealership';
        p.ProjectCloneID__c='abcd';
        p.Send_for_Approval__c=true;
        p.Approval_Status__c='Approved';
        p.Project_State__c='Alabama';
        

        olstProject.add(p);
        try{
        insert olstProject;
        }catch(Exception e){}
        
        
      //insert test Opportunity records 
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        olstOpportunity[0].Project_Name__c = p.Id;
        olstOpportunity[0].CloseDate =date.today().addDays(180);
            insert olstOpportunity ;
        system.debug('$$$'+olstOpportunity);
        
      //insert test Contact roles
        Contactroles = TestDataUtility.createOppConRTestData(olstOpportunity, olstContact);
        Contactroles[0].contact__c=olstContact[0].id;
            insert Contactroles;
        
        nrOpportunityContactRole__c noppcr=new nrOpportunityContactRole__c();
        noppcr.Contact__c=olstContact[0].id;
        noppcr.Opportunity__c =olstOpportunity[0].id;
        insert noppcr;
        delete noppcr;
        
      
       test.startTest();
        
        PageReference pageRef = Page.Quote_Wizard_CreateAccountContact;
         Test.setCurrentPageReference(pageRef);
        
        System.currentPageReference().getParameters().put('accountId',olstAccount[0].id);
        System.currentPageReference().getParameters().put('contactId',olstContact[0].id);
        System.currentPageReference().getParameters().put('projectId',olstProject[0].id);
        
        //System.currentPageReference().getParameters().put('rowId','1');
        System.currentPageReference().getParameters().put('accUrl',olstAccount[0].id);
       System.currentPageReference().getParameters().put('conUrl',olstContact[0].id);
       System.currentPageReference().getParameters().put('projUrl',olstProject[0].id);
       //System.currentPageReference().getParameters().put('oppUrl',olstOpportunity[0].id);
   
        
        Quote_WizardController_Clone qwc = new Quote_WizardController_Clone();
        	qwc.getContactOption();
            qwc.getAccountOption();
            qwc.getProjectOption();
            qwc.initializeContactCreateOption();
            qwc.initializeAccountCreateOption();
            qwc.initializeProjectCreateOption();
            qwc.CopyAddressFields();
            qwc.updateAddressNew();
            qwc.syncAccount();
            qwc.syncContact();
            qwc.contactCreateOption = 'Existing Contact';
             qwc.accountCreateOption = 'New Account';
         qwc.contactCreateOption = 'New Contact';
        qwc.projectCreateOption = 'New Project';
        qwc.createOpportunityProjects();
            qwc.saveAndCreateQuote();
            
            //qwc.contactCreateOption = 'Existing Contact';
            //qwc.initializeContactCreateOption();
            qwc.contactCreateOption = 'New Contact';
            qwc.initializeContactCreateOption();
            qwc.accountCreateOption = 'New Account';
            qwc.initializeAccountCreateOption();
           // qwc.accountCreateOption = 'Attach To Existing Account';
            //qwc.initializeAccountCreateOption();
           qwc.projectCreateOption = 'New Project';
           //qwc.initializeProjectCreateOption();
            qwc.projectCreateOption = 'Existing Project';
            qwc.initializeProjectCreateOption();        
            qwc.createOpportunityProjects();
            
            qwc.updateContactAddressNew();
            boolean vp = qwc.validateProjects();
            boolean vf = qwc.validateFields();
            boolean  t = qwc.validateZip('12345','US');
            qwc.goBack();
        	qwc.Approvalprocess();
        	qwc.CloneAndCreateQuote();
        test.stoptest();
    }
    
    static testmethod void method3(){
        // Insert Territory Details
       
        territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
      //Insert test Country codes
        countrys = TestDataUtility.getTestCountryCodes();
            insert countrys;
        
      //insert test  state codes
        states = TestDataUtility.getTestStateCodes();
            insert states;
        
      //insert test user 
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
            insert testUser;
        
      //insert test Account records
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
            insert olstAccount ;
    
      //insert test Task
        Task testTask = new Task(Subject  = 'Other' , priority = 'Normal' , Status = 'Not Started');
        insert testTask;
        
      //Insert test contact records
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        try{
            insert olstContact ;
        }catch(Exception e){}
        
        olstContact[1].MailingCountryCode='MX';
        olstContact[1].MailingStateCode='';
         try{
             insert olstContact[1];
            }
         catch(DmlException e) {
             
         }        
       /*
      //insert test project records
        olstProject = TestDataUtility.createProjectTestData();
        olstProject[0].Project_State__c ='';
        olstProject[0].Project_Country__c ='United States';
        olstProject[0].Close_Date__c = date.parse('07/27/2015');*/
            
        
        list<Project__c> olstProject =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
       // p.Stage__c='Prospecting';
        p.Application__c = 'Automotive';
        p.Application_2__c = 'Dealership';

        olstProject.add(p);
        try{
        insert olstProject;
        }catch(Exception e){}
        
      //insert test Opportunity records 
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        olstOpportunity[0].Project_Name__c = olstProject[0].Id;
            insert olstOpportunity ;
        system.debug('$$$'+olstOpportunity);
        
      //insert test Contact roles
        Contactroles = TestDataUtility.createOppConRTestData(olstOpportunity, olstContact);
            insert Contactroles;
        Test.StartTest();
        
        PageReference pageRef = Page.Quote_Wizard_CreateAccountContact;
         Test.setCurrentPageReference(pageRef);
        
        System.currentPageReference().getParameters().put('accountId',olstAccount[0].id);
        System.currentPageReference().getParameters().put('contactId',olstContact[0].id);
        System.currentPageReference().getParameters().put('projectId',olstProject[0].id);
        
        //System.currentPageReference().getParameters().put('rowId','1');
        System.currentPageReference().getParameters().put('accUrl',olstAccount[0].id);
        System.currentPageReference().getParameters().put('conUrl',olstContact[0].id);
        System.currentPageReference().getParameters().put('projUrl',olstProject[0].id);
        System.currentPageReference().getParameters().put('oppUrl',olstOpportunity[0].id);
        
        //System.currentPageReference().getParameters().put('oppUrl','');
        
        Quote_WizardController qwc = new Quote_WizardController();
            qwc.getContactOption();
            qwc.getAccountOption();
            qwc.getProjectOption();
            qwc.initializeContactCreateOption();
            qwc.initializeAccountCreateOption();
            qwc.initializeProjectCreateOption();
            qwc.CopyAddressFields();
            qwc.updateAddressNew();
            qwc.syncAccount();
            qwc.syncContact();
            qwc.syncProject();
            qwc.saveAndCreateQuote();
            qwc.createOpportunityProjects();
            //qwc.createQuoteonExistOpp();
           qwc.contactCreateOption = 'Existing Contact';
            qwc.initializeContactCreateOption();
            //qwc.contactCreateOption = 'New Contact';
            //qwc.initializeContactCreateOption();
            
            qwc.accountCreateOption = 'New Account';
            qwc.initializeAccountCreateOption();
            //qwc.accountCreateOption = 'Attach To Existing Account';
            //qwc.initializeAccountCreateOption();
            qwc.projectCreateOption = 'New Project';
            //qwc.proj.Project_State__c='';
            qwc.initializeProjectCreateOption();
            //
            
            qwc.updateContactAddressNew();
            boolean vp = qwc.validateProjects();
            boolean vf = qwc.validateFields();
            boolean  t = qwc.validateZip('12345','US');
            qwc.goBack();
        Test.StopTest();
    }
    static testMethod void method4() {
      // Insert Territory Details
        territorymaster=TestDataUtility.getTerritoryMaster();
        insert territorymaster;
        
      //Insert test Country codes
        countrys = TestDataUtility.getTestCountryCodes();
            insert countrys;
        
      //insert test  state codes
        states = TestDataUtility.getTestStateCodes();
            insert states;
        
      //insert test user 
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
            insert testUser;
        
      //insert test Account records
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
            insert olstAccount ;
    
      //insert test Task
        Task testTask = new Task(Subject  = 'Other' , priority = 'Normal' , Status = 'Not Started');
        insert testTask;
        
      //Insert test contact records
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
         olstContact[0].Email='test@gmail.com';
        try{   
        insert olstContact ;
        }catch(Exception e){}
       
         
        
        list<Project__c> olstProject =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=date.today().addDays(180)+2;
        p.Stage__c='Closed Won - Order Signed';
        p.Application__c = 'Automotive';
        p.Application_2__c = 'Dealership';
        p.ProjectCloneID__c='abcd';
        p.Send_for_Approval__c=true;
        p.Approval_Status__c='Rejected';
        p.Project_State__c='Alabama';
        

        olstProject.add(p);
        try{
        insert olstProject;
        }catch(Exception e){}
        
        
      //insert test Opportunity records 
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        olstOpportunity[0].Project_Name__c = p.Id;
        olstOpportunity[0].CloseDate =date.today().addDays(180);
            insert olstOpportunity ;
        system.debug('$$$'+olstOpportunity);
        
      //insert test Contact roles
        Contactroles = TestDataUtility.createOppConRTestData(olstOpportunity, olstContact);
        Contactroles[0].contact__c=olstContact[0].id;
            insert Contactroles;
        
        nrOpportunityContactRole__c noppcr=new nrOpportunityContactRole__c();
        noppcr.Contact__c=olstContact[0].id;
        noppcr.Opportunity__c =olstOpportunity[0].id;
        insert noppcr;
        delete noppcr;
        

      
       test.startTest();
        
        PageReference pageRef = Page.Quote_Wizard_CreateAccountContact;
         Test.setCurrentPageReference(pageRef);
        
        System.currentPageReference().getParameters().put('accountId',olstAccount[0].id);
        System.currentPageReference().getParameters().put('contactId',olstContact[0].id);
        System.currentPageReference().getParameters().put('projectId',olstProject[0].id);
        
        //System.currentPageReference().getParameters().put('rowId','1');
        System.currentPageReference().getParameters().put('accUrl',olstAccount[0].id);
       System.currentPageReference().getParameters().put('conUrl',olstContact[0].id);
       System.currentPageReference().getParameters().put('projUrl',olstProject[0].id);
       //System.currentPageReference().getParameters().put('oppUrl',olstOpportunity[0].id);
   
        
        Quote_WizardController qwc = new Quote_WizardController();
        	qwc.getContactOption();
            qwc.getAccountOption();
            qwc.getProjectOption();
            qwc.initializeContactCreateOption();
            qwc.initializeAccountCreateOption();
            qwc.initializeProjectCreateOption();
            qwc.CopyAddressFields();
            qwc.updateAddressNew();
            qwc.syncAccount();
            qwc.syncContact();
            //qwc.contactCreateOption = 'Existing Contact';
             qwc.accountCreateOption = 'New Account';
         qwc.contactCreateOption = 'New Contact';
        qwc.projectCreateOption = 'New Project';
        qwc.createOpportunityProjects();
            qwc.saveAndCreateQuote();
        qwc.insufficentPrivilege = true;       
            //qwc.contactCreateOption = 'Existing Contact';
            //qwc.initializeContactCreateOption();
        
            //qwc.contactCreateOption = 'New Contact';
            qwc.initializeContactCreateOption();
            //qwc.accountCreateOption = 'New Account';
            qwc.initializeAccountCreateOption();
           // qwc.accountCreateOption = 'Attach To Existing Account';
            //qwc.initializeAccountCreateOption();
            qwc.initializeProjectCreateOption();        
            qwc.createOpportunityProjects();
            
            qwc.updateContactAddressNew();
  
            boolean vp = qwc.validateProjects();
            boolean vf = qwc.validateFields();
            boolean  t = qwc.validateZip('12345','US');
            qwc.goBack();
        	
        test.stoptest();
    }
    
}