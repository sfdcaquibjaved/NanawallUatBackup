public class Opportunity_dupefinder_controller {


   /* private final Opportunity o;
    public Opportunity_dupefinder_controller(ApexPages.StandardController stdController) {
        this.o = (Opportunity)stdController.getRecord();
    }

    public pagereference unrelateopp() {
        Join_RelatedProjects__c j =[select id, Opportunity_2__c from join_relatedprojects__c where id = :relatingOppId];
        string input = '<Root><SFID Value="' + j.opportunity_2__c + '" /><Locked Value="False" /></Root>';
        SalesforceGateway.SalesforceGatewaySoap sfgw = new SalesforceGateway.SalesforceGatewaySoap();
//      sfgw.ProjectLock(input);

        Opportunity o = [SELECT id FROM opportunity WHERE id =:j.opportunity_2__c];     
        o.is_a_dupe__c = false;

        update o;
        
        delete j;
                
        relatedProjectList = null;
        joins = null;
        
        return null;
    }

    public pagereference AddToMaster() {
        
        string input = '<Root><SFID Value="' + this.o.id + '" /><Locked Value="True" /></Root>';
        SalesforceGateway.SalesforceGatewaySoap sfgw = new SalesforceGateway.SalesforceGatewaySoap();
    //  sfgw.ProjectLock(input);
        
        Join_RelatedProjects__c j = new Join_RelatedProjects__c();
        j.opportunity_1__c = relatingOppId;
        j.opportunity_2__c = o.id;
        j.Administrator_Approved__c = true;
        j.Master_Opportunity__c = relatingOppId;
        
        insert j;
        
        this.o.is_a_dupe__c = true;
        this.o.StageName = 'Duplicate';
        update this.o;
        
        relatedProjectList = null;
        joins = null;
        
        return new PageReference('/apex/opportunity_linkedprojectlist?id=' + o.id);
    
    }
    
    public pagereference relateOpp() {
        
        string input = '<Root><SFID Value="' + relatingOppId + '" /><Locked Value="True" /></Root>';
        SalesforceGateway.SalesforceGatewaySoap sfgw = new SalesforceGateway.SalesforceGatewaySoap();
    //  sfgw.ProjectLock(input);
        if( o.id == relatingOppId )
        { //don't make a project it's own master. that's just naughty.
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, 'Note! You cannot add a project as it\'s own master.' ));
            
            return null;
        }
        
        
        Join_RelatedProjects__c j = new Join_RelatedProjects__c();
        j.opportunity_1__c = o.id;
        j.opportunity_2__c = relatingOppId;
        j.Administrator_Approved__c = true;
        j.Master_Opportunity__c = o.id;
        
        insert j;
        
        Opportunity duped = [SELECT id FROM opportunity WHERE id = :relatingOppId ];
        duped.is_a_dupe__c = true;
        duped.StageName = 'Duplicate';
        update duped;
        
        relatedProjectList = null;
        joins = null;

        return null;
    }

    private Join_RelatedProjects__c dummyJoin = new Join_RelatedProjects__c();
    public Join_RelatedProjects__c getdummyJoin() { return dummyJoin; }
    public void setdummyopp(Join_RelatedProjects__c o) { dummyJoin = o; }

    public pagereference addotheropp() {
        
        
        map<id, integer> relatedProjects = getRelatedProjectMap();
        if( relatedProjects.containsKey(dummyjoin.opportunity_1__c)) return null;           
        
        if(dummyJoin.Opportunity_1__c ==null) return null;
        
        
        Opportunity duped = [SELECT id, is_a_dupe__c, MasterCount__c, Quote_Count__c FROM opportunity WHERE id = :dummyJoin.Opportunity_1__c ];
        if( duped.Is_A_Dupe__c )
        {
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, 'Note! The project you selected is already a duplicate of another project and cannot be added to this one.' ));
            return null;        
        } else if( duped.MasterCount__c > 0 )
        {
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, 'Note! The project you selected is a master project and cannot be added to this one.' ));
            return null;        
        
         } else if( o.id == dummyjoin.Opportunity_1__c )
         {
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, 'Note! You cannot add a project as it\'s own master.' ));
            return null;        
         
         } 
        
        duped.is_a_dupe__c = true;
        duped.StageName = 'Duplicate';
        string input = '<Root><SFID Value="' + duped.id + '" /><Locked Value="True" /></Root>';
        SalesforceGateway.SalesforceGatewaySoap sfgw = new SalesforceGateway.SalesforceGatewaySoap();
    //  sfgw.ProjectLock(input);
        
        Join_RelatedProjects__c j = new Join_RelatedProjects__c();
        j.opportunity_1__c = o.id;
        j.opportunity_2__c = dummyJoin.Opportunity_1__c;
        j.Administrator_Approved__c = true;
        j.Master_Opportunity__c = o.id;
        insert j;
        
        update duped;
        
        dummyjoin = new Join_RelatedProjects__c();
        
        relatedProjectList = null;
        joins = null;
        
    
    
        return null;
    }


    private id relatingOppId = null;
    public void setrelatingoppid( id i ) { relatingOppId = i; }
    public id getrelatingoppid() { return relatingoppid; }

    private list<Join_RelatedProjects__c> joins = null;
    public list<Join_RelatedProjects__c> getjoins() {
    
        if( joins == null )
        {
            joins =  [SELECT id, opportunity_1__c, opportunity_2__c, opportunity_1__r.name, opportunity_2__r.name,opportunity_1__r.quote_count__c, opportunity_2__r.quote_count__c, Administrator_Approved__c FROM Join_RelatedProjects__c WHERE opportunity_1__c = :o.id OR opportunity_2__c = :o.id ];
        }
        
        return joins;
    }

    private map<id, integer> relatedProjectList = null;
    public map<id, integer> getRelatedProjectMap() {
        if( relatedProjectList == null )
        {
            relatedProjectList =  new map<id,integer>();
            
            for( Join_RelatedProjects__c j :  getjoins() )
            {
                if( !relatedProjectList.containsKey(j.opportunity_1__c))
                    relatedProjectList.put(j.opportunity_1__c,1);
                if( !relatedProjectList.containsKey(j.opportunity_2__c))
                    relatedProjectList.put(j.opportunity_2__c,1);
            }

        }

        return relatedProjectList;
    }

    public list<opportunity> getduplicateOpps() { 
        
        list<opportunity> dupes = new list<opportunity>();
        map<id, integer> relatedProjects = getRelatedProjectMap();
                
        for( opportunity o : FindDupes( o) )
        {
            if( !relatedProjects.containsKey(o.id))         
                dupes.add(o);
        }
        
        return dupes;
        
    }
    
    public static list<Opportunity> FindDupes(Opportunity BaseOpportunity ) {
    
        list<Opportunity> tempOpps = new List<Opportunity>();
        if( BaseOpportunity.City__c != null && BaseOpportunity.City__c != '' 
        && BaseOpportunity.State__c != null && BaseOpportunity.State__c != '' ) 
        {
            string cleanedCityName = BaseOpportunity.City__c;
            string cleanedCityName2 = BaseOpportunity.City__c;
            cleanedCityName2 = cleanedCityName2.toLowerCase();
            cleanedCityName = cleanedCityName.toLowerCase();

            //someone entered a web quote with 'ft. meyers' and complained that it didnt match 'fort meyers', therefore ... HACK
            cleanedCityName = cleanedCityName.replace('ft.', 'fort');
            cleanedCityName2 = cleanedCityName2.replace('fort ', 'ft. ');

            tempOpps = [Select o.id, o.City__c, o.Name, o.State__c, o.MasterCount__c, o.Quote_Count__c,Max_Email_Date__c, CreatedDate from Opportunity o WHERE ( state__c = :BaseOpportunity.State__c AND ( City__c = :BaseOpportunity.City__c OR City__c = :cleanedCityName OR City__c = :cleanedCityName2) ) AND id != :BaseOpportunity.id AND is_a_dupe__c != true ORDER BY CreatedDate DESC ];
        }
//we no longer want the below       
//          duplicateOpps.addall([Select o.id, o.City__c, o.Name, o.State__c, o.MasterCount__c from Opportunity o WHERE ( name = :BaseOpportunity.name OR name like :likes )   AND id != :BaseOpportunity.id AND is_a_dupe__c != true AND state__c != :BaseOpportunity.State__c AND City__c != :BaseOpportunity.City__c  ]);        
        
        
        string likes = '%'+BaseOpportunity.name+'%';
        
System.debug( tempOpps.size() + 'opportunities fetched for checking'  );        
        list<Opportunity> duplicateOpps = new List<Opportunity>();

        string regex = '\\b(street|st|avenue|ave|drive|dr|residence|the|apartment|apt|room|rm|floor|fl|terrace)([\\.]*)\\b';
        string baseName = BaseOpportunity.name.replaceAll(regex,'').replaceAll('[^a-zA-Z0-9]','');

        integer startLineCount = 0;
        if( tempOpps.size() > 0 )
        {       
            double cpuLimit = Limits.getLimitCpuTime() *.7;
            for( Opportunity o : tempOpps ) 
            {
                System.debug( 'Going in to ' + o.name  + ' i have hit ' + Limits.getScriptStatements() + ' statements');
                startLineCount = limits.getScriptStatements();
                try {
                    string ostring = o.name.replaceAll(regex,'').replaceAll('[^a-zA-Z0-9]','');
                    System.debug( 'Comparing ' + ostring + ' to ' + baseName );                     
                    
                    //Limits.getCpuTime()
                    //if( (Limits.getLimitScriptStatements() - Limits.getScriptStatements()) < .35 * Limits.getLimitScriptStatements() )
                    if( Limits.getCpuTime() > cpuLimit )
                    {
//                      System.debug('Getting dangerously close to script execution governor. No longer trying string approx matching.');
                        System.debug('Getting dangerously close to CPU governor. No longer trying string approx matching.');
                        if( (ostring.length() < baseName.length() ? baseName : ostring ).contains( (ostring.length() < baseName.length() ? ostring : basename) )  ) 
                        { //try to limp home by seeing if one name is contained within the other
                            duplicateOpps.add( o );                     
                        }
                    } else if( ostring == baseName 
                    || Utility.StringApproximateMatch( basename,ostring ) )
                    {
                        duplicateOpps.add( o );
                    } else
                    {
                        
                    }
//                  System.debug( 'Finished with  ' + o.name  + ' i have hit ' + Limits.getScriptStatements() + ' statements');
//                  System.debug('This run took ' + (Limits.getScriptStatements() - startLineCount) );
                        
                } catch(Exception ex ) {
                }
                
            }           
        } else 
        {
        }

        return duplicateOpps;   
    }
    
    
    public static list<Opportunity> Original_FindDupes(Opportunity BaseOpportunity ) {
    
        list<Opportunity> tempOpps;
        if( BaseOpportunity.City__c != null && BaseOpportunity.City__c != '' 
        && BaseOpportunity.State__c != null && BaseOpportunity.State__c != '' ) 
            tempOpps = [Select o.id, o.City__c, o.Name, o.State__c, o.MasterCount__c from Opportunity o WHERE (name = :BaseOpportunity.name OR ( state__c = :BaseOpportunity.State__c AND City__c = :BaseOpportunity.City__c )) AND id != :BaseOpportunity.id AND is_a_dupe__c != true LIMIT 20];
        else tempOpps = [Select o.id, o.City__c, o.Name, o.State__c, o.MasterCount__c from Opportunity o WHERE ( name = :BaseOpportunity.name OR name like :BaseOpportunity.name)   AND id != :BaseOpportunity.id AND is_a_dupe__c != true  LIMIT 20];
        
        list<Opportunity> duplicateOpps = new List<Opportunity>();

        if( tempOpps.size() > 0 )
        {       
            for( Opportunity o : tempOpps ) 
            {
                try {
                    if( o.name == BaseOpportunity.name 
                    || Utility.StringApproximateMatch( BaseOpportunity.name,o.name ) )
                    {
                        duplicateOpps.add( o );
                    } else
                    {
                    }
                } catch(Exception ex ) {
                }
            }           
        } else 
        {
        }

        return duplicateOpps;   
    }

*/
}