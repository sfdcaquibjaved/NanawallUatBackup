/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : October-2016
    @ Description   : Handler class for EntitlementTrigger
    @ Audit Trial   : 
    @ Test Class    : 
    @ Last Modified Date : 20-10-2016
  
****************************************************************************/

public class EntitlementTriggerHelper {
    
        /*  
         Method Name    : CreateEntitlementContact
         Purpose        : This Method serves the pupose of creating EntitlementContact for entitlement.
         Input Parameter: List of Installation
         Created Date   : October 2016
         */
    public static void CreateEntitlementContact(List < Entitlement > newTrigger) {
         set < EntitlementContact > ContactInsert = new set < EntitlementContact > ();
         set<ID> QuoteID = new set<ID>();
        
        for(Entitlement e : newTrigger){
            QuoteID.add(e.Nana_Quote__c) ; 
        }
       List<Quote__c> QuoteList = [SELECT Contact__c , opportunity__c, project__c ,ID , Project__r.Owner.Email FROM Quote__c WHERE ID in: QuoteID] ; 
        
       for(Entitlement e : newTrigger ){
            for(Quote__c q : QuoteList)
       			 {
                     if(q.contact__c != null ){
                            EntitlementContact EC = new EntitlementContact () ;
                            EC.ContactID = q.contact__c ; 
                            EC.EntitlementId = e.ID ; 
                            ContactInsert.add(ec);
                            system.debug('The value in ContactInsert1' + ContactInsert);
                    }
                 }
            }
        
         // for adding project owner as entitlement contact
         
        set<string> OwnerEmailPro = new set<String> () ; 
		 for(Quote__c q : QuoteList) {
            OwnerEmailPro.add(q.Project__r.Owner.Email) ;   
        }
        
         List<Contact> ContactProject = [SELECT Name , Email FROM Contact WHERE EMAIL IN : OwnerEmailPro] ;
        	
        for(Entitlement e : newTrigger ){
            for(Contact con : ContactProject){
   
                    EntitlementContact ec = new EntitlementContact() ;
                    ec.EntitlementId = e.id ; 
                    ec.ContactId = con.ID ;
                    ContactInsert.add(ec);
        			system.debug('Value in ContactInsert2' + ContactInsert);
                
            }
        }
        
         // For adding Opportunity role as  entitlement contact
       
        set<ID> OpportunitySetID =  new set<ID>();
        
        for(Quote__c q : QuoteList){
            OpportunitySetID.add(q.Opportunity__c);
        }
        
        List<OpportunityContactRole> OppConRoleList = [SELECT ID , ContactID , OpportunityID FROM OpportunityContactRole WHERE OpportunityID IN: OpportunitySetID ];       
        
         for(Entitlement e : newTrigger) {
             for(OpportunityContactRole OCR : OppConRoleList){
         		      
                    EntitlementContact ec = new EntitlementContact() ;
                    ec.EntitlementId = e.id ; 
                    ec.ContactId = Ocr.ContactId ;
                    ContactInsert.add(ec);
                    system.debug('Value in ContactInsert3' + ContactInsert);
             }
         }
        
        // To create entitlement contact from influencer opportunity
        
        set<ID> ProjectSetID = new Set<ID> ();
            
            for(Quote__c q : quoteList){
                 ProjectSetID.add(q.Project__c);
                system.debug('test ProjectSetid'+ProjectSetid);
            }
        	List<Opportunity> OppListInf = [SELECT Id FROM Opportunity WHERE RecordType.Name = 'Influencer Opportunity' AND Project_Name__c IN: ProjectSetID];
        
           List<ID> OppListIDInf = new List<ID> () ; 
        for(Opportunity opp : OppListInf ){
            OppListIDInf.add(opp.id);
        }
        
        List<OpportunityContactRole> ocrList = [SELECT Id , OpportunityID , Opportunity.Project_Name__c ,  ContactID FROM OpportunityContactRole WHERE OpportunityID IN:OppListIDInf];
       
        for(Entitlement e : newTrigger){
            for(OpportunityContactRole ocr :ocrList ){
                    EntitlementContact ec = new EntitlementContact() ;
                    ec.EntitlementId = e.id ; 
                    ec.ContactId = Ocr.ContactId ;
                    ContactInsert.add(ec);
            }
        }
       
        List < EntitlementContact > EntitlementContactList = new List < EntitlementContact > ();
            EntitlementContactList.addAll(ContactInsert);
        try{
            insert EntitlementContactList;
        }
        catch(exception e){
            system.debug('Exception is:' +e);
        }
    }

}