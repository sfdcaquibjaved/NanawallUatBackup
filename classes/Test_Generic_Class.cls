@isTest
private class Test_Generic_Class {
    static testMethod void Test_AccountHomeController() {
        List<Account> listAcc = new List<Account>();
        Account a = new Account();
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.Country__c = 'United States';
        a.BillingCountry = 'United States';
        a.BillingPostalCode = '08619';
        a.Zip__c = '08619';
        a.BillingState = 'Utah';
        a.Description = 'test description';
        listAcc.add(a);
        
        Account a1 = new Account();
        a1.Phone = '(123) 456-7890';
        a1.Name = 'Test account';
        a1.Country__c = 'United States';
        a1.BillingCountry = 'United States';
        a1.BillingPostalCode = '08619';
        a1.Zip__c = '08619';
        a1.BillingState = 'Utah';
        a1.Description = '';
        listAcc.add(a1);
        INSERT listAcc;
        
        Test.StartTest();
            //Set the current VF page whose controller is being tested
            PageReference pageRef = Page.AccountHome;
            Test.setCurrentPage(pageRef);          
             
            //Invoke the constructor of the controller class by first creating an instance of Standard Controller
            //ApexPages.StandardController sc1 = new ApexPages.StandardController(a);
            AccountHomeController ahc = new AccountHomeController();
            ahc.primeSearch();
            ahc.reset();
            
            ahc.State = 'Utah';
            ahc.Country = 'United States';
            ahc.Address = 'Test Address';
            ahc.City = 'Utah City';
            ahc.Zip = '08619';
            ahc.Phone = '9876543221';
            ahc.email = 'emial@emailtest.com';
            //ahc.getmyAccounts();
            ahc.getQuery(true);
            ahc.getQuery(false);
            ahc.doSort();
            
            ahc.getStates();
            ahc.getCountries();
            ahc.gotonew();
            //ahc.previous();
            //ahc.next();
        Test.StopTest();
    }
   

    static testMethod void Test_Account_NormalizeFields() {
        Account a = new Account();
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.City__c = 'Utah City';
        a.Country__c = 'United States';
        a.State__c = 'Utah';
        a.Zip__c = '08619';
        a.BillingCountry = 'United States';
        a.BillingPostalCode = '08619';
        a.BillingStreet = 'Test Street';
        a.BillingState = 'Utah';
        a.BillingCity = 'Test City 1';
        a.Description = 'test description';
        INSERT a;
        
        Account a1 = new Account();
        a1.Phone = '(123) 456-7890';
        a1.Name = 'Test account';
        a1.City__c = 'Utah City';
        a1.Country__c = 'United States';
        a1.State__c = 'Utah';
        a1.Zip__c = '08619';
        a1.BillingCountry = 'United States';
        a1.BillingPostalCode = '08619';
        a1.BillingStreet = 'Test Street 2 \n Test Street 55';
        a1.BillingState = 'Utah';
        a1.BillingCity = 'Test City 2';
        a1.Description = 'test description 2';
        INSERT a1;
         
        Test.StartTest();
            a.BillingCity = 'Test City 2'; 
            a.BillingStreet = 'Test Street2 \n Test Street 3';
            a.BillingCountry = 'India';
            a.BillingPostalCode = '08619';
            a.BillingState = 'Assam';
            UPDATE a;
            
            a1.BillingStreet = 'Test Street2 \n Test Street 3';
            UPDATE a1;
        Test.StopTest();
    }
}