public class ashokHierarchyControll 
{

       //this list collects project count site counts to display on visualforce page
       public transient list<project__c> ProjSiteList{get;set;}
       // this list to count all sites to display on visualforce page  
       public list <account> AccSiteList{get;set;} 
       // list the ordering date 
       public list<order> rectDate{get;set;}   
        public String SortingExpression = 'name';
        public String DirectionOfSort = 'ASC';
    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;} 
   // summry report varibles
       public Account ObjAcc{get;set;}       
       public integer siz{get;set;}
       public integer PrjWon{get;set;}
       public integer psize{get;set;}
       public Integer prjStgWon{get;set;}
       public Integer prjStgPrg{get;set;}
       public Integer prjStgQtd{get;set;}
       public Integer prjStglost{get;set;}
       public integer DuplPrj{get;set;}
       public Decimal prjStgWonAmt{get;set;}
       public Decimal prjStgPrgAmt{get;set;}
       public Decimal prjStgQtdAmt{get;set;}
       public Decimal prjStglostAmt{get;set;}
       public double totalamount{get;set;}
       public double amount{get;set;}
       public double amountwon{get;set;}
       public datetime RecentOrdeDate{get;set;} 
        
    
   
    
     
    // Constructor for the class
     public ashokHierarchyControll(ApexPages.StandardController con)
    
    {
          ProjSiteList = new List<Project__c>();
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(ProjSiteList);
        RecentOrdeDate = null;    
        size=10;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        paginationSizeOptions.add(new SelectOption('200','200'));        
        objAcc = (Account)con.getRecord();     
        AccSiteList = new List<Account>();       
        rectDate = new List<order>();
         //inilize all variebles counters to zero 
         //init variable     
        
        totalAmount = 0.0;
        amountWon = 0.0;
        size = 0;
        psize = 0;
        prjWon = 0;
        prjStgQtd = 0;
        prjStglost=0; 
        prjStgPrg = 0;
        prjStgWon = 0;
        prjStgQtdAmt = 0.0;
        prjStglostAmt = 0.0;
        prjStgPrgAmt = 0.0;
        prjStgWonAmt = 0.0; 
        DuplPrj =0;                        
                       
                       
         //list contains all site count under the parent account  (site count)            
        AccSiteList = [Select Name, Id from Account where Parent.Id = :string.valueOf(ObjAcc.Id).left(15)];  
       
            
        for(Project__c proj :ProjSiteList )
        {
              
              // count total amount of all projects
               if(proj.amount__c != null)
               {
               
                   TotalAmount = TotalAmount + proj.amount__C;
               }   
               
               // counts project in progress and project in progress amount 
                if(proj.Stage__c.contains('Prospecting') || proj.Stage__c.contains('Design') || 
                proj.Stage__c.contains('Bidding') || proj.Stage__c.contains('Awarded') || proj.Stage__c.contains('Order - Negotiation'))
               
                {
                        prjStgPrg = prjStgPrg +1; 
                        prjStgPrgAmt = prjStgPrgAmt + proj.Amount__c;     
                }
                
                 // count project won and project won amount
                
                 if (proj.Stage__c != null && (proj.Stage__c.contains('Closed Won') || proj.Stage__c.contains('Closed Complete')))
                {
                    prjWon = prjWon + 1;
                    amountWon = amountWon + proj.Amount__c;
                    prjStgWon = prjStgWon + 1;
                    prjStgWonAmt = prjStgWonAmt + proj.Amount__c; 
                }
                
                // count project lost and  project lost amount
                
                if(proj.Stage__c.contains('Closed Lost - Project Lost')||proj.Stage__c.contains('Closed - Inactivity')
                ||proj.Stage__c.contains('On Hold')||proj.Stage__c.contains('Cancelled'))
            {
                
                prjStglost = prjStglost + 1;
                
                if(proj.Amount__c!=NULL)
                prjStglostAmt = prjStglostAmt + proj.Amount__c;
            }
            
            // count project queated amount and project lost amount
            
            if(proj.Stage__c.contains('Quoted') || (proj.Stage__c.contains('On Hold') && proj.Orders__r.size()==0))
            {
                
                prjStgQtd = prjStgQtd + 1;
                
                if(proj.Amount__c!=NULL)
                {
                        prjStgQtdAmt = prjStgQtdAmt + proj.Amount__c;
                }
                
            }
            if(proj.Stage__C.contains('Duplicate'))
            {
            
                DuplPrj = DuplPrj +1;
            }
        
        
        }
        
               
     }
    public String ExpressionSort 
    {
        get 
        {
            return SortingExpression;
        }
        set 
        {
                    If(value == SortingExpression) 
                    {
                            DirectionOfSort = (DirectionOfSort == 'ASC')? 'DESC' : 'ASC';
                    }
            else 
            {
                DirectionOfSort = 'ASC';
                SortingExpression = value;
            }
        }

    }
    public String getDirectionOfSort() 
    {
        If(SortingExpression == Null || SortingExpression == '') 
        {
            return 'DESC';
        }
        else 
        {
            return DirectionOfSort;
        }
    }
    public void setDirectionOfSort(String value) 
    {
        DirectionOfSort = value;
    }
    public list<project__C> getproject()
    {
        return ProjSiteList;
    }
    public PageReference ViewData() 
     {
         string sortFullExp = SortingExpression + ' ' + DirectionOfSort ;       
        

            return null;
    }
    public ApexPages.StandardSetController setCon 
        {
        get 
        {
            if(setCon == null) 
            {                
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                                                [Select Name, Id, Type, (Select Name,CreatedDate,Architect_Account__r.Name, Ordering_Account__c,
                                                       Ordering_Account__r.Name, Amount__c,Application__c,RecordType.Name,
                                                       Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,Id,
                                                       Architect_Account__c, Purchaser_Account__c, 
                                                       Purchaser_Account__r.Name from Projects1__r ) from Account 
                                                       where Parent.Id = :string.valueOf(ObjAcc.Id).left(15)]));
                        setCon.setPageSize(size);  
                        noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
        
     //Changes the size of pagination
    public PageReference refreshPageSize() {
         setCon.setPageSize(size);
         return null;
    }
 
    // Initialize setCon and return a list of record    
     
                public List<account> getprojects() {
                return (List<account>) setCon.getRecords();
    }
}