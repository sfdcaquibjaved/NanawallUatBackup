public class successRatioControllerTablenew{

/*Map<string, Integer> mtotal = new Map<string, Integer>();
Map<string, Integer> projs=new Map<string, Integer>();
decimal z;
decimal znew;
Map<string,decimal> maplist = new map<string,decimal>();
public list<WrapList> dataList{get;set;}
public list<WrapListVolume> dataListVolume{get;set;}
public Map<string, Integer> mtotalHalf = new Map<string, Integer>();
public Map<string, decimal> projtotalHalf = new Map<string, decimal>();
String Qyear;
String labelname= Label.OFD;
string nn;
Integer Tcommission;
Integer Tamount;
Decimal rounded;
Decimal roundednew;
Map<string,decimal> maplistnew = new map<string,decimal>();

public Map<string, Integer> mtotalVolumeQuarter = new Map<string, Integer>();
public Map<string, Integer> mtotalVolumeHalf = new Map<string, Integer>();
public Map<string, Integer> mtotalVolume = new Map<string, Integer>();
public Map<string, Decimal> projvolume= new Map<string, Decimal>();
public Map<string, Decimal> projVolumeHalf = new Map<string, Decimal>();
public Map<string, Decimal> projVolumeQuarter= new Map<string, Decimal>();

/****************Class Constructor*************************/   
   
/*public successRatioControllerTablenew(){
 dataList = new List<WrapList>();
 dataListVolume = new List<WrapListVolume>();*/
 
 /****************************** For Yearwise Calculation**********************************************/
 
 /*Map<string, Integer> mtotalnew = new Map<string, Integer>();

decimal z2;

  for(AggregateResult arnew:[select SUM(Commission_Total__c) commissionnew, CALENDAR_YEAR(Order_Finalized_Date__c) yeardatenew from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c)>=2012 AND Split__c>0 AND Order_Number__c>0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY  CALENDAR_YEAR(Order_Finalized_Date__c) ASC]){

     
     System.debug('Created Date' + arnew.get('yeardatenew'));
     
     mtotalnew.put(string.valueof(arnew.get('yeardatenew')),Integer.Valueof(arnew.get('commissionnew')));
     system.debug('The mtotal values are:::::::::'+mtotalnew);
      
     }
     
   
 
 for(AggregateResult pnew:[select SUM(Amount__c) amountnew , CALENDAR_YEAR(CreatedDate) yearnew from Project__c WHERE CALENDAR_YEAR(CreatedDate)>=2012 AND (NOT Name LIKE '%Test%') AND (NOT Name LIKE '%TEST%') AND (NOT Name LIKE '%test%')  GROUP BY CALENDAR_YEAR(CreatedDate)ORDER BY  CALENDAR_YEAR(CreatedDate) DESC]){
 system.debug('********************'+pnew.get('yearnew'));
 system.debug('################'+ mtotalnew.containsKey(string.valueof(pnew.get('yearnew'))));
     
  if(pnew.get('yearnew')!=null && mtotalnew.containsKey(string.ValueOf(pnew.get('yearnew'))))
 {
     integer xnew = mtotalnew.get(string.ValueOf(pnew.get('yearnew')));
     decimal rnew= decimal.valueof(xnew);
     system.debug('The x year values are:::::::'+xnew);
     object ynew = pnew.get('amountnew');
       integer anew = integer.valueof(ynew);
       decimal snew = decimal.valueof(anew);
      system.debug('The a year values are:::::::'+anew);
      
 
      znew = (rnew/snew)*100;
      roundednew =znew.setScale(2, RoundingMode.HALF_UP);
     System.debug('suceesss'+znew);
     if(znew != null && znew != 0){
     mapListnew.put(string.valueof(pnew.get('yearnew')),roundednew);
     system.debug('the mapListnew is:::::::::::'+mapListnew);
     }
     
     /*string ssnew = string.valueof(p.get('yearnew'));
     system.debug('the maplist is:::::::::::'+mapList);
     dataList.add(new Data(ss,z));
      
 }*/
   
     
 }  
 
 /********************************************************Half Yearly*******************************************************************/
 
         /*integer amt1=0;
         integer amt2=0;
         integer amt3=0;
         integer amt4=0;
         for(AggregateResult ar:[select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate,CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c)>=2012 AND Split__c>0 AND Order_Number__c>0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c),CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY  CALENDAR_YEAR(Order_Finalized_Date__c),CALENDAR_QUARTER(Order_Finalized_Date__c)  ASC]){                
             
                 
                 if(Integer.valueof(ar.get('quarter'))==1)
                 {                   
                     amt1 = Integer.Valueof(ar.get('commission'));
                 }
                 else if(Integer.valueof(ar.get('quarter'))==2)
                 {                   
                     integer ct;
                     amt2 = amt1+Integer.Valueof(ar.get('commission'));
                     ct = 1;
                     string Qyear=(ct+' '+(string.valueof(ar.get('yeardate'))));
                     mtotalHalf.put(Qyear, amt2);                    
                     amt1 = 0;
                     amt2 = 0;                    
                 }
                 else if(Integer.valueof(ar.get('quarter'))==3)
                 {                   
                     amt3 = Integer.Valueof(ar.get('commission'));
                 }
                 else if(Integer.valueof(ar.get('quarter'))==4)
                 {                   
                     integer ct;
                     amt4 = amt3+Integer.Valueof(ar.get('commission'));
                     ct = 3;
                     string Qyear=(ct+' '+(string.valueof(ar.get('yeardate'))));
                     mtotalHalf.put(Qyear, amt4);                    
                     amt3 = 0;
                     amt4 = 0;                    
                 }                       
      
         }
         Map<string,decimal> maplist = new map<string,decimal>();
         integer projamt1=0;
         integer projamt2=0;
         integer projamt3=0;
         integer projamt4=0;
         
         for(AggregateResult p:[select SUM(Amount__c) amount , CALENDAR_YEAR(CreatedDate) year, CALENDAR_QUARTER(CreatedDate) projectquarter from Project__c WHERE CALENDAR_YEAR(CreatedDate)>=2012  AND (NOT Name LIKE '%Test%') AND (NOT Name LIKE '%TEST%') AND (NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)ORDER BY  CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate) ASC]){  
         
                if(Integer.valueof(p.get('projectquarter'))==1)
                 {                   
                     projamt1= Integer.Valueof(p.get('amount'));
                 }
                 else if(Integer.valueof(p.get('projectquarter'))==2)
                 {                   
                     integer ct;
                     projamt2= projamt1+Integer.Valueof(p.get('amount'));
                     ct = 1;
                     string Qyear=(ct+' '+(string.valueof(p.get('year'))));
                     
                     integer mamount = mtotalHalf.get(Qyear);
                     decimal mamtdec = decimal.valueof(mamount);
                     decimal projdec = decimal.valueof(projamt2);
                     decimal op= (mamtdec/projdec)*100;
                     decimal rou =op.setScale(2, RoundingMode.HALF_UP);
                    /* yaxis = 'Half Year';
                     titlename = 'By Half Year';
                     string ss= 'H'+Qyear;
                     dataList.add(new Data(ss, rou));*/
                    /*string ss= 'H'+Qyear;
                     projtotalHalf.put(ss, rou);                    
                     amt1 = 0;
                     amt2 = 0;                    
                 }
                 else if(Integer.valueof(p.get('projectquarter'))==3)
                 {                   
                     projamt3= Integer.Valueof(p.get('amount'));
                 }
                 else if(Integer.valueof(p.get('projectquarter'))==4)
                 {                   
                     integer ct;
                     projamt4= projamt3+Integer.Valueof(p.get('amount'));
                     ct = 3;
                     string Qyear=(ct+' '+(string.valueof(p.get('year'))));                    
                     integer mamount = mtotalHalf.get(Qyear);
                     decimal mamtdec = decimal.valueof(mamount);
                     decimal projdec = decimal.valueof(projamt4);
                     decimal op= (mamtdec/projdec)*100;
                     decimal rou =op.setScale(2, RoundingMode.HALF_UP);
                     string ss= 'H'+Qyear;
                     projtotalHalf.put(ss, rou);                     
                     amt3 = 0;
                     amt4 = 0;                    
                                       
   }
 
 }
 
 /***************************************Quarterly**************************************************************/

 /* for(AggregateResult ar:[select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate,CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c)>=2012 AND Split__c>0 AND Order_Number__c>0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c),CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY  CALENDAR_YEAR(Order_Finalized_Date__c),CALENDAR_QUARTER(Order_Finalized_Date__c)  ASC]){
 
     Qyear=(Integer.valueof(ar.get('quarter')))+' '+(string.valueof(ar.get('yeardate')));
     
     System.debug('Created Date' +Qyear);
     
     System.debug('Created Date' + ar.get('yeardate'));
     
     mtotal.put(Qyear,Integer.Valueof(ar.get('commission')));
     system.debug('The mtotal values are:::::::::'+mtotal);
     
     
     
      
     } 
     List<String> keys = new List<String>(mtotal.keySet());  
     system.debug('The keys values are:::::::::'+keys);
     
     
   for(AggregateResult p:[select SUM(Amount__c) amount , CALENDAR_YEAR(CreatedDate) year,CALENDAR_QUARTER(CreatedDate) projectquarter from Project__c WHERE CALENDAR_YEAR(CreatedDate)>=2012  AND (NOT Name LIKE '%Test%') AND (NOT Name LIKE '%TEST%') AND (NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)ORDER BY  CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate) ASC]){
 String PQYear=(Integer.valueof(p.get('projectquarter')))+' '+(string.valueof(p.get('year')));
 
 system.debug('********************'+PQYear);
 system.debug('################'+ mtotal.containsKey(PQYear));
 system.debug('***************###########'+mtotal.get(PQYear));
 
 
 if(PQYear!=null && mtotal.containsKey(PQYear))
 {
     integer x = mtotal.get(PQYear);
     decimal r= decimal.valueof(x);
     system.debug('The x year values are:::::::'+x);
     object y = p.get('amount');
       integer a = integer.valueof(y);
       decimal s = decimal.valueof(a);
      system.debug('The a year values are:::::::'+a);
      
 
      z = (r/s)*100;
      rounded =z.setScale(2, RoundingMode.HALF_UP);
     System.debug('suceesss'+z);
     if(z != null && z != 0){
     mapList.put(string.valueof(p.get('year')),z);
     }
     
     string ss = string.valueof(PQyear);
     nn = labelname+ss;
     Tcommission = Integer.valueof(mtotal.get(PQyear));
     Tamount = Integer.valueof(p.get('amount'));
     system.debug('the Tamount is:::::::::::'+Tamount);
     System.debug('Tcommission:::::::::::::::'+Tcommission);
     system.debug('the nn is:::::::::::'+nn);
    //dataList.add(new WrapList(nn,Tcommission ,Tamount,z));
   // system.debug('the dataListis:::::::::::'+dataList);
   
    Decimal yearamount=maplistnew.get(string.valueof(p.get('year')));
   system.debug('the yearamount:::::::::::'+yearamount);
   
   Decimal halfyears=projtotalHalf.get(string.valueof(p.get('year')));
   system.debug('the halfyears:::::::::::'+halfyears);
   //WrapList  w2=new WrapList(nn,Tcommission ,Tamount,rounded,yearamount,true);

    
    
    decimal dd;
    if(projtotalHalf.containskey('H'+PQYear))
    {
        dd= projtotalHalf.get('H'+PQYear);
        System.debug('oppppppp'+dd);
    }
WrapList  w2;
   if(nn.contains('Q1'))
   {
    w2=new WrapList(nn,Tcommission ,Tamount, rounded, dd, yearamount);
    }   
    else if(nn.contains('Q3'))
    {
       w2=new WrapList(nn,Tcommission ,Tamount,rounded, dd, 0);
    }
    else
    {
        w2=new WrapList(nn,Tcommission ,Tamount,rounded,0,0);
    }
    
    
     system.debug('the WrapList$$$$$$$$$$$$:::::::::::'+w2); 
      dataList.add(w2);
      system.debug('the WrapList:::::::::::'+dataList); 
     
     
     
     
      
 }

 } 
 
/****************************************************************YearWise Calculation for Volume**********************************************************************/
 
