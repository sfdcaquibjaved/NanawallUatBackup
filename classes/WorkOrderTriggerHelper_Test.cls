/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class WorkOrderTriggerHelper_Test {

    static testMethod void workOrderWithOpportunity() {
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
       Project__c p1 = new Project__c();
        p1.Name = 'Test Project OpportunityHelper_Test1';
        p1.Project_Zip_Code__c = '12345';
        try{
        INSERT p1;
        }
        catch(DmlException e){}
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp OpportunityTriggerHelper_Test1';
        o.Amount = 5000;
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.Project_Name__c = p1.Id;
        
        try{
        insert o;
        }catch(DmlException e){}
        
         Quote__c q1 = new Quote__c();
        q1.Name = 'Test Quote OpportunityTriggerHelper_Test1';
        q1.Opportunity__c = o.Id;
        try{
        insert q1;
        }catch(DmlException e){}
        
        Work_Order__c wOrder = new Work_Order__c();
        wOrder.Name = 'WO1';
        wOrder.Opportunity__c = o.Id;
        wOrder.Quote_Custom_lookup__c = q1.Id;
        
        Test.startTest();
        insert wOrder;
        Test.stopTest();
    }
    
    static testMethod void deleteWorkOrder()
    
    {
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        Project__c p1 = new Project__c();
        p1.Name = 'Test Project OpportunityHelper_Test1';
        p1.Project_Zip_Code__c = '12345';
        try{
        INSERT p1;
        }catch(DmlException e){}
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp OpportunityTriggerHelper_Test1';
        o.Amount = 5000;
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        o.Project_Name__c = p1.Id;
        
        try{
        insert o;
        }catch(DmlException e){}
        
         Quote__c q1 = new Quote__c();
        q1.Name = 'Test Quote OpportunityTriggerHelper_Test1';
        q1.Opportunity__c = o.Id;
        
        try{
        insert q1;
        }
        catch(DmlException e){}
        Work_Order__c wOrder = new Work_Order__c();
        wOrder.Name = 'WO1';
        wOrder.Opportunity__c = o.Id;
        wOrder.Quote_Custom_lookup__c = q1.Id;
        try{
        insert wOrder;
        }catch(DmlException e){}
        
        Test.startTest();
        try{
        delete wOrder;
        }
        catch(DmlException e){}
        Test.stopTest();
        
    }
    
}