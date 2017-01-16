trigger Lead_StateAbbreviation on Lead (before insert, before update) {

    /*
    trigger options
        writes to the state abbrev field 
        
    */
    
    /*for (Lead c : trigger.new)
    {
         if( c.State != '' && ( c.nrState__c == null || c.nrState__c == '' ) )
        {
            c.nrState__c = c.State;
        }
        if (c.nrState__c == 'ALABAMA') { c.State_Abbr__c='AL';}
        else if (c.nrState__c == 'ALASKA') { c.State_Abbr__c='AK';}
        else if (c.nrState__c == 'ARIZONA') { c.State_Abbr__c='AZ';}
        else if (c.nrState__c == 'ARKANSAS') { c.State_Abbr__c='AR';}
        else if (c.nrState__c == 'CALIFORNIA') { c.State_Abbr__c='CA';}
        else if (c.nrState__c == 'COLORADO') { c.State_Abbr__c='CO';}
        else if (c.nrState__c == 'CONNECTICUT') { c.State_Abbr__c='CT';}
        else if (c.nrState__c == 'DELAWARE') { c.State_Abbr__c='DE';}
        else if (c.nrState__c == 'FLORIDA') { c.State_Abbr__c='FL';}
        else if (c.nrState__c == 'GEORGIA') { c.State_Abbr__c='GA';}
        else if (c.nrState__c == 'HAWAII') { c.State_Abbr__c='HI';}
        else if (c.nrState__c == 'IDAHO') { c.State_Abbr__c='ID';}
        else if (c.nrState__c == 'ILLINOIS') { c.State_Abbr__c='IL';}
        else if (c.nrState__c == 'INDIANA') { c.State_Abbr__c='IN';}
        else if (c.nrState__c == 'IOWA') { c.State_Abbr__c='IA';}
        else if (c.nrState__c == 'KANSAS') { c.State_Abbr__c='KS';}
        else if (c.nrState__c == 'KENTUCKY') { c.State_Abbr__c='KY';}
        else if (c.nrState__c == 'LOUISIANA') { c.State_Abbr__c='LA';}
        else if (c.nrState__c == 'MAINE') { c.State_Abbr__c='ME';}
        else if (c.nrState__c == 'MARYLAND') { c.State_Abbr__c='MD';}
        else if (c.nrState__c == 'MASSACHUSETTS') { c.State_Abbr__c='MA';}
        else if (c.nrState__c == 'MICHIGAN') { c.State_Abbr__c='MI';}
        else if (c.nrState__c == 'MINNESOTA') { c.State_Abbr__c='MN';}
        else if (c.nrState__c == 'MISSISSIPPI') { c.State_Abbr__c='MS';}
        else if (c.nrState__c == 'MISSOURI') { c.State_Abbr__c='MO';}
        else if (c.nrState__c == 'MONTANA') { c.State_Abbr__c='MT';}
        else if (c.nrState__c == 'NEBRASKA') { c.State_Abbr__c='NE';}
        else if (c.nrState__c == 'NEVADA') { c.State_Abbr__c='NV';}
        else if (c.nrState__c == 'NEW HAMPSHIRE') { c.State_Abbr__c='NH';}
        else if (c.nrState__c == 'NEW JERSEY') { c.State_Abbr__c='NJ';}
        else if (c.nrState__c == 'NEW MEXICO') { c.State_Abbr__c='NM';}
        else if (c.nrState__c == 'NEW YORK') { c.State_Abbr__c='NY';}
        else if (c.nrState__c == 'NORTH CAROLINA') { c.State_Abbr__c='NC';}
        else if (c.nrState__c == 'NORTH DAKOTA') { c.State_Abbr__c='ND';}
        else if (c.nrState__c == 'OHIO') { c.State_Abbr__c='OH';}
        else if (c.nrState__c == 'OKLAHOMA') { c.State_Abbr__c='OK';}
        else if (c.nrState__c == 'OREGON') { c.State_Abbr__c='OR';}
        else if (c.nrState__c == 'PENNSYLVANIA') { c.State_Abbr__c='PA';}
        else if (c.nrState__c == 'RHODE ISLAND') { c.State_Abbr__c='RI';}
        else if (c.nrState__c == 'SOUTH CAROLINA') { c.State_Abbr__c='SC';}
        else if (c.nrState__c == 'SOUTH DAKOTA') { c.State_Abbr__c='SD';}
        else if (c.nrState__c == 'TENNESSEE') { c.State_Abbr__c='TN';}
        else if (c.nrState__c == 'TEXAS') { c.State_Abbr__c='TX';}
        else if (c.nrState__c == 'UTAH') { c.State_Abbr__c='UT';}
        else if (c.nrState__c == 'VERMONT') { c.State_Abbr__c='VT';}
        else if (c.nrState__c == 'VIRGINIA') { c.State_Abbr__c='VA';}
        else if (c.nrState__c == 'WASHINGTON') { c.State_Abbr__c='WA';}
        else if (c.nrState__c == 'WEST VIRGINIA') { c.State_Abbr__c='WV';}
        else if (c.nrState__c == 'WISCONSIN') { c.State_Abbr__c='WI';}
        else if (c.nrState__c == 'WYOMING') { c.State_Abbr__c='WY';}
        else if (c.nrState__c == 'Alberta') { c.State_Abbr__c='AB';}
        else if (c.nrState__c == 'British Columbia') { c.State_Abbr__c='BC';}
        else if (c.nrState__c == 'Manitoba') { c.State_Abbr__c='MB';}
        else if (c.nrState__c == 'New Brunswick') { c.State_Abbr__c='NB';}
        else if (c.nrState__c == 'Newfoundland and Labrador') { c.State_Abbr__c='NL';}
        else if (c.nrState__c == 'Northwest Territories') { c.State_Abbr__c='NT';}
        else if (c.nrState__c == 'Nova Scotia') { c.State_Abbr__c='NS';}
        else if (c.nrState__c == 'Nunavut') { c.State_Abbr__c='NU';}
        else if (c.nrState__c == 'Ontario') { c.State_Abbr__c='ON';}
        else if (c.nrState__c == 'Prince Edward Island') { c.State_Abbr__c='PE';}
        else if (c.nrState__c == 'Quebec') { c.State_Abbr__c='QC';}
        else if (c.nrState__c == 'Saskatchewan') { c.State_Abbr__c='SK';}
        else if (c.nrState__c == 'Yukon') { c.State_Abbr__c='YT';}
        
        else
        {
            c.State_Abbr__c = c.nrState__c;
        }
    }*/
}