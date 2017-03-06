/*************************************************
Purpose:To create entitlements for legacy data for the old model of Nanaquote
**************************************************/
global class entitlementBatch implements Database.Batchable<sObject>{
  //  string qtId = 'a0AA0000000ct1d';
  
  
  
 
  
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select id,Name, Balanced_Received_Date__c FROM Quote__c where Balanced_Received_Date__c !=null';        system.debug('The query is:::'+query);
        return Database.getQueryLocator(query);
    }


        global void execute(Database.BatchableContext BC, List<Quote__c> scope){
        
        List<Quote_Detail__c> quoteDetaillist = [select Name,Quote__c,Quote__r.Name,Model__c,Quote__r.Account_Name__c,Quote__r.Contact_Account_ID__c,Quote__r.Install_Date__c,Quote__r.Actual_Delivery_Date__c,Quote__r.Balanced_Received_Date__c,Quote__r.Contact__c from Quote_Detail__c where Quote__c in:scope];
        system.debug('The Quote Details are::::::'+quoteDetaillist);
        List<Entitlement> entitleList = new List<Entitlement>();
        
        warranties__c entwar = warranties__c.getOrgDefaults();
        Map<string, warranties__c > mp = warranties__c.getAll();
        //system.debug('the warranties::::'+mp.get('HSW 66').Roller_Name__c);
        for(Quote__c qt : scope){  
             for(Quote_Detail__c quoteDetail:quoteDetaillist){
             if(quoteDetail.quote__c ==qt.id){
             if(mp.containskey(quoteDetail.model__c)){
                Entitlement Entitle = new Entitlement();
                Entitle.nAME = quoteDetail.Name + ' '+quoteDetail.Model__c;
                Entitle.accountid = quoteDetail.Quote__r.Contact_Account_ID__c ;
                Entitle.Contacts__c = quoteDetail.Quote__r.Contact__c;
                Entitle.Nana_Quote__c = quoteDetail.Quote__c;
                Entitle.Quote_Detail__c = quoteDetail.id; 
                Entitle.StartDate = quoteDetail.Quote__r.Balanced_Received_Date__c;
                Entitle.SlaProcessId = system.Label.Sla_Process;                    
                entitleList.add(Entitle);
                
                Entitlement Entitle1 = new Entitlement();
                Entitle1.nAME = quoteDetail.Name + ' '+quoteDetail.Model__c+ ' ' +'Roller';
                Entitle1.accountid = quoteDetail.Quote__r.Contact_Account_ID__c;
                Entitle1.Contacts__c = quoteDetail.Quote__r.Contact__c;
                Entitle1.Nana_Quote__c = quoteDetail.Quote__c;
                Entitle1.Quote_Detail__c = quoteDetail.id; 
                Entitle1.StartDate = quoteDetail.Quote__r.Balanced_Received_Date__c; 
                Entitle1.SlaProcessId = system.Label.Sla_Process;                             
                entitleList.add(Entitle1);
                system.debug('***********entitleList****'+entitleList);
                }
                else{
                Entitlement Entitle2 = new Entitlement();
                Entitle2.nAME = quoteDetail.Name + ' '+quoteDetail.Model__c;
                Entitle2.accountid = quoteDetail.Quote__r.Contact_Account_ID__c;
                Entitle2.Contacts__c = quoteDetail.Quote__r.Contact__c;
                Entitle2.Nana_Quote__c = quoteDetail.Quote__c;
                Entitle2.Quote_Detail__c = quoteDetail.id; 
                Entitle2.StartDate = quoteDetail.Quote__r.Balanced_Received_Date__c;  
                Entitle2.SlaProcessId = system.Label.Sla_Process;                           
                entitleList.add(Entitle2);
                system.debug('*******entitleList1*********'+entitleList);
                }
                }
            }
       }
        if(entitleList.size()>0){
        insert entitleList;
        }
        }
        
        
    global void finish(Database.BatchableContext BC){
    }

    
}