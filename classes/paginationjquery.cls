public with sharing class paginationjquery {
    public list<opportunity> acc{get;set;}
    public list<opportunity> FinalList{get;set;}
    public list< String > FinalList1{get;set;}
    
    public id AccId{get;set;}
    public paginationjquery() {
        acc=new list<opportunity>();
        FinalList=new list<opportunity>();
        AccId = '001A000000qW3Cd';
        onLoad();
    }
    public void onLoad(){  //This function get called automatically on on load
 		
        String query1 ='select opportunity.name,opportunity.project_name__r.name, opportunity.project_name__r.amount__c,opportunity.project_name__r.Stage__c,';
               query1+='opportunity.project_name__r.id, opportunity.project_name__r.Architect_Account__c,opportunity.project_name__r.End_Customer_Account__c,';
               query1+='opportunity.project_name__r.Purchaser_Account__c ,opportunity.project_name__r.Franchise_Account__c,opportunity.project_name__r.Franchisor_Account__c,opportunity.project_name__r.Other_Influencer_Account__c,';
               query1+='opportunity.project_name__r.Project_City__c,opportunity.project_name__r.Project_State__c,opportunity.project_name__r.Project_Zip_Code__c,opportunity.project_name__r.CreatedDate,opportunity.project_name__r.Application__c,';
               query1+='(select contact.name from OpportunityContactRoles),(Select Id,Name,CreatedDate, Order_Finalized_Date__c From Orders) from opportunity';
               query1+=' where opportunity.project_name__r.Architect_Account__c=:AccId OR opportunity.project_name__r.Brand_Name_Account__c=:AccId OR opportunity.project_name__r.End_Customer_Account__c=:AccId OR opportunity.project_name__r.Purchaser_Account__c=:AccId  '; 
              query1+='OR opportunity.project_name__r.Ordering_Account__c=:AccId OR opportunity.project_name__r.Franchisor_Account__c=:AccId ';
              query1+='OR opportunity.project_name__r.Franchise_Account__c=:AccId OR opportunity.project_name__r.Other_Influencer_Account__c=:AccId ';
        
        		acc=database.query(query1);
        		system.debug('the Value of ACC'+acc);	
        
        Set< String > OppyName = new Set< String >();
        for( Opportunity op : Acc ){
            if( Acc.size() != null){
            	OppyName.add(op.project_name__r.Name);
            }
        }
        System.debug('Size of set ::: '+OppyName.size());
        System.debug(OppyName);
        FinalList1=new list< String >(OppyName);
        
           		List<opportunity> result = new List<opportunity>();
         	//	myset.add(acc);
       	//		FinalList.addAll(myset);
          // 		system.debug('The Value of Final List'+FinalList);
 
 
    }
}