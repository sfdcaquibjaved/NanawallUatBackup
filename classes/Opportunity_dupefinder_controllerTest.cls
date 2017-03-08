@isTest
public class Opportunity_dupefinder_controllerTest {

   /* public static testmethod void myUnitTest() {
        Zip_Codes_Master__c Zip = new Zip_Codes_Master__c();
        Zip.Zip_Code__c = '12345';
        insert Zip;

        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingPostalCode = '12345';
        insert acc;
        Project__c pro = new Project__c();
        pro.name = 'Test Project';
        pro.Application_2__c = 'Auditorium';
        pro.Application__c = 'Hotel';
        pro.Project_Country__c = 'United States';
        pro.Project_Zip_Code__c = '12345';
        insert pro;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.account = Acc;
        opp.Type = 'New Policy';
        opp.StageName = 'Final';
        opp.CloseDate = date.today();
        opp.Project_Name__c = pro.Id;
        insert opp;

        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Opportunity';
        opp2.account = Acc;
        opp2.Type = 'New Policy';
        opp2.StageName = 'Final';
        opp2.CloseDate = date.today();
        opp2.Project_Name__c = pro.Id;
        insert opp2;

        Join_RelatedProjects__c JRP = new Join_RelatedProjects__c();
        JRP.Name = 'Test join related project';
        JRP.Opportunity_2__c = opp.id;
        JRP.opportunity_1__c = opp2.id;
        JRP.Master_Opportunity__c = opp.id;
        insert JRP;

        PageReference Pcon = Page.Opportunity_dupefinder;
         Test.setCurrentPage(Pcon);
        ApexPages.StandardController sc = new ApexPages.standardController(opp);

        Opportunity_dupefinder_controller ODC = new Opportunity_dupefinder_controller(sc);
        ODC.setrelatingoppid(opp.id);
        ODC.getrelatingoppid();
        ODC.AddToMaster();
       // ODC.unrelateopp();
        ODC.relateOpp();
        ODC.getdummyJoin();
        ODC.setdummyopp(JRP);
        ODC.addotheropp();
        ODC.getduplicateOpps();
        Opportunity_dupefinder_controller.FindDupes(opp);
        Opportunity_dupefinder_controller.Original_FindDupes(opp);


    }
*/

}