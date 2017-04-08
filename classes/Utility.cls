public class Utility
{

    public static map<string,string> GetCountryCodeMap_ByCountryName() 
    {
        map<string,string> temp = GetCountryCodeMap();   
        map<string,string> response = new map<string,string>();
        for( string CountryCode : temp.keySet() )
        {
            response.put( temp.get(CountryCode), CountryCode );
        } 
        return response;
    
    }
    
    public static map<string, string >  GetCountryCodeMap() 
    {
        map<string,string> CountryCodeMap = new map<string,string>{
            'AD'    => 'Andorra',
            'AE'    => 'United Arab Emirates',
            'AF'    => 'Afghanistan',
            'AG'    => 'Antigua and Barbuda',
            'AI'    => 'Anguilla',
            'AL'    => 'Albania',
            'AM'    => 'Armenia',
            'ANT'   => 'Netherlands Antilles',
            'AO'    => 'Angola',
            'AQ'    => 'Antarctica',
            'AR'    => 'Argentina',
            'AT'    => 'Austria',
            'AU'    => 'Australia',
            'AW'    => 'Aruba',
            'AX'    => 'Aland Islands',
            'AZ'    => 'Azerbaijan',
            'BA'    => 'Bosnia and Herzegovina',
            'BB'    => 'Barbados',
            'BD'    => 'Bangladesh',
            'BE'    => 'Belgium',
            'BF'    => 'Burkina Faso',
            'BG'    => 'Bulgaria',
            'BH'    => 'Bahrain',
            'BI'    => 'Burundi',
            'BJ'    => 'Benin',
            'BL'    => 'Saint Barthélemy',
            'BM'    => 'Bermuda',
            'BN'    => 'Brunei Darussalam',
            'BO'    => 'Bolivia, Plurinational State of',
            'BQ'    => 'Bonaire, Sint Eustatius and Saba',
            'BR'    => 'Brazil',
            'BS'    => 'Bahamas',
            'BT'    => 'Bhutan',
            'BV'    => 'Bouvet Island',
            'BW'    => 'Botswana',
            'BY'    => 'Belarus',
            'BZ'    => 'Belize',
            'CA'    => 'Canada',
            'CC'    => 'Cocos (Keeling) Islands',
            'CD'    => 'Congo, the Democratic Republic of the',
            'CF'    => 'Central African Republic',
            'CG'    => 'Congo',
            'CH'    => 'Switzerland',
            'CI'    => 'Cote dIvoire',
            'CK'    => 'Cook Islands',
            'CL'    => 'Chile',
            'CM'    => 'Cameroon',
            'CN'    => 'China',
            'CO'    => 'Colombia',
            'CR'    => 'Costa Rica',
            'CU'    => 'Cuba',
            'CV'    => 'Cape Verde',
            'CW'    => 'Curaçao',
            'CX'    => 'Christmas Island',
            'CY'    => 'Cyprus',
            'CZ'    => 'Czech Republic',
            'DE'    => 'Germany',
            'DJ'    => 'Djibouti',
            'DK'    => 'Denmark',
            'DM'    => 'Dominica',
            'DO'    => 'Dominican Republic',
            'DZ'    => 'Algeria',
            'EC'    => 'Ecuador',
            'EE'    => 'Estonia',
            'EG'    => 'Egypt',
            'EH'    => 'Western Sahara',
            'ER'    => 'Eritrea',
            'ES'    => 'Spain',
            'ET'    => 'Ethiopia',
            'FI'    => 'Finland',
            'FJ'    => 'Fiji',
            'FK'    => 'Falkland Islands (Malvinas)',
            'FO'    => 'Faroe Islands',
            'FR'    => 'France',
            'GA'    => 'Gabon',
            'GB'    => 'United Kingdom',
            'GD'    => 'Grenada',
            'GE'    => 'Georgia',
            'GF'    => 'French Guiana',
            'GG'    => 'Guernsey',
            'GH'    => 'Ghana',
            'GI'    => 'Gibraltar',
            'GL'    => 'Greenland',
            'GM'    => 'Gambia',
            'GN'    => 'Guinea',
            'GP'    => 'Guadeloupe',
            'GQ'    => 'Equatorial Guinea',
            'GR'    => 'Greece',
            'GS'    => 'South Georgia and the South Sandwich Islands',
            'GT'    => 'Guatemala',
            'GUM'   => 'Guam',
            'GW'    => 'Guinea-Bissau',
            'GY'    => 'Guyana',
            'HM'    => 'Heard Island and McDonald Islands',
            'HN'    => 'Honduras',
            'HR'    => 'Croatia',
            'HT'    => 'Haiti',
            'HU'    => 'Hungary',
            'ID'    => 'Indonesia',
            'IE'    => 'Ireland',
            'IL'    => 'Israel',
            'IM'    => 'Isle of Man',
            'IN'    => 'India',
            'IO'    => 'British Indian Ocean Territory',
            'IQ'    => 'Iraq',
            'IR'    => 'Iran, Islamic Republic of',
            'IS'    => 'Iceland',
            'IT'    => 'Italy',
            'JE'    => 'Jersey',
            'JM'    => 'Jamaica',
            'JO'    => 'Jordan',
            'JP'    => 'Japan',
            'KE'    => 'Kenya',
            'KG'    => 'Kyrgyzstan',
            'KH'    => 'Cambodia',
            'KI'    => 'Kiribati',
            'KM'    => 'Comoros',
            'KN'    => 'Saint Kitts and Nevis',
            'KP'    => 'Korea, Democratic Peoples Republic of',
            'KR'    => 'Korea, Republic of',
            'KW'    => 'Kuwait',
            'KY'    => 'Cayman Islands',
            'KZ'    => 'Kazakhstan',
            'LA'    => 'Lao Peoples Democratic Republic',
            'LB'    => 'Lebanon',
            'LC'    => 'Saint Lucia',
            'LI'    => 'Liechtenstein',
            'LK'    => 'Sri Lanka'  ,
            'LR'    => 'Liberia',
            'LS'    => 'Lesotho',
            'LT'    => 'Lithuania',
            'LU'    => 'Luxembourg',
            'LV'    => 'Latvia',
            'LY'    => 'Libyan Arab Jamahiriya',
            'MA'    => 'Morocco',
            'MC'    => 'Monaco',
            'MD'    => 'Moldova, Republic of',
            'ME'    => 'Montenegro',
            'MF'    => 'Saint Martin (French part)',
            'MG'    => 'Madagascar',
            'MK'    => 'Macedonia, the former Yugoslav Republic of',
            'ML'    => 'Mali',
            'MM'    => 'Myanmar',
            'MN'    => 'Mongolia',
            'MO'    => 'Macao',
            'MQ'    => 'Martinique',
            'MR'    => 'Mauritania',
            'MS'    => 'Montserrat',
            'MT'    => 'Malta',
            'MU'    => 'Mauritius',
            'MV'    => 'Maldives',
            'MW'    => 'Malawi',
            'MX'    => 'Mexico',
            'MY'    => 'Malaysia',
            'MZ'    => 'Mozambique',
            'NA'    => 'Namibia',
            'NC'    => 'New Caledonia',
            'NE'    => 'Niger',
            'NF'    => 'Norfolk Island',
            'NG'    => 'Nigeria',
            'NI'    => 'Nicaragua',
            'NL'    => 'Netherlands',
            'NO'    => 'Norway',
            'NP'    => 'Nepal',
            'NR'    => 'Nauru',
            'NU'    => 'Niue',
            'NZ'    => 'New Zealand',
            'OM'    => 'Oman',
            'PA'    => 'Panama',
            'PE'    => 'Peru',
            'PF'    => 'French Polynesia',
            'PG'    => 'Papua New Guinea',
            'PH'    => 'Philippines',
            'PK'    => 'Pakistan',
            'PL'    => 'Poland',
            'PM'    => 'Saint Pierre and Miquelon',
            'PN'    => 'Pitcairn',
            'PS'    => 'Palestinian Territory, Occupied',
            'PT'    => 'Portugal',
            'PY'    => 'Paraguay',
            'QA'    => 'Qatar',
            'RE'    => 'Reunion',
            'RO'    => 'Romania',
            'RS'    => 'Serbia',
            'RU'    => 'Russian Federation',
            'RW'    => 'Rwanda',
            'SA'    => 'Saudi Arabia',
            'SB'    => 'Solomon Islands',
            'SC'    => 'Seychelles',
            'SD'    => 'Sudan',
            'SE'    => 'Sweden',
            'SG'    => 'Singapore',
            'SH'    => 'Saint Helena, Ascension and Tristan da Cunha',
            'SI'    => 'Slovenia',
            'SJ'    => 'Svalbard and Jan Mayen',
            'SK'    => 'Slovakia',
            'SL'    => 'Sierra Leone',
            'SM'    => 'San Marino',
            'SN'    => 'Senegal',
            'SO'    => 'Somalia',
            'SR'    => 'Suriname',
            'SS'    => 'South Sudan',
            'ST'    => 'Sao Tome and Principe',
            'SV'    => 'El Salvador',
            'SX'    => 'Sint Maarten (Dutch part)',
            'SY'    => 'Syrian Arab Republic',
            'SZ'    => 'Swaziland',
            'TC'    => 'Turks and Caicos Islands',
            'TD'    => 'Chad',
            'TF'    => 'French Southern Territories',
            'TG'    => 'Togo',
            'TH'    => 'Thailand',
            'TJ'    => 'Tajikistan',
            'TK'    => 'Tokelau',
            'TL'    => 'Timor-Leste',
            'TM'    => 'Turkmenistan',
            'TN'    => 'Tunisia',
            'TO'    => 'Tonga',
            'TR'    => 'Turkey',
            'TT'    => 'Trinidad and Tobago',
            'TV'    => 'Tuvalu',
            'TW'    => 'Chinese Taipei',
            'TWN'   => 'Taiwan',
            'TZ'    => 'Tanzania, United Republic of',
            'UA'    => 'Ukraine',
            'UG'    => 'Uganda',
            'US'    => 'United States',
            'UY'    => 'Uruguay',
            'UZ'    => 'Uzbekistan',
            'VA'    => 'Holy See (Vatican City State)',
            'VC'    => 'Saint Vincent and the Grenadines',
            'VE'    => 'Venezuela, Bolivarian Republic of',
            'VG'    => 'Virgin Islands, British',
            'VN'    => 'Viet Nam',
            'VU'    => 'Vanuatu',
            'WF'    => 'Wallis and Futuna',
            'WS'    => 'Samoa',
            'YE'    => 'Yemen',
            'YT'    => 'Mayotte',
            'ZA'    => 'South Africa',
            'ZM'    => 'Zambia',
            'ZW'    => 'Zimbabwe'
            
        };
        
        return CountryCodeMap;
            
    }   
    
    public static map<string,string> GetStateCodeMap_ByStateName ( string countrycode )
    {
        map<string,string> temp = GetStateCodeMap(countrycode);
        map<string,string> response = new map<string,string>();
        for( string StateCode : temp.keySet() )
        {
            response.put( temp.get(StateCode), StateCode );
        }
        return response;
    }
    public static map<string, string >  GetStateCodeMap(string countrycode) 
    {
        map<string, string > StateCodeMap;
        
        if( countrycode == 'US' )
            StateCodeMap = new Map<string,string> {
                'AA' => 'Armed Forces Americas',
                'AE' => 'Armed Forces Europe',
                'AK' => 'Alaska',
                'AL' => 'Alabama',
                'AP' => 'Armed Forces Pacific',
                'AR' => 'Arkansas',
                'AS' => 'American Samoa',
                'AZ' => 'Arizona',
                'CA' => 'California',
                'CO' => 'Colorado',
                'CT' => 'Connecticut',
                'DC' => 'District of Columbia',
                'DE' => 'Delaware',
                'FL' => 'Florida',
                'FM' => 'Federated Micronesia',
                'GA' => 'Georgia',
                'GU' => 'Guam',
                'HI' => 'Hawaii',
                'IA' => 'Iowa',
                'ID' => 'Idaho',
                'IL' => 'Illinois',
                'IN' => 'Indiana',
                'KS' => 'Kansas',
                'KY' => 'Kentucky',
                'LA' => 'Louisiana',
                'MA' => 'Massachusetts',
                'MD' => 'Maryland',
                'ME' => 'Maine',
                'MH' => 'Marshall Islands',
                'MI' => 'Michigan',
                'MN' => 'Minnesota',
                'MO' => 'Missouri',
                'MP' => 'Northern Mariana Islands',
                'MS' => 'Mississippi',
                'MT' => 'Montana',
                'NC' => 'North Carolina',
                'ND' => 'North Dakota',
                'NE' => 'Nebraska',
                'NH' => 'New Hampshire',
                'NJ' => 'New Jersey',
                'NM' => 'New Mexico',
                'NV' => 'Nevada',
                'NY' => 'New York',
                'OH' => 'Ohio',
                'OK' => 'Oklahoma',
                'OR' => 'Oregon',
                'PA' => 'Pennsylvania',
                'PR' => 'Puerto Rico',
                'PW' => 'Palau',
                'RI' => 'Rhode Island',
                'SC' => 'South Carolina',
                'SD' => 'South Dakota',
                'TN' => 'Tennessee',
                'TX' => 'Texas',
                'UM' => 'United States Minor Outlying Islands',
                'UT' => 'Utah',
                'VA' => 'Virginia',
                'VI' => 'US Virgin Islands',
                'VT' => 'Vermont',
                'WA' => 'Washington',
                'WI' => 'Wisconsin',
                'WV' => 'West Virginia',
                'WY' => 'Wyoming'
            };
        else if (countrycode == 'AU')
            StateCodeMap =  new map<string,string> {
                'ACT'   => 'Australian Capital Territory',
                'NSW'   => 'New South Wales',
                'NT' => 'Northern Territory',
                'QLD' =>    'Queensland',
                'SA' => 'South Australia',
                'TAS' =>    'Tasmania',
                'VIC' =>    'Victoria',
                'WA'    => 'Western Australia'
            };
        else if ( countrycode == 'CA')
            StateCodeMap =  new map<string,string> {
                'AB'    => 'Alberta',
                'BC'    => 'British Columbia',
                'MB'    => 'Manitoba',
                'NB'    => 'New Brunswick',
                'NL'    => 'Newfoundland and Labrador',
                'NS'    => 'Nova Scotia',
                'NT'    => 'Northwest Territories',
                'NU'    => 'Nunavut',
                'ON'    => 'Ontario',
                'PE'    => 'Prince Edward Island',
                'QC'    => 'Quebec',
                'SK'    => 'Saskatchewan',
                'YT'    => 'Yukon Territories'                          
            };
        else if( countrycode == 'MX')
            StateCodeMap =  new map<string,string> {
                'AG'    => 'Aguascalientes',
                'BC'    => 'Baja California',
                'BS'    => 'Baja California Sur',
                'CH'    => 'Chihuahua',
                'CL'    => 'Colima',
                'CM'    => 'Campeche',
                'CO'    => 'Coahuila',
                'CS'    => 'Chiapas',
                'DF'    => 'Federal District',
                'DG'    => 'Durango',
                'GR'    => 'Guerrero',
                'GT'    => 'Guanajuato',
                'HG'    => 'Hidalgo',
                'JA'    => 'Jalisco',
                'ME'    => 'Mexico State',
                'MI'    => 'Michoacán',
                'MO'    => 'Morelos',
                'NA'    => 'Nayarit',
                'NL'    => 'Nuevo León',
                'OA'    => 'Oaxaca',
                'PB'    => 'Puebla',
                'QE'    => 'Querétaro',
                'QR'    => 'Quintana Roo',
                'SI'    => 'Sinaloa',
                'SL'    => 'San Luis Potosí',
                'SO'    => 'Sonora',
                'TB'    => 'Tabasco',
                'TL'    => 'Tlaxcala',
                'TM'    => 'Tamaulipas',
                'VE'    => 'Veracruz',
                'YU'    => 'Yucatán',
                'ZA'    => 'Zacatecas'
            };
        
        else StateCodeMap = new map<string,string>();               
        return StateCodeMap;
    }
            
    
    public static double GetTaxRateFromZip( string zipcode )
    {
       
    
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint('http://services.taxdataservice.com/TaxSimpleService.asmx');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
//      req.setHeader('SOAPAction', 'http://tempuri.org/GetTaxSimpleServiceUS');        


        string body = '<?xml version="1.0" encoding="utf-8"?>';
        body += '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">';
        body += '  <soap12:Body>';
        body += '    <GetTaxSimpleServiceUS xmlns="http://tempuri.org/">';
        body += '      <zipcode>'+zipcode+'</zipcode>';
        body += '      <username>gabepaulson@yahoo.com</username>';
        body += '      <password>Monster99!</password>';
        body += '    </GetTaxSimpleServiceUS>';
        body += '  </soap12:Body>';
        body += '</soap12:Envelope>';
        
        req.setBody(body);       
 
        
        Http http = new Http();
        HTTPResponse res = http.send(req); 
            
        string responseBody = res.getBody();            


        Pattern p = pattern.compile('(<ServiceResult(.*?)ServiceResult>)');
        matcher m = p.matcher(responseBody);
        string parsedXmlResponse = '';
        while( m.find() )
        {
            parsedXmlResponse = responseBody.substring(m.start(), m.end() ).replace('&gt;','>').replace('&lt;','<');
        }
    
        Dom.Document doc = new Dom.Document();
        doc.load( parsedXmlResponse );
        dom.Xmlnode RootNode = doc.getRootElement();

        string resp = RootNode.getChildElement('TotalSalesTax',null).getText();
    
        return double.valueof(resp);

    }
    
    
    private static map<string,TaxRate__c> taxRates = null;
    public static map<string,TaxRate__c> GetTaxRates()
    {
        if( taxRates == null )
        {
            taxRates = new map<string,TaxRate__c>();
            for( TaxRate__c tr : [SELECT Id,State__c,Service_Quote_Tax_Rate__c FROM TaxRate__c ] )
            {
                taxRates.put(tr.State__c, tr);
            }
        }
        
        return taxRates;
    }
    
    private static map<string,TaxRate__c> taxRatesMap = null;
   public static string stateReorder;
    public static map<string,TaxRate__c> GetTaxRatesList()
     
    {
         
        if( taxRatesMap == null )
        {
            taxRatesMap = new map<string,TaxRate__c>();
            for( TaxRate__c tr : [SELECT Id,State__c,Service_Quote_Tax_Rate__c FROM TaxRate__c ] )
            {
                stateReorder = tr.State__c;
                stateReorder = stateReorder.toUppercase();
                system.debug('The stateReorder is::::'+stateReorder);
                taxRatesMap.put(stateReorder, tr);
            }
        }
        
        return taxRatesMap;
    }
    
    
    
    public static string StringToTitleCase( string Str ) 
    {
        if(Str == null ) return Str;
        
        string buffer = '';
        for( string chunk : Str.split(' ') )
        {
//System.debug('checking chunk \''+chunk+'\' ' + chunk.isAllUpperCase());           
            chunk = chunk.trim();
            if( buffer != '' )
                buffer += ' ';
            if( chunk.isAllLowerCase() || chunk.isAllUpperCase() )
                buffer += chunk.toLowerCase().capitalize();
            else buffer += chunk;
        }
        
        return buffer;
    }
        
    
    public static decimal Distance(decimal lat1, decimal long1,decimal lat2, decimal long2)
    {   /*var R = 6371; // km
        var dLat = (lat2-lat1).toRad();
        var dLon = (lon2-lon1).toRad(); 
        var a = Math.sin(dLat/2) * Math.sin(dLat/2) +        
        Math.cos(lat1.toRad()) * Math.cos(lat2.toRad()) *     
            Math.sin(dLon/2) * Math.sin(dLon/2); 
            var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
            var d = R * c; */
        
        decimal R = 6371; 
        decimal ret=0;
        decimal dlat = DtoRad((lat2-lat1));
        decimal dlong = DtoRad((long2-long1));
        decimal a = Math.sin(dlat/2) * Math.sin(dlat/2) +
            Math.cos(DtoRad(lat1)) * Math.cos(DtoRad(lat2)) *
            Math.sin(dlong/2) * Math.sin(dLong/2);
        decimal c = 2 * Math.atan2(Math.sqrt(a),Math.sqrt(1-a));
        ret = R * c;
            
        return ret;
    }
    
    public static decimal DtoRad(decimal degree)
    {
        return degree * (3.14159/180);
    }
    
    public static Opportunity TaskScoring(Opportunity opp,Map<ID,Task> OppQuoteTasks,
    Map<ID,Task> ContactTasks,Map<ID,Quote__c> AllQuotes)
    {
        string linenbr='start';
        try
        {
            integer opencount=0,pdfcount=0;
             linenbr='before all quotes ' + (AllQuotes==null) + ' ' + (opp==null);
            for (Quote__c q : AllQuotes.values())
            {
                if (q.Opportunity__c ==opp.id)
                {
                    for (Task t2 : OppQuoteTasks.values())
                    {
                        if (t2.WhatID == q.id && t2.Subject.contains(': View'))
                        {
                            opencount = opencount+1;
                        }
                        else if (t2.WhatID == q.id && t2.Subject.contains('PDF:'))
                        {
                            pdfcount = pdfcount+1;
                        }
                    }
                }
            }
            
            integer openscore =0;
            if (opencount>=5)
            {
                openscore=20;
            }
            else if(opencount>=1)
            {
                openscore=10;
            }
            
            
            integer pdfscore=0;
            if (pdfcount>10)
            {
                pdfscore=20;
            }
            else if (pdfcount >=5)
            {
                pdfscore=15;
            }
            else if (pdfcount >=1)
            {
                pdfscore=10;
            }
            
            
            integer webvisitscore=0;
            integer threewebcount=0;
            integer fourteenwebcount=0;
             linenbr='before contact tasks';
            for (Task t:ContactTasks.values())
            {
                if (t.subject.contains('Website Visit'))
                {
                    if (t.CreatedDate >= opp.createddate.adddays(-3) && t.createddate <= opp.createddate.adddays(3))
                    {
                        threewebcount = threewebcount + 1;  
                    }
                    if (t.CreatedDate >= opp.createddate.adddays(-14) && t.createddate <= opp.createddate.adddays(14))
                    {
                        fourteenwebcount = fourteenwebcount + 1;    
                    }
                }
            }
            if (threewebcount > 5)
            {
                webvisitscore=20;
            }
            else if (fourteenwebcount > 5)
            {
                webvisitscore=10;
            }
            
            
            integer emailscore=0;
            
            
            integer tempscore = openscore+pdfscore+webvisitscore+emailscore;
            
            if (tempscore>=60)
            {
                opp.implicit_score__c = 1;
            }
            else if (tempscore>=40)
            {  
                opp.implicit_score__c = 2;
            }
            else if (tempscore >= 25)
            {
                opp.implicit_score__c=3;
            }
            else
            {
                opp.implicit_Score__c=4;
            }
        }
        catch (Exception ex)
        {
            utility.jimdebug(ex,'utility task scoring ' + linenbr);
        }
        return opp;
    }
        
        
    private static Map<string,string> cached_stateabbrnamemap = null; //need to do this to cut down on SOQL calls per instance run
    public static Map<string,string> StateAbbrNameMap()
    {
System.Debug('Getting abbr name map');      
        if( cached_stateabbrnamemap == null  )
        {
System.Debug(' ... wait, i need to get the map out of the DB.');        
            
            cached_stateabbrnamemap  = new Map<string,string>();
            for (State__c s : [select abbr__c,name from state__c])
            { 
                cached_stateabbrnamemap.Put(s.abbr__c,s.name);
            }
        }
System.Debug('Returning abbr name map');        
        
        return cached_stateabbrnamemap;
    }
    
//      @future(callout=true) public static void  FutureCallAccountWebService(Id AccountID)
//  {
//          WebServiceCaller.CallAccountWebService(AccountID);
//  }
    
//      @future(callout=true) public static void  FutureCallContactWebService(Id ContactID)
//  {
//          WebServiceCaller.CallContactWebService(ContactID);
//  }
    
    public static void RegisterQuoteEmailView( string QuoteID,boolean quotelink,string browser, string emailtype) {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('admin@a-stechnologies.com');   
        mail.setSenderDisplayName('Salesforce - Email Pinger');
        mail.setSubject('Email Ping! ' + QuoteID );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' Someone opened an email!' );
        mail.setHtmlBody(' Someone opened an email!' );
    //    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        string linenbr='';
        try
        {
            //if a contact opens the quote email or followup we consider the quote to be reviewed
            linenbr='before quote load';
            Quote__c q = [select id,Contact__c,Quote_ID__c from Quote__c where id=:QuoteID];
            if (emailtype=='quote' || emailtype=='followup' || emailtype=='cad')
            {           
                //is this redundant? the task trigger should catch this to set
                //quote reviewed    
//                q.Followup_Status__c = 'Reviewed';
                q.Viewed__c=true;
                update q;
                linenbr='before task load';
                //if they open the quote or followup email clear the followup tasks
                Map<id,Task> tl = new map<id,Task>([select id from Task where whatid=:QuoteID 
                    and (subject='Quote Rep Followup'  or subject='Quote Office Followup') 
                    and status!='Completed']);
                for (Task t1 : tl.values())
                {
                    t1.status = 'Completed';
                }
                update tl.values();
            }
            
            linenbr='before task create';
            Task t = new Task();
            t.ActivityDate = Date.today();
            if (emailtype=='quote')
            {
                t.Description = 'Quote Email Opened';
                t.Subject = 'Quote Email Opened: ' + q.Quote_ID__c;
            }
            else if (emailtype=='followup')
            {
                t.Description = 'Quote Followup Email Opened';
                t.Subject = 'Quote Followup Email Opened: ' + q.Quote_ID__c;                
            }
            else if (emailtype=='cad')
            {
                t.Description = 'Quote CAD Email Opened';
                t.Subject = 'Quote CAD Email Opened: ' + q.Quote_ID__c;         
                q.CAD_Viewed__c=true;
                update(q); 
            }
            t.Status = 'Completed';
            t.WhoId = q.Contact__c;
            t.WhatId = q.Id;
            t.OwnerId = '005A0000000M8piIAC';
            insert t;
         
        }
        catch (Exception ex)
        {
            Utility.JimDebug(ex,'email opened ' + emailtype + ' ' + linenbr);
        }
        //Utility.JimDebug(null, 'view email ' + QuoteID);   
        
    }
    
    
    public static integer LevenshteinDistance( string s, string t )
    {
        integer n,m,i,j,cost; // length of s
        string s_i,t_j; // ith character of s

        
        // Step 1
        if ( (n = s.length()) == 0) {
            return m;
        }
        if ( (m = t.length()) == 0) {
            return n;
        }
        list<string> sList = s.split('');
        list<string> tList = t.split('');
        
System.debug('before initializing matrix: ' + Limits.getScriptStatements( ));        
        List<List<integer>> d = new List<list<integer>>(); // matrix
        for( i=0;i<n+1;i++) 
        {
            d.add( new Integer[m+1] );
            d[i][0] = i;
        }
System.debug('after initializing matrix: ' + Limits.getScriptStatements( ));        
        
        // Step 2
        for (j = 0; j <= m; j++) {
          d[0][j] = j;
        }
system.debug('going into the matrix ' + Limits.getScriptStatements() + ' ; n = '+ n + ' ; m = ' + m );
        // Step 3
        for (i = 1; i <= n; i++) {
          for ( j=1; j <= m; j++) {
             d[i][j] =( ( d[i-1][j]+1 < d[i][j-1]+1 ? d[i-1][j]+1 : d[i][j-1]+1) < d[i-1][j-1] + ( sList[i-1] == tList[j-1] ? 0 : 1) ? ( d[i-1][j]+1 < d[i][j-1]+1 ? d[i-1][j]+1 : d[i][j-1]+1) : d[i-1][j-1] + ( sList[i-1] == tList[j-1] ? 0 : 1) );
          }
        }
system.debug('finished the matrix ' + Limits.getScriptStatements() );
        
        // Step 7
        return d[n][m];

    }
        
        
    public static boolean StringApproximateMatch(string StringOne, string StringTwo )
    {

        string string1 = StringOne.toLowerCase();
        string string2 = StringTwo.ToLowerCase();

        if (string1 == string2) return true; //a-duh!


        if( string1.length() == string2.length() )      
        { //if they are the same length the levenshtein calc works
            //half or less of the characters needs to be changed to get a match -- tweak to taste
            return ( LevenshteinDistance(string1, string2 ) < Math.round(string1.Length() / 2) ? true : false);
        }
        else
        {
            string key = (string1.Length() < string2.Length() ? string1 : string2);
            string source = (string1.Length() > string2.Length() ? string1 : string2);

            //do a quick regex
            if (source.Contains(key)) return true; //key is a substring of source
System.debug('they are not the same length');
            for (integer i = 0; i < source.length()-key.length(); i++)
            {               

System.debug( 'checking: ' + key + ' against ' + source.Substring(i,key.Length()+i ) );

                //A design thought -- maybe we should average the Levenshtein distances instead ?
                if( StringApproximateMatch( key, source.Substring(i,key.Length()+i ) ) ) //this does the approximate match on the proper lenght substrings of the source using a recursive call
                    return true;
            }
        }

        //nothign matched --- if we got to this point, return false
        return false;
    }
    
    public static void JimDebug(Exception ex,String notes)
    {
        try
        {
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'james.appenzeller@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('admin@a-stechnologies.com');   
        mail.setSenderDisplayName('debug');
        mail.setSubject('debug' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(notes );
        mail.setHtmlBody(notes);
      //  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        Task newTask = new Task();
        newTask.OwnerId = '005A0000000M8piIAC';
        if (ex != null)
        newTask.Description = notes + ' ' + ex.getCause() + ' ' + ex.getMessage();
        else
        newTask.Description = notes;
        if (ex!=null)
        newTask.Subject = ex.getTypeName();
        else
        newTask.Subject = 'general debug';
        newTask.Subject = newTask.Subject + ' ' + String.valueof(datetime.now());
        insert newTask;
        }
        catch (Exception exc)
        {
        
        }
    }
    
public static string HasAccessLastLine = '';
    public static boolean HasAccess( id ObjOwnerID, Set<id> knownIds) {
        //this method is a simple wrapper around the GetShare list Method. it takes in an ID for the owner of something
        // you want to work with, and a Set of id's for things like, ownerid and opportunityteammembers -- known ids that 
        //have access, it pulls out the total "share pool" based on the known ids and sees if the ObjOwnerID exists in the total 
        //set of ids 
HasAccessLastLine = '1';        
        return Utility.GetShareList(knownids).contains(objownerid);
    }
    public static string RequiredProfileID() { return GlobalStrings.RequiredProfileIDForSharePool(); }

    public static Set<Id> GetShareList( Set<id> IdsToLookup) {
HasAccessLastLine = '2';        
    
        Set<Id> shareSet = new Set<id>( IdsToLookup );
        
        list<User> allUsers = [SELECT id, UserRoleID,ProfileId FROM User];
        list<UserRole> allUserRoles = [SELECT Id,ParentRoleID FROM UserRole];
        
        Profile requiredProfile = [SELECT Id FROM Profile WHERE id = :Utility.RequiredProfileID() ];
HasAccessLastLine = '3';        
        
        for( Id lookupID : IdsToLookup )
        {
HasAccessLastLine = '4 ;  ' + lookupID;        
        
            //step 1: find the top id that is still a Rep profile
            
            //take the id, find the current role and profile level
//            User u = [SELECT id, UserRoleID,ProfileId FROM User WHERE id = :lookupID ];
            User u;
            for( User aU : allUsers )
            {
                if( aU.id == lookupID ) 
                {
                    u = aU;
                    break;
                }
            }
HasAccessLastLine = '5 ';        
        
            if( u.ProfileId != requiredProfile.Id )
                continue; //if the user is outside the required profile group already then dont bother to look
HasAccessLastLine = '6';        
            
            boolean keepLookingForRoot = true;
            id currentRoleID = u.UserRoleId;    
            while( keepLookingForRoot )
            {
HasAccessLastLine = '7';        
//                UserRole r = [SELECT Id,ParentRoleID FROM UserRole WHERE id = :currentRoleId ]; //get the role for the last User looked up
                UserRole r;
                for( UserRole ur : allUserRoles )
                {
                    if( ur.id == currentRoleID )
                    {
                        r = ur;
                        break;
                    }
                }
                
                //List<User> users  = [SELECT id, profileid FROM User WHERE UserRoleID = :r.ParentRoleID]; //use the parentid of the last role to fine a user "one level up"
                List<User> users = new List<User>();
                for( User aU : allUsers ) 
                {
                    if( aU.UserRoleId == r.ParentRoleId )
                    {
                        users.add( aU );
                    }
                }

                if( users.size() < 1 || users[0].ProfileId == requiredProfile.id ) 
                { //we are still within the required profile, this Role is a parent to the last role. save it and continue
                    //note: if no users were found, we treat this as a "mid level" find. worst case, when we move up past this empty one, if this empty one would have had the wrong profile the next one up would too so its all good
                    currentRoleID = r.ParentRoleId;                 
                } else {
                    keepLookingForRoot = false;
                }
            }
//          shareSet.add(currentroleid);
            //step 2: push down through the roles now   
HasAccessLastLine = '8';        
            boolean keepPushingDown = true;
            while( keepPushingDown )
            {
HasAccessLastLine = '9';        
//                for( User temp : [SELECT id FROM User WHERE UserRoleID = :currentRoleID ] )
                for( User temp : allUsers )
                {
                    if( temp.UserRoleId == currentRoleID )
                    {
                        shareSet.add(temp.id);
                    }
                }

//                List<UserRole> roles = [SELECT id FROM UserRole WHERE ParentRoleID = :currentRoleId ];
                List<UserRole> roles = new List<UserRole>();
                for( UserRole uR : allUserRoles )
                {
                    if( uR.ParentRoleId == currentRoleID )
                    {
                        roles.add(uR);
                    }
                }

                if( roles.size() < 1 )
                {
                    keepPushingDown = false;
                } else currentRoleId = roles[0].id;
            }
            //end pushing down through the roles
        }
HasAccessLastLine = '10';        

        return shareSet;
    }
    
    
    public static string getUserForTerritory(string country2,string zip2)
    {
        return GetUserFromAddress.GetUser(country2,zip2);
            }
    public static string HostName() { return GlobalStrings.HostName(); }
        public static string NanaServerAddress() { return GlobalStrings.NanaServerAddress(); } 

    public static List<List<string>> UnitedStates_States()
    { 
        List<List<string>> ret = new List<List<string>>();
        ret.Add(new List<string>{'ALABAMA','Alabama'});
        ret.Add(new List<string>{'ALASKA','Alaska'});
        ret.Add(new List<string>{'ARIZONA','Arizona'});
        ret.Add(new List<string>{'ARKANSAS','Arkansas'});
        ret.Add(new List<string>{'CALIFORNIA','California'});
        ret.Add(new List<string>{'COLORADO','Colorado'});
        ret.Add(new List<string>{'CONNECTICUT','Connecticut'});
        ret.Add(new List<string>{'DELAWARE','Delaware'});
        ret.Add(new List<string>{'FLORIDA','Florida'});
        ret.Add(new List<string>{'GEORGIA','Georgia'});
        ret.Add(new List<string>{'GUAM','Guam'});
        ret.Add(new List<string>{'HAWAII','Hawaii'});
        ret.Add(new List<string>{'IDAHO','Idaho'});
        ret.Add(new List<string>{'ILLINOIS','Illinois'});
        ret.Add(new List<string>{'INDIANA','Indiana'});
        ret.Add(new List<string>{'IOWA','Iowa'});
        ret.Add(new List<string>{'KANSAS','Kansas'});
        ret.Add(new List<string>{'KENTUCKY','Kentucky'});
        ret.Add(new List<string>{'LOUISIANA','Louisiana'});
        ret.Add(new List<string>{'MAINE','Maine'});
        ret.Add(new List<string>{'MARYLAND','Maryland'});
        ret.Add(new List<string>{'MASSACHUSETTS','Massachusetts'});
        ret.Add(new List<string>{'MICHIGAN','Michigan'});
        ret.Add(new List<string>{'MINNESOTA','Minnesota'});
        ret.Add(new List<string>{'MISSISSIPPI','Mississippi'});
        ret.Add(new List<string>{'MISSOURI','Missouri'});
        ret.Add(new List<string>{'MONTANA','Montana'});
        ret.Add(new List<string>{'NEBRASKA','Nebraska'});
        ret.Add(new List<string>{'NEVADA','Nevada'});
        ret.Add(new List<string>{'NEW HAMPSHIRE','New Hampshire'});
        ret.Add(new List<string>{'NEW JERSEY','New Jersey'});
        ret.Add(new List<string>{'NEW MEXICO','New Mexico'});
        ret.Add(new List<string>{'NEW YORK','New York'});
        ret.Add(new List<string>{'NORTH CAROLINA','North carolina'});
        ret.Add(new List<string>{'NORTH DAKOTA','North Dakota'});
        ret.Add(new List<string>{'OHIO','Ohio'});
        ret.Add(new List<string>{'OKLAHOMA','Oklahoma'});
        ret.Add(new List<string>{'OREGON','Oregon'});
        ret.Add(new List<string>{'PENNSYLVANIA','Pennslvania'});
        ret.Add(new List<string>{'PUERTO RICO','Puerto Rico'});
        ret.Add(new List<string>{'RHODE ISLAND','Rhode Island'});
        ret.Add(new List<string>{'SOUTH CAROLINA','South Carolina'});
        ret.Add(new List<string>{'SOUTH DAKOTA','South Dakota'});
        ret.Add(new List<string>{'TENNESSEE','Tennessee'});
        ret.Add(new List<string>{'TEXAS','Texas'});
        ret.Add(new List<string>{'UTAH','Utah'});
        ret.Add(new List<string>{'VERMONT','Vermont'});
        ret.Add(new List<string>{'VIRGIN ISLANDS','Virgin Islands'});
        ret.Add(new List<string>{'VIRGINIA','Virginia'});
        ret.Add(new List<string>{'WASHINGTON','Washington'});
        ret.Add(new List<string>{'WEST VIRGINIA','West Virginia'});
        ret.Add(new List<string>{'WISCONSIN','Wisconsin'});
        ret.Add(new List<string>{'WYOMING','Wyoming'});
        ret.Add(new List<string>{'District of Columbia','District of Columbia'});
        
        return ret;
    }
    
    public static List<List<string>> Canada_States()
    {
        List<List<string>> ret = new List<List<string>>();
        ret.Add(new List<string>{'Newfoundland','Newfoundland'});
        ret.Add(new List<string>{'Nova Scotia','Nova Scotia'});
        ret.Add(new List<string>{'Prince Edward Island','Prince Edward Island'});
        ret.Add(new List<string>{'New Brunswick','New Brunswick'});
        ret.Add(new List<string>{'Quebec','Quebec'});
        ret.Add(new List<string>{'Ontario','Ontario'});
        ret.Add(new List<string>{'Manitoba','Manitoba'});
        ret.Add(new List<string>{'Sasketchewan','Sasketchewan'});
        ret.Add(new List<string>{'Alberta','Alberta'});
        ret.Add(new List<string>{'British Columbia','British Columbia'});
        ret.Add(new List<string>{'Northwest Territory','Northwest Territory' });
        ret.Add(new List<string>{'Yukon Territory','Yukon Territory'});
        return ret;
    }
    
    public static List<List<string>> Mexico_States()
    {
        List<List<string>> ret = new List<List<string>>();
        ret.Add(new List<string>{'Caribbean', 'Caribbean'});
        ret.Add(new List<string>{'Aguascalientes', 'Aguascalientes'});
        ret.Add(new List<string>{'Baja California Norte', 'Baja California Norte'});
        ret.Add(new List<string>{'Baja California Sur', 'Baja California Sur'});
        ret.Add(new List<string>{'Campeche', 'Campeche'});
        ret.Add(new List<string>{'Chiapas', 'Chiapas'});
        ret.Add(new List<string>{'Chihuahua', 'Chihuahua'});
        ret.Add(new List<string>{'Coahuila', 'Coahuila'});
        ret.Add(new List<string>{'Colima', 'Colima'});
        ret.Add(new List<string>{'Distrito Federal','Distrito Federal'});
        ret.Add(new List<string>{'Durango','Durango'});
        ret.Add(new List<string>{'Guanajuato', 'Guanajuato'});
        ret.Add(new List<string>{'Guerrero', 'Guerrero'});
        ret.Add(new List<string>{'Hidalgo', 'Hidalgo'});
        ret.Add(new List<string>{'Jalisco', 'Jalisco'});
        ret.Add(new List<string>{'México (Estado de)','México (Estado de)'});
        ret.Add(new List<string>{'Michoacán', 'Michoacán'});
        ret.Add(new List<string>{'Morelos', 'Morelos'});
        ret.Add(new List<string>{'Nayarit', 'Nayarit'});
        ret.Add(new List<string>{'Nuevo León', 'Nuevo León'});
        ret.Add(new List<string>{'Oaxaca', 'Oaxaca'});
        ret.Add(new List<string>{'Puebla', 'Puebla'});
        ret.Add(new List<string>{'Querétaro', 'Querétaro'});
        ret.Add(new List<string>{'Quintana Roo', 'Quintana Roo'});
        ret.Add(new List<string>{'San Luis Potosí', 'San Luis Potosí'});
        ret.Add(new List<string>{'Sinaloa', 'Sinaloa'});
        ret.Add(new List<string>{'Sonora', 'Sonora'});
        ret.Add(new List<string>{'Tabasco', 'Tabasco'});
        ret.Add(new List<string>{'Tamaulipas', 'Tamaulipas'});
        ret.Add(new List<string>{'Tlaxcala', 'Tlaxcala'});
        ret.Add(new List<string>{'Veracruz', 'Veracruz'});
        ret.Add(new List<string>{'Yucatán', 'Yucatán'});
        ret.Add(new List<string>{'Zacatecas', 'Zacatecas'});
        return ret;
        
    }
    
    public static List<List<string>> States()
    {
        List<List<string>> ret = new List<List<string>>();
        for (List<string> pair:UnitedStates_States())
        {
            ret.add(pair);
        }
        
        for (List<string> pair:Canada_States())
        {
            ret.add(pair);
        }
        for (List<string> pair:Mexico_States())
        {
            ret.add(pair);
        }
        
        return ret;
    }
    
    public static List<SelectOption> StateOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        List<List<string>> items = Utility.States();
        for (List<string> item : items)
        {
            options.add(new SelectOption(item[0],item[1]));
        }
        return options;
    }
    
    public static List<List<string>> Countries()
    {
        //Map<string,string> ret = new Map<string,string>();
        List<List<string>> ret = new List<List<string>>();
        ret.Add(new List<string>{'United States','United States'});
        ret.Add(new List<string>{'Anguilla', 'Anguilla'});
        ret.Add(new List<string>{'Antilles, Netherlands', 'Antilles, Netherlands'});
        ret.Add(new List<string>{'Argentina', 'Argentina'});
        ret.Add(new List<string>{'Armenia', 'Armenia'});
        ret.Add(new List<string>{'Antigua and Barbuda','Antigua and Barbuda'});
        ret.Add(new List<string>{'Aruba', 'Aruba'});
        ret.Add(new List<string>{'Australia', 'Australia'});
        ret.Add(new List<string>{'Belgium', 'Belgium'});
        ret.Add(new List<string>{'Benin', 'Benin'});
        ret.Add(new List<string>{'Bahamas', 'Bahamas'});
        ret.Add(new List<string>{'Belize', 'Belize'});
        ret.Add(new List<string>{'Bermuda', 'Bermuda'});
        ret.Add(new List<string>{'Brazil', 'Brazil'});
        ret.Add(new List<string>{'Barbados', 'Barbados'});
        ret.Add(new List<string>{'Canada', 'Canada'});
        ret.Add(new List<string>{'Chile', 'Chile'});
        ret.Add(new List<string>{'China', 'China'});
        ret.Add(new List<string>{'Colombia', 'Colombia'});
        ret.Add(new List<string>{'Costa Rica', 'Costa Rica'});
        ret.Add(new List<string>{'Cayman Islands', 'Cayman Islands'});
        ret.Add(new List<string>{'Czech Republic','Czech Republic'});
        ret.Add(new List<string>{'Dominica','Dominica'});
        ret.Add(new List<string>{'Dominican Republic','Dominican Republic'});
        ret.Add(new List<string>{'Ecuador', 'Ecuador'});
        ret.Add(new List<string>{'Egypt', 'Egypt'});
        ret.Add(new List<string>{'El Salvador','El Salvador'});
        ret.Add(new List<string>{'Finland', 'Finland'});
        ret.Add(new List<string>{'France', 'France'});
        ret.Add(new List<string>{'Germany', 'Germany'});
        ret.Add(new List<string>{'Greece', 'Greece'});
        ret.Add(new List<string>{'Grenada', 'Grenada'});
        ret.Add(new List<string>{'Haiti', 'Haiti'});
        ret.Add(new List<string>{'India', 'India'});
        ret.Add(new List<string>{'Ireland', 'Ireland'});
        ret.Add(new List<string>{'Iran', 'Iran'});
        ret.Add(new List<string>{'Israel', 'Israel'});
        ret.Add(new List<string>{'Italy', 'Italy'});
        ret.Add(new List<string>{'Jamaica', 'Jamaica'});
        ret.Add(new List<string>{'Japan', 'Japan'});
        ret.Add(new List<string>{'Saint Kitts and Nevis','Saint Kitts and Nevis'});
        ret.Add(new List<string>{'Korea, Republic of', 'Korea, Republic of'});
        ret.Add(new List<string>{'Mexico', 'Mexico'});
        ret.Add(new List<string>{'Nicaragua', 'Nicaragua'});
        ret.Add(new List<string>{'Panama', 'Panama'});
        ret.Add(new List<string>{'Peru', 'Peru'});
        ret.Add(new List<string>{'Philippines', 'Philippines'});
        ret.Add(new List<string>{'Chad', 'Chad'});
        ret.Add(new List<string>{'St. Lucia','St. Lucia'});
        ret.Add(new List<string>{'Thailand', 'Thailand'});
        ret.Add(new List<string>{'Trinidad and Tobago', 'Trinidad and Tobago'});
        ret.Add(new List<string>{'Turkey', 'Turkey'});
        ret.Add(new List<string>{'Turks and Caicos', 'Turks and Caicos'});      
        ret.Add(new List<string>{'Taiwan', 'Taiwan'});
        ret.Add(new List<string>{'Ukraine', 'Ukraine'});
        ret.Add(new List<string>{'United Kingdom','United Kingdom'});       
        ret.Add(new List<string>{'Venezuela', 'Venezuela'});
        ret.Add(new List<string>{'British Virgin Islands', 'British Virgin Islands'});
        ret.Add(new List<string>{'Yugoslavia', 'Yugoslavia'});
        return ret;
    }
    
       public static List<SelectOption> CountryOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        List<List<string>> items = Countries();
        for (List<string> item : items)
        {
            options.add(new SelectOption(item[0],item[1]));
        }
        return options;
    }
    
    public static List<List<string>> LeadTypes()
    {
        List<List<string>> ret = new List<List<string>>();
        ret.Add(new List<string>{'Architect','Architect'});
        ret.Add(new List<string>{'Business Owner','Business Owner'});
        ret.Add(new List<string>{'Chain Account','Chain Account'});
        ret.Add(new List<string>{'Contractor','Contractor'});
        ret.Add(new List<string>{'Developer','Developer'});
        ret.Add(new List<string>{'Door Distributor','Door Distributor'});
        ret.Add(new List<string>{'Glazing Contractor','Glazing Contractor'});
        ret.Add(new List<string>{'Engineer','Engineer'});
        ret.Add(new List<string>{'Homeowner','Homeowner'});
        ret.Add(new List<string>{'Interior Designer','Interior Designer'});
        ret.Add(new List<string>{'Lumberyard Dealer','Lumberyard Dealer'});
        ret.Add(new List<string>{'Other','Other'});
        ret.Add(new List<string>{'Principal','Principal'});
        return ret;
    }
    
    public static List<SelectOption> LeadTypeOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        List<List<string>> items = LeadTypes();
        for (List<string> item : items)
        {
            options.add(new SelectOption(item[0],item[1]));
        }
        return options;
    }
    
    public static List<SelectOption> LeadSourceOptions()
    {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('direct','direct'));
        options.add(new SelectOption('list','list'));
        options.add(new SelectOption('email','email'));
        options.add(new SelectOption('friend','friend'));
        options.add(new SelectOption('notes','notes'));
        options.add(new SelectOption('online','online'));
        options.add(new SelectOption('print','print'));
        options.add(new SelectOption('trade show','trade show'));
        options.add(new SelectOption('other','other'));  
        return options;
        
    }
     
    public static List<SelectOption> LeadInterestOptions()
    {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Outdated Info','Outdated Info')); 
        options.add(new SelectOption('magazine-homeowner/business owner','magazine-homeowner/business owner')) ;
        options.add(new SelectOption('magazine-contractor/glazing contractor','magazine-contractor/glazing contractor')) ;
        options.add(new SelectOption('magazine-architect/designer/developer/chain','magazine-architect/designer/developer/chain')) ;
        options.add(new SelectOption('Phone/email-homeowner/business owner','Phone/email-homeowner/business owner')) ;
        options.add(new SelectOption('Phone/email-contractor/glazing contractor','Phone/email-contractor/glazing contractor')) ;
        options.add(new SelectOption('Phone/email-architect/designer/developer/chain','Phone/email-architect/designer/developer/chain')) ;
        options.add(new SelectOption('phone/email(project)-contractor/glazing contractor','phone/email(project)-contractor/glazing contractor')) ;
        options.add(new SelectOption('phone/email(project)-architect/designer/developer/chain','phone/email(project)-architect/designer/developer/chain')) ;
        options.add(new SelectOption('Pricing request','Pricing request')) ;
        options.add(new SelectOption('Ready to order','Ready to order')) ;
        options.add(new SelectOption('Other','Other')) ;
        options.add(new SelectOption('Project in progress','Project in progress')) ;
        return options;
    }
    
            public static List<SelectOption> StageOptions()
    {        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Considered','Considered')) ;
        options.add(new SelectOption('Specified','Specified')) ;
        options.add(new SelectOption('Quote Requested','Quote Requested')) ;
        options.add(new SelectOption('Budget Quote to Architect','Budget Quote to Architect')) ;
        options.add(new SelectOption('Quote/Non-Architect','Quote/Non-Architect')) ;
        options.add(new SelectOption('Quoted Architect and Non-Architect','Quoted Architect and Non-Architect')) ;
        options.add(new SelectOption('Order Probably Coming','Order Probably Coming')) ;
        options.add(new SelectOption('Order Process Started','Order Process Started')) ;
        options.add(new SelectOption('Ordered - Paid','Ordered - Paid')) ;
        options.add(new SelectOption('Quotes Passed Expected Resolution Date','Quotes Passed Expected Resolution Date')) ;

        return options;
    }
    
    public static List<List<string>> ApplicationTypes()
    {
  /*    
        List<List<string>> ret = new List<List<string>>();
        ret.Add(new List<string>{'single family residential - new','single family residential - new'});
        ret.Add(new List<string>{'single family residential - remodel','single family residential - remodel'});
        ret.Add(new List<string>{'Multifamily','Multifamily'});
        ret.Add(new List<string>{'Restaurant','Restaurants'});
        ret.Add(new List<string>{'Sports Venue','Sports Venue'});
        ret.Add(new List<string>{'Recreation/Entertainment',''});
        ret.Add(new List<string>{'Religious Institutions','Religious Institutions'});
        ret.Add(new List<string>{'Education','Education'});
        ret.Add(new List<string>{'Hotel','Hotels'});
        ret.Add(new List<string>{'Offices/Interiors','Offices/Interiors'});
        ret.Add(new List<string>{'Health Care/Assisted Living','Health Care/Assisted Living'});
        ret.Add(new List<string>{'Other','Other'});
        ret.Add(new List<string>{'Retail','Retail'});
        
*/  
        List<List<string>> ret = new List<List<string>>();
        ret.Add(new List<string>{'Automotive','Automotive'});
        ret.Add(new List<string>{'Common Area','Common Area'});
        ret.Add(new List<string>{'Education','Education'});
        ret.Add(new List<string>{'Health Care','Health Care'});
        ret.Add(new List<string>{'Hospitality','Hospitality'});
        ret.Add(new List<string>{'Hotel','Hotel'});
        ret.Add(new List<string>{'Multifamily - New','Multifamily - New'});
        ret.Add(new List<string>{'Multifamily - Remodel','Multifamily - Remodel'});
        ret.Add(new List<string>{'Office','Office'});
        ret.Add(new List<string>{'Other','Other'});
        ret.Add(new List<string>{'Recreation/Entertainment','Recreation - Entertainment'});
        ret.Add(new List<string>{'Religious Institution','Religious Institution'});
        ret.Add(new List<string>{'Restaurant','Restaurant'});
        ret.Add(new List<string>{'Retail','Retail'});
        ret.Add(new List<string>{'Single Family - New','Single Family - New'});
        ret.Add(new List<string>{'Single Family - Remodel','Single Family - Remodel'});
        ret.Add(new List<string>{'Sports Venue','Sports Venue'});

      
        return ret;
    }
    
    
            public static List<SelectOption> ApplicationOptions()
    {        
        List<SelectOption> options = new List<SelectOption>();
        List<List<string>> items = ApplicationTypes();
        for (List<string> item : items)
        {
            options.add(new SelectOption(item[0],item[1]));
        }
        return options;
    }
    
    
    
    public static Map<id,Account> AccountTreetoList(ID accid)
    {
        //Utility.JimDebug(null, 'get list '+ accid);
        accid = GetRoot(accid);
        return GetChildMap(new Map<id,Account>([select id,parent.id,name,amount__c, chain_account__c from account where id =:accid]));
    //  return new Map<id,Account>([select id,parent.id,name,amount__c from account where id =:accid]);
        
    }
    
    public static ID GetRoot(ID accid)
    {
        //Utility.JimDebug(null, 'get root '+ accid);
        Account acc = [select id,Parent.id from account where id =: accid limit 1];
        System.debug('acc id = ' + acc.id + ' ' + acc.parent.id + ' ' + accid);
        if ( acc!=null && acc.parent != null && string.valueOf(acc.parent.id) != '')
        {
            System.debug('inside if');
            return GetRoot(acc.parent.id);
        }
        else
        {
            System.debug('inside if');
            return acc.id;
        }
    }
    
    public static Map<id,Account> GetChildMap(Map<id,Account> acclist)
    {
        integer originalsize=acclist.size();
        System.debug( 'get child map size'+ acclist.size());
        map<id,Account> ret =new Map<id,account> ([select id,chain_Account__C,parent.id,name,amount__c from account where parent.id in: acclist.keyset()]);
        for (Account acc:ret.values())
        {
            if (!acclist.containsKey(acc.id))
            {
                acclist.put(acc.id,acc);
            }
        }
        if (originalsize != acclist.size())
        {
            return GetChildMap(acclist);
        }
        else
        {
            return acclist;
        } 
    }
    
