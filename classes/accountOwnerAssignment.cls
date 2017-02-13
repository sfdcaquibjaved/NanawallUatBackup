public class accountOwnerAssignment 
{      public static boolean validationPass=false;
    
    
    public static void assignOwner(List < Account > accountValues) {
        set<string> zipsAll = new set <string> ();
        set < string > cntrys = new set < string > ();
        set <string> states = new set<string> ();
        String user,zipDummy;
        
        for (Account l: accountValues) {
          System.debug('Country is' + l.BillingCountryCode + l.Billingstatecode);
            if (l.BillingPostalCode != null &&  l.billingPostalCode != '' && (l.BillingcountryCode=='US' || l.BillingCountryCode=='CA')) {
                if ((l.billingCountryCode) == 'CA'){
                    zipsAll.add(l.billingPostalCode.substring(0,3).toUpperCase());
                    zipsAll.add(l.billingPostalCode.toUppercase());
                system.debug('the zips are' + zipsAll);
                }
               else if(l.billingCountryCode=='US'){
                    zipsAll.add(l.BillingPostalCode.substring(0,5));
                }
            } 
            else if (l.BillingCountryCode!= null && l.BillingCountryCode!='US' && l.BillingCountry!= 'CA') {
                if(l.billingCountryCode=='MX'){
                    states.add(state_codes__c.getinstance(l.billingStateCode).States__c);
                } 
                else{
                    cntrys.add(country_codes__c.getInstance(l.billingCountryCode).Country__c);
                }
            }   
        }

          //system.debug('the zips are' + zips);
        map < string, Id > territoryMap = new map < string, string > ();
        map <string ,string> newTerritoryMap =new map<string ,string>();
        
        for (Zip_Codes_Master__c z: [Select Zip_Code__c, user__c,state__c,country__c,Territory__c from Zip_Codes_Master__c WHERE (Zip_Code__c IN: zipsAll OR country__c IN: cntrys OR State__c IN :states)]) {
            if (z.Zip_Code__c != null && z.Zip_code__c !='' && (z.country__c=='United States' || z.country__c=='Canada')) {
                territoryMap.put(z.Zip_Code__c, z.user__c);
                newTerritoryMap.put(z.Zip_Code__c ,z.Territory__c);
            } 
            else if (z.country__c =='Mexico'){
                territoryMap.put(z.State__c,z.user__c);
                newTerritoryMap.put(z.State__c ,z.Territory__c);
            } 
            else{
                territoryMap.put(z.Country__c, z.user__c);
                newTerritoryMap.put(z.Country__c,z.Territory__c);
            }
        }
        
        system.debug('map is' + territoryMap);
        for (Account l : accountValues) {
            if (l.BillingPostalCode != null && l.billingPostalCode !='' && (l.BillingcountryCode=='US' || l.BillingCountryCode=='CA')) {
            
               if(l.BillingCountryCode=='CA'){
                   if(territoryMap.containsKey(l.billingPostalCode.toUpperCase())){
                    user = territoryMap.get(l.billingPostalCode.toUpperCase());
                    l.Territory__c = newTerritoryMap.get(l.billingPostalCode.toUpperCase());
                   } 
                   else if(territoryMap.containsKey(l.billingPostalCode.substring(0,3).toUpperCase())){
                    user = territoryMap.get(l.billingPostalCode.substring(0,3).toUpperCase());
                    l.Territory__c = newTerritoryMap.get(l.billingPostalCode.substring(0,3).toUpperCase());
                   }
               } 
               else if(l.BillingCountryCode=='US'){
                String ZipC2= l.BillingPostalCode;
                user = territoryMap.get(ZipC2.substring(0,5));
                l.Territory__c = newTerritoryMap.get(ZipC2.substring(0,5));
               }
                system.debug('user'+ user);
            } 
                else if (l.BillingCountryCode != null) {
                   if(l.billingCountryCode=='MX'){
                   user=territoryMap.get(state_codes__c.getinstance(l.billingStateCode).States__c);
                   l.Territory__c = newTerritoryMap.get(state_codes__c.getinstance(l.billingStateCode).States__c);
                   } 
                else{
                  string otherCntry=country_codes__c.getInstance(l.billingCountryCode).Country__c ;
                  user = territoryMap.get(otherCntry);
                  l.Territory__c = newTerritoryMap.get(otherCntry);
                }
                
            } if (user != null) {
                
                    l.OwnerID = user;

                }else              
             l.ownerID= id.valueof(system.label.Default_owner);//if(zipDummy != NULL && zipDummy !=''){ l.BillingPostalCode=zipdummy;}
            
        }System.debug('owner' + user);
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
    }
    
    public static boolean validateZip(Account acc){
        string zipUS = '\\d{5}(-\\d{4})?';
        string zipCan= '((?i)[ABCEGHJKLMNPRSTVXY]\\d[A-Z]?\\s?\\d[A-Z]\\d)?';
        set<string> acczip = new set<string>();
        
        Boolean returnValue = true ;
        if((acc.BillingCountryCode=='US' || acc.BillingCountryCode=='CA') && (acc.BillingPostalCode==null || acc.billingpostalCode=='')){
            acc.BillingPostalCode.adderror('Please enter a valid Zip code');
                returnValue= false;
                return returnValue ;
            }
        // for (Account acc : accV){
        if(acc.BillingCountryCode!=null && acc.BillingPostalCode!=null && ((acc.BillingCountryCode=='US'&& !(pattern.matches(ZipUS,acc.billingPostalCode)))||(acc.BillingCountryCode=='CA'&& !(pattern.matches(zipCan,acc.billingPostalCode))))){
                
                acc.BillingPostalCode.adderror('Please enter a valid Zip code');
                returnValue= false;
                return returnValue ;
            } 
        if (acc.BillingPostalCode!=null && acc.BillingPostalCode!='' && acc.BillingCountryCode == 'US'){
            if(acc.BillingCountryCode=='US'){
            acczip.add(acc.BillingPostalCode.substring(0,5));
            }
            list <Zip_Codes_Master__c> z =[Select Zip_Code__c, user__c,state__c,country__c from Zip_Codes_Master__c WHERE Zip_Code__c IN: acczip];
            if (z.size()==0 ){
              acc.BillingPostalCode.addError('Account zip code that you are entering doesnt exist. Please check the zip code:<a href=\'http://www.unitedstateszipcodes.org/\'target="_blank">HERE</a>',false);
              returnValue = false;
              return returnValue ;
            }
         }
        
            /*else{ 
                returnValue = true;
                return returnValue ;
            }*/
        
        system.debug('the return value is' + returnValue );
        return returnValue ;
        
    }
    
    
    
    
    public static void assignoppowner(Set < Id > accIds) {
       
         list<Opportunity> updatedopps = new list<Opportunity>();
         list<OpportunityTeamMember> updateOppTeamList = new list<OpportunityTeamMember>();
      
        for (Opportunity op : [Select Id,OwnerId,Project_Name__c, Account.OwnerId,stageName from Opportunity where AccountId =: accIds]){
            
           if(op.StageName!='Closed/Won' || op.StageName!='Closed/Lost')
                {
                    if (op.ownerID != op.Account.ownerID) {
                        op.ownerID = op.Account.ownerID;
                        updatedopps.add(op);
                       }
                }
                else
                {
                    OpportunityTeamMember oppTeam = new OpportunityTeamMember();
                    oppTeam.OpportunityId = op.Id;
                    oppTeam.UserId = op.Account.ownerID;
                    updateOppTeamList.add(oppTeam);
                }   
           }
           
       
        if(updatedopps.size()>0) {
           Database.saveresult[] sr = Database.update(updatedopps, False); 
           ErrorLogUtility.processErrorLogs(sr, updatedopps, 'accountOwnerAssignment', 'assignoppowner', 'OpportunityTeamMember', 'Update');
           }
                
        if(updateOppTeamList.size()>0)
        {
           Database.saveresult[] sr = Database.insert(updateOppTeamList, False);
           ErrorLogUtility.processErrorLogs(sr, updateOppTeamList, 'accountOwnerAssignment', 'assignoppowner', 'OpportunityTeamMember', 'Insert');
        }
       
    }
    
    public static void checkProjectSplit(Set<Id> accountSet){
        
        list<Opportunity> opplst = [Select Id, Project_Name__c,OwnerId,AccountId,StageName from Opportunity where AccountId =:  accountSet];
        
        if(opplst.size() >0){
            OpportunityHelper.createProjectBidderSplit(opplst);
        }
        
    }
    
    public static void CaseUpdationwithAccountAddress(set<Account> AccountSet){
    
        //set<id> AccountIdSet = new set<id>();
        system.debug('ACCOUNT SET IS::::'+AccountSet);
        map<id, Account> AccountMap = new map<id, Account>();
        list<case> CaseEndCustomerList = new list<case>();
        list<case> CaseCallerContactList = new list<case>();
        for(Account acc: AccountSet)
        {
            AccountMap.put(acc.id, acc);
        }
        system.debug('AccountId and status');
        list<case> CaseEndCustomlist = [select id, AccountId, Shipping_City_EndCustomer__c, Shipping_Country__c, Shipping_State_End_Customer__c, Shipping_Street_End_Customer__c, Shipping_Zip_End_Customer__c, Billing_City__c, Billing_Country__c, Billing_State__c, Billing_Street_End_Customer__c, Billing_Zipcode__c from case where AccountId IN: AccountMap.keySet() AND Status!='Closed'];
        if(CaseEndCustomlist.size()>0)
        {
            for(case c: CaseEndCustomlist )
            {
                c.Shipping_City_EndCustomer__c = AccountMap.get(c.AccountId).Shippingcity;
                c.Shipping_Country__c = AccountMap.get(c.AccountId).ShippingCountry;
                c.Shipping_State_End_Customer__c= AccountMap.get(c.AccountId).ShippingState;
                c.Shipping_Street_End_Customer__c = AccountMap.get(c.AccountId).ShippingStreet;
                c.Shipping_Zip_End_Customer__c= AccountMap.get(c.AccountId).ShippingPostalCode;
                c.Billing_City__c= AccountMap.get(c.AccountId).Billingcity;
                c.Billing_Country__c = AccountMap.get(c.AccountId).BillingCountry;
                c.Billing_State__c= AccountMap.get(c.AccountId).BillingState;
                c.Billing_Street_End_Customer__c= AccountMap.get(c.AccountId).BillingStreet;
                c.Billing_Zipcode__c= AccountMap.get(c.AccountId).BillingPostalCode;
                
                CaseEndCustomerList.add(c);
            }
        }
        
        list<case> CaseCallerConlist = [select id, Caller_contact__r.AccountId, Billing_City_Caller__c, Billing_Country_Caller__c, Billing_State_Caller__c, Billing_Street_Caller__c, Billing_Zipcode_Caller__c, Shipping_City_Caller__c, Shipping_Country_Caller__c, Shipping_State_Caller__c, Shipping_Street_Caller__c, Shipping_Zip_Caller__c from case where Caller_contact__c!=NULL AND Caller_contact__r.Account.Id IN: AccountMap.keySet() AND Status!='Closed'];
        
        if(CaseCallerConlist.size()>0)
        {
            for(case c: CaseCallerConlist)
            {
                c.Shipping_City_Caller__c= AccountMap.get(c.Caller_contact__r.AccountId).Shippingcity;
                c.Shipping_Country_Caller__c = AccountMap.get(c.Caller_contact__r.AccountId).ShippingCountry;
                c.Shipping_State_Caller__c = AccountMap.get(c.Caller_contact__r.AccountId).ShippingState;
                c.Shipping_Street_Caller__c = AccountMap.get(c.Caller_contact__r.AccountId).ShippingStreet;
                c.Shipping_Zip_Caller__c = AccountMap.get(c.Caller_contact__r.AccountId).ShippingPostalCode;
                c.Billing_City_Caller__c= AccountMap.get(c.Caller_contact__r.AccountId).Billingcity;
                c.Billing_Country_Caller__c= AccountMap.get(c.Caller_contact__r.AccountId).BillingCountry;
                c.Billing_State_Caller__c= AccountMap.get(c.Caller_contact__r.AccountId).BillingState;
                c.Billing_Street_Caller__c= AccountMap.get(c.Caller_contact__r.AccountId).BillingStreet;
                c.Billing_Zipcode_Caller__c = AccountMap.get(c.Caller_contact__r.AccountId).BillingPostalCode;
                
                CaseCallerContactList.add(c);
            }
        }
        if(CaseEndCustomerList.size()>0)
        update CaseEndCustomerList;
        
        if(CaseCallerContactList.size()>0)
        update CaseCallerContactList;
         System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
    }
     
}