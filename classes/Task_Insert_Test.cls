@isTest
public class Task_Insert_Test {
    
    
    static TestMethod  void TaskInsert()
    {
     
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
        List<Lead> li= TestDataUtility.createLeadTestData();
        insert li;
        
        //insert new objects
        List<Account> accs = new List<Account>();
        Integer i;
        for( i = 0; i < 1; i++ )
        {
            Account a = new Account();
            a.Phone = '123-456-7890';
            a.Name = 'Test account';
            a.BillingCountryCode = 'US';
            a.BillingPostalCode = '08619';
            accs.add(a); 
        }       
        insert accs; 
 
        List<Contact> conts = new List<Contact>();
        for( i = 0; i < 1; i++ )
        {
            Contact c = new Contact();
            c.FirstName = 'TestFirst';
            c.LastName = 'TestLast';
            c.MailingPostalCode = '08619';
            c.MailingCountryCode = 'US';
            conts.add(c);
//            c.Email = 'kristian.stout.'+(100+i)+'@a-stechnologies.com';
        }       
        insert conts;        
      


        List<Opportunity> opps2 = new List<Opportunity>();
        for( i = 0; i < 1; i++ )
        { 
            Opportunity o = new Opportunity();
            o.Name = 'test opp';
            o.StageName = 'test stage';
            o.CloseDate = Date.today();
            o.Country__c = 'USA';
            o.Postal_Code__c = 'TEST';
            opps2.add( o );  
        }       
        insert opps2;
       
        
       List<nrOpportunityContactRole__c> ocrs = new List<nrOpportunityContactRole__c>();
        for( i = 0; i < 1; i++ )
        {
			nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
			ocr.Opportunity__c = opps2[0].id;
			ocr.Contact__c = conts[0].id;
            
            ocrs.add( ocr );
        }       
        

        try{
	        insert ocrs;
        } catch (Exception ex){}

		
        task t= new task(ActivityDate = Date.today().addDays(7),
        Subject='Send Booklet',
        PhotoBooks_Selection__c = 'Education',
        WhoId = li[0].Id,
        OwnerId = UserInfo.getUserId(),
        Status='In Progress');
        insert t;
        
      

		
    }
    
    
     static TestMethod  void TaskInsert1()
    {
     
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
        List<Lead> li= TestDataUtility.createLeadTestData();
        insert li;
        
        //insert new objects
        List<Account> accs = new List<Account>();
        Integer i;
        for( i = 0; i < 1; i++ )
        {
            Account a = new Account();
            a.Phone = '123-456-7890';
            a.Name = 'Test account';
            a.BillingCountryCode = 'US';
            a.BillingPostalCode = '08619';
            accs.add(a); 
        }       
        insert accs; 
 
        List<Contact> conts = new List<Contact>();
        for( i = 0; i < 1; i++ )
        {
            Contact c = new Contact();
            c.FirstName = 'TestFirst';
            c.LastName = 'TestLast';
            c.MailingPostalCode = '08619';
            c.MailingCountryCode = 'US';
            conts.add(c);
//            c.Email = 'kristian.stout.'+(100+i)+'@a-stechnologies.com';
        }       
        insert conts;        
      


        List<Opportunity> opps2 = new List<Opportunity>();
        for( i = 0; i < 1; i++ )
        { 
            Opportunity o = new Opportunity();
            o.Name = 'test opp';
            o.StageName = 'test stage';
            o.CloseDate = Date.today();
            o.Country__c = 'USA';
            o.Postal_Code__c = 'TEST';
            opps2.add( o );  
        }       
        insert opps2;
       
        
       List<nrOpportunityContactRole__c> ocrs = new List<nrOpportunityContactRole__c>();
        for( i = 0; i < 1; i++ )
        {
			nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
			ocr.Opportunity__c = opps2[0].id;
			ocr.Contact__c = conts[0].id;
            
            ocrs.add( ocr );
        }       
        

        try{
	        insert ocrs;
        } catch (Exception ex){}

		
        task t= new task(ActivityDate = Date.today().addDays(7),
        Subject='send binder',
        PhotoBooks_Selection__c = 'Education',                
        WhoId = conts[0].Id,
        OwnerId = UserInfo.getUserId(),
        Status='In Progress');
        insert t;
      
		
    }
      
      
    static TestMethod  void TaskInsert2()
    {
     
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
        List<Lead> li= TestDataUtility.createLeadTestData();
        insert li;
        
        //insert new objects
        List<Account> accs = new List<Account>();
        Integer i;
        for( i = 0; i < 1; i++ )
        {
            Account a = new Account();
            a.Phone = '123-456-7890';
            a.Name = 'Test account';
            a.BillingCountryCode = 'US';
            a.BillingPostalCode = '08619';
            accs.add(a); 
        }       
        insert accs; 
 
        List<Contact> conts = new List<Contact>();
        for( i = 0; i < 1; i++ )
        {
            Contact c = new Contact();
            c.FirstName = 'TestFirst';
            c.LastName = 'TestLast';
            c.MailingPostalCode = '08619';
            c.MailingCountryCode = 'US';
            conts.add(c);
//            c.Email = 'kristian.stout.'+(100+i)+'@a-stechnologies.com';
        }       
        insert conts;        
      


        List<Opportunity> opps2 = new List<Opportunity>();
        for( i = 0; i < 1; i++ )
        { 
            Opportunity o = new Opportunity();
            o.Name = 'test opp';
            o.StageName = 'test stage';
            o.CloseDate = Date.today();
            o.Country__c = 'USA';
            o.Postal_Code__c = 'TEST';
            opps2.add( o );  
        }       
        insert opps2;
       
        
       List<nrOpportunityContactRole__c> ocrs = new List<nrOpportunityContactRole__c>();
        for( i = 0; i < 1; i++ )
        {
			nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
			ocr.Opportunity__c = opps2[0].id;
			ocr.Contact__c = conts[0].id;
            
            ocrs.add( ocr );
        }       
        

        try{
	        insert ocrs;
        } catch (Exception ex){}

		
        task t= new task(ActivityDate = Date.today().addDays(7),
        Subject='Send Booklet',
        PhotoBooks_Selection__c = 'Education',
        WhoId = conts[0].Id,
        OwnerId = UserInfo.getUserId(),
        Status='In Progress');
        insert t;
       	
    }
    
