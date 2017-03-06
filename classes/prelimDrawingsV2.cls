/************************************************
Purpose:This is for building a page to show the projects,quotes and order stages for prelim drawings
Created Date:December 2015
*************************************************/
public class prelimDrawingsV2 {
    
    public List<wrapperquote> wraplist1{get;set;}
    public List<wrapperquote> wraplist2{get;set;}
    public List<wrapperquote> wraplist3{get;set;}   
    public List<wrapperquote> wraplist4{get;set;}
    public List<wrapperquote> wraplist5{get;set;}
    
    public integer count{get;set;}
    public integer count1{get;set;}
    public integer count2{get;set;}
    public integer count3{get;set;}
    public integer count4{get;set;}
    public double Amount{get;set;}
    public double Amount1{get;set;}
    public double Amount2{get;set;}
    public double Amount3{get;set;}
    public DOUBLE Amount4{get;set;}
    
    public double prtAmount = 0; //For calculating Project Amount
    public double prtAmount1 = 0; //For calculating Project Amount
    public double prtAmount2 = 0; //For calculating Project Amount
    public double prtAmount3 = 0; //For calculating Project Amount
    public double prtAmount4 = 0; //For calculating Project Amount
    
    
   
     /****************************************************Constructor for class*********************************************************/
     /****************************************************Order Started Stage***********************************************************/
     
