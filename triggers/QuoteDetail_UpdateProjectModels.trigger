trigger QuoteDetail_UpdateProjectModels on Quote_Detail__c (after delete, after insert, after update) {
    
    /*
    trigger purpose
        updates models list on the project when a quote detail is updated; this only works on 1-offs -- would need serious thought to make this bulk safe
    */
      /*** Added By Satish ---Ticket#393---  ****/
    if(trigger.isAfter && (Trigger.isInsert||Trigger.isUpdate)){
        Set<ID> setQuoteId = new Set<ID>();
        for(Quote_Detail__c qDetail :trigger.new){
            if(trigger.isInsert && (qDetail.model__c =='CERO' || qDetail.model__c =='CERO2' || qDetail.model__c =='CERO3')){
                setQuoteId.add(qDetail.Quote__c);
            }
            if(trigger.isUpdate &&  qDetail.model__c =='CERO' && (trigger.oldMap.get(qDetail.Id).model__c != qDetail.model__c)){
                system.debug('HereINQuote');
                setQuoteId.add(qDetail.Quote__c);
            }
        }
        if(setQuoteId.size()>0){
            ProjectHelper.projCeroCheck(setQuoteId);
            OpportunityHelper.UpdateCEROCheck(setQuoteId);
        }   
    }
     /*** Added By Satish ---Ticket#393----  ****/
    
    string line='1';
try{
     if(Trigger.isInsert && trigger.isAfter)
     {        
         set<id> quoteid = new set<id>();
        for(Quote_Detail__c qd: trigger.new)
        {
            quoteid.add(qd.Quote__c);
        }       
                if(quoteid.size()>0)
                {
                    OpportunityHelper.UpdateDiscountOnQuote(quoteid);
                }
      }
        
        if(Trigger.isUpdate && trigger.isAfter)
        {
            set<id> quoteid = new set<id>();           
            for(Quote_Detail__c qd: trigger.new)
            {
              if((trigger.oldmap.get(qd.id).Discount__c!=qd.Discount__c) && (trigger.oldmap.get(qd.id).Price__c!=qd.Price__c))
               {
                     quoteid.add(qd.Quote__c);
                }
            }
                
                if(quoteid.size()>0)
                {
                    OpportunityHelper.UpdateDiscountOnQuote(quoteid);
                }
        }
        
        if(Trigger.isdelete && trigger.isAfter)
       {
        set<id> quoteid = new set<id>();
        for(Quote_Detail__c qd: trigger.old)
        {
            quoteid.add(qd.Quote__c);
        }       
                if(quoteid.size()>0)
                {
                    OpportunityHelper.UpdateDiscountOnQuote(quoteid);
                }
        }
    
    if  ( (trigger.isInsert && trigger.new.size()==1) || (trigger.isDelete && trigger.old.size()==1))
    {
        line='1a';
        Quote_detail__c qd = null;
        if (trigger.isInsert)
        {
            qd = trigger.new[0]; 
        }
        else
        {
            qd=trigger.old[0];
        }
        Quote__c q1 = [select opportunity__c from quote__c where id =: qd.quote__c];
         line='2';
        List<Quote__C> quotes = new List<Quote__C>([select id,(select id,model__c from quote_details__r) from quote__c where opportunity__c =: q1.opportunity__c]);
        string models='';
        line='3';
        for (Quote__c q : quotes)
        {       
            for (Quote_detail__c qd3:q.quote_details__r)
            {  
                if (!models.contains(qd3.model__c))
                {
                     models = models + qd3.model__c + ';';
                }
            }
        } 
        Opportunity o = [select id from opportunity where id =:q1.opportunity__C];
        o.models__c = models;
        update(o);
    }
}
catch (Exception ex)
{
    Utility.JimDebug(ex, 'insert qd model update line ' + line);
}


}