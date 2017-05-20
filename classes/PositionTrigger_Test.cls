@isTest
public class PositionTrigger_Test {
    static testmethod void positioncheck(){
        list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
        insert new Zip_Code_Range_for_Paul_Nalette__c(Name = 'Zip Range',Start_Value__c = 40000,End_Value__c = 48000);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'Northern NJ',Zip_Code_del__c = 7000,Zip_Code_End_Value__c = 8999);
        insert new Zip_Code_Range_for_Bill_Leon__c(Name = 'NY State',Zip_Code_del__c = 500,Zip_Code_End_Value__c = 15000);
        Project__c prolist = new Project__c();
        prolist.Project_Zip_Code__c = '94040';
        prolist.Name = 'Test Project CompetitorHelper_Test';
             prolist.Application__c = 'Automotive';
             prolist.Application_2__c = 'Dealership';
        insert prolist;
       installation__c ins1 = new installation__c(name = '123',Project__c = prolist.id);
        insert ins1;
        installation__c ins2 = new installation__c(name = '223',Project__c = prolist.id);
        insert ins2;
        Position__c pos = new Position__c(Name='test',Installation__c= ins1.id);
        insert pos;
        
        test.startTest();
        pos.installation__c =ins2.id;
        update pos;
        test.stopTest();
    }
}