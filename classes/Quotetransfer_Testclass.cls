@isTest
public class Quotetransfer_Testclass {
    private static testmethod void unittest()
    {
                 list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
       account acc= new account();
        acc.Name='Testabc';
        acc.Type='OEM';
        acc.BillingPostalCode='12345';
        try{
        insert acc;
        }
        catch(Exception e){}
        contact con= new contact();
        con.FirstName='test';           
        con.LastName='xyz';
        con.AccountId=acc.id;
        con.MailingPostalCode='12345';
        try{
        insert con;
        }
        catch(Exception e){}
        
        project__c pro= new project__c();
        pro.Name='testproject';
        pro.Application__c='Automotive';
        pro.Application_2__c='Showroom';
        pro.Close_Date__c=date.today();
        pro.Project_Zip_Code__c='12345';
        try{
        insert pro;
        }
        catch(Exception e){}
        
        opportunity opp= new opportunity();
        opp.Name='Testopportunity';
        opp.AccountId=acc.Id;
        opp.Project_Name__c=pro.Id;
        opp.StageName='Need Analysis';
        opp.ForecastCategoryName='Pipeline';
        opp.Expected_Resolution_Date_2__c=date.today();
        opp.CloseDate=date.today();
        try{
        insert opp;
        }
        catch(Exception e){}
        quote__c q= new quote__c();
        q.Name='TestQuote';
        q.Contact__c=con.id;
        q.Opportunity__c=opp.Id;
        insert q;
        q.Opportunity__c=opp.id;
        try{
        update q;
        }
        catch(Exception e){}
        System.PageReference pr= page.QuoteTransfer;
        Test.setCurrentPage(pr);
        System.currentPageReference().getParameters().put('quote__c',q.Id);
        QuoteTransferController qtc = new QuoteTransferController(new ApexPages.StandardController(q)); 
        qtc.quo=q;
        qtc.obtainDetails();
        qtc.Transfer();
        
        
    }
    
private static testmethod void unittest2()
    {
                 list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
       account acc2= new account();
        acc2.Name='Testabcd';
        acc2.Type='OEM';
        acc2.BillingPostalCode='12345';
        try{
        insert acc2;
        }
        catch(Exception e){}
        account acc3= new account();
        acc3.Name='Testabcde';
        acc3.Type='OEM';
        acc3.BillingPostalCode='12345';
        try{
        
        insert acc3;
        }
       catch(Exception e){}
        
        contact con= new contact();
        con.FirstName='testcon';            
        con.LastName='xyz';
        con.AccountId=acc2.id;
        con.MailingPostalCode='12345';
        try{
        insert con;
        }
        catch(Exception e){}
        project__c pro= new project__c();
        pro.Name='testproject2';
        pro.Application__c='Automotive';
        pro.Application_2__c='Showroom';
        pro.Close_Date__c=date.today();
        pro.Project_Zip_Code__c='12345';
        try{
        insert pro;
        }
        catch(Exception e){}
        opportunity opp= new opportunity();
        opp.Name='Testopportunity2';
        opp.AccountId=acc2.Id;
        opp.Project_Name__c=pro.Id;
        opp.StageName='Need Analysis';
        opp.ForecastCategoryName='Pipeline';
        opp.Expected_Resolution_Date_2__c=date.today();
        opp.CloseDate=date.today();
        try{
          insert opp;
        }
        catch(Exception e){}
        opportunity opp2= new opportunity();
        opp2.Name='Testopportunity3';
        opp2.AccountId=acc3.Id;
        opp2.Project_Name__c=pro.Id;
        opp2.StageName='Need Analysis';
        opp2.ForecastCategoryName='Pipeline';
        opp2.Expected_Resolution_Date_2__c=date.today();
        opp2.CloseDate=date.today();
        try{
          insert opp2;
        }
        catch(Exception e){}
        quote__c q= new quote__c();
        q.Name='TestQuote2';
        q.Opportunity__c=opp.Id;
        try{
        
        insert q;
        }
        catch(Exception e){}
        q.Opportunity__c=opp2.Id;
        try{
        
        update q;
        }
        catch(Exception e){}
        System.PageReference pr= page.QuoteTransfer;
        Test.setCurrentPage(pr);
        System.currentPageReference().getParameters().put('quote__c',q.Id);
        QuoteTransferController qtc = new QuoteTransferController(new ApexPages.StandardController(q)); 
        QuoteTransferController qtc1 = new QuoteTransferController(new ApexPages.StandardController(q)); 
        
       
        qtc.Quo = q;
         qtc.obtainDetails(); 
         qtc.Transfer();
         qtc1.obtainDetails(); 
         qtc1.Transfer();
          
    }
    
