public  with sharing class OpportunityNewController {

    public string competitoraccount
    {
        get; set;
    }
    
    public list<SelectOption> competitoraccounts 
    {
        get 
        {
            if( competitoraccounts == null)
            {
                List<SelectOption> options = new List<SelectOption>();

                for ( Account a  : [SELECT Id, Name FROM Account WHERE competitor__c = true order by name])
                {
                    
                    options.add(new SelectOption(a.Id, a.Name) );
                }
                return options;
            
            }
            
            return competitoraccounts;
        }
    }
    


    private boolean showInfoBlock = true;
    public boolean getShowInfoBlock() { return showInfoBlock; }
    private boolean showDupeBlock = false;
    public boolean getShowDupeBlock() { return showDupeBlock; }
    
    public static string fakecontid = ''; //use this for test units

    private Opportunity dummyOpportunity = new Opportunity( country__c = 'United States', StageName = 'Considered', Probability = 10 );
    private final Opportunity o;
    public OpportunityNewController(ApexPages.StandardController stdController) {
        this.o = (Opportunity)stdController.getRecord();
        try
        {
            if( ( Apexpages.currentPage().getParameters().get('conid') != null
            && Apexpages.currentPage().getParameters().get('conid') != '' ) 
            || fakecontid != '' )
            {
                if( fakecontid != '' )
                    dummynrOCR.Contact__c = fakecontid;
                else dummynrOCR.Contact__c = Apexpages.currentPage().getParameters().get('conid');
            
                Contact c = [SELECT id, state__c, city__c FROM Contact where id = :dummynrOCR.Contact__c ];
                dummyOpportunity.City__c = c.city__c;
                dummyOpportunity.State__c = c.state__c;
            }
        } catch(Exception ex ) { 
            //whoops, oh well.
        }
//      dummyOpportunity.Probability = 0;
    }


    public Pagereference updateProbability() {
    
        dummyOpportunity.Probability = getProbability();        
        
        return null;
    }

    public integer getProbability() {

        if( dummyOpportunity.StageName == 'Considered')
            return 10;
        else if( dummyOpportunity.StageName ==  'Specified')
            return  20;
        else if( dummyOpportunity.StageName ==  'Quote Requested')
            return 30;
        else if( dummyOpportunity.StageName ==  'Budget Quote to Architect')
            return 50;
        else if( dummyOpportunity.StageName ==  'Quote/Non-Architect')
            return 40;
        else if( dummyOpportunity.StageName ==  'Quoted Architect and Non-Architect' )
            return 60;
        else if( dummyOpportunity.StageName ==  'Order Probably Coming')
            return 80;
        else if(dummyOpportunity.StageName ==  'Order Process Started'
        || dummyOpportunity.StageName ==  'Ordered - Paid')
            return 100;
        else return 0;
        
    }

        private list<Opportunity> duplicateOpps = new list<Opportunity>();
        public list<Opportunity> getduplicateopps() { return duplicateopps; }
        
public PageReference CheckDupes(){


        if( dummynrOCR.Contact__c == null )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' You must select a contact in order to add an opportunity' ));    
            return null;
        }
/*      
        if( dummyOpportunity.CloseDate == null || dummyOpportunity.CloseDate.format() == '' )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' You must select a close date.' ));   
            return null;
        
        }
        */
        
        if( dummyOpportunity.Name == null || dummyOpportunity.Name == '' )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' You must enter a project name.' ));  
            return null;
        
        }
        showInfoBlock = false;
        showDupeBlock = true;

        // -- check for dupes
        //see if any opps exist with this exact name
        try {
            //using dupe blocker now
//          duplicateOpps = Opportunity_dupefinder_controller.FindDupes(dummyOpportunity);
        } catch( Exception ex ) {
            /*
            duplicateOpps = new list<Opportunity>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
                mail.setToAddresses( toAddresses );
                mail.setReplyTo('admin@a-stechnologies.com');   
                mail.setSenderDisplayName('Salesforce - Nana Exceptions Department');
                mail.setSubject( 'An exception occurred when looking up dupes for project add'  );
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setPlainTextBody('An exception occurred when trying to look up dupes while adding an opportunity.' + dummyOpportunity.name + ' ; ' + dummyOpportunity.State__c + ' ; ' + dummyOpportunity.City__c + '  ; <br /> ' + ex   );
                mail.setHtmlBody('An exception occurred when trying to look up dupes while adding an opportunity.' + dummyOpportunity.name + ' ; ' + dummyOpportunity.State__c + ' ; ' + dummyOpportunity.City__c + '  ;<br /> ' +ex );
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
*/              
        }
        if( duplicateOpps.size() < 1 )
        {
            saveProj();
            return new PageReference('/' + dummyOpportunity.Id );
        
        }  else return null;
        // -- end check for dupes

}

    public Opportunity getNewOpportunity() { return this.dummyOpportunity; } 

    private nrOpportunityContactRole__c dummynrOCR = new nrOpportunityContactRole__c();
    public nrOpportunityContactRole__c getnrOCR() { return this.dummynrOCR; }


