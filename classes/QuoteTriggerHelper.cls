/**********************************************************************
Apex Class: QuoteTriggerHelper
Description: This class is used to implement all business logic related to 
            Quote Trigger
Created Date: 16th APR 2014            
***********************************************************************/
public with sharing class QuoteTriggerHelper{
    
    /**********************************************************************************
    Method Name: updateOppAmount
    Description: This method is used to update all the related opportunities
                 of Project to Closed/Lost if any one opportunity is Closed/Won
    Input Parameter: Set of Ids         
    **********************************************************************************/
    public static void updateOppAmount(Set <Id> oppIds , map<id,string> mapStage) {
        /*** Set the static helper variable to TRUE in the Utility Class so that the updates
         *** done to Opportunities via this method are skipped by the OpportunityTrigger
         ***/
        UtilityClass.updateFromQuoteTrigger = TRUE;
        
        //Collections & Variables declaration
        //List <Opportunity> tempOppList = new List <Opportunity> ();
        List <Opportunity> updateOppList = new List <Opportunity> ();
        map<ID,Decimal> mapProjectOppAmtOnOrder = new map<ID,Decimal>();
        Set<Id> projectIds = new Set<Id>();
        
        try{
            //Query all the Opportunities and their associated Quotes(in sub query)
            List <Opportunity> tempOppList = [SELECT Id, Amount, recordTypeId ,StageName, Project_Name__c,(SELECT Id, SubTotal__c, Primary_Quote__c,Order_Number__c FROM Quotes1__r) FROM Opportunity WHERE Id IN :mapStage.keySet()];
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            //Loop over the queried Opportunities to process the Quote amounts
            for(Opportunity opp : tempOppList){
                Integer counter = 0;
                Decimal sum = 0;
                Integer primaryCounter = 0;
                Decimal primarySum = 0;
                Boolean isNotPrimary = false;
                Boolean isPrimary = false;
                
                if (mapStage.containsKey(opp.Id)){
                    System.debug('$$$$$$$$$$$$' + mapStage.get(opp.Id)) ;
                    System.debug('###########' + opp.StageName);
                    if (mapStage.get(opp.Id) == 'Open' && opp.StageName!='Quote - Provided' && opp.StageName!= 'Quote - Negotiation/Review' && opp.StageName!= 'Order - Requested' && opp.StageName!= 'Order - Provided' && opp.StageName!=UtilityClass.opportunityWonStatus && string.valueOf(opp.recordTypeId).substring(0,15) != Label.Influencer_Opportunity_RecordTypeId)
                        opp.StageName = 'Quote - Requested';
                    if (mapStage.get(opp.Id) == 'Open' && opp.StageName!='Quote - Provided' && opp.StageName!= 'Quote - Negotiation/Review' && opp.StageName!= 'Order - Requested' && opp.StageName!= 'Order - Provided' && opp.StageName!=UtilityClass.opportunityWonStatus && string.valueOf(opp.recordTypeId).substring(0,15) == Label.Influencer_Opportunity_RecordTypeId)
                        opp.StageName = 'Budget Quote - Requested';
                    if (mapStage.get(opp.Id) == 'Presented'&& opp.StageName!= 'Quote - Negotiation/Review' && opp.StageName!= 'Order - Requested' && opp.StageName!= 'Order - Provided' && opp.StageName!=UtilityClass.opportunityWonStatus && string.valueOf(opp.recordTypeId).substring(0,15) != Label.Influencer_Opportunity_RecordTypeId)
                     opp.StageName = 'Quote - Provided';
                    if ((mapStage.get(opp.Id) == 'Presented'||mapStage.get(opp.Id) =='Presented/Viewed')&& opp.StageName!= 'Quote - Negotiation/Review' && opp.StageName!= 'Order - Requested' && opp.StageName!= 'Order - Provided' && opp.StageName!=UtilityClass.opportunityWonStatus && string.valueOf(opp.recordTypeId).substring(0,15) == Label.Influencer_Opportunity_RecordTypeId)
                     opp.StageName = 'Budget Quote - Provided';
                    if (mapStage.get(opp.Id) == 'Presented/Viewed' && opp.StageName!= 'Order - Requested' && opp.StageName!= 'Order - Provided' && opp.StageName!=UtilityClass.opportunityWonStatus && string.valueOf(opp.recordTypeId).substring(0,15) != Label.Influencer_Opportunity_RecordTypeId)
                    opp.StageName = 'Quote - Negotiation/Review';
                   /* if (mapStage.get(opp.Id) == 'Order Confirmation Started' && opp.StageName!= 'Order - Provided' && opp.StageName!=UtilityClass.opportunityWonStatus)
                    opp.StageName = 'Order - Requested';
                   if (mapStage.get(opp.Id) == 'Order Confirmation Sent'&& opp.StageName!=UtilityClass.opportunityWonStatus)
                    opp.StageName = 'Order - Provided';
                   if (mapStage.get(opp.Id) == 'Order Confirmed'){
                    opp.StageName = UtilityClass.opportunityWonStatus;
                    opp.Primary_Opportunity__c=TRUE;
                    }*/
                    System.debug('$$$$$$$$$$$$' + mapStage.get(opp.Id)) ;
                    System.debug('###########' + opp.StageName);
                }
                //modified by satish for  stages and amounts enhancements
                if (oppIds.Contains(opp.Id)){
                //Loop over related Quotes to get the average of Amount from Quotes
                for (Quote__c qt : opp.Quotes1__r) {
                    system.debug('My debug' + qt.Subtotal__c);
                    system.debug('My debug1' + qt.Order_Number__c);
                    if (qt.Order_Number__c == 0 && qt.SubTotal__c!=0.0) {
                     system.debug('my debug'+ qt.Order_Number__c );
                        isNotPrimary = true;
                        counter++;
                        sum += qt.SubTotal__c;
                    }
                    //if(qt.Primary_Quote__c == true && qt.SubTotal__c != null)
                    if(qt.Order_Number__c > 0 && qt.SubTotal__c != null){
                        isPrimary = true;
                        primaryCounter++;
                        primarySum += qt.SubTotal__c;
                    }
                }
                
                /*** Process if there is NO Primary Quote on Opportunity ***/
                if(isNotPrimary && !isPrimary){
                    //Set the Opportunity Stage to Proposal/Price Quote if only non-primary quotes exists on Opportunity
                   // opp.StageName = 'Proposal/Price Quote';
                    //Set the Opportunity Amount to the average amount of all Quotes
                    if (counter > 0 && sum > 0) {
                        opp.Amount = sum / counter;
                        projectIds.add(opp.Project_Name__c);
                        system.debug('Cheaking for amount field'+opp.Amount);
                        
                   }
                }
                
                /*** Process if there are 1 or more than one Ordered Quote on Opportunity ***/
                if(isPrimary){
                    
                    //Set the Opportunity Amount to the SUM of SubTotal of all Primary Quotes
                    if (primaryCounter > 0 && primarySum > 0) {
                        opp.Amount = primarySum;
                        mapProjectOppAmtOnOrder.put(opp.Project_Name__c,opp.Amount);
                    }
                }

                }
                  system.debug('the opp amount is'+projectIds.size() );
                //Add the modified opportunity to the final list for Update operation
                updateOppList.add(opp);
             }
             
            
            if (updateOppList.size() > 0) {
                //Updating Opportunity Stage and Amounts
                Database.SaveResult [] updateResult = Database.update(updateOppList,false);
                system.debug('the opp amount is'+ updateOpplist);
            }
            
            //Recalculate the Project Amount and update the status of Project to "In Progress - Quote"
            if(projectIds.size() > 0){
                recalculateProjectAmount(projectIds);
            }
            //Recalculate the Project Amount based on Ordered Quotes
             if(mapProjectOppAmtOnOrder.keyset().size() > 0){
                reCalculateProjectAmtOnOrders(mapProjectOppAmtOnOrder);
            }
        }
        catch(Exception ex){
            System.Debug('>>> Exception in "updateOppAmount" method of QuoteTriggerHelper class. Error is :: ' + ex.getMessage());
        }
    }
    
     /**********************************************************************************
    Method added by Satish lokinindi
    Method Name: reCalculateProjectAmtOnOrders
    Description: This method is used to update all Projects which are linked to the
                 opportunities which just got updated by the  Ordered Amounts
    Input Parameter: Map        
    **********************************************************************************/
    public static void reCalculateProjectAmtOnOrders(map<ID,Decimal> proOppAmt){
        list <Project__c> UpdateProList = new list<Project__c>();
        list<Project__c> ProList =[select id,Amount__c from Project__c Where id IN :proOppAmt.keyset()];
        list<Quote__c > quoList = [select id ,Project__c,Order_Number__c,SubTotal__c from Quote__c where Project__c IN : proOppAmt.keyset() AND  Order_Number__c > 0];
        System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Decimal subtotalSumWithOrderNumber =0;
        integer Counter = 0;
        
        for(Project__c pro: ProList){
         for(Quote__c quo: quoList){
            if(quo.Project__c == pro.id){
            Counter++;
            //sum the subTotal based on count of ordered quotes on that Project
            subtotalSumWithOrderNumber += quo.SubTotal__c;
            }
        }
        if(Counter > 0 && subtotalSumWithOrderNumber > 0){
         pro.Amount__c = subtotalSumWithOrderNumber;
         UpdateProList.add(pro);
        }
        }
        //update
        if(UpdateProList.size()>0){
             Database.saveresult[] sr = Database.update(UpdateProList, False); 
             ErrorLogUtility.processErrorLogs(sr, UpdateProList, 'QuoteTriggerHelper', 'reCalculateProjectAmtOnOrders', 'Project__c', 'Update');
        }
        
    }
    
       
    /**********************************************************************************
    Method Name: recalculateProjectAmount
    Description: This method is used to update all Projects which are linked to the
                 opportunities which just got updated by the 
    Input Parameter: Set of Ids         
    **********************************************************************************/
    public static void recalculateProjectAmount(Set <Id> projectIds) {
        List <Project__c> updateProjList = new List <Project__c> ();
        try{
            //Query over Project with Related Opportunities
            List <Project__c> projList = [SELECT Id, Amount__c, (SELECT Id, Amount, AccountId, StageName FROM Opportunities__r) FROM Project__c WHERE Id IN: projectIds];
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            //Loop over Project records
            for (Project__c prj: projList) {
                Integer counter = 0;
                Decimal sum = 0;
                //Loop over related Opportunities to get the average of Amount
                for (Opportunity opp : prj.Opportunities__r) {
                    if (opp.Amount != null) {
                        counter++;
                        sum += opp.Amount;
                    }
                }
                //Set the Project Amount to the average amount of all Opps
                if (counter > 0 && sum > 0) {
                    prj.Amount__c = sum / counter;
                }
                //Set the Project Status to In Progress - Quote for all Opps having Quote(s)
               // prj.Stage__c = 'Quote - Negotiation';
                
                updateProjList.add(prj);
            }
    
            if (updateProjList.size() > 0) {
                //Updating the Project status and amount
                Database.saveresult[] sr = Database.update(updateProjList, False); 
                ErrorLogUtility.processErrorLogs(sr, updateProjList, 'QuoteTriggerHelper', 'recalculateProjectAmount', 'Project__c', 'Update');
            }
        }
        catch(Exception ex){
            System.Debug('>>> Exception in "recalculateProjectAmount" method of QuoteTriggerHelper class. Error is :: ' + ex.getMessage());
        }
        
    }
  
    /**********************************************************************************
    Method Name: primaryQuoteProcessing
    Description: This method is used to update all the related opportunities
                 of Project to Closed/Lost if any one opportunity is Closed/Won
    Input Parameter: Set of Ids         
    **********************************************************************************/
    //public static void primaryQuoteProcessing(Set <Id> primaryOppIds) {
        /*** Set the static helper variable to TRUE in the Utility Class so that the updates
         *** done to Opportunities via this method are skipped by the OpportunityTrigger
         ***/
        //UtilityClass.updateFromQuoteTrigger = TRUE;
        
    //}
    /**********************************************************************************
    Method Added by Satish Lokinindi
    Method Name: Checkinfluenceropporder
    Description: Method to Change Influencer Opportunity Record type to either commericial or residential based on project record type by checking quote order number
    Input Parameter: Set of Ids         
    **********************************************************************************/
    /* */
    public static void CheckInfluencerOppOrder(list<Quote__c> Quotelist){
    
     /*Map < Id, String > MapProjRecTypeID = new Map < Id, String > ();
        Set < Id > projId = new Set < Id > ();
        set < Id > oppId = new set < Id >();
        
        for (Quote__c quo: Quotelist) {
           if(quo.Order_Number__c!=0){
                projId.add(quo.Project__c);
                oppId.add(quo.Opportunity__c);
           }
        }
        Id ResRecTypeID = Schema.getGlobalDescribe().get('Project__c').getDescribe().getRecordTypeInfosByName().get('Residential Project').getRecordTypeId();
        
        Id ComRecTypeID = Schema.getGlobalDescribe().get('Project__c').getDescribe().getRecordTypeInfosByName().get('Commercial Projects').getRecordTypeId();
        
        if (projId.size() >0){
            for (Project__c proji: [Select Id,RecordTypeID from Project__c Where Id IN: projId]) {
            MapProjRecTypeID.put(proji.Id, proji.RecordTypeID);
            }
        
       
          If(oppId.size()>0){
            list<Opportunity> Opplist = new List<Opportunity>();
            for(Quote__c qu:[select Id ,Order_Number__c,Project__c,Opportunity__r.Id,Opportunity__r.recordTypeId  from Quote__c Where Opportunity__c IN:oppId ]){
                
             if(string.valueOf(qu.Opportunity__r.recordTypeId).substring(0,15) == Label.Influencer_Opportunity_RecordTypeId){
                if(MapProjRecTypeID.get(qu.Project__c) == ResRecTypeID){
                Opportunity opp=qu.Opportunity__r;
                opp.recordTypeId  =Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Residential Opportunity').getRecordTypeId();
                opp.Budget_Quote__c =false;
                UtilityClass.doNotRunOnRecTypeChange = false;
                Opplist.add(opp);
                system.debug('##########@@@'+opp);
                }
        
             else {
                Opportunity oppt=qu.Opportunity__r;
                oppt.recordTypeId  =Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Commercial Opportunity').getRecordTypeId();
                oppt.Budget_Quote__c =false;
                UtilityClass.doNotRunOnRecTypeChange = false;
                Opplist.add(oppt);
                system.debug('##########@@@@'+oppt);
                }
             }
           }        
        System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
           update Opplist; 
          }
        }*/
     }
     /********************************************************
     Purpose:Creating entitlements for the Quote detail records
     *********************************************************/
     public static void createEntitlement(List<Quote__c> qtList,Map<id,Quote__c> oldquotes){
     
     set<id> quoteList = new set<id>();
     set<string> orderNameSet = new set<string>();
     for(Quote__c qt:qtList){
         if(qt.Balanced_Received_Date__c !=null && oldquotes.get(qt.id).Balanced_Received_Date__c == null){
             string orderName = string.valueof(qt.Order_Number__c);
             quoteList.add(qt.id);
             orderNameSet.add(orderName);//To add the order names
         }
         
     } 
         system.debug('The orderNameSet is ' + orderNameSet);
         system.debug('The value of quoteList' + quoteList.size());
         List<Order> orderList = [select id,Name, NanaQuote__c from Order where name in:orderNameSet];
         system.debug('The orderList is ' + orderList);
         map<id,string> orderMap = new map<id,string>();
         for(Order ord:orderList){
         orderMap.put(ord.NanaQuote__c,ord.id); //To add the order id and it's related Quote
         }
         system.debug('the orderMap is:::'+orderMap);
         
        if(quoteList.size() > 0 ){  
        List<Quote_Detail__c> quoteDetaillist = [select Name,Quote__c,Quote__r.Name,Model__c,Quote__r.Account_Name__c,Quote__r.Contact_Account_ID__c,Quote__r.Install_Date__c,Quote__r.Actual_Delivery_Date__c,Quote__r.Contact__c,Quote__r.Balanced_Received_Date__c from Quote_Detail__c where Quote__c in:quoteList];       
        system.debug('The Quote Details are::::::'+quoteDetaillist);
        warranties__c entwar = warranties__c.getOrgDefaults();
        Map<string,warranties__c> mp = warranties__c.getAll();
        List<Entitlement> entitleList = new List<Entitlement>();
        for(Quote__c qt:qtList){
             for(Quote_Detail__c quoteDetail:quoteDetaillist){
             if(quoteDetail.Quote__c == qt.id){
             if(mp.containskey(quoteDetail.model__c)){
                Entitlement Entitle = new Entitlement();
                Entitle.nAME =  quoteDetail.Name + ' '+quoteDetail.Model__c;
                Entitle.accountid = quoteDetail.Quote__r.Contact_Account_ID__c;
                Entitle.Contacts__c = quoteDetail.Quote__r.Contact__c;
                Entitle.Nana_Quote__c = quoteDetail.Quote__c;
                Entitle.Quote_Detail__c = quoteDetail.id; 
                Entitle.StartDate =  quoteDetail.Quote__r.Balanced_Received_Date__c;  
                Entitle.SlaProcessId = system.Label.Sla_Process;
                Entitle.Order__C = orderMap.get(qt.id);                   
                entitleList.add(Entitle);
                
                Entitlement Entitle1 = new Entitlement();
                Entitle1.nAME =  quoteDetail.Name + ' '+quoteDetail.Model__c+ ' ' +'Roller';
                Entitle1.accountid = quoteDetail.Quote__r.Contact_Account_ID__c;
                Entitle1.Contacts__c = quoteDetail.Quote__r.Contact__c;
                Entitle1.Nana_Quote__c = quoteDetail.Quote__c;
                Entitle1.Quote_Detail__c = quoteDetail.id; 
                Entitle1.StartDate =  quoteDetail.Quote__r.Balanced_Received_Date__c;  
                Entitle1.SlaProcessId = system.Label.Sla_Process;   
                Entitle1.Order__C = orderMap.get(qt.id);                                            
                entitleList.add(Entitle1);
                system.debug('***********entitleList****'+entitleList);
                }
                else{
                Entitlement Entitle2 = new Entitlement();
                Entitle2.nAME =  quoteDetail.Name + ' '+quoteDetail.Model__c;
                Entitle2.accountid = quoteDetail.Quote__r.Contact_Account_ID__c;
                Entitle2.Contacts__c = quoteDetail.Quote__r.Contact__c;
                Entitle2.Nana_Quote__c = quoteDetail.Quote__c;
                Entitle2.Quote_Detail__c = quoteDetail.id; 
                Entitle2.StartDate =  quoteDetail.Quote__r.Balanced_Received_Date__c;
                Entitle2.SlaProcessId = system.Label.Sla_Process;
                Entitle2.Order__C = orderMap.get(qt.id);                                        
                entitleList.add(Entitle2);
               // system.debug('*******entitleList1*********'+entitleList1);
                }
                }
            }
            }
        try{
        if(entitleList.size()>0 || entitleList.size() != null ){
        insert entitleList;
        }
       }catch(exception e){}
         }
     }
         
     
 }