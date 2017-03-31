public class HierarchyController {
        
    public List <Account> AccSiteList{get;set;}
    public Account ObjAcc{get;set;}    
    public List <List<Project__c>> ProjSiteList{get;set;}
    public Integer prjWon {get;set;}
    public Integer siz {get;set;}
    public Integer psiz {get;set;}
    public String rltype {get;set;}
    public Account AccRelatedList{get;set;}  
    public List<Hierarchy> ProjectList{get;set;}
    public Double amountWon{get;set;}
    public Double totalAmount{get;set;}
    
    public class Hierarchy{
        
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
        
        public Hierarchy(){
 
        }
        
        public Hierarchy(Id arch, Id purch, Id ordr){
                        
            this.architect = new Account();
            this.architect.Id = arch;
            this.purchaser = new Account();
            this.purchaser.Id = purch;
            this.orderingAccount = new Account();
            this.orderingAccount.Id = ordr;
        }
    }
    
        public HierarchyController(ApexPages.StandardController con){
                        
        AccSiteList = new List <Account>();
        AccRelatedList = new Account();
        ProjSiteList = new List<List<Project__c>>();
        ProjectList = new List<Hierarchy>();
        objAcc = (Account)con.getRecord();
        totalAmount = 0.0;
        amountWon = 0.0;
        siz = 0;
        psiz = 0;
        prjWon = 0;    
            
            AccSiteList = [Select Name, Id, Type, (Select Name,Architect_Account__r.Name, Ordering_Account__c,Ordering_Account__r.Name, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,Id, Architect_Account__c, Purchaser_Account__c, Purchaser_Account__r.Name from Projects1__r),(Select Name, Id, Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects4__r),(Select Name, Id, Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects__r),(Select Name, Id, Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects5__r) from Account where Parent.Id = :string.valueOf(ObjAcc.Id).left(15)];
            
            String prevAcc ='';
            
            for (Account ac : AccSiteList){
                                                 
                psiz = ProjectList.size()-1;
                
                if(ac.Projects1__r.size()==0){
                       
                        Hierarchy hier = new Hierarchy();
                
                                hier.accountName = ac;
                
                                ProjectList.add(hier);
                    }
                    
                    else{
                
                        for (List<Project__c> prjs: ac.Projects1__r){
                    
                    siz+=prjs.size(); 
                    
                    for(Project__c prj : prjs){
                        
                        Hierarchy hier = new Hierarchy(prj.Architect_Account__c, prj.Purchaser_Account__c, prj.Ordering_Account__c);
                        
                        if(prevAcc!=null && prevAcc.equalsIgnoreCase(ac.Name)){
                            hier.accountName=null;
                        }
                        else{ hier.accountName = ac; }
                    
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
                        if (prj.Stage__c != null && (prj.Stage__c.contains('Closed Won') || prj.Stage__c.contains('Closed Complete'))){
                            
                            amountWon = amountWon + prj.Amount__c;
                            prjWon = prjWon + 1;
                        }
                        totalAmount = totalAmount + prj.Amount__c;
                        
                        ProjectList.add(hier);
                        
                        prevAcc = hier.accountName.Name;
                        
                         }
                  }
               }
          }
     }
    
    public void sortDesc(){}
}