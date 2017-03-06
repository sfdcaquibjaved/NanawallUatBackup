trigger WebQuote_PreInsert on Web_Quote__c (before insert, after insert) {

    map<id,id> webQuoteIDMap = new map<id,id>();
    set<id> webQuoteIDs = new set<id>();
System.debug('webquote.preinser. incoming size: ' + trigger.new.size() );   
    for( Web_Quote__c w : trigger.new )
    { 

        if( trigger.isBefore )
        {
            try {
                w.OwnerId = Utility.getUserForTerritory( w.Project_Country__c, w.Project_Zip__c );
                
            } catch (Exception ex){
                utility.jimdebug(ex, 'Webquote user assignment failed for ' + w.Project_Name__c );
            }
        } else if (trigger.isAfter )
        {

        }
    }
System.debug('webquote.preinser. webqouteids size: ' + webQuoteIDMap.size() );  

    if( trigger.isAfter )
    {

    }
}