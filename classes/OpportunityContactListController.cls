<<<<<<< HEAD
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

=======
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

>>>>>>> 38d5474048e4349e5fb1b806274e5d38ea1dc1fc
}