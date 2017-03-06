trigger Lead_SetOwner on Lead (before insert) {

    /*
    trigger purpose
        sets proper owner id based on zip code
    */

    for( Lead l : trigger.new )
    {
        if( l.PostalCode != '' && ( l.Zip__c == null || l.Zip__c == '' ) )
        {
            l.Zip__c = l.PostalCode;
        }
        
        if( l.Country != '' && ( l.nrCountry__c == null || l.nrCountry__c == '' ) )
        {
            l.nrCountry__c = l.Country;
        }
        
        
        string countrycode = ( l.CountryCode != null && l.CountryCode != '' ? l.CountryCode : l.nrCountry__c );
        string postalcode = ( l.PostalCode != null ? l.PostalCode : l.Zip__c );


        l.OwnerId = Utility.getUserForTerritory( countrycode, postalcode );
        
    }
}