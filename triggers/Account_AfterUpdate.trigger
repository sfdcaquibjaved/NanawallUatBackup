trigger Account_AfterUpdate on Account (after update) {

    //if an account is flagged as Chain, this triggers pulls its whoel hierarchy and makes sure all the accounts in the hierarchy are chain

    if( trigger.size  == 1 )
    {
        //trigger, when an account is marked a chain account and the list is exactly 1 being updated, 
        //go down and up the account parent id; 
        //don't update it if its already a chain account 
        try 
        {
            list<Account> accountsToUpdate = new list<Account>();
            for( Account a : trigger.new ) 
            {
                if( (trigger.oldMap.get(a.id).Chain_Account__c == null 
                    ||  trigger.oldMap.get(a.id).Chain_Account__c == false ) 
                && a.Chain_Account__c == true)
                {
                    Map<id,Account> accountsInTree =  Utility.AccountTreetoList(a.id);
                    for( string key : accountsIntree.keyset() )
                    {
                        if( !accountsintree.get(key).Chain_Account__c )
                        {
                            Account acc = accountsintree.get(key);
                            acc.Chain_Account__c = true;
                            accountsToUpdate.add(acc);
                        }
                    }
                }
            }
            
            
            if(accountsToUpdate.size() > 0 )
                update accountsToUpdate;
        } catch( Exception ex ) {
            System.debug(ex);
        }
    }
}