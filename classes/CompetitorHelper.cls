/**********************************************************************
Apex Class: CompetitorHelper
Description: This class is used to write all business logic related to 
            Competitor Trigger
Created Date: 28thMarch,2014            
***********************************************************************/
public with sharing class CompetitorHelper {

    /*************************************************
    Method Name: UpdateProjectCompetitorCheckbox
    Description: This method is used to update Project has Competitor checkbox field on Project 
                if there are competitors present to project.
    Input Parameter: Set of Ids         
    *************************************************/
    public static void updateProjectCompetitorCheckbox(Set < Id > projIds) {
        //Declaration of Variables
        List < Project__c > updateProject = new List < Project__c > ();

        //Query over project with Related Competitors
        for (Project__c proj: [Select Id, Project_Has_Competitor__c, (Select Id from Competitor_Details__r) from Project__c Where ID IN: projIds]) {
            if (proj.Competitor_Details__r.size() > 0) {
                proj.Project_Has_Competitor__c = true;
            } else {
                proj.Project_Has_Competitor__c = false;
            }
            updateProject.add(proj);
        }

        if (updateProject.size() > 0) {
            //updating project
            Database.update(updateProject);
        }
    }
    
    /*************************************************
    Method Name: UpdateOpportunityCompetitorCheckbox
    Description: This method is used to update Opportunity has Competitor checkbox field on Opportunity 
                if there are competitors present to project.
    Input Parameter: Set of Ids         
    *************************************************/
    public static void updateOpportunityCompetitorCheckbox(Set < Id > oppIds) {
        //Declaration of Variables
        List < Opportunity > updateOpportunity = new List < Opportunity > ();

        //Query over Opportunity with Related Competitors
        for (Opportunity opp: [Select Id, Opportunity_Has_Competitor__c, (Select Id from Competitor_Details__r) from Opportunity Where ID IN: oppIds]) {
            if (opp.Competitor_Details__r.size() > 0) {
                opp.Opportunity_Has_Competitor__c = true;
            } else {
                opp.Opportunity_Has_Competitor__c = false;
            }
            updateOpportunity.add(opp);
        }

        if (updateOpportunity.size() > 0) {
            //updating Opportunity
            Database.update(updateOpportunity);
        }
    }

}