public class NanaWallCLass 
{       
    // Count The Project Won
        public integer ProjWon{get;set;}
    // Count The Project Order In Process
        public integer ProjOrderInProgress{get;set;}
    // Count The Project quote In Process
        public integer ProjQuoteInProgress{get;set;}
    // Count The Project Lost
        public integer ProjLost{get;set;}
    // Count The Project Duplicate
        public integer ProjDuplicate{get;set;}
    // Count The Project Closer Rate Percantage 
        public integer ProjClosureRate{get;set;}
    // Count The Project Amount Won
        public integer ProjAmountWon{get;set;}
    // Count The Project Amount in Process
        public integer ProjAmountInProgressWon{get;set;}
    // Count The Project Won
        public integer ProjQuoteAmountInProgress{get;set;}
    // Count The Project Won
        public integer ProjAmountLost{get;set;}
    // Count The Project Total Amount
        public integer ProjTotalAmount{get;set;}
    
        // Latest Order Finalaize Date
        public list<order> latestOrderDate {get;set;}
       // Store all the data ragarding Account which have project except contact role 
        public list <project__c> AccountWithProjects{get;set;}
        // Account the number site on particular account
         public integer SiteCount {get;set;}
        // hold the value for the queotelss account
        public List<Opportunity> CAProjOppList{get;set;}
        // get runtime id of the account 
        public id AccId{get;set;}
        //Pagination varibles and List
        public integer PaginationSize {get;set;}
        public integer NoOfRecords {get;set;}
        // record select options for pagination Account which does not have projects
        public List<selectoption> PaginationSizeOptions {get;set;}      
        
       // Main class Constructor for all data inilization
        public NanaWallCLass(ApexPages.StandardController setCon) 
        {
            AccId = ApexPages.currentPage().getParameters().get('id');
            
            // Inilize all summary Account Data to the Zero
            ProjWon =0;
            ProjOrderInProgress =0;
            ProjQuoteInProgress=0;
            ProjTotalAmount=0;
            ProjLost=0;
            ProjDuplicate=0;
            ProjClosureRate=0;
            ProjAmountWon=0;
            ProjAmountInProgressWon=0;
            ProjQuoteAmountInProgress=0;
            ProjAmountLost=0;
            ProjTotalAmount=0;
            
            // Count the total Site of the projects
            SiteCount=[select count() from account where parent.id =:accid];
            
            //get the latest order finalize Date from orders
            latestOrderDate = [select Order_Finalized_Date__c, project__r.Purchaser_Account__c, account.id from order where project__r.Purchaser_Account__c=:AccId  AND Order_Finalized_Date__c!=null order By Order_Finalized_Date__c DESC LIMIT 1]; 
            
            // Fire Query on Project Object and get all related data except contact Role
               String query1 ='SELECT Id,(Select Id,Name,CreatedDate, Order_Finalized_Date__c From Orders__r), Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,';
               query1+='Architect_Account__c,Ordering_Account__c, Brand_Name_Account__c, End_Customer_Account__c,End_Customer_Account__r.Name, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c, ';
               query1+='(Select Id, Name, AccountId,Project_Name__c from Opportunities__r where (StageName like \'%Won%\' OR StageName like \'%Complete%\' OR StageName like \'%Paid%\') AND (NOT StageName LIKE \'%Influencer%\'))';
               query1+=' FROM Project__c';
               query1+=' WHERE (Architect_Account__c = :AccId OR Brand_Name_Account__c = :AccId OR End_Customer_Account__c = :AccId '; 
               query1+=' OR Franchise_Account__c = :AccId OR Franchisor_Account__c = :AccId OR Other_Influencer_Account__c = :AccId '; 
               query1+=' OR Purchaser_Account__c =:AccId OR Ordering_Account__c =:AccId ) ';
            
            //Assign Query REsults to the project List type Projects
             AccountWithProjects = database.query(query1);
            
            
            /*********QuoteLess Opprotunities *******************/
            CAProjOppList = [select id, name, stagename , Quote_Count__c,Project_Name__r.Name, Project_Name__r.Purchaser_Account__c  from opportunity where (stagename='Need Analysis' OR stagename='Drawings - Provided' OR stagename='Drawings - Requested') AND Project_Name__r.Purchaser_Account__c =:AccId AND Quote_Count__c=0];
            // Pagination Default Page Size 
            PaginationSize =25;
            // User Can select Pagination Size from this options
            paginationSizeOptions = new List<selectoption>();
            // Page size options on Account which does not have project
            paginationSizeOptions.add(new selectoption('25','25'));
            paginationSizeOptions.add(new selectoption('100','100'));
            paginationSizeOptions.add(new selectoption('150','150'));
            paginationSizeOptions.add(new selectoption('200','200'));
            paginationSizeOptions.add(new selectoption('250','250'));
            
            
            for(project__c proj : AccountWithProjects)
            {
            
            // Count the Project Won
             if (proj.Stage__c != null && (proj.Stage__c.contains('Closed Complete - Ordered - Paid')))
                {
                    ProjWon = ProjWon + 1;
                    
                }
            
            if(proj.Stage__c.contains('Closed Won - Order In Process') || proj.Stage__c.contains('Closed Won - Order Signed') || proj.Stage__c.contains('Order - Negotiation') || proj.Stage__c.contains('Project On Hold') && proj.Orders__r.size()>0)
                {
                ProjOrderInProgress = ProjOrderInProgress + 1; 
                    
                   
            }
            
            // Count the Duplicate Project in this Account
            if(proj.Stage__c.contains('Duplicate'))
                {
                    ProjDuplicate = ProjDuplicate + 1;
                }   
            
            }
        }
    
    
    public ApexPages.StandardSetController setCon 
    {
        get {
            if(setCon == null) {  
               
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [SELECT Account.Name FROM Account WHERE parent.id =:AccId AND Account.Id NOT IN (SELECT project__C.End_Customer_Account__c FROM project__c)]));
                setCon.setPageSize(Paginationsize);  
                noOfRecords = setCon.getResultSize(); 
                return setcon;
                
            }            
            return setCon;
        }
        set;
    }
    //Changes the size of pagination
    public PageReference refreshPageSize() 
    {
         setCon.setPageSize(PaginationSize);
         return null;
    }
 
    // Initialize setCon and return a list of record    
     
    public List<account> getAccountsData()
    {
         return (List<Account>) setCon.getRecords();
    }
}