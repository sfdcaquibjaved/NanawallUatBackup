trigger LeadConvert on Lead (after update) {



    /*
    trigger purpose
        this trigger makes sure that opportunities get the contactroles on convert; I THINK that we ould actually get rid of the contactrole and this trigger.  
    */

    /*set<Id> contactIds = new set<Id>();
    for( Lead l : trigger.new )
    {
        if( !l.IsConverted || l.ConvertedContactId == null)
            continue; 
            
        if( !contactIds.contains(l.ConvertedContactId) )
            contactIds.add(l.ConvertedContactId);
    }
    list<Id> lookupContactIds = new list<Id>( contactIds );
    list<Id> convertedContactsToUpdate = new LIst<Id>();
    
    if( TriggerVariables.LeadConvert_existingOCRs == null )
    { //look int he static variable keeping track of these. this should be the same across multiple runs of the trigger.
        TriggerVariables.LeadConvert_existingOCRs = new Set<string>();
        for( nrOpportunityContactRole__c ocr : TriggerVariables.LeadConvert_getNrOpportunityContactRole_By_ContactIds(lookupContactIds))
        {
            if(!TriggerVariables.LeadConvert_existingOCRs.contains(ocr.Opportunity__c+'_'+ocr.Contact__c) ) 
                TriggerVariables.LeadConvert_existingOCRs.add(ocr.Opportunity__c+'_'+ocr.Contact__c);
            
        }
    }

    list<nrOpportunityContactRole__c> ocrList = new list<nrOpportunityContactRole__c>();
    for( Lead l : Trigger.new ) 
    {
        //detect a conversion is in process
        if( l.isConverted   )
        {
            if( l.ConvertedContactId != null && l.ConvertedOpportunityId != null 
            && !TriggerVariables.LeadConvert_existingOCRs.contains(l.ConvertedContactId+ '_' + l.ConvertedOpportunityId) )
            {
                nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
                ocr.Opportunity__c = Trigger.new[0].ConvertedOpportunityId;
                ocr.Contact__c = Trigger.new[0].ConvertedContactId;
                ocr.Role__c = l.Type__c;
                ocrList.add(ocr);
                TriggerVariables.LeadConvert_existingOCRs.add(l.ConvertedContactId+ '_' + l.ConvertedOpportunityId); //this should persist across multiple runs of this trigger
                
                
            } else if(TriggerVariables.LeadConvert_existingOCRs.contains(l.ConvertedContactId+ '_' + l.ConvertedOpportunityId))
            {
                System.debug('LeadConvert Warning! Trying to create a duplicate opportunitycontact role for ' + Trigger.new[0].ConvertedOpportunityId + ' , ' + Trigger.new[0].ConvertedContactId);
            }
        }
    }
    
    if( ocrList.size() > 0)
    {
        insert ocrList;   
    }*/
    

}