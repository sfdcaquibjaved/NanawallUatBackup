public with sharing class Opportunity_OppSplitManager_Controller {

	class OTM
	{
		public string UserName  { get; set; }
		public string OpportunityAccessLevel  { get; set; }
		public string TeamMemberRole  { get; set; }
		public double Commission  { get; set; }
		public string Credit  { get; set; }
		public string Credit1  { get; set; }
		public string ID  { get; set; }


		public OpportunityTeamMember tm {get; set;}
		public OpportunitySplit split { get; set; }

	}
	
	private final Opportunity o;
    public Opportunity_OppSplitManager_Controller(ApexPages.StandardController stdController) {
        this.o = (Opportunity)stdController.getRecord();
        
    }
	
	public string DeleteOppRepID { get; set; }
	public PageReference DeleteOppRep() {


		list<OpportunityTeamMember> deleteTMs = new list<OpportunityTeamMember>();
		list<OpportunitySplit> deleteSplits	 = new list<OpportunitySplit>();	
		string deleteuserid = null;
		for( OTM otm : otms )
		{
			if( otm.tm.UserId == DeleteOppRepId )
			{
				if( otm.tm.TeamMemberRole == 'Project Owner' || otm.tm.userid == this.o.ownerid)
				{
					ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,  'Cannot delete the project owner.' ));				
				
				} else
				{
					deleteUserid = otm.TM.UserId;
	
					if( otm.tm != null )				
						deleteTms.add(otm.Tm);
					
					if( otm.split != null)
						deleteSplits.add(otm.Split);
//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info,  'Delete ' + otm.tm.id + '; ' + otm.split.Id ));				
				
				}
			}
		}
		
		
		if( deleteuserid != null )
		{
			//merging wih dupeblocker was causing a weird problem where splits didnt come over, and trying to delete the team member causes a split problem because, apparently, every project has a revenue split even though i turnes 
			//them off.  need to delete all splits associated with the user to get it to work
			deleteSplits = [SELECT Id FROM OpportunitySplit WHERE SplitOwnerID = :deleteuserid AND OpportunityID = :this.o.id];
		}
		
		if( deleteSplits.size() > 0  )
		{
			
			list<nrOpportunityTeamMember__c> nrOTMs = [ SELECT Id FROM nrOpportunityTeamMember__c WHERE Opportunity__c = :this.o.id AND User__c = :deleteuserid];
			
			try
			{
				delete deleteSplits;
			} catch( Exception ex )
			{
				
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
				mail.setToAddresses( toAddresses );
				mail.setReplyTo('admin@a-stechnologies.com');   
				mail.setSenderDisplayName('Salesforce - Delete Team Member Exception ');
				mail.setSubject('An error occurred when trying to delete team member from an opportunity ' + this.o.Id + ' and Team Member ' + DeleteOppRepId  );
				mail.setBccSender(false);
				mail.setUseSignature(false);
				mail.setPlainTextBody('Opportunity ' + this.o.Id + ' and Team Member ' + DeleteOppRepId + '\n\n' + ex );
				mail.setHtmlBody('Opportunity ' + this.o.Id + ' and Team Member ' + DeleteOppRepId   + '<br><br>' + ex );
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
				
			}
			RenderRedirectCode = true;
			
			if(nrOTMs.size() > 0 )
			{
//				delete nrOTMs;
			}
		} else if( deleteTms.size() > 0 )
		{
			list<nrOpportunityTeamMember__c> nrOTMs = [ SELECT Id FROM nrOpportunityTeamMember__c WHERE Opportunity__c = :this.o.id AND User__c = :deleteuserid];			
			delete deleteTms;

			RenderRedirectCode = true;
			
			if(nrOTMs.size() > 0 )
			{
//				delete nrOTMs;
			}
			
		}
		return null;
	}


	private boolean adminAccess = null;
	private boolean HasAdminAccess() {
		
		if( adminAccess == null )
		{
			Profile p = [SELECT id FROM profile where id = :GlobalStrings.RequiredProfileIDForSharePool()];
			adminAccess = ( Userinfo.getProfileId() == p.id ? false : true ); //if they have the rep profile, they are invalid
		}	
		
		return adminAccess;
	}

	public boolean getHasDeleteAccess() {
		return HasAdminAccess();
	}
	public boolean getHasUpdateAccess() {
		return HasAdminAccess();
	}
	
	public boolean getHasCommissionAccess() {
		return HasAdminAccess();
	}

	private boolean hasCreditAcces = null;
	public boolean getHasCreditAccess() {
		
		if( hasCreditAcces == null )
		{
			list<id> allowedIds = new list<id>();
			allowedIds.add( '00eA0000000RMcs');
			allowedIds.add( '00eA0000000RHCb' );
			allowedIds.add('00eA0000000Qmst');
			allowedIds.add('00eA0000000QqGH' );
			allowedIds.add('00eA0000000QOwu' );
			allowedIds.add('00eA0000000RgOE' );
			allowedIds.add('00eA0000000Qmsl');

			for( Profile p : [SELECT Id FROM Profile WHERE id in :allowedIds] )
			{
				if( p.id == UserInfo.getProfileId() )
				{
					hasCreditAcces = true;
					break;
				}
			}
		}
		
		return hasCreditAcces;
	}


	public boolean getHasAccess() { 
		Profile p = [SELECT id FROM profile where id = :GlobalStrings.RequiredProfileIDForSharePool()];
		return ( Userinfo.getProfileId() == p.id ? false : true ); //if they have the rep profile, they are invalid
	
	} 
	
	public Opportunity getOpp (){ return o; }

	public string getNewLink() { return '/apex/Opportunity_TeamSplit_New?id='+this.o.id; }

	private List<OTM> otms = null;
	public List<OTM> getOTMs() {
		
		/*
		if( otms == null )
		{
			otms = new List<nrOpportunityTeamMember__c>();
			for( nrOpportunityTeamMember__c otm : [SELECT TeamMemberRole__c, UsersName__c,Credit__c, Credit1__c, Id, Commission__c,OpportunityAccessLevel__c FROM nrOpportunityTeamMember__c WHERE Opportunity__c = :o.Id ] )
			{
				otms.add(otm);
			}
		}
		return otms;
		*/
		
		if( otms == null )
		{
			otms = new list<OTM>();
			map<string, OTM>  otmMap = new map<string, OTM>();
//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'Id: ' + this.o.Id ));				
			for( OpportunityTeamMember tm : [ SELECT Id, UserId, User.FirstName, User.LastName,OpportunityAccessLevel,TeamMemberRole,Credit__c,Credit1__c  FROM OpportunityTeamMember WHERE OpportunityId = :this.o.Id ] )
			{
				if( !otmMap.containsKey(tm.UserId) )
				{
					otmMap.put( tm.UserId, new OTM( ) );
					
				}
				
				otmMap.get(tm.UserId).tm = tm;
				otmMap.get(tm.UserId).Id = tm.UserId;
				
			}
			
			OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];			
			for( OpportunitySplit split : [ SELECT Id, SplitOwnerId, SplitPercentage FROM OpportunitySplit WHERE OpportunityId = :this.o.Id and splittypeid = :splittype.id ] )
			{
				if( !otmMap.containsKey(split.SplitOwnerId) )
				{
					otmMap.put( split.SplitOwnerId, new OTM() );
				}
				
				otmMap.get(split.SplitOwnerId).split = split;
				otmMap.get(split.SplitOwnerId).Id = split.SplitOwnerId;
				
			}
			
			otms = otmMap.values();
			
		}

		
		
		
		return otms;
	}

	public PageReference UpdateOTMs() {
		try {		
			Double total = 0;
			for( OTM otm : otms )
			{
				total += otm.split.SplitPercentage;
			}
			if( total == 100 )
			{

				//DO THE UPDATE ON THE TEAM MEMBERS
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'Updated Salesteams' ));		
				list<OpportunityTeamMember> tmsToUpdate = new list<OpportunityTeamMember>();
				list<OpportunitySplit> splitsToUpdate = new list<OpportunitySplit>();
				for( OTM otm : otms )
				{
				
					tmsToUpdate.add( otm.tm );
					splitsToUpdate.add( otm.split );
				}


				update tmsToUpdate;
				update splitsToUpdate;	
				renderRedirectCode = true;
				
			} else 
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,  'The commissions you entered add up to ' + total + '. They must equal 100 in order to save' ));		
			}			
		} catch( Exception ex ) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Exception: ' + ex  ));		
		
		}
		return null;
		
	}

	private boolean renderRedirectCode = false;
	public boolean getRenderRedirectCode() { return renderRedirectCode;   }    
}