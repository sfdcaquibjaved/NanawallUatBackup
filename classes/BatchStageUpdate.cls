global class BatchStageUpdate implements Database.Batchable<sObject> {
       String Query;
       // for testing purpose only
       /* String[] filters = new String[]{'Closed Won - Order Signed','Closed Won - Order In Process','Closed Complete - Ordered - Paid',
       'Closed Lost - Project Lost','Closed Lost - Project Cancelled','Closed - Inactivity','Order - Negotiation'};*/
    global Database.querylocator start(Database.BatchableContext BC) {
        list<String> filters =new list<String>{'a1sA00000038ndHIAQ','a1sn0000001v782AAA','a1sn0000001v7Am'};
        Query = 'SELECT id FROM Project__c where id IN:filters';
        system.debug('Value of Query' + Query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, list <project__c> pro) {
         
          System.debug('The list is:'+pro);
          
          map<project__c,list<opportunity>> map2 = new map<project__c,list<opportunity>>();
          map<opportunity,list<quote__c>> map1 = new map<opportunity,list<quote__c>>();
        
        //Case: Projects without any opportunities or quotes  
          
          list<project__c> noppproj = new list<project__c>();
          list<opportunity> testlist = [select project_name__c from opportunity where project_name__c in: pro];
          set<ID> projectIDset = new set<ID>();
        
          for(Opportunity opp : testlist) {
		   projectIDset.add(opp.project_name__c);             
          }
         
          System.debug('from list'+projectIDset);
         
          noppproj = [select id,stage__c from project__c where id in: pro and id not in: projectIDset];
         
          System.debug(noppproj);
         
          list<project__c> onlyprojects = new list<project__c>();
          if(noppproj.isEmpty() == false){
               onlyprojects = BatchStageUpdateHelper.projectswithoutopp(noppproj);
          }  
          
         System.debug('only projects'+ onlyprojects);
          
        //Case:For projects having closed opportunities and random quote stages
          
        list<opportunity> allopp = [select id, project_name__c,stagename,quote_count__c,account.type, Budget_quote__c,recordtype.name,Preliminary_Drawlings__c,preliminary_drawings_date__c from opportunity where project_name__c in: pro ];
        list<quote__c> quolist = [select id, project__c, opportunity__c,stage__c,printed__c, viewed__c from quote__c where project__c in: pro and opportunity__c in: allopp];
                    
        System.debug('opportunity'+allopp.size());
        System.debug('quotes'+quolist);
          
        list<quote__c> updatedquotelist = new list<quote__c>();
        // Updating stages of all quotes  
         
        updatedquotelist = BatchStageUpdateHelper.updatequotestages(quolist);
        
        System.debug('updation'+updatedquotelist);
        
        // Map of opportunity with quotes
        
          for(opportunity ot: allopp){
           list<quote__c> upquote = new list<quote__c>();
              for(quote__c qo:updatedquotelist){
                  if(ot.id == qo.opportunity__c) {
                      upquote.add(qo);
                 System.debug('missing quotes'+ upquote);           
                 }
              }
              map1.put(ot,upquote);
            }
        for(opportunity k:map1.keyset()){
         System.debug('this is key'+ k);
         System.debug('this is value'+ map1.get(k));
        }
        
        map<opportunity,quote__c> opportunitystages = new map<opportunity,quote__c>();
        // Updating all opportunities
        
        opportunitystages = BatchStageUpdateHelper.greatestopportunitystage(map1);
        
        list<opportunity> updatedopportunitylist = new list<opportunity>();
        
        updatedopportunitylist = BatchStageUpdateHelper.updateopportunitylist(opportunitystages);
        
        //Map of project with opportunities
        
        list<project__c> finallist = [select id,stage__c, award_date__c,bid_date__c from project__c where id in: pro and id not in: noppproj];
        System.debug('finallist'+finallist);
        for(project__c pr: finallist){
        list<opportunity> projectopps = new list<opportunity>();
            for(opportunity o: updatedopportunitylist){
                if(o.project_name__c == pr.id){
                    projectopps.add(o);
                }
            }
            map2.put(pr,projectopps);
        }
        for(project__c k:map2.keyset()){
         System.debug('this is key'+ k);
         System.debug('this is value'+ map2.get(k));
        }
        
        //Updating all projects with opportunities
        
        list<project__c> updatedprojectlist = new list<project__c>();
        
        map<project__c,opportunity>  projectstagesmap = new map<project__c,opportunity>();
        
        projectstagesmap = BatchStageUpdateHelper.greatestprojectstage(map2);
        
        for(project__c p:projectstagesmap.keyset()){
            System.debug('this is pr key'+p.id);
            System.debug('this is or value'+projectstagesmap.get(p));
        }

        updatedprojectlist = BatchStageUpdateHelper.updateprojectlist(projectstagesmap);
        
        System.debug('updated projects'+ updatedprojectlist);                                
    }
    
        global void finish(Database.BatchableContext BC) {

    }
}