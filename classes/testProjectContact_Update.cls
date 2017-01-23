@isTest
public class testProjectContact_Update {
    public static list < Zip_Codes_Master__c > territorymaster;
    static testmethod void method1(){
        territorymaster = TestDataUtility.getTerritoryMaster();
         insert territorymaster;
         list<Account> acclist = TestDataUtility.createAccountTestData();
         insert acclist;
         list<Contact> conlist = TestDataUtility.createConTestData();
        for(Integer i =0;i<conlist.size();i++){
            conlist[i].Accountid = acclist[i].id;
            //conlist[i].Account.Name = acclist[i].Name;
        }
         insert conlist;
        list<Opportunity>  opplist = TestDataUtility.createOppTestData();
        for(Integer j=0;j<opplist.size();j++){
            opplist[j].AccountId = acclist[j].id;
            //opplist[j].Account.name = acclist[j].name;
        }
        insert opplist;
        test.startTest();
        list<nrOpportunityContactRole__c> oppCon = TestDataUtility.createOppConRTestData(opplist,conlist);
        insert oppCon;
        test.stopTest();
    }
}