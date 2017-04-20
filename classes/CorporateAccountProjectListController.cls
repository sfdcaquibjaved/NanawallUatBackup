public with sharing class CorporateAccountProjectListController
{
    public ApexPages.StandardController stdCon;
    public Account objAcc {get; set;}
    public class ProjectContainer {
        public string relType {get; set;}
        public Project__c proj {get; set;}
    }
    public List<ProjectContainer> lstProject {get; set;}
     @TestVisible private List<Project__c> lstProj {get; set;}
    public Integer intProjectWon {get; set;}
    public Double dblAmountTotal {get; set;}
    public Double dblAmountWon {get; set;}
    public List<Account> lstAccount {get; set;}
    public Boolean showPenetration {get; set;}
    public String ValueOfObjId {get; set;}
    transient List <Account> architects {get; set;}  
    transient Map <Account,Integer> archCnt {get;set;} 
    transient List <Account> contractors {get; set;}  
    transient Map <Account,Integer> contCnt {get;set;} 
    public String str {get;set;}
    public String str2 {get;set;}
   
    
    
    public CorporateAccountProjectListController(ApexPages.StandardController controller)
    {
        stdCon = controller;
        objAcc = (Account) stdCon.getRecord();
        
        showPenetration = false;
        lstAccount = new List<Account>();
        lstProject = new List<ProjectContainer>();
        lstProj = new List<Project__c>();
        dblAmountTotal = dblAmountWon = 0;
        intProjectWon = 0;
        architects = new List<Account>();
        contractors = new List<Account>();
        Integer cnt =0;
        Integer prevcnt=0;
        archCnt = new Map <Account,Integer>();
        contCnt = new Map <Account,Integer>();
        str='';
        str2='';
        
        
        if(objAcc.Id != null)
        {
            
            lstAccount = [SELECT Id,parentID, Name FROM Account WHERE (Ultimate_ParentId__c = :string.valueOf(objAcc.Id).left(15) OR Parent.Id = :string.valueOf(objAcc.Id).left(15)) AND id !=:string.valueOf(objAcc.Id).left(15)];
            
            
            architects = [SELECT Id, Name FROM Account WHERE Type='Architecture Firm'];
            
            contractors = [SELECT Id, Name FROM Account WHERE Type='General Contractor' OR Type='Glazing Contractor'];
            
            //ValueOfObjId = string.valueOf(objAcc.Id).left(15);
            
            lstProj = [SELECT Id, Name, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Bid_Date__c, Close_Date__c,
                       Architect_Account__c, Brand_Name_Account__c, End_Customer_Account__c, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c
                       FROM Project__c
                       WHERE ( Architect_Account__c = :objAcc.Id OR Brand_Name_Account__c = :objAcc.Id OR End_Customer_Account__c = :objAcc.Id 
                       OR Franchise_Account__c = :objAcc.Id OR Franchisor_Account__c = :objAcc.Id OR Other_Influencer_Account__c = :objAcc.Id 
                       OR Purchaser_Account__c =:objAcc.Id ) AND (Stage__c!='Duplicate') ORDER BY Close_Date__c DESC];
                       
            
            for (Project__c proj : lstProj) {
                ProjectContainer pc = new ProjectContainer();
                pc.proj = proj;
                if (proj.Architect_Account__c == objAcc.Id)
                { 
                    pc.relType = 'Architect Account';
                }
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
           
          
            for (Account arch : architects) {
            for (Project__c proj : lstProj) {
                
                 if(proj.Architect_Account__c!=null)
                 if(proj.Architect_Account__c == arch.id){cnt++;}
            }
            if(cnt!=0){
                archCnt.put(arch,cnt);
                if(prevcnt>cnt)
                str = str +' '+ arch.Name + ' (' + cnt + '); ';
                else
                str = ' '+ arch.Name + ' (' + cnt + '); '+ str;
                If(prevcnt<cnt)
                prevcnt=cnt;
            }
                
                cnt=0;           
          }
          
          prevcnt=0;
          
           for (Account cont : contractors) {
           for (Project__c proj : lstProj) { 
                
               if(proj.Purchaser_Account__c!=null)
               if(proj.Purchaser_Account__c == cont.id){cnt++;}
           }
           
               if(cnt!=0)
               {
                 contCnt.put(cont,cnt);
                 if(prevcnt>cnt)
                 str2 = str2 +' '+ cont.Name + ' (' + cnt + '); ';
                 else
                 str2 = ' '+ cont.Name + ' (' + cnt + '); '+ str2;
                 If(prevcnt<cnt)
                 prevcnt=cnt; 
               }
               cnt=0;
         }
            
       }
   }
}