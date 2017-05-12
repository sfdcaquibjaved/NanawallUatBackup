public class HierarchyController_nishant1{
    
    public Set<Id> SetOr{get;set;}
    public List<ProjectWrapper> records{get;set;} 
    public string sortFullExp{get;set;}
    public List <Account> AccSiteList{get;set;}
    public  integer DuplPrj{get;set;}    
    public Account ObjAcc{get;set;}    
    public String prjStsFilter{get;set;}
    public List<Project__c> ProjSiteList{get;set;}
    public Integer prjWon {get;set;}
    public Integer siz {get;set;}
    public Integer psiz {get;set;}
    public String rltype {get;set;}
    public Account AccRelatedList{get;set;}  
    public Project__c [] ProjectListBkp{get;set;}
    public Double amountWon{get;set;}
    public Double totalAmount{get;set;}
    private String sortDirection = 'ASC';
    private String sortExp = '';
    public List<String> acclist;
    public List<Order> ordList{get;set;}
    public LIST<Contact> contrls{get;set;}
    public LIST<Project__c> prjList2{get;set;}
    public LIST<Opportunity> oppList2{get;set;}
    public LIST<List<Opportunity>> oppList3{get;set;}
    public Integer prjStgWon{get;set;}
    public Integer prjStgPrg{get;set;}
    public Integer prjStgQtd{get;set;}
    public Integer prjStglost{get;set;}
    public Decimal prjStgWonAmt{get;set;}
    public Decimal prjStgPrgAmt{get;set;}
    public Decimal prjStgQtdAmt{get;set;}
    public Decimal prjStglostAmt{get;set;}
    public String relType{get;set;}
    public String prjFilter{get;set;}
    public String cityFilter{get;set;}
    public String stateFilter{get;set;}
    public String zipFilter{get;set;}
    public String archFilter{get;set;}
    public String purFilter{get;set;}
    public String ordFilter{get;set;}
    public String appIndFilter{get;set;}
    public String accFilter{get;set;}
    public Date ordFnzDtMax{get;set;}
    public String ordby;
    public Set<ID> oppIDSet{get;set;}
    public Set<ID> oppAccSet{get;set;}
    public Hierarchy [] ProjectList{get;set;}
    datetime RecentCreateDate;

    
   // Public Set<Id> SetTest{get;set;}
   
    public class Hierarchy {
        
        //public Account accountName{get;set;}
        public Project__c projectName{get;set;}
        public Double amount{get;set;}
        public String status{get;set;}
        public Account endCustomer{get;set;}
        public Account purchaser{get;set;}
        public Account orderingAccount{get;set;}
        public Account architect{get;set;}
        public String projectCity{get;set;}
        public String projectState{get;set;}
        public String projectZipCode{get;set;}
        public String applicationIndustry{get;set;}
        public List<Date> ordFnzDt {get;set;}
        public List<Date> ordCrtDt {get;set;}
        public List<OpportunityContactRole> ocr {get;set;}
        public Date crtdt{get;set;}
     //   RecentCreateDate
        
        public Hierarchy()
        {
                        //this.accountName = new Account();
                        this.purchaser = new Account();
                        this.orderingAccount = new Account();
                        ordFnzDt = new List<Date>();
                        ordCrtDt = new List<Date>();
                        ocr = new List<OpportunityContactRole>();
                        this.architect = new Account();
                        this.purchaser = new Account();
        }
    }

    public String sortExpression {

             get { return sortExp; }

             set { 

               if (value == sortExp) 
                   
                   sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';

               else sortDirection = 'ASC';

               sortExp = value;
           }
       }

        public String getSortDirection() 
        {  
                if (sortExpression == null || sortExpression == '') 
                    return 'ASC';

            else return sortDirection;

         }

         public void setSortDirection(String value) 
         { 
                    sortDirection = value;
         }

        public PageReference ViewData()
        {
           sortFullExp = sortExpression  + ' ' + sortDirection;  
  
           if(sortExp.equalsIgnoreCase('AccName')){ noProjectAccounts(); ordby = 'End_Customer_Account__r.Name'; }
        
           else if (sortExp.equalsIgnoreCase('PrjName')) ordby = 'Name';
            
           else  if (sortExp.equalsIgnoreCase('Amount')) ordby = 'Amount__c';
            
           else if (sortExp.equalsIgnoreCase('Stage')) ordby = 'Stage__c';   
            
            else if (sortExp.equalsIgnoreCase('PCrtDt')) ordby = 'CreatedDate';
            
            else if (sortExp.equalsIgnoreCase('Arch')) ordby = 'Architect_Account__c';
            
            else if (sortExp.equalsIgnoreCase('Purch')) ordby = 'Purchaser_Account__c';
            
            else if (sortExp.equalsIgnoreCase('Ordering')) ordby = 'Ordering_Account__c';
            
            else if (sortExp.equalsIgnoreCase('City')) ordby = 'Project_City__c';
            
            else if (sortExp.equalsIgnoreCase('State')) ordby = 'Project_State__c';
            
            else if (sortExp.equalsIgnoreCase('Zipcode')) ordby = 'Project_Zip_Code__c';
            
            else if (sortExp.equalsIgnoreCase('AppIndustry')) ordby = 'Application__c';
            
            runQuery(ObjAcc.Id);

            return null;
     }
    
    public void summary(){
        
        for(Project__c proj: ProjSiteList){
            
            if(proj.Id!=null){ 
            
            ordList = proj.Orders__r;
                
            ordList.sort();
               
            Integer sz = ordList.size();    
                
            if((ordFnzDtMax!=null) && sz > 0 &&(ordFnzDtMax < ordList.get(sz-1).Order_Finalized_Date__c)){
                             
                             ordFnzDtMax = date.newInstance(ordList.get(sz-1).Order_Finalized_Date__c.year(), ordList.get(sz-1).Order_Finalized_Date__c.month(), ordList.get(sz-1).Order_Finalized_Date__c.day());
                         }
                             
                         else if (ordFnzDtMax==null && sz > 0 && ordList.get(sz-1).Order_Finalized_Date__c!=null){
                                    
                             ordFnzDtMax = date.newInstance(ordList.get(sz-1).Order_Finalized_Date__c.year(), ordList.get(sz-1).Order_Finalized_Date__c.month(), ordList.get(sz-1).Order_Finalized_Date__c.day());
                         }
                                      
           if (proj.Amount__c != null) totalAmount = totalAmount + proj.Amount__c;
            
            if(proj.Stage__c.contains('Prospecting') || proj.Stage__c.contains('Design') || proj.Stage__c.contains('Bidding') || proj.Stage__c.contains('Awarded') || proj.Stage__c.contains('Order - Negotiation') || (proj.Stage__c.contains('On Hold') && proj.Orders__r.size()>0))
                {
                prjStgPrg = prjStgPrg +1; 
                    
                if(proj.Amount__c!=null)    
                    
                prjStgPrgAmt = prjStgPrgAmt + proj.Amount__c;     
            }
                
            if (proj.Stage__c != null && (proj.Stage__c.contains('Closed Won') || proj.Stage__c.contains('Closed Complete')))
                {
                    prjWon = prjWon + 1;
                    amountWon = amountWon + proj.Amount__c;
                    prjStgWon = prjStgWon + 1;
                    prjStgWonAmt = prjStgWonAmt + proj.Amount__c; 
                }
                
        if(proj.Stage__c.contains('Duplicate'))
                {
                    DuplPrj = DuplPrj +1;
                }   

            if(proj.Stage__c.contains('Quoted') || (proj.Stage__c.contains('On Hold') && proj.Orders__r.size()==0)){
                
                prjStgQtd = prjStgQtd + 1;
                
                if(proj.Amount__c!=NULL){
                prjStgQtdAmt = prjStgQtdAmt + proj.Amount__c;
            }}
            
            if(proj.Stage__c.contains('Closed Lost - Project Lost')||proj.Stage__c.contains('Closed - Inactivity')||proj.Stage__c.contains('Cancelled')){
                
                prjStglost = prjStglost + 1;
                
                if(proj.Amount__c!=NULL)
                prjStglostAmt = prjStglostAmt + proj.Amount__c;
            }
            }
        }
        
    }
    
    public List<Account> noProjectAccounts(){
        
        AccSiteList = [Select Name, Id, (Select id from Projects1__r) from Account where parent.Id=:string.valueOf(ObjAcc.Id).left(15)]; //OR id=:string.valueOf(ObjAcc.Id).left(15) */
       
        siz = AccSiteList.size();
        
        List<Account> acctemp = new List<Account>();
        
        for(Account a: AccSiteList)
           if(a.Projects1__r.size()==0)
              acctemp.add(a);
        
        AccSiteList = acctemp;
       
        return AccSiteList;
    }
    
    public class ProjectWrapper
    {
    
    
    
    }
    
    public void runQuery(ID objAccId){
        
        String query1 ='SELECT Id,(Select Id,Name,CreatedDate, Order_Finalized_Date__c From Orders__r), Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,';
               query1+='Architect_Account__c,Ordering_Account__c, Brand_Name_Account__c, End_Customer_Account__c,End_Customer_Account__r.Name, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c, ';
               query1+='(Select Id, Name, AccountId,Project_Name__c from Opportunities__r where StageName like \'%Won%\' OR StageName like \'%Complete%\' OR StageName like \'%Paid%\')';
               query1+=' FROM Project__c';
               query1+=' WHERE (Architect_Account__c = :objAccId OR Brand_Name_Account__c = :objAccId OR End_Customer_Account__c = :objAccId'; 
               query1+=' OR Franchise_Account__c = :objAccId OR Franchisor_Account__c = :objAccId OR Other_Influencer_Account__c = :objAccId'; 
               query1+=' OR Purchaser_Account__c =:objAccId OR Ordering_Account__c =:objAccId) '; 
        if(sortExp!=''){
            query1+='order by ';
            query1+=ordby;
            if(sortDirection!='')    
            query1+= ' '+sortDirection;
            else
            query1+= ' ASC';
        }
        
        ProjSiteList = database.query(query1);
        
        opportunityCRSet();
        
        oppList2 = [Select Id, Name, AccountId,Project_Name__c, (Select Contact.Name, ContactId from OpportunityContactRoles ) 
                                    from Opportunity where Id IN:oppIDSet AND  AccountId IN:oppAccSet];         

        for(Project__c prj:ProjSiteList ) { hierarchySetData(prj); }        
        
        psiz = ProjSiteList.size();
        
        if(sortExp!='AccName')
        noProjectAccounts();
        
        ProjectListBkp = ProjSiteList;
    }
    
    public void hierarchySetData(Project__c prj){
                        
                        Hierarchy hier = new Hierarchy();
                        
                        hier.crtdt = date.newInstance(prj.CreatedDate.year(), prj.CreatedDate.month(), prj.CreatedDate.day()) ;                                 
                        //hier.accountName = ac;
                        hier.projectName = prj;
                        hier.architect.Name = prj.Architect_Account__r.Name;
                        hier.purchaser.Name = prj.Purchaser_Account__r.Name;
                        hier.orderingAccount.Name = prj.Ordering_Account__r.Name;    
                        hier.amount = prj.Amount__c;
                        hier.status = prj.Stage__c;
                        hier.projectCity = prj.Project_City__c;
                        hier.projectState = prj.Project_State__c;
                        hier.projectZipCode = prj.Project_Zip_Code__c;
                        hier.applicationIndustry = prj.Application__c;
                        hier.architect.Id = prj.Architect_Account__c; 
                        hier.purchaser.Id = prj.Purchaser_Account__c;
                        hier.orderingAccount.Id = prj.Ordering_Account__c;
                        
                        retrieveContactRoles(hier);
    }
    
    public void opportunityCRSet(){
        
        for(Project__c plist: ProjSiteList){
            
            if(plist.Opportunities__r.size()!=0){
                
                for(Project__c prj : ProjSiteList){
                    
                for(Opportunity opp: prj.Opportunities__r){
                        
                        oppIDSet.add(opp.Id);
                        oppAccSet.add(prj.Ordering_Account__c);
                    }
                }
           }
        }
    }
    
    public void retrieveContactRoles(Hierarchy hier){
                
        for(Project__c prj: ProjSiteList){
            
            for (Order od : prj.Orders__r){ 
                        hier.ordFnzDt.add(od.Order_Finalized_Date__c);
                                hier.ordCrtDt.add(date.newInstance(od.CreatedDate.year(), od.CreatedDate.month(), od.CreatedDate.day()));
                   }
            
            for (Opportunity op : oppList2){
                  for(List<OpportunityContactRole> ocrs : op.OpportunityContactRoles){
                            for(OpportunityContactRole ocr : ocrs ){ 
                               hier.ocr.add(ocr);
                            }
                        }
                    }
             }
        ProjectList.add(hier);
    }
    
    public HierarchyController_nishant1(ApexPages.StandardController con){
        
        ProjectList = new List<Hierarchy>();
        ordFnzDtMax = null;
        ordby='';
        DuplPrj =0;
        oppIdSet = new Set<ID>();
        oppAccSet = new Set<ID>();
        AccSiteList = new List <Account>();
        ordList = new LIST<Order>();
        contrls = new List<Contact>();
        prjList2 = new List<Project__c>();
        oppList2 = new List<Opportunity>();
        oppList3 = new List<List<Opportunity>>();
        AccRelatedList = new Account();
        ProjSiteList = new List<Project__c>();
        ProjectListBkp = new List<Project__c>();
        objAcc = (Account)con.getRecord();
       // SetTest =new set<Id>();
        SetOr =new set<Id>();
        totalAmount = 0.0;
        amountWon = 0.0;
        siz = 0;
        psiz = 0;
        prjWon = 0;
        prjStgQtd = 0;
        prjStglost=0; 
        prjStgPrg = 0;
        prjStgWon = 0;
        prjStgQtdAmt = 0.0;
        prjStglostAmt = 0.0;
        prjStgPrgAmt = 0.0;
        prjStgWonAmt = 0.0;
        relType='';
        accFilter = '';
        prjFilter = '';
        cityFilter = '';
        stateFilter = '';
        appIndFilter = '';
        prjStsFilter = '';
        ordFilter = '';
        purFilter = '';
        archFilter = '';
        sortFullExp = '';
        
        runQuery(objAcc.Id);
       
        summary();
                           
                           
                 
     }
    
    public void filter()
    {
        ProjSiteList = ProjectListBkp;
        
        List<Project__c> filterList = new List<Project__c>();     
        
        for(Project__c hr: ProjSiteList)
        {
            integer flag = 0, cnt=0;
            
            if(accFilter!=''){accFilter = accFilter.trim(); cnt++;} 
            if(prjFilter!=''){prjFilter = prjFilter.trim(); cnt++;} 
            if(cityFilter!=''){cityFilter = cityFilter.trim(); cnt++;} 
            if(stateFilter!=''){stateFilter = stateFilter.trim(); cnt++;} 
            if(zipFilter!=''){zipFilter = zipFilter.trim(); cnt++;}
            if(appIndFilter!=''){appIndFilter = appIndFilter.trim(); cnt++;}
            if(prjStsFilter!=''){prjStsFilter = prjStsFilter.trim(); cnt++;}
            if(archFilter!=''){archFilter = archFilter.trim(); cnt++;}
            if(purFilter!=''){purFilter = purFilter.trim(); cnt++;}
            if(ordFilter!=''){ordFilter = ordFilter.trim(); cnt++;}
            
            if(accFilter!='' && hr.End_Customer_Account__r.Name!=null) 
               if(hr.End_Customer_Account__r.Name.containsIgnoreCase(accFilter))
                flag++; 
            
            if(prjFilter!='' && hr.Name!=null) 
                if(hr.Name.containsIgnoreCase(prjFilter))
                    flag++;

            if(cityFilter!='' && hr.Project_City__c!=null) 
                if(hr.Project_City__c.containsIgnoreCase(cityFilter))
                    flag++;

            if(stateFilter!='' && hr.Project_State__c!=null)
                if(hr.Project_State__c.containsIgnoreCase(stateFilter))
                    flag++;

            if(zipFilter!='' && hr.Project_Zip_Code__c!=null)
                if(hr.Project_Zip_Code__c.containsIgnoreCase(zipFilter))
                    flag++;
                    
            if(appIndFilter!='' && hr.Application__c!=null)
                if(hr.Application__c.containsIgnoreCase(appIndFilter))
                    flag++;
            
            if(prjStsFilter!='' && hr.Stage__c!=null)
                if(hr.Stage__c.containsIgnoreCase(prjStsFilter))
                    flag++;
                    
            if(archFilter!='' && hr.Architect_Account__r.Name!=null)
                if(hr.Architect_Account__r.Name.containsIgnoreCase(archFilter))
                    flag++;
                    
            if(purFilter!='' && hr.Purchaser_Account__r.Name!=null)
                if(hr.Purchaser_Account__r.Name.containsIgnoreCase(purFilter))
                    flag++;
                    
            if(ordFilter!='' && hr.Ordering_Account__r.Name!=null)
                if(hr.Ordering_Account__r.Name.containsIgnoreCase(ordFilter))
                    flag++;
                            
            if(cnt == flag)
                filterList.add(hr);
              
              if(accFilter!='') 
                filterAcc();
                
        }
        
                ProjSiteList = filterList;
    }
    
    public PageReference refresh()
    {
            PageReference pr = ApexPages.currentPage();
            pr.setRedirect(true);
            return pr;
    } 
    
    public void filterAcc(){
        
        AccSiteList = noProjectAccounts();
        
        List<Account> accTmpList = new List<Account>();
        
        for (Account a : AccSiteList)
        
        if(accFilter!='' && a.Name!=null) 
               if(a.Name.containsIgnoreCase(accFilter))
                  accTmpList.add(a);
        AccSiteList = accTmpList;    
    }

}