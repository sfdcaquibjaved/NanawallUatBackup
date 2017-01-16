@istEST
public class ServiceQuote_Search_Controller_test {
    /*public static testMethod void mytest1(){
        
          profile p = [select id from Profile where name = 'Standard User'];
        User u = new User(alias = 'testme', email = 'testme@noemail.com', emailencodingkey = 'UTF-8', lastname = 'test', languagelocalekey = 'en_US',
            localesidkey = 'en_US', profileid = p.Id, country = 'United Kingdom', timezonesidkey = 'Europe/London', username = 'testme@noemail.com');
        insert u;

        list < Zip_Codes_Master__c > lstzipCode = new list < Zip_Codes_Master__c > ();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345';
        zipcode1.User__c = u.id;
        lstzipCode.add(zipCode1);
        insert lstzipCode;

        Account acc = new Account();
        acc.Name = 'test';
        acc.Phone = '12345678';
        acc.BillingState = 'New York';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = '12345';
        acc.Certified_Installer__c = true;
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
        con.Last_Mailbook_Sent__c = system.now();
        con.Last_Booklet_Sent__c = null;
        con.Last_Binder_Sent__c = system.now();
        con.Send_Booklet__c = false;
        con.Phone = '563256';
        con.Fax = '563256';
        con.Email = 'test@test.com';
        con.MailingStreet = 'street';
        con.MailingCity = 'city';
        con.Mailingstate = 'Utah';
        con.MailingPostalCode = '12345';
        con.MailingCountryCode = 'US';
        con.OwnerId = u.id;
        insert con;

        test.startTest();
        list < Project__c > proList = new list < Project__c > ();
        Project__c pro = new Project__c();
        pro.RecordTypeId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        pro.Name = 'xyz enterprise';
        pro.Project_Zip_Code__c = '12345';
        pro.Project_Country__c = 'United States';
        pro.Close_Date__c = Date.newInstance(2015, 12, 12);
        pro.Stage__c = 'Prospecting';
        proList.add(pro);
        insert proList;




        Service_Part__c sp = new Service_Part__c();
        sp.Is_Installer_Part__c = true;
        sp.Location__c = 4.00;
        sp.Part_Name__c = 'abcd';
        insert sp;

        
        list < Opportunity > lstOpps = TestDataUtility.createOppTestData();
        Opportunity testOpp = lstOpps[0];
        testOpp.AccountId = acc.id;
        testOpp.Project_Name__c = proList[0].id;
        insert testOpp;

        quote__c q = new quote__c();
        q.Name = 'TestQuote4';
        q.Contact__c = con.id;
        q.Opportunity__c = lstOpps[0].Id;
        insert q;

        case c = new case ();
        //cases[0].Who_is_Calling__c = 'Architect';
        c.AccountId = acc.id;
        c.ContactId = con.id;
        c.Dummy__c = false;
        c.Quote__c = q.id;
        insert c;


        Service_Quote__c sq = new Service_Quote__c();
        sq.Deposit_Date__c = system.today();
        sq.Case__c = c.id;
        insert sq;
        
         Quote_Detail__c qd=new Quote_Detail__c();
         qd.Quote__c=q.Id;
         qd.Configuration__C='3L0R';
         qd.Model__c='HSW 60';
         qd.Panels__c = 09;
         
         insert qd;

        Service_Quote_Detail__c sqd = new Service_Quote_Detail__c();
        sqd.Notes__c = 'abcde';
        sqd.Service_Quote__c = sq.Id;
        sqd.Service_Part__c = sp.Id;
        insert sqd;


        
        ServiceQuote_Search_Controller ssc = new ServiceQuote_Search_Controller();
        ServiceQuote_Search_Controller.ServiceQuoteEntry st1 = new ServiceQuote_Search_Controller.ServiceQuoteEntry();
        ServiceQuote_Search_Controller.ServiceQuoteSearchResult st2=new ServiceQuote_Search_Controller.ServiceQuoteSearchResult();
        List<SelectOption> list1 = ssc.getStates();
        ssc.dosort();
        ssc.SearchObjects();
        test.stopTest();
            
        
    }*/

}