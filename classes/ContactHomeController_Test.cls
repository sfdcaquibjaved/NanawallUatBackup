@IsTest
public class ContactHomeController_Test {
    public boolean hasprevious;
    public boolean hasnext;
    public boolean Competitor;
    public string GetQuery;
    public string Total;
    public boolean whereonly;
    public static list<Account> olstAccount;
    public static list<Contact> olstContact;
    public static List < Zip_Codes_Master__c > olstTerritoryMastereCode;
    public static List < Country_codes__c > olstTestCountryCode;
    public static List < state_codes__c > olstTestStateCode;
    public static User olstuse;
    static testmethod void testmethod1() {
        
         PageReference pageRef = Page.ContactHome;
        Test.setCurrentPage(pageRef);
        
        /*olstAccount = TestDataUtility.createAccountTestData();
        insert olstAccount;
        olstContact = TestDataUtility.createConTestData();
        insert olstContact;
        olstTerritoryMastereCode = TestDataUtility.getTerritoryMaster();
         insert olstTerritoryMastereCode;
        
       profile p = [select id from Profile where name = 'Standard User'];
        User u = new User(alias = 'testme', email = 'testme@noemail.com', emailencodingkey = 'UTF-8', lastname = 'test', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = p.Id, country = 'United Kingdom', timezonesidkey = 'Europe/London', username = 'testme@noemail.com');
        insert u;
        
        list < Account > accList = new list < Account > ();
        Account acc = new Account();
        acc.Name = 'test';
        acc.OwnerId = u.id;
        acc.Phone = '12345678';
        acc.BillingState = 'New York';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = '12345';
        accList.add(acc);
       // acc1.add(acc);
        insert acc;
        
        list < Contact > conList = new list < Contact > ();
        contact con = new contact();
        con.Accountid = acc.id;
        con.FirstName = 'john';
        con.LastName = 'doe';
        con.address_1__c = 'New York';
        con.Address_2__c = 'New York';
        con.City__c = 'abc';
        con.State_Abbr__c = 'NY';
        con.State__c = 'Maine';
        con.Zip__c = '12345';
        con.repeat_customer__c=true;
        con.Country__c = 'US';
        con.Phone = '563256';
        con.Fax = '563256';
        con.Email = 'test@test.com';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.Mailingstate = 'New York';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        conList.add(con);
        insert con;*/
        
       // ApexPages.StandardController sc = new ApexPages.StandardController(con);
      //  ContactHomeController con1=new ContactHomeController(sc);
        
        ContactHomeController chc=new ContactHomeController();
        //chc.whereonly=true;
       chc.GetQuery(true);
        chc.hasprevious=true;
        chc.hasnext=true;
      chc.Competitor=true;
        //chc.Total();
        chc.previous();
        chc.next();
        chc.myaction();
        chc.primeSearch();
        chc.doSort();
        chc.reset();
        chc.gotonew();
        
        List < SelectOption > getlety = chc.getLeadTypes();
        List < SelectOption > getlein = chc.getLeadInterests();
        List < SelectOption > getlesr = chc.getLeadSources();
        List < SelectOption > getterr = chc.getTerritories();
        List < SelectOption > getcoun = chc.getCountries();
        List < SelectOption > getstate = chc.getStates();
    }
     static testmethod void testmethod2() {
         PageReference pageRef = Page.ContactHome;
        Test.setCurrentPage(pageRef);
         
         /*olstAccount = TestDataUtility.createAccountTestData();
         insert olstAccount;
		*/
         
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
         
        list < Account > accList = new list < Account > ();
        Account acc = new Account();
        acc.Name = 'test';
        acc.OwnerId = olstuse.id;
        acc.Phone = '12345678';
        acc.BillingState = 'New York';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = '12345';
        accList.add(acc);
       // acc1.add(acc);
        insert accList;
         
        olstContact = TestDataUtility.createConTestData();
         insert olstContact;
        
        list < Contact > conList = new list < Contact > ();
        contact con = new contact();
        con.Accountid = accList[0].id;
        con.FirstName = 'john';
        con.LastName = 'doe';
        con.address_1__c = 'abcd';
        con.Address_2__c = 'hyd';
        con.Country__c = 'US';
        con.State_Abbr__c = 'asd';
        con.State__c = 'Connecticut';
        con.City__c = 'abc';
        con.Zip__c = '12345';
        con.repeat_customer__c=true;
       
        con.Phone = '563256';
        con.Fax = '563256';
        con.Email = 'test@test.com';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.Mailingstate = 'Utah';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        conList.add(con);
        insert conList;
        
       //ApexPages.StandardController sc = new ApexPages.StandardController(con);
       // ContactHomeController con1=new ContactHomeController(sc);
        
        ContactHomeController chc=new ContactHomeController();
        //chc.whereonly=true;
       chc.GetQuery(false);
        chc.hasprevious=true;
        chc.hasnext=true;
       chc.Competitor=true;
        //chc.Total();
        chc.previous();
        chc.next();
        chc.myaction();
        chc.primeSearch();
        chc.doSort();
        chc.reset();
        chc.gotonew();
        
        List < SelectOption > getlety = chc.getLeadTypes();
        List < SelectOption > getlein = chc.getLeadInterests();
        List < SelectOption > getlesr = chc.getLeadSources();
        List < SelectOption > getterr = chc.getTerritories();
        List < SelectOption > getcoun = chc.getCountries();
        List < SelectOption > getstate = chc.getStates();
    }
}