/*for(AggregateResult ar:[select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(quote__c.Project__c) pname from Quote__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c)>=2012 AND Order_Number__c>1 AND Order_Number__c>0 AND (NOT Project_Name__c LIKE '%Test%') AND (NOT Project_Name__c LIKE '%TEST%') AND (NOT Project_Name__c LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY  CALENDAR_YEAR(Order_Finalized_Date__c) ASC]){
          
              mtotalVolume.put(string.valueof(ar.get('yeardate')),Integer.Valueof(ar.get('cid')));
          }
          
          for(AggregateResult p:[select COUNT(id) pid, CALENDAR_YEAR(CreatedDate) year from Project__c WHERE CALENDAR_YEAR(CreatedDate)>=2012  AND (NOT Name LIKE '%Test%') AND (NOT Name LIKE '%TEST%') AND (NOT Name LIKE '%test%')  GROUP BY CALENDAR_YEAR(CreatedDate)ORDER BY  CALENDAR_YEAR(CreatedDate) ASC]){
              
              if(p.get('year')!=null && mtotalVolume.containsKey(string.ValueOf(p.get('year'))))
              {
                  integer fullvol = mtotalVolume.get(string.ValueOf(p.get('year')));
                  decimal decvol = decimal.valueof(fullvol);
                  object obj = p.get('pid');
                  integer ipvol = integer.valueof(obj);
                  decimal dpvol = decimal.valueof(ipvol);
                  decimal op = (decvol/dpvol)*100;
                  decimal rd = op.setScale(2, RoundingMode.HALF_UP);
                  //yaxis = 'Year';
                  //titlename = 'By Year';
                 string ss = string.valueof(p.get('year'));
                 system.debug('the maplist is:::::::::::'+mapList);
                 projvolume.put(ss,rd);
                 system.debug('the projvolume:::::::::::'+projvolume);
                 //dataVolumelist.add(new Data(ss, rd));
                  
              }
          }     
 
/****************************************************************Halfyearly Calculation for Volume***********************************************************************/
 
  /*integer vol1=0;
         integer vol2=0;
         integer vol3=0;
         integer vol4=0;
         for(AggregateResult ar:[select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(quote__c.Project__c) pname from Quote__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c)>=2012 AND Order_Number__c>1 AND Order_Number__c>0 AND (NOT Project_Name__c LIKE '%Test%') AND (NOT Project_Name__c LIKE '%TEST%') AND (NOT Project_Name__c LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c),CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY  CALENDAR_YEAR(Order_Finalized_Date__c),CALENDAR_QUARTER(Order_Finalized_Date__c)  ASC]){                
             
                 
                 if(Integer.valueof(ar.get('quarter'))==1)
                 {                   
                     vol1= Integer.Valueof(ar.get('cid'));
                 }
                 else if(Integer.valueof(ar.get('quarter'))==2)
                 {                   
                     integer ct;
                     vol2= vol1+Integer.Valueof(ar.get('cid'));
                     ct = 1;
                     string Qyear=(ct+' '+(string.valueof(ar.get('yeardate'))));
                     mtotalVolumeHalf.put(Qyear, vol2);                    
                     vol1= 0;
                     vol2= 0;                    
                 }
                 else if(Integer.valueof(ar.get('quarter'))==3)
                 {                   
                     vol3= Integer.Valueof(ar.get('cid'));
                 }
                 else if(Integer.valueof(ar.get('quarter'))==4)
                 {                   
                     integer ct;
                     vol4 = vol3+Integer.Valueof(ar.get('cid'));
                     ct = 3;
                     string Qyear=(ct+' '+(string.valueof(ar.get('yeardate'))));
                     mtotalVolumeHalf.put(Qyear, vol4);                    
                     vol3 = 0;
                     vol4 = 0;                    
                 }                            
         }
         
         integer projvol1=0;
         integer projvol2=0;
         integer projvol3=0;
         integer projvol4=0;
         
         for(AggregateResult p:[select COUNT(id) pid, CALENDAR_YEAR(CreatedDate) year, CALENDAR_QUARTER(CreatedDate) projectquarter from Project__c WHERE CALENDAR_YEAR(CreatedDate)>=2012  AND (NOT Name LIKE '%Test%') AND (NOT Name LIKE '%TEST%') AND (NOT Name LIKE '%test%')  GROUP BY CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)ORDER BY  CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate) ASC]){  
         
                if(Integer.valueof(p.get('projectquarter'))==1)
                 {                   
                     projvol1= Integer.Valueof(p.get('pid'));
                 }
                 else if(Integer.valueof(p.get('projectquarter'))==2)
                 {                   
                     integer ct;
                     projvol2= projvol1+Integer.Valueof(p.get('pid'));
                     ct = 1;
                     string Qyear=(ct+' '+(string.valueof(p.get('year'))));
                     
                     integer mamount = mtotalVolumeHalf.get(Qyear);
                     decimal mamtdec = decimal.valueof(mamount);
                     decimal projdec = decimal.valueof(projvol2);
                     decimal op= (mamtdec/projdec)*100;
                     decimal rou =op.setScale(2, RoundingMode.HALF_UP);
                     //yaxis = 'Half Year';
                     //titlename = 'By Half Year';
                     string ss= 'H'+Qyear;
                     //dataVolumelist.add(new Data(ss, rou));
                     projVolumeHalf.put(ss, rou); 
                     system.debug('the projVolumeHalf:::::::::::'+projVolumeHalf);                   
                     projvol1 = 0;
                     projvol2 = 0;                    
                 }
                 else if(Integer.valueof(p.get('projectquarter'))==3)
                 {                   
                     projvol3= Integer.Valueof(p.get('pid'));
                 }
                 else if(Integer.valueof(p.get('projectquarter'))==4)
                 {                   
                     integer ct;
                     projvol4 = projvol3+Integer.Valueof(p.get('pid'));
                     ct = 3;
                     string Qyear=(ct+' '+(string.valueof(p.get('year'))));                    
                     integer mamount = mtotalVolumeHalf.get(Qyear);
                     decimal mamtdec = decimal.valueof(mamount);
                     decimal projdec = decimal.valueof(projvol4);
                     decimal op= (mamtdec/projdec)*100;
                     decimal rou =op.setScale(2, RoundingMode.HALF_UP);
                    // yaxis = 'Half Year';
                     //titlename = 'By Half Year';
                     string ss= 'H'+Qyear;
                    
                     projVolumeHalf.put(ss, rou); 
                     system.debug('the projVolumeHalf:::::::::::'+projVolumeHalf);
                                         
                     projvol3 = 0;
                     projvol4 = 0;                    
                 }                       
                           
           }  
 
/************************************************************Quarterly Calculation for volume********************************************************************/
   
   
   /* for(AggregateResult ar:[select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate,CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(quote__c.Project__c) pname from Quote__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c)>=2012 AND Order_Number__c>1 AND Order_Number__c>0 AND (NOT Project_Name__c LIKE '%Test%') AND (NOT Project_Name__c LIKE '%TEST%') AND (NOT Project_Name__c LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c),CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY  CALENDAR_YEAR(Order_Finalized_Date__c),CALENDAR_QUARTER(Order_Finalized_Date__c)  ASC]){
     
             string Qyear=(Integer.valueof(ar.get('quarter')))+' '+(string.valueof(ar.get('yeardate')));
             mtotalVolumeQuarter.put(Qyear, Integer.Valueof(ar.get('cid')));
      
         }  
         
         for(AggregateResult p:[select COUNT(id) pid, CALENDAR_YEAR(CreatedDate) year, CALENDAR_QUARTER(CreatedDate) projectquarter from Project__c WHERE CALENDAR_YEAR(CreatedDate)>=2012  AND (NOT Name LIKE '%Test%') AND (NOT Name LIKE '%TEST%') AND (NOT Name LIKE '%test%')  GROUP BY CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate)ORDER BY  CALENDAR_YEAR(CreatedDate),CALENDAR_QUARTER(CreatedDate) ASC]){  
         
         String PQYear=(Integer.valueof(p.get('projectquarter')))+' '+(string.valueof(p.get('year'))); 
 
         if(PQYear!=null && mtotalVolumeQuarter.containsKey(PQYear))
         {
             integer tvol = mtotalVolumeQuarter.get(PQYear);
             decimal dvol = decimal.valueof(tvol);
             object obj = p.get('pid');
             integer ipvol = integer.valueof(obj);
             decimal pvol = decimal.valueof(ipvol);
             decimal op = (dvol/pvol)*100;
             decimal rd = op.setScale(2, RoundingMode.HALF_UP);
              projVolumeQuarter.put(PQYear, rd);
              system.debug('The projVolumeQuartervalues are:::::::::'+projVolumeQuarter);
            
            string ss2 = string.valueof(PQyear);  
            string  nn2 = labelname+ss2;
     Integer Vcommission = Integer.valueof(mtotalVolumeQuarter.get(PQyear));
     Integer Vamount = Integer.valueof(p.get('pid'));
     system.debug('the Vamount is:::::::::::'+Vamount );
     System.debug('Vcommission:::::::::::::::'+Vcommission );
     system.debug('the nn2 is:::::::::::'+nn2);
       
       Decimal yearvolume=projvolume.get(string.valueof(p.get('year')));
   system.debug('the yearvolume:::::::::::'+yearvolume);
   
   Decimal Volumehalfyears=projVolumeHalf.get(string.valueof(p.get('year')));
   system.debug('the Volumehalfyears:::::::::::'+Volumehalfyears);


decimal ddvolume;
    if(projVolumeHalf.containskey('H'+PQYear))
    {
        ddvolume= projVolumeHalf.get('H'+PQYear);
        System.debug('ddvolumeeeeee'+ddvolume);
    }



WrapListVolume  Wvolume;
   if(nn2.contains('Q1'))
   {
    Wvolume=new WrapListVolume(nn2,Vcommission ,Vamount, rd, ddvolume, yearvolume);
    }   
    else if(nn2.contains('Q3'))
    {
       Wvolume=new WrapListVolume(nn2,Vcommission ,Vamount,rd, ddvolume, 0);
    }
    else
    {
        Wvolume=new WrapListVolume(nn2,Vcommission ,Vamount,rd,0,0);
    }
       
       dataListVolume.add(Wvolume);
       }
      }   
}
     
/*******************Wrapper Class*****************/

