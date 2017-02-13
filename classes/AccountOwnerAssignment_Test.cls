/**
 * @author       Absyz Consulting
 * @date         11/04/2015
 * @description  Test class which tests AccountOwnerAssignment class
 *
 * @ Audit Trial   : Repeating block for each change to the code
 **/
@isTest
private class AccountOwnerAssignment_Test {

    public static List < Account > olstTestAccount;
    public static List < Country_codes__c > olstTestCountryCode;
    public static List < state_codes__c > olstTestStateCode;
    public static List < Zip_Codes_Master__c > olstTerritoryMastereCode;
    public static List < Case > olstTestCase;
    public static User olstuse;
    static testMethod void myUnitTest() {


        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        try {
            insert olstTestCountryCode;
        } catch (Exception e) {}
        olstTestStateCode = TestDataUtility.getTestStateCodes();
        try {
            insert olstTestStateCode;
        } catch (Exception e) {}

        olstuse = TestDataUtility.createUser('System Administrator', 'satishlokinindi@gmail.com');
        try {
            insert olstuse;
        } catch (Exception e) {}

        olstTestAccount = TestDataUtility.createAccountTestData();

        olstTestAccount[1].BillingCountryCode = 'CA';
        olstTestAccount[1].BillingPostalCode = 'v0m 9s9';
        olstTestAccount[1].BillingState = 'Alberta';

        olstTestAccount[2].BillingCountryCode = 'US';
        olstTestAccount[2].BillingPostalCode = '12345';


        olstTestAccount[3].BillingCountryCode = 'MX';
        olstTestAccount[3].BillingState = 'Colima';
        try {
            insert olstTestAccount;
        } catch (Exception e) {

        }

        olstTestAccount[1].BillingCountryCode = 'US';
        olstTestAccount[1].BillingPostalCode = '12345';
        olstTestAccount[2].BillingCountryCode = 'CA';
        olstTestAccount[2].BillingPostalCode = 'v0m 9s9';
        olstTestAccount[3].BillingCountryCode = 'MX';
        olstTestAccount[3].BillingState = 'Colima';
        olstTestAccount[4].BillingCountryCode = 'US';
        olstTestAccount[4].BillingPostalCode = '12345';
        try {

            Update olstTestAccount;
        }
        Catch(Exception ex) {}

        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        //For (Zip_Codes_Master__c o:olstTerritoryMastereCode )
        try { //o.User__c=olstuse.ID ; 
            insert olstTerritoryMastereCode;
        }
        Catch(Exception ex) {}

    }




    static testMethod void myUnitTestnew() {
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        //For (Zip_Codes_Master__c o:olstTerritoryMastereCode )
        //o.User__c=olstuse.ID ; 
        insert olstTerritoryMastereCode;
        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        insert olstTestCountryCode;
        olstTestStateCode = TestDataUtility.getTestStateCodes();
        insert olstTestStateCode;
        olstuse = TestDataUtility.createUser('System Administrator', 'satishlokinindi@gmail.com');
        insert olstuse;
        olstTestAccount = TestDataUtility.createAccountTestData();
        olstTestAccount[0].BillingCountryCode = 'US';
        olstTestAccount[0].BillingPostalCode = '12345';

        olstTestAccount[1].BillingCountryCode = 'CA';
        olstTestAccount[1].BillingPostalCode = 'v0m 9s9';
        olstTestAccount[1].BillingState = 'Alberta';

        olstTestAccount[2].BillingCountryCode = 'US';
        olstTestAccount[2].BillingPostalCode = '12345';


        olstTestAccount[3].BillingCountryCode = 'MX';
        olstTestAccount[3].BillingState = 'Colima';

        olstTestAccount[4].BillingCountryCode = 'india';
        olstTestAccount[5].BillingCountryCode = 'US';
        olstTestAccount[5].BillingPostalCode = '12345';

        olstTestAccount[6].BillingCountryCode = 'US';
        olstTestAccount[6].BillingPostalCode = '12345';
        try {
            insert olstTestAccount;
        } catch (Exception e) {}
        olstTestAccount[0].BillingCountryCode = 'US';
        olstTestAccount[0].BillingPostalCode = '12345';
        olstTestAccount[1].BillingCountryCode = 'US';
        olstTestAccount[1].BillingPostalCode = '12345';
        olstTestAccount[2].BillingCountryCode = 'CA';
        olstTestAccount[2].BillingPostalCode = 'v0m 9s9';
        olstTestAccount[3].BillingCountryCode = 'MX';
        olstTestAccount[3].BillingState = 'Colima';
        olstTestAccount[5].BillingCountryCode = 'US';
        olstTestAccount[5].BillingPostalCode = '';
        olstTestAccount[6].BillingCountryCode = 'US';
        olstTestAccount[6].BillingPostalCode = '12345';


        try {

            Update olstTestAccount;
        }
        Catch(Exception ex) {}
        Set < Id > AccountIds = new Set < Id > ();
        for (Account acc: olstTestAccount) {
            AccountIds.add(acc.Id);
        }

        accountOwnerAssignment.assignoppowner(AccountIds);
        accountOwnerAssignment.checkProjectSplit(AccountIds);
    }
    static testMethod void myUnitTestnew2() {
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();

        insert olstTerritoryMastereCode;
        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        insert olstTestCountryCode;
        olstTestStateCode = TestDataUtility.getTestStateCodes();
        insert olstTestStateCode;
        olstuse = TestDataUtility.createUser('System Administrator', 'satishlokinindi@gmail.com');
        insert olstuse;

        olstTestAccount = TestDataUtility.createAccountTestData();
        olstTestAccount[1].BillingCountryCode = 'US';
        olstTestAccount[1].BillingPostalCode = '12345';
        try {
            insert olstTestAccount;
        } catch (Exception e) {}

        olstTestAccount[1].BillingCountryCode = 'US';
        olstTestAccount[1].BillingPostalCode = '12345';


        try {

            Update olstTestAccount;
        }
        Catch(Exception ex) {}



    }


