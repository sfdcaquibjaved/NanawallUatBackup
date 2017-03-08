global class copyContacts{
    webservice static boolean copyContactsMethod(id actid){
       
        system.debug('ACCOUNTID'+actid);
        boolean result=false;
        List<Account> acts = [select id,Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, ShippingState, ShippingStreet, Phone, Fax from Account where id =:actid];
        List<Contact> cons = [select id,Name, AccountId, MailingCity, MailingCountry, MailingPostalCode, MailingState, MailingStreet, OtherCity, OtherCountry, OtherState, OtherPostalCode,OtherStreet, Fax, Phone from Contact where AccountId =:acts[0].id];
        system.debug('the contacts are:::'+cons);
        List<Contact> contactsList = new lIST<contact>();
        
        for(Account a:acts){
            for(Contact c:cons){
                c.MailingCity = a.BillingCity;
                c.MailingCountry = a.BillingCountry;
                c.MailingPostalCode = a.BillingPostalCode;
                c.MailingState = a.BillingState;
                c.MailingStreet = a.BillingStreet;
                c.OtherCity = a.ShippingCity;
                c.OtherCountry = a.ShippingCountry;
                c.OtherState = a.ShippingState;
                c.OtherStreet = a.ShippingStreet;
                c.OtherPostalCode = a.ShippingPostalCode;
                c.Phone = a.Phone;
                c.Fax = a.Fax;
                contactsList.add(c);
            }
        }
        Database.SaveResult[] res;
        try{
        res=database.update(contactsList,true);
        }catch(exception e){}
        if(res!=NULL)
        {
        for (Database.SaveResult sr : res) {
        if (sr.isSuccess()) {
        result=true;
    }
    else{
    result=false;
    }
    }
    }else
    result = false;
    return result;
        
    }
}