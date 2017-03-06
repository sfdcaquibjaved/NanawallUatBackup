trigger Docusign_Status_on_Project on dsfs__DocuSign_Status__c(before insert, after insert, after update) {

    list < dsfs__DocuSign_Status__c > dsinsert = new list < dsfs__DocuSign_Status__c > ();
    if (trigger.isInsert && trigger.isafter) {
        list < dsfs__DocuSign_Status__c > dslist = [select id, Nana_Quote__r.Project__c from dsfs__DocuSign_Status__c where id IN: Trigger.newMap.keySet()];
        for (dsfs__DocuSign_Status__c ds: dslist) {
            if (ds.Nana_Quote__c != NULL) {
                ds.Project_Name__c = ds.Nana_Quote__r.Project__c;
                System.debug('project' + ds.Nana_Quote__c);
                dsinsert.add(ds);
            }

        }

        if (dsinsert.size() > 0) {
            update dsinsert;
        }
    }

}