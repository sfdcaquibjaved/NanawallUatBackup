public class leadOwnerAssignment {
    public static boolean doNotRun = false;
    public static boolean doNotRunInsert = false;
    public static boolean validationPass = false;

    @ future
    public static void assignOwner(set < ID > leadID) {

        list < Lead > leadValues = [select ownerID, countryCode, Project_Site_Zip_Code__c, Project_Site_Country__c, postalCode, country, State, stateCode from lead where id in: leadID];
        leadValues = prepareLeadRecordValues(leadValues);

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = false;
        dmo.EmailHeader.triggerAutoResponseEmail = false;
        dmo.EmailHeader.triggerOtherEmail = false;
        leadOwnerAssignment.doNotRun = true;
        try {
            Database.update(leadValues, dmo);
        } catch (Exception ex) {}

    }

    public static list < Lead > prepareLeadRecordValues(list < lead > leadValues) {
        /*system.debug('GET CPU TIME : '+ limits.getCpuTime() +' ' + limits.getLimitCpuTime());
       list<lead> leadValues = new list<lead>();
       for (lead checkValidity : leadValuesPimary){
        if(validateZip(checkValidity)){
           system.debug('GET CPU TIME : '+ limits.getCpuTime() +' ' + limits.getLimitCpuTime());
            leadValues.add(checkValidity);
            }
        }*/
        set < string > zips = new set < string > ();
        set < string > cntrys = new set < string > ();
        set < string > states = new set < string > ();
        string user, zipDummy;

        Map < String, Country_codes__c > countriesCode = Country_codes__c.getAll();
        Map < String, String > countryWithCode = new map < String, String > ();
        Map < String, String > codeWithCountry = new map < String, String > ();
        Map < String, state_codes__c > statesCode = state_codes__c.getAll();
        Map < String, String > stateWithCode = new map < String, String > ();
        Map < String, String > codeWithState = new map < String, String > ();


        for (Country_codes__c cCode: countriesCode.Values()) {
            countryWithCode.put(cCode.Country__c, cCode.Name);
            codeWithCountry.put(cCode.Name, cCode.Country__c);
        }

        for (state_codes__c sCode: statesCode.Values()) {
            stateWithCode.put(sCode.States__c, sCode.Name);
            codeWithState.put(sCode.Name, sCode.States__c);
        }

        for (lead l: leadValues) {

            String leadCountryCode;
            String leadCountry;

            if (l.CountryCode != null) {
                leadCountryCode = l.CountryCode;
            } else {
                leadCountryCode = 'Not Available';
            }

            if (l.Country != null) {
                leadCountry = l.Country;
            } else {
                leadCountry = 'Not Available';
            }

            if (l.postalcode != null && l.postalcode != '' && (leadCountryCode == 'US' || leadCountryCode == 'CA' || leadCountry == 'United States' || leadCountry == 'Canada')) {
                if (leadCountryCode == 'CA' || leadCountry == 'Canada') {
                    string zipCodeCanada = l.PostalCode;
                    if (zipCodeCanada.length() >= 3) {
                        zips.add(zipCodeCanada.substring(0, 3).toUpperCase());
                        zips.add(zipCodeCanada.toUppercase());
                    }
                } else if (leadCountryCode == 'US' || leadCountry == 'United States') {
                    String zipCodeUnitedStates = l.PostalCode;
                    if (zipCodeUnitedStates.length() >= 5) {
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@' + zipCodeUnitedStates);
                        String zipUS = zipCodeUnitedStates.substring(0, 5);
                        zips.add(zipUS);
                    }
                }
            } else if ((leadCountryCode != 'Not Available' || leadCountry != 'Not Available') && (leadCountryCode != 'US' || leadCountry != 'United States') && (leadCountryCode != 'CA' || leadCountry != 'Canada')) {
                if (leadCountryCode == 'MX' || leadCountry == 'Mexico') {
                    if (l.StateCode != null && codeWithState.ContainsKey(l.StateCode)) {
                        states.add(state_codes__c.getinstance(l.StateCode).States__c);
                    }
                    if (l.State != null && stateWithCode.ContainsKey(l.State)) {
                        states.add(state_codes__c.getinstance(stateWithCode.get(l.State)).States__c);
                    }
                } else
                if (leadCountryCode != 'Not Available' && codeWithCountry.containsKey(leadCountryCode)) {
                    cntrys.add(country_codes__c.getInstance(leadCountryCode).Country__c);
                }
                if (leadCountry != 'Not Available' && countryWithCode.containsKey(leadCountry)) {
                    cntrys.add(country_codes__c.getInstance(countryWithCode.get(leadCountry)).Country__c);
                }
            }
        }

        map < string, ID > territoryMap = new map < string, string > ();
        map < string, string > newTerritoryMap = new map < string, string > ();
        for (Zip_Codes_Master__c z: [Select Zip_Code__c, Country__c, user__c, state__c, Territory__c from Zip_Codes_Master__c WHERE(Zip_Code__c IN: zips OR country__c IN: cntrys OR state__c IN: states)]) {
            if (z.zip_code__c != null && z.zip_code__c != '' && (z.country__c == 'United States' || z.country__c == 'Canada')) {

                territoryMap.put(z.Zip_Code__c, z.user__c);
                newTerritoryMap.put(z.Zip_Code__c, z.Territory__c);
            } else if (z.country__c == 'Mexico') {
                territoryMap.put(z.state__c, z.user__c);
                newTerritoryMap.put(z.state__c, z.Territory__c);
            } else
                territoryMap.put(z.country__c, z.user__c);
            newTerritoryMap.put(z.country__c, z.Territory__c);

        }

        for (lead l: leadValues) {

            String leadCountryCode;
            String leadCountry;

            if (l.CountryCode != null) {
                leadCountryCode = l.CountryCode;
            } else {
                leadCountryCode = 'Not Available';
            }

            if (l.Country != null) {
                leadCountry = l.Country;
            } else {
                leadCountry = 'Not Available';
            }

            if (l.postalcode != null && l.postalcode != '' && (leadCountryCode == 'US' || leadCountryCode == 'CA' || leadCountry == 'United States' || leadCountry == 'Canada')) {


                if (leadCountryCode == 'CA' || leadCountry == 'Canada') {
                    String zipCanada = l.postalCode;
                    if (zipCanada.length() >= 3) {
                        if (territoryMap.containsKey(zipCanada.toUpperCase())) {
                            user = territoryMap.get(zipCanada.toUpperCase());
                            l.Territory__c = newTerritoryMap.get(zipCanada.toUpperCase());
                            system.debug(user);
                        } else if (territoryMap.containsKey(zipCanada.substring(0, 3).toUpperCase())) {
                            user = territoryMap.get(zipCanada.substring(0, 3).toUpperCase());
                            l.Territory__c = newTerritoryMap.get(zipCanada.substring(0, 3).toUpperCase());
                        }
                        system.debug('user is' + user);
                    }
                } else if (leadCountryCode == 'US' || leadCountry == 'United States') {
                    String ZipC2 = l.PostalCode;
                    if (ZipC2.length() >= 5) {
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@' + ZipC2);
                        user = territoryMap.get(ZipC2.substring(0, 5));
                        l.Territory__c = newTerritoryMap.get(ZipC2.substring(0, 5));
                    }
                }
                If(user != null) {
                    l.OwnerID = user;
                } else

                l.ownerID = id.valueof(system.label.Default_owner);

            } else if (l.countryCode != null || l.Country != null) {
                if (leadCountryCode == 'MX' || leadCountry == 'Mexico') {
                    if (l.StateCode != null && codeWithState.ContainsKey(l.StateCode)) {
                        user = territorymap.get(state_codes__c.getinstance(l.statecode).states__c);
                        l.Territory__c = newTerritoryMap.get(state_codes__c.getinstance(l.statecode).states__c);
                    }
                    if (l.State != null && stateWithCode.ContainsKey(l.State)) {
                        user = territorymap.get(state_codes__c.getinstance(stateWithCode.get(l.State)).states__c);
                        l.Territory__c = newTerritoryMap.get(state_codes__c.getinstance(stateWithCode.get(l.State)).states__c);
                    }
                } else {
                    if (leadCountryCode != 'Not Available' && codeWithCountry.containsKey(leadCountryCode)) {
                        string otherCntry = country_codes__c.getInstance(leadCountryCode).Country__c;
                        user = territoryMap.get(otherCntry);
                        l.Territory__c = newTerritoryMap.get(otherCntry);
                    }
                    if (leadCountry != 'Not Available' && countryWithCode.containsKey(leadCountry)) {
                        string otherCntry = country_codes__c.getInstance(countryWithCode.get(leadCountry)).Country__c;
                        user = territoryMap.get(otherCntry);
                        l.Territory__c = newTerritoryMap.get(otherCntry);
                    }
                }
                if (user != null) {
                    l.OwnerID = user;

                } else
                    l.ownerID = id.valueof(system.label.Default_owner);
            }
        }
        return leadValues;
    }
    public static List < Lead > validateZip(List < Lead > leadsList) {
        set < string > leadzip = new set < string > ();
        set < string > leadzip1 = new set < string > ();
        list < Lead > leadvalues = new List < Lead > ();
        String leadCountryCode;
        String leadCountry;

        for (lead ld: leadsList) {

            if (ld.CountryCode != null) {
                leadCountryCode = ld.CountryCode;
            } else {
                leadCountryCode = 'Not Available';
            }

            if (ld.Country != null) {
                leadCountry = ld.Country;
            } else {
                leadCountry = 'Not Available';
            }

            string zipUS = '\\d{5}(-\\d{4})?';
            string zipCan = '((?i)[ABCEGHJKLMNPRSTVXY]\\d[A-Z]?\\s?\\d[A-Z]\\d)?';

            Boolean returnValue = True;
            if ((leadCountryCode == 'US' || leadCountryCode == 'CA' /*|| leadCountry == 'United States' || leadCountry == 'Canada'*/ ) && (ld.PostalCode == null || ld.PostalCode == '')) {
                ld.PostalCode.adderror('Please enter a valid Zip code');
                returnValue = false;
                //return returnValue ;
            } 
            if ((leadCountryCode != 'Not Available' || leadCountry != 'Not Available') && ld.PostalCode != null && (((leadCountryCode == 'US' /*|| leadCountry == 'United States'*/ ) && (!(pattern.matches(ZipUS, ld.PostalCode)))) || ((leadCountryCode == 'CA' /*|| leadCountry == 'Canada'*/ ) && (!(pattern.matches(zipCan, ld.PostalCode)))))) {

                ld.PostalCode.adderror('Please enter a valid Zip code');
                returnValue = false;
                //return returnValue ;
            }
            if (ld.PostalCode != null && ld.PostalCode != '' && leadCountryCode == 'US' &&  returnValue == true) {

                if (leadCountryCode == 'US') {
                    leadzip.add(ld.PostalCode.substring(0, 5));
                }

                list < Zip_Codes_Master__c > z = [Select Zip_Code__c, user__c, state__c, country__c from Zip_Codes_Master__c WHERE Zip_Code__c IN: leadzip];
                if (z.size() == 0) {

                    ld.PostalCode.addError('Lead zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>', false);
                    returnValue = false;
                    //return returnValue ;
                }
            }
           if ( ld.Project_Site_Zip_Code__c != null && (( ld.Project_Site_Country__c == 'United States' )&& (!(pattern.matches(ZipUS, ld.Project_Site_Zip_Code__c))) || ((ld.Project_Site_Country__c == 'Canada')  && (!(pattern.matches(zipCan, ld.Project_Site_Zip_Code__c)))))) {

                ld.Project_Site_Zip_Code__c.adderror('Please enter a valid Zip code');
                returnValue = false;
                //return returnValue ;
            }
            if (ld.Project_Site_Zip_Code__c != null && ld.Project_Site_Zip_Code__c != '' && ld.Project_Site_Country__c == 'United States' &&  returnValue == true) {

                if (ld.Project_Site_Country__c == 'United States') {
                    leadzip1.add(ld.Project_Site_Zip_Code__c.substring(0, 5));
                }

                list < Zip_Codes_Master__c > z1 = [Select Zip_Code__c, user__c, state__c, country__c from Zip_Codes_Master__c WHERE Zip_Code__c IN: leadzip1];
                system.debug('###########' + z1.size());
                if (z1.size() == 0) {
                    ld.Project_Site_Zip_Code__c.addError('Project zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>', false);
                    returnValue = false;
                }
            }
            system.debug('the return value is' + returnValue);
            if (returnValue == true) {
                leadvalues.add(ld);
            }
        }
        return leadvalues;
    }
}