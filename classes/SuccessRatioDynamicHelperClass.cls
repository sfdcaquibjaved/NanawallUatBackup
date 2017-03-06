/**********************************************************************
Apex Class: SuccessRatioDynamicHelperClass
Description: This class is a helper class for successRatioDynamicContorller
Created Date: 4th August,2016            
***********************************************************************/
public class SuccessRatioDynamicHelperClass {
    
    public static set<id> projectIdArchSet;
    public static set<id> projectIdOnlyArchSet;
    public static set<id> projectArchSet;
/**********************************************************************
Apex Method: projectFetching
Description: This method is used to fetch project having no budget quotes
Created Date: 4th August,2016            
***********************************************************************/    
    @RemoteAction
    @ReadOnly
    public static set<id> projectFetching()
    {
        //Local Variables
        set<id> projectIdFinalSet = new set<id>();
        projectArchSet = new set<id>();
         set<id> dummySet = new set<id>();
        map<id, id> projectIdNewFinalMap = new map<id, id>();
        map<id, id> projectIdonlyNonArchMap = new map<id, id>();
        projectIdArchSet = new set<id>();
        projectIdOnlyArchSet = new set<id>();
        //list<Opportunity> oppList = [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c from Opportunity where Quote_Count__c>0 AND RecordType.Name!= 'Influencer Opportunity' AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=2012];            
        
        for(Opportunity opp: [select id, Budget_Quote__c, Project_Name__c, Project_Name__r.Influencer_Count__c, Quote_Count__c from Opportunity where Quote_Count__c>0 AND RecordType.Name!= 'Influencer Opportunity' AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=2012])
        {
            projectIdFinalSet.add(opp.Project_Name__c);
            projectIdNewFinalMap.put(opp.Project_Name__c, opp.Project_Name__c);
            
           if(opp.Project_Name__r.Influencer_Count__c==0)
           {
               projectArchSet.add(opp.Project_Name__c);
           }
            
        }
        System.debug('sizecheckLast'+projectIdFinalSet);
        
      /*  for(Opportunity opp: [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c, RecordType.Name from Opportunity where Quote_Count__c>0 AND RecordType.Name='Influencer Opportunity' AND Project_Name__c IN: projectIdFinalSet AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=2012])
        {
           
               projectIdArchSet.add(opp.Project_Name__c);
                    
        }
        
        for(Project__c pro: [select id, Opportunity_Count__c, Influencer_Count__c from Project__c where CALENDAR_YEAR(convertTimezone(createdDate))>=2012])
        {
           if(pro.Opportunity_Count__c==pro.Influencer_Count__c )
           {
               projectIdOnlyArchSet.add(pro.id);
           }
           
        }*/
       // list<Opportunity> oppNewList = [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c, RecordType.Name from Opportunity where Quote_Count__c>0 AND Project_Name__c IN: projectIdFinalSet AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=2012];
     /*   for(Opportunity opp: [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c, RecordType.Name from Opportunity where Quote_Count__c>0 AND Project_Name__c IN: projectIdFinalSet AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=2012])
        {
            if(opp.RecordType.Name=='Influencer Opportunity')
            {
            projectIdArchSet.add(opp.Project_Name__c);
            projectIdonlyNonArchMap .put(opp.Project_Name__c, opp.Project_Name__c);
            }
        }*/
     //   System.debug('sizecheckLastArch'+projectIdArchSet);
       // list<Opportunity> oppFinalList = [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c from Opportunity where Quote_Count__c>0 AND RecordType.Name='Influencer Opportunity' AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=2012];            
        
       /* for(Opportunity opp: [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c from Opportunity where Quote_Count__c>0 AND RecordType.Name='Influencer Opportunity' AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=2012])
        {           
            dummySet.add(opp.Project_Name__c);
        }
        
        for(id i: dummySet)
        {
            if(!projectIdNewFinalMap.containsKey(i))
            {
                projectIdOnlyArchSet.add(i);
            }
        }
        
        if(projectIdFinalSet.size()>0)
        {
            
            for(id ii: projectIdFinalSet)
            {
                if(!projectIdonlyNonArchMap.containsKey(ii))
                {
                    projectArchSet.add(ii);
                }
            }           
        }   */ 
        return projectIdFinalSet;
    }
    
