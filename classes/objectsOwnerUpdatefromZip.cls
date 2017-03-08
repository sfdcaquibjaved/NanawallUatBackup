public with sharing class objectsOwnerUpdatefromZip {

    public static void assignobjectowner(list < Zip_Codes_Master__c > zipOld, list < Zip_Codes_Master__c > zipNew) {
        set < string > zips = new set < string > ();
        set < string > cntrys = new set < string > ();
        list < account > acclist = new list < account > ();
        list < lead > leadslist = new list < lead > ();
        list < contact > conlist = new list < contact > ();
        list < project__c > prolist = new list < project__c > ();
        list <project__share> updateproshrlist = new list <project__share>();
        ID uold, unew;
        set < ID > usr = new set < ID > ();
        set < ID > usrold = new set < ID > ();
        for (Zip_Codes_Master__c z: zipOld) {
            uOld = z.user__c;
            usrold.add(z.user__c);
        }
        for (Zip_Codes_Master__c l: zipNew) {
            if (l.user__c != uOld) {
                usr.add(l.user__c);
                if (l.zip_code__c != null && l.zip_code__c != '') {
                    zips.add(l.zip_code__c);
                } else if (l.country__c != null && l.country__c != '') {
                    cntrys.add(l.country__c);
                }
                unew = l.user__c;
            }          
        }
        for (account acountToUpdate: [select ownerID, ID,billingcountry from account where billingpostalcode IN: zips OR billingcountry IN: cntrys]) {
            if (acountToUpdate.OwnerID != unew) {
                acountToUpdate.OwnerID = unew;
                acclist.add(acountToUpdate);
            }
        }
        for (lead leadsToUpdate: [select ownerID, isConverted, ID from lead where ownerID IN: usrold AND(postalcode IN: zips OR country IN: cntrys)]) {
            if (leadsToUpdate.ownerID != unew && leadsToUpdate.isConverted == False) {
                leadsToUpdate.ownerID = unew;
                leadslist.add(leadsToUpdate);
            }
        }
        for (contact contactsToUpdate: [select ownerID, ID from contact where ownerID IN: usrold AND(mailingpostalcode IN: zips OR mailingcountry IN: cntrys)]) {
            if (contactsToUpdate.ownerID != unew) {
                contactsToUpdate.ownerID = unew;
                conlist.add(contactsToUpdate);
            }
        }
        for (project__c projectsToUpdate: [select ownerID, ID,stage__c from project__c where ownerID IN: usrold AND(project_zip_code__c IN: zips OR project_country__c IN: cntrys)]) {
            if(projectsToUpdate.stage__c != 'Closed Lost - Project Lost' && projectsToUpdate.stage__c != 'Closed Lost - Project Cancelled' && projectsToUpdate.stage__c !='Closed Complete - Ordered - Paid' ){
                if (projectsToUpdate.ownerID != unew) {
                     projectsToUpdate.ownerID = unew;
                     prolist.add(projectsToUpdate);
            }
            }
            else { 
                    project__share proshr = new project__share();
                    //oppTeam.OpportunityAccessLevel = 'Read';
                    proshr.parentID = projectsToUpdate.ID;
                    proshr.UserOrGroupId = unew;
                    proshr.AccessLevel = 'Read';
                    updateproshrlist.add(proshr);
            }
        }
        Try {
        insert updateproshrlist;
        update acclist;
        update leadslist;
        update conlist;
        update prolist;
        }
Catch (System.DmlException e)  {
System.debug ('DML Exception ' + e.getDmlMessage(0));
}
Finally {
system.debug('exception');
}
    }
}