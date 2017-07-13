public class AccountDemo1
    
{
    public list<project__C> AllProjectData {get;set;}
    public list<opportunity> opp{get;set;} 
    public list<opportunityContactRole> ContactRole{get;set;}  
    public list<Projectwrapper> WrapperCombineAllData {get;set;}
    map<id, project__c> ProjectData {get;set;} 
    public id  AccId {get;set;}
    public Map<id,list<opportunityContactRole>> uniqueData {get;set;}
    
    
    public AccountDemo1()
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
        
       ContactRole =[select contact.name, opportunity.project_name__C, opportunity.id from opportunityContactRole where opportunity.id IN :opp];
        
        for(project__C prj : AllProjectData)
        {
            ProjectData.put(prj.id, prj);
            
        }
       
        integer i =0;
        for(opportunityContactRole OCR : ContactRole )
        {
              if (projectData.containsKey(OCR.opportunity.project_name__C))
        
                {
                        
                    WrapperCombineAllData.add(new Projectwrapper(projectdata.get(OCR.opportunity.project_name__C),OCR));
                    i++;
                }
              
        }
        
system.debug('The Value of I is ' +ContactRole.size());
    }
    
    
 
     public class Projectwrapper
    {
        
        public project__C pr{get;set;}
        public opportunityContactRole opp1{get;set;}
        public Projectwrapper( project__C GP,opportunityContactRole opp  )
        {
            this.pr = GP;
            this.opp1 =opp;
        }
       
    }

}