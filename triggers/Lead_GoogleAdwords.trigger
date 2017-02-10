trigger Lead_GoogleAdwords on Lead (after insert, after update) {

    /*
        trigger purpose
            when the keywords object change, this creates a record; do we still use ad words? If not, we can get rid of this
    */

    list<SFGA__Keyword__c>   sfgaKeywordUpdates = new List<SFGA__Keyword__c>();
    for ( Integer i=0; i< trigger.size; i++ )
    {

        if( trigger.old == null 
        || (
                trigger.new[i].kts__c != trigger.old[i].kts__c 
                && trigger.new[i].kts__c != null
                && trigger.new[i].kts__c != '' )
            )
        { //keywords changing
             
            try {
                

                String decodedUrl = EncodingUtil.urlDecode(trigger.new[i].kts__c,'utf-8');
                
                Pattern cpattern = Pattern.compile('adurl=([^&]*)&(.*)$');
                Matcher cmatcher = cpattern.matcher(decodedUrl );
                Boolean foundSubUrl = cmatcher.find();
                String embeddedUrl = EncodingUtil.urlDecode( cmatcher.group(1).replace('adurl=','') , 'utf-8');

                Pattern subpattern = Pattern.compile('_kk=([^&]*)&(.*)$');
                cmatcher = subpattern.matcher(embeddedUrl );
                Boolean foundKeyValuePair = cmatcher.find();
                String kkValue = cmatcher.group(1).replace('_kk=','');

                
//              trigger.new[i].TestResult__c = kkValue;


                list<SFGA__Keyword__c>   temp = [SELECT id FROM SFGA__keyword__c WHERE SFGA__Lead__c = :trigger.new[i].id AND Name = :kkValue ];
                if( temp.size() < 1 )
                {
                
                    SFGA__keyword__c sfgaKey = new SFGA__Keyword__c();
                    sfgaKey.Name     = kkValue;
                    sfgaKey.SFGA__Lead__c = trigger.new[i].id;
                    sfgaKeywordUpdates.add( sfgaKey );
                }


            } catch (Exception ex )
            {
//              trigger.new[i].TestResult__c = ex.getmessage();
                
            }
        }
    
    }
    
    if( sfgaKeywordUpdates.size() > 0 ) insert sfgaKeywordUpdates;

}