/*public class WrapList{
        public String yearname{ get; set; }
        public Integer totalOrderAmount{ get; set; }
         public Integer projectAmount{ get; set; }
         public decimal successRatio{ get; set; } 
         public decimal halfyearSuccessRatio{get; set;}
         Public decimal yearSuccessRatio{get; set;}
       
 /*******************Wrapper Class Constructor**************/      
      /*public WrapList(String yearname,Integer totalOrderAmount,Integer projectAmount, Decimal successRatio,Decimal halfyearSuccessRatio,Decimal yearSuccessRatio) {
            this.yearname= yearname;
            this.totalOrderAmount=totalOrderAmount;
            this.projectAmount= projectAmount;
            this.successRatio=successRatio;
            this.halfyearSuccessRatio=halfyearSuccessRatio;
            this.yearSuccessRatio=yearSuccessRatio;
           
        }
    }
    
  /*******************Wrapper Class For Volume*****************/

/*public class WrapListVolume{
        public String yearname{ get; set; }
        public Integer totalOrderAmount{ get; set; }
         public Integer projectAmount{ get; set; }
         public decimal successRatio{ get; set; } 
         public decimal halfyearSuccessRatio{get; set;}
         Public decimal yearSuccessRatio{get; set;}
       
/*******************Wrapper Class Constructor For Volume**************/      
      /*public WrapListVolume(String yearname,Integer totalOrderAmount,Integer projectAmount, Decimal successRatio,Decimal halfyearSuccessRatio,Decimal yearSuccessRatio) {
            this.yearname= yearname;
            this.totalOrderAmount=totalOrderAmount;
            this.projectAmount= projectAmount;
            this.successRatio=successRatio;
            this.halfyearSuccessRatio=halfyearSuccessRatio;
            this.yearSuccessRatio=yearSuccessRatio;
           
        }
    }  
}*/