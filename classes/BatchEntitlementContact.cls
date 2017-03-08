/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : October-2016
    @ Description   : Batch Class to add Entitlement Contact on Entitlement Record
    @ Audit Trial   : 
    @ Test Class    : 
    @ Last Modified Date : 13-Oct-2016
  
****************************************************************************/
global class BatchEntitlementContact implements Database.Batchable < sObject > {

    String query;

    // Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
      //  set<ID> EntSet = new set<ID>{'550n0000002B2WY' ,'550n0000002BC6H' , '550n0000002B2O1' };
        Query = 'Select id,Nana_Quote__c , Nana_Quote__r.Contact__c , Nana_Quote__r.Opportunity__c , Nana_Quote__r.Project__c , Nana_Quote__r.Project__r.Owner.Email from Entitlement  WHERE Nana_Quote__c != null ';
        system.debug('Value of Query' + Query);
        return Database.getQueryLocator(query);
        
    }

    //Execute Method of Batch class
    global void execute(Database.BatchableContext BC, List < Entitlement > ent) {

        set < EntitlementContact > ContactInsert = new set < EntitlementContact > ();
        set < id > QuoteId = new set < id > ();
System.debug('Entitle'+ent);
            for(Entitlement e : ent ){
                    EntitlementContact EC = new EntitlementContact () ;
                    EC.ContactID = e.Nana_Quote__r.Contact__c ;
          
                    EC.EntitlementId = e.ID ; 
                    ContactInsert.add(ec);
                    system.debug('The value in ContactInsert1' + ContactInsert);
                    }
        
        
        
       

      

        // for adding project owner as entitlement contact
        
        set<string> OwnerEmailPro = new set<String> () ; 
		 for(Entitlement e : Ent) {
            OwnerEmailPro.add(e.Nana_Quote__r.Project__r.Owner.Email) ;   
        }
        system.debug('Value of OwnerEmailPro ' + OwnerEmailPro);
        List<Contact> ContactProject = [SELECT Name , Email FROM Contact WHERE EMAIL IN : OwnerEmailPro] ; 
    	system.debug('Value in ContactProject' + ContactProject);
        for(Entitlement e : ENT ){
            for(Contact con : ContactProject){
                if(e.Nana_Quote__r.Project__r.Owner.Email == con.email){
                    
                    EntitlementContact ec = new EntitlementContact() ;
                    ec.EntitlementId = e.id ; 
                    ec.ContactId = con.ID ;
                    ContactInsert.add(ec);
        			system.debug('Value in ContactInsert2' + ContactInsert);
                }
            }
        }
        
    
       // For adding Opportunity role as  entitlement contact
       
        set<ID> OpportunitySetID =  new set<ID>();
        for(Entitlement e : ent){
            OpportunitySetID.add(e.Nana_Quote__r.Opportunity__c);
        }
        system.debug('Value in OpportunitySetID' + OpportunitySetID );
		List<OpportunityContactRole> OppConRoleList = [SELECT ID , ContactID , OpportunityID FROM OpportunityContactRole WHERE OpportunityID IN: OpportunitySetID ];       
        system.debug('Value in OppConRoleList' + OppConRoleList);
        
        for(Entitlement e : Ent) {
            for(OpportunityContactRole OCR : OppConRoleList){
                if(e.nana_quote__r.opportunity__c == OCR.OpportunityID ){
                   
                    EntitlementContact ec = new EntitlementContact() ;
                    ec.EntitlementId = e.id ; 
                    ec.ContactId = Ocr.ContactId ;
                    ContactInsert.add(ec);
                    system.debug('Value in ContactInsert3' + ContactInsert);
                }
            }
        }
        

        // To create entitlement contact from influencer opportunity
        
        set<ID> ProjectSetID = new Set<ID> ();
            
            for(Entitlement e : ent){
                ProjectSetID.add(e.Nana_Quote__r.Project__c);
                system.debug('test ProjectSetid'+ProjectSetid);
            }
            
			List<Opportunity> OppListInf = [SELECT Id FROM Opportunity WHERE RecordType.Name = 'Influencer Opportunity' AND Project_Name__c IN: ProjectSetID];
              system.debug('Value in OppListInf' + OppListInf);
        	List<ID> OppListIDInf = new List<ID> () ; 
        for(Opportunity opp : OppListInf ){
            OppListIDInf.add(opp.id);
        }
        
			system.debug('Value of ProjectSetID' + ProjectSetID);        	
        	List<OpportunityContactRole> ocrList = [SELECT Id , OpportunityID , Opportunity.Project_Name__c ,  ContactID FROM OpportunityContactRole WHERE OpportunityID IN:OppListIDInf];
        	system.debug('Value of ocrList' + ocrList);
        for(Entitlement e : ent){
            for(OpportunityContactRole ocr :ocrList ){
                if(e.nana_quote__r.project__c == ocr.opportunity.Project_Name__c){
                    EntitlementContact ec = new EntitlementContact() ;
                    ec.EntitlementId = e.id ; 
                    ec.ContactId = Ocr.ContactId ;
                    ContactInsert.add(ec);
                    system.debug('Value of ContactInsert4' + ContactInsert);
                }
            }
        }
        
            
       

        try {
            List < EntitlementContact > EntitlementContactList = new List < EntitlementContact > ();
            EntitlementContactList.addAll(ContactInsert);
            insert EntitlementContactList;
            system.debug('The value in EntitlementContactList' + EntitlementContactList);
        } catch (exception e) {
            system.debug('Exception is:' + e);
        }


    }

    global void finish(Database.BatchableContext BC) {

    }
}