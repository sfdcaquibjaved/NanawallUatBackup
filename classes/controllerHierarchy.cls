public class controllerHierarchy 
{
    public account objAcc{get;set;} //to strore parent id
    public list<account> acclist {get;set;} //to store accountinfo
    list<project__c> PrjectSiteList {get;set;} // store project information
    
    
    public controllerHierarchy(apexpages.StandardController con)
    {
       objAcc= (account)con.getRecord();
        Projectinformation ();
        
    }
    
    
    public void Projectinformation ()
    {
        
                        
                 accList = [select id, name from account where parent.id = : objAcc.id];
                 PrjectSiteList = [SELECT Id, Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Bid_Date__c, Close_Date__c,
                       Architect_Account__c,Ordering_Account__c, (Select Id,Name,CreatedDate, Order_Finalized_Date__c From Orders__r) ,Brand_Name_Account__c, End_Customer_Account__c, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c
                       FROM Project__c
                       WHERE (Architect_Account__c = :objAcc.Id OR Brand_Name_Account__c = :objAcc.Id OR End_Customer_Account__c = :objAcc.Id 
                       OR Franchise_Account__c = :objAcc.Id OR Franchisor_Account__c = :objAcc.Id OR Other_Influencer_Account__c = :objAcc.Id 
                       OR Purchaser_Account__c =:objAcc.Id OR Ordering_Account__c =:objAcc.Id) AND (Stage__c!='Duplicate') ORDER BY Close_Date__c DESC];
  
                
        
                
     }
    
        
}