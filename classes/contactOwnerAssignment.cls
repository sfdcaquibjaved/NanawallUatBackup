public with sharing class contactOwnerAssignment {
 public static boolean validationPass=false;
    public static void assignOwner (List<contact> contactValues) {
set<string> zips = new set<string>(); 
set<string> cntrys = new set<string>();
set<string> states= new set<string>();
string user,zipDummy;
    for (contact l: contactValues) {
          System.debug('Country is' + l.mailingCountryCode + l.mailingstatecode);
            if (l.mailingPostalCode != null &&  l.mailingPostalCode != ''&& (l.MailingCountryCode=='US' || l.MailingCountryCode=='CA')) {
                 if ((l.mailingCountryCode) == 'CA'){
                zips.add(l.mailingPostalCode.substring(0,3).toUpperCase());
                zips.add(l.mailingPostalCode.toUpperCase());
                system.debug('the zips are' + zips);
                }
                else if(l.mailingCountryCode=='US'){
                  zips.add(l.mailingPostalCode.substring(0,5));
                }
            } else if (l.mailingCountryCode!= null && l.mailingCountryCode!='US' && l.mailingCountry!= 'CA') {
                    if(l.mailingCountryCode=='MX'){
                    states.add(state_codes__c.getinstance(l.mailingStateCode).States__c);
                    } else
                cntrys.add(country_codes__c.getInstance(l.mailingCountryCode).Country__c);
            }   
        }

          system.debug('the zips are' + zips+'country is ' + cntrys);
        map < string, ID > territoryMap = new map < string, string > ();
        map < string ,string> newTerritoryMap = new map <string, string>();
        
        for (Zip_Codes_Master__c z: [Select Zip_Code__c, user__c,state__c,country__c,Territory__c from Zip_Codes_Master__c WHERE (Zip_Code__c IN: zips OR country__c IN: cntrys OR State__c IN :states)]) {
            if (z.Zip_Code__c != null && z.zip_code__c !=''  && (z.country__c=='United States' || z.country__c=='Canada') ) {

                territoryMap.put(z.Zip_Code__c, z.user__c);
                newTerritoryMap.put(z.Zip_Code__c ,z.Territory__c);
            } else if (z.country__c =='Mexico'){
                    territoryMap.put(z.State__c,z.user__c);
                    newTerritoryMap.put(z.State__c,z.Territory__c);
                    } else
                territoryMap.put(z.Country__c, z.user__c);
                newTerritoryMap.put(z.Country__c, z.Territory__c);
        }
        system.debug('map is' + territoryMap);
        for (Contact l: contactValues) {
            if (l.mailingPostalCode != null && l.mailingPostalCode !='' && (l.MailingCountryCode=='US'|| l.MailingCountryCode=='CA') ) {
                if(l.mailingCountryCode=='CA'){
                   if(territoryMap.containsKey(l.mailingPostalCode.toUpperCase())){
                    user = territoryMap.get(l.mailingPostalCode.toUpperCase());
                    l.Territory__c = newTerritoryMap.get(l.mailingPostalCode.toUpperCase());
                    system.debug(user);
                   } 
                   else if(territoryMap.containsKey(l.mailingPostalCode.substring(0,3).toUpperCase())){
                    user=territoryMap.get(l.mailingPostalCode.substring(0,3).toUpperCase());
                    l.Territory__c = newTerritoryMap.get(l.mailingPostalCode.substring(0,3).toUpperCase());
                   }
               }  else if(l.mailingCountryCode=='US'){
                user = territoryMap.get(l.mailingPostalCode.substring(0,5));
                l.Territory__c = newTerritoryMap.get(l.mailingPostalCode.substring(0,5));
               }
                system.debug('user'+ user);
              
            } else if (l.mailingCountryCode != null) {
                   if(l.mailingCountryCode=='MX'){
                   user=territoryMap.get(state_codes__c.getinstance(l.mailingStateCode).States__c);
                   l.Territory__c = newTerritoryMap.get(state_codes__c.getinstance(l.mailingStateCode).States__c);
                   } else {
                  string otherCntry=country_codes__c.getInstance(l.mailingCountryCode).Country__c ;
                user = territoryMap.get(otherCntry);
                l.Territory__c = newTerritoryMap.get(otherCntry);
                }
                system.debug('user is' +user);
            }
              if (user != null) {
                    l.OwnerID = user;

                }else              
             l.ownerID= id.valueof(system.label.Default_owner);
            //if(zipDummy != NULL && zipDummy !=''){ l.MailingPostalCode=zipdummy;}
            
            l.owner_assignment__c = false ;
        }
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
    }
        public static boolean validateZip(Contact con){
        string zipUS = '\\d{5}(-\\d{4})?';
        string zipCan= '((?i)[ABCEGHJKLMNPRSTVXY]\\d[A-Z]?\\s?\\d[A-Z]\\d)?';
        set<string> conZips =new set<string>();
        
        Boolean returnValue = true ;
        if((con.mailingCountryCode=='US' || con.mailingCountryCode=='CA') && (con.mailingPostalCode==null || con.mailingPostalCode=='')){
            con.mailingPostalCode.adderror('Please enter a valid Zip code');
            returnValue= false;
            return returnValue ;
        }
        if(con.mailingCountryCode!=null && con.mailingPostalCode!=null && ((con.mailingCountryCode=='US'&& !(pattern.matches(ZipUS,con.mailingPostalCode)))||(con.mailingCountryCode=='CA'&& !(pattern.matches(zipCan,con.mailingPostalCode))))){
                
            System.debug('CheckCountry'+con.mailingCountryCode);    
            System.debug('CheckZip'+con.mailingPostalCode);  
            con.mailingPostalCode.adderror('Please enter a valid Zip code');
            returnValue= false;
            return returnValue ;
         }
        if(con.mailingPostalCode!=null && con.mailingPostalCode!='' && con.mailingCountryCode =='US'){
            if(con.mailingCountryCode=='US'){
            conZips.add(con.mailingPostalCode.substring(0,5));
            }
            list <Zip_Codes_Master__c> z =[Select Zip_Code__c, user__c,state__c,country__c from Zip_Codes_Master__c WHERE Zip_Code__c IN: conZips];
            if (z.size()==0 ){
              con.mailingPostalCode.addError('Contact zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>',false);
              returnValue = false;
              return returnValue ;
            }
        }
         
        /*else{ 
            returnValue = true;
            return returnValue ;
            }*/
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
        system.debug('the return value is' + returnValue );
        return returnValue ;
        
    }
}