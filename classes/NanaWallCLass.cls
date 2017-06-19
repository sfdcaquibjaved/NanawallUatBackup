public class NanaWallCLass 
{       
    public list<project__c> ProjectData{get;set;}
    public list <opportunityContactRole> OppContRole{get;set;}
    // wrapper class to hold all data
    public list<Projectwrapper> WrapperList{get;set;}
    // get runtime id of the account 
        public id AccId{get;set;}
    
    public NanaWallClass()
    {
          AccId = '001A000001ENNzE';
        ProjectData = new list<project__c>();
        OppContRole = new list<opportunityContactRole>();    
        wrapperList =new list<Projectwrapper>();
        summary();
    }
    
    public void summary()
    {
     
        String query1 ='SELECT Id,(select id from opportunities__r), Name, Architect_Account__r.Name, Purchaser_Account__r.Name, Ordering_Account__r.Name, CreatedDate, Application__c, Amount__c, Stage__c, Project_City__c, Project_State__c, Project_Zip_Code__c,';
               query1+='Architect_Account__c,Ordering_Account__c, Brand_Name_Account__c, End_Customer_Account__c,End_Customer_Account__r.Name, Franchise_Account__c, Franchisor_Account__c, Other_Influencer_Account__c, Purchaser_Account__c';
               query1+=' FROM Project__c';
               query1+=' WHERE (Architect_Account__c = :AccId OR Brand_Name_Account__c = :AccId OR End_Customer_Account__c = :AccId '; 
               query1+=' OR Franchise_Account__c = :AccId OR Franchisor_Account__c = :AccId OR Other_Influencer_Account__c = :AccId '; 
               query1+=' OR Purchaser_Account__c =:AccId OR Ordering_Account__c =:AccId ) ';
        
           ProjectData = Database.query(query1);
         for(Project__c prc : ProjectData)
         {
         	
         }
        string query2='select contact.name, opportunitycontactrole.opportunity.Project_Name__r.name from opportunityContactrole where ';
              query2+='opportunitycontactrole.opportunity.Project_Name__r.End_Customer_Account__c=:AccId OR ';
              query2+='opportunitycontactrole.opportunity.Project_Name__r.Franchise_Account__c= :AccId  OR ';
             query2+='opportunitycontactrole.opportunity.Project_Name__r.Franchisor_Account__c= :AccId OR ';
              query2+='opportunitycontactrole.opportunity.Project_Name__r.Other_Influencer_Account__c= :AccId OR ';
              query2+='opportunitycontactrole.opportunity.Project_Name__r.Architect_Account__c= :AccId OR ';
               query2+='opportunitycontactrole.opportunity.Project_Name__r.Purchaser_Account__c= :AccId OR ';
               query2+='opportunitycontactrole.opportunity.Project_Name__r.Brand_Name_Account__c= :AccId OR ';
               query2+='opportunitycontactrole.opportunity.Project_Name__r.Ordering_Account__c= :AccId '; 
       
               OppContRole=Database.query(query2);
        system.debug('the Value of Ashok ' +OppContRole);
        for(project__c prj : ProjectData)
        {
             system.debug('the Value of ProjectData  ' +prj);
 			   for(opportunitycontactRole opp :  OppContRole )
               {
                   system.debug('the Value of opportunitycontactRole123  ' +opp);
                   
                   if(prj.name  == opp.opportunity.project_name__r.name)
                   {
                       system.debug('the Value of Project List Name123456   ' +prj.name);
                       system.debug('the Value of opportunity Contact Role Project Name   ' +opp.opportunity.project_name__r.name);
                       Projectwrapper ProjectObject = new Projectwrapper(prj, opp);
                       wrapperlist.add(ProjectObject);
                   }
               }
        
        }
        
        
        
    }
    
    public class Projectwrapper
    {
        
        public project__c pr{get;set;}
        public opportunityContactRole opp1{get;set;}
        public Projectwrapper(project__C GP ,opportunityContactRole opp)
        {
            pr = GP;
            opp1 =opp;
        }
        
    }
        
}