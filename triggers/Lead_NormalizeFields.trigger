trigger Lead_NormalizeFields on Lead (before insert, before update) {
    
    //maintains the sync with the built-in address fields and the lead wrapper fields

   /* for( Lead l : trigger.new )
    {
        //clean funny capitalizations ; both insert and update 
        l.FirstName = Utility.StringToTitleCase(l.FirstName);
        l.LastName = Utility.StringToTitleCase(l.LastName);
        l.nrCity__c = Utility.StringToTitleCase(l.nrCity__c);
        
        if( trigger.isInsert )
        {
            //this trigger is just for new leads being inserted 
            if( l.City != '' && ( l.nrCity__c == null || l.nrCity__c == '' ) )
            {
                l.nrCity__c = l.City;
            }
            

            
//          if( l.Country != '' && ( l.nrCountry__c == null || l.nrCountry__c == '' ) )
            if( l.CountryCode != '' )
            {
                map<string,string > CountryCodeMap = Utility.GetCountryCodeMap();               
                if( CountryCodeMap.get( l.CountryCode) != null )
                     l.nrCountry__c  = CountryCodeMap.get( l.CountryCode );
                 


            } else if ( l.nrCountry__c != null || l.nrCountry__c != '' ) 
            {
                map<string,string> countrycodemap_rev = Utility.GetCountryCodeMap_ByCountryName();
                l.CountryCode =  countrycodemap_rev.get( l.nrCountry__c );

            
            }



            
//          if( l.State != '' && ( l.nrState__c == null || l.nrState__c == '' ) )
            if( l.StateCode != ''   )
            {
                map<string,string > StateCodeMap = Utility.GetStateCodeMap(l.CountryCode);
                if( StateCodeMap.get( l.StateCode ) != null )
                     l.nrState__c = StateCodeMap.get( l.StateCode );
                
//              l.nrState__c = l.State;
            } else 
            {
            
                l.State = l.nrState__c;
            }
            
/*

*/          

           /* if( l.Street != '' && ( l.Address_1__c == null || l.Address_1__c == '' ) )  
            {
                /*
                try 
                {
                    string address1 = '';
                    string address2 = '';
                    string temp = l.Street;
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
                        address1 = l.Street;
                    }

                    l.Address_1__c = address1;
                    l.Address_2__c = address2;

                    
                } catch( Exception ex )
                {
                
                    l.Address_1__c  = l.Street; 
                } 
*/
                /*l.Address_1__c = l.Street;
            } else 
            {
                l.Street = l.Address_1__c;
            }
            
            
/*          
            if( l.Street != '' && ( l.Address_1__c == null || l.Address_1__c == '' ) )
            {
                l.Address_1__c = l.Street;
            }
    */      
            /*if( l.PostalCode != '' && ( l.Zip__c == null || l.Zip__c == '' ) )
            {
                l.Zip__c = l.PostalCode;
            }
            
        } else if( trigger.isUpdate  )
        {
            Lead oldL = trigger.oldMap.get(l.id);
            if( oldL.City != l.City )  l.nrCity__c  = l.City; //the underlying billing city changed; this is for the data.com stuff in ticket 18240
            else    l.City = l.nrCity__c;  //otherwise, the wrapper city changed
        
//          if( oldL.State != l.State )  l.nrState__c  = l.State; 
//          else    l.State = l.nrState__c;  
            if(  oldL.StateCode != l.StateCode )  
            {
                map<string,string > StateCodeMap = Utility.GetStateCodeMap(l.CountryCode);
                
                if( StateCodeMap.get( l.StateCode ) != null )
                     l.nrState__c = StateCodeMap.get( l.StateCode );
                    
            } else if(  oldL.nrState__c != l.nrState__c) 
            {
                l.State = l.nrState__c;   
            }
    
    
        
            if( oldL.Street != l.Street )  
            {
/*                
                try 
                {
                    string address1 = '';
                    string address2 = '';
                    string temp = l.Street;
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
                        address1 = l.Street;
                    }

                    l.Address_1__c = address1;
                    l.Address_2__c = address2;

                    
                } catch( Exception ex )
                {
                
                    l.Address_1__c  = l.Street; 
                } 
*/
               /* l.Address_1__c = l.Street;
            } else  
            {
//                l.Street = l.Address_1__c + ( l.address_2__c != '' && l.address_2__c != null ?  '\n' + l.Address_2__c : '');  
                l.Street = l.Address_1__c;
            }
            
            if( oldL.PostalCode != l.PostalCode )  l.Zip__c  = l.PostalCode; 
            else    l.PostalCode = l.Zip__c;  
        
        
//          if( oldL.Country != l.Country )  l.nrCountry__c  = l.Country; 
//          else    l.Country = l.nrCountry__c;  
            if( oldL.CountryCode != l.CountryCode )  
            {
                map<string,string > CountryCodeMap = Utility.GetCountryCodeMap();
                
                if( CountryCodeMap.get( l.CountryCode) != null ) 
                     l.nrCountry__c  = CountryCodeMap.get( l.CountryCode );

            } else if( oldL.nrCountry__c != l.nrCountry__c ) 
            {
                l.Country = l.nrCountry__c;                         
            }

        
        }
        

        
    }*/
}