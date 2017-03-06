@isTest
public class ProjectSplitPageControllerOverRide_Test {
    
    public  static testMethod void myUnitTest() {
        
        profile p = [select id from Profile where name = 'Standard User'];
         
         User u = new User ( alias = 'testme', email = 'testme@noemail.com', emailencodingkey = 'UTF-8', lastname = 'test',languagelocalekey = 'en_US', 
         localesidkey = 'en_US', profileid = p.Id, country = 'United Kingdom', timezonesidkey = 'Europe/London', username = 'testme@noemail.com');
         insert u;
         
         list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
         zipCode1.City__c = 'Stow';
         zipCode1.Country__c = 'United States';
         zipCode1.State__c = 'Maine';
         zipCode1.Zip_Code__c = '12345' ;
         lstzipCode.add(zipCode1);
         insert  lstzipCode; 
         
         
         
         Account acc=new Account();
         acc.Name='test';
         acc.Phone='12345678';
         acc.BillingState = 'New York';
         acc.BillingCountry='United States';
         acc.BillingPostalCode ='12345';
         insert acc;
         
         contact con=new contact();
         //con.Name='test contact';
         con.Accountid=acc.id;
         con.FirstName = 'john';
         con.LastName = 'doe';
         con.MailingStreet = 'street';
         con.MailingCity = 'city'; 
         con.Mailingstate = 'Utah';
         con.MailingPostalCode = '12345';
         con.MailingCountryCode = 'US';
         insert con; 
         
                  
         
         list<Project__c> projList=new list<Project__c>();
         Project__c proj = new Project__c();
         proj.Name='Test Project';
         proj.OwnerId=u.id;
         proj.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
         proj.Actual_Project_Need_Date__c=date.today();
         proj.Amount__c=10;
         proj.Architect_Account__c=acc.id;
         proj.Architect_Considered__c=true;
         proj.Architect_On_Project__c=true;
         proj.Award_Date__c=date.today();
         proj.Bid_Date__c=date.today();
         proj.Budget_Quote_Provided__c=true;
         proj.Choices__c='NoValue';
         proj.Corporate_Account__c=true;
         proj.Dodge_Number__c='123';
         proj.End_Customer_Contact__c=con.id;
         proj.Implicit_Contact__c=con.id;
         proj.Installer_Email_Viewed__c=true;
         proj.Lead_Source__c='cold';
         proj.Model_Home__c=true;
         proj.Nearby_Showrooms__c=12;
         proj.Office_Interior__c=true;
         proj.OldProjectId__c='abc';
         proj.Opportunity_ID__c='test old';
         //proj.Opportunity_Name__c=opp1.id;
         proj.Estimated_Project_Need_Date__c=date.today();
         proj.Expected_Install_Date__c=date.today();
         proj.Expected_Open_Date__c=date.today();
         proj.Explicit_Score__c='a';
         proj.HighRise__c=true;
         proj.How_Many_Models__c='4';
         proj.Ordering_Account__c=acc.id;
         proj.Preliminary_Drawings_Date__c=date.today();
         proj.Preliminary_Drawings__c=true;
         proj.Project_Implicit_Score__c=5;
         proj.Project_State__c='Indiana';
         proj.Project_Street_Address__c='street address';
         proj.Project_Zip_Code__c='12345';
         proj.Ordering_Account__c=acc.id;
         proj.Project_Zip_Code__c='12345';
         projList.add(proj);
         insert projList;
        
        Project_Split__c ps=new Project_Split__c();
        //ps.Name='test';
        //ps.Amount__c=10;
        ps.Notes__c='project split note';
        ps.Account__c=acc.id;
        ps.Project__c=projList[0].id;
        insert ps;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ps);
        ProjectSplitPageControllerOverRide psp=new ProjectSplitPageControllerOverRide(sc);
        psp.redirect();
        
        
    
    }

}