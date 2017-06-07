public class NanaWallCLass 
{
        public list <project__c> AccountWithProjects{get;set;}
        // ccount the number site on particular account
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
        
        public NanaWallCLass(ApexPages.StandardController setCon) 
        {
            AccId = ApexPages.currentPage().getParameters().get('id');
            // Count the total Site of the projects
            SiteCount=[select count() from account where parent.id =:accid];
            String query1 ='SELECT Id,(Select Id,Name,CreatedDate, Order_Finalized_Date__c From Orders__r), Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,';
               query1+='Architect_Account__c,Ordering_Account__c, Brand_Name_Account__c, End_Customer_Account__c,End_Customer_Account__r.Name, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c, ';
               query1+='(Select Id, Name, AccountId,Project_Name__c from Opportunities__r where (StageName like \'%Won%\' OR StageName like \'%Complete%\' OR StageName like \'%Paid%\') AND (NOT StageName LIKE \'%Influencer%\'))';
               query1+=' FROM Project__c';
               query1+=' WHERE (Architect_Account__c = :AccId OR Brand_Name_Account__c = :AccId OR End_Customer_Account__c = :AccId '; 
               query1+=' OR Franchise_Account__c = :AccId OR Franchisor_Account__c = :AccId OR Other_Influencer_Account__c = :AccId '; 
               query1+=' OR Purchaser_Account__c =:AccId OR Ordering_Account__c =:AccId ) ';
            
            AccountWithProjects = database.query(query1);
            
            
            /*********QuoteLess Opprotunities *******************/
        CAProjOppList = [select id, name, stagename , Quote_Count__c,Project_Name__r.Name, Project_Name__r.Purchaser_Account__c  from opportunity where (stagename='Need Analysis' OR stagename='Drawings - Provided' OR stagename='Drawings - Requested') AND Project_Name__r.Purchaser_Account__c =:AccId AND Quote_Count__c=0];
            // Pagination option 
            PaginationSize =25;
            paginationSizeOptions = new List<selectoption>();
            paginationSizeOptions.add(new selectoption('25','25'));
            paginationSizeOptions.add(new selectoption('100','100'));
            paginationSizeOptions.add(new selectoption('150','150'));
            paginationSizeOptions.add(new selectoption('200','200'));
            paginationSizeOptions.add(new selectoption('250','250'));
            
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