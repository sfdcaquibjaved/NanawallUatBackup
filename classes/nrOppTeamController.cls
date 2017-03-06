//public with sharing class nrOppTeamController {
public class nrOppTeamController {

    private Set<Id> GetGroupShareList( Id id ) {
    
        Set<Id> shareSet = new Set<id>( );

		User u = [SELECT id, UserRoleID FROM User WHERE id = :id];
//		List<User> allUsers = [SELECT id, UserRoleID, ProfileID, UserRole.ParentRoleID FROM User WHERE IsActive = true];
		List<UserRole> allUserRoles = [SELECT id, ParentRoleID, PortalRole, Name FROM UserRole];
		
		
         
        Set<id> UserRoleIDs = new Set<Id>();
	    map< string, UserRole> userRoleMap = new map<String,UserRole>();
        for( UserRole ur : allUserRoles ) 
        {
        	userRoleIDs.add( ur.id );
        	userRoleMap.put( ur.id, ur);
        }
        List<Group> allGroups = [SELECT id, Name, RelatedID, Type FROM Group WHERE RelatedID in :userRoleIDs ];
		    
	    map< string, list<group> > roleToGroupMap = new map<String, list<group> >();
	    map< string, group> groupMap = new map<String,group>();
		for( Group g : allGroups )
		{
			if( roleToGroupMap.get(g.RelatedID)  == null )
				roleToGroupMap.put(g.RelatedID, new LIst<Group>() );
				
			roleToGroupMap.get( g.RelatedID ).add(g);
			groupMap.put(g.id, g);
		}
		//look for this user's role
		string NextRoleId = '';
		for( UserRole ur : allUserRoles )
		{
			if( ur.id == u.userRoleID )
			{
				NextRoleID = ur.id;
				break;
			}
		}		
		//drill down to find the bottom most role in the hierarchy
		Boolean keepLooking = true;
		while( keepLooking )
		{
			boolean foundOne = false;
			for( UserRole ur : allUserRoles )
			{
				if( ur.ParentRoleId == NextRoleID )  //this role is one down in the hierarchy from the last located role id in the hierarchy
				{
					NextRoleID = ur.id;
					foundOne = true;
					break;
				}
			}
			keepLooking = foundOne; //we stop when we did not locate any role with the currentrole as its parent
		} 
		
		//at this point we should have located the UserRoleID farthese down on the totem pole
		//now push upward looking for all share groups we need to add
		keepLooking = true;
		while( keepLooking )
		{
			boolean foundOne = false;
			for( UserRole  ur : allUserRoles ) 
			{
					if( ur.Id == NextRoleId && roleToGroupMap.containsKey( ur.Id ) )
					{
						
//						if( !shareSet.contains(ur.Id) )
						{
							UserRole r = userRoleMap.get(ur.Id);
							for( Group g : roleToGroupMap.get( ur.id ) )
							{
								if( g.Type == 'RoleAndSubordinates' &&  ( r.PortalRole == 'Executive' || r.Name.toLowerCase().contains('executive') )  
								&& r.Name.tolowercase() != 'executives' && !shareSet.contains(g.id) )
									shareSet.add( g.id );
							}
						}
						NextRoleId = ur.ParentRoleId;
						foundOne = true;
						break;
					}
			}
			
			 
			if( NextRoleId == null || NextRoleId == '' || !foundOne)
				keepLooking = false;
		}		    
		
		//oh won't you take me to ... hacky town? yes ! i will! i couldn't figure out how the cross-territory sharing rules were working
		//under the covers, so i am hard coding the one scenario they have that does this - ks
		try {
			if( shareSet.contains('00GA0000000KAjCMAW')  //canada share group
				|| shareSet.contains('00GA0000000J337MAC')    //CAnorth-NVnorth Partner Executive
				|| shareSet.contains('00GA0000001KkKcMAK') ) //CAsouth Partner Executive
			{
				if(!shareSet.contains('00GA0000001Kk9vMAC')) 
					shareSet.add( '00GA0000001Kk9vMAC'); //add the Hawaii group if its not on there
			}
		} catch(Exception ex )
		{
		    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Share exception:  ' + ex ));
		}
/*		
		string roleList = '';
		for(  Id i : shareSet )
		{
			roleList += i + ' = ' + groupmap.get(i).Name + ' '+ groupmap.get(i).Type+'<br /> ';
		}

	    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'Groups to share for id  ' + id + ':<br />'  + roleList ));
*/
		    
    
        return shareSet;
    }
    

// Constructor - this only really matters if the autoRun function doesn't work right
	private final nrOpportunityTeamMember__c nrOTM;

