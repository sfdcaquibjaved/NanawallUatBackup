public with sharing class paginationjquery {
    public list<opportunity> acc{get;set;}
    public list<opportunity> FinalList{get;set;}
    public map<list<opportunity>, id> oppdata{get;set;}
    public id AccId{get;set;}
    public paginationjquery() {
        acc=new list<opportunity>();
        FinalList=new list<opportunity>();
        AccId = '001A000000sKyXx';
        oppdata  =new map<list<opportunity>, id>();
        onLoad();
    }
    public void onLoad()
    {  //This function get called automatically on on load
             String query1 ='select (Select CreatedDate, Order_Finalized_Date__c From Orders order by Order_Finalized_Date__c ) ,(select contact.name from OpportunityContactRoles ), opportunity.project_name__r.name, opportunity.project_name__r.amount__c,opportunity.project_name__r.Stage__c,';
               query1+='opportunity.project_name__r.id, opportunity.project_name__r.Architect_Account__c,opportunity.project_name__r.End_Customer_Account__c,';
               query1+='opportunity.project_name__r.Purchaser_Account__c ,opportunity.project_name__r.Franchise_Account__c,opportunity.project_name__r.Franchisor_Account__c,opportunity.project_name__r.Other_Influencer_Account__c,';
               query1+='opportunity.project_name__r.Project_City__c,opportunity.project_name__r.Project_State__c,opportunity.project_name__r.Project_Zip_Code__c,opportunity.project_name__r.CreatedDate,opportunity.project_name__r.Application__c';
               query1+=' from opportunity';
               query1+=' where opportunity.project_name__r.Architect_Account__c=:AccId OR opportunity.project_name__r.Brand_Name_Account__c=:AccId OR opportunity.project_name__r.End_Customer_Account__c=:AccId OR opportunity.project_name__r.Purchaser_Account__c=:AccId  '; 
              query1+='OR opportunity.project_name__r.Ordering_Account__c=:AccId OR opportunity.project_name__r.Franchisor_Account__c=:AccId ';
              query1+='OR opportunity.project_name__r.Franchise_Account__c=:AccId OR opportunity.project_name__r.Other_Influencer_Account__c=:AccId  ';
                acc=database.query(query1); 
                system.debug('the Value of ACC'+  acc.size());
                Map<id,opportunity> aMap=new Map<id,opportunity>();
                for(opportunity a : acc)
                {
                        system.debug('the Value of OriginaList'  + a);
                       aMap.put(a.project_name__r.id, a);                 
                       system.debug('the Value of Original List'  + aMap);
                       
     
 
                }
                 FinalList=aMap.values();
    } 
    
    }