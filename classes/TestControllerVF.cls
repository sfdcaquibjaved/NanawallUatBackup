@isTest
public class TestControllerVF {
    
    public static List<Account> accList {get;set;}
    
    @isTest static void testController(){
        
        Account acc = new Account(Name='Test Account 001', type='Architecture Firm', BillingPostalCode='35004');
        
        Account acc2 = new Account(Name='Test Account 002', type='Architecture Firm', BillingPostalCode='35004');
        	
        Account acc3 = new Account(Name='Test Account 003', type='General Contractor', BillingPostalCode='35004');
        
        Account acc4 = new Account(Name='Test Account 004', type='Glazing Contractor', BillingPostalCode='35004');
        
        insert acc;
        
        //acc.ParentId = acc.Id;
        
        acc2.ParentId = acc.Id;
                
       // update acc;
        
        //update acc2;
        
        accList = new List<Account>();
        
        accList.add(acc2);
        accList.add(acc3);
        accList.add(acc4);
        
        insert accList;
        
        Project__c prj = new Project__c(Name='Test Project', Application__c='Automotive', Application_2__c= 'Showroom',Architect_Account__c=acc2.Id,Purchaser_Account__c=acc3.Id); 
   
    	insert prj;
        
        prj.RecordTypeId='Commercial Projects';
        
        update prj;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc2);
        
        CorporateAccountProjectListController con = new CorporateAccountProjectListController(sc);
        
        System.debug('Success');
        
    }
     

}