     public prelimDrawingsV2(){     
        Date baldate = Date.newinstance(2006,12,31);       
        wraplist1 = new List<wrapperquote>();
        wraplist2 = new List<wrapperquote>();
        wraplist3 = new List<wrapperquote>();
        wraplist4 = new List<wrapperquote>();
        wraplist5 = new List<wrapperquote>();
        
        List<Quote__c>  prtlist = [SELECT Name, SubTotal__c ,Custom_Drawing__c,Drawing_Notes__c,Balance_Received__c,Opportunity__r.Owner.Name,Contact__r.Owner.Name, Order_Number__c,Unique_Models__c, Nana_Link__c, Project__r.Name, Project__r.Corporate_Account__c,Project__r.Residential_Vertical__c, Project__r.Preliminary_Drawings__c,Contact__r.Email,Balanced_Received_Date__c, Contact__r.Phone, Contact__r.Name, Drawing_Deposit_Amount__c, Drawing_Initial_Deposit_Description__c,Drawing_Revision_1_Date__c,Drawing_Revision_2_Date__c,Drawing_Revision_3_Date__c,Drawing_Revision_4_Date__c,Drawing_Revision_5_Date__c,Drawing_Revision_6_Date__c,Drawing_Revision_7_Date__c,Drawing_Revision_8_Date__c,Drawing_Deposit__c,Drawing_Order_Confirmation_Signoff__c, Drawing_Customer_Drawings_Received__c,Order_Confirmation_Started__c, Project__r.Amount__c,Drawing_Eng_Clarification_Contact__c, Drawing_Complete__c,Drawing_Internal_Approval__c,Drawing_Final_Documents_Sent__c, Drawing_First_Submittal_Order_Sent__c,Drawing_Thirty_Percent_Deposit_Amount__c,Drawing_Additional_Payment_Received__c, Drawing_Final_Order_Confirmation__c, Drawing_Final_Signoff__c, Order_Finalized_Date__c, Drawing_On_Hold_Till_Date__c, Project__r.Stage__c from Quote__c where  Custom_Drawing__c=True and Order_Number__c > 0 and Pipeline_Notes__c!='dead' and Balanced_Received_Date__c!=: baldate and Project__r.Stage__c!='Closed Complete - Ordered - Paid' and Project__r.Stage__c!='Closed Lost - Project Lost' and Project__r.Stage__c!='Closed Lost - Project Cancelled' and Project__r.Stage__c!='Closed - Inactivity' and Project__r.Stage__c!='Closed Lost - Project Lost,Proje'and Balanced_Received_Date__c = Null];
          system.debug('The prtlist is:::::::'+prtlist.size());
          
        /***************************************checking for each record in prtlist**************************************/
        
          for(Quote__c qt:prtlist){
            wrapperquote wrapQuote =new wrapperquote(qt); 
              
              /******************Conditions for Assigning the Drawing Owner*******************/
            
            if(qt.Project__r.Preliminary_Drawings__c == true){
              if(String.valueof(qt.Order_Number__c).startsWith('7')){
               wrapQuote.DrawingOwner = 'April/Dirk';
            }
            else{
            wrapQuote.DrawingOwner = 'Taha';
            }
            }
            if(qt.Project__r.Preliminary_Drawings__c == false){
              if(String.valueof(qt.Order_Number__c).startsWith('7')){
              wrapQuote.DrawingOwner = 'April/Dirk';
              }
              else{
               wrapQuote.DrawingOwner = 'Jurgen';
              }
            }
            
            if(qt.Project__r.Corporate_Account__c == True || qt.Project__r.Residential_Vertical__c == True){
            wrapQuote.ProjectCoordinator = 'Frieda Keeler ';
            }
            
            /*else if(qt.Unique_Models__c!=null && String.valueof(qt.Unique_Models__c).contains('HSW')){*/
            else if(qt.Custom_Drawing__c==True){
            wrapQuote.ProjectCoordinator = 'Corrin Baker';
            }
            
            else if(qt.SubTotal__c > 25000 ){
            wrapQuote.ProjectCoordinator = 'James Mann';
            }
            
            else {
             wrapQuote.ProjectCoordinator = 'Kevin Ou';
            }   
            
              /***********************************Order Process Started Stage*************************************/
             
            if((qt.Drawing_Deposit__c!=null ||qt.Drawing_Order_Confirmation_Signoff__c!=null /*|| qt.Drawing_Customer_Drawings_Received__c!=null*/ )||(!(qt.Drawing_Deposit__c!=null ||qt.Drawing_Order_Confirmation_Signoff__c!=null /*|| qt.Drawing_Customer_Drawings_Received__c!=null*/ ))){
                 if (!(qt.Drawing_Deposit__c!=null && qt.Drawing_Order_Confirmation_Signoff__c!=null /*&& qt.Drawing_Customer_Drawings_Received__c!=null*/)){
                    if(!(qt.Drawing_On_Hold_Till_Date__c != Null)){
                     wraplist1.add(wrapQuote); 
                     system.debug('The wraplist1 size:::::::::'+wraplist1.size());  
                    }  
                 }
             }     
                      system.debug('tHE WARAPLIST1 IS:::::::::::'+wraplist1);                         
                      count =  wraplist1.size();
              
              
            /************************************************Drawing Started Stage**************************************************/
         
           
       
             if(((qt.Drawing_Deposit__c!=null && qt.Drawing_Order_Confirmation_Signoff__c!=null /*&& qt.Drawing_Customer_Drawings_Received__c!=null*/) && (qt.Drawing_Eng_Clarification_Contact__c!=null || qt.Drawing_Complete__c!=null || qt.Drawing_Final_Documents_Sent__c!=null /*|| qt.Drawing_First_Submittal_Order_Sent__c!=null|| qt.Drawing_Customer_Drawings_Received__c!=null*/))||(qt.Drawing_Deposit__c!=null && qt.Drawing_Order_Confirmation_Signoff__c!=null /*&& qt.Drawing_Customer_Drawings_Received__c!=null*/)){
                 if(!(qt.Drawing_Eng_Clarification_Contact__c!=null && qt.Drawing_Complete__c!=null && qt.Drawing_Final_Documents_Sent__c!=null /*&& qt.Drawing_First_Submittal_Order_Sent__c!=Null && qt.Order_Finalized_Date__c!=null*/&& qt.Drawing_Customer_Drawings_Received__c!=null )){                
                     
                     if(!(qt.Drawing_On_Hold_Till_Date__c != Null)){
                     wraplist2.add(wrapQuote);   
                     system.debug('The wraplist2 size:::::::::'+wraplist2.size());
                     }          
                 }
             }
             count1 =  wraplist2.size();
          
             
           
                /***************************************************Order Finalization Process Started*******************************************************/
            
         
             if((qt.Drawing_Deposit__c!=null && qt.Drawing_Order_Confirmation_Signoff__c!=null && qt.Drawing_Customer_Drawings_Received__c!=null) && (qt.Drawing_Eng_Clarification_Contact__c!=null && qt.Drawing_Complete__c!=null  && qt.Drawing_Final_Documents_Sent__c!=null /*&& qt.Drawing_First_Submittal_Order_Sent__c!=null && qt.Order_Finalized_Date__c!=null*/)&&((qt.Drawing_Additional_Payment_Received__c!=null || qt.Drawing_Final_Order_Confirmation__c!=null|| qt.Drawing_Final_Signoff__c!=null /*||qt.Order_Finalized_Date__c!=null*/)||(qt.Drawing_Deposit__c!=null && qt.Drawing_Order_Confirmation_Signoff__c!=null && qt.Drawing_Customer_Drawings_Received__c!=null) && (qt.Drawing_Eng_Clarification_Contact__c!=null && qt.Drawing_Complete__c!=null && qt.Drawing_Final_Documents_Sent__c!=null /*&& qt.Drawing_First_Submittal_Order_Sent__c!=null && qt.Order_Finalized_Date__c!=null*/))){
                if(!(qt.Drawing_Additional_Payment_Received__c!=null && qt.Drawing_Final_Order_Confirmation__c!=null && qt.Drawing_Final_Signoff__c!=null && qt.Order_Finalized_Date__c!=null)){  
                    if(!(qt.Drawing_On_Hold_Till_Date__c != Null)){
                    wraplist3.add(wrapQuote);
                    system.debug('the wraplist3 size is::::'+wraplist3.SIZE());
                    }
                 }
             }
             count2 =  wraplist3.size();
             
             /***************************************************Orders On-hold Stage*******************************************************/
             
           /*  if(qt.Drawing_Deposit__c!=null && qt.Drawing_Order_Confirmation_Signoff__c!=null && qt.Drawing_Customer_Drawings_Received__c!=null && qt.Drawing_Eng_Clarification_Contact__c!=null && qt.Drawing_Complete__c!=null && qt.Drawing_Final_Documents_Sent__c!=null && qt.Drawing_First_Submittal_Order_Sent__c!=null && qt.Drawing_Additional_Payment_Received__c!=null && qt.Drawing_Final_Order_Confirmation__c!=null && qt.Drawing_Final_Signoff__c!=null && qt.Order_Finalized_Date__c!=null && qt.Drawing_On_Hold_Till_Date__c==null){
              if(!(qt.Drawing_Deposit__c!=null && qt.Drawing_Order_Confirmation_Signoff__c!=null && qt.Drawing_Customer_Drawings_Received__c!=null && qt.Drawing_Eng_Clarification_Contact__c!=null && qt.Drawing_Complete__c!=null && qt.Drawing_Final_Documents_Sent__c!=null && qt.Drawing_First_Submittal_Order_Sent__c!=null && qt.Drawing_Additional_Payment_Received__c!=null && qt.Drawing_Final_Order_Confirmation__c!=null && qt.Drawing_Final_Signoff__c!=null && qt.Order_Finalized_Date__c!=null && qt.Drawing_On_Hold_Till_Date__c!=null)){
               
                 wraplist4.add(wrapQuote);
                 system.debug('the wraplist4 size is::::'+wraplist4.size());
               }
             }
             if(qt.Drawing_On_Hold_Till_Date__c!=null && qt.Drawing_On_Hold_Till_Date__c >= System.Today()){
                 wraplist4.add(wrapQuote);
             }*/
             if(qt.Drawing_On_Hold_Till_Date__c!=null){
                 wraplist4.add(wrapQuote);
             }
             
             count3 =  wraplist4.size();
             
            
            /***************************************************Orders Finalized Stage*******************************************************/
            if((qt.Drawing_Deposit__c!=null && qt.Drawing_Order_Confirmation_Signoff__c!=null && qt.Drawing_Customer_Drawings_Received__c!=null && qt.Drawing_Eng_Clarification_Contact__c!=null && qt.Drawing_Complete__c!=null && qt.Drawing_Final_Documents_Sent__c!=null /*&& qt.Drawing_First_Submittal_Order_Sent__c!=null */&& qt.Drawing_Additional_Payment_Received__c!=null && qt.Drawing_Final_Order_Confirmation__c!=null && qt.Drawing_Final_Signoff__c!=null && qt.Order_Finalized_Date__c!=null)&&(qt.Balanced_Received_Date__c == null)){
               if(!(qt.Drawing_Deposit__c!=null && qt.Drawing_Order_Confirmation_Signoff__c!=null && qt.Drawing_Customer_Drawings_Received__c!=null && qt.Drawing_Eng_Clarification_Contact__c!=null && qt.Drawing_Complete__c!=null && qt.Drawing_Final_Documents_Sent__c!=null /*&& qt.Drawing_First_Submittal_Order_Sent__c!=null */&& qt.Drawing_Additional_Payment_Received__c!=null && qt.Drawing_Final_Order_Confirmation__c!=null && qt.Drawing_Final_Signoff__c!=null && qt.Order_Finalized_Date__c!=null && qt.Balanced_Received_Date__c != null)){
                 if(!(qt.Drawing_On_Hold_Till_Date__c != Null)){
                 wraplist5.add(wrapQuote);
                 system.debug('the wraplist5 size is::::'+wraplist5.size());
                 }
               }
            }
              count4 =  wraplist5.size();
         }
         /********************************Calculating the project amount for all stages********************************/
         for(wrapperquote q:wraplist1){
                if(q.ProjectAmount!=null){
                  prtAmount = prtAmount + q.ProjectAmount;
                     system.debug('The project amount is::'+prtamount);
                        Decimal toround1 = prtAmount;
                        Decimal rounded1 = toRound1.setScale(2, RoundingMode.HALF_UP);
                        system.debug(rounded1);
                        Amount = rounded1;
                }
          }
         //Amount = prtAmount;
         
         /******************Drawing Process Started stage:Project Amount**********************/
         for(wrapperquote q:wraplist2){
                if(q.ProjectAmount!=null){
                  prtAmount1 = prtAmount1 + q.ProjectAmount;
                     system.debug('The project amount is::'+prtamount1);
                    Decimal toround2 = prtAmount1;
                        Decimal rounded2 = toRound2.setScale(2);
                            system.debug(rounded2);
                    Amount1 = rounded2;
                }
              }
        // Amount1 = prtAmount1;
         /******************* Orders Finalization Process Started Stage: Project Amount***********************/
         for(wrapperquote q:wraplist3){
                if(q.ProjectAmount!=null){
                  prtAmount2 = prtAmount2 + q.ProjectAmount;
                     system.debug('The project amount is::'+prtamount2);
                     Decimal toround3 = prtAmount2;
                     Decimal rounded3 = toRound3.setScale(2, RoundingMode.HALF_UP);
                     system.debug(rounded3);
                     Amount2 = rounded3;
                }
              }
         //Amount2 = prtAmount2;
         
         /******************* Orders on - Hold Stage: Project Amount***********************/
         for(wrapperquote q:wraplist4){
                if(q.ProjectAmount!=null){
                  prtAmount3 = prtAmount3 + q.ProjectAmount;
                     system.debug('The project amount is::'+prtamount3);
                     Decimal toround4 = prtAmount3;
                     Decimal rounded4 = toRound4.setScale(2, RoundingMode.HALF_UP);
                     system.debug(rounded4);
                     Amount3 = rounded4;
                }
              }
         //Amount3 = prtAmount3;
         
         /******************* Orders Finalized Stage: Project Amount***********************/
         
         for(wrapperquote q:wraplist5){
                if(q.ProjectAmount!=null){
                  prtAmount4 = prtAmount4 + q.ProjectAmount;
                     system.debug('The project amount is::'+prtamount4);
                    Decimal toround = prtAmount4;
                        Decimal rounded = toRound.setScale(2, RoundingMode.HALF_UP);
                            system.debug('The rounded::::::'+rounded);
                    Amount4 = rounded;
                }
             
          }
         
     } //closing of the constructor

     
     
