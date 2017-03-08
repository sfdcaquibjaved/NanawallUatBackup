/*** This test class will test the following components -
 *** 1. competitorDetailsTrigger - Apex Trigger
 *** 2. CompetitorHelper - Apex Class
 ***/
@isTest(SeeAllData=false)
public class CompetitorHelper_Test{
    
     //Static data Member
   public static List<Opportunity> olstTestOpportunity;
   public static List<Project__c> olstTestProject;
   public static List<Competitor_Detail__c> olstTestCompDetail;
   
    
    static testMethod void CompetitorHelper_Test1(){
        
        list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        /*Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        lstzipCode.add(zipCode1);
        insert  lstzipCode;*/ 
        lstzipCode = TestDataUtility.getTerritoryMaster();
    insert lstzipCode;
        
        //Create Test Data
        olstTestOpportunity = TestDataUtility.createOppTestData();
        //try{
        insert olstTestOpportunity ;
        //}catch(DMLEXCEPTION e){}
        
        
        
        olstTestProject = TestDataUtility.createProjectTestData();
       // try{
        insert olstTestProject ;
       // }catch(DMLEXCEPTION e){}
       
        
        
        olstTestCompDetail = TestDataUtility.createcompDetailTestData(olstTestOpportunity ,olstTestProject );
        
        Test.startTest();
          insert olstTestCompDetail ;
          CompetitorHelper ch = new CompetitorHelper();
        
        //ch.updateProjectCompetitorCheckbox();
        //ch.updateOpportunityCompetitorCheckbox();
            
        Test.stopTest();
    }
}