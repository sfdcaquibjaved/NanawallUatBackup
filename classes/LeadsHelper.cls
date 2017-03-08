public with sharing class LeadsHelper {


/*************************************************
    Method Name: SetContactRoleDefaults
    Description: This method is used to update Contact Role with value
    from Type field in Lead
 *************************************************/
// Sets default values on the Opportunity and Opportunity Contact Role record created during Conversion. Called on AFTER UPDATE
public static void SetContactRoleDefaults(Lead[] leads, map<ID,Lead> old_leads) 
{

	//Declaration of Variables     
    Map<Id,String> opptyMaps = new Map<ID,String>();
                 
    // Get Opportunity IDs and Lead Type into a Map if the lead was just converted and an Opportunity was created
    for (Lead l:leads){
        if (l.IsConverted && !old_leads.get(l.id).IsConverted){
            if (l.ConvertedOpportunityId != null){
                opptyMaps.put(l.ConvertedOpportunityId,old_leads.get(l.id).Type__c);
            }
        }
    }
     
    // Update Opportunity Contact Roles
    list<OpportunityContactRole> list_opptyContactRolesToUpdate = new list<OpportunityContactRole>();
    for(OpportunityContactRole ocr:[select Id,IsPrimary,Role,OpportunityId from OpportunityContactRole where OpportunityId in :opptyMaps.keySet()]) { 
        //Setting Contact Role from Lead Type
        ocr.Role = opptyMaps.get(ocr.OpportunityId); // set to what you want defaulted
        list_opptyContactRolesToUpdate.add(ocr);
    }
    
    //Update Contact Role List 
    if (list_opptyContactRolesToUpdate.size() > 0) {
        update list_opptyContactRolesToUpdate;
    }
     
}

}