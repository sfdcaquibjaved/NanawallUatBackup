/*********************************************************************************************************************
Trigger Name: QuoteTrigger
Events: after insert,after update,before insert and before update
Description: This trigger is 
**********************************************************************************************************************/
trigger QuoteTrigger on Quote__c (after insert, after update, before insert, before update, after delete) {

if(Limits.getQueries()<50){
System.debug('I am here with limit' + Limits.getQueries());
    //Declaration of Collections and Variables
    Set<Id> oppIds = new Set<Id>();
    Set<Id> primaryOppIds = new Set<Id>();
    Set<Id> quoteIds = new Set<Id>();
    set<Id> stQuoteId = new set<Id>();
    Map<Id,String> oppQuoteStage = new Map<Id,String>();
    set<Id> OppIdForERD = new set<Id>();
    set<Id> OppIdForERDOrderNo = new set<Id>();
    id oppid;
    
    
    
    if (trigger.isBefore ){
        if(UtilityClass.runQuoteTrigger){
        for(Quote__c qt : Trigger.New){
        if(trigger.isInsert||(trigger.isupdate &&(((trigger.oldMap.get(qt.Id).Printed__c != qt.Printed__c) &&( qt.Printed__c == true) )||((trigger.oldMap.get(qt.Id).Viewed__c != qt.Viewed__c )&& (qt.Viewed__c==true) )))){
            if (qt.Printed__c == true ){
            qt.Stage__c = 'Presented' ;}
            if (qt.Viewed__c == true && qt.Printed__c == true ){
            qt.Stage__c = 'Presented/Viewed' ;}
        }
        }
        }
        for(quote__c qt : trigger.new){
          stQuoteId.add(qt.Opportunity__c);
        }
        if(!stQuoteId.isEmpty()){
        Map<Id,Opportunity> oppProjectMap = new Map<Id,Opportunity>([select ID,project_name__c from opportunity where ID IN : stQuoteId ]);
        if(oppProjectMap != null && !oppProjectMap.isEmpty()){
          for(quote__c qt : trigger.new){
            if(oppProjectMap.get(qt.Opportunity__c) != null)
              qt.Project__c = oppProjectMap.get(qt.Opportunity__c).project_name__c;
          }
        }
       
    } 
    } 
    
    /*** AFTER INSERT / AFTER UPDATE ***/
    if (trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate) ) {
        
        for(Quote__c qt : Trigger.New){
            if(trigger.isInsert ||(trigger.isupdate && (trigger.oldMap.get(qt.Id).Stage__c != qt.Stage__c) )){
             oppQuoteStage.put(qt.Opportunity__c,qt.Stage__c);
             //oppIds.add(qt.Opportunity__c);
             }
            /*** If a new non-primary Quote is created, then the quote SubTotal has to be averaged with other
             *** Quotes under the same Opportunity and the Opportunity amount has to be updated with this Quote
             *** average amount. Also at this point, ensure that Opportunity Stage = "Proposal/Price Quote" and
             *** the Project Status = "In Progress - Quote"
             ***/
            if(Trigger.isInsert && qt.SubTotal__c != null && qt.SubTotal__c != 0.00){
                
                  
                   oppIds.add(qt.Opportunity__c);
                }
                
                 /*if(Trigger.isUpdate && ((qt.Balanced_Received_Date__c!=null )&&((Trigger.oldMap.get(qt.id).Balanced_Received_Date__c!=(Trigger.newMap.get(qt.id).Balanced_Received_Date__c))))){
                //OpportunityHelper.checkdate(Trigger.New);
                }
                 if(Trigger.isUpdate && ((qt.Order_Finalized_Date__c!=null )&&((Trigger.oldMap.get(qt.id).Order_Finalized_Date__c!=(Trigger.newMap.get(qt.id).Order_Finalized_Date__c))))){
                //OpportunityHelper.checkdate2(Trigger.New);
                }
                //Opportunity opp=[select id, ManualChangeOfERD__c from Opportunity where id=:qt.Opportunity__c];*/
            if(Trigger.isInsert){
                OppIdForERD.add(qt.id);
            }
            if(Trigger.isUpdate && (trigger.oldMap.get(qt.Id).Order_Number__c != qt.Order_Number__c)){
                OppIdForERDOrderNo.add(qt.id);
            }
            
            if(Trigger.isUpdate && ((trigger.oldMap.get(qt.id).Discount__c!=qt.Discount__c) || (trigger.oldMap.get(qt.id).Primary_Quote__c!=qt.Primary_Quote__c) || (trigger.oldMap.get(qt.id).Average_Quote_Discount__c!=qt.Average_Quote_Discount__c)))
            {
                 OpportunityHelper.UpdateDiscountOnOpportunities(Trigger.New);   
            }
            
            
            if(Trigger.isInsert && ((qt.Discount__c!=NULL  && qt.Discount__c!=0) || (qt.Average_Quote_Discount__c!=NULL && qt.Average_Quote_Discount__c!=0)))
            {
                OpportunityHelper.UpdateDiscountOnOpportunities(Trigger.New);
            }
            
            
            /*** If a Quote SubTotal amount is updated and it is a non-primary quote, then we have to again
             *** average this new amount with other quotes under the same Opportunity and the Opportunity amount
             *** has to be updated with this Quote average amount.
             ***
             *** If a Quote is set as "Primary Quote" then the associated Opportunity amount has to be updated with the
             *** SUM of all Primary Quotes on an Opportunity. Ideally there should be only one Primary Quote on an
             *** Opportunity, but this solution is scalable to handle multiple Primary Quotes. Also at this point, the
             *** Opportunity Stage is auto-updated to "Negotiation/Review". Project Status remains as "In Progress - Quote".
             *** After 'Primary Quote' flag is set on Quote, Opportunity and Project Amount fields have to be recalculated.
             ***/
            if(Trigger.isUpdate && (qt.SubTotal__c != Trigger.oldMap.get(qt.Id).SubTotal__c || qt.Order_Number__c != Trigger.oldMap.get(qt.Id).Order_Number__c)){
            if(Trigger.isUpdate){
                oppIds.add(qt.Opportunity__c);
                oppQuoteStage.put(qt.Opportunity__c,qt.Stage__c);
            }            
            /*
            if(Trigger.isUpdate && qt.Primary_Quote__c == TRUE){
                primaryOppIds.add(qt.Opportunity__c);
            }
            */
        }
       
        }
        
         
       /*  for(Quote__c q: [select id, Createddate, Opportunity__c, Order_Number__c from Quote__c where id=: QuoteIds])
        {
        OppId=q.Opportunity__c;
            
        }
        for(Opportunity oppty: [select id, CloseDate, Quote_Count__c from Opportunity where id=:OppId])
        {
            if(oppty.Quote_Count__c==0)
            {*/
        if(OppIdForERD.size()>0 && trigger.IsInsert && trigger.IsAfter )
        {
        

        
            OpportunityHelper.UpdateERDDateOfOpp(OppIdForERD);
            
        }
        //}}
        }
        
        
       
         
         if(OppIdForERDOrderNo.size()>0 && trigger.IsUpdate && trigger.IsAfter)
        {
            OpportunityHelper.UpdateERDDateOfOpp(OppIdForERDOrderNo);
        }
       list<Quote__c> qList = new list<Quote__c>();
        if((trigger.isInsert||trigger.isUpdate)&&trigger.isAfter){
        for(Quote__c q:trigger.new){         
             if (trigger.isAfter && (Trigger.isInsert || (Trigger.isUpdate && (Trigger.oldMap.get(q.Id).Order_Number__c != q.Order_Number__c) && (trigger.oldMap.get(q.id).Order_Number__c == 0))) ) {
            qList.add(q);
                              
             } 
         }
         
         if(qList.size()>0){
            QuoteTriggerHelper.CheckInfluencerOppOrder(Trigger.New);
         }
         }
        
      
     
      
      if(Trigger.isAfter && Trigger.isDelete)
      {
          for(Quote__c q: trigger.Old)
          {
              OpportunityHelper.UpdateDiscountOnOpportunities(Trigger.Old);
          }
      }
     
    
    /*** The collections have now been populated in the above sections as per the conditions and business requirements.
     *** Now we'll pass these collections to the QuoteTriggerHelper class methods where the actual business logic is implemented.
     ***/
    if(oppQuoteStage.Keyset().size() > 0){
        QuoteTriggerHelper.updateOppAmount(oppIds,oppQuoteStage);
    }
    /*
    if(primaryOppIds.size() > 0){
        QuoteTriggerHelper.updateOppAmount(primaryOppIds);
    }
    */
    
    // for sending quote to installer and creating Installation if ETA jobsite is filled
    // Added on 23/ 08 / 2016
   // if(trigger.isUpdate && trigger.isAfter) {
    // List < quote__c > QuoteList = new List < quote__c > ();
  //   List <quote__c > QuoteInstallList = new List < quote__c >();
  //  for(quote__c q : trigger.new) {
     //   if((trigger.isUpdate && trigger.isAfter)  &&  (trigger.oldMap.get(q.ID).Send_Quote_to_Installer__c != q.Send_Quote_to_Installer__c )&& (q.Send_Quote_to_Installer__c == TRUE) ){
            
       //     QuoteList = Trigger.newMap.values();
 //       }
     /*   if((trigger.isUpdate && trigger.isAfter)  
        && (trigger.oldMap.get(q.ID).ETA_Jobsite__c!= q.ETA_Jobsite__c) 
        ) {
        if(Helperclass.firstrun ==TRUE){
            QuoteInstallList = Trigger.newMap.values();
             system.debug('Inside after update');
             Helperclass.firstrun = false ;
             }
        } */
        
  //  }
     /*   if(QuoteList.size() >0 ){
    QuoteToInstaller.SendQuote(QuoteList);
        } */
 //  }
  //  QuoteToInstaller.CreateInstallation(QuoteInstallList );
  /***************************************************
  Purpose:To create entitltlements
  ****************************************************/
  if(trigger.isAfter && trigger.isUpdate){
      QuoteTriggerHelper.createEntitlement(trigger.new,trigger.oldmap);
  }
    
    // for  creating Installation if balance received date is filled
     // Added on 28/ 10 / 2016  
 
 //       List < quote__c > QuoteList = new List < quote__c > ();
     /*   for(quote__c q : trigger.new){
            if(((trigger.isUpdate && trigger.isAfter) && (trigger.oldMap.get(q.ID).Balanced_Received_Date__c !=q.Balanced_Received_Date__c) ) || ((trigger.isInsert)&&(trigger.isAfter)&&(q.Balanced_Received_Date__c != null))){
                QuoteList = Trigger.newMap.values();
                system.debug('Inside After update');
            }
        } */
   // system.debug('Value of QuoteList'+QuoteList);
    // QuoteTriggerHandler.CreateInstallation(QuoteList); 
    
    
}
}