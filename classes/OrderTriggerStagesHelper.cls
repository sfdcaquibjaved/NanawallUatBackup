/**************************** 
Created By :- Satish Lokinindi
Description :- This class is used  to update the Stages of Quote & Opportunity & Project  when Order Stages are Changed
****************************/

public with sharing class OrderTriggerStagesHelper{
    
    
    /*************************************************
    Method Name: updateQuoteStages
    Description: This method is used to update  the related Quote stage                 
    Input Parameter: Set of Ids  and map     
    *************************************************/
    //@future    
    public static void updateQuoteStages(set<ID>qSetIds,map<Id,String> orderStatusMap){
         
        list<Quote__c> updateQuote = new list<Quote__c>();
        list<Quote__c> quList =[select id,Stage__c,(select id,Status,NanaQuote__c from Orders1__r) from Quote__c  where ID IN:qSetIds  ];
 
        //Loop over Quotes to assign the  default stages of quote to  Ordered When order is created
        for(Quote__c quo :quList ){
             for(Order ord :quo.Orders1__r){
               UtilityClass.runQuoteTrigger = False;
                if(quo.Id==ord.NanaQuote__c && (ord.Status == orderStatusMap.get(ord.id)) && quo.Stage__c !=UtilityClass.QuotOrderStage){
                //Set default ordered value from static variable ,Commented Code
                    quo.Stage__c = UtilityClass.QuotOrderStage;
                    system.debug('AreYouHEREWITHANYUPDATE'+quo.Stage__c);
                    UpdateQuote.add(quo);
                }
             }
        }
        //Error logs
        //Update the quotes 
        if(updateQuote.size()>0){
        Database.saveresult[] sr = Database.update(updateQuote, false);
        ErrorLogUtility.processErrorLogs(sr, updateQuote, 'OrderTriggerStagesHelper', 'updateQuoteStages', 'Quote__c', 'update');   
        }
    }
    
    
    /*************************************************
    Method Name: updateOppStages
    Description:  This Method is used to update related opp based on changes in Order  object           
    Input Parameter:  Set of Ids  and map      
    *************************************************/
   // @future
     public static void updateOppStages(set<ID>oSetIds,map<Id,String> orderStatusMap){
        
        list<Opportunity> updateOpplist = new list<Opportunity>();
        //list<Quote__c> quoList =[select Id,Stage__c,Opportunity__r.StageName,Project__c,Order__r.Status,Order__r.NanaQuote__c, Order__r.Project__c from Quote__c  where ID IN:setIds  ];
       // list<Opportunity> oppList = [select id,StageName,Project_Name__c,(select id ,Order__r.ID,Order__r.Status,Order__r.NanaQuote__c, Order__r.Project__c From Quotes1__r) from Opportunity Where Project_Name__c IN:pSetIds] ;
       
        list<Opportunity> oppList = [select id,StageName,Project_Name__c,(select id ,OpportunityID ,Status From Orders) from Opportunity Where ID IN:oSetIds] ;

        if(oppList.size()>0){
        // Loop over Opportunities to assign the Opportunity Stages based on Changes in  Order stages 
        for(Opportunity opp: oppList){
             for(Order ord: opp.Orders){
                if( orderStatusMap.containskey(ord.ID)){
                    UtilityClass.doNotRunOnOrderOppUpdate=false;
                    if(orderStatusMap.get(ord.ID)==ord.Status && opp.StageName != UtilityClass.opportunityWonStatus && opp.stageName!= UtilityClass.getStringValue('LeadClosedLostStatus') && opp.stageName!= UtilityClass.getStringValue('RelatedOppClosed-Lost' ) && (!orderStatusMap.get(ord.ID).equalsignorecase('Cancelled'))  && (!orderStatusMap.get(ord.ID).equalsignorecase('On Hold'))&& (!orderStatusMap.get(ord.ID).equalsignorecase('Draft'))){
                        opp.StageName = OrderOppStages__c.getinstance(orderStatusMap.get(ord.ID)).OppStage__c;
                        system.debug('OPPSTAGE'+opp.StageName);
                        updateOpplist.add(opp);
                    }
                    //Check to handle the specific stages when it should actually work and update the stages
                    if(/*orderStatusMap.get(ord.ID).equalsignorecase('Cancelled') ||  orderStatusMap.get(ord.ID).equalsignorecase('On Hold')|| */ orderStatusMap.get(ord.ID).equalsignorecase('Closed/Inactivity')){
                        opp.StageName = OrderOppStages__c.getinstance(orderStatusMap.get(ord.ID)).OppStage__c;
                        system.debug('OPPSTAGE1111'+opp.StageName);
                        updateOpplist.add(opp);
                    }
                }
             } 
        }
        }
        //Error logs
        //Update the Opps ,null check
         if(updateOpplist.size()>0){
        Database.saveresult[] sr = Database.update(updateOpplist, false);
        ErrorLogUtility.processErrorLogs(sr, updateOpplist, 'OrderTriggerStagesHelper', 'updateOppStages', 'Opportunity', 'Update');   
        }
     }
     
     
    /*************************************************
    Method Name: updateProjStagesFromOpportunity
    Description:  This Method is used to update related Projects based on changes in Order  object           
    Input Parameter:  Set of Ids  and map         
    *************************************************/  

 // @future
    public static void updateProjStagesFromOpportunity(set<ID>pSetIds,map<Id,String> orderStatusMap){
       
        list<Project__c> pList = new list<Project__c>();
        //list<Order> orderList = [select id , Status,NanaQuote__c,Project__c from Order where ID IN :orderStatusMap.keyset()];
        list<Project__c> proList = [select id ,Stage__c,(select id , Status,NanaQuote__c,Project__c from Orders__r) from Project__c where id IN : pSetIds];
        map < String, Integer > mapStageProj = new map < String, Integer > ();
        System.debug('3.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        //create a list of project stages and store in map to analyze the highest and lowest pick values
        Integer num = 1;
        Schema.DescribeFieldResult allProStages = Schema.sObjectType.Project__c.fields.Stage__c;
        for (Schema.Picklistentry entry: allProStages.getPicklistValues()) {
            mapStageProj.put(entry.getValue(), num);
            //System.debug('---map of Project Stages--' + entry.getValue() + '--label--' + entry.getLabel());
            num++;
        }
       if(proList.size()>0){
        // Loop over Projects to assign the Project Stages based on  Changes in Order stages 
        for(Project__c pro : proList){
             for(Order ord : pro.Orders__r ){
                if(ord.Project__c == pro.Id && orderStatusMap.containskey(ord.ID)){
                    if((pro.Stage__c != UtilityClass.ProjectwonCompletestatus ||pro.Stage__c != UtilityClass.ProjectwonProcessstatus ||pro.Stage__c != UtilityClass.Projectwonsignedstatus)&& ( mapStageProj.get(pro.Stage__c) < mapStageProj.get(OrdProjectStages__c.getinstance(orderStatusMap.get(ord.ID)).ProjStage__c)) && (!ord.Status.equalsignorecase('Cancelled')) &&  (!ord.Status.equalsignorecase('On Hold'))){
                        pro.Stage__c = OrdProjectStages__c.getinstance(orderStatusMap.get(ord.ID)).ProjStage__c ;
                        pList.add(pro);
                    }
                    //Check to handle the specific stages when it should actually work and update the stages
                    if(/*ord.Status.equalsignorecase('Cancelled') || ord.Status.equalsignorecase('On Hold') || pro.Stage__c.equalsignorecase('Cancelled') || pro.Stage__c.equalsignorecase('Project On Hold')|| */pro.Stage__c.equalsignorecase('Closed - Inactivity')){
                        pro.Stage__c = OrdProjectStages__c.getinstance(orderStatusMap.get(ord.ID)).ProjStage__c ;
                        pList.add(pro);
                    }
                }
             }
        }
       }
       //Error log
       //Null Check and To update projects
        if(pList.size()>0){
        Database.saveresult[] sr = Database.update(pList, false);
        ErrorLogUtility.processErrorLogs(sr, pList, 'OrderTriggerStagesHelper', 'updateProjStagesFromOpportunity', 'Project__c', 'Update');     
        }
        
        
    }
   /*************************************************
    Method Name: updateOrderNumber
    Description:  This Method is used to update order number based on US /CA          
    Input Parameter:  trigger.new values   
    *************************************************/ 
    //*********CODE COMMENTED************//
    public static void updateOrderNumber(list<Order> OrderNewValues){
       /* 
        //Query the highest order from US
           list<order> ord = [select id,order_number__c,ShippingCountryCode from order where ShippingCountryCode = 'US' ORDER BY Order_Number__c DESC NULLS last limit 1 ];
            
            decimal usD= ord[0].order_number__c;
         //Query the highest order from CA  
           list<order> ord2 = [select id,order_number__c,ShippingCountryCode from order where ShippingCountryCode = 'CA' ORDER BY Order_Number__c DESC NULLS last limit 1 ];
            
            decimal caD= ord2[0].order_number__c;
            
            for(order oNew: OrderNewValues){
               system.debug('debugggg'+oNew.ShippingCountryCode);
                if(oNew.ShippingCountryCode.equalsIgnoreCase('CA')&& (caD >=20000)){
                
                    oNew.Order_Number__c=caD+1;
                    caD =oNew.Order_Number__c;
                }
                else if(oNew.ShippingCountryCode.equalsIgnoreCase('CA')){
                    oNew.Order_Number__c=20000;
                    caD =oNew.Order_Number__c;

                }
                if(oNew.ShippingCountryCode.equalsIgnoreCase('US') && ((usD >= 1)&&(usD < 20000))){
                
                   
                    oNew.Order_Number__c=usD+1;
                    usD = oNew.Order_Number__c;
                  
                }
                else if(oNew.ShippingCountryCode.equalsIgnoreCase('US')){
                    oNew.Order_Number__c=1;
                    usD = oNew.Order_Number__c;
                }
                
            }*/
            
    }
    
    /*************************************************
    Method Name: updateOrderNumberBasedonManufacturing
    Description:  This Method is used to update order number based on Manufactuting          
    Input Parameter:  trigger.new values   
    ------------------CREATED FOR TESTING PURPOSE------------------
    *************************************************/ 
   public static void updateOrderNumberBasedonManufacturing(list<Order> OrderNewValues){
       

/*
       Decimal rd ;
       Decimal sd ;
       Decimal td ;

       
       list<order> ord = [select id, Order_Number_Default__c, Manufacturing__c from order where Manufacturing__c = 'Richmond'  ORDER BY Order_Number_Default__c DESC NULLS last limit 1 ];
        if(ord.size()>0){rd= ord[0].Order_Number_Default__c;}
       list<order> ord1 = [select id, Order_Number_Default__c, Manufacturing__c from order where Manufacturing__c = 'Solarlux' ORDER BY Order_Number_Default__c DESC NULLS last limit 1 ];
         if(ord1.size()>0){sd= ord1[0].Order_Number_Default__c;}
       list<order> ord2 = [select id, Order_Number_Default__c, Manufacturing__c from order where Manufacturing__c = 'Teuffel' ORDER BY Order_Number_Default__c DESC NULLS last limit 1 ];
        if(ord2.size()>0){ td= ord2[0].Order_Number_Default__c;}
        
        for(order oNew: OrderNewValues){
               //check if manufacturing is from richmond and assign ordernumber with incremental value
                if(oNew.Manufacturing__c.equalsIgnoreCase('Richmond')&& (rd >=40000)){
                
                    oNew.Order_Number_Default__c=rd+1;
                     //store incremental value 
                    rd =oNew.Order_Number_Default__c;
                }
                else if(oNew.Manufacturing__c.equalsIgnoreCase('Richmond')){
                    oNew.Order_Number_Default__c=40000;
                     //store incremental value 
                    rd =oNew.Order_Number_Default__c;

                }
                //check if manufacturing is from solarlux and assign ordernumber with incremental value
                if(oNew.Manufacturing__c.equalsIgnoreCase('Solarlux') && (sd >=20000)){
                
                   
                    oNew.Order_Number_Default__c=sd+1;
                    //store incremental value 
                    sd = oNew.Order_Number_Default__c;
                  
                }
                else if(oNew.Manufacturing__c.equalsIgnoreCase('Solarlux')){
                    oNew.Order_Number_Default__c=20000;
                     //store incremental value 
                    sd = oNew.Order_Number_Default__c;
                }
                //check if manufacturing is from teuffel and assign ordernumber with incremental value
                if(oNew.Manufacturing__c.equalsIgnoreCase('Teuffel') && (td>=75000)){
                
                   
                    oNew.Order_Number_Default__c=td+1;
                     //store incremental value 
                    td = oNew.Order_Number_Default__c;
                  
                }
                else if(oNew.Manufacturing__c.equalsIgnoreCase('Teuffel')){
                    oNew.Order_Number_Default__c=75000;
                     //store incremental value 
                    td = oNew.Order_Number_Default__c;
                }
                
            }*/
            
   }
    /*************************************************
    Added by Satish Lokinindi
    Method Name: orderNumberBasedOnRangeAndModel
    Description:  This Method is used to update order number based on first positions          
    Input Parameter:  trigger.new values   
    ------------------CREATED FOR TESTING PURPOSE------
    *************************************************/ 
   public static void orderNumberBasedOnRangeAndModel(list<Order> orderList){
    //loop over all orders and store the quote ids
    set<id> qid = new set<id>();
       for(order o: orderList){
            qid.add(o.NanaQuote__c);
            
       }
    //string s;
    //map the quote and model and use them  to request the model manfacturer from custom settings
    map<string,string> mapQuoteModel = new map<string,string>();
    //Query the first created model from the set of quote ids and store it in map
     list<Quote_detail__c> qdlistAll = [select id,Quote__c,model__c from Quote_detail__c where Quote__c IN:qid ORDER BY createdDate ASC]; 
     
     for(order o: orderList){ 
     decimal x=0;
     decimal c=0;
     decimal count=0; 
     decimal count2=0; 
     string sModel;
     string s2Model;
     string sQuote;
     
     boolean f =true;
        for(Quote_detail__c qdList : qdlistAll){
        
        
            if(qdList.Quote__c==o.NanaQuote__c){
            count=count+1;
                if(!qdList.model__c.contains('Screen')){  
                        c=c+1;
                        count2=count2+1; 
                        if(c==1){
                        //mapQuoteModel.put(qdList.Quote__c,qdList.model__c); 
                        sModel=qdList.model__c;
                        sQuote=qdList.Quote__c;
                        
                         f=false;     
                        }                                                    
                }
                    else{
                    x=x+1;
                    count2=count2+1;
                        if(c==0 && x==1){
                         s2Model=qdList.model__c;
                         sQuote =qdList.Quote__c;
                        }
                    
                    }
            }
             
           
            
        }
            if((count>0)==(count2>0)){
            if(f==false){
            mapQuoteModel.put(sQuote,sModel);
            system.debug(mapQuoteModel);
            }
            else if((c==0)&& (x > 0)){
            mapQuoteModel.put(sQuote,s2Model);
             system.debug(mapQuoteModel);
            }
            } 
            
        
    }   
       
     //if(qdList.size()>0){s = ModelManufacturer__c.getinstance(qdList[0].model__c).Manufacturer__c;}
       
       Decimal rd ;
       Decimal sd ;
       Decimal td ;
       Decimal wd ;
       //query to get the highest ordernumber for that respective manufacturer
       list<order> ord = [select id, Order_Number_Default__c, Manufacturing__c from order where Manufacturing__c = 'Richmond'  ORDER BY Order_Number_Default__c DESC NULLS last limit 1 ];
        if(ord.size()>0){rd= ord[0].Order_Number_Default__c;}
       list<order> ord1 = [select id, Order_Number_Default__c, Manufacturing__c from order where Manufacturing__c = 'Solarlux' ORDER BY Order_Number_Default__c DESC NULLS last limit 1 ];
         if(ord1.size()>0){sd= ord1[0].Order_Number_Default__c;}
       list<order> ord2 = [select id, Order_Number_Default__c, Manufacturing__c from order where Manufacturing__c = 'Teuffel' ORDER BY Order_Number_Default__c DESC NULLS last limit 1 ];
        if(ord2.size()>0){ td= ord2[0].Order_Number_Default__c;}
       list<order> ord3 = [select id, Order_Number_Default__c, Manufacturing__c from order where Manufacturing__c = 'Wizard' ORDER BY Order_Number_Default__c DESC NULLS last limit 1 ];
        if(ord3.size()>0){ wd= ord3[0].Order_Number_Default__c;}
    //loop over the orders and assign order number and update the manufacturer on orders
     for(order oNew: orderList){
       system.debug(ModelManufacturer__c.getinstance(mapQuoteModel.get(oNew.NanaQuote__c)));
       system.debug(mapQuoteModel.get(string.valueof(oNew.NanaQuote__c)));
               //check if manufacturing is from richmond and assign ordernumber with incremental value
               //based  on model get the manufacturer from custom settings
                if(ModelManufacturer__c.getinstance(mapQuoteModel.get(string.valueof(oNew.NanaQuote__c))).Manufacturer__c.equalsIgnoreCase('Richmond')&& (rd >=40000)){
                
                    oNew.Order_Number_Default__c=rd+1;
                    oNew.Manufacturing__c='Richmond';
                     //store incremental value 
                    rd =oNew.Order_Number_Default__c;
                }
                else if(ModelManufacturer__c.getinstance(mapQuoteModel.get(oNew.NanaQuote__c)).Manufacturer__c.equalsIgnoreCase('Richmond')){
                    oNew.Order_Number_Default__c=40200;
                    oNew.Manufacturing__c='Richmond';
                     //store incremental value 
                    rd =oNew.Order_Number_Default__c;

                }
                //check if manufacturing is from solarlux and assign ordernumber with incremental value
                if(ModelManufacturer__c.getinstance(mapQuoteModel.get(oNew.NanaQuote__c)).Manufacturer__c.equalsIgnoreCase('Solarlux') && (sd >=20000)){
                
                    oNew.Manufacturing__c='Solarlux';
                    oNew.Order_Number_Default__c=sd+1;
                    //store incremental value 
                    sd = oNew.Order_Number_Default__c;
                  
                }
                else if(ModelManufacturer__c.getinstance(mapQuoteModel.get(oNew.NanaQuote__c)).Manufacturer__c.equalsIgnoreCase('Solarlux')){
                    oNew.Order_Number_Default__c=20000;
                    oNew.Manufacturing__c='Solarlux';
                     //store incremental value 
                    sd = oNew.Order_Number_Default__c;
                }
                //check if manufacturing is from teuffel and assign ordernumber with incremental value
                if(ModelManufacturer__c.getinstance(mapQuoteModel.get(oNew.NanaQuote__c)).Manufacturer__c.equalsIgnoreCase('Teuffel') && (td>=75000)){
                
                   oNew.Manufacturing__c='Teuffel';
                    oNew.Order_Number_Default__c=td+1;
                     //store incremental value 
                    td = oNew.Order_Number_Default__c;
                  
                }
                else if(ModelManufacturer__c.getinstance(mapQuoteModel.get(oNew.NanaQuote__c)).Manufacturer__c.equalsIgnoreCase('Teuffel')){
                    oNew.Order_Number_Default__c=75400;
                    oNew.Manufacturing__c='Teuffel';
                     //store incremental value 
                    td = oNew.Order_Number_Default__c;
                }
                if(ModelManufacturer__c.getinstance(mapQuoteModel.get(oNew.NanaQuote__c)).Manufacturer__c.equalsIgnoreCase('Wizard') && (wd>=90000)){
                
                   oNew.Manufacturing__c='Wizard';
                    oNew.Order_Number_Default__c=wd+1;
                     //store incremental value 
                    wd = oNew.Order_Number_Default__c;
                  
                }
                else if(ModelManufacturer__c.getinstance(mapQuoteModel.get(oNew.NanaQuote__c)).Manufacturer__c.equalsIgnoreCase('Wizard')){
                    oNew.Order_Number_Default__c=97000;
                    oNew.Manufacturing__c='Wizard';
                     //store incremental value 
                    wd = oNew.Order_Number_Default__c;
                }
                
            
        }

   }
    
}