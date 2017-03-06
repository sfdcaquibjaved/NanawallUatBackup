@isTest
public class testPositionTrigger {
    static testmethod void positioncheck(){
       installation__c ins1 = new installation__c(name = '123');
        insert ins1;
        installation__c ins2 = new installation__c(name = '223');
        insert ins2;
        Position__c pos = new Position__c(Name='test',Installation__c= ins1.id);
        insert pos;
        
        test.startTest();
        pos.installation__c =ins2.id;
        update pos;
        test.stopTest();
    }
}