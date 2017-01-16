trigger Account_SetOwner on Account (before insert) {

    /*
     this trigger works in conjunction with our assignment rules when converting leads -- makes sure we don’t overwrite an 
     owner of a lead (or overwrite when necessary) based on lead convert options
     */

    /*for( Account a : trigger.new )
    {
        if( a.DoNotAutoAssignOwner__c != true )
        {
            if( a.BillingPostalCode != '' && ( a.Zip__c == null || a.Zip__c == '' ) )
            {
                a.Zip__c = a.BillingPostalCode;
            }
            
            if( a.BillingCountry != '' && ( a.Country__c == null || a.Country__c == '' ) )
            {
                a.Country__c = a.BillingCountry;
            }
            
            
            string country = ( a.BillingCountryCode != null ? a.BillingCountryCode : a.Country__c );
            string zipcode = ( a.BillingPostalCode != null ? a.BillingPostalCode : a.Zip__c );
            
            a.OwnerId = Utility.getUserForTerritory(a.BillingCountryCode, a.BillingPostalCode);
        }
    }*/
}