    /****************************************************Wrapper Class***********************************************************/
  
    public class wrapperquote{      
        
        public  string ProjectName {get;set;}
        public  string ProjectID {get;set;}
        public  string QuoteName {get;set;}
        public  string QuoteId {get;set;}
        public string ContactId{get;set;}
        public  decimal OrderNumber {get;set;}
        public  string ContactEmail{get;set;}
        public  string ContactPhone{get;set;}
        public  string ContactName{get;set;}
        public  string QuoteOwner{get;set;}
        public  string DrawingOwner{get;set;}
       // public  string ApprovedBy{get;set;}
        public  string ContactOwner{get;set;}
        public string stage{get;set;}
        //public boolean prelim{get;set;}
        public string IntialDescription{get;set;}
        public string ProjectCoordinator{get;set;}
        public string Modeltype{get;set;}
        public string notes{get;set;}
        public boolean conceptualdwg{get;set;}
        
        public  decimal orderamount{get;set;}
        public  date SignOff{get;set;}
        public  date Specs{get;set;}
        public  date Clarification{get;set;}
        public  date Complete{get;set;}
        public  date Approved{get;set;}
        //public  date sent{get;set;}
        public  date AdditionalPayment{get;set;}
        public  date OrderConfirmation{get;set;}
        public  date Signoff2{get;set;}
        public  date OrderFinalizedDate{get;set;}
        public  date DepositReceivedDate{get;set;}
        public  decimal projectamount{get;set;}
        public date OrderConfirmationStarted{get;set;}
        public date FirstSubmittalOrderSent{get;set;}
        public decimal ThirtyPercentDepositAmount{get;set;}
        public date OnHoldTillDate{get;set;}
        public DATE BalanceReceivedDate{get;set;}
        public decimal BalanceReceivedAmount{get;set;}
        Public date Revision1{get;set;}
        Public date Revision2{get;set;}
        Public date Revision3{get;set;}
        Public date Revision4{get;set;}
        Public date Revision5{get;set;}
        Public date Revision6{get;set;}
        Public date Revision7{get;set;}
        Public date Revision8{get;set;}
        
        
       
