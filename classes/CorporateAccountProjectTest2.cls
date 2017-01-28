@isTest
public class CorporateAccountProjectTest2 {
    
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
                
                list < account > a = new list < account > ();
                a = TestDataUtility.createAccountTestData();
                insert a;
                a[0].type = 'Architecture Firm';
                update a[0];
                ApexPages.StandardController sc = new ApexPages.standardController(a[0]);
                CorporateAccountProjectListController2 obj = new CorporateAccountProjectListController2 (sc);
                List<Project__c> pList = new List<Project__c>();
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
                insert pList;
                List<CorporateAccountProjectListController2.ProjectContainer> pconList = new List<CorporateAccountProjectListController2.ProjectContainer>();
                CorporateAccountProjectListController2.ProjectContainer pc = new CorporateAccountProjectListController2.ProjectContainer ();
                pc.relType = 'xyz';
                pc.proj = p1;
                pconList.add(pc);
                CorporateAccountProjectListController2.ProjectContainer pc1 = new CorporateAccountProjectListController2.ProjectContainer ();
                pc1.relType = 'xyz';
                pc1.proj = p2;
                pconList.add(pc1);
                obj.lstProject = pconList;
                obj.lstProj = pList;
                obj.intProjectWon  =1;
                obj.dblAmountTotal =100;
                obj.dblAmountWon =101;
                obj.showPenetration =True;
                obj.str='a1';
                obj.str2='a12';
                obj.ValueOfObjId = '1010010011001';
                
                //Account acc = new account ( Name='ababba',BillingCity='Monterrey',BillingCountry='Mexico',BillingCountryCode='MX',BillingPostalCode='1',BillingState='Nuevo León',BillingStreet='Aldama # 981-A',BillingStateCode='NL');
                //insert acc;
                Account acc1 = new account ( Name='cdcdcdc' ,type ='Architecture Firm',BillingCity='Monterrey',BillingCountry='Mexico',BillingCountryCode='MX',BillingPostalCode='1',BillingState='Nuevo León',BillingStreet='Aldama # 981-A',BillingStateCode='NL');
                 
               // a.add(acc1);
               // insert a;
               insert acc1;
                Project__c p = new Project__c (Name ='project1',Application__c='Automotive',Application_2__c='Hotel',Project_State__c='state1',Project_City__c='city1',Project_Street_Address__c='street 111',Project_Country__c='Australia', TerritoryName__c='teeett1',Project_Zip_Code__c = '94040',Architect_Account__c=acc1.ID );
                
               // pList.add(p);
               // insert pList;
               insert p;
                
            }

}