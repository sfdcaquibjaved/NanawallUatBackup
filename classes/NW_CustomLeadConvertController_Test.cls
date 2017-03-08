/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Test class which tests  NW_CustomLeadConvertController - Apex Trigger
                                        
*
* @ Audit Trial   : Repeating block for each change to the code
**/

@isTest(SeeAllData=false)

private class NW_CustomLeadConvertController_Test {
    
    public static List<Account> olstTestAccount;
    public static List<Lead> olstTestLead;
    public static List<Project__c> olstProject ;
    public static List<Contact> olstContact ;
    public static List<Zip_Codes_Master__c> olstTerritoryMastereCode;
   
  //  public static List<Opportunity> olstOpportunity;
    static testMethod void testLeadConversion()
    {
     olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 
    
    olstTestAccount = TestDataUtility.createAccountTestData();
    insert olstTestAccount ;
    
    olstProject = TestDataUtility.createProjectTestData();
    insert olstProject[0] ;
    
    olstContact = TestDataUtility.createConTestData();
    insert olstContact ;
    
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].Company = olstTestAccount[0].Name ;
    //olstTestLead[1].Company = olstTestAccount[1].Name ;
   // olstTestLead[2].Company = olstTestAccount[2].Name ;
    //olstTestLead[3].Company = olstTestAccount[3].Name ;
    //olstTestLead[4].Company = olstTestAccount[4].Name ;
    insert olstTestLead[0] ;
    
    
    
    Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount[0].Id ;
    nCustom.convertLead();
    nCustom.cancel();
    String Teststr = nCustom.selectedOpportunityPicklist ;
    LeadStatus lStatus = nCustom.ldStatus ;
    //Contact con = nCustom.person ;
    Opportunity opp = nCustom.project ; 
    Test.stopTest();
 }
 
 static testMethod void testLeadConversionWithoutOpportunity()
    {
     
       olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 

        
    olstTestAccount = TestDataUtility.createAccountTestData();
    insert olstTestAccount ;
    
    olstProject = TestDataUtility.createProjectTestData();
    insert olstProject[0] ;
    
    olstContact = TestDataUtility.createConTestData();
    insert olstContact ;
    
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].Company = olstTestAccount[0].Name ;
    //olstTestLead[1].Company = olstTestAccount[1].Name ;
    //olstTestLead[2].Company = olstTestAccount[2].Name ;
    //olstTestLead[3].Company = olstTestAccount[3].Name ;
    //olstTestLead[4].Company = olstTestAccount[4].Name ;
    insert olstTestLead[0] ;
    
    Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.projCheck = true;
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount[0].Id ;
    nCustom.selectedProject=olstProject[0].Name;  
    nCustom.convertLead();
    nCustom.cancel();
    Test.stopTest();
 }
 
 static testMethod void testLeadConversionWithoutAccount(){
    
     olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 

    olstTestLead = TestDataUtility.createLeadTestData();
    insert olstTestLead ;
    
    olstContact = TestDataUtility.createConTestData();
    insert olstContact ;
    
    Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    ncustom.validateFields();
    nCustom.addingNewAccount();
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.convertLead();
    nCustom.cancel();
    Test.stopTest();
    
 }
 
 static testMethod void testLeadConversionWithoutProject(){
    
     olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 

   
     olstTestLead = TestDataUtility.createLeadTestData();
    insert olstTestLead ;
    
     olstContact = TestDataUtility.createConTestData();
    insert olstContact ;
    
    Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.addingNewAccount();
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.convertLead();
    nCustom.cancel();
    Test.stopTest();
    
 }
 
 static testMethod void testLeadConversionWithOpportunity()
 {
     olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 

    
     list<account> olstTestAccount2 = new list<account>();
     for(integer i=0; i<10; i++)
     {
     Account a = new Account();
        a.Name = 'Test Account' + i;
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type='Competitor Firm';
        olstTestAccount2.add(a);
     }
     insert olstTestAccount2;
     
     list<contact> clist = new list<contact>();
     for (Integer i= 0 ; i < 10; i++){
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo' + i;
        con.LastName = 'bar' + i;
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
         con.accountid=olstTestAccount2[0].id;
        clist.add(con); 
     } insert clist;
     
    
    list<lead> olstTestLead2 = new list<lead>();
    for(integer i=0; i<10; i++)
    {
     Lead l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst' + i;
        l.LastName = 'testlast';
        l.PostalCode = '08619';
        l.CountryCode = 'US';
        l.Type_of_record__c = 'Commercial';
        l.project_name__c = 'Test Proj1';
        l.Project_Application_Industry__c = 'Automotive';
        l.Project_Application__c = 'Dealership';
        l.Project_Site_Zip_Code__c= '94040';
       olstTestLead2.add(l);
       }
       insert olstTestLead2;
    olstTestLead2[0].Company = olstTestAccount2[0].Name ;     
    olstTestLead2[1].Company = olstTestAccount2[1].Name ;
    olstTestLead2[2].Company = olstTestAccount2[2].Name ;
    olstTestLead2[3].Company = olstTestAccount2[3].Name ;
    olstTestLead2[4].Company = olstTestAccount2[4].Name ;
    update olstTestLead2;
    
    
    list<project__c> olstProject2 = new list<Project__c>();
     project__c p = new project__c();
     p.Name='Test Proj1';
     p.Application__c='Automotive';
     p.Application_2__c='Dealership';
     p.Project_Zip_Code__c='94040';
    p.RecordTypeId= Schema.SObjectType.project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
  olstProject2.add(p);
     insert olstProject2;
     
           Campaign c = new Campaign();
           c.Name='Test';
           c.Status='Planned';
           c.Type=' Advertisement';
           c.IsActive=TRUE;
           insert c;
           
        
         
         Default_User_Campaigns__c duc = new Default_User_Campaigns__c();
         duc.Member_Status__c='Responded';
         duc.Name='MarketingNana';
         duc.Campaign_Id__c=c.id;
         duc.User_Role__c='MarketingNana';
         duc.Contact_Role_Label__c='other';
         duc.Search_Timeframe__c=14;
         
         
         insert duc;
         
         
         list<CampaignMember> cmp = new list<CampaignMember>();
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=duc.Campaign_Id__c;
                campign.ContactId=clist[0].Id;
                campign.Status=duc.Member_Status__c;
               // campign.FCRM__FCR_Opportunity__c=olstOpportunity[0].Id;
                //campign.FCRM__FCR_Admin_Response_Control__c=8; 
                cmp.add(campign);
                insert cmp;
                //cmp[0].FCRM__FCR_Opportunity__c=olstOpportunity[0].id;
                cmp[0].FCRM__FCR_Admin_Response_Control__c=8;
                update cmp;
         
     Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead2[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount2[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject2[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount2[0].Id ;
    nCustom.projCheck=false;
    nCustom.selectedProject=olstProject2[0].id;
    nCustom.convertLead();
    nCustom.cancel();
    String Teststr = nCustom.selectedOpportunityPicklist ;
    LeadStatus lStatus = nCustom.ldStatus ;
    //Contact con = nCustom.person ;
    Opportunity opp = nCustom.project ; 
    Test.stopTest();
 }     
    
    static testMethod void unitest()
 {
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 

     list<account> olstTestAccount2 = new list<account>();
     for(integer i=0; i<10; i++)
     {
     Account a = new Account();
        a.Name = 'Test Account' + i;
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type='Competitor Firm';
        olstTestAccount2.add(a);
     }
     insert olstTestAccount2;
     
     list<contact> clist = new list<contact>();
     for (Integer i= 0 ; i < 10; i++){
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo' + i;
        con.LastName = 'bar' + i;
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
          con.accountid=olstTestAccount2[0].id;
        clist.add(con); 
     } insert clist;
     
    
    olstTestLead = TestDataUtility.createLeadTestData();
    
    olstTestLead[0].Company = olstTestAccount2[0].Name ;
     
    olstTestLead[1].Company = olstTestAccount2[1].Name ;
     
    olstTestLead[2].Company = olstTestAccount2[2].Name ;
    
    olstTestLead[3].Company = olstTestAccount2[3].Name ;
     
    olstTestLead[4].Company = olstTestAccount2[4].Name ;
    insert olstTestLead ;
    Test.startTest();
    list<project__c> olstProject2 = new list<Project__c>();
     project__c p = new project__c();
     p.Name='Test Proj';
     p.Application__c='Automotive';
     p.Application_2__c='Dealership';
     p.Project_Zip_Code__c='08619';
    p.RecordTypeId= Schema.SObjectType.project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
 
     project__c p2 = new project__c();
     p2.Name='Test Project';
     p2.Application__c='Automotive';
     p2.Application_2__c='Dealership';
     p2.Project_Zip_Code__c='08619';
     p2.RecordTypeId= Schema.SObjectType.project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
     olstProject2.add(p);
     olstProject2.add(p2);
     insert olstProject2;
    
      List<Opportunity> olstOpportunity = new  List<Opportunity>();
     Opportunity o = new Opportunity();
     o.Name='test Opp';
      o.StageName='Qualification';
     o.CloseDate=date.today();
     o.Country__c='USA';
     o.Project_Name__c=olstProject2[0].id;
     o.Accountid=olstTestAccount2[0].id;
     olstOpportunity.add(o);
     insert olstOpportunity;
     
      List<nrOpportunityContactRole__c> oppConRolelist = new List<nrOpportunityContactRole__c>();
         nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
         oppConRole.Contact__c = clist[0].Id ;
         oppConRole.Opportunity__c = olstOpportunity[0].Id ;
         oppConRolelist.add(oppConRole);
         insert oppConRolelist;
           
           Campaign c = new Campaign();
           c.Name='Test';
           c.Status='Planned';
           c.Type=' Advertisement';
           c.IsActive=TRUE;
           insert c;
           
        
         
         Default_User_Campaigns__c duc = new Default_User_Campaigns__c();
         duc.Member_Status__c='Responded';
         duc.Name='MarketingNana';
         duc.Campaign_Id__c=c.id;
         duc.User_Role__c='MarketingNana';
         duc.Contact_Role_Label__c='other';
         duc.Search_Timeframe__c=14;
         
         
         insert duc;
         
         
         list<CampaignMember> cmp = new list<CampaignMember>();
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=duc.Campaign_Id__c;
                //campign.ContactId=clist[0].Id;
                campign.Status=duc.Member_Status__c;
                campign.FCRM__FCR_Opportunity__c=olstOpportunity[0].Id;
                campign.FCRM__FCR_Admin_Response_Control__c=8; 
                
                insert cmp;
                
                
                
         
     
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount2[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject2[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount2[0].Id ;
    nCustom.selectedProject=olstProject2[1].id;
    nCustom.convertLead();
    nCustom.cancel();
    String Teststr = nCustom.selectedOpportunityPicklist ;
    LeadStatus lStatus = nCustom.ldStatus ;
    //Contact con = nCustom.person ;
    Opportunity opp = nCustom.project ; 
    Test.stopTest();
 }     
    
     static testMethod void unittest2()
 {
    olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 

     list<account> olstTestAccount2 = new list<account>();
     for(integer i=0; i<10; i++)
     {
     Account a = new Account();
        a.Name = 'Test Account' + i;
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        olstTestAccount2.add(a);
     }
     insert olstTestAccount2;
     
     list<contact> clist = new list<contact>();
     for (Integer i= 0 ; i < 10; i++){
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo' + i;
        con.LastName = 'bar' + i;
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
         con.accountid=olstTestAccount2[0].id;
        clist.add(con); 
     } insert clist;
     
    
    list<lead> olstTestLead2 = new list<lead>();
    for(integer i=0; i<10; i++)
    {
     Lead l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst' + i;
        l.LastName = 'testlast';
        l.PostalCode = '08619';
        l.CountryCode = 'US';
        l.Type__c='Other';
        l.Status='Not Engaged';
       
       olstTestLead2.add(l);
       }
       insert olstTestLead2;
    olstTestLead2[0].Company = olstTestAccount2[0].Name ;     
    olstTestLead2[1].Company = olstTestAccount2[1].Name ;
    olstTestLead2[2].Company = olstTestAccount2[2].Name ;
    olstTestLead2[3].Company = olstTestAccount2[3].Name ;
    olstTestLead2[4].Company = olstTestAccount2[4].Name ;
    update olstTestLead2;
    
    
    list<project__c> olstProject2 = new list<Project__c>();
     project__c p = new project__c();
     p.Name='Test Proj1';
     p.Application__c='Automotive';
     p.Application_2__c='Dealership';
     p.Project_Zip_Code__c='94040';
    p.RecordTypeId= Schema.SObjectType.project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
  olstProject2.add(p);
     insert olstProject2;
     
      List<Opportunity> olstOpportunity = new  List<Opportunity>();
     Opportunity o = new Opportunity();
     o.Name='test Opp';
      o.StageName='Qualification';
     o.CloseDate=date.today();
     o.Country__c='USA';
     o.Project_Name__c=olstProject2[0].id;
     o.Accountid=olstTestAccount2[0].id;
     olstOpportunity.add(o);
     insert olstOpportunity;
     
      List<nrOpportunityContactRole__c> oppConRolelist = new List<nrOpportunityContactRole__c>();
         nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
         oppConRole.Contact__c = clist[0].Id ;
         oppConRole.Opportunity__c = olstOpportunity[0].Id ;
         oppConRolelist.add(oppConRole);
         insert oppConRolelist;
           
           Campaign c = new Campaign();
           c.Name='Test';
           c.Status='Planned';
           c.Type=' Advertisement';
           c.IsActive=TRUE;
           insert c;
           
        
         
         Default_User_Campaigns__c duc = new Default_User_Campaigns__c();
         duc.Member_Status__c='Responded';
         duc.Name='MarketingNana';
         duc.Campaign_Id__c=c.id;
         duc.User_Role__c='MarketingNana';
         duc.Contact_Role_Label__c='other';
         duc.Search_Timeframe__c=14;
         
         
         insert duc;
         
         
         list<CampaignMember> cmp = new list<CampaignMember>();
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=duc.Campaign_Id__c;
                campign.ContactId=clist[0].Id;
                campign.Status=duc.Member_Status__c;
               // campign.FCRM__FCR_Opportunity__c=olstOpportunity[0].Id;
                //campign.FCRM__FCR_Admin_Response_Control__c=8; 
                cmp.add(campign);
                insert cmp;
                //cmp[0].FCRM__FCR_Opportunity__c=olstOpportunity[0].id;
                cmp[0].FCRM__FCR_Admin_Response_Control__c=8;
                update cmp;
         Test.startTest();
    
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead2[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount2[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject2[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount2[0].Id ;
    nCustom.projCheck=false;
    nCustom.selectedProject=olstProject2[0].id;
    nCustom.convertLead();
    nCustom.cancel();
    String Teststr = nCustom.selectedOpportunityPicklist ;
    LeadStatus lStatus = nCustom.ldStatus ;
    //Contact con = nCustom.person ;
    Opportunity opp = nCustom.project ; 
    Test.stopTest();
 }     
    
    static testMethod void unittest3()
 {
     
     olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 

      
    list<account> olstTestAccount2 = new list<account>();
     for(integer i=0; i<10; i++)
     {
     Account a = new Account();
        a.Name = 'Test Account' + i;
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type = 'Competitor Firm';
        olstTestAccount2.add(a);
     }
     insert olstTestAccount2;
     olstContact = TestDataUtility.createConTestData();
     olstContact[0].accountid=olstTestAccount2[0].id;
    insert olstContact ;
     /*list<contact> clist = new list<contact>();
     for (Integer i= 0 ; i < 10; i++){
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo' + i;
        con.LastName = 'bar' + i;
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '94941';
        con.MailingCountryCode = 'US';
         con.accountid=olstTestAccount2[0].id;
        clist.add(con); 
     } insert clist;*/
     
      Campaign c = new Campaign();
           c.Name='Test';
           c.Status='Planned';
           c.Type=' Advertisement';
           c.IsActive=TRUE;
           insert c;
    list<lead> olstTestLead2 = new list<lead>();
    for(integer i=0; i<10; i++)
    {
     Lead l = new Lead();
        l.Phone = '(123) 456-7890';
        l.FirstName = 'testfirst' + i;
        l.LastName = 'testlast';
        l.PostalCode = '12345';
        l.CountryCode = 'US';
        l.Type__c='Other';
        l.Status='Not Engaged';
        l.Type_of_record__c = 'Commercial';
        l.project_name__c = 'Test Proj1';
        l.Project_Application_Industry__c = 'Automotive';
        l.Project_Application__c = 'Dealership';
        l.Project_Site_Zip_Code__c= '12345';
       
       olstTestLead2.add(l);
       }
       insert olstTestLead2;
    olstTestLead2[0].Company = olstTestAccount2[0].Name ;     
    olstTestLead2[1].Company = olstTestAccount2[1].Name ;
    olstTestLead2[2].Company = olstTestAccount2[2].Name ;
    olstTestLead2[3].Company = olstTestAccount2[3].Name ;
    olstTestLead2[4].Company = olstTestAccount2[4].Name ;
     
         
    update olstTestLead2;
    
   
    list<project__c> olstProject2 = new list<Project__c>();
     project__c p = new project__c();
     p.Name='Test Proj1';
     p.Application__c='Automotive';
     p.Application_2__c='Dealership';
     p.Project_Zip_Code__c='08619';
    p.RecordTypeId= Schema.SObjectType.project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
  olstProject2.add(p);
     insert olstProject2;
     
      List<Opportunity> olstOpportunity = new  List<Opportunity>();
     Opportunity o = new Opportunity();
     o.Name='test Opp';
      o.StageName='Qualification';
     o.CloseDate=date.today();
     o.Country__c='USA';
     o.Project_Name__c=olstProject2[0].id;
     o.Accountid=olstTestAccount2[0].id;
    // o.OwnerId=olstTestAccount2[0].Ownerid;
     o.RecordTypeID=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial Opportunity').getRecordTypeId();
     olstOpportunity.add(o);
     insert olstOpportunity;
     
      List<nrOpportunityContactRole__c> oppConRolelist = new List<nrOpportunityContactRole__c>();
         nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
         oppConRole.Contact__c = olstContact[0].Id ;
         oppConRole.Opportunity__c = olstOpportunity[0].Id ;
         oppConRolelist.add(oppConRole);
         insert oppConRolelist;
           
         
           
              
         Default_User_Campaigns__c duc = new Default_User_Campaigns__c();
         duc.Member_Status__c='Responded';
         duc.Name='National Sales Manager';
         duc.Campaign_Id__c=c.id;
         duc.User_Role__c='National Sales Manager';
         duc.Contact_Role_Label__c='other';
         duc.Search_Timeframe__c=14;
         
         
         insert duc;
         
        /* olstTestLead2[0].CampaignId=c.id;
         update olstTestLead2;*/
         
         list<CampaignMember> cmp = new list<CampaignMember>();
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=duc.Campaign_Id__c;
                campign.ContactId=olstContact[0].Id;
                campign.Status=duc.Member_Status__c;
               // campign.FCRM__FCR_Opportunity__c=olstOpportunity[0].Id;
                //campign.FCRM__FCR_Admin_Response_Control__c=8; 
                cmp.add(campign);
                insert cmp;
               /* //cmp[0].FCRM__FCR_Opportunity__c=olstOpportunity[0].id;
                cmp[0].FCRM__FCR_Admin_Response_Control__c=8;
                update cmp;*/
         
     Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead2[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount2[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject2[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount2[0].Id ;
    nCustom.projCheck=false;
    nCustom.selectedProject=olstProject2[0].id;
    nCustom.convertLead();
    nCustom.cancel();
    String Teststr = nCustom.selectedOpportunityPicklist ;
    LeadStatus lStatus = nCustom.ldStatus ;
    //Contact con = nCustom.person ;
    Opportunity opp = nCustom.project ; 
    Test.stopTest();
 }     
 static testMethod void unittest4()
    {
       
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 

        user testuser = [select id, UserRole.Name from user where UserRole.Name='Administration Team' LIMIT 1];

    olstTestAccount = TestDataUtility.createAccountTestData();
    olstTestAccount[0].OwnerId=testuser.id;
        olstTestAccount[1].OwnerId=testuser.id;
        olstTestAccount[2].OwnerId=testuser.id;
        //olstTestAccount[3].OwnerId=testuser.id;
        //olstTestAccount[4].OwnerId=testuser.id;
    insert olstTestAccount ;
    
    olstProject = TestDataUtility.createProjectTestData();
    insert olstProject[0] ;
    
    /*olstContact = TestDataUtility.createConTestData();
        olstContact[0].accountId=olstTestAccount[0].id;
    insert olstContact ;*/
    list<contact> conlist=  new list<contact>();
         Contact con = new Contact();
      
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.AccountId=olstTestAccount[0].id;
        con.OwnerId=testuser.id;
        conlist.add(con); 
        insert conlist;
    
    list<opportunity> opplist = new list<opportunity>();
      opplist=TestDataUtility.createOppTestData();
        opplist[0].Accountid=olstTestAccount[0].id;
        opplist[0].Project_Name__c=olstProject[0].id;
        insert opplist;
        
         List<nrOpportunityContactRole__c> oppConRolelist = new List<nrOpportunityContactRole__c>();
       
       
         nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
         oppConRole.Contact__c = conlist[0].Id ;
         oppConRole.Opportunity__c = opplist[0].Id ;
         oppConRolelist.add(oppConRole);
        insert oppConrolelist;
        
        
        Test.startTest();
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].Company = olstTestAccount[0].Name ;
    //olstTestLead[1].Company = olstTestAccount[1].Name ;
    //olstTestLead[2].Company = olstTestAccount[2].Name ;
    //olstTestLead[3].Company = olstTestAccount[3].Name ;
    //olstTestLead[4].Company = olstTestAccount[4].Name ;
    insert olstTestLead[0] ;
        Campaign c = new Campaign();
           c.Name='Test';
           c.Status='Planned';
           c.Type=' Advertisement';
           c.IsActive=TRUE;
           insert c;
        Default_User_Campaigns__c duc = new Default_User_Campaigns__c();
         duc.Member_Status__c='Responded';
         duc.Name='Administration Team';
         duc.Campaign_Id__c=c.id;
         duc.User_Role__c='Administration Team';
         duc.Contact_Role_Label__c='other';
         duc.Search_Timeframe__c=14;        
         insert duc;
        list<CampaignMember> cmp = new list<CampaignMember>();
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=duc.Campaign_Id__c;
                campign.ContactId=conlist[0].Id;
                campign.Status=duc.Member_Status__c;
                campign.FCRM__FCR_Opportunity__c=opplist[0].Id;
                //campign.FCRM__FCR_Response_Date__c=Date.newInstance(2015, 10, 10);
                campign.FCRM__FCR_Admin_Response_Control__c=8; 
                cmp.add(campign);
                insert cmp;
    
    
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.projCheck = true;
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount[0].Id ;
    nCustom.selectedProject=olstProject[0].Name;  
    nCustom.convertLead();
    nCustom.cancel();
    Test.stopTest();
 }
    static testMethod void unittest5()
    {
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 

       
    olstTestAccount = TestDataUtility.createAccountTestData();
    insert olstTestAccount ;
    
    olstProject = TestDataUtility.createProjectTestData();
    insert olstProject[0] ;
    
    olstContact = TestDataUtility.createConTestData();
        olstContact[0].accountId=olstTestAccount[0].id;
    insert olstContact ;
    
    list<opportunity> opplist = new list<opportunity>();
      opplist=TestDataUtility.createOppTestData();
        opplist[0].Accountid=olstTestAccount[0].id;
        opplist[0].Project_Name__c=olstProject[0].id;
        insert opplist;
        
         List<nrOpportunityContactRole__c> oppConRolelist = new List<nrOpportunityContactRole__c>();
       
       
         nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
         oppConRole.Contact__c = olstContact[0].Id ;
         oppConRole.Opportunity__c = opplist[0].Id ;
         oppConRolelist.add(oppConRole);
        insert oppConrolelist;
        
        Test.startTest();
        
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].Company = olstTestAccount[0].Name ;
   // olstTestLead[1].Company = olstTestAccount[1].Name ;
    //olstTestLead[2].Company = olstTestAccount[2].Name ;
    //olstTestLead[3].Company = olstTestAccount[3].Name ;
    //olstTestLead[4].Company = olstTestAccount[4].Name ;
    insert olstTestLead[0] ;
        Campaign c = new Campaign();
           c.Name='Test';
           c.Status='Planned';
           c.Type=' Advertisement';
           c.IsActive=TRUE;
           insert c;
        Default_User_Campaigns__c duc = new Default_User_Campaigns__c();
         duc.Member_Status__c='Responded';
         duc.Name='National Sales Manager';
         duc.Campaign_Id__c=c.id;
         duc.User_Role__c='National Sales Manager';
         duc.Contact_Role_Label__c='other';
         duc.Search_Timeframe__c=14;        
         insert duc;
        list<CampaignMember> cmp = new list<CampaignMember>();
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=duc.Campaign_Id__c;
                campign.ContactId=olstContact[0].Id;
                campign.Status=duc.Member_Status__c;
                campign.FCRM__FCR_Opportunity__c=opplist[0].Id;
                campign.FCRM__FCR_Response_Date__c=Date.newInstance(2015, 10, 10);
                campign.FCRM__FCR_Admin_Response_Control__c=8; 
                cmp.add(campign);
                insert cmp;
    
    
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.projCheck = true;
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount[0].Id ;
    nCustom.selectedProject=olstProject[0].Name;  
    nCustom.convertLead();
    nCustom.cancel();
    Test.stopTest();
    }
    static testMethod void unittest6()
    {
          User testUser = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
          insert testUser;
          
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;

        
       // user testuser = [select id, UserRole.Name from user where UserRole.Name='Administration Team' LIMIT 1];

    olstTestAccount = TestDataUtility.createAccountTestData();
    olstTestAccount[0].OwnerId=testuser.id;
        olstTestAccount[1].OwnerId=testuser.id;
        //olstTestAccount[2].OwnerId=testuser.id;
        //olstTestAccount[3].OwnerId=testuser.id;
        //olstTestAccount[4].OwnerId=testuser.id;
    insert olstTestAccount ;
    
    olstProject = TestDataUtility.createProjectTestData();
    insert olstProject[0] ;
    
    /*olstContact = TestDataUtility.createConTestData();
        olstContact[0].accountId=olstTestAccount[0].id;
    insert olstContact ;*/
    list<contact> conlist=  new list<contact>();
         Contact con = new Contact();
      
        con.FirstName = 'foo';
        con.LastName = 'bar';
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.AccountId=olstTestAccount[0].id;
        con.OwnerId=testuser.id;
        conlist.add(con); 
        insert conlist;
    
    list<opportunity> opplist = new list<opportunity>();
      opplist=TestDataUtility.createOppTestData();
        opplist[0].Accountid=olstTestAccount[0].id;
        opplist[0].Project_Name__c=olstProject[0].id;
        insert opplist;
        
         List<nrOpportunityContactRole__c> oppConRolelist = new List<nrOpportunityContactRole__c>();
       
       
         nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
         oppConRole.Contact__c = conlist[0].Id ;
         oppConRole.Opportunity__c = opplist[0].Id ;
         oppConRolelist.add(oppConRole);
        insert oppConrolelist;
        
        Test.startTest();
        
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].Company = olstTestAccount[0].Name ;
   // olstTestLead[1].Company = olstTestAccount[1].Name ;
   // olstTestLead[2].Company = olstTestAccount[2].Name ;
   // olstTestLead[3].Company = olstTestAccount[3].Name ;
    //olstTestLead[4].Company = olstTestAccount[4].Name ;
    insert olstTestLead[0] ;
        Campaign c = new Campaign();
           c.Name='Test';
           c.Status='Planned';
           c.Type=' Advertisement';
           c.IsActive=TRUE;
           insert c;
        Default_User_Campaigns__c duc = new Default_User_Campaigns__c();
         duc.Member_Status__c='Responded';
         duc.Name='default';
         duc.Campaign_Id__c=c.id;
         duc.User_Role__c='default';
         duc.Contact_Role_Label__c='other';
         duc.Search_Timeframe__c=14;        
         insert duc;
        
        list<CampaignMember> cmp = new list<CampaignMember>();
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=duc.Campaign_Id__c;
                campign.ContactId=conlist[0].Id;
                campign.Status=duc.Member_Status__c;
                campign.FCRM__FCR_Opportunity__c=opplist[0].Id;
                //campign.FCRM__FCR_Response_Date__c=Date.newInstance(2015, 10, 10);
                campign.FCRM__FCR_Admin_Response_Control__c=8; 
                cmp.add(campign);
                insert cmp;
    
    
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.projCheck = true;
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount[0].Id ;
    nCustom.selectedProject=olstProject[0].Name;  
        
    nCustom.convertLead();
    nCustom.cancel();
    Test.stopTest();
 }
 
 
    static testMethod void unittest7()
    {
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
     insert olstTerritoryMastereCode ; 
    
    olstTestAccount = TestDataUtility.createAccountTestData();
    insert olstTestAccount ;
    
    olstProject = TestDataUtility.createProjectTestData();
    insert olstProject[0] ;
    
    olstContact = TestDataUtility.createConTestData();
        olstContact[0].MailingPostalCode='12345';
    insert olstContact ;
    
    olstTestLead = TestDataUtility.createLeadTestData();
    olstTestLead[0].Company = olstTestAccount[0].Name ;
    //olstTestLead[1].Company = olstTestAccount[1].Name ;
   // olstTestLead[2].Company = olstTestAccount[2].Name ;
    //olstTestLead[3].Company = olstTestAccount[3].Name ;
    //olstTestLead[4].Company = olstTestAccount[4].Name ;
    insert olstTestLead[0] ;
    
    
   /* list<opportunity> opplist = new list<opportunity>();
      opplist=TestDataUtility.createOppTestData();
        opplist[0].Accountid=olstTestAccount[0].id;
        opplist[0].Project_Name__c=olstProject[0].id;
        insert opplist;*/
    
    
        Campaign c = new Campaign();
           c.Name='Test';
           c.Status='Planned';
           c.Type=' Advertisement';
           c.IsActive=TRUE;
           insert c;
        Default_User_Campaigns__c duc = new Default_User_Campaigns__c();
         duc.Member_Status__c='Responded';
         duc.Name='National Sales Manager';
         duc.Campaign_Id__c=c.id;
         duc.User_Role__c='default';
         duc.Contact_Role_Label__c='other';
         duc.Search_Timeframe__c=14;        
         insert duc;
        
         Default_User_Campaigns__c duc2 = new Default_User_Campaigns__c();
         duc2.Member_Status__c='Responded';
         duc2.Name='National Sales Manager';
         duc2.Campaign_Id__c=c.id;
         duc2.User_Role__c='System Administrator';
         duc2.Contact_Role_Label__c='other';
         duc2.Search_Timeframe__c=14;        
         insert duc2;
        
        list<CampaignMember> cmp = new list<CampaignMember>();
                CampaignMember campign = new CampaignMember();
                campign.CampaignId=duc.Campaign_Id__c;
                campign.ContactId=olstContact[0].Id;
                campign.Status=duc.Member_Status__c;
                //campign.FCRM__FCR_Opportunity__c=opplist[0].Id;
                campign.FCRM__FCR_Response_Date__c=Date.newInstance(2015, 10, 10);
                campign.FCRM__FCR_Admin_Response_Control__c=8; 
                cmp.add(campign);
                insert cmp;
    
    
 Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(olstTestLead[0]);
    NW_CustomLeadConvertController nCustom = new NW_CustomLeadConvertController(controller);
    nCustom.autoSelectOpp();
    nCustom.getAccountsList();
    nCustom.getProjectList();
    nCustom.accountToBeIncluded = olstTestAccount[0].Name;
    nCustom.addingNewAccount();
    nCustom.projectToBeIncluded = olstProject[0].Name;
    nCustom.addingNewProject();
    nCustom.sendEmail = false;
    nCustom.tsk.Status = 'In Progress';
    nCustom.selectedAccount = olstTestAccount[0].Id ;
    nCustom.convertLead();
    nCustom.cancel();
    String Teststr = nCustom.selectedOpportunityPicklist ;
    LeadStatus lStatus = nCustom.ldStatus ;
    //Contact con = nCustom.person ;
    Opportunity opp = nCustom.project ; 
    Test.stopTest();
    }
}