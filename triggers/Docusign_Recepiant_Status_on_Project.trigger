trigger Docusign_Recepiant_Status_on_Project on dsfs__DocuSign_Recipient_Status__c(before insert, after insert, after update) {
    list < dsfs__DocuSign_Recipient_Status__c > drinsert = new list < dsfs__DocuSign_Recipient_Status__c > ();
    dsfs__DocuSign_Recipient_Status__c drlist2;
    dsfs__DocuSign_Status__c dd;
    dsfs__DocuSign_Status__c dpro;
    if (trigger.isInsert && trigger.isAfter) {
        for (dsfs__DocuSign_Recipient_Status__c ds: trigger.new) {
            if (ds.dsfs__Parent_Status_Record__c != NULL && ds.Dummy__c != TRUE) {

                dsfs__DocuSign_Status__c d = [Select Id, Nana_Quote__c from dsfs__DocuSign_Status__c where id = : ds.dsfs__Parent_Status_Record__c];
                quote__c q = [select id, Project__c from quote__c where id = : d.Nana_Quote__c];
                string s = String.valueof(q.id);
                try{
                dd = [select id from dsfs__DocuSign_Status__c where Project_Name__c = : q.Project__c AND Docusign_Quote_id__c = : d.id];
                }catch(Exception e){}
                
                dsfs__DocuSign_Recipient_Status__c drlist = [Select Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, ConnectionReceivedId, ConnectionSentId, dsfs__Parent_Status_Record__c, dsfs__Account__c, dsfs__Contact__c, dsfs__Date_Declined__c, dsfs__Date_Delivered__c, dsfs__Date_Sent__c, dsfs__Date_Signed__c, dsfs__Decline_Reason__c, dsfs__DocuSign_Recipient_Company__c, dsfs__DocuSign_Recipient_Email__c, dsfs__DocuSign_Recipient_Id__c, dsfs__DocuSign_Recipient_Title__c, dsfs__DocuSign_Routing_Order__c, dsfs__Envelope_Id__c, dsfs__Lead__c, dsfs__Recipient_Status__c FROM dsfs__DocuSign_Recipient_Status__c where id = : ds.id];
                
                if (drlist != NULL && dd!=NULL) {
                    dsfs__DocuSign_Recipient_Status__c dr = new dsfs__DocuSign_Recipient_Status__c();
                    dr = drlist.clone(false, true, false, false);
                    dr.dsfs__Parent_Status_Record__c = dd.id;
                    dr.Docusign_recepient_id_of_quote__c=drlist.id;
                    dr.Dummy__c = true;

                    drinsert.add(dr);

                }


            }
        }
        if (drinsert.size() > 0) {
            insert drinsert;
        }
    }

    if (trigger.isUpdate && trigger.isAfter) {

        list < dsfs__DocuSign_Recipient_Status__c > docureciplist = new list < dsfs__DocuSign_Recipient_Status__c > ();
        for (dsfs__DocuSign_Recipient_Status__c ds: trigger.new) {
            if (trigger.oldMap.get(ds.id).dsfs__Recipient_Status__c != ds.dsfs__Recipient_Status__c && ds.dummy__c != TRUE) {
                dsfs__DocuSign_Status__c d = [Select Id, OwnerId, IsDeleted, Name, CreatedDate, dsfs__Case__c, dsfs__Company__c, dsfs__Completed_Age__c, dsfs__Completed_Date_Time__c, dsfs__Contact__c, dsfs__Contract__c, dsfs__Days_to_Complete__c, dsfs__Declined_Date_Time__c, dsfs__Declined_Reason__c, dsfs__DocuSign_Envelope_ID__c, dsfs__Envelope_Link__c, dsfs__Envelope_Status__c, dsfs__Hours_to_Complete__c, dsfs__Hrs_Sent_to_Sign__c, dsfs__Lead__c, dsfs__Minutes_to_Complete__c, dsfs__Number_Completed__c, dsfs__Opportunity__c, dsfs__Sender_Email__c, dsfs__Sender__c, dsfs__Sent_Age__c, dsfs__Sent_Date_Time__c, dsfs__Subject__c, dsfs__Time_to_Complete__c, dsfs__Viewed_Date_Time__c, dsfs__Voided_Date_Time__c, dsfs__Voided_Reason__c, Nana_Quote__c, Project_Name__c FROM dsfs__DocuSign_Status__c where id = : ds.dsfs__Parent_Status_Record__c];
                quote__c q = [select id, Project__c from quote__c where id = : d.Nana_Quote__c];
                try {
                    dpro = [Select Id, Project_Name__c FROM dsfs__DocuSign_Status__c where Project_Name__c = : q.Project__c AND quote_id__c = : q.id AND Docusign_Quote_id__c=:d.id];
                } catch (exception e) {}
                dsfs__DocuSign_Recipient_Status__c drlist = [Select Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, ConnectionReceivedId, ConnectionSentId, dsfs__Parent_Status_Record__c, dsfs__Account__c, dsfs__Contact__c, dsfs__Date_Declined__c, dsfs__Date_Delivered__c, dsfs__Date_Sent__c, dsfs__Date_Signed__c, dsfs__Decline_Reason__c, dsfs__DocuSign_Recipient_Company__c, dsfs__DocuSign_Recipient_Email__c, dsfs__DocuSign_Recipient_Id__c, dsfs__DocuSign_Recipient_Title__c, dsfs__DocuSign_Routing_Order__c, dsfs__Envelope_Id__c, dsfs__Lead__c, dsfs__Recipient_Status__c FROM dsfs__DocuSign_Recipient_Status__c where id = : ds.id];
               if(dpro!=NULL)
               {
                try {
                    drlist2 = [Select Id, IsDeleted, Name, CreatedDate, CreatedById, Docusign_recepient_id_of_quote__c, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, ConnectionReceivedId, ConnectionSentId, dsfs__Parent_Status_Record__c, dsfs__Account__c, dsfs__Contact__c, dsfs__Date_Declined__c, dsfs__Date_Delivered__c, dsfs__Date_Sent__c, dsfs__Date_Signed__c, dsfs__Decline_Reason__c, dsfs__DocuSign_Recipient_Company__c, dsfs__DocuSign_Recipient_Email__c, dsfs__DocuSign_Recipient_Id__c, dsfs__DocuSign_Recipient_Title__c, dsfs__DocuSign_Routing_Order__c, dsfs__Envelope_Id__c, dsfs__Lead__c, dsfs__Recipient_Status__c FROM dsfs__DocuSign_Recipient_Status__c where dsfs__Parent_Status_Record__c = : dpro.id AND Docusign_recepient_id_of_quote__c=:ds.id];
                } catch (exception e) {

                }
                }

                if (drlist2 != NULL) {
                    drlist2.dsfs__Date_Declined__c = drlist.dsfs__Date_Declined__c;
                    drlist2.dsfs__Date_Delivered__c = drlist.dsfs__Date_Delivered__c;
                    drlist2.dsfs__Date_Sent__c = drlist.dsfs__Date_Sent__c;
                    drlist2.dsfs__Date_Signed__c = drlist.dsfs__Date_Signed__c;
                    drlist2.dsfs__Decline_Reason__c = drlist.dsfs__Decline_Reason__c;
                    drlist2.dsfs__Recipient_Status__c = drlist.dsfs__Recipient_Status__c;

                    docureciplist.add(drlist2);
                } else {
                    if (dpro != NULL) {
                        dsfs__DocuSign_Recipient_Status__c dr = new dsfs__DocuSign_Recipient_Status__c();
                        dr = drlist.clone(false, true, false, false);
                        dr.dsfs__Parent_Status_Record__c = dpro.id;
                        dr.Dummy__c = true;
                        dr.Docusign_recepient_id_of_quote__c=drlist.id;
                        drinsert.add(dr);
                    } else {
                        dsfs__DocuSign_Status__c dpro2 = new dsfs__DocuSign_Status__c();
                        dpro2 = d.clone(false, true, false, false);
                        dpro2.Nana_Quote__c = NULL;
                        dpro2.Project_Name__c = q.Project__c;
                        dpro2.quote_id__c = q.id;
                        dpro2.Docusign_Quote_id__c = d.id;
                        insert dpro2;

                        dsfs__DocuSign_Recipient_Status__c dr = new dsfs__DocuSign_Recipient_Status__c();
                        dr = drlist.clone(false, true, false, false);
                        dr.dsfs__Parent_Status_Record__c = dpro2.id;
                        dr.Dummy__c = true;
                        dr.Docusign_recepient_id_of_quote__c=drlist.id;
                        drinsert.add(dr);

                    }
                }
            }
        }
        if (docureciplist.size() > 0) {
            update docureciplist;
        }
        if (drinsert.size() > 0) {
            insert drinsert;
        }
    }
}