@isTest
Private class TestCreateNewProjectExtension{
    Static testMethod void ProjectVfpage(){
        
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
    list<Account> acc =new list<Account>();
        Account a = new Account();
        a.Name='Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry='United States';
        a.BillingPostalCode='12345';
        a.type='Developer';
        acc.add(a);
              
    insert acc;
    list<Contact> con =new list<Contact>();
        Contact c = new Contact();
        c.Accountid=acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city'; 
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        con.add(c);

    insert con;
       
        
    list<Project__c> pro =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';

        pro.add(p);
        
    insert pro;
        
    //list<Project__c> pro1 =new list<Project__c>();
    Project__c pr = new Project__c();
        pr.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        pr.Name='xyz enterprise2';
        pr.Project_Zip_Code__c='';
        pr.Project_Country__c='Mexico';
        pr.Project_State__c='Chiapas';
        pr.Close_Date__c=Date.newInstance(2015, 12, 12);
        pr.Stage__c='Prospecting';
        //pro1.add(pr);
    insert pr;
      pr.Stage__c='Prospecting';
          
            pr.Project_Country__c='Canada';
            pr.Project_Zip_Code__c='V0A 9S9'; 
            try {
          Update pr;
        }
          catch (Exception ex) {
      System.Assert(ex.getMessage().contains('Update Failed'), 'Please enter a valid Zip code');
      }
    
        
        PageReference pageRef = Page.CreateNewProject;
        Test.setCurrentPageReference(pageRef); 
        ApexPages.CurrentPage().getparameters().put('contactID', con[0].Id);
        ApexPages.CurrentPage().getparameters().put('accountID', acc[0].Id);
                                          
        ApexPages.StandardController controller = new ApexPages.StandardController(pro[0]); 
        CreateNewProjectExtension cnpe = new CreateNewProjectExtension(Controller); 
        cnpe.projectTypeSelected = 'New';
        cnpe.recTypeSelected = 'Residential';
        cnpe.recTypeSelection();
        cnpe.getProjectType();
        cnpe.saveProject();
        cnpe.getRecType();
        cnpe.projectTypeSelection();
        cnpe.copyAddressFields();
  
        Project__c po =[select id from Project__c where Id =:pr.ID];
          po.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
      po.Stage__c='Prospecting';
            po.Project_Country__c='Canada';
            po.Project_Zip_Code__c='V0A 9J9';
          //po.RecordTypeId='012K0000000DKP0';
            //try {
          Update po;
        

        cnpe.projectTypeSelected = 'Existing';

        cnpe.recTypeSelected = 'Residential';
        cnpe.recTypeSelection();
        cnpe.saveProject();
        cnpe.projectTypeSelection();
        
        cnpe.projectTypeSelected = 'Existing';

        cnpe.recTypeSelected = 'Commercial';
        cnpe.recTypeSelection();
        cnpe.getProjectType();
        cnpe.saveProject();
        cnpe.getRecType();
        cnpe.projectTypeSelection();
        
        cnpe.copyAddressFields();
    
         
    }
    Static testMethod void ProjectVfpage2(){
         list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
    list<Account> acc =new list<Account>();
        Account a = new Account();
        a.Name='Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry='United States';
        a.BillingPostalCode='12345';
        a.type='Developer';
        acc.add(a);
        
    insert acc;
    list<Contact> con =new list<Contact>();
        Contact c = new Contact();
        c.Accountid=acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city'; 
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        con.add(c);
          
    insert con;
       
    list<Project__c> pro =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';

        pro.add(p);
        try{    
    insert pro;
        }catch (Exception e) {}
       
    list<Project__c> pro1 =new list<Project__c>();
    Project__c pr = new Project__c();
        pr.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        pr.Name='xyz enterprise2';
        pr.Project_Zip_Code__c='';
        pr.Project_Country__c='Mexico';
        pr.Project_State__c='Chiap';
        pr.Close_Date__c=Date.newInstance(2015, 12, 12);
        pr.Stage__c='Prospecting';
        pro1.add(pr);
        insert pr;
            
            pr.Stage__c='Prospecting';
            pr.Project_Country__c='Canada';
            pr.Project_Zip_Code__c='V0';
        try{   
          Update pr;
        }catch (Exception ex) {
      //System.Assert(ex.getMessage().contains('Update Failed'), 'Please enter a valid Zip code');
      }
        
      
        PageReference pageRef = Page.CreateNewProject;
        Test.setCurrentPageReference(pageRef); 
        ApexPages.CurrentPage().getparameters().put('contactID', con[0].Id);
        ApexPages.CurrentPage().getparameters().put('accountID', acc[0].Id);
                                          
        ApexPages.StandardController controller = new ApexPages.StandardController(pro[0]); 
        CreateNewProjectExtension cnpe = new CreateNewProjectExtension(Controller); 
        cnpe.projectTypeSelected = 'New';
        cnpe.recTypeSelected = 'Residential';
        cnpe.recTypeSelection();
        cnpe.getProjectType();
        cnpe.saveProject();
        cnpe.getRecType();
        cnpe.projectTypeSelection();
        cnpe.copyAddressFields();
        cnpe.validateFields();
  
        Project__c po =[select id from Project__c where Id =:pr.ID];
          po.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
          po.Stage__c='Prospecting';
            po.Project_Country__c='Canada';
            po.Project_Zip_Code__c='V0A 9J9';
          //po.RecordTypeId='012K0000000DKP0';
            //try 
          Update po;
          
    
        cnpe.projectTypeSelected = 'Existing';

        cnpe.recTypeSelected = 'Residential';
        cnpe.recTypeSelection();
        cnpe.getProjectType();
        cnpe.saveProject();
        cnpe.getRecType();
        cnpe.projectTypeSelection();
        cnpe.copyAddressFields();
        cnpe.validateFields();
        
        cnpe.projectTypeSelected = 'Existing';

        cnpe.recTypeSelected = 'Commercial';
        cnpe.recTypeSelection();
        cnpe.getProjectType();
        cnpe.saveProject();
        cnpe.getRecType();
        cnpe.projectTypeSelection();
        cnpe.copyAddressFields();
        cnpe.validateFields();
    
         
    }
    //Third Method
    
    Static testMethod void ProjectVfpage3(){
         list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
    list<Account> acc =new list<Account>();
        Account a = new Account();
        a.Name='Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry='United States';
        a.BillingPostalCode='12345';
        a.type='Developer';
        acc.add(a);
        
    insert acc;
    list<Contact> con =new list<Contact>();
        Contact c = new Contact();
        c.Accountid=acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city'; 
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        con.add(c);
        
    insert con;
       
    list<Project__c> pro =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';

        pro.add(p);
      
    insert pro;
       
        list<Opportunity> opp= new list<Opportunity>();
        Opportunity o= new Opportunity();
        o.AccountId=acc[0].id;
        o.Name='Test';
        o.StageName='Need Analysis';
        o.ForecastCategoryName='Pipeline';
        o.Expected_Resolution_Date_2__c=date.today();
        o.CloseDate=date.today();
        o.Project_Name__c=pro[0].id;
        
        opp.add(o);
        insert opp;
        
        
        
             
    list<Project__c> pro1 =new list<Project__c>();
    Project__c pr = new Project__c();
        pr.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        pr.Name='xyz enterprise2';
        pr.Project_Zip_Code__c='';
        pr.Project_Country__c='Mexico';
        pr.Project_State__c='Chiapas';
        pr.Close_Date__c=Date.newInstance(2015, 12, 12);
        pr.Stage__c='Prospecting';
        pro1.add(pr);
       
        insert pr;
       
      
        list<Opportunity> opp2= new list<Opportunity>();
        Opportunity o2= new Opportunity();
        o2.AccountId=acc[0].id;
        o2.Name='Test2';
        o2.StageName='Need Analysis';
        o2.ForecastCategoryName='Pipeline';
        o2.Expected_Resolution_Date_2__c=date.today();
        o2.CloseDate=date.today();
        o2.Project_Name__c=pro1[0].id;
        opp2.add(o2);
        insert opp2;
        
        
        PageReference pageRef = Page.CreateNewProject;
        Test.setCurrentPageReference(pageRef); 
        ApexPages.CurrentPage().getparameters().put('contactID', con[0].Id);
        ApexPages.CurrentPage().getparameters().put('accountID', acc[0].Id);
       
                                          
        ApexPages.StandardController controller = new ApexPages.StandardController(pro[0]); 
        CreateNewProjectExtension cnpe = new CreateNewProjectExtension(Controller); 
                 
        
        
        cnpe.projectTypeSelected = 'Existing';
        cnpe.recTypeSelected = 'residential';
        cnpe.getProjectType();
        cnpe.getRecType();
        cnpe.projectTypeSelection();
        cnpe.recTypeSelection();
        cnpe.copyAddressFields();
        cnpe.validateFields();
        cnpe.opp.Project_Name__c = pro[0].Id; 
        cnpe.saveProject();
        
     
      
        cnpe.projectTypeSelected = 'New';
        cnpe.recTypeSelected = 'Residential';
        cnpe.getProjectType();
        cnpe.getRecType();
        cnpe.projectTypeSelection();
        cnpe.recTypeSelection();
        cnpe.copyAddressFields();
        cnpe.validateFields();
        
        cnpe.saveProject();

        ApexPages.StandardController controller3 = new ApexPages.StandardController(pro1[0]); 
        CreateNewProjectExtension cnpe3 = new CreateNewProjectExtension(Controller3); 
        
          cnpe3.projectTypeSelected = 'Existing';
        cnpe3.recTypeSelected = 'commercial'; 
        cnpe3.getProjectType();
        cnpe3.getRecType();
        cnpe3.projectTypeSelection();
        cnpe3.recTypeSelection();
        cnpe3.copyAddressFields();
        cnpe3.validateFields();
        cnpe3.opp.Project_Name__c = pro1[0].Id; 
        cnpe3.saveProject();
    }
        
        //Fourth Method
    

   /* Static testMethod void ProjectVfpage6(){
         list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
    list<Account> acc =new list<Account>();
        Account a = new Account();
        a.Name='Abc corp';
        a.BillingState = 'New York';
        a.BillingCountry='United States';
        a.BillingPostalCode='12345';
        a.type='Developer';
        acc.add(a);
        
    insert acc;
    list<Contact> con =new list<Contact>();
        Contact c = new Contact();
        c.Accountid=acc[0].id;
        c.FirstName = 'john';
        c.LastName = 'doe';
        c.MailingStreet = 'street';
        c.MailingCity = 'city'; 
        c.Mailingstate = 'Utah';
        c.MailingPostalCode = '12345';
        c.MailingCountryCode = 'US';
        con.add(c);
          
    insert con;
        
        //list<Project__c> pro =new list<Project__c>();
    Project__c p=new Project__c();
        p.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='1235S';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Quoted';

        //pro.add(p);
        try{
        insert p;
        } catch(Exception e){
           //System.Assert(e.getMessage().contains('Insert Failed'), 'Please enter Zip code');
        }
  
        list<Opportunity> opp2= new list<Opportunity>();
        Opportunity o2= new Opportunity();
        o2.AccountId=acc[0].id;
        o2.Name='Test2';
        o2.StageName='Quote - Requested';
        o2.ForecastCategoryName='Pipeline';
        o2.Expected_Resolution_Date_2__c=date.today();
        o2.CloseDate=date.today();
        o2.Project_Name__c=p.id;
        opp2.add(o2);
        insert opp2;
        
        PageReference pageRef = Page.CreateNewProject;
        Test.setCurrentPageReference(pageRef); 
        ApexPages.CurrentPage().getparameters().put('contactID', con[0].Id);
        ApexPages.CurrentPage().getparameters().put('accountID', acc[0].Id);
       
        ApexPages.StandardController controller = new ApexPages.StandardController(p); 
        CreateNewProjectExtension cnpe = new CreateNewProjectExtension(Controller); 
        
        cnpe.projectTypeSelected = 'Existing';
        cnpe.recTypeSelected = 'residential';
        cnpe.getProjectType();
        cnpe.getRecType();
        cnpe.projectTypeSelection();
        cnpe.recTypeSelection();
        cnpe.copyAddressFields();
        cnpe.validateFields();
        cnpe.opp.Project_Name__c = p.Id; 
        cnpe.saveProject();
 
    } */
}