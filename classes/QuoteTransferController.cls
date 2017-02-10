/*************************************************************************\
    @ Author        : Satish lokinindi
    @ Date          : August 2015
    @ Test File     : NA
    Function        : Apex Class for QuoteTransfer Page 
    @ Audit Trial   : Repeating block for each change to the code
    -----------------------------------------------------------------------------
    
******************************************************************************/
public with sharing class QuoteTransferController {
    public Quote__c Quo {
        get;
        set;
    }
    public Quote__c QuotQuery;
    public Quote__c Quoterec;
    public Opportunity opp {
        get;
        set;
    }
    public nrOpportunityContactRole__c oppConRole;
    //public list<nrOpportunityContactRole__c> listConrl ;

    //Get the Quote Record
    public QuoteTransferController(ApexPages.StandardController std) {
            Quo = new Quote__c(); //Create a new instance 
            Opp = new Opportunity();
            Quoterec = (Quote__c) std.getRecord();
            oppConRole = new nrOpportunityContactRole__c();
        }
    //query over opp and quote
    public pagereference obtainDetails() {
            if (Quo.Opportunity__c != null) {
                opp = [select Id, AccountID, Name, Account.Name from Opportunity where Id = : Quo.Opportunity__c];
                QuotQuery = [Select Id, Contact__r.AccountID, Opportunity__c, Contact__c from Quote__c where Id = : Quoterec.Id];
            }
            return null;
        }
    //Transfer Quote  to opportunity
    public pagereference Transfer() {
        if (opp.id != null) {
            if (QuotQuery.Contact__r.AccountID == opp.AccountID) {
                QuotQuery.Opportunity__c = opp.ID;
                UtilityClass.doNotRunonTransfer = false;
                try {
                        update QuotQuery;
                 }
                    Catch(exception e) {}

                //Success Message 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'The Quote has been transferred successfully'));

                //create the contact role if not exists 
                set < ID > conrolset = new set < ID > ();
                for (nrOpportunityContactRole__c oppConRole: [select Id, Contact__c, Opportunity__c from nrOpportunityContactRole__c WHERE Opportunity__c = : opp.Id]) {
                    conrolset.add(oppConRole.Contact__c);
                }
                if (!conrolset.Contains(QuotQuery.Contact__c)) {
                    nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
                    oppConRole.Contact__c = QuotQuery.Contact__c;
                    oppConRole.Opportunity__c = opp.Id;
                    try {
                        insert oppConRole;
                    }
                    Catch(exception e) {}
                }

            } else {
                //Error Message 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please search Opportunity with Same Account '));
            }
        }
        Else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Opportunity '));
        }


        return null;
    }
}