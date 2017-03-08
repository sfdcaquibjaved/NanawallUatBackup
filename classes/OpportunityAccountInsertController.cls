public with sharing class OpportunityAccountInsertController {

	//.
	private final nrOpportunity_Account__c o;
	public OpportunityAccountInsertController(ApexPages.StandardController stdController) {
		this.o = (nrOpportunity_Account__c)stdController.getRecord();
	}
	
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
	
	public boolean useCompetitorAccount {
		get 
		{
			if( useCompetitorAccount == null ) useCompetitorAccount = false;
			return useCompetitorAccount;
		} 
		set;
	}
	
	public Pagereference save() {

		if( useCompetitorAccount )
		{
			o.Account__c = competitoraccount;
		} else
		{
			o.Account__c = o.Selector_Account__c;
		}

		if( o.Account__c == null )
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,  'Please select either an account or a competitor account to save this record.'));		
			return null;		
		}

	
		list<nrOpportunity_Account__c> accJoins = new List<nrOpportunity_Account__c>();
		set<id> AccountsToFindParents = new set<id>();
		set<string> existingProjAccs = new set<string>();

		//look at the already existing joins on the project 
		for( nrOpportunity_Account__c joins : [SELECT Id, Opportunity__c, Account__c FROM nrOpportunity_Account__c WHERE Opportunity__c = :o.Opportunity__c]  )
		{
			existingProjAccs.add(joins.opportunity__c + '_' + joins.Account__c);
		}	
		
		accJoins.add( o );
		AccountsToFindParents.add(o.Account__c );
		  		
		
		string lineNbr = '1';
		try {
			if( AccountsToFindParents.size() > 0 )
			{
				boolean checkAccounts = true;
				//detect and add parent accounts -- we dont have a clean way to do this in bulk
				// i am pretty sure this algorithm should work for us, but we will have to see
	
lineNbr = '2';				
				while( checkAccounts )
				{
lineNbr = '3';				
					list<id> accountsToFindParents_List = new list<id>(AccountsToFindParents);
					list<Account> accsToCheckForParents = [SELECT Id,ParentId,Franchise_Owner__c FROM Account WHERE id in :accountsToFindParents_List ];
							
					set<id> parentAccs = new set<id>();
					for( Account a : accsToCheckForParents )
					{
						if( !parentAccs.contains(a.ParentID) )
							parentAccs.add(a.ParentID);
						if( !parentAccs.contains(a.Franchise_Owner__c) )
							parentAccs.add(a.Franchise_Owner__c);
					}
lineNbr = '4';
					
					if( parentAccs.size() > 0 )
					{
						accountsToFindParents_List = new list<id>(AccountsToFindParents);
						AccountsToFindParents = new set<id>();
						for(Account a : [SELECT Id,ParentId,Franchise_Owner__c FROM Account WHERE id in :accountsToFindParents_List ] )
						{
lineNbr = '5';
							list<nrOpportunity_Account__c> tempAccjoins = new list<nrOpportunity_Account__c>( accjoins ); //cant modify whil eiterating
							for(nrOpportunity_Account__c accjoin : tempAccjoins) {		
								//look at current account joins -- if you find an account with this ID, create a new join with it's parent
								if( a.id == accJoin.Account__c  )
								{
lineNbr = '6';
									if(a.parentid != null 
									&& !existingProjAccs.contains(accjoin.opportunity__c + '_' + a.ParentId )) //dont duplicate it
									{
lineNbr = '7';										
										nrOpportunity_Account__c parentaccjoin = new nrOpportunity_Account__c();
										parentaccjoin.Account__c = a.ParentId;
										parentaccjoin.opportunity__c = accjoin.opportunity__c;
										accJoins.add( parentaccjoin );
										existingProjAccs.add(accjoin.opportunity__c + '_' + a.ParentId );//putting it in here will prevent it from being added multiple times in this trigger		  		
									}
									if( a.ParentID != null ) AccountsToFindParents.add( a.parentid ); //put the parentid on the list to see if it has a parent
									

									if(a.Franchise_Owner__c != null 
									&& !existingProjAccs.contains(accjoin.opportunity__c + '_' + a.Franchise_Owner__c )) //dont duplicate it
									{
lineNbr = '7c';
system.debug('have a franchise owner');
										nrOpportunity_Account__c franchiseaccjoin = new nrOpportunity_Account__c();
										franchiseaccjoin.Account__c = a.Franchise_Owner__c;
										franchiseaccjoin.opportunity__c = accjoin.opportunity__c;
										accJoins.add( franchiseaccjoin );
										existingProjAccs.add(accjoin.opportunity__c + '_' + a.Franchise_Owner__c );//putting it in here will prevent it from being added multiple times in this trigger		  		
									}//Matt Spessard
system.debug('end of franchise owner check');									
									if( a.Franchise_Owner__c != null ) AccountsToFindParents.add( a.Franchise_Owner__c ); //put the parentid on the list to see if it has a parent
									
								}
							}
							
							if( AccountsToFindParents.size() < 1 )
								checkAccounts = false; //we didnt have any more parentids, kill the loop
						}
					}  else checkAccounts = false;
lineNbr = '8';
					if(  (Limits.getLimitDmlStatements() + 4) >  = Limits.getLimitDmlRows() )
					{ //do an emergency check to make sure we arent running out of dml calls
						// i  *think* we just need 4 more calls to handle the last four possible updates
lineNbr = '9';
						checkAccounts = false;
					}
				}
			}		
		} catch( Exception ex ) 
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,  'An error occurred while trying to add this project account. '+ ex ));		
			
		}				


		if( accJoins.size() > 0 )
		{
			insert accJoins;
			return new Pagereference('/' + o.Opportunity__c );
			
		}
	
		return null;
	}

	public Pagereference cancel() {
	
	
		return new Pagereference('/' + o.Opportunity__c );
	}

//
}