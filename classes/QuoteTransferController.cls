/*************************************************************************\
    @ Author        : Satish lokinindi
    @ Date          : August 2015
    @ Test File     : NA
    Function        : Apex Class for QuoteTransfer Page 
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/
public with sharing class QuoteTransferController {
    public Quote__c quo {get;set;}
    public Quote__c queryQuoteToUpdate;
    public Quote__c quoteRec;
    public Opportunity opp {get;set;}
    public nrOpportunityContactRole__c oppConRole;
    //public list<nrOpportunityContactRole__c> listConrl ;

    //Get the Quote Record
    public QuoteTransferController(ApexPages.StandardController std) {
            quo = new Quote__c(); //Create a new instances 
            opp = new Opportunity();
            quoteRec = (Quote__c) std.getRecord();
            oppConRole = new nrOpportunityContactRole__c();
           
        }
    //query over  Opportunity and Quote  to obtain  record information 
    public pagereference obtainDetails() {
            if (quo.Opportunity__c != null) {
                opp = [select Id, AccountID, Name, Account.Name from Opportunity where Id = : quo.Opportunity__c];
                queryQuoteToUpdate = [Select Id, Contact__r.AccountID, Opportunity__c, Contact__c,order__c from Quote__c where Id = : quoteRec.Id];
            }
            return null;
        }
    //Method to Transfer Quote  to opportunity and to validate before Transfer
    public pagereference transfer() {
        //Null Check 
        if (opp.id != null) {
        //Check  for Account on Quote rec and Account in opportunity rec to be  transferred are same or not
            if (queryQuoteToUpdate.Contact__r.AccountID == opp.AccountID) {
            // Do not Transfer Quotes with Orders
                if(queryQuoteToUpdate.order__c ==null){
                queryQuoteToUpdate.Opportunity__c = opp.ID;
                 UtilityClass.doNotRunonTransfer = false;//Static Boolean to ensure that Trigger to vaildate the duplicate  Opportunities method doesn't invoke.
                try {
                
                        update queryQuoteToUpdate;
                //Display Success Message once quote got transferred successfully 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'The Quote has been transferred successfully'));
                   
                 }
                    Catch(exception e) {}
                
                
                //create the contact role if Doesn't exists in opportunity related list upon transfer  
                set < ID > setConRolIds = new set < ID > ();
                for (nrOpportunityContactRole__c oppConRole: [select Id, Contact__c, Opportunity__c from nrOpportunityContactRole__c WHERE Opportunity__c = : opp.Id]) {
                    setConRolIds.add(oppConRole.Contact__c);
                }
                if (!setConRolIds.Contains(queryQuoteToUpdate.Contact__c)) {
                    nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                    oppConRole.Contact__c = queryQuoteToUpdate.Contact__c;
                    oppConRole.Opportunity__c = opp.Id;
                    try {
                        insert oppConRole;
                    }
                    Catch(exception e) {}
                }
                }else
                {
                //Display Error Message When Quote having any orders before Quote transfer
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You have an order in the quote so you cannot transfer the quote'));
                }
            }
            else {
                //Display Error Message when Quote and Opportunity Account Ids are diferent
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please search Opportunity with Same Account '));
            }
        }
        else {
            //Display Error Message  when opportunity is not selected on Page
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Opportunity '));
        }

        
        return null;
    }
}