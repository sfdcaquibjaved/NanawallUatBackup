/*********************************************************************************************************************
Trigger Name: CaseTrigger
Events: before insert,after update, after insert
Description: To handle different functionalities on Case in Service Cloud
**********************************************************************************************************************/
trigger CaseTrigger on Case(before insert,before update, after update, after insert) {

    /*
     Purpose:This functionality serves the purpose of assigning the case owner as a case team member on that case
     Created Date: April 2016
     */
    set < id > caseIdSetInsert = new set < id > ();
    public List < Case > NewCaseOwner;
    if (trigger.isInsert && trigger.isafter) {

        CaseTriggerUtility.AssignTeamMember(Trigger.new);
        for (
            case c:
                trigger.new) {
            caseidsetInsert.add(c.id);
        }

        if (caseIdSetInsert.size() > 0)
            caseAttachment.insertfirstemail(caseIdSetInsert);

    } else if (trigger.isUpdate && trigger.isafter) {
        for (ID CaseId: Trigger.newMap.keySet()) {
            //Fire only when owner is changed
            if (Trigger.oldMap.get(CaseId).OwnerId != Trigger.newMap.get(CaseId).OwnerId) {

                NewCaseOwner = Trigger.newMap.values();
            }
        }

        CaseTriggerUtility.AssignTeamMember(NewCaseOwner);

    }

    /*
    Purpose:Trigger for Auto Updating the Tax Rates field in Service Quote based on the shipping state of Case
    Created Date: April 2016
    */


    if (trigger.isAfter && trigger.isUpdate) {
       // SQ_TaxRates.updateTaxRate(trigger.new);


        /*
     
     Description: For creating attachments in the case realted list from email messages
     Created Date: May 2016
    */

        List < EmailMessage > emaillist = new List < EmailMessage > ();
        list <
            case >caselist = new list <
            case >();
        set < EmailMessage > emailmessageset = new set < EmailMessage > ();
        set < id > caseIdSet = new set < id > ();

        for (
            case c:
                trigger.new) {
            if (c.dummy__c == true) {
                caseIdSet.add(c.id);
            }
        }
        emaillist = [select id, parentid from EmailMessage where parentid IN: caseIdSet order by createddate DESC LIMIT 1];


        for (EmailMessage em: emaillist) {
            emailmessageset.add(em);
        }

        /******************************************************
        Purpose:To autocomplete the Case created milestone when the customer receives the email notification and check field is checked
        *******************************************************/
      try{
      List<Case> caseList1 = new List<Case>();
        for(Case cs:trigger.new){
        if(cs.Milestone_check__c == true){
        caseList1.add(cs);
        system.debug('The caseList1 is::'+caseList1);
        }
    }
    CaseTriggerUtility.completeMilestone(caseList1); //Calling completeMilestone method in caseTriggerUtility clas
    }catch(exception e){}
    }
    // Purpose : - Change default case owner of email to case functionality

    if (trigger.isInsert && trigger.isBefore) {
        //CaseOwner.ChangeOwner(Trigger.new);
    }
    list<case> caseList = new list<case>();
    boolean quoteChanged= false; // to check whether the order eas changed on the case or quote 
    boolean orderChanged= false;
    for(case c :trigger.new){
    if( trigger.isBefore && (trigger.isInsert || (trigger.isUpdate && (Trigger.oldMap.get(c.id).quote__c != c.quote__c))|| (trigger.isUpdate && (Trigger.oldMap.get(c.id).Order__c != c.Order__c)))){
        caseList.add(c);
        if(trigger.isUpdate && (Trigger.oldMap.get(c.id).quote__c != c.quote__c))
         quoteChanged = true;
        else if(trigger.isUpdate && (Trigger.oldMap.get(c.id).Order__c != c.Order__c))
         orderChanged = true;
        system.debug('hiSatz');
    }
    }
    if(caseList.size()>0){
    caseTriggerHelperForOrderUpdate.addValuesOfOrderQuoteProject(caseList,quoteChanged,orderChanged);
    system.debug('hiSatz2');
    }
    
    set<id> caseConIds = new set<id>();
    for(case c :trigger.new){
        if( trigger.isBefore && (trigger.isInsert || (trigger.isUpdate && (Trigger.oldMap.get(c.id).ContactId != c.ContactId)))){
           system.debug('ConID:-'+c.ContactId);
           if(c.ContactId!=null){
              caseConIds.add(c.ContactId); 
           }  
        }
    }
    if(caseConIds.size()>0){
        caseTriggerHelperForOrderUpdate.autoUpdateConTypeOnCase(Trigger.new,caseConIds);
    }
    
<<<<<<< HEAD
    set<id> caseOrdIds = new set<id>();
    for(case c:trigger.new){
    if( trigger.isBefore && (trigger.isInsert || (trigger.isUpdate && (Trigger.oldMap.get(c.id).order__c != c.order__c)))){
        if(c.order__c !=null){
        caseOrdIds.add(c.order__c);
        }  
    }
    
        if(caseOrdIds.size()>0){    
        caseTriggerHelperForOrderUpdate.updateSLorderFromManufact(Trigger.new,caseOrdIds);
        }
    }
    
    
=======
>>>>>>> 38d5474048e4349e5fb1b806274e5d38ea1dc1fc
}