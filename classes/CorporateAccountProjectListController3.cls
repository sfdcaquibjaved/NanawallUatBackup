public class CorporateAccountProjectListController3 {
public ApexPages.StandardController stdCon;
    public Account objAcc {get; set;}
    public class ProjectContainer {
        public string relType {get; set;}
        public Project__c proj {get; set;}
    }
    public List<ProjectContainer> lstProject {get; set;}
    private List<Project__c> lstProj {get; set;}
    private List<Project__c> lstProj1 {get; set;}
    public Integer intProjectWon {get; set;}
    public Double dblAmountTotal {get; set;}
    public Double dblAmountWon {get; set;}
    public List<Account> lstAccount {get; set;}
    public Boolean showPenetration {get; set;}
    public String ValueOfObjId {get; set;}
    
    public CorporateAccountProjectListController3(ApexPages.StandardController controller)
    {
        stdCon = controller;
        objAcc = (Account) stdCon.getRecord();
        
        showPenetration = false;
        lstAccount = new List<Account>();
        lstProject = new List<ProjectContainer>();
        lstProj = new List<Project__c>();
        lstProj1 = new List<Project__c>();
        dblAmountTotal = dblAmountWon = 0;
        intProjectWon = 0;
        
        if(objAcc.Id != null)
        {
            
            lstAccount = [SELECT Id,Name FROM Account WHERE Ultimate_ParentId__c = :string.valueOf(objAcc.Id).left(15) OR Parent.Id = :string.valueOf(objAcc.Id).left(15)];
            system.debug('lstAccount -> ' + lstAccount);
            
            ValueOfObjId = string.valueOf(objAcc.Id).left(15);
            
            lstProj = [SELECT Id, Name, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Bid_Date__c, Close_Date__c,
                       Architect_Account__c,Architect_Contact__c, Brand_Name_Account__c,End_Customer_Account__c, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c
                       FROM Project__c
                       WHERE (Brand_Name_Account__c = :objAcc.Id OR Franchise_Account__c= :objAcc.Id  OR  End_Customer_Account__c= :objAcc.Id  OR Other_Influencer_Account__c =: objAcc.Id OR
                       Franchisor_Account__c =:objAcc.Id)  AND Architect_Account__c != null];
            lstProj1 =[SELECT Id, Name, RecordType.Name ,Architect_Account__c,Architect_Contact__c FROM	Project__c where Architect_Account__c = :objAcc.Id ];
            for (Project__c proj : lstProj) {
                ProjectContainer pc = new ProjectContainer();
                pc.proj = proj;
                if (proj.Architect_Account__c == objAcc.Id) pc.relType = 'Architect Account';
                else if (proj.Brand_Name_Account__c == objAcc.Id) pc.relType = 'Brand Name Account';
                else if (proj.End_Customer_Account__c == objAcc.Id) pc.relType = 'End Customer Account';
                else if (proj.Franchise_Account__c == objAcc.Id) 
                {
                    pc.relType = 'Franchisee Account';
                    showPenetration = true;
                }
                else if (proj.Franchisor_Account__c == objAcc.Id) 
                {
                    pc.relType = 'Franchisor Account';
                    showPenetration = true;
                }
                else if (proj.Other_Influencer_Account__c == objAcc.Id) pc.relType = 'Other Influencer Account';
                else if (proj.Purchaser_Account__c == objAcc.Id) pc.relType = 'Purchaser Account';
                lstProject.add(pc);
                if (proj.Amount__c != null) dblAmountTotal = dblAmountTotal + proj.Amount__c;
                if (proj.Stage__c != null && (proj.Stage__c.contains('Closed Won') || proj.Stage__c.contains('Closed Complete')))
                {
                    intProjectWon = intProjectWon + 1;
                    dblAmountWon = dblAmountWon + proj.Amount__c;
                }
            }
            
        }
        
    }


}