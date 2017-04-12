global class retrieveObjectDetails{

public string searchOrder {
        get;
        set;
    }

    public string searchProject {
        get;
        set;
    }

 public string searchQuote {
        get;
        set;
    }
 
 public String searchText { 
         get ;
         set;
  }
  
  public List<Order> orderList {get;set;}
   public list<orderprojquote> searchResults {get;set;}
   
     public Boolean noSearchResults {
        get;
        set;
    }
    public list <displayDetails> orderdetailslst {
        get;
        set;
    }  

 public retrieveObjectDetails() {
 orderList=new list<order>();
 
 searchResults= new list<orderprojquote>();
 orderdetailslst =new list<displayDetails>();

  }

   
   public pageReference dosearch(){
  
    searchResults = new list<orderprojquote>() ;
    noSearchResults = true;
        
     String searchOrder= 'Select Id, Name,Order_Confirmation_Started__c,Nana_Order_Mfg__c,EffectiveDate,Complete_Signoff_Date__c,Deposit_Date__c,Deposit_Received_Date__c,Deposit_Amount__c,Order_Finalized_Date__c,Payment_Type__c,Initial_Deposit_Description__c,Invoices_Sent_Date__c,Balance_Received_Amount__c,IN_Actual_Delivery_Date_c__c,Balance_Received_Date__c  from Order' + ' where Name like \'%'+searchText+'%\' order by Name Limit 500';
        
      orderList = Database.query(searchOrder); 
     System.debug('orderrrrrrrrrrrrrrrrr'+orderList); 
     
     list<Case> caseList=[select id,Order__c,CaseNumber from case where Order__c IN :orderlist];
      System.debug('Casesss'+caseList);
     
      list<Installation__c> installationList=[select id,Name,Order__c from Installation__c where Order__c IN :orderlist ];
      System.debug('Installations'+installationList);
     
     
     if (orderList.size() > 0) {
            noSearchResults = false;
        }


        //Warning message if the search didn't return any result
        if (noSearchResults) {

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Your search did not return any result.'));
          


        }

       for (Order ord: orderList) {
            orderprojquote ordWrapp = new orderprojquote(ord);
            searchResults.add(ordWrapp);
        }
        
          for (Case cas: caseList) {
            orderprojquote caseWrapp = new orderprojquote(cas);
            searchResults.add(caseWrapp);
        }

        for (Installation__c insta: installationList) {
            orderprojquote instaWrapp = new orderprojquote(insta);
            searchResults.add(instaWrapp);
        }



     for (Order ord: orderList) {
            displayDetails ordWrapp = new displayDetails(ord,ord.Order_Confirmation_Started__c,installationList,caseList);
            orderdetailslst.add(ordWrapp);
        }
        system.debug('The orderdetailslst is::::'+orderdetailslst);
         /* for (Case cas: caseList) {
            displayDetails caseWrapp = new displayDetails(cas);
            orderdetailslst.add(caseWrapp);
        }

        for (Installation__c insta: installationList) {
            displayDetails instaWrapp = new displayDetails(insta);
            orderdetailslst.add(instaWrapp);
        }
*/




     
     
       return null;
       
      }    
      
      
//Wrapper class for displaying         
         
         
         
         
global class displayDetails {



        public Order order {
            get;
            set;
        }
        public List<Installation__c> installation {
            get;
            set;
        }
        public List<Case> cases {
            get;
            set;
        }
    
        public Date ocs {
            get;
            set;
        }
        
        
      
  
       public displayDetails(Order odd,Date ocs,List<Installation__c> ins,List<Case> cas ) {
            this.Order = odd;
             this.ocs = odd.Order_Confirmation_Started__c;
            this.installation=ins;
            this.cases=cas;
 }     
      
   }   
      
    
      
      
      
      
      
      
      
      
      
      
      
      
      
    //For Searching Orders  
      
       public class orderprojquote {
        
        public Project__c project {get ;set;}
        public Order orderr {get;set;} 
        public Quote__c quote {get;set;}
        public Installation__c insta {get;set;}
        public Case cas {get;set;}
        public String objtype {
            get;
            set;
        }
        public String recName {
            get;
            set;
        }
        public String recordId {
            get;
            set;
        }

     
        public orderprojquote(Order ord) {
            this.Orderr = ord;
            this.objtype = 'Order';
            this.recName = ord.Name;
            this.recordId = ord.Id;
          }
         
         public orderprojquote(Case cas) {
            this.Cas = cas;
            this.objtype = 'Case';
           // this.recName = cas.Name;
            this.recordId = cas.Id;
          }
         


         public orderprojquote(Installation__c insta) {
            this.Insta = insta;
            this.objtype = 'Installation';
            this.recName = insta.Name;
            this.recordId = insta.Id;
          }
         

         
         
         
         
         
         
         
         
          
     }   
        
}