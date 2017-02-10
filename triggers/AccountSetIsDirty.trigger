trigger AccountSetIsDirty on Account (before insert, before update) {

    //this trigger cleans phone numbers on acocunt
    
    
    Map<string,string> statemap = Utility.StateAbbrNameMap(); 
     for( Account a : Trigger.new )
    {
        if (a.Phone != NULL)
        {
            if (a.Phone.startsWith('+1'))
            {
                a.Phone = a.Phone.substring(3);
                a.Phone = a.Phone.replace('.','-');
                a.Phone = a.Phone.replaceFirst('(^[0-9][0-9][0-9]).','($1) ');
            }
            a.Phone = a.Phone.replace('.','-');
        }
        
        a.SyncInProgress__c = false;
        
                            
    }
}