/* 
 * Author: Cloudalyze Solutions LLP
 * Class: HierarchyControllerTest
 * Description: Test class for HierarchyController
 * Date: 15th June, 2017
 * Version: 
 * 
 * */


@isTest (seeAllData=true)
public class HierarchyControllerTest {
    
    
    private static Account objAcc;
    private static Account objAccOne;
    private static Project__c objProject;
    private static Project__c objProjectOne;
    private static Project__c objProjectTwo;
    private static Order objOrder;
    private static Quote__c objQuote;
    private static Opportunity objOppy;
    private static List<SelectOption> soList ;
   
    
    // inserting test data.
    static void testDataSetup(){
        
        objAcc = new Account( Name = 'test name', Type = 'Architecture Firm',
                                     BillingCountry = 'United States', 
                                     BillingState = 'New York', 
                                     BillingPostalCode = '60603'
                            );
        insert objAcc;
        objAccOne = new Account( Name = 'test name', Type = 'Architecture Firm',
                                     BillingCountry = 'United States', 
                                     BillingState = 'New York', 
                                     BillingPostalCode = '60603'
                            );
        insert objAccOne;
        
        objProject = new Project__c(  Name = 'Test Project', Application__c = 'Retail', 
                                      Stage__c = 'Closed Complete - Ordered - Paid',
                                      Amount__c = 1.2, Purchaser_Account__c = objAcc.Id, 
                                      End_Customer_Account__c = objAcc.Id, Architect_Account__c = objAcc.id, 
                                      Ordering_Account__c = objAcc.Id, Project_Country__c = 'Canada', 
                                      Project_Zip_Code__c = 'T5A0A7'
                                   );
        insert objProject;
        
        objProjectOne = new Project__c(  Name = 'Test Project', Application__c = 'Retail', 
                                      Stage__c = 'Closed Won - Order In Process',
                                      Amount__c = 1.2, Purchaser_Account__c = objAccOne.Id, 
                                      End_Customer_Account__c = objAccOne.Id, Architect_Account__c = objAccOne.id, 
                                      Ordering_Account__c = objAccOne.Id, Project_Country__c = 'Canada', 
                                      Project_Zip_Code__c = 'T5A0A7'
                                   );
        insert objProjectOne;
        
        objProjectTwo = new Project__c(  Name = 'Test Project', Application__c = 'Retail', 
                                      Stage__c = 'Quoted',
                                      Amount__c = 1.2, Purchaser_Account__c = objAccOne.Id, 
                                      End_Customer_Account__c = objAccOne.Id, Architect_Account__c = objAccOne.id, 
                                      Ordering_Account__c = objAccOne.Id, Project_Country__c = 'Canada', 
                                      Project_Zip_Code__c = 'T5A0A7'
                                   );
        insert objProjectTwo;
        
        objOppy = new Opportunity( Name = 'Test Opportunity', AccountId = objAcc.Id, 
                                  Project_Name__c = objProject.Id, StageName = 'Need Analysis', 
                                  ForecastCategoryName='Pipeline', CloseDate = System.today()
                                 );
        insert objOppy;
        objQuote = new Quote__c( Name = 'Test Quote', Opportunity__c = objOppy.id, Project__c = objProject.Id); 
        insert objQuote;
        
        objOrder = new Order( Name = 'Test Order', Status = 'Draft', 
                              AccountId = objAcc.Id, EffectiveDate = System.today(), 
                              Project__c = objProject.Id, NanaQuote__c= objQuote.ID, 
                              Order_Finalized_Date__c = System.today()
                            );
         insert objOrder;
    
    }
    
    
    //single record insertion
    static testMethod void recordInsert(){
        
        testDataSetup();    
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
  		HierarchyController objHC = new HierarchyController(sc);
        objHC.appIndFilter = 'Retail';
        PageReference pageRef = Page.AccountHierarchyWithProjects; // VF Page.
  		pageRef.getParameters().put('id', String.valueOf(objAcc.Id));
        pageRef.getParameters().put('ordFnzDtMax', '01/01/2016');
        pageRef.getParameters().put('project_drp_Stage', 'Closed Complete - Ordered - Paid'); 
        pageRef.getParameters().put('sortExpression', '');
        pageRef.getParameters().put('accFilter', 'Test Account');
        pageRef.getParameters().put('appIndFilter','ASC');
        
        Test.setCurrentPage(pageRef);
        // Methods 
        soList = objHC.getStageDrp();
        pageRef = objHC.ViewData();
        pageRef = objHC.refresh();
        objHC.setSortDirection('06/15/2017');
        String sortVal = objHC.getSortDirection();
        pageRef = objHC.refreshPageSize();
        List < Account > accList = objHC.getOpportunities();
        try{
            objHC.filter();
        }catch(Exception e){
        }
        objHC.filterAcc();
    }
    
    
    static testMethod void newRecordInsert(){
        
        testDataSetup();    
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccOne);
  		HierarchyController objHC = new HierarchyController(sc);
        objHC.appIndFilter = 'Retail';
        PageReference pageRef = Page.AccountHierarchyWithProjects; // VF Page.
  		pageRef.getParameters().put('id', String.valueOf(objAccOne.Id));
        pageRef.getParameters().put('ordFnzDtMax', '01/01/2016');
        pageRef.getParameters().put('sortExpression', 'ASC');
    }
    

}