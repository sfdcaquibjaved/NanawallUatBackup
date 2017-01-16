@isTest
public class projecttrigger_test {
    static testmethod void prowner(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        project__c p= new project__c();
           // p1.recordtypeId='012K0000000DKP0IAO';
             p.Name = 'Test Project CompetitorHelper_Test';
             p.Application__c = 'Automotive';
             p.Application_2__c = 'Dealership';
             p.Project_Zip_Code__c = '94040' ;
             insert p;
            test.startTest();
            p.Project_Zip_Code__c = '12345' ;
            update p;
            test.stopTest();
    }
}