	private OpportunityShare os;
	public nrOppTeamController(ApexPages.StandardController stdController) {
		this.nrOTM = (nrOpportunityTeamMember__c)stdController.getRecord();
		if( nrOTM.id != null )
		{
			os = [SELECT OpportunityAccessLevel, Id, RowCause FROM OpportunityShare WHERE OpportunityID = :nrOTM.Opportunity__c AND UserOrGroupId = :nrOTM.User__c AND rowcause != 'ImplicitChild' AND rowcause != 'Rule' ];
		}
		else os = new OpportunityShare();
	}
	
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
	
	
	
		
	public boolean getDontRenderUserLookup() {
		if( nrOTM.id == null ) return false;
		else return true;
	}

	public boolean getRenderUserLookup() {
		if( nrOTM.id == null ) return true;
		else return false;
	}
	public boolean getEditRoleNotOK() {
		
		if( nrOTM.Id == null ) return false;
		
		if( os.RowCause == 'Owner' ) return true;
		else return false;
	}
	public string getUserName() {
		if( nrOTM.id == null ) return '';
		
		user u = [SELECT firstname, lastname FROM user where id = :nrOTM.User__c ];
		
		return u.FirstName+ ' ' + u.LastName;
	}
	public boolean getEditRoleOK() {
		
		if( nrOTM.Id == null ) return true;
		
		if( os.RowCause == 'Owner' ) return false;
		else return true;

//		return true;
	}

	public Pagereference Cancel() {
		PageReference ref = new PageReference('/' + nrOTM.Opportunity__c );			
		ref.setRedirect(true);
		return ref;
	
	}

	public PageReference UpdateRec() {

		string nbrline = '38';
try {
		OpportunityTeamMember otm;
		OpportunityShare os; // = new OpportunityShare();
		boolean createNewOppShare = false;
		boolean doNotUpdateOppShare = false;
		list<OpportunityShare> osInserts = new List<OpportunityShare>();
		if( nrOTM.Id == null )
		{
			nbrline = '43';

			if([SELECT id FROM nrOpportunityTeamMember__c WHERE User__c = :selectedUser AND Opportunity__c = :nrOTM.Opportunity__c  ].size() > 0 )
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'This user is already on the project' ));						
				return null;
			}

		
			nbrline = '50';
			nrOTM.User__c = selectedUser;
			nrOTM.OpportunityAccessLevel__c = selectedAccessLevel;
			insert nrOTM;
			
