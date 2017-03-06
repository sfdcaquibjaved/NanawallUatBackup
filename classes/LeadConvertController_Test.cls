/*************************************************************************
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : August-2016
    @ Description   : This class serves the pupose of code coverage of LeadConvertController class
    @ Audit Trial   : 
    @ Last Modified Date :
  
****************************************************************************/
@isTest(SeeAllData = false)

public class LeadConvertController_Test {
    public static list < Zip_Codes_Master__c > territorymaster;
     public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Lead > LeadList;
    public static list <Project__c> ProjectList ; 
    public static list < Account > accounts;
     public static list < Contact > contacts;
 
   
    static testMethod void unitTest() {
        
        //Creating test data for Territory Master
        territorymaster = TestDataUtility.getTerritoryMaster();
        try {
            insert territorymaster;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        
        
        //Creating test data for countries
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
        accounts = TestDataUtility.createAccountTestData();
        try {
            insert accounts;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
        
        //Creating Contacts test data by using utility class
        contacts = TestDataUtility.createConTestData();
        contacts[0].Accountid = Accounts[0].id;
        contacts[0].Email = 'testUserName@gmail.com';
        try {
            insert contacts;
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }
    
        
        // Creating Test data for lead 
        LeadList = TestDataUtility.createLeadTestData() ; 
        insert Leadlist ; 
        
              
        
        
		//Creating Test data for Project 
		ProjectList = TestDataUtility.createProjectTestData();
        insert ProjectList ; 
        
        //Creating Test Data for Opportunity
		List<Opportunity> opps = new List<Opportunity>();
            
                opps.add(new Opportunity(Name='Test Name',
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=accounts[0].Id));
        insert opps ; 
        
        
        //Test Data for task 
       
        List<Task> tasks = new List<Task>();
           tasks.add(new Task(
                     ActivityDate = Date.today().addDays(7),
                     Subject='Sample Task',
                     WhatId = accounts[0].Id,
                     OwnerId = UserInfo.getUserId(),
                     Status='In Progress'));

					insert tasks;
        
        
        
        string projectid = ProjectList[0].id ; 
        string subject ='Test Subject';
        string AccountId = accounts[0].id ; 
        string OppName ='Test Name' ; 
        string opportunityid = opps[0].id ; 
        string AccName = 'new' ;
       string contactid = contacts[0].id ;
        string projcity = 'Washington';
        string projstate = 'California';
        string projapp = 'Residential';
        string projzip = '12345';
                    
        ApexPages.StandardController sc = new ApexPages.standardController(LeadList[0]);
        LeadConvertController LCC = new LeadConvertController(sc);
        LCC.ToggleAccountType();
        LCC.getCreateTask();
        LCC.getdupeprojectid();
        LCC.setdupeprojectid(ProjectId);
        LCC.getConvertedContactID() ; 
        LCC.getConvertedContactName() ; 
        LCC.getshowalreadyconvertedblock();
        LCC.getShowBackButton();
        LCC.getshowdupeblock() ; 
        LCC.getnewopportunity() ; 
        LCC.setCreateTask(True);
        LCC.getTask();
        LCC.setnewopportunity(opps[0]);
        LCC.setTask(tasks[0]);
        LCC.getTaskSubject();
        LCC.setTaskSubject(subject);
        LCC.getCreateNewOpp();
        LCC.setCreateNewOpp(true);
        LCC.getAccountID();
        LCC.setAccountID(AccountId);
        LCC.getContactLookup() ;
        LCC.getNewOppName();
        LCC.setNewOppName(OppName);
        LCC.getNewAccName() ; 
        LCC.setNewAccName(AccName) ;
        LCC.getUseExistingAccount() ;
        LCC.setUseExistingAccount(AccName) ; 
        LCC.getduplicateOpps() ;
       // LCC.addtoexistingproject() ; 
        LCC.CheckDupes() ; 
        LCC.getAccountOptions() ;
        LCC.PreConvertLead() ;
        LCC.checkConvertAction() ;
       // LCC.ConvertLead(AccountId);
        LCC.BackTolead() ;
      // LCC.HandlePostConversion(opportunityid , contactid , accountid , projcity , projstate , projapp , projzip) ;
        
        
        
    }
    

}