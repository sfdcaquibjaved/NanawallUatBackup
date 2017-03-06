public with sharing class VerifyOpportunityAccountsController {

public VerifyOpportunityAccountsController() {
	if( oppAcc == null )
	{
		oppAcc = new nrOpportunity_Account__c();
		verifyButtonVisiable = true;
		commitButtonVisiable = false;
	}
}

	public nrOpportunity_Account__c oppAcc { get; set; }

	public boolean verifyButtonVisiable { get; set; }
	public boolean commitButtonVisiable { get; set; }
	
	public PageReference verify() 
	{
		accJoinToAdd = new List<nrOpportunity_Account__c>();
		
		find();
		if( accJoinToAdd.size() > 0 )
			commitButtonVisiable = true;
		
		for( nrOpportunity_Account__c accjoin : accJoinToAdd )
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'Need <a href="/'+accJoin.Account__c+'" target="_blank">' + accJoin.Account__c + '</a> to <a href="/'+accJoin.Opportunity__c+'">'+accJoin.Opportunity__c+'</a>' ));
		}					
		return null;
	}
	
	public pagereference commitaccounts(){
	
		if( accJoinToAdd.Size() > 0 )
		{
			for( nrOpportunity_Account__c accjoin : accJoinToAdd )
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'Adding <a href="/'+accJoin.Account__c+'" target="_blank">' + accJoin.Account__c + '</a> to <a href="/'+accJoin.Opportunity__c+'">'+accJoin.Opportunity__c+'</a>' ));
			}
			
			insert accJoinToAdd;
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'Those account joinss have been added.' ));
//			return new Pagereference('/' + o.Opportunity__c );
		
		}
		commitButtonVisiable = false;
		
		return null;
	} 
	
	list<nrOpportunity_Account__c> accJoinToAdd = new List<nrOpportunity_Account__c>();
	public void find () {
		
		set<id> AccountsToFindParents = new set<id>();
		set<string> existingProjAccs = new set<string>();



		integer currentCount = 0;
		//look at the already existing joins on the projects 
		//also build a list of all the contacts' accounts and the project accounts to look at for uplines
		list<nrOpportunity_Account__c> accjoins = new List<nrOpportunity_Account__c>();
		
		for( nrOpportunity_Account__c joins : [SELECT Id, Opportunity__c, Account__c FROM nrOpportunity_Account__c WHERE Account__c = :oppAcc.Account__c]  )
		{
			existingProjAccs.add(joins.opportunity__c + '_' + joins.Account__c);
			accjoins.add(joins);
			AccountsToFindParents.add( joins.Account__c);
		}	

/*		 this wont work for this kind of code; need to fix this up with the other back fill code on Nana server
		for( Contact c : [SELECT AccountId, id FROM Contact WHERE id in (SELECT Contact__c FROM nrOpportunityContactRole__c WHERE Opportunity__c in :oppIds) ] )
		{

			if( !AccountsToFindParents.contains( c.AccountId ))			
				AccountsToFindParents.add( c.AccountId );
		}		  		
		*/
		currentCount = existingProjAccs.size();

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
//
				
					if( parentAccs.size() > 0 )
					{
						accountsToFindParents_List = new list<id>(AccountsToFindParents);
						AccountsToFindParents = new set<id>();
						for(Account a : [SELECT Id,ParentId,Franchise_Owner__c FROM Account WHERE id in :accountsToFindParents_List ] )
						{
							list<nrOpportunity_Account__c> tempAccjoins = new list<nrOpportunity_Account__c>( accjoins ); //cant modify whil eiterating
							for(nrOpportunity_Account__c accjoin : tempAccjoins) {
								//look at current account joins -- if you find an account with this ID, create a new join with it's parent
								if( a.id == accJoin.Account__c )
								{ //if the account we are currently looking at matches one of the account joins we've found so far ... 
									// ...AND it has a parent, add the parent's join
									if(a.parentid != null 
									&& !existingProjAccs.contains(accJoin.Opportunity__c + '_' + a.ParentId )) //dont duplicate it
									{
										nrOpportunity_Account__c parentaccjoin = new nrOpportunity_Account__c();
										parentaccjoin.Account__c = a.ParentId;
										parentaccjoin.opportunity__c = accJoin.Opportunity__c;
										accJoins.add( parentaccjoin );
										accJoinToAdd.add(parentaccjoin);
										existingProjAccs.add(accJoin.Opportunity__c + '_' + a.ParentId );//putting it in here will prevent it from being added multiple times in this trigger		  		
									}
											
		
									if(a.Franchise_Owner__c != null 
									&& !existingProjAccs.contains(accJoin.Opportunity__c + '_' + a.Franchise_Owner__c )) //dont duplicate it
									{
										nrOpportunity_Account__c franchiseaccjoin = new nrOpportunity_Account__c();
										franchiseaccjoin.Account__c = a.Franchise_Owner__c;
										franchiseaccjoin.opportunity__c = accJoin.Opportunity__c;
										accJoins.add( franchiseaccjoin );
										accJoinToAdd.add(franchiseaccjoin);
										existingProjAccs.add(accJoin.Opportunity__c + '_' + a.Franchise_Owner__c );//putting it in here will prevent it from being added multiple times in this trigger		  		
									}
		
									if( a.ParentID != null ) 
									{
										AccountsToFindParents.add( a.parentid ); //put the parentid on the list to see if it has a parent
									}
									if( a.Franchise_Owner__c != null ) 
									{
										
										AccountsToFindParents.add( a.Franchise_Owner__c ); //put the parentid on the list to see if it has a parent
									}
								}
							}	
						}
						
					}  else 
					{
						
						checkAccounts = false;
					}
lineNbr = '8';
				}
			}		
		} catch( Exception ex ) 
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,  'An error occurred while trying to add this project account. '+ ex ));		
			
		}				


		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,  'This account currently has  ' + currentCount +' joins. It should have ' + accJoinToAdd.size() + ' additional joins.' ));
	
		return;
		
	
	}
}