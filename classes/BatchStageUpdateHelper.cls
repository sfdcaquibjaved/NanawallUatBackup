public class BatchStageUpdateHelper {
    
  public static list<project__c> projectswithoutopp(list<project__c> var){
        list<project__c> justprojects = new list<project__c>();
        for(project__c v: var){   
        if(v.stage__c != 'Prospecting'){
            v.stage__c = 'Prospecting';
            justprojects.add(v);
           }
            
        }
        update justprojects;   
        return justprojects;
            
    }
    
   public static list<quote__c> updatequotestages(list<quote__c> quolist)
    {
     list<quote__c> updatedquote = new list<quote__c>();   
     set<id> successquote = new set<id>();
        for(quote__c qq: quolist){ 
           if(qq.printed__c == true && qq.viewed__c == true ){
                    qq.stage__c ='Presented/Viewed';
                    updatedquote.add(qq);
            }else
           if(qq.printed__c == true && qq.viewed__c != true ){
                    qq.stage__c ='Presented';
                    updatedquote.add(qq);
            }
            else{
                 qq.stage__c = 'Open';
                 updatedquote.add(qq);
            }
      
         }
        Database.SaveResult[] srList = Database.update(updatedquote, false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully updated Quote. Quote ID: ' + sr.getId());
        successquote.add(sr.getId());
    }
            else{
              for(Database.Error err : sr.getErrors()) {
                 System.debug('error files'+err.getMessage());
                 System.debug('error due to'+ err.getFields());
              }
            }
        }
        for(quote__c q:updatedquote){
            system.debug('updated stage'+ q.stage__c);
        }
       list<quote__c> updatedquotelist = [select id,stage__c,opportunity__c from quote__c where id in:successquote];
        return updatedquotelist;
    }
    
   public static map<opportunity,quote__c> greatestopportunitystage (map<opportunity,list<quote__c>> map1){
        map<opportunity,quote__c> opportunitystagemap = new map<opportunity,quote__c>();
        map < String, Integer > mapStageInt2 = new map < String, Integer > ();
        Integer i = 1 ;     
        Schema.DescribeFieldResult f = Schema.sObjectType.Quote__c.fields.Stage__c;
        
        for (Schema.Picklistentry entry: f.getPicklistValues()) {
            mapStageInt2.put(entry.getValue(), i);
            i++;
        }
        
       System.debug('---map of Quo Stages--' + mapStageInt2);
       Integer j;
        for(string s: mapStageInt2.keyset()){
            j = mapStageInt2.get(s);
            if(j>3){
            mapStageInt2.remove(s);
            }
        }
      System.debug('--- modified map of Quo Stages--' + mapStageInt2);     
        List < opportunity > updateOppList = new List < opportunity > ();
        
        System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        //Loop over Opportunity
        for (opportunity op: map1.keyset()) {
            Integer max = 0;
            list<quote__C> values = new list<quote__C>();
            values = map1.get(op);
            if (values.isEmpty() == false){
            for (quote__c quo: map1.get(op)) {
                    System.debug('*****Stage--Opp***' + quo.Stage__c);
                    if (mapStageInt2.containsKey(quo.Stage__c) && mapStageInt2.get(quo.Stage__c) > max) {
                    max = mapStageInt2.get(quo.Stage__c);
                    opportunityStageMap.put(op, quo);
                    
                }
            }
            }
            else{
                opportunityStageMap.put(op,null);
            }
        }
       for(opportunity o : opportunityStagemap.keyset()){
        System.debug('this is keystage'+o.id);
        System.debug('this is valuestage'+opportunityStagemap.get(o));
       }
        return opportunityStagemap;
      }
    
      public static list<opportunity> updateopportunitylist(map<opportunity,quote__c> opportunitymap){
        list<opportunity> newlist = new list<opportunity>();
        set<id> successopp = new set<id>();
        Quote__c largeststage = new Quote__c();

        for(opportunity oo: opportunitymap.keyset()){
              largeststage = opportunitymap.get(oo);
            if(largeststage == null){
                oo.stagename = 'Need Analysis';
                newlist.add(oo);
            }else
              //System.debug(largeststage.stage__c);
            if(oo.budget_quote__c == true || (oo.account.type == 'Architecture Firm' || oo.account.type == 'Interior Designer' || oo.account.type == 'Cost Consulting Firm')){
                if(oo.preliminary_drawlings__c == true && oo.preliminary_drawings_date__c != null){
                           oo.StageName = 'Drawings - Provided';
                           newlist.add(oo);
                }else
                if(oo.preliminary_drawlings__c == true){
                           oo.StageName = 'Drawings - Requested';
                           newlist.add(oo);
                }else
                if(oo.Budget_quote__c == true && oo.quote_count__c == 0){
                           oo.stageName = 'Budget Quote - Requested';
                           newlist.add(oo);
                }
                
                }
         
                else
                {    
                    
                if(oo.preliminary_drawlings__c == true && oo.preliminary_drawings_date__c != null){
                           oo.StageName = 'Drawings - Provided';
                           newlist.add(oo);
                }else
                if(oo.preliminary_drawlings__c == true){
                           oo.StageName = 'Drawings - Requested';
                           newlist.add(oo);
                }else
                if(oo.Budget_quote__c == true && oo.quote_count__c == 0){
                           oo.stageName = 'Budget Quote - Requested';
                           newlist.add(oo);
                
                }
                if(oo.Budget_quote__c == true && largeststage.stage__c == 'Open')
                {
                             oo.stageName = 'Budget quote - Provided';
                             newlist.add(oo);
                }else
                if(largeststage.stage__c == 'Presented'){
                             oo.stageName = 'Quote - Provided';
                             newlist.add(oo);
                }else
                if(largeststage.stage__c == 'Presented/Viewed'){
                             oo.stageName = 'Quote - Negotiation/review';
                             newlist.add(oo);
                }
                
                }
        
          }                    
        Database.SaveResult[] srList = Database.update(newlist, false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully updated Opportunity. Opportunity ID: ' + sr.getId());
        successopp.add(sr.getId());
    }
            else{
              for(Database.Error err : sr.getErrors()) {
                 System.debug('error files'+err.getMessage());
                 System.debug('error due to'+ err.getFields());
              }
            }
        }
        for(opportunity o:newlist){
            system.debug('updated stage'+ o.stageName);
        }
       list<opportunity> updatedopportunitylist = [select id,stageName,project_name__c,budget_quote__c from opportunity where id in:successopp];
        return updatedopportunitylist;
        
    }
    public static map<project__c,opportunity> greatestprojectstage (map<project__c,list<opportunity>> map2){
        map < String, Integer > mapStageInt = new map < String, Integer > ();
        Integer i = 1;        
        Schema.DescribeFieldResult f = Schema.sObjectType.Opportunity.fields.StageName;
        for (Schema.Picklistentry entry: f.getPicklistValues()) {
            mapStageInt.put(entry.getValue(), i);
            i++;
        }
       System.debug('---map of Opp Stages--' + mapStageInt);
       Integer j;
       for(string s: mapStageInt.keyset()){
            j = mapStageInt.get(s);
            if(j>8){
            mapStageInt.remove(s);
            }
        }
       System.debug('---modified map of Opp Stages--' + mapStageInt);
        List < Project__c > updateProjList = new List < Project__c > ();
        map < project__c, Opportunity > projectStageMap = new map < project__c, Opportunity > ();
        //Query over Project with Related Opportunities
        
        System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

        //Loop over Project
        for (Project__c prj: map2.keyset()) {
            Integer max = 0;
            for (Opportunity opp: map2.get(prj)) {
                    if (mapStageInt.containsKey(opp.StageName) && mapStageInt.get(opp.StageName) > max) {
                        max = mapStageInt.get(opp.StageName);
                        projectStageMap.put(prj, opp);
                    System.debug('opp'+opp);
                }
            }
        }
         return projectStageMap;
    }
    
    public static list<project__c> updateprojectlist(map<project__c,opportunity> projectmap){
        Opportunity largest = new opportunity();
        list<project__c> updatedvalues = new list<project__c>();
        for(project__c pp:projectmap.keyset()){
            largest = projectmap.get(pp);
             if(largest.stageName == 'Need Analysis'){
                        pp.stage__c = 'Considered';
                        updatedvalues.add(pp);
              }else
              if(largest.stageName == 'Drawings - Requested' || largest.stageName == 'Drawings - Provided'){
                        pp.stage__c = 'Design';
                        updatedvalues.add(pp);
              }
              else 
              if(largest.budget_quote__c == true && System.today() > pp.Bid_Date__c && System.today() < pp.award_date__C){
                    pp.stage__c = 'Bidding';
                    updatedvalues.add(pp);
              }
              else 
              if(largest.budget_quote__c == true && System.today() > pp.Bid_Date__c && System.today() > pp.award_date__C){
                    pp.stage__c = 'Awarded';
                    updatedvalues.add(pp);
              }
             
              else if(largest.stageName == 'Quote - Requested' || largest.stageName == 'Quote - Provided' || largest.stageName == 'Quote - Negotiation/Review'){
                pp.stage__c = 'Quoted';
                updatedvalues.add(pp);
              }
        }
              update updatedvalues;
              System.debug('Updated project stage'+ updatedvalues);
              return updatedvalues;
        
       }
    
 }