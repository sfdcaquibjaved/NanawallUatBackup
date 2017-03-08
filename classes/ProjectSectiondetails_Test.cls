@isTest(SeeAllData = false)
public class ProjectSectiondetails_Test {

    public static list < Zip_Codes_Master__c > territorymaster;
    public static User testUser;
    public static list < Country_codes__c > countrys;
    public static list < state_codes__c > states;
    public static list < Account > accounts;
    public static list < Contact> contacts;

    public static testMethod void UnitTest1() {
            
           
        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;

        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;

        countrys = TestDataUtility.getTestCountryCodes();
        insert countrys;

        states = TestDataUtility.getTestStateCodes();
        insert states;

        /*list < Account > acc = new List < Account > ();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.Phone = '(123) 456-7890';
        ac.BillingCountryCode = 'US';
        ac.BillingPostalCode = '12345';
        ac.BillingStateCode = 'CA';
        ac.Zip__c = '12345';
        acc.add(ac);
        insert acc[0];

        Account ac1 = new Account();
        ac1.Name = 'Test Account1';
        ac1.Type = 'Architecture Firm';
        ac1.Phone = '(123) 456-7890';
        ac1.BillingCountryCode = 'US';
        ac1.BillingPostalCode = '12345';
        ac1.BillingStateCode = 'CA';
        ac1.Zip__c = '12345';
        acc.add(ac1);
        insert acc[1];

        Account ac2 = new Account();
        ac2.Name = 'Test Account1';
        ac2.Phone = '(123) 456-7890';
        ac2.BillingCountryCode = 'US';
        ac2.BillingPostalCode = '12345';
        ac2.BillingStateCode = 'CA';
        ac2.Zip__c = '12345';
        acc.add(ac2);
        insert acc[2];*/
     
 
       accounts = testDataUtility.createAccountTestData();
       insert accounts;
       
       contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       Contacts[1].Accountid=accounts[1].id;
       Contacts[2].Accountid=accounts[2].id;
       insert contacts;


       /* list < contact > con = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'Test';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        con.add(c);
        insert con[0];



        Contact c1 = new Contact();
        c1.Accountid = acc[1].id;
        c1.FirstName = 'Ram';
        c1.LastName = 'Test';
        c1.MailingStreet = 'street';
        c1.MailingCity = 'city';
        c1.Mailingstate = 'Utah';
        c1.MailingPostalCode = '12345';
        c1.MailingCountryCode = 'US';
        con.add(c1);
        insert con[1];

        Contact c2 = new Contact();
        c2.Accountid = acc[2].id;
        c2.FirstName = 'Ram';
        c2.LastName = 'Test';
        c2.MailingStreet = 'street';
        c2.MailingCity = 'city';
        c2.Mailingstate = 'Utah';
        c2.MailingPostalCode = '12345';
        c2.MailingCountryCode = 'US';
        con.add(c2);
        insert con[2];*/

 Test.startTest();

        list < Project__c > Pro = new list < Project__c > ();
        Project__c proj = new Project__c();
        proj.Name = 'Test ProjectSectiondetails';
        proj.OwnerId = testUser.id;
        proj.RecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        proj.Application__c = 'Automotive';
        proj.Application_2__c = 'Other';
        proj.Project_City__c = 'city';
        proj.Project_Country__c = 'United States';
        proj.Project_State__c = 'Indiana';
        proj.Project_Street_Address__c = 'street address';
        proj.Project_Zip_Code__c = '12345';
        proj.TerritoryName__c = 'territory';
        proj.Purchaser_Account__c = accounts[0].id;
        proj.Purchaser_Contact__c = contacts[0].id;
        proj.Other_Influencer_Account__c = accounts[1].id;
        proj.Other_Influencer_Contact__c = contacts[1].id;
        proj.Architect_Account__c = accounts[2].id;
        proj.Architect_Contact__c = contacts[2].id;
        proj.Brand_Name_Account__c = accounts[2].id;
        proj.Brand_Name_Contact__c = contacts[2].id;
        proj.End_Customer_Account__c = accounts[2].id;
        proj.End_Customer_Contact__c = contacts[2].id;
        proj.Franchise_Account__c = accounts[2].id;
        proj.Franchise_Contact__c = contacts[2].id;
        proj.Franchisor_Account__c = accounts[2].id;
        proj.Franchisor_Contact__c = contacts[2].id;
        proj.Interior_Application__c = 'Interior_Application__c';
        proj.Corporate_Account__c = true;
        proj.Residential_Vertical__c = true;
        proj.Chain_Project_Type__c = 'Standard';
        proj.Budget_Quote_Provided__c = true;
        proj.Web_Project__c = true;
        proj.Public_Spec_d_Job__c = true;
        proj.Publicly_Specified_Jobs__c = 'Nana only';
        proj.Installer_Email_Viewed__c = true;
        proj.Ordering_Account__c = accounts[0].id;
        proj.Purchasing_Method__c = 'Glass House';
        proj.Preliminary_Drawings__c = true;
        proj.Preliminary_Drawings_Date__c = date.today();
        proj.Award_Date__c = date.today();
        proj.Bid_Date__c = date.today();
        proj.Close_Date__c = Date.newInstance(2016, 12, 12);
        proj.Estimated_Project_Need_Date__c = date.today();
        proj.Expected_Install_Date__c = date.today();
        proj.Expected_Open_Date__c = date.today();
        proj.Actual_Project_Need_Date__c = date.today();
        proj.Amount__c = 10;
        proj.Stage__c ='Quoted';
       // proj.Reason_Project_Lost__c ='See Notes'; 
        // proj.IsDeleted=false;
        proj.Architect_Considered__c = true;
       

        Pro.add(proj);
        
        try {
            insert Pro[0];
        } catch (Exception e) {}
        
        //pro[0].Stage__c = 'Closed Lost - Project Lost';
        //pro[0].Reason_Project_Lost__c ='See Notes';
        //Pro.add(proj);
       // update pro[0];
        
        List < Note > notelist = new List < Note > ();
        Note note = new Note();
        note.ParentId = Pro[0].id;
        note.Title = 'Test';
        note.Body = 'testing';
        insert note;
        //test.startTest();

        List < Attachment > atchlst = new List < Attachment > ();
        Attachment at = new Attachment();
        at.Name = 'test';
        at.ParentId = Pro[0].id;
        at.Body = Blob.valueOf('Unit Test Attachment Body');
        atchlst.add(at);
        insert atchlst[0];


        List < Opportunity > oppList = new list < Opportunity > ();
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = accounts[1].id;
        opp.Amount = 1000;
        //opp.Probability = 20;
        opp.Project_Name__c = Pro[0].id;
        //opp.Stage_Detail__c = 'Considered';
        //opp.ForecastCategoryName = 'Pipeline';
        opp.Expected_Resolution_Date_2__c = system.today();
        opp.StageName = 'Closed/Lost';
        //opp.Application_Industry__c='test';
        //opp.Application_Sub_Industry__c='test1';
        //opp.Award_Date__c = date.today();
        //opp.Bid_Date__c = date.today();
        //opp.Budget_Quote__c = true;
        //opp.Discounts__c = 5.00;
        //opp.Primary_Opportunity__c = true;
        //opp.Close_Date__c=system.today()+10;
        opp.CloseDate = Date.today() + 10;
        //opp.OwnerId = testUser.id;
        //opp.RecordTypeId = Label.Influencer_Opportunity_RecordTypeId;
        oppList.add(opp);
        
        insert oppList;
        

        List < nrOpportunityContactRole__c > nrlist = new List < nrOpportunityContactRole__c > ();

        nrOpportunityContactRole__c nropp = new nrOpportunityContactRole__c();
        nropp.Contact__c = contacts[1].id;
        nropp.Opportunity__c = oppList[0].id;
        nrlist.add(nropp);

        insert nrlist[0];


        

        list < Quote__c > qList = new list < Quote__c > ();
        Quote__c qt = new Quote__c();
        qt.Name = 'test quote';
        //qt.Average_Quote_Discount__c = 15.23;
        qt.Project__c = pro[0].id;
        /*qt.AACO__c = true;
        qt.Actual_Delivery_Date__c = date.today();
        qt.Actual_Pickup_Date__c = date.today();
        qt.Address__c = 'abc';
        
        qt.Balanced_Received_Date__c = date.today();
        qt.Balance_Received__c = 20.66;
        qt.CAD_Opened__c = system.now();
        qt.CAD_Sent__c = system.now();
        qt.CAD_Viewed__c = false;
        qt.Canadian_Tax_Status__c = 'Company';
        qt.Cancelled__c = true;
        qt.City__c = 'abc';
        qt.Commission_Showroom__c = show.id;
        qt.Complete_Signoff_Date__c = date.today();
        qt.Contact__c = con[0].Id;
        qt.Showroom__c = con[0].id;
        qt.VisitedShowroom__c = con[0].id;
        qt.Controlling_Account__c = acc[0].id;
        qt.Country__c = 'india';
        qt.Custom__c = true;
        qt.Custom_Drawing__c = true;
        qt.Deposit_Amount__c = 5;
        qt.Deposit_Date__c = date.today();
        qt.DocuSign_Status__c = ds.id;
        qt.Deposit_Received_Date__c = date.today();
        qt.Drawing_Deposit_Amount__c = 20;
        qt.Drawing_Deposit__c = date.today();
        qt.Drawing_Deposit_Amount__c = 20;
        qt.Drawing_Deposit__c = date.today();
        qt.Drawing_Thirty_Percent_Deposit_Amount__c = 30;
        qt.Drawing_Additional_Payment_Received__c = date.today();
        qt.Drawing_Approved_Contract__c = date.today();
        qt.Drawing_As_Built_Drawings_Supplied__c = date.today();
        qt.Drawing_Author__c = 'abc';
        qt.Drawing_CAD_Files_Sent_To_Germany__c = date.today();
        qt.Drawing_Complete__c = date.today();
        qt.Drawing_Copy_Sent_To_Rep__c = date.today();
        qt.Drawing_Cost_Discrepancy_Summary_Sent__c = date.today();
        qt.Drawing_Customer_Drawings_Received__c = date.today();
        qt.Drawing_Customer_Issues_Resolved__c = date.today();
        qt.Drawing_Eng_Implemented_Corrections__c = date.today();
        qt.Drawing_Eng_Clarification_Contact__c = date.today();
        qt.Drawing_Engineering_Fee_Received__c = date.today();
        qt.Drawing_Engineering_Technical_Meeting__c = date.today();
        qt.Drawing_ETA__c = date.today();
        qt.Drawing_Final_Signoff__c = date.today();
        qt.Drawing_Final_Order_Confirmation__c = date.today();
        qt.Drawing_Final_Documents_Sent__c = date.today();
        qt.Drawing_First_Submittal_Order_Sent__c = date.today();
        qt.Drawing_Followup_Letter_Sent__c = date.today();
        qt.Drawing_Initial_Deposit_Description__c = '50% only';
        qt.Drawing_Internal_Approval__c = date.today();
        qt.Drawing_Late_Approval_Rep_Notification__c = date.today();
        qt.Drawing_Nana_Reps_Updated__c = date.today();
        qt.Drawing_Notes__c = 'test drawing';
        qt.Drawing_On_Hold_Till_Date__c = date.today();
        qt.Drawing_Order_Released_For_Production__c = date.today();
        qt.Drawing_PDFs_Put_In_Project_File__c = date.today();
        qt.Drawing_Pipeline_Category_Name_2__c = 'abc';
        qt.Drawing_PIpeline_Status_2__c = 'def';
        qt.Drawing_Order_Confirmation_Signoff__c = date.today();
        qt.Drawing_Price__c = 10;
        qt.Drawing_Project_Start_Date__c = date.today();
        qt.Drawing_Requirements_Sent__c = date.today();
        qt.Drawing_Review_Drawings__c = date.today();
        qt.Drawing_Revision_1_Date__c = date.today();
        qt.Drawing_Revision_2_Date__c = date.today();
        qt.Drawing_Revision_3_Date__c = date.today();
        qt.Drawing_Revision_4_Date__c = date.today();
        qt.Drawing_Revision_5_Date__c = date.today();
        qt.Drawing_Revision_6_Date__c = date.today();
        qt.Drawing_Revision_7_Date__c = date.today();
        qt.Drawing_Revision_8_Date__c = date.today();
        qt.Drawing_Revision_Charge_Applied__c = date.today();
        qt.Drawing_Revision_Reason__c = 'abc';
        qt.Drawing_Revision_Received__c = date.today();
        qt.Drawing_Revision_Submitted__c = date.today();
        qt.Drawings__c = 'Standard';
        qt.Drawing_Samples_Received__c = date.today();
        qt.Drawing_Samples_Sent__c = date.today();
        qt.Drawing_Supervisor_One_Checked_Drawings__c = date.today();
        qt.Drawing_Supervisor_Two_Checked_Drawings__c = date.today();
        qt.Drawing_Tracking_Number_Sent_To_Rep__c = date.today();
        qt.Drawing_Version_Number__c = 10;
        qt.ELQ_Send_ETA_Letter__c = true;
        qt.ELQ_Send_Revised_ETA_Letter__c = true;
        qt.Print_Date__c = system.now();
        qt.Email_sent_to_Service_Department__c = date.today();
        qt.Estimated_Pickup_Date__c = date.today();
        qt.ETA_Jobsite__c = date.today();
        qt.ETA_Letter_Sent__c = true;
        qt.ETA_Letter_Sent_Date__c = date.today();
        qt.Expedited_Shipping__c = true;
        qt.Extended_Warranty__c = true;
        qt.Factory_Completion_Date__c = date.today();
        qt.Final_Confirmation_Date__c = date.today();
        qt.Final_Invoice_Amount__c = 20;
        qt.First_threshold__c = false;
        qt.Followup__c = false;
        qt.Followup_Status__c = 'Reviewing';
        qt.Freight_ETA_Jobsite__c = date.today();
        qt.Freight_ETA_Toggle__c = false;
        qt.Freight_Lookup__c = 20;
        qt.Freight__c = 30;
        qt.Freight_Tracking_Number__c = 'test123';
        qt.Glass_Size_Sent__c = date.today();
        qt.Hard_Copy_Date__c = system.now();
        qt.Hardware_Actual_Jobsite__c = date.today();
        qt.Hardware_Email_Details__c = 'abc';
        qt.Hardware_Email_Sent__c = date.today();
        qt.Hardware_ETA_Jobsite__c = date.today();
        qt.Hardware_Ship_Date__c = date.today();
        qt.Hardware_Tracking_Number__c = 'test';
        qt.Incomplete_Order_Confirmation_Notes__c = 'test notes';
        qt.Incomplete_Order_Confirmation_Paperwork__c = false;
        qt.Install_Confirmed__c = false;
        qt.Install_Date__c = date.today();
        qt.Installer__c = acc[0].id;
        qt.Installer_Email_Viewed__c = false;
        qt.Installer_Notes__c = 'abc';
        qt.Invoices_Sent_Date__c = date.today();
        qt.Is_Local__c = false;
        qt.Keyed_Alike__c = false;
        qt.Nana_Added_By__c = 'abc';
        qt.Nana_Create_Date__c = date.today();
        qt.Nana_Edit_Date__c = date.today();
        qt.NanaPDFID__c = 123456789;
        qt.On_Hold__c = false;
        qt.Order_Acknowledged_Date__c = date.today();
        qt.Order_Acknowledgement_2_Needed__c = false;
        qt.Order_Confirmation_Opened__c = system.now();
        qt.Order_Confirmation_Sent__c = system.now();
        qt.Order_Confirmation_Started__c = date.today();
        qt.Ordered__c = false;
        qt.Order_Finalized_Date__c = date.today();
        qt.Order_Notes__c = 'test 13';
        qt.Order_Number__c = 123;
        qt.Packaging__c = 30;
        qt.PDF_URL__c = 'test pdf';
        qt.Pipeline_Notes__c = 'pipeline';
        qt.PO_Number__c = 'po num';
        qt.Preview_Order__c = 'preview';
        qt.Primary_Quote__c = true;
        qt.Printed__c = true;
        
        qt.Project_Coordinator__c = testUser.id;
        qt.QNO_Follow_Up__c = false;
        qt.Discount__c = 10;
        qt.Quote_ID__c = 10;
        qt.Quote_Notes__c = 'test quote notes';
        qt.Record_Type__c = 'Purchase';
        qt.Revised_ETA_Jobsite__c = date.today();
        qt.Revised_ETA_Jobsite_Reason__c = 'not intrested';
        qt.Revised_ETA_Toggle__c = true;
        qt.Screen_Actual_Jobsite__c = date.today();
        qt.Screen_Actual_Mill_Valley__c = date.today();
        qt.Screen_ETA_Jobsite__c = date.today();
        qt.Screen_ETA_Mill_Valley__c = date.today();
        qt.Screen_Notes__c = 'abc';
        qt.Screen_Order_Placed__c = date.today();
        qt.Screen_Ship_from_Mill_Valley__c = date.today();
        qt.Screen_Supplier__c = 'Frehe';
        qt.Screen_Tracking_Number__c = 'qwd';
        qt.Sealy_Sent__c = false;
        qt.Send_Tax_Certificate__c = false;
        qt.Shipping_Company__c = 'test data';
        qt.Shipping_Max__c = 456;
        qt.Shipping_Min__c = 12;
        qt.Shipping_Name__c = '123';
        qt.Shipping_Phone__c = '456';
        qt.SL_Order_Number__c = '789';
        
        qt.State__c = 'ap';
        qt.Taha_Review__c = false;
        qt.Take_Off_Provided__c = false;
        qt.Taxable__c = false;
        qt.TaxRate__c = 12;
        qt.Tax_Total__c = 23;
        qt.Technical_Supervisor__c = testUser.id;
        qt.Total__c = 50;
        qt.Training_Actual__c = date.today();
        qt.Training_ETA__c = date.today();
        qt.Unglazed_Override__c = false;
        qt.Unique_Models__c = 'HSW 50';
        qt.Use_Controlling_Account__c = false;
        qt.Van_Ness_Commission__c = true;
        qt.Viewed__c = true;
        qt.Web_Quote__c = true;
        qt.Work_Order_Received__c = date.today();
        qt.Work_Order_Sent__c = date.today();
        qt.Zip__c = '12345';*/
        //qt.SubTotal__c=10;
        qt.Opportunity__c = oppList[0].id;
        qt.Stage__c = 'Open';
        qList.add(qt);
          
        insert qList;
        
        
        
        PageReference pageRef = Page.ProjectSelectSectionDetails;
            Test.setCurrentPageReference(pageRef);
            System.currentPageReference().getParameters().put('projectId', Pro[0].id);
            ApexPages.StandardController sc = new ApexPages.StandardController(Pro[0]);
        ProjectSectiondetails projsecdetails = new ProjectSectiondetails();
            System.currentPageReference().getParameters().put('projectId', Pro[0].id);
        
        //projsecdetails.box1 =true;
        projsecdetails.allSelected = true;
        //projsecdetails.nttproji nt = projsecdetails.nttproji(note);
        projsecdetails.notesAttachList[0].isSelected2 = true;
        projsecdetails.notesAttachList[1].isSelected2 = true;
        
        projsecdetails.selectAll();
        
        projsecdetails.Next();
        projsecdetails.goBack();
        projsecdetails.Next();
        //ProjectSectiondetails.Oproji psd = new ProjectSectiondetails.Oproji(oppList[0]);
        //projsecdetails.oppList[0].isSelected1 = true;
       // Test.startTest();
        projsecdetails.selected();
       //Test.stopTest();
        projsecdetails.validate();
        Test.stopTest();
        
        
        
    }
    public static testMethod void UnitTest2() {

        territorymaster = TestDataUtility.getTerritoryMaster();
        insert territorymaster;

        testUser = TestDataUtility.createUser('Standard User', 'testUserName@testing.com');
        insert testUser;

        countrys = TestDataUtility.getTestCountryCodes();
        insert countrys;

        states = TestDataUtility.getTestStateCodes();
        insert states;
    /*Test.startTest();
        list < Account > acc = new List < Account > ();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.Phone = '(123) 456-7890';
        ac.BillingCountryCode = 'US';
        ac.BillingPostalCode = '12345';
        ac.BillingStateCode = 'CA';
        ac.Zip__c = '12345';
        acc.add(ac);
        insert acc[0];

        Account ac1 = new Account();
        ac1.Name = 'Test Account1';
        ac1.Type = 'Architecture Firm';
        ac1.Phone = '(123) 456-7890';
        ac1.BillingCountryCode = 'US';
        ac1.BillingPostalCode = '12345';
        ac1.BillingStateCode = 'CA';
        ac1.Zip__c = '12345';
        acc.add(ac1);
        insert acc[1];

        Account ac2 = new Account();
        ac2.Name = 'Test Account1';
        ac2.Phone = '(123) 456-7890';
        ac2.BillingCountryCode = 'US';
        ac2.BillingPostalCode = '12345';
        ac2.BillingStateCode = 'CA';
        ac2.Zip__c = '12345';
        acc.add(ac2);
        insert acc[2];

        
        

        list < contact > con = new list < contact > ();
        Contact c = new Contact();
        c.Accountid = acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'Test';
        c.MailingStreet = 'street';
        c.MailingCity = 'city';
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        con.add(c);
        insert con[0];



        Contact c1 = new Contact();
        c1.Accountid = acc[1].id;
        c1.FirstName = 'Ram';
        c1.LastName = 'Test';
        c1.MailingStreet = 'street';
        c1.MailingCity = 'city';
        c1.Mailingstate = 'Utah';
        c1.MailingPostalCode = '12345';
        c1.MailingCountryCode = 'US';
        con.add(c1);
        insert con[1];

        Contact c2 = new Contact();
        c2.Accountid = acc[2].id;
        c2.FirstName = 'Ram';
        c2.LastName = 'Test';
        c2.MailingStreet = 'street';
        c2.MailingCity = 'city';
        c2.Mailingstate = 'Utah';
        c2.MailingPostalCode = '12345';
        c2.MailingCountryCode = 'US';
        con.add(c2);
        insert con[2];*/
        
        accounts = testDataUtility.createAccountTestData();
       insert accounts;
       
       contacts = testDataUtility.createConTestData();
       Contacts[0].Accountid=accounts[0].id;
       Contacts[1].Accountid=accounts[1].id;
       Contacts[2].Accountid=accounts[2].id;
       insert contacts;
        
 Test.startTest();
 
        list < Project__c > Pro = new list < Project__c > ();
        Project__c proj = new Project__c();
        proj.Name = 'Test ProjectSectiondetails';
        proj.OwnerId = testUser.id;
        proj.RecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        proj.Application__c = 'Automotive';
        proj.Application_2__c = 'Other';
        proj.Project_City__c = 'city';
        proj.Project_Country__c = 'United States';
        proj.Project_State__c = 'Indiana';
        proj.Project_Street_Address__c = 'street address';
        proj.Project_Zip_Code__c = '12345';
        proj.TerritoryName__c = 'territory';
        proj.Purchaser_Account__c = accounts[0].id;
        proj.Purchaser_Contact__c = contacts[0].id;
        proj.Other_Influencer_Account__c = accounts[1].id;
        proj.Other_Influencer_Contact__c = contacts[1].id;
        proj.Architect_Account__c = accounts[2].id;
        proj.Architect_Contact__c = contacts[2].id;
        proj.Brand_Name_Account__c = accounts[2].id;
        proj.Brand_Name_Contact__c = contacts[2].id;
        proj.End_Customer_Account__c = accounts[2].id;
        proj.End_Customer_Contact__c = contacts[2].id;
        proj.Franchise_Account__c = accounts[2].id;
        proj.Franchise_Contact__c = contacts[2].id;
        proj.Franchisor_Account__c = accounts[2].id;
        proj.Franchisor_Contact__c = contacts[2].id;
        proj.Interior_Application__c = 'Interior_Application__c';
        proj.Corporate_Account__c = true;
        proj.Residential_Vertical__c = true;
        proj.Chain_Project_Type__c = 'Standard';
        proj.Budget_Quote_Provided__c = true;
        proj.Web_Project__c = true;
        proj.Public_Spec_d_Job__c = true;
        proj.Publicly_Specified_Jobs__c = 'Nana only';
        proj.Installer_Email_Viewed__c = true;
        proj.Ordering_Account__c = accounts[0].id;
        proj.Purchasing_Method__c = 'Glass House';
        proj.Preliminary_Drawings__c = true;
        proj.Preliminary_Drawings_Date__c = date.today();
        proj.Award_Date__c = date.today();
        proj.Bid_Date__c = date.today();
        proj.Close_Date__c = Date.newInstance(2016, 12, 12);
        proj.Estimated_Project_Need_Date__c = date.today();
        proj.Expected_Install_Date__c = date.today();
        proj.Expected_Open_Date__c = date.today();
        proj.Actual_Project_Need_Date__c = date.today();
        proj.Amount__c = 10;
        proj.Stage__c = 'Closed Won - Order Signed';
        // proj.IsDeleted=false;
        proj.Architect_Considered__c = true;

        Pro.add(proj);
        try {
            insert Pro[0];
        } catch (Exception e) {}
        
        List < Opportunity > oppList = new list < Opportunity > ();
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.AccountId = accounts[1].id;
        opp.Amount = 1000;
        //opp.Probability = 20;
        opp.Project_Name__c = Pro[0].id;
        //opp.Stage_Detail__c = 'Considered';
        //opp.ForecastCategoryName = 'Pipeline';
        //opp.Expected_Resolution_Date_2__c = system.today();
        opp.StageName = 'Closed/Won';
        //opp.Application_Industry__c='test';
        //opp.Application_Sub_Industry__c='test1';
        //opp.Award_Date__c = date.today();
        //opp.Bid_Date__c = date.today();
        //opp.Budget_Quote__c = true;
        //opp.Discounts__c = 5.00;
        //opp.Primary_Opportunity__c = true;
        //opp.Close_Date__c=system.today()+10;
        opp.CloseDate = Date.today() + 10;
        //opp.OwnerId = testUser.id;
        //opp.RecordTypeId = Label.Influencer_Opportunity_RecordTypeId;
        oppList.add(opp);
        
        insert oppList;
       
        

        List < nrOpportunityContactRole__c > nrlist = new List < nrOpportunityContactRole__c > ();

        nrOpportunityContactRole__c nropp = new nrOpportunityContactRole__c();
        nropp.Contact__c = contacts[1].id;
        nropp.Opportunity__c = oppList[0].id;
        nrlist.add(nropp);

        insert nrlist[0];


        List < Note > notelist = new List < Note > ();
        Note note = new Note();
        note.ParentId = Pro[0].id;
        note.Title = 'Test';
        note.Body = 'testing';
        insert note;
        //test.startTest();

        List < Attachment > atchlst = new List < Attachment > ();
        Attachment at = new Attachment();
        at.Name = 'test';
        at.ParentId = Pro[0].id;
        at.Body = Blob.valueOf('Unit Test Attachment Body');
        atchlst.add(at);
        insert atchlst[0];




        list < Quote__c > qList = new list < Quote__c > ();
        Quote__c qt = new Quote__c();
        qt.Name = 'test quote';
        //qt.Average_Quote_Discount__c = 15.23;
        qt.Project__c = proj.id;
        /*qt.AACO__c = true;
        qt.Actual_Delivery_Date__c = date.today();
        qt.Actual_Pickup_Date__c = date.today();
        qt.Address__c = 'abc';
        
        qt.Balanced_Received_Date__c = date.today();
        qt.Balance_Received__c = 20.66;
        qt.CAD_Opened__c = system.now();
        qt.CAD_Sent__c = system.now();
        qt.CAD_Viewed__c = false;
        qt.Canadian_Tax_Status__c = 'Company';
        qt.Cancelled__c = true;
        qt.City__c = 'abc';
        qt.Commission_Showroom__c = show.id;
        qt.Complete_Signoff_Date__c = date.today();
        qt.Contact__c = con[0].Id;
        qt.Showroom__c = con[0].id;
        qt.VisitedShowroom__c = con[0].id;
        qt.Controlling_Account__c = acc[0].id;
        qt.Country__c = 'india';
        qt.Custom__c = true;
        qt.Custom_Drawing__c = true;
        qt.Deposit_Amount__c = 5;
        qt.Deposit_Date__c = date.today();
        qt.DocuSign_Status__c = ds.id;
        qt.Deposit_Received_Date__c = date.today();
        qt.Drawing_Deposit_Amount__c = 20;
        qt.Drawing_Deposit__c = date.today();
        qt.Drawing_Deposit_Amount__c = 20;
        qt.Drawing_Deposit__c = date.today();
        qt.Drawing_Thirty_Percent_Deposit_Amount__c = 30;
        qt.Drawing_Additional_Payment_Received__c = date.today();
        qt.Drawing_Approved_Contract__c = date.today();
        qt.Drawing_As_Built_Drawings_Supplied__c = date.today();
        qt.Drawing_Author__c = 'abc';
        qt.Drawing_CAD_Files_Sent_To_Germany__c = date.today();
        qt.Drawing_Complete__c = date.today();
        qt.Drawing_Copy_Sent_To_Rep__c = date.today();
        qt.Drawing_Cost_Discrepancy_Summary_Sent__c = date.today();
        qt.Drawing_Customer_Drawings_Received__c = date.today();
        qt.Drawing_Customer_Issues_Resolved__c = date.today();
        qt.Drawing_Eng_Implemented_Corrections__c = date.today();
        qt.Drawing_Eng_Clarification_Contact__c = date.today();
        qt.Drawing_Engineering_Fee_Received__c = date.today();
        qt.Drawing_Engineering_Technical_Meeting__c = date.today();
        qt.Drawing_ETA__c = date.today();
        qt.Drawing_Final_Signoff__c = date.today();
        qt.Drawing_Final_Order_Confirmation__c = date.today();
        qt.Drawing_Final_Documents_Sent__c = date.today();
        qt.Drawing_First_Submittal_Order_Sent__c = date.today();
        qt.Drawing_Followup_Letter_Sent__c = date.today();
        qt.Drawing_Initial_Deposit_Description__c = '50% only';
        qt.Drawing_Internal_Approval__c = date.today();
        qt.Drawing_Late_Approval_Rep_Notification__c = date.today();
        qt.Drawing_Nana_Reps_Updated__c = date.today();
        qt.Drawing_Notes__c = 'test drawing';
        qt.Drawing_On_Hold_Till_Date__c = date.today();
        qt.Drawing_Order_Released_For_Production__c = date.today();
        qt.Drawing_PDFs_Put_In_Project_File__c = date.today();
        qt.Drawing_Pipeline_Category_Name_2__c = 'abc';
        qt.Drawing_PIpeline_Status_2__c = 'def';
        qt.Drawing_Order_Confirmation_Signoff__c = date.today();
        qt.Drawing_Price__c = 10;
        qt.Drawing_Project_Start_Date__c = date.today();
        qt.Drawing_Requirements_Sent__c = date.today();
        qt.Drawing_Review_Drawings__c = date.today();
        qt.Drawing_Revision_1_Date__c = date.today();
        qt.Drawing_Revision_2_Date__c = date.today();
        qt.Drawing_Revision_3_Date__c = date.today();
        qt.Drawing_Revision_4_Date__c = date.today();
        qt.Drawing_Revision_5_Date__c = date.today();
        qt.Drawing_Revision_6_Date__c = date.today();
        qt.Drawing_Revision_7_Date__c = date.today();
        qt.Drawing_Revision_8_Date__c = date.today();
        qt.Drawing_Revision_Charge_Applied__c = date.today();
        qt.Drawing_Revision_Reason__c = 'abc';
        qt.Drawing_Revision_Received__c = date.today();
        qt.Drawing_Revision_Submitted__c = date.today();
        qt.Drawings__c = 'Standard';
        qt.Drawing_Samples_Received__c = date.today();
        qt.Drawing_Samples_Sent__c = date.today();
        qt.Drawing_Supervisor_One_Checked_Drawings__c = date.today();
        qt.Drawing_Supervisor_Two_Checked_Drawings__c = date.today();
        qt.Drawing_Tracking_Number_Sent_To_Rep__c = date.today();
        qt.Drawing_Version_Number__c = 10;
        qt.ELQ_Send_ETA_Letter__c = true;
        qt.ELQ_Send_Revised_ETA_Letter__c = true;
        qt.Print_Date__c = system.now();
        qt.Email_sent_to_Service_Department__c = date.today();
        qt.Estimated_Pickup_Date__c = date.today();
        qt.ETA_Jobsite__c = date.today();
        qt.ETA_Letter_Sent__c = true;
        qt.ETA_Letter_Sent_Date__c = date.today();
        qt.Expedited_Shipping__c = true;
        qt.Extended_Warranty__c = true;
        qt.Factory_Completion_Date__c = date.today();
        qt.Final_Confirmation_Date__c = date.today();
        qt.Final_Invoice_Amount__c = 20;
        qt.First_threshold__c = false;
        qt.Followup__c = false;
        qt.Followup_Status__c = 'Reviewing';
        qt.Freight_ETA_Jobsite__c = date.today();
        qt.Freight_ETA_Toggle__c = false;
        qt.Freight_Lookup__c = 20;
        qt.Freight__c = 30;
        qt.Freight_Tracking_Number__c = 'test123';
        qt.Glass_Size_Sent__c = date.today();
        qt.Hard_Copy_Date__c = system.now();
        qt.Hardware_Actual_Jobsite__c = date.today();
        qt.Hardware_Email_Details__c = 'abc';
        qt.Hardware_Email_Sent__c = date.today();
        qt.Hardware_ETA_Jobsite__c = date.today();
        qt.Hardware_Ship_Date__c = date.today();
        qt.Hardware_Tracking_Number__c = 'test';
        qt.Incomplete_Order_Confirmation_Notes__c = 'test notes';
        qt.Incomplete_Order_Confirmation_Paperwork__c = false;
        qt.Install_Confirmed__c = false;
        qt.Install_Date__c = date.today();
        qt.Installer__c = acc[0].id;
        qt.Installer_Email_Viewed__c = false;
        qt.Installer_Notes__c = 'abc';
        qt.Invoices_Sent_Date__c = date.today();
        qt.Is_Local__c = false;
        qt.Keyed_Alike__c = false;
        qt.Nana_Added_By__c = 'abc';
        qt.Nana_Create_Date__c = date.today();
        qt.Nana_Edit_Date__c = date.today();
        qt.NanaPDFID__c = 123456789;
        qt.On_Hold__c = false;
        qt.Order_Acknowledged_Date__c = date.today();
        qt.Order_Acknowledgement_2_Needed__c = false;
        qt.Order_Confirmation_Opened__c = system.now();
        qt.Order_Confirmation_Sent__c = system.now();
        qt.Order_Confirmation_Started__c = date.today();
        qt.Ordered__c = false;
        qt.Order_Finalized_Date__c = date.today();
        qt.Order_Notes__c = 'test 13';
        qt.Order_Number__c = 123;
        qt.Packaging__c = 30;
        qt.PDF_URL__c = 'test pdf';
        qt.Pipeline_Notes__c = 'pipeline';
        qt.PO_Number__c = 'po num';
        qt.Preview_Order__c = 'preview';
        qt.Primary_Quote__c = true;
        qt.Printed__c = true;
        
        qt.Project_Coordinator__c = testUser.id;
        qt.QNO_Follow_Up__c = false;
        qt.Discount__c = 10;
        qt.Quote_ID__c = 10;
        qt.Quote_Notes__c = 'test quote notes';
        qt.Record_Type__c = 'Purchase';
        qt.Revised_ETA_Jobsite__c = date.today();
        qt.Revised_ETA_Jobsite_Reason__c = 'not intrested';
        qt.Revised_ETA_Toggle__c = true;
        qt.Screen_Actual_Jobsite__c = date.today();
        qt.Screen_Actual_Mill_Valley__c = date.today();
        qt.Screen_ETA_Jobsite__c = date.today();
        qt.Screen_ETA_Mill_Valley__c = date.today();
        qt.Screen_Notes__c = 'abc';
        qt.Screen_Order_Placed__c = date.today();
        qt.Screen_Ship_from_Mill_Valley__c = date.today();
        qt.Screen_Supplier__c = 'Frehe';
        qt.Screen_Tracking_Number__c = 'qwd';
        qt.Sealy_Sent__c = false;
        qt.Send_Tax_Certificate__c = false;
        qt.Shipping_Company__c = 'test data';
        qt.Shipping_Max__c = 456;
        qt.Shipping_Min__c = 12;
        qt.Shipping_Name__c = '123';
        qt.Shipping_Phone__c = '456';
        qt.SL_Order_Number__c = '789';
        
        qt.State__c = 'ap';
        qt.Taha_Review__c = false;
        qt.Take_Off_Provided__c = false;
        qt.Taxable__c = false;
        qt.TaxRate__c = 12;
        qt.Tax_Total__c = 23;
        qt.Technical_Supervisor__c = testUser.id;
        qt.Total__c = 50;
        qt.Training_Actual__c = date.today();
        qt.Training_ETA__c = date.today();
        qt.Unglazed_Override__c = false;
        qt.Unique_Models__c = 'HSW 50';
        qt.Use_Controlling_Account__c = false;
        qt.Van_Ness_Commission__c = true;
        qt.Viewed__c = true;
        qt.Web_Quote__c = true;
        qt.Work_Order_Received__c = date.today();
        qt.Work_Order_Sent__c = date.today();
        qt.Zip__c = '12345';*/
        //qt.SubTotal__c=10;
        qt.Opportunity__c = oppList[0].id;
        qt.Stage__c = 'Open';
        qList.add(qt);
          
        insert qList;
        

        PageReference pageRef = Page.ProjectSelectSectionDetails;
            Test.setCurrentPageReference(pageRef);
            System.currentPageReference().getParameters().put('projectId', Pro[0].id);
            ApexPages.StandardController sc = new ApexPages.StandardController(Pro[0]);
        ProjectSectiondetails projsecdetails = new ProjectSectiondetails();
            System.currentPageReference().getParameters().put('projectId', Pro[0].id);
        
        //projsecdetails.box1 =true;
        projsecdetails.allSelected = true;
        //projsecdetails.nttproji nt = projsecdetails.nttproji(note);
        //projsecdetails.notesAttachList[0].isSelected2 = true;
        //projsecdetails.notesAttachList[2].isSelected2 = true;
        
        projsecdetails.selectAll();
        
        projsecdetails.Next();
        projsecdetails.goBack();
        projsecdetails.Next();
        //ProjectSectiondetails.Oproji psd = new ProjectSectiondetails.Oproji(oppList[0]);
        //projsecdetails.oppList[0].isSelected1 = true;
        //Test.startTest();
        projsecdetails.selected();
        //Test.stopTest();
         projsecdetails.validate();
        Test.stopTest();
        
        
    }
}