			if( [Select count() FROM OpportunityShare WHERE OpportunityID = :nrOTM.Opportunity__c AND UserOrGroupID = :nrOTM.User__c AND rowcause != 'ImplicitChild' AND rowcause != 'Rule' ] > 0  )
			{ //if we have an existing oppshare (ie from an Owner that pre-exists )
				os = [SELECT OpportunityAccessLevel, Id, RowCause FROM OpportunityShare WHERE OpportunityID = :nrOTM.Opportunity__c AND UserOrGroupId = :nrOTM.User__c AND rowcause != 'ImplicitChild' AND rowcause != 'Rule' ];
				doNotUpdateOppShare = true;
				
				nrOTM.OpportunityAccessLevel__c = 'Owner';
				update nrOTM;
			} else {
				os = new OpportunityShare();
				os.UserOrGroupId = nrOTM.User__c;
				os.OpportunityId = nrOTM.Opportunity__c;
				osInserts.add( os );
				createNewOppShare = true;
			}
		} else 
		{
			nbrline = '55';
			if( nrOTM.OpportunityAccessLevel__c != 'Owner' )
			{  //we cannot update the owner's access level
				nrOTM.OpportunityAccessLevel__c = selectedAccessLevel;
			}
			update nrOTM; 
			os = this.os;
		}
	
		nbrline = '70';
		
		
		try
		{
			set<id> sharesToInsert = GetGroupShareList(nrOtm.USer__c);
			list<OpportunityShare> shares = new list<OpportunityShare>();
			for( id groupID : sharesToInsert )
			{
				OpportunityShare groupShare = new OpportunityShare();
				groupShare.UserOrGroupId = groupID;
				groupShare.OpportunityId = nrOtm.Opportunity__c;
				groupShare.OpportunityAccessLevel = 'Edit';
				osInserts.add(groupShare);
			}
		} catch (Exception ex )
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'exception: '+ ex ));						
		}
			
		
		if( getEditRoleOK( ) && !doNotUpdateOppShare ) 
		{
			if( nrOTM.OpportunityAccessLevel__c == 'Owner' )
			{
					os.OpportunityAccessLevel = 'All';
			} else if( nrOTM.OpportunityAccessLevel__c == 'Read/Write' )
			{
					os.OpportunityAccessLevel = 'Edit';
			} else
			{
					os.OpportunityAccessLevel = 'Read';
			}
			
		
//			if( createNewOppShare )
			if( osInserts.size() > 0 )
			{
				
		nbrline = '134';
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'operation: insert ' + osInserts.size() + ' shares.'  ));						
				insert osInserts;

//				insert os;
			}
			else {
		nbrline = '139';
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'operation: insert' ));		
				
				update os;
				
			}
		}
		nbrline = '92';		
		Opportunity opp = [SELECT id FROM opportunity WHERE id = :nrOTM.Opportunity__c];	
		opp.IsDirty__c = true;
		update opp;
		
		
		
/*		List<nrOpportunityTeamMember__c> nrotms = new List<nrOpportunityTeamMember__c>();
		for( nrOpportunityTeamMember__c tempotm : [SELECT id FROM nrOpportunityTeamMember__c WHERE Opportunity__c = :nrOTM.Opportunity__c AND id != :nrOTM.Id ] )
		{
//			tempotm.Commission__c = 100-nrOTM.Commission__c;			
			nrotms.add(tempotm);
		}
		if( nrotms.size() > 0 )
		{
			for( Integer i=0; i<nrotms.size(); i++ )
			{
				nrotms[i].Commission__c = (100-nrOTM.Commission__c)/nrotms.size();
			}
			update nrotms; 
		}
		*/
		/*
		PageReference ref = new PageReference('/' + nrOTM.Opportunity__c );			
		ref.setRedirect(true);
		return ref;
		*/
		
		//return null;
		
		PageReference ref = new PageReference('/' + nrOTM.Opportunity__c );			
		ref.setRedirect(true);
		
		
		return ref;
} catch( Exception e ) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Caught an exception: ' + e ));	
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Last Line: ' + nbrline  ));	
			
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		        String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
		        mail.setToAddresses( toAddresses );
		        mail.setReplyTo('admin@a-stechnologies.com');   
		        mail.setSenderDisplayName('Salesforce - Opp Team Insert/Update Error');
		        mail.setSubject('Opp Team Update Error ' );
		        mail.setBccSender(false);
		        mail.setUseSignature(false);
		        mail.setPlainTextBody(' Opp team controller Insert/update on line '+nbrline+'; Opportunity: '+nrOTM.Opportunity__c+' <br />' + e  );
		        mail.setHtmlBody(' Opp team controller Insert/update on line '+nbrline+'; Opportunity: '+nrOTM.Opportunity__c+' <br />' + e );
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });      
			
	return null;	
//		PageReference ref = new PageReference('/' + nrOTM.Opportunity__c );			
//		ref.setRedirect(true);
//		return ref;
}		
	}
	
}