 /**********************************************************************
Apex Method: projectFetchingForTrends
Description: This method is used to fetch project having no budget quotes
Created Date: 4th August,2016            
***********************************************************************/    
    @RemoteAction
    @ReadOnly
    public static void projectFetchingForTrends(string SalesRepName, set<id> ProjectId)
    {
        //Local Variables
        set<id> projectIdFinalSet = new set<id>();
        projectArchSet = new set<id>();
         set<id> dummySet = new set<id>();
        map<id, id> projectIdNewFinalMap = new map<id, id>();
        map<id, id> projectIdonlyNonArchMap = new map<id, id>();
        projectIdArchSet = new set<id>();
        projectIdOnlyArchSet = new set<id>();
        //list<Opportunity> oppList = [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c from Opportunity where Quote_Count__c>0 AND RecordType.Name!= 'Influencer Opportunity' AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=2012];            
        
        for(Opportunity opp: [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c, RecordType.Name from Opportunity where RecordType.Name='Influencer Opportunity' AND Project_Name__c IN: ProjectId AND Project_Name__r.Owner.Name=: SalesRepName AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=2012])
        {
           
               projectIdArchSet.add(opp.Project_Name__c);
                    
        }
        
        for(Project__c pro: [select id, Opportunity_Count__c, Influencer_Count__c from Project__c where CALENDAR_YEAR(convertTimezone(createdDate))>=2012 AND owner.Name=: SalesRepName])
        {
           if(pro.Opportunity_Count__c==pro.Influencer_Count__c )
           {
               projectIdOnlyArchSet.add(pro.id);
           }
           
        }
      
    }   
    
/**********************************************************************
Apex Method: projectFetchingFromQuotes
Description: This method is used to fetch project having no budget quotes and 
             orderfinalized date NULL
Created Date: 12th September,2016            
***********************************************************************/    
    @RemoteAction
    @ReadOnly
    public static set<id> projectFetchingFromQuotes()
    {
        //Local Variables
        set<id> projectIdNewFinalSet = new set<id>();
        set<id> projectIdFinalSet = new set<id>();
        map<id, boolean> proOppCheckMap = new map<id, boolean>();
        
        integer year = system.today().year();
        //list<Quote__c> QuoteList = [select id, Opportunity__r.Budget_Quote__c, Project__r.Name, Opportunity__r.Quote_Count__c, Order_Finalized_Date__c from Quote__c where Opportunity__r.Quote_Count__c>0 AND Opportunity__r.RecordType.Name!= 'Influencer Opportunity' AND CALENDAR_YEAR(convertTimezone(Project__r.createdDate))=:year];            
        
        for(Quote__c quo: [select id, Opportunity__r.Budget_Quote__c, Project__r.Name, Opportunity__r.Quote_Count__c, Order_Finalized_Date__c from Quote__c where Opportunity__r.Quote_Count__c>0 AND Opportunity__r.RecordType.Name!= 'Influencer Opportunity' AND CALENDAR_YEAR(convertTimezone(Project__r.createdDate))=:year])
        {
            
            projectIdFinalSet.add(quo.Project__c);
        }
        
      //  list<Project__c> projectList = [select id, (select id, Order_Finalized_Date__c from Nana_Quotes__r where Order_Finalized_Date__c!=NULL) from project__c where id IN: projectIdFinalSet];
        
        for(Project__c pro: [select id, (select id, Order_Finalized_Date__c from Nana_Quotes__r where Order_Finalized_Date__c!=NULL) from project__c where id IN: projectIdFinalSet])
        {
            if(pro.Nana_Quotes__r.size()==0)
            {
                 projectIdNewFinalSet.add(pro.id);
            }                   
        }
        return projectIdNewFinalSet;
    }
    
    
/**********************************************************************
Apex Method: SiteVisitCalculateHelper
Description: This method is used to fetch project having site visits
Created Date: 12th September,2016            
***********************************************************************/    
    @RemoteAction
    @ReadOnly
    public static set<id> SiteVisitCalculateHelper()
    {
        //Local Variables
        set<id> projectIdFinalSet = new set<id>();
        integer year = (system.today().year()-2);
      //  list<Opportunity> oppList = [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c from Opportunity where Quote_Count__c>0 AND Site_Visit_Paid__c = TRUE AND RecordType.Name!= 'Influencer Opportunity' AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=:year];            
        
        for(Opportunity opp: [select id, Budget_Quote__c, Project_Name__c, Quote_Count__c from Opportunity where Quote_Count__c>0 AND Site_Visit_Paid__c = TRUE AND RecordType.Name!= 'Influencer Opportunity' AND CALENDAR_YEAR(convertTimezone(Project_Name__r.createdDate))>=:year])
        {
            projectIdFinalSet.add(opp.Project_Name__c);
        }
        return projectIdFinalSet;
        
    }      
}