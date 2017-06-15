public with sharing class paginationjquery {
    public list<opportunity> acc{get;set;}
    public list<opportunity> FinalList{get;set;}
    public list< opportunity > OCR{get;set;}
    public map<id, opportunity> oppdata{get;set;}
   // public list<project__c> ProjectDate{get;set;}
    public id AccId{get;set;}
    public paginationjquery() {
        acc=new list<opportunity>();
        FinalList=new list<opportunity>();
        AccId = '001A000000sKyXx';
        oppdata  =new map<id, opportunity>();
     //   ProjectDate =new list<project__C>();
         OCR = new list<opportunity>();
        
        onLoad();
    }
    public void onLoad()
    {  //This function get called automatically on on load
       //               ProjectDate =[select id from project__C where Architect_Account__c=:AccId OR  Brand_Name_Account__c=:AccId OR End_Customer_Account__c=:AccId];
       String query1 ='select name,(Select CreatedDate, Order_Finalized_Date__c From Orders order by Order_Finalized_Date__c ) ,(select contact.name from OpportunityContactRoles ), opportunity.project_name__r.name, opportunity.project_name__r.amount__c,opportunity.project_name__r.Stage__c,';
               query1+='opportunity.project_name__r.id, opportunity.project_name__r.Architect_Account__c,opportunity.project_name__r.End_Customer_Account__c,';
               query1+='opportunity.project_name__r.Purchaser_Account__c ,opportunity.project_name__r.Franchise_Account__c,opportunity.project_name__r.Franchisor_Account__c,opportunity.project_name__r.Other_Influencer_Account__c,';
               query1+='opportunity.project_name__r.Project_City__c,opportunity.project_name__r.Project_State__c,opportunity.project_name__r.Project_Zip_Code__c,opportunity.project_name__r.CreatedDate,opportunity.project_name__r.Application__c';
               query1+=' from opportunity';
               query1+=' where opportunity.project_name__r.Architect_Account__c=:AccId OR opportunity.project_name__r.Brand_Name_Account__c=:AccId OR opportunity.project_name__r.End_Customer_Account__c=:AccId OR opportunity.project_name__r.Purchaser_Account__c=:AccId  '; 
              query1+='OR opportunity.project_name__r.Ordering_Account__c=:AccId OR opportunity.project_name__r.Franchisor_Account__c=:AccId ';
              query1+='OR opportunity.project_name__r.Franchise_Account__c=:AccId OR opportunity.project_name__r.Other_Influencer_Account__c=:AccId  ';
         
       string query2='select (Select CreatedDate, Order_Finalized_Date__c From Orders order by Order_Finalized_Date__c ) from opportunity   where opportunity.project_name__r.Architect_Account__c=:AccId OR opportunity.project_name__r.Brand_Name_Account__c=:AccId OR opportunity.project_name__r.End_Customer_Account__c=:AccId OR opportunity.project_name__r.Purchaser_Account__c=:AccId OR opportunity.project_name__r.Ordering_Account__c=:AccId OR opportunity.project_name__r.Franchisor_Account__c=:AccId OR opportunity.project_name__r.Franchise_Account__c=:AccId OR opportunity.project_name__r.Other_Influencer_Account__c=:AccId';
          OCR =database.query(query2);
                acc=database.query(query1); 
                system.debug('the Value of ACC'+  acc.size());
                Map<id,opportunity> aMap=new Map<id,opportunity>();
                acc.sort();
            for(opportunity a:acc)
                {
                        system.debug('the Value of Original List'  + a);
                    aMap.put(a.project_name__r.id, a);
                       
                    system.debug('the Value of Original List'  + aMap);
                    
       FinalList=aMap.values();
       
     //   system.debug('the value of FinalList is' + FinalList.size());
      //  system.debug('the value of FinalList is' +   FinalList);
 
    }
    } }