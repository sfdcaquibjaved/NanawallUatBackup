public class Apex_demo {
    Public List<Project__c> ProjSiteList{get;set;}
    Public Integer ChildAccountCount{get;set;}
    Public List<Account> accList{get;set;}
    Public List<order> orderRecentDate{get;set;}
    
    Public Integer PrjWonOrderPaid{get;set;}
    Public Integer PrjOrderProgress{get;set;}
    
    public Apex_demo(ApexPages.StandardController con)
    {
        ProjSiteList = new List<Project__c>();
        orderRecentDate = new List<order>();
        prjQuery(con.getId());
        ChildAccountCount = [Select count() from Account where ParentId =: con.getId()];
        
        PrjWonOrderPaid = 0;
        PrjOrderProgress = 0;
        SummarySection();
        }
   public void prjQuery(Id accId)
   {
      ProjSiteList =[Select name,(Select Order_Finalized_Date__c From Orders__r Order By Order_Finalized_Date__c),Stage__c,Amount__c from Project__c where Purchaser_Account__c =:accId]; 
      orderRecentDate = [Select Order_Finalized_Date__c From Order where project__r.Purchaser_Account__c=:accId AND Order_Finalized_Date__c!=NUll  Order By Order_Finalized_Date__c DESC Limit 1];
    
   }
   public void SummarySection()
   {
       for(Project__c projData : ProjSiteList)
       {
          if(projData.stage__c.contains('Closed Complete - Ordered - Paid') && projData.Stage__c != null )
          {
             PrjWonOrderPaid = PrjWonOrderPaid + 1;              
          }
          if(projData.Stage__c.contains('Closed Won - Order In Process') || projData.Stage__c.contains('Closed Won - Order Signed') || projData.Stage__c.contains('Order - Negotiation')|| projData.Stage__c.contains('Project On Hold'))
          {
              PrjOrderProgress = PrjOrderProgress + 1;
          }
       }
   }
}