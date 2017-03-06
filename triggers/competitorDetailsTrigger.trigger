/****************************************************************
Trigger Name: competitorDetailsTrigger
Events: after insert,after update and after delete
*****************************************************************/
trigger competitorDetailsTrigger on Competitor_Detail__c(after insert, after update, after delete) {
    // Declaration of Variables
    Set < Id > projIds = new Set < Id > ();
    Set < Id > oppIds = new Set < Id > ();

    //Trigger event on after Insert,Update and delete
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.IsDelete)) {
        for (Competitor_Detail__c comp: (Trigger.isDelete) ? trigger.old : trigger.new) {
            //Check if Competitor has Project
            if (comp.Project__c != null) {
                projIds.add(comp.Project__c);
            }
            
            if(comp.Opportunity__c!=null){
                oppIds.add(comp.Opportunity__c);
           }
            
        }
    }

    if (projIds.size() > 0) {
        //Call method from CompetitorHelper Utility class
        CompetitorHelper.updateProjectCompetitorCheckbox(projIds);
    }
    
   if(oppIds.size()>0){
        CompetitorHelper.updateOpportunityCompetitorCheckbox(oppIds);
    }

}