public class Apex_demo {
    public List<Project__c> ProjSiteList{get;set;}
    private final Account objAccId;
    private Id accId{get;set;}
 //   public string objAccId{get;set;}
public Apex_demo(ApexPages.StandardController con)
{
   ProjSiteList = new List<Project__c>();
   this.objAccId = (Account)con.getRecord();
   accId = objAccId.Id; 
 // objAccId=ApexPages.currentPage().getParameters().get('id'); 
}
    public void Queryresult()
    {
        String query1 ='SELECT Id,(Select Id,Name,CreatedDate, Order_Finalized_Date__c From Orders__r), Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,';
               query1+='Architect_Account__c,Ordering_Account__c, Brand_Name_Account__c, End_Customer_Account__c,End_Customer_Account__r.Name, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c, ';
               query1+='(Select Id, Name, AccountId,Project_Name__c,Project_Name__r.Ordering_Account__c from Opportunities__r where (StageName like \'%Won%\' OR StageName like \'%Complete%\' OR StageName like \'%Paid%\') AND (NOT StageName LIKE \'%Influencer%\')AND (Project_Name__r.Ordering_Account__c!=Null))';
               query1+=' FROM Project__c WHERE End_Customer_Account__c =:'+ApexPages.currentPage().getParameters().get('id');
               
        
         ProjSiteList = database.query(query1);
    }
}