        /***************************************************Constructor for Wrapper class*********************************************************/
    public  wrapperquote(Quote__c quote1){
      
        ProjectName = quote1.Project__r.Name;
        ProjectID = quote1.Project__r.ID;
        QuoteName = quote1.Name ;
        QuoteId = quote1.Id ;    
        ContactId = quote1.Contact__r.Id;
        OrderNumber = quote1.Order_Number__c ;
        ContactEmail = quote1.Contact__r.Email;
        ContactPhone = quote1.Contact__r.Phone;
        ContactName = quote1.Contact__r.Name;
        QuoteOwner = quote1.Opportunity__r.Owner.Name;
        ContactOwner = quote1.Contact__r.Owner.Name;
        SignOff = quote1.Drawing_Order_Confirmation_Signoff__c;
        SignOff2 = quote1.Drawing_Final_Signoff__c;
        Specs = quote1.Drawing_Customer_Drawings_Received__c;
        Clarification = quote1.Drawing_Eng_Clarification_Contact__c;
        Complete = quote1.Drawing_Complete__c;
        Approved = quote1.Drawing_Internal_Approval__c;
        //sent = quote1.Drawing_Final_Documents_Sent__c;
        AdditionalPayment = quote1.Drawing_Additional_Payment_Received__c;
        OrderConfirmation = quote1.Drawing_Final_Order_Confirmation__c;
        orderamount = quote1.Drawing_Deposit_Amount__c;
        stage = quote1.Project__r.Stage__c;
        OrderFinalizedDate = quote1.Order_Finalized_Date__c;
        DepositReceivedDate=quote1.Drawing_Deposit__c;
        projectamount = quote1.Project__r.Amount__c;
        OrderConfirmationStarted = quote1.Order_Confirmation_Started__c;
        FirstSubmittalOrderSent = quote1.Drawing_Final_Documents_Sent__c;
        ThirtyPercentDepositAmount = quote1.Drawing_Thirty_Percent_Deposit_Amount__c;
        OnHoldTillDate = quote1.Drawing_On_Hold_Till_Date__c;
        BalanceReceivedDate = quote1.Balanced_Received_Date__c;
        BalanceReceivedAmount = quote1.Balance_Received__c;
        //prelim = quote1.Project__r.Preliminary_Drawings__c;
         Revision1 = quote1.Drawing_Revision_1_Date__c;
         Revision2 = quote1.Drawing_Revision_2_Date__c;
         Revision3 = quote1.Drawing_Revision_3_Date__c;
         Revision4 = quote1.Drawing_Revision_4_Date__c;
         Revision5 = quote1.Drawing_Revision_5_Date__c;
         Revision6 = quote1.Drawing_Revision_6_Date__c;
         Revision7 = quote1.Drawing_Revision_7_Date__c;
         Revision8 = quote1.Drawing_Revision_8_Date__c;
         IntialDescription = quote1.Drawing_Initial_Deposit_Description__c;
         Modeltype = quote1.Unique_Models__c;
         notes = quote1.Drawing_Notes__c;
         conceptualdwg = quote1.Project__r.Preliminary_Drawings__c;
       }
       
    }
    
}