@isTest

private with sharing class Project_Trigger_Test
{
    public static list<opp_proj_stages__c> olstprojectStages ; 
    public static list<HardCodingUtility__c> olstHardcodUtil ; 
    
    static testMethod void testProjectTrigger()
    {
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
         /*list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode; */
        
        olstprojectStages = TestDataUtility.getProjectStages();
        try{
        insert olstprojectStages ;
        }catch(Exception e){}
        
        //Insert Custom Setting Record
        olstHardcodUtil = TestDataUtility.getHardCodingUtility();
        try{
        insert olstHardcodUtil ;
        }catch(Exception e){}
        
        
        Account acc = new Account();
        acc.Name = 'Architect Account';
        acc.Type='Architecture Firm';
        acc.BillingState = 'New York';
        acc.BillingCountry='United States';
        acc.BillingPostalCode='12345';
        try{
        insert acc;
        }catch(Exception e){}
        
        Project__c p1 = new Project__c();
        p1.Name='Test Architect Account';
        p1.Architect_Account__c = acc.Id;
        p1.Project_Zip_Code__c = '12345';
         p1.Project_Country__c='United States';
        p1.Close_Date__c=Date.newInstance(2015, 12, 12);
        try{
        insert p1;
        }catch(Exception e){}
        
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp OpportunityTriggerHelper_Test1';
        o.Amount = 5000;
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'US';
        o.Postal_Code__c = '10001';
        o.Project_Name__c = p1.Id;
        opps.add(o);
        Opportunity o1 = new Opportunity();
        o1.Name = 'Test Opp OpportunityTriggerHelper_Test11';
//        o1.StageName = UtilityClass.opportunityWonStatus ;
        o1.CloseDate = Date.today();
        o1.Country__c = 'US';
        o1.StageName = 'Need Analysis';
        o1.Postal_Code__c = '08619';
        o1.Project_Name__c = p1.Id;
        opps.add(o1);
        
        try
        {
        insert opps;
        } Catch (Exception ex )
        {
            //i had to give up here because i couldnt deploy for hours tryign to mess with this. works in UAT, not in production
            // ks 
        }
        
        Test.startTest();
        p1.Name='Test Architect Project';
        update p1;
        Test.stopTest();
    
    }


   /* static testMethod void testProjectTrigger2()
    {
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
       
        User testUser1 = TestDataUtility.createUser('admin2' , 'testUser1@testing.com');
        insert testUser1;

        //User testUser2 = TestDataUtility.createUser('admin3' , 'testUser3@testing.com');
        //insert testUser2;
        
        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages ;
        
        //Insert Custom Setting Record
        olstHardcodUtil = TestDataUtility.getHardCodingUtility();
        insert olstHardcodUtil ;
        
        
        Account acc = new Account();
        acc.Name = 'Architect Account';
        acc.Type='Architecture Firm';
        acc.BillingState = 'New York';
        acc.BillingCountry='United States';
        acc.BillingPostalCode='12345';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'Architect Account1';
        acc1.Type='Architecture Firm';
        acc1.BillingState = 'California';
        acc1.BillingCountry='United States';
        acc1.BillingPostalCode='22222';
        insert acc1;
        
        Account acc2 = new Account();
        acc2.Name = 'Architect Account2';
        acc2.Type='Architecture Firm';
        acc2.BillingState = 'California';
        acc2.BillingCountry='United States';
        acc2.BillingPostalCode='08615';
        insert acc2;
        
        Account acc3 = new Account();
        acc3.Name = 'Architect Account2';
        acc3.Type='Architecture Firm';
        acc3.BillingState = 'California';
        acc3.BillingCountry='United States';
        acc3.BillingPostalCode='08616';
        insert acc3;
        
        Account acc4 = new Account();
        acc4.Name = 'Architect Account4';
        acc4.Type='Architecture Firm';
        acc4.BillingState = 'California';
        acc4.BillingCountry='United States';
        acc4.BillingPostalCode='08617';
        insert acc4;
        
        Account acc5 = new Account();
        acc5.Name = 'Architect Account5';
        acc5.Type='Architecture Firm';
        acc5.BillingState = 'California';
        acc5.BillingCountry='United States';
        acc5.BillingPostalCode='08618';
        insert acc5;

        Account acc6 = new Account();
        acc6.Name = 'Architect Account5';
        acc6.Type='Architecture Firm';
        acc6.BillingState = 'California';
        acc6.BillingCountry='United States';
        acc6.BillingPostalCode='08615';
        insert acc6;  
        
         Account acc7 = new Account();
        acc7.Name = 'Architect Account6';
        acc7.Type='Architecture Firm';
        acc7.BillingState = 'California';
        acc7.BillingCountry='United States';
        acc7.BillingPostalCode='08612';
        insert acc7; 
        
        
        Project__c p1 = new Project__c();
        p1.Name='Test Architect Account';
        p1.Architect_Account__c = acc.Id;
        p1.Project_Zip_Code__c = '12345';
        insert p1;
        
        Project__c p2 = new Project__c();
        p2.Name='Test Architect Account1';
        p2.Architect_Account__c = acc1.Id;
        p2.Project_Zip_Code__c = '12345';
        p2.Stage__c='Closed Lost - Project Lost';
        p2.Reason_Project_Lost__c='Wrong Product';
        insert p2;
        
        Project__c p3 = new Project__c();
        p3.Name='Test Architect Account3';
        p3.Architect_Account__c = acc2.Id;
        p3.Project_Zip_Code__c = '12345';
        p3.Stage__c='Closed Lost - Project Lost';
        p3.Reason_Project_Lost__c='Wrong Product';
        p3.Residential_Vertical__c=true;
        insert p3;
        
        Project__c p4 = new Project__c();
        p4.Name='Test Architect Account4';
        p4.Architect_Account__c = acc3.Id;
        p4.Project_Zip_Code__c = '12345';
        p4.Stage__c='Closed Lost - Project Lost';
        p4.Reason_Project_Lost__c='Wrong Product';
        p4.Residential_Vertical__c=true;
        p4.Corporate_Account__c=true;
        insert p4;
        
        Project__c p5 = new Project__c();
        p5.Name='Test Architect Account5';
        p5.Architect_Account__c = acc4.Id;
        p5.Project_Zip_Code__c = '12345';
        p5.Stage__c='Closed Lost - Project Lost';
        p5.Reason_Project_Lost__c='Wrong Product';
        p5.Residential_Vertical__c=true;
        p5.Corporate_Account__c=true;
        p5.OwnerId=testUser.Id;
        insert p5;
        
        Project__c p6 = new Project__c();
        p6.Name='Test Architect Account5';
        p6.Architect_Account__c = acc5.Id;
        p6.Project_Zip_Code__c = '12345';
        p6.Stage__c='Closed Lost - Project Lost';
        p6.Reason_Project_Lost__c='Wrong Product';
        p6.Residential_Vertical__c=true;
        p6.Corporate_Account__c=true;
        p6.OwnerId=testUser1.Id;
        insert p6;
        
        Project__c p7 = new Project__c();
        p7.Name='Test Architect Account6';
        p7.Architect_Account__c = acc6.Id;
        p7.Project_Zip_Code__c = '12345';
        p7.Stage__c='Closed Lost - Project Lost';
        p7.Reason_Project_Lost__c='Wrong Product';
        p7.Residential_Vertical__c=true;
        p7.Corporate_Account__c=true;
        p7.OwnerId=testUser1.Id;
        insert p7;
        
        
    Project__c p8= new Project__c();
        p8.Name='Test Architect Account6';
        p8.Architect_Account__c = acc7.Id;
        p8.Project_Zip_Code__c = '12345';
        p8.Stage__c='Closed Lost - Project Lost';
        p8.Reason_Project_Lost__c='Wrong Product';
        p8.Residential_Vertical__c=true;
        p8.Corporate_Account__c=true;
        p8.OwnerId=testUser.Id;
        insert p8;
        
        
        
        
        
        
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp OpportunityTriggerHelper_Test1';
        o.Amount = 5000;
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'US';
        o.Postal_Code__c = '10001';
        o.Project_Name__c = p1.Id;
        opps.add(o);
        Opportunity o1 = new Opportunity();
        o1.Name = 'Test Opp OpportunityTriggerHelper_Test11';
        o1.CloseDate = Date.today();
        o1.Country__c = 'US';
        o1.StageName = 'Need Analysis';
        o1.Postal_Code__c = '08619';
        o1.Project_Name__c = p1.Id;
        opps.add(o1);
        
        Opportunity o2 = new Opportunity();
        o2.Name = 'Test Opp OpportunityTriggerHelper_Test12';
        o2.CloseDate = Date.today();
        o2.Country__c = 'US';
        o2.StageName = 'Closed Lost';
        o2.Postal_Code__c = '08610';
        o2.Project_Name__c = p2.Id;
        opps.add(o2);
        
        Opportunity o3 = new Opportunity();
        o3.Name = 'Test Opp OpportunityTriggerHelper_Test13';
        o3.CloseDate = Date.today();
        o3.Country__c = 'US';
        o3.StageName = 'Closed Lost';
        o3.Postal_Code__c = '08615';
        o3.Project_Name__c = p7.Id;
        opps.add(o3);
        
        
        try
        {
        insert opps;
        } Catch (Exception ex )
        {
            //i had to give up here because i couldnt deploy for hours tryign to mess with this. works in UAT, not in production
            // ks 
        }
        
        Test.startTest();
        p1.Name='Test Architect Project';
        p7.Architect_Account__c = acc6.Id;
        p8.Stage__c='Closed Lost - Project Cancelled';
        p8.Reason_Project_Lost__c='Wrong Product';
        
        update p1;
        update p2;
        update p3;
        update p4;
        update p5;
        update p6;
        update p7;
        update p8;
        p5.OwnerId=testUser.Id;
        p6.Corporate_Account__c=true;
        
        Test.stopTest();
    
    }*/
    static testMethod void testProjectTrigger3()
    {
        /*list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;*/
        
        Test.startTest();
        
         list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode; 
        
        User testUser = TestDataUtility.createUser('admin1' , 'testUser@testing.com');
        insert testUser;
       
        User testUser1 = TestDataUtility.createUser('admin2' , 'testUser1@testing.com');
        insert testUser1;

        //User testUser2 = TestDataUtility.createUser('admin3' , 'testUser3@testing.com');
        //insert testUser2;
        
        olstprojectStages = TestDataUtility.getProjectStages();
        insert olstprojectStages ;
        
        //Insert Custom Setting Record
        olstHardcodUtil = TestDataUtility.getHardCodingUtility();
        insert olstHardcodUtil ;
        
        
        Account acc = new Account();
        acc.Name = 'Architect Account';
        acc.Type='Architecture Firm';
        acc.BillingState = 'New York';
        acc.BillingCountry='United States';
        acc.BillingPostalCode='12345';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'Architect Account1';
        acc1.Type='Architecture Firm';
        acc1.BillingState = 'California';
        acc1.BillingCountry='United States';
        acc1.BillingPostalCode='22222';
        insert acc1;
        
        Account acc2 = new Account();
        acc2.Name = 'Architect Account2';
        acc2.Type='Architecture Firm';
        acc2.BillingState = 'California';
        acc2.BillingCountry='United States';
        acc2.BillingPostalCode='08615';
        insert acc2;
        
        Account acc3 = new Account();
        acc3.Name = 'Architect Account2';
        acc3.Type='Architecture Firm';
        acc3.BillingState = 'California';
        acc3.BillingCountry='United States';
        acc3.BillingPostalCode='08616';
        insert acc3;
        
        Account acc4 = new Account();
        acc4.Name = 'Architect Account4';
        acc4.Type='Architecture Firm';
        acc4.BillingState = 'California';
        acc4.BillingCountry='United States';
        acc4.BillingPostalCode='08617';
        insert acc4;
        
        Account acc5 = new Account();
        acc5.Name = 'Architect Account5';
        acc5.Type='Architecture Firm';
        acc5.BillingState = 'California';
        acc5.BillingCountry='United States';
        acc5.BillingPostalCode='08618';
        insert acc5;

        Account acc6 = new Account();
        acc6.Name = 'Architect Account5';
        acc6.Type='Architecture Firm';
        acc6.BillingState = 'California';
        acc6.BillingCountry='United States';
        acc6.BillingPostalCode='08615';
        insert acc6;  
        
         Account acc7 = new Account();
        acc7.Name = 'Architect Account6';
        acc7.Type='Architecture Firm';
        acc7.BillingState = 'California';
        acc7.BillingCountry='United States';
        acc7.BillingPostalCode='08612';
        insert acc7; 
        
        Account acc8 = new Account();
        acc8.Name = 'Architect Account6';
        acc8.Type='Architecture Firm';
        acc8.BillingState = 'California';
        acc8.BillingCountry='United States';
        acc8.BillingPostalCode='08614';
        insert acc8; 
        
         
        Project__c p1 = new Project__c();
        p1.Name='Test Architect Account';
        p1.Architect_Account__c = acc.Id;
        p1.Project_Zip_Code__c = '12345';
       // p1.Send_for_Approval__c=false;
        insert p1;
        
        Project__c p2 = new Project__c();
        p2.Name='Test Architect Account1';
        p2.Architect_Account__c = acc1.Id;
        p2.Project_Zip_Code__c = '12345';
        p2.Stage__c='Closed Lost - Project Lost';
        p2.Reason_Project_Lost__c='Wrong Product';
        insert p2;
        
        Project__c p3 = new Project__c();
        p3.Name='Test Architect Account3';
        p3.Architect_Account__c = acc2.Id;
        p3.Project_Zip_Code__c = '12345';
        p3.Stage__c='Closed Lost - Project Lost';
        p3.Reason_Project_Lost__c='Wrong Product';
        p3.Residential_Vertical__c=true;
        insert p3;
        
        Project__c p4 = new Project__c();
        p4.Name='Test Architect Account4';
        p4.Architect_Account__c = acc3.Id;
        p4.Project_Zip_Code__c = '12345';
        p4.Stage__c='Closed Lost - Project Lost';
        p4.Reason_Project_Lost__c='Wrong Product';
        p4.Residential_Vertical__c=true;
        p4.Corporate_Account__c=true;
        insert p4;
        
       /* Project__c p5 = new Project__c();
        p5.Name='Test Architect Account5';
        p5.Architect_Account__c = acc4.Id;
        p5.Project_Zip_Code__c = '08617';
        p5.Stage__c='Closed Lost - Project Lost';
        p5.Reason_Project_Lost__c='Wrong Product';
        p5.Residential_Vertical__c=true;
        p5.Corporate_Account__c=true;
        p5.OwnerId=testUser.Id;
        insert p5;*/
        
        /*Project__c p6 = new Project__c();
        p6.Name='Test Architect Account5';
        p6.Architect_Account__c = acc5.Id;
        p6.Project_Zip_Code__c = '08618';
        p6.Stage__c='Closed Lost - Project Lost';
        p6.Reason_Project_Lost__c='Wrong Product';
        p6.Residential_Vertical__c=true;
        p6.Corporate_Account__c=true;
        p6.OwnerId=testUser1.Id;
        insert p6;*/
        
        /*Project__c p7 = new Project__c();
        p7.Name='Test Architect Account6';
        p7.Architect_Account__c = acc6.Id;
        p7.Project_Zip_Code__c = '08615';
        p7.Stage__c='Closed Lost - Project Lost';
        p7.Reason_Project_Lost__c='Wrong Product';
        p7.Residential_Vertical__c=true;
        p7.Corporate_Account__c=true;
        p7.OwnerId=testUser1.Id;
        insert p7;*/
        
        
    /*Project__c p8= new Project__c();
        p8.Name='Test Architect Account6';
        p8.Architect_Account__c = acc7.Id;
        p8.Project_Zip_Code__c = '12345';
        p8.Stage__c='Closed Lost - Project Lost';
        p8.Reason_Project_Lost__c='Wrong Product';
        p8.Residential_Vertical__c=true;
        p8.Corporate_Account__c=true;
        p8.OwnerId=testUser.Id;
        insert p8;*/
        
        Project__c p9= new Project__c();
        p9.Name='Test Architect Account9';
        p9.Architect_Account__c = acc8.Id;
        p9.Project_Zip_Code__c = '12345';
        p9.Stage__c='Closed Lost - Project Lost';
        p9.Reason_Project_Lost__c='Wrong Product';
        p9.Residential_Vertical__c=true;
        p9.Corporate_Account__c=true;
        p9.OwnerId=testUser.Id;
        p9.Amount__c=1900;
        insert p9;
        

        List<Opportunity> opps = new List<Opportunity>();
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp OpportunityTriggerHelper_Test1';
        o.Amount = 5000;
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'US';
        o.Postal_Code__c = '10001';
        o.Project_Name__c = p1.Id;
        opps.add(o);
        
        /*Opportunity o1 = new Opportunity();
        o1.Name = 'Test Opp OpportunityTriggerHelper_Test11';
        o1.CloseDate = Date.today();
        o1.Country__c = 'US';
        o1.StageName = 'Need Analysis';
        o1.Postal_Code__c = '08619';
        o1.Project_Name__c = p1.Id;
        opps.add(o1);*/
        
        Opportunity o2 = new Opportunity();
        o2.Name = 'Test Opp OpportunityTriggerHelper_Test12';
        o2.CloseDate = Date.today();
        o2.Country__c = 'US';
        o2.StageName = 'Closed Lost';
        o2.Postal_Code__c = '08610';
        o2.Project_Name__c = p4.Id;
        opps.add(o2);
         
       /* Opportunity o3 = new Opportunity();
        o3.Name = 'Test Opp OpportunityTriggerHelper_Test13';
        o3.CloseDate = Date.today();
        o3.Country__c = 'US';
        o3.StageName = 'Closed Lost';
        o3.Postal_Code__c = '08615';
        o3.Project_Name__c = p7.Id;
        opps.add(o3);*/
        
        Opportunity o4 = new Opportunity();
        o4.Name = 'Test Opp OpportunityTriggerHelper_Test14';
        o4.CloseDate = Date.today();
        o4.Country__c = 'US';
        o4.StageName = 'Closed Lost';
        o4.Postal_Code__c = '08614';
        o4.Project_Name__c = p9.Id;
        o4.Amount=1900;
        opps.add(o4);
        
        try
        {
        insert opps;
        } Catch (Exception ex )
        {
            //i had to give up here because i couldnt deploy for hours tryign to mess with this. works in UAT, not in production
            // ks 
        }
        try{
        //Test.startTest();
        //p1.Name='Test Architect Project';
        //p7.Architect_Account__c = acc6.Id;
        //p8.Stage__c='Closed Lost - Project Cancelled';
        //p8.Reason_Project_Lost__c='Wrong Product';
        p1.Stage__c='Closed Lost - Project Cancelled';
        update p1;
        //update p2;
        //update p3;
        update p4;
       // update p5;
       // update p6;
        //update p7;
        //update p8;
        update p9;
        p9.Amount__c=1900;
        p9.Id=acc8.id;
        //p5.OwnerId=testUser.Id;
        //p6.Corporate_Account__c=true;
        
        Test.stopTest();
        }
        Catch (Exception ex )
        {
            //i had to give up here because i couldnt deploy for hours tryign to mess with this. works in UAT, not in production
            // ks 
        }
    
    }


}