trigger projectownerassignmentTrigger on project__c (before insert, before update, after insert,after update) 
{
/*list<Project__c> lstProjects= new list<Project__c>();
 if(trigger.isbefore)
 {
     for(Project__c ProRec : trigger.New)
     {
       if((Trigger.isInsert || (Trigger.isUpdate &&
       (Trigger.oldMap.get(ProRec.Id).project_zip_code__c!=ProRec.project_zip_code__c || Trigger.oldMap.get(ProRec.Id).project_state__c!=ProRec.project_state__c || Trigger.oldMap.get(ProRec.Id).Project_Country__c!=ProRec.Project_Country__c )))&&
       projectOwnerAssignment.validateZip(ProRec))
       {
         lstProjects.add(ProRec);
       }
     }
  
     
 if(lstProjects!=null && lstProjects.size()>0)
    {
      projectOwnerAssignment.assignOwner(lstProjects);
     }
  }
if (trigger.isafter)
    {
      projectOwnerAssignment.updateOppTeam(trigger.new);
    }*/
}