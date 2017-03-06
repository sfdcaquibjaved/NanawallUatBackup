@isTest(SeeAllData=false)
public with sharing class TriggerTests2 {
    
    
    @isTest(SeeAllData=false)
    static void RunTest() 
    {

        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        Contact c = TriggerTests.getContact();
        insert c;
        Opportunity o = TriggerTests.getOpportunity();
        insert o; 
        
        Quote__c q = TriggerTests.getNewQuote();
        q.Contact__c = c.Id;
        q.Opportunity__c = o.Id;
        insert q;




        Quote_Detail__c qd = TriggerTests.getNewQuoteDetail();
        qd.Quote__c = q.Id;
                
//      insert qd;          
//      update qd; 
//      update q;

        Case cs = TriggerTests.getNewCase();
        insert cs;


        Service_Quote__c sq = TriggerTests.getNewServiceQuote();
        sq.Quote__c = q.Id;
        sq.Case__c = cs.Id;
        insert sq;
        update sq;
        
        
        
        Service_Quote_Detail__c sqd = TriggerTests.getNewServiceQuoteDetail();
        sqd.Service_Quote__c = sq.Id;
        insert sqd;
        update sqd;

    
    /*
        User u = [SELECT id FROM User WHERE IsActive = true LIMIT 1 ];
        nrOpportunityTeamMember__c teamMember = TriggerTests.getNewTeamMember();
        teamMember.User__c = u.Id;
        teamMember.Opportunity__c = o.Id;
        insert teamMember;
        update teamMember;
    */





//      delete teamMember;
        delete sqd;

        delete sq;      
        delete cs;

//      delete qd;
        delete q;

    }
}