    static testMethod void myUnitTest3() {

        profile p = [select id from Profile where name = 'Standard User'];

        User u = new User(alias = 'testme', email = 'testme@noemail.com', emailencodingkey = 'UTF-8', lastname = 'test', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = p.Id, country = 'United Kingdom', timezonesidkey = 'Europe/London', username = 'testme@noemail.com');
        insert u;


        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        insert olstTerritoryMastereCode;

        olstTestCountryCode = TestDataUtility.getTestCountryCodes();
        insert olstTestCountryCode;
        olstTestStateCode = TestDataUtility.getTestStateCodes();
        insert olstTestStateCode;
        olstuse = TestDataUtility.createUser('System Administrator', 'satishlokinindi@gmail.com');

        insert olstuse;

        //catch(Exception e){}

        olstTestAccount = TestDataUtility.createAccountTestData();

        olstTestAccount[0].BillingCountryCode = 'US';
        olstTestAccount[0].BillingPostalCode = '12345';
        olstTestAccount[0].Name = 'test';
        olstTestAccount[0].OwnerId = u.id;
        olstTestAccount[0].Phone = '12345678';
        olstTestAccount[0].BillingState = 'New York';
        olstTestAccount[0].BillingCountry = 'United States';
        olstTestAccount[0].BillingPostalCode = '12345';


        olstTestAccount[1].BillingCountryCode = 'CA';
        olstTestAccount[1].BillingPostalCode = ''; // v0m 9s9
        olstTestAccount[1].BillingState = 'Alberta';

        olstTestAccount[2].BillingCountryCode = 'US';
        olstTestAccount[2].BillingPostalCode = '12345';


        olstTestAccount[3].BillingCountryCode = 'MX';
        olstTestAccount[3].BillingState = 'Colima';

        olstTestAccount[4].BillingCountryCode = 'india';
        olstTestAccount[5].BillingCountryCode = 'US';
        olstTestAccount[5].BillingPostalCode = '12345';

        olstTestAccount[6].BillingCountryCode = 'US';
        olstTestAccount[6].BillingPostalCode = '12345';
        try {
            insert olstTestAccount;
        } catch (Exception e) {}

        // Set<Id> s1 = (new Map<Id,Account>(olstTestAccount)).keySet();

        olstTestAccount[0].BillingCountryCode = 'US';
        olstTestAccount[0].BillingPostalCode = '12345';
        olstTestAccount[1].BillingCountryCode = 'US';
        olstTestAccount[1].BillingPostalCode = '12345';
        olstTestAccount[2].BillingCountryCode = 'CA';
        olstTestAccount[2].BillingPostalCode = 'v0m 9s9';
        olstTestAccount[3].BillingCountryCode = 'MX';
        olstTestAccount[3].BillingState = 'Colima';
        olstTestAccount[5].BillingCountryCode = 'US';
        olstTestAccount[5].BillingPostalCode = '';
        olstTestAccount[6].BillingCountryCode = 'US';
        olstTestAccount[6].BillingPostalCode = '12345';


        try {

            Update olstTestAccount;
        }
        Catch(Exception ex) {}

        //Set<Id> s1 = (new Map<Id,Account>(olstTestAccount)).keySet();
        Set < Id > AccountIds = new Set < Id > ();
        Set <Account> Acc1 = new Set <Account> ();
        //Set<Id> OpportunityIds=new Set<Id>();

        for (Account acc: olstTestAccount) {
            AccountIds.add(acc.Id);
        }


        olstTestCase=TestDataUtility.createCaseTestData();
        
        olstTestCase[0].Origin='Phone';
        olstTestCase[0].Status='New';
        olstTestCase[0].Priority='Medium';
        olstTestCase[0].Subject='Test';
        olstTestCase[0].Description='Test Description';
        
        olstTestCase[1].Origin='Email';
        olstTestCase[1].Status='New';
        olstTestCase[1].Priority='High';
        olstTestCase[1].Subject='Test';
        olstTestCase[1].Description='Test Desc';
        
        try{
        insert olstTestCase;
        }catch (Exception e){}



        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        insert olstTerritoryMastereCode;


        list < Zip_Codes_Master__c > lstzipCode = new list < Zip_Codes_Master__c > ();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345';
        lstzipCode.add(zipCode1);
        insert lstzipCode;

        //set<id> accSet=new set<id>();
        list < Account > accList = new list < Account > ();
        Account acc = new Account();
        acc.Name = 'test';
        acc.OwnerId = u.id;
        acc.Phone = '12345678';
        acc.BillingState = 'New York';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = '12345';
        accList.add(acc);
        acc1.add(acc);
        insert acc;

        contact con = new contact();
        con.Accountid = acc.id;
        con.FirstName = 'john';
        con.LastName = 'doe';
        con.address_1__c = 'abcd';
        con.Address_2__c = 'hyd';
        con.City__c = 'abc';
        con.State_Abbr__c = 'asd';
        con.State__c = 'ALASKA';
        con.Zip__c = '12345';
        con.Country__c = 'Anguilla';
        con.Phone = '563256';
        con.Fax = '563256';
        con.Email = 'test@test.com';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.Mailingstate = 'Utah';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        
        insert con;


        Project__c proj = new Project__c();
        proj.Name = 'Test Project';
        proj.OwnerId = u.id;
        //proj.IsDeleted=false;
        proj.RecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        proj.Actual_Project_Need_Date__c = date.today();
        proj.Amount__c = 10;
        proj.Architect_Account__c = acc.id;
        proj.Architect_Considered__c = true;
        proj.Architect_On_Project__c = true;
        proj.Award_Date__c = date.today();
        proj.Bid_Date__c = date.today();
        proj.Budget_Quote_Provided__c = true;
        proj.Choices__c = 'NoValue';
        proj.Corporate_Account__c = true;
        proj.Project_Zip_Code__c = '12345';
        proj.Dodge_Number__c = '123';
        proj.End_Customer_Contact__c = con.id;
        proj.Implicit_Contact__c = con.id;
        proj.Installer_Email_Viewed__c = true;
        proj.Lead_Source__c = 'cold';
        insert proj;

        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.Project_Name__c = proj.id;
        opp.OwnerId = u.id;
        opp.AccountId = olstTestAccount[0].id;
        opp.Amount = 1000;
        opp.Probability = 20;
        opp.StageName = 'Closed/Won';
        opp.CloseDate = Date.today() + 10;
        insert opp;

       /* list < Case > caselist = new list < Case >();
        Case c=new Case();
        for(integer i=0;i<2;i++)
        {
        //c.Name = 'testcase';
        c.AccountId=olstTestAccount[i].id;
        c.Shipping_City_EndCustomer__c='Cust Name';
        c.Shipping_Country__c= 'United States';
        c.Shipping_State_End_Customer__c='Second Cust';
        c.Shipping_Street_End_Customer__c='John';
        c.Shipping_Zip_End_Customer__c='Test John';
        c.Billing_City__c='Test City';
        c.Billing_Country__c='US';
        c.Billing_State__c='New York';
        c.Billing_Street_End_Customer__c='Test Name';
        c.Billing_Zipcode__c='12345';
        
        
        }
        caselist.add(c);
        insert c;*/
        
        list < Case > caselist = new list < Case >();
        Case c=new Case();
         
        //c.Name = 'testcase';
        c.AccountId=acc.id;
        c.status='New';
        c.Shipping_City_EndCustomer__c='Cust Name';
        c.Shipping_Country__c= 'United States';
        c.Shipping_State_End_Customer__c='Second Cust';
        c.Shipping_Street_End_Customer__c='John';
        c.Shipping_Zip_End_Customer__c='Test John';
        c.Billing_City__c='Test City';
        c.Billing_Country__c='US';
        c.Billing_State__c='New York';
        c.Billing_Street_End_Customer__c='Test Name';
        c.Billing_Zipcode__c='12345';
        c.Caller_contact__c=con.id;
        caselist.add(c);
       // insert c;
        
        //list < Case > caselist1 = new list < Case >();
        case c1=new Case();
        c1.AccountId=acc.id;
        c1.status='New';
        c1.Shipping_City_EndCustomer__c='Cust Name';
        c1.Shipping_Country__c= 'United States';
        c1.Shipping_State_End_Customer__c='Second Cust';
        c1.Shipping_Street_End_Customer__c='John';
        c1.Shipping_Zip_End_Customer__c='Test John';
        c1.Billing_City__c='Test City';
        c1.Billing_Country__c='US';
        c1.Billing_State__c='New York';
        c1.Billing_Street_End_Customer__c='Test Name';
        c1.Billing_Zipcode__c='12345';
        c1.Caller_contact__c=con.id;
        caselist.add(c1);
        insert caselist;
        
        accountOwnerAssignment.assignoppowner(AccountIds);
        accountOwnerAssignment.checkProjectSplit(AccountIds);
        accountOwnerAssignment.assignOwner(accList);
        accountOwnerAssignment.CaseUpdationwithAccountAddress(Acc1);

    }


