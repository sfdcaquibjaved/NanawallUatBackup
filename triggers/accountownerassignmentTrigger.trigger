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
        Set<Account> accountUpdateAddSet = new set<Account>();
        for(Account a : Trigger.New){
            //Updating case Deatils
            if((trigger.oldMap.get(a.id).ShippingStreet!=a.ShippingStreet) || (trigger.oldMap.get(a.id).Shippingcity!=a.Shippingcity) || (trigger.oldMap.get(a.id).ShippingState!=a.ShippingState) || (trigger.oldMap.get(a.id).ShippingCountry!=a.ShippingCountry) || (trigger.oldMap.get(a.id).ShippingPostalCode!=a.ShippingPostalCode) || (trigger.oldMap.get(a.id).BillingPostalCode!=a.BillingPostalCode) || (trigger.oldMap.get(a.id).BillingCountry!=a.BillingCountry) || (trigger.oldMap.get(a.id).BillingState!=a.BillingState) || (trigger.oldMap.get(a.id).Billingcity!=a.Billingcity) || (trigger.oldMap.get(a.id).Billingstreet!=a.Billingstreet))
            {
                accountUpdateAddSet.add(a);
            }
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
        if(accountUpdateAddSet.size()>0)
        {
            accountOwnerAssignment.CaseUpdationwithAccountAddress(accountUpdateAddSet);
        }
    }
}