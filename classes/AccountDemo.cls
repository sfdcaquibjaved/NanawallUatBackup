public class AccountDemo
    
{
    public list<project__C> AllProjectData {get;set;}
    public list<opportunity> opp{get;set;} 
    public list<opportunityContactRole> ContactRole{get;set;}  
    public list<Projectwrapper> WrapperCombineAllData {get;set;}
    map<id, opportunity>uniqueOpportunity {get;set;} 
    public id  AccId {get;set;}
    public Map<id,list<opportunityContactRole>> uniqueData {get;set;}
    
    
    public AccountDemo()
    {
        
       	AccId = '001A000000ksAXI';
        AllProjectData= new list<project__C>();
        opp = new list<opportunity>();
        uniqueOpportunity =new map<id, opportunity>();
         ContactRole = new list<opportunityContactRole>();
        CombineDate();
    }
    
    public void CombineDate()
    {
         AllProjectData=[select id,(select id, name , project_name__c from opportunities__r) name from project__c where (Purchaser_Account__c =: AccID OR End_Customer_Account__c='001A000000ksAXI' )];
       
       
        for(project__C prj : AllProjectData)
        {
            
            opp.addAll(prj.opportunities__r);
            
            
        }
        
        
        
        ContactRole =[select contact.name, opportunity.project_name__C, opportunity.id from opportunityContactRole where opportunity.id IN :opp];
        system.debug('the value of opportunitycontactRole is' +ContactRole.size());        
        system.debug('the value of opp is '+opp.size());
        
               
        
        
        
    }
       
            
            
         
    
    
    
    
     public class Projectwrapper
    {
        
        public project__c pr{get;set;}
        public list<opportunityContactRole> opp1{get;set;}
        public Projectwrapper(project__C GP ,list<opportunityContactRole> opp)
        {
            pr = GP;
            opp1 =opp;
        }
        
    }

}