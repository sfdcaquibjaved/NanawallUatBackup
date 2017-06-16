/* 
 * Author: Cloudalyze Solutions LLP
 * Class: HierarchyControllerTest
 * Description: Test class for HierarchyController
 * Date: 15th June, 2017
 * Version: 
 * 
 * */


@isTest
public class HierarchyControllerTest {
    
    
    private static Account objAcc;
    private static Project__c objProject;
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
        objProject = new Project__c(  Name = 'Test Project', Application__c = 'Retail', 
                                      Stage__c = 'Closed Complete - Ordered - Paid',
                                      Amount__c = 1.2, Purchaser_Account__c = objAcc.Id, 
                                      End_Customer_Account__c = objAcc.Id, Architect_Account__c = objAcc.id, 
                                      Ordering_Account__c = objAcc.Id, Project_Country__c = 'Canada', 
                                      Project_Zip_Code__c = 'T5A0A7'
                                   );
        insert objProject;
        objOppy = new Opportunity( Name = 'Test Opportunity', AccountId = objAcc.Id, 
                                  Project_Name__c = objProject.Id, StageName = 'Need Analysis', 
                                  ForecastCategoryName='Pipeline', CloseDate = System.today()
                                 );
        insert objOppy;
        objQuote = new Quote__c( Name = 'Test Quote', Opportunity__c = objOppy.id, Project__c = objProject.Id); 
        insert objQuote;
        
        objOrder = new Order( Name = 'Test Order', Status = 'Draft', 
                              AccountId = objAcc.Id, EffectiveDate = System.today(), 
                              Project__c = objProject.Id, NanaQuote__c= objQuote.ID 
                            );
    //    insert objOrder;
    
    }
    
    
    //single record insertion
    static testMethod void recordInsert(){
        
        testDataSetup();    
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcc);
  		HierarchyController objHC = new HierarchyController(sc);
        PageReference pageRef = Page.AccountHierarchyWithProjects; // VF Page.
  		pageRef.getParameters().put('id', String.valueOf(objAcc.Id));
 /*       pageRef.getParameters().put('appIndFilter', 'Retail');
        pageRef.getParameters().put('archFilter', 'Test');
        pageRef.getParameters().put('purFilter', 'Test');
        pageRef.getParameters().put('ordFilter', 'Test'); */
        pageRef.getParameters().put('project_drp_Stage', 'Closed Complete - Ordered - Paid'); 

        pageRef.getParameters().put('sortExpression', '');
        pageRef.getParameters().put('accFilter', 'Test Account');
        
        
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
    

}