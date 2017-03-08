@isTest
private  class ProjectSplitTriggerTest {
    
     static testMethod void myUnitTest() {
      test.startTest();
      list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
     list<project__c> olstTestProject = new list<project__c>();
        project__c p= new project__c();
        p.Name='xyz enterprise';
        p.Project_Zip_Code__c='12345';
        p.Project_Country__c='United States';
        p.Close_Date__c=Date.newInstance(2015, 12, 12);
        p.Stage__c='Prospecting';
            
        olstTestProject.add(p);
        
    insert olstTestProject;    
      
      list<Project_Split__c> newSplits = new list<Project_Split__c>();
      Project_Split__c newSplit = new Project_Split__c();
      newSplit.Project__c = olstTestProject[0].Id ;
      newSplit.Split__c = 0.0 ;
      newSplit.Project_Rep__c = Userinfo.getUserId();
      newSplits.add(newSplit); 
      insert newSplits ;
      
      list<Project_Split__c> newSplits1 = new list<Project_Split__c>();
      Project_Split__c newsp = new Project_Split__c();
      newSp.Project__c = olstTestProject[0].Id ;
      newSp.Split__c = 10.0 ;
      newSp.Project_Rep__c = Userinfo.getUserId();
      newSplits1.add(newSp); 
      insert newSplits1 ;
      
      list<Project_Split__c> Querytodelete = [select id,Project__c,Split__c,Role__c from Project_Split__c where Project__c =:olstTestProject[0].Id and Role__c='Location' and Split__c=100.00];
         
         try{
              delete newSplits;
         }
         catch(DMLException e){}
     
         try{
             delete Querytodelete;
            }
         catch(DmlException e) {
             
         }

      
     }
}