    static testMethod void myUnitTest4() {

        profile p = [select id from Profile where name = 'Standard User'];

        User u = new User(alias = 'testme', email = 'testme@noemail.com', emailencodingkey = 'UTF-8', lastname = 'test', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = p.Id, country = 'United Kingdom', timezonesidkey = 'Europe/London', username = 'testme@noemail.com');
        insert u;
        User usr = new User(alias = 'testme1', email = 'testme1@noemail.com', emailencodingkey = 'UTF-8', lastname = 'test', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = p.Id, country = 'United Kingdom', timezonesidkey = 'Europe/London', username = 'testme1@noemail.com');
        insert usr;


        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
        insert olstTerritoryMastereCode;
        olstTestCountryCode = TestDataUtility.getTestCountryCodes();

        insert olstTestCountryCode;
        olstTestStateCode = TestDataUtility.getTestStateCodes();

        insert olstTestStateCode;
        olstuse = TestDataUtility.createUser('System Administrator', 'satishlokinindi@gmail.com');
        insert olstuse;
        olstTestAccount = TestDataUtility.createAccountTestData();
        olstTestAccount[0].BillingCountryCode = 'AF';
        olstTestAccount[0].BillingPostalCode = '';
        olstTestAccount[0].Name = 'test';
        //olstTestAccount[0].OwnerId=u.id;
        olstTestAccount[0].Phone = '12345678';



        olstTestAccount[1].BillingCountryCode = 'CA';
        olstTestAccount[1].BillingPostalCode = ''; // v0m 9s9
        olstTestAccount[1].BillingState = 'Alberta';

        olstTestAccount[2].BillingCountryCode = 'IN';
        //olstTestAccount[2].BillingPostalCode = '';   


        olstTestAccount[3].BillingCountryCode = 'MX';
        olstTestAccount[3].BillingState = 'Colima';

        olstTestAccount[4].BillingCountryCode = 'IN';

        olstTestAccount[5].BillingCountryCode = 'US';
        olstTestAccount[5].BillingPostalCode = '1234s';

        olstTestAccount[6].BillingCountryCode = 'CA';
        olstTestAccount[6].BillingPostalCode = 'V0M sS0';
        try {
            insert olstTestAccount;
        } catch (Exception e) {}

        olstTestAccount[0].BillingCountryCode = 'US';
        olstTestAccount[0].BillingPostalCode = '';
        olstTestAccount[1].BillingCountryCode = 'US';
        olstTestAccount[1].BillingPostalCode = '12345';
        olstTestAccount[2].BillingCountryCode = 'CA';
        olstTestAccount[2].BillingPostalCode = 'v0m 919';
        olstTestAccount[3].BillingCountryCode = 'MX';
        olstTestAccount[3].BillingState = 'Colima';
        olstTestAccount[5].BillingCountryCode = 'US';
        olstTestAccount[5].BillingPostalCode = '1234s';
        olstTestAccount[6].BillingCountryCode = 'MX';
        olstTestAccount[6].BillingPostalCode = '';
        olstTestAccount[6].BillingState = '';


        try {

            Update olstTestAccount;
        }
        Catch(Exception ex) {}

        Set < Id > AccountIds = new Set < Id > ();
        for (Account acc: olstTestAccount) {
            AccountIds.add(acc.Id);
        }
        list < Zip_Codes_Master__c > lstzipCode = new list < Zip_Codes_Master__c > ();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345';
        lstzipCode.add(zipCode1);
        insert lstzipCode;

        set < id > accSet = new set < id > ();
        //list<Account> accList=new list<Account>();
        Account acc = new Account();
        acc.Name = 'test';
        acc.OwnerId = u.id;
        acc.Phone = '12345678';
        acc.BillingState = 'New York';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = '12345';

        insert acc;

        Account acc1 = new Account();
        acc1.Name = 'test';
        acc1.OwnerId = usr.id;
        acc1.Phone = '12345678';
        acc1.BillingState = 'New York';
        acc1.BillingCountry = 'United States';
        acc1.BillingPostalCode = '12345';

        insert acc1;
        accSet.add(acc1.id);

        contact con = new contact();
        con.Accountid = acc.id;
        con.FirstName = 'john';
        con.LastName = 'doe';
        con.address_1__c = 'abcd';
        con.Address_2__c = 'hyd';
        con.City__c = 'abc';
        con.State_Abbr__c = 'asd';
        con.State__c = 'ALASKA';
        con.Zip__c = '12345';
        con.Country__c = 'Anguilla';
        con.Phone = '563256';
        con.Fax = '563256';
        con.Email = 'test@test.com';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.Mailingstate = 'Utah';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        insert con;


        Project__c proj = new Project__c();
        proj.Name = 'Test Project';
        proj.OwnerId = u.id;
        //proj.IsDeleted=false;
        proj.RecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        proj.Actual_Project_Need_Date__c = date.today();
        proj.Amount__c = 10;
        proj.Architect_Account__c = acc.id;
        proj.Architect_Considered__c = true;
        proj.Architect_On_Project__c = true;
        proj.Award_Date__c = date.today();
        proj.Bid_Date__c = date.today();
        proj.Budget_Quote_Provided__c = true;
        proj.Choices__c = 'NoValue';
        proj.Corporate_Account__c = true;
        proj.Project_Zip_Code__c = '12345';
        proj.Dodge_Number__c = '123';
        proj.End_Customer_Contact__c = con.id;
        proj.Implicit_Contact__c = con.id;
        proj.Installer_Email_Viewed__c = true;
        proj.Lead_Source__c = 'cold';
        insert proj;

        Project__c projt = new Project__c();
        projt.Name = 'Test Project';
        projt.OwnerId = u.id;
        //proj.IsDeleted=false;
        projt.RecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        projt.Actual_Project_Need_Date__c = date.today();
        projt.Amount__c = 10;
        projt.Architect_Account__c = acc.id;
        projt.Architect_Considered__c = true;
        projt.Architect_On_Project__c = true;
        projt.Award_Date__c = date.today();
        projt.Bid_Date__c = date.today();
        projt.Budget_Quote_Provided__c = true;
        projt.Choices__c = 'NoValue';
        projt.Corporate_Account__c = true;
        projt.Project_Zip_Code__c = '12345';
        projt.Dodge_Number__c = '123';
        projt.End_Customer_Contact__c = con.id;
        projt.Implicit_Contact__c = con.id;
        projt.Installer_Email_Viewed__c = true;
        projt.Lead_Source__c = 'cold';
        insert projt;

        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.Project_Name__c = proj.id;
        opp.OwnerId = u.id;
        opp.AccountId = acc.id;
        opp.Amount = 1000;
        opp.Probability = 20;
        opp.StageName = 'Quote-Requested';
        opp.CloseDate = Date.today() + 10;
        Test.startTest();
        insert opp;
        opp.AccountId = acc1.id;
        update opp;
        Test.stopTest();

        List < OpportunityTeamMember > otml = new List < OpportunityTeamMember > ();

        OpportunityTeamMember otm = new OpportunityTeamMember();
        otm.Userid = usr.id;
        otm.Opportunityid = opp.id;
        otml.add(otm);
        insert otml[0];

        accountOwnerAssignment.assignoppowner(accSet);

    }
    static testMethod void myUnitTest5() {
    
    }
    

}