// --------------- test method for utility. add calls in this method if you add methods to utility ---------------\\
    @isTest(SeeAllData=false)
    public static void TestUtility() {
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
          
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        Utility.Distance(1, 2, 3, 4);
        Utility.DtoRad(1 );
        Opportunity opp = TriggerTests.getNewOpportunity();
        insert opp;
        Quote__c qt = new Quote__c();
        qt.Opportunity__c = opp.id;
//      try 
//      {
            insert qt;
//      } catch( Exception ex)
//      {
//      }
        Map<Id, Quote__c> allQuotes =  new Map<ID,Quote__c>();
        allQuotes.put(qt.id,qt);
        Utility.TaskScoring(opp, new Map<ID,Task>(), new Map<ID,Task>(), allQuotes );
        StateAbbrNameMap();
        try
        {
            Account a = TriggerTests.getNewAccount();
            insert a;
//          Utility.FutureCallAccountWebService(a.id);
        } catch(exception ex) {}
        
        try {
            Contact c = TriggerTests.getNewContact();
//          Utility.FutureCallContactWebService(c.Id);
        } catch( Exception ex ) {}
        
        Utility.RegisterQuoteEmailView( '',false,'','');
        Utility.LevenshteinDistance( 'abc','def' );
        Utility.StringApproximateMatch('test 1','test 2' );
//      Utility.JimDebug( Exception,'');
        try{
            Quote__c q = TriggerTests.getNewQuote();            
            insert q;
            Utility.HasAccess( q.CreatedById, new Set<id>() );
        } catch( Exception ex) {}
        Utility.RequiredProfileID();
        Utility.GetShareList( new Set<id>() );
        Utility.getUserForTerritory('usa', '08619');
        Utility.HostName();
        Utility.NanaServerAddress();
        Utility.UnitedStates_States();
        Utility.Canada_States();
        Utility.Mexico_States();
        Utility.States();
        Utility.StateOptions();
        Utility.Countries();
        Utility.CountryOptions();
        Utility.LeadTypes();
        Utility.LeadTypeOptions();
        Utility.LeadSourceOptions();
        Utility.LeadInterestOptions();
        Utility.StageOptions();
        Utility.ApplicationTypes();
        Utility.ApplicationOptions();
        Account acc = TriggerTEsts.getNewAccount();
        insert acc;
        Utility.AccountTreetoList(acc.Id);
        Utility.GetRoot(acc.Id);
        Utility.GetChildMap(new Map<id,Account>() );
    
    }

    
}