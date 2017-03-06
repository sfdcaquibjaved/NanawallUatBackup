@isTest
public class CorporateAccountProjectTest {
    
    public static list < opp_proj_stages__c > olstprojectStages;
    public static list < HardCodingUtility__c > olstHardcodUtil;


    public static testmethod void corporateAccountProjectTst() {

                list < Zip_Codes_Master__c > z = new list < Zip_Codes_Master__c > ();
                z = TestDataUtility.getTerritoryMaster();
                insert z;
                
                User testUser = TestDataUtility.createUser('admin1', 'testUser@testing.com');
                insert testUser;
                
                User testUser1 = TestDataUtility.createUser('admin2', 'testUser1@testing.com');
                insert testUser1;                             
                
                olstprojectStages = TestDataUtility.getProjectStages();
                insert olstprojectStages;
                
                //Insert Custom Setting Record
                olstHardcodUtil = TestDataUtility.getHardCodingUtility();
                insert olstHardcodUtil;
                List<Project__c> pList = new List<Project__c>();
                list < account > a = new list < account > ();
                a = TestDataUtility.createAccountTestData();
                insert a;
                a[0].type = 'Architecture Firm';
                update a[0];
                Project__c p1= new Project__c();
                p1.Architect_Account__c = a[0].ID;
                p1.Project_Zip_Code__c = '94040' ;
                pList.add(p1);
                Project__c p2= new Project__c();
                p2.Franchise_Account__c = a[0].ID;
                p2.Project_Zip_Code__c = '94040' ;
                pList.add(p2);
                Project__c p3= new Project__c();
                p3.Franchisor_Account__c = a[0].ID;
                p3.Project_Zip_Code__c = '94040' ;
                pList.add(p3);
                Project__c p4= new Project__c();
                p4.Other_Influencer_Account__c = a[0].ID;
                p4.Project_Zip_Code__c = '94040' ;
                pList.add(p4);
                Project__c p5= new Project__c();
                p5.Purchaser_Account__c = a[0].ID;
                p5.Project_Zip_Code__c = '94040' ;
                p5.Stage__c= 'Closed Won - Order Signed';
                p5.Amount__c = 400;
                pList.add(p5);
                insert pList;
                List<CorporateAccountProjectListController.ProjectContainer> pconList = new List<CorporateAccountProjectListController.ProjectContainer>();
                CorporateAccountProjectListController.ProjectContainer pc = new CorporateAccountProjectListController.ProjectContainer ();
                pc.relType = 'xyz';
                pc.proj = p1;
                pconList.add(pc);
                CorporateAccountProjectListController.ProjectContainer pc1 = new CorporateAccountProjectListController.ProjectContainer ();
                pc1.relType = 'xyz';
                pc1.proj = p2;
                pconList.add(pc1);
                ApexPages.StandardController sc = new ApexPages.standardController(a[0]);
                CorporateAccountProjectListController obj = new CorporateAccountProjectListController (sc);
                obj.lstProject = pconList;
                obj.lstProj = pList;
                obj.intProjectWon  =0;
                obj.dblAmountTotal =0;
                obj.dblAmountWon =0;
                obj.showPenetration =True;
                obj.str='a1';
                obj.str2='a12';
                obj.ValueOfObjId = '1010010011001';
                
                a[0].type = 'General Contractor';
                update a[0];
                ApexPages.StandardController scc = new ApexPages.standardController(a[0]);
                CorporateAccountProjectListController ob = new CorporateAccountProjectListController (scc);
                ob.lstProject = pconList;
                ob.lstProj = pList;
                ob.intProjectWon  =0;
                ob.dblAmountTotal =0;
                ob.dblAmountWon =0;
                ob.showPenetration =True;
                ob.str='a1';
                ob.str2='a12';
                ob.ValueOfObjId = '1010010011001';
            }

}