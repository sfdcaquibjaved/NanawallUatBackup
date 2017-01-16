@isTest
public class testcontact_delete {
     
     static testmethod void  deletecon(){
       
         // Insert new accounts
            list<Zip_Codes_Master__c> tmList = TestDataUtility.getTerritoryMaster();
            insert tmList;
           
            Account acctt = new Account(Name='My Test Account2',BillingCity=' ', BillingCountry='United States', BillingPostalCode='12345', BillingState=' ', BillingStreet='y',ShippingCity=' ', ShippingCountry='United States', ShippingPostalCode='12345', ShippingState=' ', ShippingStreet='xy', Phone='5432167', Fax='444-5555');                                    
            insert acctt;

        // Queries to get the inserted accounts 
           Account mergeAcct = [SELECT Id, Name FROM Account WHERE Name = 'My Test Account2' LIMIT 1];

         
           list<Contact> olstContact= new list<Contact>();
        // Add the contacts to be merged
           Contact c = new Contact(); 
           c.FirstName='Joe'; 
           c.LastName='Merged';
           c.MailingCountry='United States';
           c.MailingPostalCode='08619';
           //c.Person_Engagement_Score_Max__c =2;           
           c.AccountId = mergeAcct.Id;
           olstContact.add(c);
         
         
          Contact c2 = new Contact();
          c2.FirstName='Joe';
          c2.LastName='Merged2';
          c2.MailingCountry='United States';
	      c2.MailingPostalCode='08619';
		  //c2.Person_Engagement_Score_Max__c =1; 
		  c2.AccountId = mergeAcct.Id;
		  olstContact.add(c2);
          Insert olstContact;
         
         
          list<Opportunity> Oppslist = new list<Opportunity>();
          Opportunity o = new Opportunity();
          o.Name = 'Test Opp CompetitorHelper_Test1' ;
          o.StageName = 'Qualification';
          o.CloseDate = Date.today();
          o.Country__c = 'USA';
          o.Postal_Code__c = 'TEST';
          oppslist.add(o);  
          insert Oppslist;
              
          list<Quote__c> lstQuote = new list<Quote__c>();
        
        
            Quote__c q = new Quote__c();
            q.Name = 'Test Quote';
            q.Opportunity__c = Oppslist[0].Id;
            q.Primary_Quote__c=True;
            lstQuote.add(q); 
            insert lstQuote;
         
         
          
         List<OpportunityContactRole> oppConRolelist = new List<OpportunityContactRole>();
         OpportunityContactRole oppConRole = new OpportunityContactRole();
         oppConRole.ContactId = olstContact[0].Id ;
         oppConRole.OpportunityId = OppsList[0].Id ;
         oppConRolelist.add(oppConRole);
         insert oppConRolelist;
         
           
          test.startTest();
		  try {
   				 merge c c2;
		  } catch (DmlException e) {
   		 // Process exception
    		System.debug('An unexpected error has occurred: ' + e.getMessage()); 
			}
			test.stopTest();

    }
    
}