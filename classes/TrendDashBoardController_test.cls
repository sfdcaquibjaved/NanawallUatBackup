@IsTest
public class TrendDashBoardController_test {
    public static List<Project__c> olstTestProject;
    static testMethod void testMethod1() {
        User testUser = TestDataUtility.createUser('admin1' , 'testUser1@testing.com');
        insert testUser;
        /*olstTestProject = TestDataUtility.createProjectTestData();
         insert olstTestProject;*/
        
       /* Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u1 = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1@camfed.org');
        insert u1;*/
        
   /*Account portalAccount = new Account(name = 'portalAccount');
  insert portalAccount;
  Contact portalContact = new contact(LastName = 'portalContact', AccountId = portalAccount.Id);
  insert portalContact;
  User u1 = new User( email='testmail@gmail.com',
                profileid = portalContact.Id, 
                UserName='testmail@gmail.com' + system.label.PortalEmailSuffix, 
                Alias = 'GDS',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = portalContact.Id,
                PortalRole = 'Manager',
                FirstName = 'test',
                LastName = 'User');*/
        
        
        TrendDashBoardController tdbc=new TrendDashBoardController();
        tdbc.communityuser=TRUE;
        //tdbc.userid=testuser.id;
        tdbc.username='testuser';
        tdbc.getRegionlist();
        tdbc.regionname='Eastern Sales';
        tdbc.TrendsCalculation();
    }
    static testMethod void testMethod2() {
        TrendDashBoardController tdbc=new TrendDashBoardController();
        tdbc.regionname='Mid Eastern Sales';
        tdbc.TrendsCalculation();
    }
    static testMethod void testMethod3() {
        TrendDashBoardController tdbc=new TrendDashBoardController();
        tdbc.regionname='Midwest Sales';
        tdbc.TrendsCalculation();
    }
    static testMethod void testMethod4() {
        TrendDashBoardController tdbc=new TrendDashBoardController();
        tdbc.regionname='Western Sales';
        tdbc.TrendsCalculation();
    }
    static testMethod void testMethod5() {
        TrendDashBoardController tdbc=new TrendDashBoardController();
        tdbc.regionname='--None--';
        tdbc.TrendsCalculation();
    }
    static testMethod void testMethod6() {
        TrendDashBoardController tdbc=new TrendDashBoardController();
        tdbc.getRegionlist();
        //tdbc.TrendsCalculation();
    }
}