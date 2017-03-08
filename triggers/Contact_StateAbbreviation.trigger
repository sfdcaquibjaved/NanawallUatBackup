trigger Contact_StateAbbreviation on Contact (before insert, before update) {

    /*
    trigger purpose
        assigns the two-letter abbreviation to the abbrev field when  a contact is updated
    */

    for (Contact c : trigger.new)
    {
        c.State_Abbr__c = c.MailingStateCode;
        /*
        if (c.MailingState == 'ALABAMA') { c.State_Abbr__c='AL';}
        else if (c.MailingState == 'ALASKA') { c.State_Abbr__c='AK';}
        else if (c.MailingState == 'ARIZONA') { c.State_Abbr__c='AZ';}
        else if (c.MailingState == 'ARKANSAS') { c.State_Abbr__c='AR';}
        else if (c.MailingState == 'CALIFORNIA') { c.State_Abbr__c='CA';}
        else if (c.MailingState == 'COLORADO') { c.State_Abbr__c='CO';}
        else if (c.MailingState == 'CONNECTICUT') { c.State_Abbr__c='CT';}
        else if (c.MailingState == 'DELAWARE') { c.State_Abbr__c='DE';}
        else if (c.MailingState == 'FLORIDA') { c.State_Abbr__c='FL';}
        else if (c.MailingState == 'GEORGIA') { c.State_Abbr__c='GA';}
        else if (c.MailingState == 'HAWAII') { c.State_Abbr__c='HI';}
        else if (c.MailingState == 'IDAHO') { c.State_Abbr__c='ID';}
        else if (c.MailingState == 'ILLINOIS') { c.State_Abbr__c='IL';}
        else if (c.MailingState == 'INDIANA') { c.State_Abbr__c='IN';}
        else if (c.MailingState == 'IOWA') { c.State_Abbr__c='IA';}
        else if (c.MailingState == 'KANSAS') { c.State_Abbr__c='KS';}
        else if (c.MailingState == 'KENTUCKY') { c.State_Abbr__c='KY';}
        else if (c.MailingState == 'LOUISIANA') { c.State_Abbr__c='LA';}
        else if (c.MailingState == 'MAINE') { c.State_Abbr__c='ME';}
        else if (c.MailingState == 'MARYLAND') { c.State_Abbr__c='MD';}
        else if (c.MailingState == 'MASSACHUSETTS') { c.State_Abbr__c='MA';}
        else if (c.MailingState == 'MICHIGAN') { c.State_Abbr__c='MI';}
        else if (c.MailingState == 'MINNESOTA') { c.State_Abbr__c='MN';}
        else if (c.MailingState == 'MISSISSIPPI') { c.State_Abbr__c='MS';}
        else if (c.MailingState == 'MISSOURI') { c.State_Abbr__c='MO';}
        else if (c.MailingState == 'MONTANA') { c.State_Abbr__c='MT';}
        else if (c.MailingState == 'NEBRASKA') { c.State_Abbr__c='NE';}
        else if (c.MailingState == 'NEVADA') { c.State_Abbr__c='NV';}
        else if (c.MailingState == 'NEW HAMPSHIRE') { c.State_Abbr__c='NH';}
        else if (c.MailingState == 'NEW JERSEY') { c.State_Abbr__c='NJ';}
        else if (c.MailingState == 'NEW MEXICO') { c.State_Abbr__c='NM';}
        else if (c.MailingState == 'NEW YORK') { c.State_Abbr__c='NY';}
        else if (c.MailingState == 'NORTH CAROLINA') { c.State_Abbr__c='NC';}
        else if (c.MailingState == 'NORTH DAKOTA') { c.State_Abbr__c='ND';}
        else if (c.MailingState == 'OHIO') { c.State_Abbr__c='OH';}
        else if (c.MailingState == 'OKLAHOMA') { c.State_Abbr__c='OK';}
        else if (c.MailingState == 'OREGON') { c.State_Abbr__c='OR';}
        else if (c.MailingState == 'PENNSYLVANIA') { c.State_Abbr__c='PA';}
        else if (c.MailingState == 'RHODE ISLAND') { c.State_Abbr__c='RI';}
        else if (c.MailingState == 'SOUTH CAROLINA') { c.State_Abbr__c='SC';}
        else if (c.MailingState == 'SOUTH DAKOTA') { c.State_Abbr__c='SD';}
        else if (c.MailingState == 'TENNESSEE') { c.State_Abbr__c='TN';}
        else if (c.MailingState == 'TEXAS') { c.State_Abbr__c='TX';}
        else if (c.MailingState == 'UTAH') { c.State_Abbr__c='UT';}
        else if (c.MailingState == 'VERMONT') { c.State_Abbr__c='VT';}
        else if (c.MailingState == 'VIRGINIA') { c.State_Abbr__c='VA';}
        else if (c.MailingState == 'WASHINGTON') { c.State_Abbr__c='WA';}
        else if (c.MailingState == 'WEST VIRGINIA') { c.State_Abbr__c='WV';}
        else if (c.MailingState == 'WISCONSIN') { c.State_Abbr__c='WI';}
        else if (c.MailingState == 'WYOMING') { c.State_Abbr__c='WY';}
        else if (c.MailingState == 'Alberta') { c.State_Abbr__c='AB';}
        else if (c.MailingState == 'British Columbia') { c.State_Abbr__c='BC';}
        else if (c.MailingState == 'Manitoba') { c.State_Abbr__c='MB';}
        else if (c.MailingState == 'New Brunswick') { c.State_Abbr__c='NB';}
        else if (c.MailingState == 'Newfoundland and Labrador') { c.State_Abbr__c='NL';}
        else if (c.MailingState == 'Northwest Territories') { c.State_Abbr__c='NT';}
        else if (c.MailingState == 'Nova Scotia') { c.State_Abbr__c='NS';}
        else if (c.MailingState == 'Nunavut') { c.State_Abbr__c='NU';}
        else if (c.MailingState == 'Ontario') { c.State_Abbr__c='ON';}
        else if (c.MailingState == 'Prince Edward Island') { c.State_Abbr__c='PE';}
        else if (c.MailingState == 'Quebec') { c.State_Abbr__c='QC';}
        else if (c.MailingState == 'Saskatchewan') { c.State_Abbr__c='SK';}
        else if (c.MailingState == 'Yukon') { c.State_Abbr__c='YT';}
        
        else
        {
            c.State_Abbr__c = c.MailingState;
        }
        */
    }
}