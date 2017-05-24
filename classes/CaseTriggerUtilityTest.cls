@isTest
public class CaseTriggerUtilityTest {
    static testmethod void method1(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        list<Account>acclist = TestDataUtility.createAccountTestData();
        Integer size = acclist.size();
        insert acclist;
        list<Contact>conlist = TestDataUtility.createConTestData();
        for(Integer k=0;k<conlist.size();k++){
            conlist[k].AccountId = acclist[k].id;
        }
        insert conlist;
        
            
        list<Case>caselist = TestDataUtility.createCaseTestData();
        for(Integer i=0;i< caselist.size();i++){
            caselist[i].Milestone_check__c = true;
            caselist[i].ContactId = conlist[i].id;
            //caselist[i].EntitlementId = ent.id;
        }
        insert caselist;
        /*List<CaseMilestone> lstcm = [Select ID,CaseId FROM CaseMilestone WHERE CaseId=:caselist[0].Id];
        System.debug('I am hereeeee'+lstcm.size());
        System.debug('I am hereeeee again'+lstcm);*/
        
        /*list<CaseMilestone> cmlist = new list<CaseMilestone>();
        CaseMilestone cm = new CaseMilestone();
        cm.CompletionDate = System.today();
        cmlist.add(cm);
        
        
        //insert cmlist;*/
        test.startTest();
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        list<Installation__c> inslist = TestDataUtility.createInsTestData();
        insert inslist;
        test.stopTest();
        
}
    static testmethod void method2(){
        test.startTest();

        Manufacturer_OrderNb__c mo = new Manufacturer_OrderNb__c();
        mo.Name = 'Richmond';
        //mo.LatestNumber__c = 40200;
        mo.LatestOrderNumber__c='40209';
        insert mo;
        
        Manufacturer_OrderNb__c mo1 = new Manufacturer_OrderNb__c();
        mo1.Name = 'Solarlux';
        //mo1.LatestNumber__c = 20001;
        mo1.LatestOrderNumber__c='20017';
        insert mo1;
        
        Manufacturer_OrderNb__c mo2 = new Manufacturer_OrderNb__c();
        mo2.Name = 'Teuffel';
        //mo2.LatestNumber__c = 75400;
        mo2.LatestOrderNumber__c='75401';
        insert mo2;
        
        Manufacturer_OrderNb__c mo3 = new Manufacturer_OrderNb__c();
        mo3.Name = 'Wizard';
        //mo3.LatestNumber__c = 97000;
        mo3.LatestOrderNumber__c='97001';
        insert mo3;
        
        ModelManufacturer__c mm=new ModelManufacturer__c();
        mm.Name='HSW 45';
        mm.Manufacturer__c='Solarlux';
        insert mm;
        
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
        insert tmList;
        
         Project__c p1 = new Project__c();
         p1.Name = 'Test Project CompetitorHelper_Test';
         p1.Application__c = 'Automotive';
         p1.Application_2__c = 'Dealership';
         p1.Stage__c = 'Considered';
         p1.Project_Zip_Code__c = '94040' ;
         insert p1;
        
        Account acct = new Account(Name='My Test Account1',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');
        insert acct; 
         
         contact co=new contact();
         co.Accountid = acct.id;
         co.FirstName = 'john';
         co.LastName = 'CAD EMAIL RECIPIENT';
         co.MailingStreet = 'street';
         co.MailingCity = 'city'; 
         co.Mailingstate = 'Utah'; 
         co.MailingPostalCode = '12345';
         co.MailingCountryCode = 'US';
         co.Address_1__c='hyderabad';
         co.Address_2__c='hyder guda';
         co.AIA_Lunch_and_Learn__c=true;
         co.AssistantName='contact assistant';
         co.Birthdate=system.today();
         co.Fax='123456';
         co.Email='abc@abc.com';
         co.Phone='125869';
         co.Country__c='Aruba';
         insert co;

         Opportunity o = new Opportunity();
         o.Name = 'Test Opp CompetitorHelper_Test1';
         o.StageName = 'Need Analysis';
         o.CloseDate = Date.today();
         o.project_name__c = p1.id;
         o.Country__c = 'USA';
         o.Postal_Code__c = 'TEST';
         insert o;
         Quote__c q = new Quote__c();
         q.Name = 'Test Quote';
         q.Opportunity__c = o.Id;
         q.Primary_Quote__c=True;
         q.Project__c = p1.id;
         q.Shipping_Min__c = 12;
         insert q;
        
         Quote q1 = new Quote();
         q1.Name = 'Test Quote';
         q1.OpportunityId = o.Id;
         q1.Nana_Quote__c = q.Id;
         q1.First_Threshold_Price__c = 1;        
         q1.ContactId = Co.id;
         q1.Tax = 1.0;
         q1.Order_Number__c = 12345;
         insert q1;
         
         order ord = new order();
         ord.Status = 'draft';
         ord.EffectiveDate = system.today();
         ord.AccountId = acct.id;
         ord.Order_Finalized_Date__c = date.newInstance(2017,01,10);
         ord.Nanaquote__c = q.id;
         insert ord;
         
        case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
         c.Order__c = ord.id;        
        
        insert c;
        
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        
        Installation__c ins = new Installation__c();
            ins.Status__c = 'Accepted by Installer' ;
            ins.Installation_Date__c = system.today() ;
            //ins.Order__c = orderList[i].id;
            ins.Order__c = ord.id;
        ins.Installer_Account__c = acct.id;
            ins.Installer_contact__c = co.id;
            ins.Project__c = p1.id;
        
        insert ins;
        test.stopTest();
    }
    
}