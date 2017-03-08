public with sharing class OpportunityContactListController
{
    private final Opportunity o;
    public OpportunityContactListController(ApexPages.StandardController stdController) 
    {    
        this.o = (Opportunity)stdController.getRecord();    
    }
             
    public List<sObject> getContacts()
    {
        List<sObject> ret= new List<nrOpportunityContactRole__c>();
        for( sObject ocr : [SELECT Id FROM nrOpportunityContactRole__c WHERE Opportunity__c = :o.Id ] )  
        {
            ret.add(ocr);      
        }    
        
        return ret;
    }

}