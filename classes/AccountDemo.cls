public class AccountDemo
    
{
    public list<project__C> AllProjectData {get;set;}
    public list<opportunityContactRole> ContactRole{get;set;}  
    public list<Projectwrapper> WrapperCombineAllData {get;set;}
    public id  AccId {get;set;}
    public Map<id,list<opportunityContactRole>> uniqueData {get;set;}
    
    
    public AccountDemo()
    {
        
    }
    
    
        public AccountDemo(ApexPages.StandardController con)
    
        {
            AllProjectData =new list<project__C>();
            contactRole = new list<opportunityContactRole>();
            WrapperCombineAllData = new list<Projectwrapper>();
             AccId = '001A0000006nCrj'; 
       
            CombineData();
              Map<id,opportunityContactRole> uniqueData =new Map<id,opportunityContactRole>(contactRole);
            	system.debug('The Size of the map is'+uniqueData.size());
            
            
        }     
    
    public void combineData()
    {
        
        // Fire Query on Project Object and get all related data except contact Role
              String query1 ='SELECT Id,(Select Id,Name,CreatedDate, Order_Finalized_Date__c From Orders__r), Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,';
               query1+='Architect_Account__c,Ordering_Account__c, Brand_Name_Account__c, End_Customer_Account__c,End_Customer_Account__r.Name, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c ';
               query1+=' FROM  Project__C ' ;
                   //Project__c WHERE (Architect_Account__c = :AccId OR Brand_Name_Account__c = :AccId OR End_Customer_Account__c = :AccId '; 
              //    WHERE (Architect_Account__c = :AccId OR Brand_Name_Account__c = :AccId OR End_Customer_Account__c = :AccId ';
              // query1+=' OR Franchise_Account__c = :AccId OR Franchisor_Account__c = :AccId OR Other_Influencer_Account__c = :AccId '; 
              // query1+=' OR Purchaser_Account__c =:AccId OR Ordering_Account__c =:AccId ) ';
         
         
 AllProjectData = database.query(query1);    
        /*    String query2 =' select opportunity.project_name__c,opportunity.name,contact.name from opportunityContactrole  where ';
             		query2+=' OpportunityContactRole.opportunity.project_name__r.Ordering_Account__c =:AccId OR  ';
            	    query2+=' OpportunityContactRole.opportunity.project_name__r.Architect_Account__c =:AccId OR ';
             		query2+=' OpportunityContactRole.opportunity.project_name__r.Brand_Name_Account__c =:AccId OR ';
             		query2+=' OpportunityContactRole.opportunity.project_name__r.End_Customer_Account__c =:AccId OR';
             	    query2+=' OpportunityContactRole.opportunity.project_name__r.Franchise_Account__c =:AccId OR ';
            		query2+=' OpportunityContactRole.opportunity.project_name__r.Franchisor_Account__c=:AccId  OR ';
             		query2+=' OpportunityContactRole.opportunity.project_name__r.Other_Influencer_Account__c=:AccId OR ';
            		query2+=' OpportunityContactRole.opportunity.project_name__r.Purchaser_Account__c=:AccId '; */
        
            
//             ContactRole =database.query(query2);
        
     
// system.debug('The Size of the map is'+uniqueData.size());        
        
      
        
        
    }
    
    
     public class Projectwrapper
    {
        
        public project__c pr{get;set;}
        public opportunityContactRole opp1{get;set;}
        public Projectwrapper(project__C GP ,opportunityContactRole opp)
        {
            pr = GP;
            opp1 =opp;
        }
        
    }

}