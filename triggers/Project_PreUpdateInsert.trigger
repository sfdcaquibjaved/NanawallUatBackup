trigger Project_PreUpdateInsert on Opportunity(before insert, before update) {

    /*
        trigger purpose
            flags projects as needing a "LatLng" update; flags the opp as "Architect known" when appropriate;  sends the In2Clouds call out for scoring when appropriate
    */

    set < id > ids = new set < id > ();
    for (Opportunity o: trigger.new) {
        if (trigger.isInsert) {

        } else if (trigger.isUpdate) {
            try {
                if (o.Roles__c.contains('Architect')) {
                    o.Architect_Known__c = 'Yes';
                }
                if (o.I2C_Realtime_Request_In_Progress__c || o.IsClosed) {
                    //we have a future method calling in to this trigger -- do not re-queue it
                    o.I2C_Realtime_Request_In_Progress__c = false;


                } else {

                    Opportunity oldopp = trigger.oldMap.get(o.id);

                    Datetime ITC2_DateThresh = datetime.now();
                    ITC2_DateThresh = ITC2_DateThresh.addDays(-90);


                    if (
                        (o.Quote_Count__c > 2 && o.CreatedDate <= ITC2_DateThresh && o.Contact_Count__c > 2 &&
                            (o.CreatedDate != oldopp.CreatedDate || o.Contact_Count__c != oldopp.Contact_Count__c || o.Quote_Count__c != oldopp.Quote_Count__c)
                        ) ||
                        (
                            (o.Quote_Count__c > 0 && (
                                o.Quote_Count__c != oldopp.Quote_Count__c || o.CreatedDate != oldopp.CreatedDate || o.Chain_Account__c != oldopp.Chain_Account__c || o.OwnerId != oldopp.OwnerId || o.Amount != oldopp.Amount || o.Application__c != oldopp.Application__c || o.Discount__c != oldopp.Discount__c || o.Discount_Grouping__c != oldopp.Discount_Grouping__c || o.HighRise__c != oldopp.HighRise__c || o.Models__c != oldopp.Models__c || o.Roles__c != oldopp.Roles__c || o.Prizm_4__c != oldopp.Prizm_4__c || o.Max_Finalized_Date__c != oldopp.Max_Finalized_Date__c || o.Max_Email_Date__c != oldopp.Max_Email_Date__c
                            ))
                        )) {
                        ids.add(o.id);

                    }
                }
            } catch (Exception ex) {
                System.debug('Project_PreUpdateInsert caught an exception ' + ex);
            }

        }
    }

    if (ids.size() > 0) {
        Opportunity_UtilityClass.SetIn2CloudsScore(new list < id > (ids));
    }


}