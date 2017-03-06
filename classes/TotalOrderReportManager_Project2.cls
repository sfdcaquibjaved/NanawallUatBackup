global  with sharing class TotalOrderReportManager_Project2 implements Schedulable {

	// static instance variables
	global static string LastResult = 'INIT';
	global static boolean running = false;
	
	//end static instance variables


	// intermediate classes
    class SF_TotalOrderResult 
    {
    	/*
	Project_Split__c
	Territory__c
    	*/
        public Id  project { get; set; }
		public Id contact { get; set; }
		public list<Order> orderList { get; set; } 
		public list<Project_Split__c> splitList { get; set; }

		public SF_TotalOrderResult ( Id p, Id c )  
		{
			project = p;
			contact = c;
			orderList = new list<Order>(); 
			splitList = new list<Project_Split__c>();
		}

    }	
	//end intermediate classes
	private static string cronKey = 'TotalOrderReportManager_Project';
	public static string getcronkey() { return cronkey; }

	global static void insertScheduler(integer nextRun) {
		
		//1. kill the currently scheduled job
		Application_Setting__c cronSetting = null;		
		try {
			cronSetting = [SELECT Setting_Name__c, Setting_Value__c FROM Application_Setting__c WHERE Setting_Name__c = :TotalOrderReportManager_Project.getcronKey() ];
		} catch( Exception ex ) 
		{
System.debug('Cron setting was null..');					
		}
		
		if( cronSetting != null )
		{ 	//this should only be triggered when there is no Setting for the job
			//this will get recreated byt he insertScheduler call below
System.debug('found an old cron setting to kill.');			
				try
				{
				System.abortJob( cronSetting.setting_value__c );		
				} catch(Exception ex )
				{}
				delete cronSetting;
		}
		
		//2. reschedule the run for 10 minutes from now
		DateTime nextRunTime = datetime.now().addMinutes( nextRun );
		String jobID = System.schedule( TotalOrderReportManager_Project.getcronkey(),'0 '+nextRunTime.minute()+' * * * ?', new TotalOrderReportManager_Project() );
		cronSetting = new Application_Setting__c();
		cronSetting.Setting_Name__c = TotalOrderReportManager_Project.getcronkey();
		cronSetting.setting_value__c = jobid;
		insert cronSetting;	
	}


    global void execute(SchedulableContext SC) 
    {
    	integer firstYear = 2009;
    	integer nextYear = date.today().year(); 
    	integer nextYearSegment = 1;
		map<string, Application_Setting__c> settings = new map<string, Application_Setting__c>();

		for( Application_Setting__c appSetting : [SELECT Id, Setting_Name__c, Setting_Value__c FROM Application_Setting__c WHERE Setting_Name__c  like 'TotalOrderReport_Project_%' ] )
		{

			if( appSetting.Setting_Name__c == 'TotalOrderReport_Project_StartYear' )
			{
				firstYear = integer.valueOf( appSetting.Setting_Value__c);
				settings.put( appSetting.Setting_Name__c, appSetting );			
			} else if ( appSetting.Setting_Name__c == 'TotalOrderReport_Project_LastYearSegmentProcessed') 
			{
				if (appSetting.Setting_Value__c == null )
					appSetting.Setting_Value__c = '1'; 
				else if( appSetting.Setting_Value__c == '1')
				{
					 nextYearSegment = 2;
				} else if( appSetting.Setting_Value__c == '2')
				{
					nextYearSegment = 3;
				} else if(appSetting.Setting_Value__c == '3')
				{
					nextYearSegment = 4;
				} else if( appSetting.Setting_Value__c == '4' )
				{
					nextYearSegment = 5;
				} else if( appSetting.Setting_Value__c == '5' )
				{
					nextYearSegment = 6;					
					
				} else if( appSetting.Setting_Value__c == '6' )
				{
					nextYearSegment = 7;					
					
				} else if( appSetting.Setting_Value__c == '7' )
				{
					nextYearSegment = 8;					
					
				} else if( appSetting.Setting_Value__c == '8' )
				{
					nextYearSegment = 9;					
					
				} else if( appSetting.Setting_Value__c == '9' )
				{
					nextYearSegment = 10;					
					
				} else if( appSetting.Setting_Value__c == '10' )
				{
					nextYearSegment = 11;					
					
				} else if( appSetting.Setting_Value__c == '11' )
				{
					nextYearSegment = 12;					
					
				} else 
				{
					nextYearSegment = 1;
				}
				settings.put( appSetting.Setting_Name__c, appSetting );			
				
				
			} else if(appSetting.Setting_Name__c == 'TotalOrderReport_Project_LastYearProcessed') 
			{
				if (appSetting.Setting_Value__c == null )
					appSetting.Setting_Value__c = '2009'; 
					
				else nextYear = integer.valueOf( appSetting.Setting_Value__c);
	
				settings.put( appSetting.Setting_Name__c, appSetting );			
				
			} else if(appSetting.Setting_Name__c == 'TotalOrderReport_Project_RunLog') 
			{
				settings.put( appSetting.Setting_Name__c, appSetting );			
			}
		}		
		
		if(nextYearSegment == 1 ) 
		{ //we've rolled past 12
			nextYear++;
		}

		if( nextYear > date.today().year() )
		{
			nextYear = firstYear; //going into the future, loop back around
		}


		RunYearSegment( nextYear, nextYearSegment  ); 
		
		LastResult += 'Updating the cron to run again in 2 minutes.<br />\n';
		TotalOrderReportManager_Project.insertScheduler(2); //will take 24 minutes roughly to do one year
				
		System.debug('$$$$$$$$$$' + nextYear);
		System.debug('#########' + nextYearSegment);
		System.debug('@@@@@@@@@' + LastResult);		
				
		settings.get('TotalOrderReport_Project_LastYearProcessed').Setting_Value__c =  string.valueOf(nextYear);
		settings.get('TotalOrderReport_Project_LastYearSegmentProcessed').Setting_Value__c =  string.valueOf(nextYearSegment);
//		settings.get('TotalOrderReport_Project_RunLog').Setting_Value__c =  LastResult;
		
		System.debug('$$$$$$$$$$$' + settings.values());
		
		update settings.values();

    }

    public static void RunYearSegment(integer YearToRun, integer SegmentToRun) 
    {

		if( !running )
		{
			running = true;
			TotalOrderReportManager_Project.LastResult = 'Starting Total Order Report (project) rebuild run at ' + datetime.now()+'<br />\n';
	        Date startDate = Date.Parse('1/1/2009');
	        Date endDate = Date.Parse('12/31/2009');
	
			integer startYear = 2009;
			integer toYear = Date.today().year();

        	//disabled when developing, restore before release
            try
            {
                startDate = Date.Parse( ( SegmentToRun == 1 ? '1/1/' : '6/2/' ) + YearToRun);
                endDate = Date.Parse(  (SegmentToRun == 1 ?   '6/1/' : '12/31/' ) + YearToRun);
	                  
                if(SegmentToRun == 1 )
                {
                	startDate  = Date.Parse('1/1/' + YearToRun);
                	endDate = Date.Parse( '2/1/' + YearToRun);
                } else if( SegmentToRun == 2 )
                {
                	startDate = Date.Parse('2/1/' + YearToRun);
                	endDate = Date.Parse( '3/1/' + YearToRun);
                } else if( SegmentToRun == 3)
                {
                	startDate = Date.Parse( '3/1/' + YearToRun);
                	endDate = Date.Parse( '4/1/' + YearToRun);
                } else if( segmentToRun == 4 )
                {
                	startDate = Date.Parse( '4/1/' + YearToRun);
                	endDate = Date.Parse( '5/1/' + YearToRun);
                } else if( segmentToRun == 5 )
                {
                	startDate = Date.Parse( '5/1/' + YearToRun);
                	endDate = Date.Parse( '6/1/' + YearToRun);
                	                	                	
                } else if( segmentToRun == 6 )
                {
                	startDate = Date.Parse( '6/1/' + YearToRun);
                	endDate = Date.Parse( '7/1/' + YearToRun);
                	                	                	
                } else if( segmentToRun == 7 )
                {
                	startDate = Date.Parse( '7/1/' + YearToRun);
                	endDate = Date.Parse( '8/1/' + YearToRun);
                	                	                	
                } else if( segmentToRun == 8 )
                {
                	startDate = Date.Parse( '8/1/' + YearToRun);
                	endDate = Date.Parse( '9/1/' + YearToRun);
                	                	                	
                } else if( segmentToRun == 9 )
                {
                	startDate = Date.Parse( '9/1/' + YearToRun);
                	endDate = Date.Parse( '10/1/' + YearToRun);
                	                	                	
                } else if( segmentToRun == 10 )
                {
                	startDate = Date.Parse( '10/1/' + YearToRun);
                	endDate = Date.Parse( '11/1/' + YearToRun);
                	                	                	
                } else if( segmentToRun == 11 )
                {
                	startDate = Date.Parse( '11/1/' + YearToRun);
                	endDate = Date.Parse( '12/1/' + YearToRun);
                	                	                	
                	                	                	
                } else 
                {
                	startDate = Date.Parse('12/1/' + YearToRun);
                	endDate = Date.Parse( '12/31/' + YearToRun);
                }
	                
	                
				LastResult += 'TotalOrderReportManager.run() running for year ' + YearToRun +' <br />\n'; 
				doCompile(startDate, endDate);
					
				LastResult += 'Finished running ' + YearToRun + '.<br />\n=========<br />\n';
				System.debug('finished running totalorderreportmanager');
            } catch (Exception ex)
            {
               LastResult += 'Caught an exeception in TotalOrderReportManager.run() for ' + YearToRun + '. ' + ex + ' on line ' + ex.getLineNumber()  +' <br />\n'; 
            }

	        running = false;
	    }



		System.debug(LastResult);

    }
    
    public static void doCompile(Date startDate, Date endDate ) 
    {
    	map<id, SF_TotalOrderResult > totalOrderLookup = new Map< id, SF_TotalOrderResult >();
    	
    	integer ordercount = 0;
    	//stage 0 - clean up any duplicate records. somehow there are duplicate Unique_Ids in here. 
		list<string> deletelist = new list<string>();
		set<string> existingset = new set<string>();
//		for( Total_Order_Report_Data_Point__c point :  [SELECT Unique_Key__c FROM Total_Order_Report_Data_Point__c WHERE (Nana_Quote__r.Order_Finalized_Date__c  >= :startDate AND Nana_Quote__r.Order_Finalized_Date__c  <= :endDate) OR ( Nana_Quote__r.Invoices_Sent_Date__c != null   AND Nana_Quote__r.Invoices_Sent_Date__c >= :startDate  AND Nana_Quote__r.Invoices_Sent_Date__c <= :endDate )  OR ( Nana_Quote__r.Deposit_Date__c != null   AND Nana_Quote__r.Deposit_Date__c >= :startDate  AND Nana_Quote__r.Deposit_Date__c <= :endDate )  OR ( Nana_Quote__r.Balanced_Received_Date__c != null   AND Nana_Quote__r.Balanced_Received_Date__c >= :startDate  AND Nana_Quote__r.Balanced_Received_Date__c <= :endDate ) OR ( Nana_Quote__r.Deposit_Received_Date__c != null   AND Nana_Quote__r.Deposit_Received_Date__c >= :startDate  AND Nana_Quote__r.Deposit_Received_Date__c <= :endDate ) OR ( Nana_Quote__r.Order_Confirmation_Started__c != null   AND Nana_Quote__r.Order_Confirmation_Started__c >= :startDate  AND Nana_Quote__r.Order_Confirmation_Started__c <= :endDate ) ] )
		for( Total_Order_Report_Data_Point__c point :  [SELECT Unique_Key__c FROM Total_Order_Report_Data_Point__c WHERE (Order_Finalized_Date__c  >= :startDate AND Order_Finalized_Date__c  <= :endDate) ] )
		{
			if( !existingset.contains(point.Unique_Key__c) )
		    {
		        existingset.add( point.Unique_Key__c);
		    } else 
		    {
		        deletelist.add( point.id);
		    }
		}
		
		list<Total_Order_Report_Data_Point__c> deletepoints = [SELECT Id FROM Total_Order_Report_Data_Point__c WHERE Id = :deletelist];
		delete deletepoints;

    	
    	
		//stage 1 - get the quotes
		list<Order> orderList = new list<Order>();
		list<id> projectIds = new list<Id>();
		
		for( Order o : [SELECT Contact__c,Id,Name,NanaQuote__c,OpportunityId,Project__c, NanaQuote__r.Quote_ID__c, Opportunity.Project_Name__c FROM Order WHERE	( Order_Finalized_Date__c != null   AND Order_Finalized_Date__c >= :startDate AND Order_Finalized_Date__c <= :endDate  )  OR ( Invoices_Sent_Date__c != null   AND Invoices_Sent_Date__c >= :startDate  AND Invoices_Sent_Date__c <= :endDate ) OR ( Deposit_Date__c != null   AND Deposit_Date__c >= :startDate  AND Deposit_Date__c <= :endDate ) OR ( Balance_Received_Date__c != null   AND Balance_Received_Date__c >= :startDate  AND Balance_Received_Date__c <= :endDate ) OR ( Deposit_Received_Date__c != null   AND Deposit_Received_Date__c >= :startDate  AND Deposit_Received_Date__c <= :endDate ) OR ( Order_Confirmation_Started__c != null   AND Order_Confirmation_Started__c >= :startDate  AND Order_Confirmation_Started__c <= :endDate ) ] )
		{
			projectIds.add(o.Opportunity.Project_Name__c);
			orderList.add(o);
		 
		}
		
		map<Id, Project__c> projectMap = new map<Id, Project__c>();
		for( Project__c p : [SELECT Id, Name, TerritoryName__c FROM Project__c WHERE Id in :projectIds] )
		{
			projectMap.put( p.Id, p);
		}
		
		
		for( Order o : orderList )
		{
			Project__c p = projectMap.get( o.Opportunity.Project_Name__c);
			if( o == null )
				continue;
			else if( p == null ) 
			{
				system.debug('Warning: ' + o.Name +' does not appear to have a valid Project');
				continue;
			}

			ordercount++;
			SF_TotalOrderResult res = null;
			if( !totalOrderLookup.containsKey(o.Opportunity.Project_Name__c) )
			{
				res = new SF_TotalOrderResult(o.Opportunity.Project_Name__c, o.Contact__c);
				res.orderList = new list<Order>();
				res.splitList = new list<Project_Split__c>();
        				
			} else
			{
				res = totalOrderLookup.get( o.Opportunity.Project_Name__c );
			}
			
			res.orderList.add( o );
			
			totalOrderLookup.put( o.Opportunity.Project_Name__c, res ); //make sure it gets saved back
		}
		
		LastResult += 'I picked up ' + ordercount +' total orders for  ' + startDate +' -> ' + endDate +'\n';
		
		//stage 2 - get the team members
		map<string,double> splitAmounts = new map<string,double>();
        Map<string, string> userTerrLookup = new Map<string, string>(); //just a temporary hash to cut down on string processing 
		
		integer splitcount = 0;
		for( Project_Split__c split : [SELECT Id, Project__c, Split__c, Project_Rep__c, Project_Rep__r.UserRoleName__c   FROM Project_Split__c WHERE Project__c IN  :totalOrderLookup.keySet()  ] )
    	{
    		splitcount++;
    		
			SF_TotalOrderResult res = null;
			if( !totalOrderLookup.containsKey(split.Project__c) )
			{
				res = new SF_TotalOrderResult(split.Project__c, null);
				res.orderList = new list<Order>();
				res.splitList = new list<Project_Split__c>();
        				
			} else
			{
				//hopefully, this is the only branch that gets fired in this code block. if the one above gets fired, there is a problem
				res = totalOrderLookup.get( split.Project__c );
			}
			
			res.splitList.add( split );
			totalOrderLookup.put( split.Project__c, res ); //make sure it gets saved back

    	}
		
		LastResult += 'I picked up ' + splitcount +' total splits for  ' + startDate +' -> ' + endDate +'\n';
		
		//stage 3, put all the splits and quotes together
        Map<string, Total_Order_Report_Data_Point__c> expectedJoins = new Map<string, Total_Order_Report_Data_Point__c>();
        Map<string, Total_Order_Report_Position_Data_Point__c> expectedPositionJoins = new Map<string, Total_Order_Report_Position_Data_Point__c>();
		
		for( Id projid : totalOrderlookup.keyset() )
		{
			SF_TotalOrderResult res = totalOrderLookup.get( projId);
			for( Order o : res.orderList )
			{
				for( Project_Split__c split:  res.splitList )
				{
					Total_Order_Report_Data_Point__c point = new Total_Order_Report_Data_Point__c();
		            if (!userTerrLookup.ContainsKey(split.Project_Rep__c))
		            {
		            	if( split.Project_Rep__c != null && split.Project_Rep__r.UserRoleName__c != null )
		            	{
			                string[] parts = split.Project_Rep__r.UserRoleName__c.Split(' ');
			                userTerrLookup.put( split.Project_Rep__c, (parts.size() > 0 ? parts[0] : 'missing'));
		            	} 
		            }

					//set up the main point
					point.OwnerId = split.Project_Rep__c;
		            point.Contact__c = res.contact;
					point.Order__c = o.Id;
		            point.Project__c = res.project;
		            point.Project_Split__c = split.Id;
		            
		            point.Territory__c = projectMap.get( res.project ).TerritoryName__c;
		            point.Project_Is_Split__c = ( res.splitList.size() > 1);
		            point.Unique_Key__c = res.project+'_' + o.Id + '_' + split.Id;
		            point.OwnerId = split.Project_Rep__c;

					//set any post-positions values on the point		            
                    if( !expectedJoins.ContainsKey( point.Unique_Key__c) )
                        expectedJoins.put( point.Unique_Key__c, point);

				}
			}
			
		}
		 
		 
        List<Database.upsertResult> results = Database.upsert( expectedJoins.values(), Total_Order_Report_Data_Point__c.Fields.Unique_Key__c, false );	
        string errorSummary = '';
        integer i = 1;
        LastResult += results.size() + ' total records were "upserted"<br />\n';
        for(Database.upsertResult theResult:results) 
		{
			if(theResult.isSuccess()) continue; // next item
			List<Database.Error> errors = theResult.getErrors();
			errorSummary += '<h1>Errors Were Found</h1>';
  			for(Database.Error theError:Errors) 
  			{
  				errorSummary += '<b>An error occurred: </b>' + theError.getMessage() + theError.getStatusCode()+ '<br />\n';
		  	}
		}
		
		
    	//4. Clean up data that should NOT exist
        List<string> deletingJoins = new List<string>();

		for( Total_Order_Report_Data_Point__c point : [SELECT Unique_Key__c, Id    FROM Total_Order_Report_Data_Point__c  WHERE (    (   Nana_Quote__r.Order_Finalized_Date__c != null  AND Nana_Quote__r.Order_Finalized_Date__c >=  :startDate AND Nana_Quote__r.Order_Finalized_Date__c <=   :endDate  )   OR ( Nana_Quote__r.Invoices_Sent_Date__c != null      AND Nana_Quote__r.Invoices_Sent_Date__c >=    :startDate  AND Nana_Quote__r.Invoices_Sent_Date__c <=  :endDate )  OR ( Nana_Quote__r.Deposit_Date__c != null   AND Nana_Quote__r.Deposit_Date__c >= :startDate  AND Nana_Quote__r.Deposit_Date__c <= :endDate )  OR ( Nana_Quote__r.Balanced_Received_Date__c != null   AND Nana_Quote__r.Balanced_Received_Date__c >= :startDate  AND Nana_Quote__r.Balanced_Received_Date__c <= :endDate ) OR ( Nana_Quote__r.Deposit_Received_Date__c != null   AND Nana_Quote__r.Deposit_Received_Date__c >= :startDate  AND Nana_Quote__r.Deposit_Received_Date__c <= :endDate ) OR ( Nana_Quote__r.Order_Confirmation_Started__c != null   AND Nana_Quote__r.Order_Confirmation_Started__c >= :startDate  AND Nana_Quote__r.Order_Confirmation_Started__c <= :endDate ) ) ] )
		{
			if( !expectedJoins.ContainsKey( point.Unique_Key__c ) )
			    deletingJoins.Add(point.Id);
		}
		if( deletingJoins.size() > 0 ) 
		{
			Database.delete( deletingJoins, false );
		}
		LastResult += (' got ' +expectedJoins.keySet().size() +' joins to add and '+deletingJoins.size()+' joins to cleanup for ' +startDate.year() )+' <br />\n';


    	
		if( errorSummary != '' )
			LastResult += errorSummary;
    	
    	
    	
    }    

}