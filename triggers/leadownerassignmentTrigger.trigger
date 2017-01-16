trigger leadownerassignmentTrigger on Lead(before insert, before update) {
    list < Lead > updateLeadList = new list < Lead > ();
    list < Lead > lstLeads = new list < Lead > ();
    if (Trigger.isInsert) {

        list < Lead > LeadList = leadOwnerAssignment.validateZip(trigger.new);
        if (LeadList.size() > 0) {
            leadOwnerAssignment.prepareLeadRecordValues(LeadList);
        }
    }
    if (trigger.isUpdate) {
        if (!leadOwnerAssignment.doNotRun) {
            Set < Id > leadId = new Set < Id > ();
            for (Lead lead: Trigger.new) {
                if ((lead.PostalCode != Trigger.oldMap.get(lead.Id).PostalCode || lead.CountryCode != Trigger.oldMap.get(lead.Id).CountryCode || lead.statecode != Trigger.oldMap.get(lead.Id).statecode || lead.Country != Trigger.oldMap.get(lead.Id).Country) || (lead.Project_Site_Zip_Code__c != Trigger.oldMap.get(lead.Id).Project_Site_Zip_Code__c || lead.Project_Site_Country__c != Trigger.oldMap.get(lead.Id).Project_Site_Country__c || lead.Project_Site_State__c != Trigger.oldMap.get(lead.Id).Project_Site_State__c)) {
                    lstLeads.add(lead);
                }
            }
            if (lstLeads.size() > 0) {
                updateLeadList = leadOwnerAssignment.validateZip(lstLeads);
            }
            for (lead l: updateLeadList) {
                leadId.add(l.Id);
            }
            if (leadId.size() > 0) {
                leadOwnerAssignment.assignOwner(leadId);
            }
        }
    }
}