    static TestMethod  void TaskInsert3()
    {
     
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
        List<Lead> li= TestDataUtility.createLeadTestData();
        insert li;
        
        //insert new objects
        List<Account> accs = new List<Account>();
        Integer i;
        for( i = 0; i < 1; i++ )
        {
            Account a = new Account();
            a.Phone = '123-456-7890';
            a.Name = 'Test account';
            a.BillingCountryCode = 'US';
            a.BillingPostalCode = '08619';
            accs.add(a); 
        }       
        insert accs; 
 
        List<Contact> conts = new List<Contact>();
        for( i = 0; i < 1; i++ )
        {
            Contact c = new Contact();
            c.FirstName = 'TestFirst';
            c.LastName = 'TestLast';
            c.MailingPostalCode = '08619';
            c.MailingCountryCode = 'US';
            conts.add(c);
//            c.Email = 'kristian.stout.'+(100+i)+'@a-stechnologies.com';
        }       
        insert conts;        
      


        List<Opportunity> opps2 = new List<Opportunity>();
        for( i = 0; i < 1; i++ )
        { 
            Opportunity o = new Opportunity();
            o.Name = 'test opp';
            o.StageName = 'test stage';
            o.CloseDate = Date.today();
            o.Country__c = 'USA';
            o.Postal_Code__c = 'TEST';
            opps2.add( o );  
        }       
        insert opps2;
       
        
       List<nrOpportunityContactRole__c> ocrs = new List<nrOpportunityContactRole__c>();
        for( i = 0; i < 1; i++ )
        {
			nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
			ocr.Opportunity__c = opps2[0].id;
			ocr.Contact__c = conts[0].id;
            
            ocrs.add( ocr );
        }       
        

        try{
	        insert ocrs;
        } catch (Exception ex){}

		
        task t= new task(ActivityDate = Date.today().addDays(7),
        Subject='send binder',
        PhotoBooks_Selection__c = 'Education',                
        WhoId = Li[0].Id,
        OwnerId = UserInfo.getUserId(),
        Status='In Progress');
        insert t;
      
		
    }
        
    }