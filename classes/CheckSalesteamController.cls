public with sharing class CheckSalesteamController {

	public Opportunity dummyopportunity { 
		get
		{
			if( dummyOpportunity == null )
				dummyOpportunity = new Opportunity();
				
			return dummyOpportunity;
		} 
		set; 
	}

	class MissingTeamMember
	{
		public string OpportunityId { get; set; }
		public string OpportunityName { get; set; }
		public string RepID { get; set; }
		public string RepName  { get; set; }
	}

	public list<MissingTeamMember> missingTeamMembers  {get {  if(missingTeamMembers == null ) missingTeamMembers = new List<MissingTeamMember>();  return missingTeamMembers; } set;}

	public PageReference runCheck() 
	{


		missingTeamMembers  = new list<MissingTeamMember>();

		set<id> opportunityIds = new set<id>();
		map<id, set<Id> > expectedSalesTeams = new map<id, set<Id> > ();
		map<id, set<Id> > existingSalesTeams = new map<id, set<Id> > ();
		integer expectedSalesTeamCount = 0;
		integer existingSalesTeamCount = 0;
		
		map<Id, string> oppNamMap = new map<Id, string>();
		map<Id, User> userMap = new map<Id, User>();
		
		for( User u : [SELECT id, firstName, LastName FROM User ] )
		{
			userMap.put( u.Id, u );
		}
		
		for( nrOpportunityContactRole__c contRole : [SELECT Contact__r.OwnerID, Opportunity__c,Opportunity__r.Name FROM nrOpportunityContactRole__c WHERE Opportunity__c in (SELECT Id FROM Opportunity  WHERE CreatedDate >= :dummyopportunity.Nana_Create_Date__c AND CreatedDate <= :dummyopportunity.Nana_Edit_Date__c AND StageName like '%Order%' ) ] )
		{

			if( !opportunityIds.contains(contRole.Opportunity__c ) ) 
				opportunityIds.add( contRole.Opportunity__c);
				
			if( !expectedSalesTeams.containsKey(contRole.Opportunity__c ))
				expectedSalesTeams.put(contRole.Opportunity__c, new set<Id>() );
				
			if( !expectedSalesTeams.get(contRole.Opportunity__c).contains(contRole.Contact__r.OwnerID) )
			{
				expectedSalesTeams.get(contRole.Opportunity__c).add(contRole.Contact__r.OwnerID);
				expectedSalesTeamCount++;
			}
			
			oppNamMap.put( contRole.Opportunity__c, contRole.Opportunity__r.Name );
		}	
			
		for( nrOpportunityTeamMember__c teamMember : [SELECT User__c, Opportunity__c, Opportunity__r.Name FROM nrOpportunityTeamMember__c WHERE Opportunity__c in :new list<Id>(opportunityIds) ] )
		{

			if( !existingSalesTeams.containsKey(teamMember.Opportunity__c ))
				existingSalesTeams.put(teamMember.Opportunity__c, new set<Id>() );
				
			if( !existingSalesTeams.get(teamMember.Opportunity__c).contains(teamMember.User__c) )
			{
				existingSalesTeams.get(teamMember.Opportunity__c).add(teamMember.User__c);
				existingSalesTeamCount++;
			}
			
			oppNamMap.put( teamMember.Opportunity__c, teamMember.Opportunity__r.Name );
				
		}		

		for( Id OpportunityID : expectedSalesTeams.keySet() )
		{
			for( string UserID_Expected : expectedSalesTeams.get(OpportunityID) )
			{
				boolean hasTeamMember = false;
				for( string UserID_Existing : existingSalesTeams.get(OpportunityID) )
				{
					if( UserID_Existing == UserID_Expected )
					{
						hasTeamMember = true;
						break;
					}
				}
				
				if( !hasTeamMember )
				{
					
					MissingTeamMember member = new MissingTeamMember();
					member.OpportunityId = OpportunityId;
					member.RepID = UserID_Expected;
					member.RepName = userMap.get(UserID_Expected).FirstName + ' ' +  userMap.get(UserID_Expected).LastName;
					member.OpportunityName = oppNamMap.get( OpportunityId);


					missingTeamMembers.add(member);
				}
			}
		}
		
		ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Info, 'Total Opportunities to check: ' + opportunityIds.size()+ '; Total Expected Salesteam members:  ' + expectedSalesTeamCount + '; Existing Salesteam Members: ' + existingSalesTeamCount + '; team members to add: ' + missingTeamMembers.size()) );
		
		return null;
	}
 
}