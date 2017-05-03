public class ashokHierarchyControll 
{
       //this list collects project count site counts to display on visualforce page
       public list<project__c> ProjSiteList{get;set;}
       // this list to count all sites to display on visualforce page  
       public list <account> AccSiteList{get;set;} 
       public Account ObjAcc{get;set;} 
    // Constructor for the class
     public ashokHierarchyControll(ApexPages.StandardController con)
    
    {
        objAcc = (Account)con.getRecord();
        ProjSiteList = new List<Project__c>();
        AccSiteList = new List<Account>();
        
        // list contains site count which dislpay on visualforce page 
        ProjSiteList = [SELECT Id, Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, 
                        RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, 
                        Project_Zip_Code__c, Bid_Date__c, Close_Date__c,Architect_Account__c,Ordering_Account__c, Brand_Name_Account__c, 
                        End_Customer_Account__c, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c
                        FROM Project__c
                       WHERE (Architect_Account__c = :objAcc.Id OR Brand_Name_Account__c = :objAcc.Id OR End_Customer_Account__c = :objAcc.Id 
                       OR Franchise_Account__c = :objAcc.Id OR Franchisor_Account__c = :objAcc.Id OR Other_Influencer_Account__c = :objAcc.Id 
                       OR Purchaser_Account__c =:objAcc.Id OR Ordering_Account__c =:objAcc.Id) AND (Stage__c!='Duplicate')];
                       
         //list contains all site count under the parent account              
        AccSiteList = [Select Name, Id, Type, (Select Name,CreatedDate,Architect_Account__r.Name, Ordering_Account__c,
                                                       Ordering_Account__r.Name, Amount__c,Application__c,RecordType.Name,
                                                       Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,Id,
                                                       Architect_Account__c, Purchaser_Account__c, 
                                                       Purchaser_Account__r.Name from Projects1__r ) from Account 
                                                       where Parent.Id = :string.valueOf(ObjAcc.Id).left(15)];
                       
        
               
     }
}