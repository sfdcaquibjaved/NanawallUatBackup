public class AccountDemo
    
{
    public list<project__C> AllProjectData {get;set;}
    public list<opportunity> opp{get;set;} 
    public list<opportunityContactRole> ContactRole{get;set;}  
    public list<Projectwrapper> WrapperCombineAllData {get;set;}
    map<id, project__c> ProjectData {get;set;} 
    public id  AccId {get;set;}
    public Map<id,list<opportunityContactRole>> uniqueData {get;set;}
    
    
    public AccountDemo()
    {
        
        AccId = '001A000000ksAXI';
        AllProjectData= new list<project__C>();
        opp = new list<opportunity>();
        ProjectData =new map<id, project__C>();
         ContactRole = new list<opportunityContactRole>();
         WrapperCombineAllData = new list<projectWrapper>();
       
        CombineDate();
    }
    
    public void CombineDate()
    {
         AllProjectData=[select id,(select id, name , project_name__c from opportunities__r) name from project__c where (Purchaser_Account__c =: AccID OR End_Customer_Account__c='001A000000ksAXI' )];
         
      
       
        for(project__C prj : AllProjectData)
        {
            
            opp.addAll(prj.opportunities__r);
            
            
        }
      
        system.debug('the value of opportunitycontactRole is' +ContactRole.size());        
        system.debug('the value of opp is '+opp.size());
       ContactRole =[select contact.name, opportunity.project_name__C, opportunity.id from opportunityContactRole where opportunity.id IN :opp];
        
        for(project__C prj : AllProjectData)
        {
            ProjectData.put(prj.id, prj);
            
        }
        system.debug('The Size of Map is ' +ProjectData.size());
        integer i =0;
        for(opportunityContactRole OCR : ContactRole )
        {
              if (projectData.containsKey(OCR.opportunity.project_name__C))
        
                {
                        
                    WrapperCombineAllData.add(new Projectwrapper(projectData,OCR));
                }
              
        }
        
       
    
    system.debug('hi'+i);
    
    }
    
    
 
     public class Projectwrapper
    {
        
        public map<Id,project__c> pr{get;set;}
        public opportunityContactRole opp1{get;set;}
        public Projectwrapper( map<id,project__C> GP,opportunityContactRole opp  )
        {
            this.pr = GP;
            this.opp1 =opp;
        }
       
    }

}