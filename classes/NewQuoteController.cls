public with sharing class NewQuoteController
{
    private Quote__c q;
    public string oppId;
    public string ProjectId {get;set;}
    
    public NewQuoteController(ApexPages.StandardController controller)
    {
        projIsNull = false;
        oppid='';
         q = (Quote__c)controller.getRecord();
         oppId=System.currentPageReference().getParameters().get('CF00NA0000001O58u_lkid');
         
         try 
        {
         Opportunity o = [SELECT id , Project_Name__c FROM opportunity WHERE id = :oppId];
          ProjectId = o.Project_Name__c ;
         } catch(Exception ex)
        {
        	
        } 
    }
    public boolean projIsNull { get; set; }
        
    public string getServeraddress(){ return GlobalStrings.NanaServerAddress(); }
    public String getOpportunityID()
    {
        try 
        {
            Opportunity o = [SELECT id FROM opportunity WHERE id = :oppId];
          return o.Id;
        } catch(Exception ex)
        {
          projIsNull = true;
            return null;        
        }
    }
    private Opportunity opp = null;
    public Opportunity getOpportunity() {
        if( opp == null )
        {
            try 
            {
               opp = [SELECT id, is_a_dupe__c FROM opportunity WHERE id = :oppId];
            } catch(Exception ex ) 
            {
                opp = new Opportunity();
                projIsNull = true;
            }
        }
        return opp; 
    }
    public String getUserID()
    {
        return UserInfo.getUserId() ;
    }
}