@isTest
public class ProjectHomeController_Test {
    public static String sortField;
    public static testMethod void mytest1(){
        
        ProjectHomeController phc = new ProjectHomeController();
        phc.reset();
        string str = phc.getOldModelsChecked();
        string str1 = phc.getOldModelsToggleValue();
        List<SelectOption> list1 = phc.getModelOptions();
        string str2 = phc.getSelectedTerritory();
        List<SelectOption> list2 = phc.getTerritories();
        Project__c str3 = phc.getDummyOpportunity();
        phc.primeSearch();
        phc.myaction();
        List<Project__c> list3 = phc.getmyOpportunitys();
        List<SelectOption> list4 = phc.getStates();
        List<SelectOption> list5 = phc.getStages();
        List<SelectOption> list6 = phc.getRecordTypes();
        List<SelectOption> list7 = phc.getCountries();
        List<SelectOption> list8 = phc.getApplications();
        phc.gotonew();
        phc.previous();
        phc.next();
        phc.doSort();
        //List<Project__c> list3 = phc.GetSearchResults();
    }
}