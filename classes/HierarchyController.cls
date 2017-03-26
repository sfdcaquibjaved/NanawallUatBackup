public class HierarchyController {
        
    public List <Account> AccSiteList{get;set;}
    public Account ObjAcc{get;set;}    
    public List <List<Project__c>> ProjSiteList{get;set;}
    public Integer siz {get;set;}
    public Integer psiz {get;set;}
    public String rltype {get;set;}
    public Account AccRelatedList{get;set;}  
    public List<Hierarchy> ProjectList{get;set;}
    
    public class Hierarchy{
        
        public Account accountName{get;set;}
        public Project__c projectName{get;set;}
        public Decimal amount{get;set;}
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
    }
    
        public HierarchyController(ApexPages.StandardController con){
                        
        AccSiteList = new List <Account>();
        AccRelatedList = new Account();
        ProjSiteList = new List<List<Project__c>>();
        ProjectList = new List<Hierarchy>();
        objAcc = (Account)con.getRecord();
        siz = 0;
        psiz = 0;
            
            AccSiteList = [Select Name, Id, Type, (Select Name,Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,Id, Architect_Account__c, Purchaser_Account__c from Projects1__r),(Select Name, Id, Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects4__r),(Select Name, Id, Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects__r),(Select Name, Id, Ordering_Account__c, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects5__r) from Account where Parent.Id = :string.valueOf(ObjAcc.Id).left(15)];
            
            for (Account ac : AccSiteList){
                
                Hierarchy hier = new Hierarchy();
                
                hier.accountName = ac;
                 
                for (List<Project__c> prjs: ac.Projects1__r)
                    
                    for(Project__c prj : prjs){
                    
                    //Hierarchy hier = new Hierarchy();
 
                        if (prj!=null){
                    
                        hier.projectName = prj;

                            try{
                                    System.debug('Architect: ' + prj.Architect_Account__c);
                                    
                                    hier.architect = new Account();
                                
                                    hier.architect.Id = prj.Architect_Account__c;
                            }catch(Exception e){}
                        
                            
                        try{
                                System.debug('Purchase: ' + prj.Purchaser_Account__c);
                                hier.purchaser = new Account();
                                hier.purchaser.Id = prj.Purchaser_Account__c;
                            }catch(Exception e){}
                            
                        try{
                                System.debug('ordering acccount: ' + prj.Ordering_Account__c);
                                hier.orderingAccount = new Account();
                                hier.orderingAccount.id = prj.Ordering_Account__c;
                            }catch(Exception e){}
                            
                        hier.amount = prj.Amount__c;
                        hier.status = prj.Stage__c;
                        hier.projectCity = prj.Project_City__c;
                        hier.projectState = prj.Project_State__c;
                        hier.projectZipCode = prj.Project_Zip_Code__c;
                        hier.applicationIndustry = prj.Application__c;
                    }
                        
                        System.debug('ProjectList: ' + prj);
                }

                                ProjectList.add(hier);
                
                        
            }
            
                                
         AccRelatedList = [Select Name, Id, Type, (Select Name, Id from Projects1__r),(Select Name, Id from Projects4__r),(Select Name, Id from Projects__r),(Select Name, Id from Projects5__r) from Account where Id = :string.valueOf(ObjAcc.Id).left(15)];
                                
         if(AccRelatedList.Projects1__r.size()>0){
              ProjSiteList.add(AccRelatedList.Projects1__r);
                  rltype = 'Projects1';         
          }
          else if(AccRelatedList.Projects4__r.size()>0){
                    ProjSiteList.add(AccRelatedList.Projects4__r);
                        rltype = 'Projects4';
          }
          else if(AccRelatedList.Projects__r.size()>0){
                        ProjSiteList.add(AccRelatedList.Projects__r);
              rltype = 'Projects';
          }
          else if(AccRelatedList.Projects5__r.size()>0){
                        ProjSiteList.add(AccRelatedList.Projects5__r);
              rltype = 'Projects5';
          }
                                siz = ProjSiteList[0].size();
            
        }
}