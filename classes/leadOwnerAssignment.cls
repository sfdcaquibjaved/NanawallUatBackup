public class leadOwnerAssignment {
    public static boolean doNotRun = false;
    public static boolean doNotRunInsert = false;
    public static boolean validationPass = false;

    @ future
    //Method to Assign Ownership and territory Based on Zip code  and Run this Method in Future 
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
    //Method to Assign Ownership and territory Based on Zip code 
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

        //Map < String, Country_codes__c > countriesCode = Country_codes__c.getAll();
        //Map < String, String > countryWithCode = new map < String, String > ();
        Map < String, String > codeWithCountry = new map < String, String > ();
        //Map < String, state_codes__c > statesCode = state_codes__c.getAll();
        //Map < String, String > stateWithCode = new map < String, String > ();
        Map < String, String > codeWithState = new map < String, String > ();


        for (Country_codes__c cCode: Country_codes__c.getAll().Values()) {
            //countryWithCode.put(cCode.Country__c, cCode.Name);
            codeWithCountry.put(cCode.Name, cCode.Country__c);
        }

        for (state_codes__c sCode: state_codes__c.getAll().Values()) {
            //stateWithCode.put(sCode.States__c, sCode.Name);
            codeWithState.put(sCode.Name, sCode.States__c);
        }
        system.debug('countyrlist'+codeWithCountry);
        //Loop Over all the records passed and Assign Ownership based on Country and Zip Code for US and CANADA and  based on State for Mexico ,and based on Country for rest
        for (lead l: leadValues) {

            String leadCountryCode;
            //String leadCountry;

            if (l.CountryCode != null) {
                leadCountryCode = l.CountryCode;
            } else {
                leadCountryCode = 'Not Available';
            }

           /* if (l.Country != null) {
                leadCountry = l.Country;
            } else {
                leadCountry = 'Not Available';
            }*/
            
            if (l.postalcode != null && l.postalcode != '' && (leadCountryCode == 'US' || leadCountryCode == 'CA' /*|| leadCountry == 'United States' || leadCountry == 'Canada'*/)) {
                if (leadCountryCode == 'CA' /*|| leadCountry == 'Canada'*/) {
                    string zipCodeCanada = l.PostalCode;
                    if (zipCodeCanada.length() > 2) {
                        zips.add(zipCodeCanada.substring(0, 3).toUpperCase());
                        zips.add(zipCodeCanada.toUppercase());
                    }
                } else if (leadCountryCode == 'US' /*|| leadCountry == 'United States'*/) {
                    String zipCodeUnitedStates = l.PostalCode;
                    if (zipCodeUnitedStates.length() > 4) {
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@' + zipCodeUnitedStates);
                        String zipUS = zipCodeUnitedStates.substring(0, 5);
                        zips.add(zipUS);
                    }
                }
            } else if (leadCountryCode != 'Not Available' /*|| leadCountry != 'Not Available' && (leadCountryCode != 'US' || leadCountry != 'United States') && (leadCountryCode != 'CA' || leadCountry != 'Canada')*/) {
                if (leadCountryCode == 'MX' /*|| leadCountry == 'Mexico'*/ ) {
                    if (l.StateCode != null && codeWithState.ContainsKey(l.StateCode)) {
                        states.add(codeWithState.get(l.StateCode));
                    }
                    /*if (l.State != null && stateWithCode.ContainsKey(l.State)) {
                        states.add(state_codes__c.getinstance(stateWithCode.get(l.State)).States__c);
                    }*/
                } else
                if (leadCountryCode != 'Not Available' && codeWithCountry.containsKey(leadCountryCode)) {
                   // cntrys.add(codeWithCountry.get(leadCountryCode));
                    cntrys.add(country_codes__c.getInstance(leadCountryCode).Country__c);
                    system.debug('cntrys'+cntrys);
                }
                /*if (leadCountry != 'Not Available' && countryWithCode.containsKey(leadCountry)) {
                    cntrys.add(country_codes__c.getInstance(countryWithCode.get(leadCountry)).Country__c);
                }*/
            }
        }
        //Store the Values in Map based on Zip/Country/State from Territory Master
       // map < string, ID > territoryMap = new map < string, string > ();
        //map < string, string > newTerritoryMap = new map < string, string > ();
        map < string, string > tempTerritoryMap = new map < string, string > ();
        for (Zip_Codes_Master__c z: [Select Zip_Code__c, Country__c, user__c, state__c, Territory__c from Zip_Codes_Master__c WHERE(Zip_Code__c IN: zips OR country__c IN: cntrys OR state__c IN: states)]) {
           
            if (z.zip_code__c != null && z.zip_code__c != '' && (z.country__c == 'United States' || z.country__c == 'Canada')) {

                //territoryMap.put(z.Zip_Code__c, z.user__c);
                //newTerritoryMap.put(z.Zip_Code__c, z.Territory__c);
                tempTerritoryMap.put(z.Zip_Code__c,z.user__c + ','+ z.Territory__c);
            } else if (z.country__c == 'Mexico') {
               // territoryMap.put(z.state__c, z.user__c);
                //newTerritoryMap.put(z.state__c, z.Territory__c);
                tempTerritoryMap.put(z.state__c, z.user__c + ','+ z.Territory__c);
            } else {
                //territoryMap.put(z.country__c, z.user__c);
                //newTerritoryMap.put(z.country__c, z.Territory__c);
                tempTerritoryMap.put(z.country__c, z.user__c + ','+ z.Territory__c);
                system.debug('maplist'+tempTerritoryMap);
            }

        }

        for (lead l: leadValues) {

            String leadCountryCode;
            String leadCountry;

            if (l.CountryCode != null) {
                leadCountryCode = l.CountryCode;
            } else {
                leadCountryCode = 'Not Available';
            }

            /*if (l.Country != null) {
                leadCountry = l.Country;
            } else {
                leadCountry = 'Not Available';
            }*/

            if (l.postalcode != null && l.postalcode != '' && (leadCountryCode == 'US' || leadCountryCode == 'CA' /*|| leadCountry == 'United States' || leadCountry == 'Canada'*/)) {


                if (leadCountryCode == 'CA' /*|| leadCountry == 'Canada'*/) {
                    String zipCanada = l.postalCode;
                    if (zipCanada.length() >= 3) {
                        if (tempTerritoryMap.containsKey(zipCanada.toUpperCase())) {

                            string[] str = tempTerritoryMap.get(zipCanada.toUpperCase()).split(',');
                            user = str[0];

                            l.Territory__c = str[1];
                             //user = territoryMap.get(zipCanada.toUpperCase());
                             //l.Territory__c = newTerritoryMap.get(zipCanada.toUpperCase());
                            
                            system.debug(user);
                        } else if (tempTerritoryMap.containsKey(zipCanada.substring(0, 3).toUpperCase())) {
                            string[] str1 = tempTerritoryMap.get(zipCanada.substring(0, 3).toUpperCase()).split(',');
                            user = str1[0];

                            l.Territory__c = str1[1];
                            //user = territoryMap.get(zipCanada.substring(0, 3).toUpperCase());
                            //l.Territory__c = newTerritoryMap.get(zipCanada.substring(0, 3).toUpperCase());
                        }
                        system.debug('user is' + user);
                    }
                } else if (leadCountryCode == 'US' /*|| leadCountry == 'United States'*/) {
                    String ZipUnited= l.PostalCode;
                    if (ZipUnited.length() >= 5) {
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@' + ZipUnited);
                        string[] str2 = tempTerritoryMap.get(ZipUnited.substring(0, 5)).split(',');
                        user = str2[0];
                        l.Territory__c = str2[1];
                        // user = territoryMap.get(ZipUnited.substring(0, 5));
                         //l.Territory__c = newTerritoryMap.get(ZipUnited.substring(0, 5));
                    }
                }
                //Assign OwnerShip if data is available
                If(user != null) {
                    l.OwnerID = user;
                } else
                //Set default ownership for unmapped records to George 
                l.ownerID = id.valueof(system.label.Default_owner);

            } else if (l.CountryCode != null /*|| l.Country != null*/) {
                if (leadCountryCode == 'MX' /*|| leadCountry == 'Mexico'*/) {
                    if (l.StateCode != null && codeWithState.ContainsKey(l.StateCode)) {
                        string[] str3 = tempTerritoryMap.get(codeWithState.get(l.statecode)).split(',');
                        user = str3[0];
                        l.Territory__c = str3[1];
                        //user = territorymap.get(codeWithState.get(l.statecode));
                        //l.Territory__c = newTerritoryMap.get(codeWithState.get(l.statecode));
                    }
                    /*if (l.State != null && stateWithCode.ContainsKey(l.State)) {
                        user = territorymap.get(state_codes__c.getinstance(stateWithCode.get(l.State)).states__c);
                        l.Territory__c = newTerritoryMap.get(state_codes__c.getinstance(stateWithCode.get(l.State)).states__c);
                    }*/
                } else {
                    if (leadCountryCode != 'Not Available' && codeWithCountry.containsKey(leadCountryCode) && tempTerritoryMap.containsKey(leadCountryCode)) {
                        //string otherCntry = country_codes__c.getInstance(leadCountryCode).Country__c;
                        system.debug('debugchecklist' + leadCountryCode);
                        
                        string[] str4 = tempTerritoryMap.get(country_codes__c.getInstance(leadCountryCode).Country__c).split(',');
                        
						user = str4[0];
                        l.Territory__c = str4[1];
                         //user = territoryMap.get(codeWithCountry.get(leadCountryCode));
                         //l.Territory__c = newTerritoryMap.get(codeWithCountry.get(leadCountryCode));
                       }
                    
                    /*if (leadCountry != 'Not Available' && countryWithCode.containsKey(leadCountry)) {
                        string otherCntry = country_codes__c.getInstance(countryWithCode.get(leadCountry)).Country__c;
                        user = territoryMap.get(otherCntry);
                        l.Territory__c = newTerritoryMap.get(otherCntry);
                    }*/
                }
                if (user != null) {
                    l.OwnerID = user;

                } else
                    l.ownerID = id.valueof(system.label.Default_owner);
            }
        }
        return leadValues;
    }
    // Method to validate the data before assigning the territory and ownership
    public static List < Lead > validateZip(List < Lead > leadsList) {
         
        
        list < Lead > leadValues = new List < Lead > ();
        String leadCountryCode;
        //String leadCountry;
        
        Set<string>  leadzip = new Set<string>() ;
        //Set<string>  leadProzip = new Set<string>() ;
        
         // Loop over all the input records to get the ZipCodes and retreive from Territory Master and Store it in Map to resue to validate the data   
        for(lead ld: leadsList){
            if(ld.CountryCode != null && ld.CountryCode == 'US'  && ld.PostalCode != null && ld.PostalCode != ''){
                string leadZipCode =ld.postalCode;
                if(leadZipCode.length()>4){
                    leadzip.add(leadZipCode.substring(0, 5));
                }
             }   
             if(ld.Project_Site_Country__c == 'United States' && ld.Project_Site_Zip_Code__c != null && ld.Project_Site_Zip_Code__c !='' ){   
                string ProZipCode =ld.Project_Site_Zip_Code__c;
                if(ProZipCode.length()>4){
                    leadzip.add(ProZipCode.substring(0, 5));
                }
            } 
          
        }
        
        set<string>  setPostalCode = new set<string>();
        if(leadzip.size()>0){
            for(Zip_Codes_Master__c  zipCodMaster : [Select Zip_Code__c, user__c, state__c, country__c from Zip_Codes_Master__c where Zip_Code__c IN: leadzip ]){
                setPostalCode.add(zipCodMaster.Zip_Code__c);
            }
        }
       
        //Loop to validate the Bulk records at once
        for (lead ld: leadsList) {

            if (ld.CountryCode != null) {
                leadCountryCode = ld.CountryCode;
            } else {
                leadCountryCode = 'Not Available';
            }

            /*if (ld.Country != null) {
                leadCountry = ld.Country;
            } else {
                leadCountry = 'Not Available';
            }*/
           // string  leadzipC ;
            //string  leadzipC1 ;
            string zipUS = '\\d{5}(-\\d{4})?';
            string zipCan = '((?i)[ABCEGHJKLMNPRSTVXY]\\d[A-Z]?\\s?\\d[A-Z]\\d)?';

            Boolean returnValue = True;
            if ((leadCountryCode == 'US' || leadCountryCode == 'CA' /*|| leadCountry == 'United States' || leadCountry == 'Canada'*/ ) && (ld.PostalCode == null || ld.PostalCode == '')) {
                ld.PostalCode.adderror('Please enter a valid Zip code');
                returnValue = false;
                //return returnValue ;
            } 
            else if ((leadCountryCode != 'Not Available' /*|| leadCountry != 'Not Available'*/) && ld.PostalCode != null && (((leadCountryCode == 'US' /*|| leadCountry == 'United States'*/ ) && (!(pattern.matches(ZipUS, ld.PostalCode)))) || ((leadCountryCode == 'CA' /*|| leadCountry == 'Canada'*/ ) && (!(pattern.matches(zipCan, ld.PostalCode)))))) {

                ld.PostalCode.adderror('Please enter a valid Zip code');
                returnValue = false;
                //return returnValue ;
            }
            else if (ld.PostalCode != null && ld.PostalCode != '' && leadCountryCode == 'US' && (!setPostalCode.contains(ld.PostalCode.substring(0, 5))) ) {


                    ld.PostalCode.addError('Lead zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>', false);
                    returnValue = false;
            }
           else if ( ld.Project_Site_Zip_Code__c != null && (( ld.Project_Site_Country__c.equalsignorecase('United States'))&& (!(pattern.matches(ZipUS, ld.Project_Site_Zip_Code__c))) || ((ld.Project_Site_Country__c.equalsignorecase('Canada'))  && (!(pattern.matches(zipCan, ld.Project_Site_Zip_Code__c)))))) {

                ld.Project_Site_Zip_Code__c.adderror('Please enter a valid Zip code');
                returnValue = false;
                //return returnValue ;
            }
            else if (ld.Project_Site_Zip_Code__c != null && ld.Project_Site_Zip_Code__c != '' && ld.Project_Site_Country__c.equalsignorecase('United States') && (!setPostalCode.contains(ld.Project_Site_Zip_Code__c.substring(0, 5)))) {


                    ld.Project_Site_Zip_Code__c.addError('Project zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>', false);
                    returnValue = false;
                
            }
            system.debug('the return value is' + returnValue);
            
            if (returnValue == true) {
                leadValues.add(ld);
            }
        }
        //Return the list to trigger to Process further  based upon successful validation
        return leadValues;
    }
}