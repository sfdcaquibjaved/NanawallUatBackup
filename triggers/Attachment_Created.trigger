trigger Attachment_Created on Attachment (after insert,after update) {

    /* 
        this trigger detects when an attachment is created, and appends the 
        attachment name to the opportunity's Attachment_List__c*/

    //load up all the objects needed for the trigger; make sure to use the TriggerVariables structure to prevent unnecessary SOQL hits
    list<Id> parentIds = new list<id>();
    for( Attachment a : trigger.new )
    {   
        if( !TriggerVariables.OpportunityMap_All.containsKey(a.ParentId) )
            parentIds.add( a.ParentId );
    } 
    if( parentIds.size() > 0  )
    {
        for( Opportunity o : TriggerVariables.GetOpportunitiesFromIdList(parentIds) )
        {
            TriggerVariables.OpportunityMap_All.put(o.Id, o);
        }
    }
    //end loading up static variables   
    
    list<Opportunity> oppsToUpdate = new list<Opportunity>();
    for( Attachment a : trigger.new )
    {
        if(TriggerVariables.OpportunityMap_All.containsKey(a.ParentId ) )
        {
            Opportunity o = TriggerVariables.OpportunityMap_All.get( a.ParentId);
            if(o.Attachment_List__c == null)
                o.Attachment_List__c = a.Name;
            else o.Attachment_List__c += ', ' + a.Name;
        
            oppsToUpdate.add( o );  
            TriggerVariables.OpportunityMap_All.put(o.Id, o ); //overwriting the reference because im not sure how the data is stored and dont have time to test
        }
    }
    
    if( oppsToUpdate.size() > 0 )
        update oppsToUpdate;
    
/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 06-June-2016
    @ Test File     : 
    @ Description   : This functionality serves the purpose of handling attachment in email messages
    @ Audit Trial   : Code moved to utility class
    @ Events        : after insert,after update
    @ Last Modified Date : 07-June-2016
  
****************************************************************************/ 
   
    if (((trigger.isinsert ) || (trigger.isUpdate) ) && trigger.isAfter) 
    {
        AttachmentUtility.AttachmentHandler(Trigger.new);
        AttachmentUtility.moveuploads(Trigger.new);
        AttachmentUtility.movecaseuploads(Trigger.new);
    }
    
    if(trigger.isInsert && trigger.isAfter){
        AttachmentUtility.moveAttachment(Trigger.new);
    }
}