private void saveproj(){

        Contact c = [SELECT c.id, c.ownerid, c.AccountId, c.Account.Chain_Account__c FROM Contact c WHERE id = :dummynrOCR.Contact__c ];
        
        
        
        dummyOpportunity.OwnerId = c.OwnerId;
        
        if( dummyOpportunity.CloseDate == null || dummyOpportunity.CloseDate.format() == '' )
        {
/*          integer closeDateLeadTime = 196;            
            if( dummyOpportunity.Application__c.toLowerCase() == 'auto showrooms' ) 
            {
                closeDateLeadTime = 213;
            } else if( 
                dummyOpportunity.Application__c.toLowerCase() == 'commercial (retail, storefront, auto dealership, office)' 
                || dummyOpportunity.Application__c.toLowerCase() == 'health care' 
                || dummyOpportunity.Application__c.toLowerCase() == 'retail storefront' 
                || dummyOpportunity.Application__c.toLowerCase() == 'bank' 
                || dummyOpportunity.Application__c.toLowerCase() == 'supermarket' 
            )  { 
                closeDateLeadTime = 221;
            } else if( dummyOpportunity.Application__c.toLowerCase() == 'educational' )
            {
                closeDateLeadTime = 291;                    
            } else if(dummyOpportunity.Application__c.toLowerCase() == 'hotel' )
            {
                closeDateLeadTime = 238;
            } else if(dummyOpportunity.Application__c.toLowerCase() == 'leisure (country club, casino, community center)')
            {
                closeDateLeadTime = 245;
            } else if( dummyOpportunity.Application__c.toLowerCase() == 'multi family residential (high rise, balcony)' ) 
            {
                closeDateLeadTime = 239;
            } else if( dummyOpportunity.Application__c.toLowerCase() == 'office' ) 
            {
                closeDateLeadTime = 195;
            } else if( dummyOpportunity.Application__c.toLowerCase() == 'other' )
            {
                closeDateLeadTime = 215;
            } else if( dummyOpportunity.Application__c.toLowerCase() == 'religious' )
            {
                closeDateLeadTime = 268;
            } else if( dummyOpportunity.Application__c.toLowerCase() == 'restaurant' )
            {
                closeDateLeadTime = 194;
            } else if( dummyOpportunity.Application__c.toLowerCase() == 'single family residential - new' )
            {
                closeDateLeadTime = 188;
            } else if( dummyOpportunity.Application__c.toLowerCase() == 'single family residential - remodel' )
            {
                closeDateLeadTime = 150;
            } else if( dummyOpportunity.Application__c.toLowerCase() == 'sports venue' )
            {
                closeDateLeadTime = 230;
            }
            else
            {
                closeDateLeadTime=160;
            }
        */

            dummyOpportunity.CloseDate = Date.today().addMonths(3);
            
        }
        
        if( c.account.chain_account__c ) dummyOpportunity.Chain_Account__c = true;
        
        insert dummyOpportunity;
        
        dummynrOCR.Opportunity__c = dummyOpportunity.Id;
 
        insert dummynrOCR;


        if(competitoraccount != null )
        {
        
            nrOpportunity_Account__c oppacc = new nrOpportunity_Account__c();
            oppacc.Opportunity__c = dummyOpportunity.Id;
            oppacc.Account__c = competitoraccount;
            
            insert oppacc;
        }
    

}
    
    public PageReference save() { 

        if( dummynrOCR.Contact__c == null )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' You must select a contact in order to add an opportunity' ));    
            return null;
        }
         
    /*  if( dummyOpportunity.CloseDate == null || dummyOpportunity.CloseDate.format() == '' )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' You must select a close date.' ));   
            return null;
        
        }*/
        if( dummyOpportunity.Name == null || dummyOpportunity.Name == '' )
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' You must enter a project name.' ));  
            return null;
        
        }

        try
        {
            saveProj();
            return new PageReference('/' + dummyOpportunity.Id );
        } catch(Exception ex )
        {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, ex.getMessage() ));
            return null;
        }
    }

    public PageReference cancel() {
        return new PageReference('/o');
    }

}