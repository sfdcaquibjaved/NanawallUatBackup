public class HierarchyController_nishant{
    public string AccName{get;set;}
    
      
    public List <Account> AccSiteList{get;set;}
    public Account ObjAcc{get;set;}    
    public List<Project__c> ProjSiteList{get;set;}
    public Integer prjWon {get;set;}
    public Integer siz {get;set;}
    public Integer psiz {get;set;}
    public String rltype {get;set;}
    public Account AccRelatedList{get;set;}  
    public Hierarchy [] ProjectList{get;set;}
    public Double amountWon{get;set;}
    public Double totalAmount{get;set;}
    private String sortDirection = 'ASC';
    private String sortExp = 'AccName';
    public List<String> acclist;
    public Map <String,Hierarchy> accmap;    
    public List<String> prjlist;
    public Map <String,Hierarchy> prjmap;
    public List<String> prjsts;
    public Map <String,Hierarchy> stsmap;
    public List<Decimal> amtlst;
    public Map <Decimal,Hierarchy> amtmap;
    public LIST<Order> ordList{get;set;}
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
    public List<String> noPrjAccs{get;set;}
    public String relType{get;set;}
    
    public HierarchyController_nishant(ApexPages.StandardController con){
        
        AccSiteList = new List <Account>();
        noPrjAccs = new List <String>();
        ordList = new LIST<Order>();
        contrls = new List<Contact>();
        prjList2 = new List<Project__c>();
        oppList2 = new List<Opportunity>();
        oppList3 = new List<List<Opportunity>>();
        amtlst = new List<Decimal>();
        amtmap = new Map<Decimal,Hierarchy>();    
        prjsts = new List<String>();
        stsmap = new Map<String,Hierarchy>();    
        acclist = new List<String>();
        accmap = new Map<String,Hierarchy>();    
        prjlist = new List<String>();
        prjmap = new Map<String,Hierarchy>();    
        AccRelatedList = new Account();
        ProjSiteList = new List<Project__c>();
        ProjectList = new List<Hierarchy>();
        objAcc = (Account)con.getRecord();
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
       
         ProjSiteList = [SELECT Id, Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Bid_Date__c, Close_Date__c,
                       Architect_Account__c,Ordering_Account__c, Brand_Name_Account__c, End_Customer_Account__c, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c
                       FROM Project__c
                       WHERE Architect_Account__c = :objAcc.Id OR Brand_Name_Account__c = :objAcc.Id OR End_Customer_Account__c = :objAcc.Id 
                       OR Franchise_Account__c = :objAcc.Id OR Franchisor_Account__c = :objAcc.Id OR Other_Influencer_Account__c = :objAcc.Id 
                       OR Purchaser_Account__c =:objAcc.Id OR Ordering_Account__c =:objAcc.Id ORDER BY Close_Date__c DESC];
                       
                    
                       
                      
        
        
        for(Project__c proj: ProjSiteList){
        
            /*

                             
                                
                        for (Opportunity op : oppList2){
                                        for(List<OpportunityContactRole> ocrs : op.OpportunityContactRoles){
                                        for(OpportunityContactRole ocr : ocrs ){
                                                hier.ocr.add(ocr); System.debug('ocr: '+ocr +' hier.ocr:'+hier.ocr);
                             }
                          }
                        }               
                    }    
              }          
                              
               for (Order od : ordList){ 
                        hier.ordFnzDt.add(od.Order_Finalized_Date__c);
                                hier.ordCrtDt.add(date.newInstance(od.CreatedDate.year(), od.CreatedDate.month(), od.CreatedDate.day()));
                    }
                         
                        hier.crtdt = date.newInstance(proj.CreatedDate.year(), proj.CreatedDate.month(), proj.CreatedDate.day()) ;                                 
                        
                        if(relType.equalsIgnoreCase('End Customer Account'))
                        hier.accountName.Id = proj.End_Customer_Account__c;
                        else            
                        if(relType.equalsIgnoreCase('Purchaser Account'))
                        hier.accountName.Id = proj.Purchaser_Account__c;
                        else
                        if(relType.equalsIgnoreCase('Ordering Account'))
                        hier.accountName.Id = proj.Ordering_Account__c;
                        else
                        if(relType.equalsIgnoreCase('Architect Account'))
                        hier.accountName.Id = proj.Architect_Account__c;        
                        else
                        if(relType.equalsIgnoreCase('Franchisee Account'))
                        hier.accountName.Id = proj.Franchise_Account__c;
                        
                        hier.projectName = proj;
                        hier.architect.Name = proj.Architect_Account__r.Name;
                        hier.purchaser.Name = proj.Purchaser_Account__r.Name;
                        hier.orderingAccount.Name = proj.Ordering_Account__r.Name;    
                        hier.amount = proj.Amount__c;
                        hier.status = proj.Stage__c;
                        hier.projectCity = proj.Project_City__c;
                        hier.projectState = proj.Project_State__c;
                        hier.projectZipCode = proj.Project_Zip_Code__c;
                        hier.applicationIndustry = proj.Application__c;
                        prjlist.add(proj.Name);
                        prjsts.add(proj.Stage__c +''+ proj.Id);
                        amtlst.add(proj.Amount__c);
                        acclist.add(hier.accountName +''+proj.Id);
                        accmap.put(hier.accountName+''+proj.Id, hier);
                        prjmap.put(proj.Name, hier);
                        stsmap.put(proj.Stage__c+''+proj.Id,hier);
                        amtmap.put(proj.Amount__c, hier);
                                
                    if (prj.Stage__c != null && (prj.Stage__c.contains('Closed Won') || prj.Stage__c.contains('Closed Complete')))
                       {
                            
                            amountWon = amountWon + prj.Amount__c;
                            prjWon = prjWon + 1;
                        }
                        
//                        if(prj.Amount__c!=null)
                        
//                        totalAmount = totalAmount + prj.Amount__c;
                        
                        ProjectList.add(hier);
                         
/                      prevAcc = hier.accountName.Name;*/
            
           
            
            if (proj.Amount__c != null) totalAmount = totalAmount + proj.Amount__c;
            
            if(proj.Stage__c.contains('Prospecting') || proj.Stage__c.contains('Design') || proj.Stage__c.contains('Bidding') || proj.Stage__c.contains('Awarded') || proj.Stage__c.contains('Order Negotiation'))
                {
                prjStgPrg = prjStgPrg +1; prjStgPrgAmt = prjStgPrgAmt + proj.Amount__c;     
            }
                
            if (proj.Stage__c != null && (proj.Stage__c.contains('Closed Won') || proj.Stage__c.contains('Closed Complete')))
                {
                    prjWon = prjWon + 1;
                    amountWon = amountWon + proj.Amount__c;
                    prjStgWon = prjStgWon + 1;
                    prjStgWonAmt = prjStgWonAmt + proj.Amount__c; 
                }
                
            if(proj.Stage__c.contains('Quoted')){
                
                prjStgQtd = prjStgQtd + 1;
                
                if(proj.Amount__c!=NULL){
                prjStgQtdAmt = prjStgQtdAmt + proj.Amount__c;
            }}
            
            if(proj.Stage__c.contains('Closed Lost - Project Lost')||proj.Stage__c.contains('Closed - Inactivity')||proj.Stage__c.contains('On Hold')||proj.Stage__c.contains('Cancelled')){
                
                prjStglost = prjStglost + 1;
                
                if(proj.Amount__c!=NULL){
                prjStglostAmt = prjStglostAmt + proj.Amount__c;
            }}
            
    }
            
        //AccSiteList = [Select Name, Id, Type, (Select Name,CreatedDate,Architect_Account__r.Name, Ordering_Account__c,Ordering_Account__r.Name, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,Id, Architect_Account__c, Purchaser_Account__c, Purchaser_Account__r.Name from Projects1__r Order by Amount__c desc Nulls last),(Select Name, Id, Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects4__r),(Select Name, Id, Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects__r),(Select Name, Id, Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects5__r) from Account where Parent.Id = :string.valueOf(ObjAcc.Id).left(15)];
    
                AccSiteList = [Select Name, Id, Type, (Select Name,CreatedDate,Architect_Account__r.Name, Ordering_Account__c,
                                                       Ordering_Account__r.Name, Amount__c,Application__c,RecordType.Name,
                                                       Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,Id,
                                                       Architect_Account__c, Purchaser_Account__c, 
                                                       Purchaser_Account__r.Name from Projects1__r ) from Account 
                                                       where Parent.Id = :string.valueOf(ObjAcc.Id).left(15)]; //OR id=:string.valueOf(ObjAcc.Id).left(15) */
                
             String prevAcc ='';
            
            for (Account ac : AccSiteList)
            {
                    psiz = ProjectList.size()-1;

                    if(ac.Projects1__r.size()==0)
                    {
                            Hierarchy hier = new Hierarchy();
                
                            hier.accountName = ac;
                
                            acclist.add(ac.Name);
                        
                            noPrjAccs.add(ac.Name);
                
                            accmap.put(ac.Name, hier);    
                
                            ProjectList.add(hier);
                     }
        else
        {
            for (List<Project__c> prjs: ac.Projects1__r)
            {
                         //siz+=prjs.size();           
                     for(Project__c prj : prjs)
                     { 
                             Hierarchy hier = new Hierarchy(prj.Architect_Account__c, prj.Purchaser_Account__c,
                                                            prj.Ordering_Account__c);

                             ordList = [Select Name,Id, CreatedDate, Order_Finalized_Date__c, Project__r.Id from Order
                                        where Project__r.Id =:prj.Id]; 
               
                             prjList2 = [Select Id, Ordering_Account__c, (Select Name, Id, StageName from Opportunities__r where
                                                     StageName like '%Won%' OR StageName like '%Complete%' OR StageName like '%Paid%' )                          
                                        from Project__c where Id =:string.valueOf(prj.Id).left(15) AND Ordering_Account__c != null];
                        
               for (Project__c prj2 : prjList2)
               for (List<Opportunity> oppList : prj2.Opportunities__r)
               {
                   for (Opportunity opp : oppList)
                   {
                       oppList2 = [Select Id, Name, AccountId, (Select Contact.Name, ContactId from OpportunityContactRoles ) 
                                    from Opportunity where Id =:string.valueOf(opp.Id).left(15) AND AccountId =: prj2.Ordering_Account__c];
                                
                        for (Opportunity op : oppList2){
                                        for(List<OpportunityContactRole> ocrs : op.OpportunityContactRoles){
                                        for(OpportunityContactRole ocr : ocrs ){
                                                hier.ocr.add(ocr); System.debug('ocr: '+ocr +' hier.ocr:'+hier.ocr);
                         }
                          }
                        }               
                    }    
              }          
                              
               for (Order od : ordList){ 
                        hier.ordFnzDt.add(od.Order_Finalized_Date__c);
                                hier.ordCrtDt.add(date.newInstance(od.CreatedDate.year(), od.CreatedDate.month(), od.CreatedDate.day()));
                    }
                         
                        hier.crtdt = date.newInstance(prj.CreatedDate.year(), prj.CreatedDate.month(), prj.CreatedDate.day()) ;                                 
                        hier.accountName = ac;
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
                        prjlist.add(prj.Name);
                        prjsts.add(prj.Stage__c +''+ prj.Id);
                        amtlst.add(prj.Amount__c);
                        acclist.add(ac.Name +''+prj.Id);
                        accmap.put(ac.Name+''+prj.Id, hier);
                        prjmap.put(prj.Name, hier);
                        stsmap.put(prj.Stage__c+''+prj.Id,hier);
                        amtmap.put(prj.Amount__c, hier);
                                
/*                       if (prj.Stage__c != null && (prj.Stage__c.contains('Closed Won') || prj.Stage__c.contains('Closed Complete')))
                       {
                            
                            amountWon = amountWon + prj.Amount__c;
                            prjWon = prjWon + 1;
                        }*/
                        
//                        if(prj.Amount__c!=null)
                        
//                        totalAmount = totalAmount + prj.Amount__c;
                        
                        ProjectList.add(hier);
                         
//                        prevAcc = hier.accountName.Name;
                     }
                  }
               }
          }
     }
    
    public class Hierarchy {
        
        public Account accountName{get;set;}
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
        
        public Hierarchy()
        {
                        this.accountName = new Account();
                        ordFnzDt = new List<Date>();
                                ordCrtDt = new List<Date>();
                        ocr = new List<OpportunityContactRole>();            
        }
        
        public Hierarchy(Id arch, Id purch, Id ordr)
        {     
            this.accountName = new Account();
            ordFnzDt = new List<Date>();
            ordCrtDt = new List<Date>();
            ocr = new List<OpportunityContactRole>();
            this.architect = new Account();
            this.architect.Id = arch;
            this.purchaser = new Account();
            this.purchaser.Id = purch;
            this.orderingAccount = new Account();
            this.orderingAccount.Id = ordr;
        }
    }

    public String sortExpression {

             get { return sortExp; }

             set { //if the column is clicked on then switch between Ascending and Descending modes

               if (value == sortExp) 
                   
                   sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';

               else sortDirection = 'ASC';

               sortExp = value;
           }
       }

        public String getSortDirection() 
        {  
            //if not column is selected

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

            string sortFullExp = sortExpression  + ' ' + sortDirection;  

            if(sortExp.equalsIgnoreCase('AccName')) sortData('AccName');
        
             else if (sortExp.equalsIgnoreCase('PrjName')) sortData('PrjName');
            
           else  if (sortExp.equalsIgnoreCase('Amount')) sortData('Amount');
            
            else if (sortExp.equalsIgnoreCase('Stage')) sortData('PrjStatus');    
            
            return null;
     }

        
       public void sortData(String str)
        { 
            
            if (str.equalsIgnoreCase('Amount'))
            {

                amtlst.sort();
                
                List<Hierarchy> amtlist = new List<Hierarchy>();
                
                for (Decimal s : amtlst)
                {
                    
                     amtlist.add(amtmap.get(s));
                }
                
                if(sortDirection.equalsIgnoreCase('ASC')){
                
                    ProjectList = amtlist;
                    
                    for(String s: noPrjAccs)
                    
                    ProjectList.add(accmap.get(s));
                }
             
                else if (sortDirection.equalsIgnoreCase('DESC'))
                {
                
                for(Integer i = amtlist.size()-1, j=0;i >=0; i--)
                    
                 ProjectList.set(i,amtlist.get(j++));
             }
          }

            if (str.equalsIgnoreCase('AccName'))
             {
                    
                acclist.sort();
                
                List<Hierarchy> hrlist = new List<Hierarchy>();
                
                for (String s : acclist)
                {
                    
                     hrlist.add(accmap.get(s));
                }
                    
                if(sortDirection.equalsIgnoreCase('ASC'))
                
                ProjectList = hrlist;
             
                else if (sortDirection.equalsIgnoreCase('DESC'))
                {
                
                    for(Integer i = ProjectList.size()-1, j=0;i >=0; i--)
                    
                    ProjectList.set(i,hrlist.get(j++));
                }
         }
            
            if (str.equalsIgnoreCase('PrjStatus'))
            {
                    
                prjsts.sort();
                
                List<Hierarchy> stslist = new List<Hierarchy>();
                
                for (String s : prjsts)
                {
                    
                     stslist.add(stsmap.get(s));
                }
                    
                if(sortDirection.equalsIgnoreCase('ASC')){
                
                    ProjectList = stslist;
                    
                    for(String s: noPrjAccs)
                    
                    ProjectList.add(accmap.get(s));
                }
                else if (sortDirection.equalsIgnoreCase('DESC'))
                {
                
                    for(Integer i = stslist.size()-1, j=0;i >=0; i--)
                    
                    ProjectList.set(i,stslist.get(j++));
                }
         }
            
                if (str.equalsIgnoreCase('PrjName'))
                {
                    system.debug('Data before sorting: '+prjlist);
                     prjlist.sort();
                     system.debug('Data After sorting: '+prjlist);
                    
                     List<Hierarchy> prlist = new List<Hierarchy>();
                
                     for (String s : prjlist)
                     {
                    
                        prlist.add(prjmap.get(s));
                     }
                    
                if(sortDirection.equalsIgnoreCase('ASC'))
                
                ProjectList = prlist;
             
                else if (sortDirection.equalsIgnoreCase('DESC'))
                {
                
                    for(Integer i = prlist.size()-1, j=0;i >=0; i--)
                    //for(Integer i = projectlist.size()-1, j=0;i >=0; i--)
                    
                    ProjectList.set(i,prlist.get(j++));
                }
                              
                for(String s: noPrjAccs){
                    
                    ProjectList.add(accmap.get(s));
                }
          } 
               
     }
     
     public PageReference runSearch() {
    
    
    String AccName = Apexpages.currentPage().getParameters().get('AName');
    System.debug('Account Name: '+AccName); 
    String ProjectName = Apexpages.currentPage().getParameters().get('ProjectName');
    String city = Apexpages.currentPage().getParameters().get('city');
    String state = Apexpages.currentPage().getParameters().get('state');
    String zipcode = Apexpages.currentPage().getParameters().get('zipcode');
    String Country = Apexpages.currentPage().getParameters().get('Country');
   
   
   System.debug('Nishant'+AccName);
    List<Hierarchy> Phier = new List<Hierarchy>();
    
    for(Hierarchy hr : ProjectList)
    
    {
       if(AccName != null)
        {
          if(hr.accountName.Name.contains('Cactus Club Café- park-royal'))
           {
             Phier.add(hr);
             
           }
        }
    } 
    ProjectList.clear(); 
   // ProjectList = Phier;

    // run the query again
   return null;
  }
}