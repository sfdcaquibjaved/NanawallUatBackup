@isTest
private class ProjectspiltControllerTest {

   static testMethod void myUnitTest() {
      //test.startTest();
      list<Country_codes__c> lstCountryCode = TestDataUtility.getTestCountryCodes();
        insert lstCountryCode;
                list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
      list<Account> acc =TestDataUtility.createAccountTestData();
       acc[0].BillingStreet='North End';
       acc[0].BillingCity='Calif'; 
       acc[0].BillingCountry='United States';
       acc[0].Type='Interior Designer';
       try{
       insert acc;
       }
       catch(Exception e){}
      LIST<Project__c> lstTestProjs = TestDataUtility.createProjectTestData();
       lstTestProjs[0].Architect_Account__c =acc[0].id;
       //lstTestProjs[1].Architect_Account__c =acc[0].id;
       try{
         insert lstTestProjs;
         }
         catch(Exception e){}
      
      list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(Project_Split__c newSplits : newSplit){
         newSplits.Project__c = lstTestProjs[0].Id ;
         newSplits.Split__c = 0.0 ;
         newSplits.Account__c =acc[0].id;
         newSplits.Project_Rep__c = Userinfo.getUserId();
         newSplit.add(newSplits);
         }
         try{
       insert newSplit ;
       }
       catch(Exception e){}
     
       PageReference pageRef = Page.ProjectSplitPage;
            Test.setCurrentPageReference(pageRef);
       
       ApexPages.StandardController controller = new ApexPages.StandardController(lstTestProjs[0]); 
         ProjectSplitController psc = new ProjectSplitController(Controller);
            psc.Save();
            psc.addRow();
            try{
       ApexPages.currentPage().getParameters().put('rowIndex','2');
            psc.deleteRow();
       }
       catch(Exception e){}
            boolean t = psc.validateProjectSplit(newSplit);
          //boolean t1 = psc.validateProjectSplit(newSplit1);
   }
static testMethod void myUnitTest2() {
      
      /* list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode;*/
      
             list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
       //test.startTest();
      //list<Country_codes__c> lstCountryCode = TestDataUtility.getTestCountryCodes();
      list<Country_codes__c> lstCountryCode = new list<Country_codes__c>();
      Country_codes__c couCode1 = new Country_codes__c();
     couCode1.Name = 'US';
     couCode1.Country__c = 'United States';
     lstCountryCode.add(couCode1);
     
     Country_codes__c couCode2 = new Country_codes__c();
     couCode2.Name = 'CA';
     couCode2.Country__c = 'Canada';
     lstCountryCode.add(couCode2);
      
     Country_codes__c couCode3 = new Country_codes__c();
     couCode3.Name = 'MX';
     couCode3.Country__c = 'Mexico';
     lstCountryCode.add(couCode3);
     
     Country_codes__c couCode4 = new Country_codes__c();
     couCode4.Name = 'IN';
     couCode4.Country__c = 'India';
     lstCountryCode.add(couCode4);
      
        insert lstCountryCode;
       
     // list<Account> acc =TestDataUtility.createAccountTestData();
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
       
       
     /* LIST<Project__c> lstTestProjs = TestDataUtility.createProjectTestData();
       lstTestProjs[0].Architect_Account__c =accountlst[0].id;
       //lstTestProjs[1].Architect_Account__c =acc[0].id;
       try{
         insert lstTestProjs;
         }
         catch(Exception e){}*/
         
         list<Project__c> projlst = new list<Project__c>();
        
        
            Project__c p1 = new Project__c();
            //p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ;
             p1.Project_Country__c='United States';
             p1.Architect_Account__c =accountlst[0].id;
             
             projlst.add(p1);
             
             insert projlst;
         
         
         
      
      list<Project_Split__c> newSplit = new list<Project_Split__c>();
         For(Project_Split__c newSplits : newSplit){
         newSplits.Project__c = projlst[0].Id ;
         newSplits.Split__c = 0.0 ;
         newSplits.Account__c =accountlst[0].id;
         newSplits.Notes__c='test';
         //newSplits.Amount__c=120;
         newSplits.Project_Rep__c = Userinfo.getUserId();
         newSplits.Role__c='test';
         newSplit.add(newSplits);
         }
         try{
       insert newSplit ;
       }
       catch(Exception e){}
     
       PageReference pageRef = Page.ProjectSplitPage;
            Test.setCurrentPageReference(pageRef);
       
       ApexPages.StandardController controller = new ApexPages.StandardController(projlst[0]); 
         ProjectSplitController psc = new ProjectSplitController(Controller);
            psc.Save();
            psc.addRow();
            
       ApexPages.currentPage().getParameters().put('rowIndex','0');
            psc.deleteRow();
       
       
            boolean t = psc.validateProjectSplit(newSplit);
          //boolean t1 = psc.validateProjectSplit(newSplit1);
   }

}