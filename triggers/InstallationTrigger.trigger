/*********************************************************************************************************************
Trigger Name: InstallationTrigger
Events: before insert ,after insert, after update, before update
Description: To handle different functionalities on Installation in Installation Management
**********************************************************************************************************************/
trigger InstallationTrigger on Installation__c(before insert, after insert, after update, before update) {

    //Added by Satish Lokinindi For updating Order Product details on to the Installation object
    if (trigger.isInsert && trigger.isAfter) {

        InstallationTriggerHandler.udpateInstallationPosition(Trigger.new);
    }
    system.debug('DML 1' + Limits.getDMLStatements());
    system.debug('SOQL 1' + Limits.getQueries());

    if (((trigger.isUpdate) || (trigger.isInsert)) && (trigger.isBefore))  {
        List < Installation__c > InstallationUserList = new List < Installation__c > ();

        for (installation__c i: trigger.new) {
            /**if ((Trigger.isBefore) && ((trigger.isInsert) || (trigger.isUpdate && (trigger.oldMap.get(i.ID)
                    .Installer_Contact__c != i.Installer_Contact__c)))) {
                InstallationUserList.add(i);


            }   */

            if (((trigger.isUpdate) && (trigger.isBefore)) && (trigger.oldMap.get(i.ID)
                    .Installation_Date__c == null) && (i.Installation_Date__c != null) && (i.RecordTypeId == label.Pre_Site_Visit_Record_ID)) {
                i.Status_Pre_Installation_Visit__c = 'Scheduled';
            }

        }
        //for assigning installer user 
      /*  if (InstallationUserList.size() > 0) {
          //  InstallationTriggerHandler.updateInstallerUser(InstallationUserList);
            system.debug('DML 2' + Limits.getDMLStatements());
            system.debug('SOQL 2' + Limits.getQueries());
        } */
    }




    if (trigger.isInsert && trigger.isBefore) {
        // for updating Names of Installation Ticket
        InstallationTriggerHandler.updateInstallationName(Trigger.new);
        system.debug('DML 3' + Limits.getDMLStatements());
        system.debug('SOQL 3' + Limits.getQueries());

    }

   if (((trigger.isUpdate) || (trigger.isInsert)) && (trigger.isBefore ))  {
        List < Installation__c > InstallationTaskList = new List < Installation__c > ();
        for (installation__c i: trigger.new) {
            if ((Trigger.isBefore) && ((trigger.isInsert) || (trigger.isUpdate && (trigger.oldMap.get(i.ID)
                    .Installation_Date__c != i.Installation_Date__c)))) {
                InstallationTaskList.add(i);
            }
        }
        //for creating task and event
        if (InstallationTaskList.size() > 0) {
            InstallationTriggerHandler.CreateOwnerTask(InstallationTaskList);
            system.debug('DML 4' + Limits.getDMLStatements());
            system.debug('SOQL 4' + Limits.getQueries());
        }
    }

  if (((trigger.isUpdate) || (trigger.isInsert)) && (trigger.isBefore ))  {

        List < Installation__c > InstallationAccountList = new List < Installation__c > ();
        for (installation__c i: trigger.new) {
            if ((Trigger.isBefore) && ((trigger.isInsert) || (trigger.isUpdate && (trigger.oldMap.get(i.ID)
                    .Project__c != i.Project__c)))|| (trigger.isUpdate && (trigger.oldMap.get(i.ID).Installer_Contact__c != i.Installer_Contact__c))){
                              InstallationAccountList.add(i);


            }


        }
        //for assigning installer account and contact to installtion record

        if (InstallationAccountList.size() > 0) {
            InstallationTriggerHandler.AssignInstaller(InstallationAccountList);
            system.debug('DML 5' + Limits.getDMLStatements());
            system.debug('SOQL 5' + Limits.getQueries());
        }
    }



   if (((trigger.isUpdate) || (trigger.isInsert)) && (trigger.isAfter ))  {

        List < Installation__c > InstallationShareList = new List < Installation__c > ();
        for (installation__c i: trigger.new) {


            if (((trigger.isInsert) && (Trigger.isAfter)) || (trigger.isUpdate && (trigger.oldMap.get(i.ID).Assigned_to__c != i.Assigned_to__c)))
                {
                
                    InstallationShareList = Trigger.newMap.values();


                }



        }
        //for sharing account and project record to Installer
        if (InstallationShareList.size() > 0) {
            InstallationTriggerHandler.manualShareRead(InstallationShareList);
            system.debug('DML 7' + Limits.getDMLStatements());
            system.debug('SOQL 7' + Limits.getQueries());
        }
    }

    if (trigger.isInsert && trigger.isAfter) {
        //for creating task for Installer
        InstallationTriggerHandler.CreateOwnerTask(Trigger.new);
        system.debug('DML 6' + Limits.getDMLStatements());
        system.debug('SOQL 6' + Limits.getQueries());
    }




    /***
     PURPOSE: For updating Entitlements start date,Certified Installer check box based on different conditions
      ***/

    //To update the entitlement based on the Installation fields
    try {
        List < Installation__c > instList = new List < Installation__c > ();
        if ((trigger.isInsert && trigger.isAfter) || (trigger.isupdate && trigger.isAfter)) {

            InstallationTriggerHandler.updateEntitlement(trigger.new, trigger.oldmap);
            system.debug('DML 8' + Limits.getDMLStatements());
            system.debug('SOQL 8' + Limits.getQueries());
        }
    } catch (exception e) {}



}