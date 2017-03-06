@isTest
public class testbatchNoInfluencerOnProject {
        public static list < Zip_Codes_Master__c > territorymaster;
   
    static testmethod void method1(){
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        insert zipCode1;
        Account a = new Account();
        a.Name = 'Test Account';
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type ='Cost Consulting Firm';
        insert a;

            Project__c p1 = new Project__c();
             p1.Name = 'Test Project CompetitorHelper_Test';
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '12345' ; 
             p1.Architect_Account__c = null;
             p1.Close_Date__c = System.today();
        insert p1;
        test.startTest();
       String strRecordTypeId = label.Influencer_Opportunity_RecordTypeId;
       Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1';
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.AccountId = a.id;
        o.Project_Name__c = p1.id;
        o.RecordTypeId= strRecordTypeId;
        batchArchitectAccount en = new batchArchitectAccount();
        Database.executeBatch(en);
        test.stopTest();
    
    }
    /*static testmethod void method2(){
        territorymaster = TestDataUtility.getTerritoryMaster();
         insert territorymaster;
         list<Account> acclist = TestDataUtility.createAccountTestData();
         for(Integer k=0;k<acclist.size();k++){
            acclist[k].Type = 'Cost Consulting Firm';
        }
         insert acclist;
         /*list<Contact> conlist = TestDataUtility.createConTestData();
         insert conlist;*/
         /*list<Project__c> projlist = TestDataUtility.createProjectTestData();
        for(Integer i =0;i<projlist.size();i++){
            projlist[i].Architect_Account__c = null;
            projlist[i].Close_Date__c = System.today();
        }
        insert projlist;
        test.startTest();
        list<Opportunity>  opplist = TestDataUtility.createOppTestData();
        String strRecordTypeId = label.Influencer_Opportunity_RecordTypeId;
        for(Integer j = 0;j<opplist.size();j++){
            opplist[j].AccountId = acclist[j].id;
            opplist[j].Project_Name__c = projlist[j].id;
             opplist[j].RecordTypeId= strRecordTypeId;
            opplist[j].StageName = 'Drawings - Requested';
            
        }
        insert opplist;
        batchArchitectAccount en = new batchArchitectAccount();
        Database.executeBatch(en);
        test.stopTest();
    
    }*/
}