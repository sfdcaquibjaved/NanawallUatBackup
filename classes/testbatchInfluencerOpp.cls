@isTest
public class testbatchInfluencerOpp {
    public static list < Zip_Codes_Master__c > territorymaster;
    static testmethod void method1(){
        territorymaster = TestDataUtility.getTerritoryMaster();
         insert territorymaster;
         list<Account> acclist = TestDataUtility.createAccountTestData();
         insert acclist;
         /*list<Contact> conlist = TestDataUtility.createConTestData();
         insert conlist;*/
         list<Project__c> projlist = TestDataUtility.createProjectTestData();
        for(Integer i =0;i<projlist.size();i++){
            projlist[i].Architect_Account__c = acclist[i].id;
            projlist[i].Close_Date__c = System.today();
        }
        insert projlist;
        test.startTest();
        list<Opportunity>  opplist = TestDataUtility.createOppTestData();
        Map <String,Schema.RecordTypeInfo> recordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        for(Integer j = 0;j<opplist.size();j++){
            opplist[j].AccountId = acclist[j].id;
            opplist[j].Project_Name__c = projlist[j].id;
            if(recordTypeMap.containsKey('Influencer Opportunity')) {
             opplist[j].RecordTypeId= recordTypeMap.get('Influencer Opportunity').getRecordTypeId();
            }
        }
        insert opplist;
        batchInfluencerOpp en = new batchInfluencerOpp();
        Database.executeBatch(en);
        test.stopTest();
    }
    static testmethod void method2(){
        territorymaster = TestDataUtility.getTerritoryMaster();
         insert territorymaster;
         list<Account> acclist = TestDataUtility.createAccountTestData();
         insert acclist;
         /*list<Contact> conlist = TestDataUtility.createConTestData();
         insert conlist;*/
         list<Project__c> projlist = TestDataUtility.createProjectTestData();
        for(Integer i =0;i<projlist.size();i++){
            projlist[i].Architect_Account__c = acclist[i].id;
            projlist[i].Close_Date__c = System.today();
            projlist[i].Stage__c = 'Prospecting';
        }
        insert projlist;
        list<Account> acclist2 = TestDataUtility.createAccountTestData();
         insert acclist2;
        test.startTest();
        list<Opportunity>  opplist = TestDataUtility.createOppTestData();
        Map <String,Schema.RecordTypeInfo> recordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
        for(Integer j = 0;j<opplist.size();j++){
            opplist[j].AccountId = acclist2[j].id;
            opplist[j].StageName = 'Need Analysis';
            opplist[j].Project_Name__c = projlist[j].id;
            if(recordTypeMap.containsKey('Influencer Opportunity')) {
             opplist[j].RecordTypeId= recordTypeMap.get('Influencer Opportunity').getRecordTypeId();
            }
        }
        insert opplist;
        batchInfluencerOpp en = new batchInfluencerOpp();
        Database.executeBatch(en);
        test.stopTest();
    }
}