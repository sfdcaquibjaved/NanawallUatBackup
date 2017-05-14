public class controllerHierarchy 
{
    public account objAcc{get;set;} //to strore parent id
    public list<account> acclist {get;set;} //to store accountinfo
    public list<project__c> PrjectSiteList {get;set;} // store project information
    public double totalAmount {get;set;} //total amouunt won
    public integer PrjStgPrg {get;set;} //
    double PrgStgPrgAmt {get;set;}
    public integer prjWon {get;set;}
    public double AmountWon {get;set;}
    public integer ProgStageWon {get;set;}
    public double ProjectStageWonAmount {get;set;}
    public integer DuplicateProject {get;set;}
    public integer projectStageQueted {get;set;}
    double ProjectStageQuateAmount {get;set;}
    public integer ProjectStagelost {get;set;}
    public double ProjectStageLostAmount {get;set;} 
    
    
    public controllerHierarchy(apexpages.StandardController con)
    {
       objAcc= (account)con.getRecord();
       DuplicateProject=0;
        PrgStgPrgAmt=0;
        ProjectStageLostAmount=0;
        totalAmount =0;
         prjStgPrg =0;
          prjWon = 0;
                                    AmountWon = 0;
                                    ProgStageWon=0;
                                    ProjectStageWonAmount=0;
                                    projectStageQueted=0;
                                    ProjectStagelost=0;
                                    
    
       
        
    
    
   
                       // list contains count of all the child accound of parent account
                        
                 accList = [select id, name from account where parent.id = : objAcc.id];
                 
                 // list contains all the Account which have projects
                 
                 PrjectSiteList = [SELECT Id, Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, 
                                   RecordType.Name, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c, 
                                   Bid_Date__c, Close_Date__c,Architect_Account__c,Ordering_Account__c, (Select Id,Name,CreatedDate, Order_Finalized_Date__c From Orders__r order by Order_Finalized_Date__c DESC Nulls last ) ,
                                   Brand_Name_Account__c, End_Customer_Account__c, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c
                                   FROM Project__c
                                   WHERE (Architect_Account__c = :objAcc.Id OR Brand_Name_Account__c = :objAcc.Id OR End_Customer_Account__c = :objAcc.Id 
                                   OR Franchise_Account__c = :objAcc.Id OR Franchisor_Account__c = :objAcc.Id OR Other_Influencer_Account__c = :objAcc.Id 
                                   OR Purchaser_Account__c =:objAcc.Id OR Ordering_Account__c =:objAcc.Id) AND (Stage__c!='Duplicate')  ORDER BY Close_Date__c DESC];

    
                for(project__C proj :PrjectSiteList)
                {
                   
                        if (proj.Amount__c != null) 
                            {
                                    
                                    totalAmount = totalAmount + proj.Amount__c;
                            }   
            
                        if(proj.Stage__c.contains('Closed Won - Order In Process') || proj.Stage__c.contains('Closed Won - Order Signed') || proj.Stage__c.contains('Order - Negotiation') || proj.Stage__c.contains('Project On Hold') && proj.Orders__r.size()>0)
                
                            {
                                   
                                    prjStgPrg = prjStgPrg +1; 
                    
                                     if(proj.Amount__c!=null)   
                             
                                            {
                                                    
                                                    PrgStgPrgAmt = PrgStgPrgAmt + proj.Amount__c; 
                                            }
                            }
                
                        if (proj.Stage__c != null && (proj.Stage__c.contains('Closed Complete - Ordered - Paid')))
                
                            {
                                   
                                    prjWon = prjWon + 1;                    
                                    AmountWon = AmountWon + proj.Amount__c;  
                                    ProgStageWon = ProgStageWon + 1;
                                    ProjectStageWonAmount = ProjectStageWonAmount + proj.Amount__c; 
                            }
                
                        if(proj.Stage__c.contains('Duplicate'))
                
                        {
                                    
                                    DuplicateProject = DuplicateProject +1;
                        }   

                        if(proj.Stage__c.contains('Quoted') || proj.Stage__c.contains('Prospecting') || proj.Stage__c.contains('Design') || proj.Stage__c.contains('Bidding') || proj.Stage__c.contains('Awarded') || (proj.Stage__c.contains('On Hold') && proj.Orders__r.size()==0))
           
                        {
                                   
                                   projectStageQueted = projectStageQueted + 1;                
                    
                                     if(proj.Amount__c!=NULL)
               
                                        {   
                                                ProjectStageQuateAmount=0;  
                                                ProjectStageQuateAmount = ProjectStageQuateAmount + proj.Amount__c;
                                        }
            
                        }
            
                        if(proj.Stage__c.contains('Closed Lost - Project Lost')||proj.Stage__c.contains('Closed - Inactivity')||proj.Stage__c.contains('Cancelled'))
                
                        {
                                    
                                    ProjectStagelost = ProjectStagelost + 1;
                
                                    if(proj.Amount__c!=NULL)
                        
                                            {
                                                    
                                                    ProjectStageLostAmount = ProjectStageLostAmount + proj.Amount__c;
                                            }
                        }
        
                
                }
        
        }
        
       
        
    }