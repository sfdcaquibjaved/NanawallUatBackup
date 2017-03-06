public with sharing class nrSalesteamListController {

	private final Opportunity o;
	public nrSalesteamListController(ApexPages.StandardController stdController) {
		this.o = (Opportunity)stdController.getRecord();
		
	}
	
	private string buildNanaSoapEnvelope(string xml) {
            string xml2 = '<?xml version=\'1.0\' encoding=\'utf-8\'?>';
            xml2 += '<soap12:Envelope xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xmlns:xsd=\'http://www.w3.org/2001/XMLSchema\' xmlns:soap12=\'http://www.w3.org/2003/05/soap-envelope\'>';
            xml2 += '<soap12:Body><TriggerAutoQuote  xmlns="http://tempuri.org/"><xml>';
            xml2 += xml;
            xml2 += '</xml></TriggerAutoQuote></soap12:Body>';
            xml2 += '</soap12:Envelope>';
		return xml2;
	}
	
	public string DeleteOppRepID { get; set; }
	public PageReference DeleteOppRep() {


		nrOpportunityTeamMember__c otm = [SELECT id,Opportunity__c,User__c FROM nrOpportunityTeamMember__c WHERE id = :DeleteOppRepID ];

		delete otm;
		otms = null;

		set<id> ids = new set<id>();
		ids.add(otm.Opportunity__c);
		Async_WebServiceCaller.FlushNanaCache(ids, 'Opportunity');

/*		ids = new set<id>();
		ids.add(otm.Id);
		Async_WebServiceCaller.FlushNanaCache(ids, 'nrOpportunityTeamMember__c');
*/
		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'Deleted team member.' ));		

	
	
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
		return true;
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
//		Profile p = [SELECT id FROM profile where id = :GlobalStrings.RequiredProfileIDForSharePool()];
//		return ( Userinfo.getProfileId() == p.id ? false : true ); //if they have the rep profile, they are invalid
	
		return true; //we now allow anyone to add/update a rep on the salesteam	
	} 
	
	public Opportunity getOpp (){ return o; }

	public string getNewLink() { return GlobalStrings.NewSaleTeamMemberLink( o.id  ); }

	private List<nrOpportunityTeamMember__c> otms = null;
	public List<nrOpportunityTeamMember__c> getOTMs() {
		if( otms == null )
		{
			otms = new List<nrOpportunityTeamMember__c>();
			for( nrOpportunityTeamMember__c otm : [SELECT TeamMemberRole__c, UsersName__c,Credit__c, Credit1__c, Id, Commission__c,OpportunityAccessLevel__c FROM nrOpportunityTeamMember__c WHERE Opportunity__c = :o.Id ] )
			{
				otms.add(otm);
			}
		}
		return otms;
	}

	public PageReference UpdateOTMs() {
		try {		
			Double total = 0;
			for( nrOpportunityTeamMember__c otm : otms )
			{
				total += otm.Commission__c;
			}
			if( total == 100 )
			{
				update otms;
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'Updated Salesteams' ));		
	
				o.IsDirty__c = true;
				update o; //flag it as dirty
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