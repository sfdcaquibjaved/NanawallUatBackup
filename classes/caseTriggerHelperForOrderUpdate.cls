public class caseTriggerHelperForOrderUpdate{

    public static void addValuesOfOrderQuoteProject(List<Case> caseList,boolean quoteChange,boolean orderChange){
    system.debug('hiSatz3');
    set<string> orderNo = new set<string>();
    string str ;
    set<id> qId = new set<id>();
    for(case c :caseList){
        qId.add(c.Quote__c);
    }
    for(Quote__c q :[select id,Order_Number__c from Quote__c where id IN:qId]){
    str=string.valueof(q.Order_Number__c);
    system.debug(str);
    system.debug(q.Order_Number__c);
    orderNo.add(str);
    }
    map<string,id> mapQuoteOrder = new map<string,id>();
    list<order> ordList = [select id,name from Order where name IN :orderNo];
    for(order o:ordList){
    if(o.name!='0'){
    mapQuoteOrder.put(o.Name,o.id);
    system.debug(mapQuoteOrder);
    }
    
    }
     for(case c:caseList){
          if((c.Order__c!=null  && !quoteChange && !orderChange) || (c.Order__c!=null && orderChange)) {
                list<order> ord =[select id ,name,Project__c , NanaQuote__c from order where id =:c.order__c];  
                  if(ord.size()>0){
                      c.Quote__c=ord[0].NanaQuote__c;
                      c.ProjectName__c=ord[0].Project__c;
                  }
                  else{
                      //c.Order_Number__c.addError('Order Number Doesnt Exists');
                  }
          }
          else if((c.Quote__c != null && !quoteChange && !orderChange)||(c.Quote__c != null && quoteChange  )){
              list<Quote__c> q =[select id,Order_Number__c,Project__c from Quote__c where id =:c.Quote__c LIMIT 1];
                  if(q.size()>0){
                      //c.Quote__c=q[0].id;
                      c.ProjectName__c=q[0].Project__c;
                      string strg = string.valueof(q[0].Order_Number__c);
                      if(mapQuoteOrder.containskey(strg)!= null){
                      c.Order__c = mapQuoteOrder.get(strg);
                      system.debug(c.Order__c);
                      }
                      else{
                      c.Order__c ='';
                      }
                  }
               }
     }
    }
    public static void autoUpdateConTypeOnCase(List<Case> caseList,set<id> caseConIds){
        list<contact> conList = [select id,LeadType__c,AccountID , Account.type from COntact where ID IN : caseConIds];
        for(case c: caseList){
            for(contact con:conList){
                if(con.id==c.ContactId){
                    c.I_am_requesting_service_as__c  = con.LeadType__c;
                    c.Account_Type__c = con.Account.type;
                    c.AccountID = con.AccountID;
                }
            }
        }
    }
<<<<<<< HEAD
    
    public static void updateSLorderFromManufact(List<Case> casList,set<id> caseOrdIds){
    //set<id> caseSet=new set<id>();
    list<Manufacturing_Order__c> ManufOrderList=[select id,Order__c,Supplier_WO_Number__c from Manufacturing_Order__c where Order__c in :caseOrdIds AND Supplier_WO_Number__c !='' And Supplier_WO_Number__c!='0'];
    
    List<case> caseList =new List<case>();
    //caseSet=[select id,Order__c,SL_Order_Id_Manuf__c from case where Order__c];
    for(case c:casList){
        integer count =0;
          for(Manufacturing_Order__c mo:ManufOrderList){
              if(c.order__c==mo.order__C){
              c.SL_Order_Id_Manuf__c=mo.Supplier_WO_Number__c;
              count+=1;
              }
          }
          //on update if selected order has Sl order  blank,then overwrite the existing value with null
          if(count==0){
          c.SL_Order_Id_Manuf__c='';
          }
    
    }
    
    }
=======
>>>>>>> 38d5474048e4349e5fb1b806274e5d38ea1dc1fc
}