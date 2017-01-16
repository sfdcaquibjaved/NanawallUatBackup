/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  1. SinglePageLeadConvertController - Apex Class
                                        
* @ Audit Trial   : Repeating block for each change to the code
**/
@isTest(SeeAllData=false)

private class SinglePageLeadConvertController_Test {
   /* 
    public static list<Account> olstAccount ;
    public static list<Contact> olstContact ;
    public static list<Opportunity> olstOpportunity ;
    public static list<Project__c> olstProject;
    public static User testUser ;
    
    static testMethod void myUnitTest() {
        
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
        insert olstAccount ;
        
        Task testTask = new Task(Subject  = 'Other' , priority = 'Normal' , Status = 'Not Started');
        insert testTask;
        
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        insert olstContact ;
        
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        insert olstOpportunity ;
        
        olstProject = TestDataUtility.createProjectTestData();
        insert olstProject;
  
        List<Apexpages.Message> msgs = ApexPages.getMessages();
            for(ApexPages.Message msg :  ApexPages.getMessages()) { 
                System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
            }

        SinglePageLeadConvertController testLeadConvert = new SinglePageLeadConvertController();
        testLeadConvert.selectedType = 'Commercial';
        testLeadConvert.setaccounttype('existing');
        testLeadConvert.getItems();
        testLeadConvert.getrecType();
        testLeadConvert.getAppItems();
                 
        
        testLeadConvert.selectedType = 'Residential';
         string useExistingproject='New';
        testLeadConvert.getAppItems();
        testLeadConvert.getnewaccount();
        testLeadConvert.setnewaccount(olstAccount[0]);
        testLeadConvert.getnewcontact();
        testLeadConvert.setnewcontact(olstContact[0]);
        testLeadConvert.getnewopportunity();
        testLeadConvert.setnewopportunity(olstOpportunity[0]);
        testLeadConvert.getaccounttype();
        testLeadConvert.getPros();
        
        Account acc = testLeadConvert.existAccount;
        testLeadConvert.getnewtask();
        testLeadConvert.getprojects();
        testLeadConvert.setprojects('pro');
        testLeadConvert.getApplications();
        testLeadConvert.setnewtask(testTask);
        testLeadConvert.setaccounttype('Test');
        
        boolean test = testLeadConvert.validateFields();
        testLeadConvert.continueWithProject();
        testLeadConvert.CreateObjects();
        testLeadConvert.sAppIndus = 'Sports';
        testLeadConvert.CreateObjects();
        testLeadConvert.onProjectCheck();
        testLeadConvert.updateAddressNew();
        testLeadConvert.getduplicateopps();
        
    }
    static testMethod void myUnitTest2() {
        
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
        insert olstAccount ;
        
        Task testTask = new Task(Subject  = 'Other' , priority = 'Normal' , Status = 'Not Started');
        insert testTask;
        
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        insert olstContact ;
        
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        insert olstOpportunity ;
        
        olstProject = TestDataUtility.createProjectTestData();
        insert olstProject;
  
        List<Apexpages.Message> msgs = ApexPages.getMessages();
            for(ApexPages.Message msg :  ApexPages.getMessages()) { 
                System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
            }

        SinglePageLeadConvertController testLeadConvert = new SinglePageLeadConvertController();
        testLeadConvert.selectedType = 'Commercial';
        testLeadConvert.setaccounttype('existing');
        testLeadConvert.getItems();
        testLeadConvert.getrecType();
        testLeadConvert.getAppItems();
                 
        
        testLeadConvert.selectedType = 'Residential';
         string useExistingproject='New';
        testLeadConvert.getAppItems();
        testLeadConvert.getnewaccount();
        //testLeadConvert.setnewaccount(olstAccount[0]);
        testLeadConvert.getnewcontact();
        //testLeadConvert.setnewcontact(olstContact[0]);
        testLeadConvert.getnewopportunity();
        testLeadConvert.setnewopportunity(olstOpportunity[0]);
        testLeadConvert.getaccounttype();
        testLeadConvert.getPros();
        
        Account acc = testLeadConvert.existAccount;
        testLeadConvert.getnewtask();
        testLeadConvert.getprojects();
        testLeadConvert.setprojects('new');
        testLeadConvert.getApplications();
        testLeadConvert.setnewtask(testTask);
        testLeadConvert.setaccounttype('new');
        
        boolean test = testLeadConvert.validateFields();
        testLeadConvert.continueWithProject();
        testLeadConvert.CreateObjects();
        testLeadConvert.sAppIndus = 'Sports';
        testLeadConvert.CreateObjects();
        testLeadConvert.onProjectCheck();
        testLeadConvert.updateAddressNew();
        testLeadConvert.getduplicateopps();
        
    }
    static testMethod void myUnitTest3() {
        
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
        insert olstAccount ;
        
        Task testTask = new Task(Subject  = 'Other' , priority = 'Normal' , Status = 'Not Started');
        insert testTask;
        
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        insert olstContact ;
        
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        insert olstOpportunity ;
        
        olstProject = TestDataUtility.createProjectTestData();
        insert olstProject;
  
        List<Apexpages.Message> msgs = ApexPages.getMessages();
            for(ApexPages.Message msg :  ApexPages.getMessages()) { 
                System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
            }

        SinglePageLeadConvertController testLeadConvert = new SinglePageLeadConvertController();
        testLeadConvert.selectedType = 'Commercial';
        testLeadConvert.setaccounttype('existing');
        testLeadConvert.getItems();
        testLeadConvert.getrecType();
        testLeadConvert.getAppItems();
                 
        
        testLeadConvert.selectedType = 'Residential';
         string useExistingproject='New';
        testLeadConvert.getAppItems();
        testLeadConvert.getnewaccount();
        testLeadConvert.setnewaccount(olstAccount[0]);
        testLeadConvert.getnewcontact();
        testLeadConvert.setnewcontact(olstContact[0]);
        testLeadConvert.getnewopportunity();
        testLeadConvert.setnewopportunity(olstOpportunity[0]);
        testLeadConvert.getaccounttype();
        testLeadConvert.getPros();
        
        Account acc = testLeadConvert.existAccount;
        testLeadConvert.getnewtask();
        testLeadConvert.getprojects();
        //testLeadConvert.setprojects('pro');
        testLeadConvert.getApplications();
        testLeadConvert.setnewtask(testTask);
        //testLeadConvert.setaccounttype('test');
        
        boolean test = testLeadConvert.validateFields();
        testLeadConvert.continueWithProject();
         testLeadConvert.setaccounttype('new');
         testLeadConvert.getaccounttype();
        testLeadConvert.setprojects('new');
        testLeadConvert.getprojects();
        testLeadConvert.CreateObjects();
        testLeadConvert.sAppIndus = 'Sports';
        testLeadConvert.CreateObjects();
        testLeadConvert.onProjectCheck();
        testLeadConvert.updateAddressNew();
        testLeadConvert.getduplicateopps();
        
    }
    static testMethod void myUnitTest4() {
        
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
        insert olstAccount ;
        
        Task testTask = new Task(Subject  = 'Other' , priority = 'Normal' , Status = 'Not Started');
        insert testTask;
        
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        insert olstContact ;
        
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        insert olstOpportunity ;
        
        olstProject = TestDataUtility.createProjectTestData();
        insert olstProject;
  
        List<Apexpages.Message> msgs = ApexPages.getMessages();
            for(ApexPages.Message msg :  ApexPages.getMessages()) { 
                System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
            }

        SinglePageLeadConvertController testLeadConvert = new SinglePageLeadConvertController();
        testLeadConvert.selectedType = 'Commercial';
        testLeadConvert.setaccounttype('existing');
        testLeadConvert.getItems();
        testLeadConvert.getrecType();
        testLeadConvert.getAppItems();
                 
        
        testLeadConvert.selectedType = 'Residential';
         string useExistingproject='New';
        testLeadConvert.getAppItems();
        testLeadConvert.getnewaccount();
        //testLeadConvert.setnewaccount(olstAccount[0]);
        testLeadConvert.getnewcontact();
       // testLeadConvert.setnewcontact(olstContact[0]);
        testLeadConvert.getnewopportunity();
        testLeadConvert.setnewopportunity(olstOpportunity[0]);
        testLeadConvert.getaccounttype();
        testLeadConvert.getPros();
        
        Account acc = testLeadConvert.existAccount;
        testLeadConvert.getnewtask();
        testLeadConvert.getprojects();
        //testLeadConvert.setprojects('pro');
        testLeadConvert.getAppItems();
        testLeadConvert.getApplications();
        testLeadConvert.setnewtask(testTask);
        //testLeadConvert.setaccounttype('test');
        testLeadConvert.setprojects('new');
        testLeadConvert.sAppIndus = '--None--';
        testLeadConvert.sApplication='--None--';
        testLeadConvert.getprojects();
        boolean test = testLeadConvert.validateFields();
        testLeadConvert.continueWithProject();
         testLeadConvert.setaccounttype('new');
         testLeadConvert.getaccounttype();
        testLeadConvert.setprojects('new');
        testLeadConvert.getprojects();
        testLeadConvert.CreateObjects();
        testLeadConvert.sAppIndus = 'Sports';
        //testLeadConvert.CreateObjects();
        testLeadConvert.onProjectCheck();
        testLeadConvert.updateAddressNew();
        testLeadConvert.getduplicateopps();
        
    }
     static testMethod void myUnitTest5() {
        
        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;
        olstAccount = TestDataUtility.createAccountTestData();
        olstAccount[0].Competitor__c = true ;
        insert olstAccount ;
        
        Task testTask = new Task(Subject  = 'Other' , priority = 'Normal' , Status = 'Not Started');
        insert testTask;
        
        olstContact = TestDataUtility.createConTestData();
        olstContact[0].AccountId = olstAccount[0].Id ;
        insert olstContact ;
        
        olstOpportunity = TestDataUtility.createOppTestData();
        olstOpportunity[0].AccountId = olstAccount[0].Id ;
        insert olstOpportunity ;
        
        olstProject = TestDataUtility.createProjectTestData();
        insert olstProject;
  
        List<Apexpages.Message> msgs = ApexPages.getMessages();
            for(ApexPages.Message msg :  ApexPages.getMessages()) { 
                System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
            }

        SinglePageLeadConvertController testLeadConvert = new SinglePageLeadConvertController();
        testLeadConvert.selectedType = 'Commercial';
        testLeadConvert.setaccounttype('existing');
        testLeadConvert.getItems();
        testLeadConvert.getrecType();
        testLeadConvert.getAppItems();
                 
        
        testLeadConvert.selectedType = 'Residential';
         string useExistingproject='New';
        testLeadConvert.getAppItems();
        testLeadConvert.getnewaccount();
        testLeadConvert.setnewaccount(olstAccount[0]);
        testLeadConvert.getnewcontact();
        testLeadConvert.setnewcontact(olstContact[0]);
        testLeadConvert.getnewopportunity();
        testLeadConvert.setnewopportunity(olstOpportunity[0]);
        testLeadConvert.getaccounttype();
        testLeadConvert.getPros();
        
        Account acc = testLeadConvert.existAccount;
        testLeadConvert.getnewtask();
        testLeadConvert.getprojects();
        testLeadConvert.setprojects('new');
        testLeadConvert.getApplications();
        testLeadConvert.setnewtask(testTask);
        testLeadConvert.setaccounttype('new');
        
        boolean test = testLeadConvert.validateFields();
        testLeadConvert.continueWithProject();
        testLeadConvert.CreateObjects();
        testLeadConvert.sAppIndus = 'Sports';
        testLeadConvert.CreateObjects();
        testLeadConvert.onProjectCheck();
        testLeadConvert.updateAddressNew();
        testLeadConvert.getduplicateopps();
        
    }*/
   
}