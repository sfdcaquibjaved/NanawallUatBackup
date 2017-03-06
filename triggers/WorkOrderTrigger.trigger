trigger WorkOrderTrigger on Work_Order__c(after delete, after insert, after update)  {
    Set < Id > oppIds = new Set < Id > ();

    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.IsDelete)) {
        for (Work_Order__c  wOrder: (Trigger.isDelete) ? trigger.old : trigger.new) {
            oppIds.add(wOrder.Opportunity__c);
        }
    }
    if (oppIds.size() > 0)
        WorkOrderTriggerHelper.checkForOpportunitiesProject(oppIds);

}