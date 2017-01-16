public with sharing class Project_In2CloudsScore {


    private final Opportunity o;
    public Project_In2CloudsScore(ApexPages.StandardController stdController) {
        this.o = (Opportunity)stdController.getRecord();
    }

	

}