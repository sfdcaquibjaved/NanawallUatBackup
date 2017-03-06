public with sharing class Account_OrderedProjs_ListController {

	public string BaseUrl{ 
		get { return GlobalStrings.HostName(); }
		set;
	}

	class OppWrapper
	{
		public string Id { get; set; }
		public string Name { get; set; }
		public string OrderList { get; set; }
	}
	
	public list<OppWrapper> orderedProjects 
	{
		get 
		{
			if( orderedProjects == null )
			{
				system.debug(this.acc);
				orderedProjects = new List<OppWrapper>();
				set<Id> projectIds = new set<Id>();
				map<Id, Opportunity> oppMap = new map<Id, Opportunity>();
				map< Id, list<Quote__c> > orderMap = new map< Id, list<Quote__c>>();
				for( Opportunity o : [ SELECT Id, Name FROM Opportunity WHERE Id in (SELECT Opportunity__c FROM nrOpportunity_Account__c WHERE Account__c = :this.acc.Id 	) ] )
				{
					oppMap.put(o.Id, o);

					orderMap.put( o.Id, new List<Quote__c>() );
					
					if( !projectIds.contains(o.Id) )
						projectIds.add(o.Id);
				}
				
				
				list<Id> lookupIds = new list<Id>( projectIDs );
				projectIds = new set<Id>();
				for( Quote__c q : [SELECT Id, Opportunity__c, Name FROM Quote__c WHERE Ordered__c = true AND Opportunity__c in :lookupIds] )
				{
					
					orderMap.get(q.Opportunity__c).add( q );
					
					if( !projectIds.contains(q.Opportunity__c) )
						projectIds.add(q.Opportunity__c);
				}

				for( Id oppId : projectIds )
				{
					Opportunity o = oppMap.get(oppId);
					OppWrapper ow = new OppWrapper();
					ow.Id = o.Id;
					ow.Name = o.Name;
					
					 ow.OrderList = '';
					for( Quote__c q : orderMap.get(o.Id) )
					{
						if( ow.OrderList != '' ) ow.OrderList += ', ';
						ow.OrderList += '<a href="javascript:goTo(\''+q.Id+'\')">'+q.Name+'</a>';
					}

					orderedProjects.add( ow );
				}
			}
			
			return orderedProjects;
		}
		set {}
	}


    private final Account acc;
    public Account_OrderedProjs_ListController(ApexPages.StandardController stdController) 
    {    
        this.acc = (Account)stdController.getRecord();    
    }

}