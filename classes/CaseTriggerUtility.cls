/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 06-June-2016
    @ Test File     : CaseAttachmentTestNew
    @ Description   : To assign the case owner as case team member
    @ Audit Trial   : Added logic for excluding Case Default owner and shopify guest user in case team member
    @ Last Modified Date : 15-June-2016
  
****************************************************************************/ 


public class CaseTriggerUtility {
     /* 
         Method Name    : AssignTeamMember
         Purpose        : This Method serves the pupose of assigning case owner as Case Manager in Case Team Member.
         Input Parameter: List of Cases  
         Created Date   : June 2016
         */
    public static void AssignTeamMember(List < Case > newTrigger) {
        system.debug('Entered AssignTeamMember');
        Set < id > ParentCaseIds = new Set < id > ();
        Set < id > UserMembers = new set < id > ();

        List < CaseTeamRole > CtRole = [SELECT Name, Id FROM CaseTeamRole Where Name = 'Case Manager' Limit 1];
        List<CaseTeamMember> CtmAdd = new List<CaseTeamMember>();
       
        /*To exclude default owner and shopify guest user from being added to case team member*/ 
       List<string> ExcludeTheseOwners = new List<string>();
       string DefaultCaseOwner = Label.Default_Case_Owner;
       string ShopifyGuestUser = Label.Shopify_Guest_User; 
       ExcludeTheseOwners.Add(DefaultCaseOwner);
       ExcludeTheseOwners.add(ShopifyGuestUser);
       Map<ID, User> ExcludedUser = new Map<id,User>([SELECT id , Name FROM USER Where Name IN: ExcludeTheseOwners Limit 5]);
            
        
        try {
               for (case c: newTrigger)

               {
                   if(!ExcludedUser.containsKey(c.OwnerId))
                   {
                       CaseTeamMember CTMNew = new CaseTeamMember();
                       CTMNew.MemberId = c.OwnerId ; 
                       CTMNew.ParentId = c.id ; 
                       CTMNew.TeamRoleId = ctrole[0].id ;  
                       CtmAdd.Add(CTMNew);
                   }

              }


            insert CtmAdd;

        } catch (exception e) {
            system.debug('Exception is:' + e.getMessage());
        }
    }
    
    /*********************************************
    Method:completeMilestone
    Purpose: To complete the Case created milestone automatically
    Related Triggers:CaseTrigger
    Test class: EntitlementcaseTrigger_Test
    **********************************************/
    public static void completeMilestone(List<Case> caselist){
    TRY{
        system.debug('The caselist is:::'+caselist);
        List<CaseMilestone> cmList = new List<CaseMilestone>();
        //Querying the milestones based on the caseids
        List<CaseMilestone> milestoneList = [select id,CompletionDate,Caseid from CaseMilestone WHERE Caseid in:caselist limit 1];
        
        system.debug('the milestoneList is::'+milestoneList);
        if(milestoneList.size()>0){
        for(CaseMilestone sm:milestoneList){
            sm.CompletionDate = system.now(); 
            cmList.add(sm);
        }
        if(cmList.size()>0){ //Null pointer check
        update cmList;
        }
        }
        }catch(exception e){}
    }
    /*********************************************
    Method:updateInstallerContactonCase
    Purpose: To fill the Installer Contact field on Case created if Order field is not empty 
             and the Order has Installations below it
    Related Triggers:CaseTrigger
    **********************************************/
    public static void updateInstallerContactonCase(list<Case>caselist,set<id>ordIds){
        list<Installation__c> inslist= [Select id,Installer_Contact__c,Order__c from Installation__c where Order__c in:ordIds];
        if(inslist.size()>0){
            for(case c:caselist){
                for(installation__c i:inslist){
                    if(c.order__c == i.order__c) 
                    {
                        c.Installer_Contact__c = i.Installer_Contact__c;
                    }
                }
            }
        }

        
    }
    
    /*********************************************
    Method: EmailToCaseDelete
    Purpose: Delete Case created by Email to Case
    Related Triggers:CaseTrigger
    **********************************************/
    @future
    public static void EmailToCaseDelete(list<ID> caselist){
        system.debug('I am inside EmailToCaseDelete');
        if(caselist.size() > 0 ){
            system.debug('Value of caseList' +caseList);
            Database.delete(caseList);
            
        }
        
    }
    
    
    
    
}