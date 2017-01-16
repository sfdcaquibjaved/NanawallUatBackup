@isTest
public class Lead_PreSaveTest {
    
    
    Static TestMethod Void PreSave()
    {
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
        
        List<Lead> li= TestDataUtility.createLeadTestData();
        insert li;
        
        test.startTest();
       
       // list<Lead> l1 = new list<Lead>();
        Lead L = new Lead();
        l.Phone = '(123) 456-7890';
        l.project_name__c = 'Test Proj';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        l.PostalCode = '08619';
        l.CountryCode = 'US';
        l.Type_of_record__c = 'Commercial';
        l.Project_Application_Industry__c = 'Automotive';
        l.Project_Application__c = 'Dealership';
        l.Project_Site_Zip_Code__c= '94040';
        Insert l;
        
        
        l.Email='bc2@gmail.com';
        update l;
        
       /*ead L2 = new Lead();
        l2.FirstName = 'John';
        l2.LastName = 'Mars';
        l2.Company ='Test Com';
        l2.Type__c ='Architect';
        l2.Status = 'Not Engaged';
        l2.Phone='+19569465986';
        l2.Country='United States';
        l2.State='Colorado';
        l2.Zip__c='08619';
       //2.IsConverted=True;
        l2.Email='abc1@gmail.com';
        Insert l2;
        l2.Email='abc2@gmail.com';
        update l2;
        
        Lead l13= new Lead();
        l13.FirstName = 'John';
        l13.LastName = 'Mars';
        l13.Company ='Test Com';
        l13.Type__c ='Architect';
        l13.Status = 'Not Engaged';
        l13.Country='United States';
        l13.State='california';
        l13.Zip__c='94094';
        l13.Phone='+19426205610';
        //3.IsConverted=True;
        l13.Email='abc3@gmail.com';
        Insert l13;
        l13.Email='abc4@gmail.com';
        Update l13;*/ 
        
        
        
        test.stopTest();
        
        
        
        
    }

    Static TestMethod Void PreSave2()
    {
     
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
        List<Lead> li= TestDataUtility.createLeadTestData();
        insert li;
        
         // list<Lead> l1 = new list<Lead>();
        Lead L = new Lead();
        l.Phone = '+123 456-7890';
        l.project_name__c = 'Test Proj';
        l.FirstName = 'testfirst';
        l.LastName = 'testlast';
        l.PostalCode = '08619';
        l.CountryCode = 'US';
        l.Company='Test Com';
        l.Email='abc4@yahoo.com';
        l.Type_of_record__c = 'Commercial';
        l.Project_Application_Industry__c = 'Automotive';
        l.Project_Application__c = 'Dealership';
        l.Project_Site_Zip_Code__c= '94040';
        Insert l;
        
       
        test.startTest();
        Lead L1 = new Lead();
        l1.Phone = '(123) 456-7856';
        l1.project_name__c = 'Test Proj';
        l1.FirstName = 'testfirst';
        l1.LastName = 'testlast';
        l1.PostalCode = '08619';
        l1.CountryCode = 'US';
        l1.Company='Test Com';
        l1.Email='abc4@yahoo.com';
        l1.Type_of_record__c = 'Commercial';
        l1.Project_Application_Industry__c = 'Automotive';
        l1.Project_Application__c = 'Dealership';
        l1.Project_Site_Zip_Code__c= '94040';
        
        
        
        try {
             Insert l1;
        } catch (Exception e) {
            System.debug('ERROR: A lead or contact already exists with this email address.' );
        }
        
       
        
        test.stopTest();
       
        
        
    }
    
    
}