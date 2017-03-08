public with sharing class OpportunityRedirect
{
   public Id recType;
   public Id contactId ;

    public OpportunityRedirect(ApexPages.StandardController controller) {
     recType = ApexPages.currentPage().getParameters().get('RecordType');
     contactId = ApexPages.currentPage().getParameters().get('conid');
    }


    public Pagereference redirectPage()
    {
        Pagereference pg;
        if(ApexPages.currentPage().getParameters().containsKey('accId'))
        {
           if (contactId == null)
               pg = new Pagereference('/'+Opportunity.sObjectType.getDescribe().getKeyPrefix()+'/e?RecordType='+recType+'&opp3=Fills_Automatically&nooverride=1&accid='+ApexPages.currentPage().getParameters().get('accid')+'&retURL='+ApexPages.currentPage().getParameters().get('accid'));
             else
             pg = new Pagereference('/'+Opportunity.sObjectType.getDescribe().getKeyPrefix()+'/e?RecordType='+recType+'&opp3=Fills_Automatically&nooverride=1&accid='+ApexPages.currentPage().getParameters().get('accid')+'&retURL='+ApexPages.currentPage().getParameters().get('accid') +'&conid='+ contactId);
             
         }
         else if(ApexPages.currentPage().getParameters().containsKey(System.Label.ProjectSourceID))
         {
            pg = new Pagereference('/'+Opportunity.sObjectType.getDescribe().getKeyPrefix()+'/e?&RecordType='+recType+'&opp3=Fills_Automatically&nooverride=1&retURL='+ApexPages.currentPage().getParameters().get(System.Label.ProjectSourceLkdID));         
            pg.getParameters().put(System.Label.ProjectSourceID,ApexPages.currentPage().getParameters().get(System.Label.ProjectSourceID));
            pg.getParameters().put(System.Label.ProjectSourceLkdID,ApexPages.currentPage().getParameters().get(System.Label.ProjectSourceLkdID));
         }
         else
         {
            pg = new Pagereference('/'+Opportunity.sObjectType.getDescribe().getKeyPrefix()+'/e?RecordType='+ApexPages.currentPage().getParameters().get('RecordType')+'&opp3=Fills_Automatically&nooverride=1&retURL='+Opportunity.sObjectType.getDescribe().getKeyPrefix()+'/o');                  
         }
        pg.setRedirect(true); 
        return pg;    
    }
}