    private static testmethod void unittest3()
    {
                 list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
         lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
       account acc= new account();
        acc.Name='Testabcdef';
        acc.Type='OEM';
        acc.BillingPostalCode='12345';
        try{
        
        insert acc;
        }
       catch(Exception e){} 
        account acc2= new account();
        acc2.Name='Testabcdefg';
        acc2.Type='OEM';
        acc2.BillingPostalCode='12345';
        try{
        insert acc2;
        }
        catch(Exception e){}
        contact con= new contact();
        con.FirstName='test';           
        con.LastName='xyz';
        con.AccountId=acc.id;
        con.MailingPostalCode='12345';
        try{
       insert con;
        }
        catch(Exception e){}
        
        contact con2= new contact();
        con2.FirstName='test';          
        con2.LastName='xyzw';
        con2.AccountId=acc2.id;
        con2.MailingPostalCode='12345';
        try{
        insert con2;
        }
        catch(Exception e){}
        
        project__c pro= new project__c();
        pro.Name='testproject';
        pro.Application__c='Automotive';
        pro.Application_2__c='Showroom';
        pro.Close_Date__c=date.today();
        pro.Project_Zip_Code__c='12345';
        try{
        insert pro;
        }
        catch(Exception e){}
        project__c pro2= new project__c();
        pro2.Name='testproject2';
        pro2.Application__c='Automotive';
        pro2.Application_2__c='Showroom';
        pro2.Close_Date__c=date.today();
        pro2.Project_Zip_Code__c='12345';
        try{
        insert pro2;
        }
        catch(Exception e){}
        opportunity opp= new opportunity();
        opp.Name='Testopportunity4';
        opp.AccountId=acc.Id;
        opp.Project_Name__c=pro.Id;
        opp.StageName='Need Analysis';
        opp.ForecastCategoryName='Pipeline';
        opp.Expected_Resolution_Date_2__c=date.today();
        opp.CloseDate=date.today();
        try{
        insert opp;
        }
        catch(Exception e){}
        opportunity opp2= new opportunity();
        opp2.Name='Testopportunity6';
        opp2.AccountId=acc.Id;
        opp2.Project_Name__c=pro2.Id;
        opp2.StageName='Need Analysis';
        opp2.ForecastCategoryName='Pipeline';
        opp2.Expected_Resolution_Date_2__c=date.today();
        opp2.CloseDate=date.today();
        try{
          insert opp2;
        }
        catch(Exception e){}
        
        nrOpportunityContactRole__c cnr = new nrOpportunityContactRole__c();
        cnr.Opportunity__c=opp2.id;
        cnr.Contact__c=con.id;
        try{
    
           insert cnr;
        }
        catch(Exception e){}
       Test.StartTest();
        quote__c q= new quote__c();
        q.Name='TestQuote4';
        q.Contact__c = con.id;
        q.Opportunity__c=opp.Id;
        try{
        insert q;
        }
        catch(Exception e){}
        q.Opportunity__c=opp2.ID;
        update q;
        System.PageReference pr= page.QuoteTransfer;
        Test.setCurrentPage(pr);
        System.currentPageReference().getParameters().put('quote__c',q.Id);
        QuoteTransferController qtc = new QuoteTransferController(new ApexPages.StandardController(q));
        qtc.Quo=q;
        qtc.obtainDetails();
        
        qtc.Transfer();
        Test.stopTest();
        
    }
    
}