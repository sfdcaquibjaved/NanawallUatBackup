trigger accountownerassignmentTrigger on Account (before insert,before update,after update) {
    public list<Account> lstAccounts = new list<Account>();
    public list<Id> accIdsToUpdateOppNames = new list<Id>();
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            for(Account accRec : trigger.New){
                if((Trigger.isInsert ||
                    (Trigger.isUpdate && (Trigger.oldMap.get(accRec.Id).BillingPostalCode!=accRec.BillingPostalCode
                    ||Trigger.oldMap.get(accRec.Id).Billingstatecode!=accRec.Billingstatecode
                    ||Trigger.oldMap.get(accRec.Id).BillingCountryCode!=accRec.BillingCountryCode)
                    )
                   )
                   && accountOwnerAssignment.validateZip(accRec)
                  ){
                    lstAccounts.add(accRec);
                }
            }
            if(lstAccounts!=null && lstAccounts.size()>0){
                accountOwnerAssignment.assignOwner(lstAccounts);
            }
         }
    }
    
    //Added for SF Ticket # 37.
    if(Trigger.isAfter && Trigger.isUpdate){
    	
    	Set<Id> accountlstForOwner = new set<Id>();
    	
        for(Account a : Trigger.New){
            if(a.Name != Trigger.oldMap.get(a.Id).Name){
                accIdsToUpdateOppNames.add(a.Id);
            }
            if(a.OwnerId != Trigger.oldMap.get(a.Id).OwnerId){
            accountlstForOwner.add(a.Id);
            }
        }
        if(accIdsToUpdateOppNames.size()>0){
            projectStageUpdate.updateOppNames(accIdsToUpdateOppNames,'Account');
        }
        if (accountlstForOwner.size()>0){
        	accountOwnerAssignment.assignoppowner(accountlstForOwner);
        	
        	accountOwnerAssignment.checkProjectSplit(accountlstForOwner);
        }
    }
}