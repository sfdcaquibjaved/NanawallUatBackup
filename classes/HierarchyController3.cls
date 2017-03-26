public class HierarchyController3 {
        
    public List <Account> AccSiteList{get;set;}
    public Account ObjAcc{get;set;}    
    public List <List<Project__c>> ProjSiteList{get;set;}
    public Integer siz {get;set;}
    public Integer psiz {get;set;}
    public String rltype {get;set;}
    public Account AccRelatedList{get;set;}  
    public Map<Account,List<Map<String,String>>> ProjectMap{get;set;}
    public List< Map <String,String>> PrjListMap {get;set;}
   	public Map<String,List<Project__c>> ListMap{get;set;}
    //public List<Project__c> ProjectList{get;set;}
    public Set<Account> acKeys{get;set;}
	public Set<Set<String>> spKeys{get;set;}
    public Set<String> pKeys{get;set;}
    
        public HierarchyController3(ApexPages.StandardController con){
                        
                        AccSiteList = new List <Account>();
                        AccRelatedList = new Account();
                        ProjSiteList = new List<List<Project__c>>();
            			ListMap = new Map<String,List<Project__c>>();
            			//ProjectList = new List<Project__c>();
            			PrjListMap = new List< Map <String,String>>();
            			ProjectMap = new Map<Account,List<Map<String,String>>>();
                        objAcc = (Account)con.getRecord();
            			acKeys = new Set<Account>();
            			pKeys = new Set<String>();
            			spKeys = new Set<Set<String>>();
                        siz = 0;
						psiz = 0;
            			integer count =0;
            
            AccSiteList = [Select Name, Id, Type, (Select Name,Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,Id, Architect_Account__c, Purchaser_Account__c from Projects1__r),(Select Name, Id, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects4__r),(Select Name, Id, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects__r),(Select Name, Id, Amount__c,Application__c,RecordType.Name,Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Architect_Account__c, Purchaser_Account__c from Projects5__r) from Account where Parent.Id = :string.valueOf(ObjAcc.Id).left(15)];
            
            Integer sz = AccSiteList.size();
            
           /* for (Account ac : AccSiteList){ ListMap.put(ac.Name, new Project__c()); //System.debug('Executed'+ ac.Name);
                for(Project__c prj : [SELECT Id, Name, RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, Bid_Date__c, Close_Date__c,
                       Architect_Account__c, Brand_Name_Account__c,Ordering_Account__c, End_Customer_Account__c, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c
                       FROM Project__c
                       WHERE Architect_Account__c = :ac.Id OR Brand_Name_Account__c = :ac.Id OR End_Customer_Account__c = :ac.Id 
                       OR Franchise_Account__c = :ac.Id OR Franchisor_Account__c = :ac.Id OR Other_Influencer_Account__c = :ac.Id 
                       OR Purchaser_Account__c =:ac.Id] ){ //System.debug('Executed'+ ac.Name+', '+ prj);
            			If(prj!=null)
            			{		
	                           /*ListMap.put('Site Name', ac.Name); 
                               ListMap.put('Project Name', prj.Name);
                               ListMap.put('Status', prj.Stage__c);
                               ListMap.put('Amount', prj.Amount__c+'');
                               ListMap.put('Application Industry', prj.Application__c); 
                               ListMap.put('Type', prj.RecordType.Name);
                               ListMap.put('City', prj.Project_City__c); 
                               ListMap.put('State', prj.Project_State__c);  
                               ListMap.put('Zip Code', prj.Project_Zip_Code__c); 
                               ListMap.put('Architect', prj.Architect_Account__c); 
                               ListMap.put('Odering Account', prj.Ordering_Account__c); 
                               ListMap.put('Purchaser', prj.Purchaser_Account__c);
                               PrjListMap.add(ListMap);
                               ProjectMap.put(ac,PrjListMap);
                               ListMap.remove(ac.Name);	
                        	   ListMap.put(ac.Name, prj);	    
                		               	
                            }	
            			else
                        	{
                                //PrjListMap.add(null);
                               	//ProjectMap.put(ac,null);
                               	ListMap.put(ac.Name, null);  
                                //System.debug('Executed'+ ac.Name+', '+ prj);
                        	}
            			}
                	}*/
            
            for (Account ac : AccSiteList){
                
                List<Project__c> ProjectList = new List<Project__c>();
                
                if(ac.Projects__r.size()>0){
              		ProjectList.addAll(ac.Projects__r);
                }
                if(ac.Projects1__r.size()>0){
              		ProjectList.addAll(ac.Projects1__r);
                }
                if(ac.Projects4__r.size()>0){
              		ProjectList.addAll(ac.Projects4__r);
                }
                if(ac.Projects5__r.size()>0){
              		ProjectList.addAll(ac.Projects5__r);
                }
                
                ListMap.put(ac.Name, ProjectList);
                
                //ProjectList = null;
            }
            
            pKeys.addAll(ListMap.keySet());
            //spKeys.add(pKeys);            
            
            //acKeys.addAll(ProjectMap.keySet());
            //psiz = PrjListMap.size();	
            
            //for (Account acc :acKeys){ for(Integer i=0;i<psiz;i--){ PrjListMap.get(i);}}
            //for (String str: ProjectMap.)
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