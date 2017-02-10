trigger Account_NormalizeFields on Account (before insert, before update) {

    //this is the trigger that keeps the built-in address fields and the custom address fields in sync
    
    for( Account a : trigger.new )
    {
        a.City__c = Utility.StringToTitleCase(a.City__c);
        
        if( trigger.isInsert) 
        {
            if( a.BillingCity != '' && ( a.City__c == null || a.City__c == '' ) )
            {
                a.City__c = a.BillingCity;
            } else 
            {
                a.BillingCity = a.City__c;
            }
            
            if( a.BillingCountryCode != ''  )
            {
                map<string,string > CountryCodeMap = Utility.GetCountryCodeMap();
                
                if( CountryCodeMap.get( a.BillingCountryCode) != null )
                     a.Country__c  = CountryCodeMap.get( a.BillingCountryCode );
                
            } else if( a.Country__c != null && a.Country__c != '' )
            {
                
                map<string,string> countrycodemap_rev = Utility.GetCountryCodeMap_ByCountryName();
                a.BillingCountryCode = countrycodemap_rev.get( a.Country__c );
            }

            if( a.BillingstateCode != ''  )
            {
                
                map<string,string > StateCodeMap = null;
            
                if( a.BillingCountryCode != null && a.BillingCountryCode != '' )
                {
                    StateCodeMap = Utility.GetStateCodeMap( a.BillingCountryCode);
                } else
                {
                    map<string,string> countryreversemap = Utility.GetCountryCodeMap_ByCountryName();
                    StateCodeMap = Utility.GetStateCodeMap( countryreversemap.get(a.Country__c) );
                }
                
                if( StateCodeMap != null && StateCodeMap.get( a.BillingStateCode ) != null )
                      a.state__c = StateCodeMap.get( a.BillingStateCode );

            } else
            {
                a.BillingState = a.State__c;
            }
            
            /*
            if( a.BillingStreet != '' && ( a.Address_1__c == null || a.Address_1__c == '' ) )
            {
                a.Address_1__c = a.BillingStreet;
            } else
            {
                a.BillingStreet = a.Address_1__c;
            }
            */
            if( a.BillingStreet == null || a.BillingStreet == 'null')
                a.BillingStreet = '';
            
            if( a.Address_1__c == null || a.Address_1__c == 'null')
                a.Address_1__c = '';
            
            if( a.Address_2__c == null || a.Address_2__c == 'null')
                a.Address_2__c = '';
            
            
            if(  a.BillingStreet != '' && ( a.Address_1__c == null || a.Address_1__c == '' )  )  
            {
             
                /*   
                try 
                {
                    string address1 = '';
                    string address2 = '';
                    string temp = a.BillingStreet;
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
                        address1 = a.BillingStreet;
                    }

                    a.Address_1__c =  address1;
                    a.Address_2__c = address2;

                    
                } catch( Exception ex )
                {
                
                    a.Address_1__c = a.BillingStreet;
                } 
                */
                
                a.Address_1__c = a.BillingStreet;

            } else
            {
//                a.BillingStreet = a.Address_1__c + ( a.Address_2__c != '' ? '\n' + a.Address_2__c : '');
                a.BillingStreet = a.Address_1__c; // + ( a.Address_2__c != '' ? '\n' + a.Address_2__c : '');
            }

                        
            
            if( a.BillingPostalCode != '' && ( a.Zip__c == null || a.Zip__c == '' ) )
            {
                a.Zip__c = a.BillingPostalCode;
            } else 
            {
                a.BillingPostalCode = a.Zip__c;
            }


            
        } else if (trigger.isUpdate )
        {
            Account oldA = trigger.oldMap.get(a.id);

//            if(  !oldA.BillingStreet.equals(  a.BillingStreet )  )

            if( ( oldA.BillingCity != null && !oldA.BillingCity.equals( a.BillingCity ) )
            || (oldA.BillingCity != a.BillingCity) )  
                a.City__c  = a.BillingCity; //the underlying billing city changed; this is for the data.com stuff in ticket 18240
            else    a.BillingCity = a.ShippingCity = a.City__c;  //otherwise, the wrapper city changed

//          if( oldA.BillingStreet != a.BillingStreet )  a.Address_1__c  = a.BillingStreet; 
//          else    a.BillingStreet = a.ShippingStreet = a.Address_1__c; 
            if( a.BillingStreet == null || a.BillingStreet == 'null')
                a.BillingStreet = '';
            
            if( a.Address_1__c == null || a.Address_1__c == 'null')
                a.Address_1__c = '';
            
            if( a.Address_2__c == null || a.Address_2__c == 'null')
                a.Address_2__c = '';
            
            if(  
                ( oldA.BillingStreet != null &&  !oldA.BillingStreet.equals(  a.BillingStreet )  ) 
                || oldA.BillingStreet != a.BillingStreet
            )
            {
                
                a.Address_1__c = a.BillingStreet;

            } else  
            {
                a.BillingStreet = a.ShippingStreet = ( a.address_1__c != null && a.Address_1__c != '' ? a.Address_1__c : '' ); // + ( a.Address_2__c != '' && a.Address_2__c != null ? '\n' + a.Address_2__c : '');  
            }



//          if( oldA.BillingState != a.BillingState )  a.state__c  = a.BillingState;
//          else    a.BillingState = a.ShippingState = a.state__c;  
            if(  oldA.BillingStateCode != a.BillingStateCode )  
            {
                map<string,string > StateCodeMap = Utility.GetStateCodeMap( a.BillingCountryCode);
                
                if( StateCodeMap.get( a.BillingStateCode ) != null )
                      a.state__c = StateCodeMap.get( a.BillingStateCode );
                    
            } else if(  oldA.state__c != a.state__c) 
            {
                a.BillingState = a.ShippingState = a.state__c;   
            }
    



            if( oldA.BillingPostalCode != a.BillingPostalCode )  a.Zip__c  = a.BillingPostalCode;
            else    a.BillingPostalCode = a.ShippingPostalCode = a.Zip__c; 


            if( oldA.BillingCountryCode != a.BillingCountryCode )  
            {
                map<string,string > CountryCodeMap = Utility.GetCountryCodeMap();
                
                if( CountryCodeMap.get( a.BillingCountryCode) != null )
                     a.Country__c  = CountryCodeMap.get( a.BillingCountryCode );

            } else if( oldA.Country__c != a.Country__c ) 
            {
                a.BillingCountry = a.ShippingCountry = a.Country__c;                        
            }

        }
        
    }

}