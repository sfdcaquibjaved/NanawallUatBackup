public class HierarchyController1 {
        
    public List <Account> AccSiteList{get;set;}
    public Account AccObj{get;set;}    
    public List <List<Project__c>> ProjSiteList{get;set;}
    public Integer siz {get;set;}
    public String rltype {get;set;}
    public Account AccRelatedList{get;set;}    
    
      public HierarchyController1(ApexPages.StandardController con){
                        
                                AccSiteList = new List <Account>();
                        AccRelatedList = new Account();
                        ProjSiteList = new List<List<Project__c>>();
                        AccObj = (Account)con.getRecord();
                        siz = 0;
                        AccSiteList = [Select Name, Id, Type, (Select Name,Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,Id, Architect_Account__c, Purchaser_Account__c from Projects1__r),(Select Name, Id, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects4__r),(Select Name, Id, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects__r),(Select Name, Id, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects5__r) from Account where Parent.Id = :string.valueOf(AccObj.Id).left(15)];
                        
                        /*for(Account ac : AccSiteList)
                for(Project__c prj : ac.Projects1__r)
                    if(ac.Projects1__r.size()>0)
                        ProjSiteList.add(ac.Projects1__r);
                                else if(ac.Projects4__r.size()>0)
                        ProjSiteList.add(ac.Projects4__r);
                                else if(ac.Projects__r.size()>0)
                        ProjSiteList.add(ac.Projects__r);
                                else if(ac.Projects5__r.size()>0)
                        ProjSiteList.add(ac.Projects5__r);*/
                                
                                AccRelatedList = [Select Name, Id, Type, (Select Name, Id from Projects1__r),(Select Name, Id from Projects4__r),(Select Name, Id from Projects__r),(Select Name, Id from Projects5__r) from Account where Id = :string.valueOf(AccObj.Id).left(15)];
                                
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