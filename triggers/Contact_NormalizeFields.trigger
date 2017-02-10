trigger Contact_NormalizeFields on Contact (before insert, before update) {

    /*trigger purpose
        fixes capitalization in name fields, maintains sync with built-in fields and our wrappers
    */
    for( Contact c : trigger.new )
    {
        //clean funny capitalizations ; both insert and update 
        c.FirstName = Utility.StringToTitleCase(c.FirstName);
        c.LastName = Utility.StringToTitleCase(c.LastName);
        c.City__c = Utility.StringToTitleCase(c.City__c);
        
        if( trigger.isInsert )
        {
            /*
            if( c.MailingStreet != '' && ( c.Address_1__c == null || c.Address_1__c == '' ) )
            {
                c.Address_1__c = c.MailingStreet;
            }*/
            
            if( c.MailingStreet == null || c.MailingStreet == 'null')
                c.MailingStreet = '';
            
            if( c.Address_1__c == null || c.Address_1__c == 'null')
                c.Address_1__c = '';
            
            if( c.Address_2__c == null || c.Address_2__c == 'null')
                c.Address_2__c = '';
            
            
            if( c.MailingStreet != '' && c.MailingStreet != null  )  
            {
                /*
                try 
                {
                    string address1 = '';
                    string address2 = '';
                    string temp = c.MailingStreet;
                    if(   temp.contains('\n') )
                    {
                        String[] parts = temp.split('\n');
                        address1 = parts[0];
                        for( integer i = 1; i<parts.size(); i++ )
                        {
                            if( address2 != '' )
                                address2 += '\n';
                            address2 += parts[i];
                        }
                    } else
                    {
                        address1 = c.MailingStreet;
                    }

                    c.Address_1__c =  address1;
                    c.Address_2__c = address2;

                    
                } catch( Exception ex )
                {
                
                    c.Address_1__c = c.MailingStreet;
                } 
                */
                c.Address_1__c = c.MailingStreet;

            } else 
            {
                c.MailingStreet = c.Address_1__c;
            }
            
            
            
            
            if( c.MailingCity != '' && ( c.City__c == null || c.City__c == '' ) )
            {
                c.City__c = c.MailingCity;
            }


/*
            if( c.MailingCountryCode != '' && ( c.Country__c == null || c.Country__c == '' ) )
            {
                map<string,string > CountryCodeMap = Utility.GetCountryCodeMap();
                
                if( CountryCodeMap.get( c.MailingCountryCode) != null )
                    c.Country__c  = CountryCodeMap.get( c.MailingCountryCode );
                
            }
    */
            if( c.MailingCountryCode != '' )
            {
                map<string,string > CountryCodeMap = Utility.GetCountryCodeMap();
                
                if( CountryCodeMap.get( c.MailingCountryCode) != null ) 
                     c.Country__c  = CountryCodeMap.get( c.MailingCountryCode );
                
            } else if( c.Country__c != null && c.Country__c != '' )
            {
                
                map<string,string> countrycodemap_rev = Utility.GetCountryCodeMap_ByCountryName();
                c.MailingCountryCode = countrycodemap_rev.get( c.Country__c );
            }
            

            if( c.MailingStateCode != ''  )
            {
                
                map<string,string > StateCodeMap = null;            
                if( c.MailingCountryCode != null && c.MailingCountryCode != '' )
                {
                    StateCodeMap = Utility.GetStateCodeMap( c.MailingCountryCode);
                } else
                {
                    map<string,string> countryreversemap = Utility.GetCountryCodeMap_ByCountryName();
                    StateCodeMap = Utility.GetStateCodeMap( countryreversemap.get( c.Country__c) );
                }
                
                if( StateCodeMap != null && StateCodeMap.get( c.MailingStateCode ) != null )
                      c.state__c = StateCodeMap.get( c.MailingStateCode );

            } else
            {
                c.MailingState = c.State__c;
            }
            

    
            if( c.MailingPostalCode != '' && ( c.Zip__c == null || c.Zip__c == '' ) )
            {
                c.Zip__c = c.MailingPostalCode;
            } else if( 
                (c.MailingPostalCode == null || c.MailingPostalCode == '' )
                && (c.Zip__c != null && c.Zip__c != '' )
            ) {
                c.MailingPostalCode = c.Zip__c;
            }
    
        } else if( trigger.isUpdate )
        {
            Contact oldC = trigger.oldMap.get(c.id);
            if( oldC.MailingCity != c.MailingCity )  c.City__c  = c.MailingCity; //the underlying billing city changed; this is for the data.com stuff in ticket 18240
            else    c.MailingCity = c.City__c;  //otherwise, the wrapper city changed
 
//          if( oldC.MailingStreet != c.MailingStreet )  c.address_1__c  = c.MailingStreet;
//          else    c.MailingStreet = c.OtherStreet = c.address_1__c;  

            if( c.MailingStreet == null || c.MailingStreet == 'null')
                c.MailingStreet = '';
            
            if( c.Address_1__c == null || c.Address_1__c == 'null')
                c.Address_1__c = '';
            
            if( c.Address_2__c == null || c.Address_2__c == 'null')
                c.Address_2__c = '';
            
            

            if(  oldC.MailingStreet != c.MailingStreet )  
            {
                /*
                try 
                {
                    string address1 = '';
                    string address2 = '';
                    string temp = c.MailingStreet;
                    if(   temp.contains('\n') )
                    {
                        String[] parts = temp.split('\n');
                        address1 = parts[0];
                        for( integer i = 1; i<parts.size(); i++ )
                        {
                            if( address2 != '' )
                                address2 += '\n';
                            address2 += parts[i];
                        }
                    } else
                    {
                        address1 = c.MailingStreet;
                    }

                    c.Address_1__c = address1;
                    c.Address_2__c = address2;

                    
                } catch( Exception ex )
                {
                
                    c.Address_1__c  = c.MailingStreet; 
                } 
                */
                
                c.Address_1__c = c.MailingStreet;

            } else  
            {
//              c.MailingStreet = (c.Address_1__c != null && c.Address_1__c != '' ? c.Address_1__c : '' ) + ( c.address_2__c != '' && c.address_2__c != null ?  '\n' + c.Address_2__c : '');  
                c.MailingStreet = (c.Address_1__c != null && c.Address_1__c != '' ? c.Address_1__c : '' ); // + ( c.address_2__c != '' && c.address_2__c != null ?  '\n' + c.Address_2__c : '');  
            }
            

//          if( oldC.MailingState != c.MailingState )  c.State__c  = c.MailingState;
            if( oldC.mailingstatecode != c.mailingstatecode )  
            {
                map<string,string > StateCodeMap = Utility.GetStateCodeMap(c.mailingcountrycode);
                
                if( StateCodeMap.get( c.mailingstatecode) != null )
                    c.State__c  = StateCodeMap.get( c.mailingstatecode );
                    
                    
            } else if( oldC.State__c != c.State__c) 
            {
                c.MailingState  = c.State__c;  
            }
            
            if( oldC.MailingPostalCode != c.MailingPostalCode )  c.zip__c  = c.MailingPostalCode;
            else    c.MailingPostalCode = c.zip__c;  

//          if( oldC.MailingCountry != c.MailingCountry )  c.country__c  = c.MailingCountry;
            if( oldC.MailingCountryCode != c.MailingCountryCode )  
            {
                map<string,string > CountryCodeMap = Utility.GetCountryCodeMap();
                
                if( CountryCodeMap.get( c.MailingCountryCode) != null )
                    c.Country__c  = CountryCodeMap.get( c.MailingCountryCode);
                
//              c.country__c  = c.MailingCountry;
            } else if( c.Country__c != oldC.Country__c ) 
            {
                c.MailingCountry  = c.country__c;                       
            }
        }
    }
}