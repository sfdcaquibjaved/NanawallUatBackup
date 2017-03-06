trigger Contact_SetOwner on Contact (before insert) {

    /*
    trigger purpose
        before inserting a contact, assigns the owner based on a zip code 
    */

    for( Contact c : trigger.new )
    {
        //this is taken out of normalize trigger because we realize we cannot know 
        //the order they should be running in
        if( c.MailingPostalCode != '' && ( c.Zip__c == null || c.Zip__c == '' ) )
        {
            c.Zip__c = c.MailingPostalCode;
        }
        
        if( c.MailingCountry != '' && ( c.Country__c == null || c.Country__c == '' ) )
        {
            c.Country__c = c.MailingCountry;
        }
        
        
        string country = ( c.MailingCountryCode != null ? c.MailingCountryCode : c.Country__c );
        string postalcode =  ( c.MailingPostalCode != null ? c.MailingPostalCode : c.Zip__c );
        
        c.OwnerId = Utility.getUserForTerritory( country, postalcode );

    }

}