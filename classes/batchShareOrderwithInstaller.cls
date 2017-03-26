global class batchShareOrderwithInstaller implements Database.Batchable < sObject > {
String query;
// Start Method of Batch class 
    global Database.querylocator start(Database.BatchableContext BC) {
    String filters ='a1uA0000000UeAnIAK';
        Query = 'SELECT ID, Zip_Code__c,Installer_Contact__c , Installer_User__c FROM Zip_Codes_Master__c WHERE Installer_User__c != null and Id =: filters';
        system.debug('Value of Query' + Query);
        return Database.getQueryLocator(query);
        
    }
    //Execute Method of Batch class
    global void execute(Database.BatchableContext BC, List < Zip_Codes_Master__c > zip) 
    {
        System.debug('Value of zip %%%%%' +zip);
        set<String> zipcodes = new set<String>();
        for(Zip_Codes_Master__c z:zip){
           zipcodes.add(z.Zip_Code__c);
        }
        System.debug('set of zipcodes'+ zipcodes);
        map<id,id> orderzips = new map<id,id>();
        list<Order> orderlist =[select id,BillingPostalCode,AccountId from Order where BillingPostalCode in: zipcodes];
        System.debug('orderlist'+orderlist);
        for(Zip_Codes_Master__c zi:zip){
         //list<id> idss = new list<id>();
         for(order ord:orderlist){
                if(ord.BillingPostalCode == zi.Zip_Code__c){
                 orderzips.put(ord.AccountId, zi.Installer_User__c);
                }
            }
        }
       System.debug('map orderzips'+orderzips);
        /*set<id> acct = new set<id>();
        for(Id newids:orderzips.keyset()){
            list<id> accids= orderzips.get(newids);
            for(Id tr:accids){
               acct.add(tr);
            }
        }*/
        List<Account> acctoshare = [select id,name from Account where id in:orderzips.keyset()];
        System.debug('acctoshare'+acctoshare);
        List<AccountShare> sharesToCreate = new List<AccountShare>();
        for(Id usrs:orderzips.keySet()){
            for(Account at: acctoshare){
               AccountShare acc = new AccountShare();
                 acc.AccountAccessLevel = 'Read';
                 acc.AccountId = usrs;
                 acc.UserOrGroupId = orderzips.get(usrs);
                 acc.OpportunityAccessLevel = 'Read';
                 sharesToCreate.add(acc); 
            }
        }
        System.debug('sharesToCreate'+sharesToCreate);
        if (!sharesToCreate.isEmpty())
          insert sharesToCreate;
        
    }
   // Finish Method of Batch class 
    global void finish(Database.BatchableContext BC) {

    }
    
}