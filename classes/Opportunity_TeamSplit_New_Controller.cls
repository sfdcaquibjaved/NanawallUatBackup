public with sharing class Opportunity_TeamSplit_New_Controller {

	private final Opportunity o;
    public Opportunity_TeamSplit_New_Controller(ApexPages.StandardController stdController) {
        this.o = (Opportunity)stdController.getRecord();
        
        
    }

	
	public OpportunityTeamMember otm { get { if( otm==null) { otm = new OpportunityTeamMember( OpportunityId = this.o.id); } return otm;} set; }
	public OpportunitySplit split { get{ if( split == null) { split = new OpportunitySplit(OpportunityId = this.o.id); }  return split;} set; }	
	
	//user lookup stuff
	private String selectedUser = null;
	public String getSelectedUser() { return selectedUser; }
	public void setSelectedUser(String u ) { selectedUser = u;  }
    public List<SelectOption> getUserItems() {
    	List<SelectOption> options = new List<SelectOption>();
        for( User u: [SELECT FirstName, LastName, Id, UserRoleName__c FROM User WHERE IsActive = true AND profileid != '00eA0000000RSay' AND Profileid != '00eA0000000Rh8Q'  Order by LastName, FirstName ] )
        { 

        	options.add( new SelectOption( u.id, u.FirstName + ' ' + u.LastName) );
        } 
        return options;
    } 
	
	//roles lookup stuff
	private String selectedAccessLevel = null;
	public String getSelectedAccessLevel() { return selectedAccessLevel; }
	public void setSelectedAccessLevel(String al ) { selectedAccessLevel = al;  }
    public List<SelectOption> getAvailableAccessLevels() {
    	List<SelectOption> options = new List<SelectOption>();
    	options.add( new SelectOption( 'Read/Write','Read/Write') );
    	options.add( new SelectOption( 'Read','Read') );
        return options;
    }

	public Pagereference Cancel() {
		PageReference ref = new PageReference('/' + this.o.Id );			
		ref.setRedirect(true);
		return ref;
	
	}

	public PageReference UpdateRec() {



		try {


			if( this.otm.Id == null )
			{
				this.otm.UserId = selectedUser;
//				this.otm.OpportunityAccessLevel = SelectedAccessLevel;  //API can no longer set this. if they want this, will need to do it via OpportunityShare updates
				insert this.otm;
			}

			if( this.split.id == null )
			{
				OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];
				
				this.split.SplitOwnerId = selectedUser;
				this.split.splittypeid = splittype.id;
//				insert this.split;			
			}
			
			PageReference ref = new PageReference('/' + this.o.id);			
			ref.setRedirect(true);
		
		
			return ref;
		} catch( Exception e ) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Caught an exception: ' + e ));	
			
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
	        mail.setToAddresses( toAddresses );
	        mail.setReplyTo('admin@a-stechnologies.com');   
	        mail.setSenderDisplayName('Salesforce - Opp Team Insert/Update Error');
	        mail.setSubject('Opp Team Update Error ' );
	        mail.setBccSender(false);
	        mail.setUseSignature(false);
	        mail.setPlainTextBody(' Opp team controller Insert/update  Opportunity: '+ this.o.id+' <br />' + e  );
	        mail.setHtmlBody(' Opp team controller Insert/update Opportunity: '+this.o.id+' <br />' + e );
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
			
			return null;	
		}		
	}

}