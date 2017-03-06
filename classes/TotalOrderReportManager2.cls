// the original TotalOrderReportManager is "stuck" in cs10 -- so, need to do this. hooray.
global with sharing class TotalOrderReportManager2 implements Schedulable{

	public class CommissionRateInput
	{
		public double Total_List_Price { get; set; }
		public double Quote_Sub_Total { get; set; } 
		public boolean Chain_Account { get; set; } 
		public double Weighted_Discount { get; set; }
		public double Quote_Discount_Override { get; set; }
		public boolean Allow_Showroom_Commission  { get; set; }
		public string User_Id  { get; set; }
		public string Opportunity_Postal_Code { get; set; }
		public string Opportunity_State { get; set; }
		public string Opportunity_City { get; set; }
		public string Quote_Zip { get; set; }
		public string Quote_State { get; set; }
		public string Quote_City { get; set; }		
		public boolean Is_Main_Rep {get; set; }
	}

	public class CommissionRateResult 
	{
		public double Commission_Rate { get; set; }
		public boolean Has_Showroom_Credit  { get; set; }
		public string Debug_String { get; set; }
		public boolean Do_Not_Give_Commission { get; set; }
		public double Base_Reduction { get; set; }
		public double Base_Commission_Pct { get; set; }
		public double Base_Commission { get; set; }
		public double Overage_Commission { get; set; }                                                 
		public double Overage_Commission_First { get; set; }              
		public double Overage_Commission_Second { get; set; }              
		public double Overage_Commission_Third { get; set; }                                                 
		public double BaseOrExcess_First { get; set; }                   
		public double BaseOrExcess_Second { get; set; }    
		public double BaseOrExcess_Third { get; set; }        
		public double Weighted_Discount  { get; set; }                                        

		
	}

	public static TotalOrderReportManager2.CommissionRateResult CalculateCommissionRate( CommissionRateInput input )
	{
		
		TotalOrderReportManager2.CommissionRateResult result = new TotalOrderReportManager2.CommissionRateResult();
		
		result.Weighted_Discount = input.Weighted_Discount;
		if( input.Chain_Account != null && input.Chain_Account 
		&& input.Quote_Discount_Override != null && input.Quote_Discount_Override > 0 )
			result.Weighted_Discount = input.Quote_Discount_Override;
			
		result.Do_Not_Give_Commission = false;
		if( result.Weighted_Discount > 30
		&& input.Quote_Discount_Override != null
		&& Math.round(result.Weighted_Discount ) == input.Quote_Discount_Override)
			result.Do_Not_Give_Commission = true;
		else if( result.Weighted_Discount > 30 
		&& input.Quote_Discount_Override != null )
			result.Weighted_Discount = input.Quote_Discount_Override;
		

		result.Commission_Rate = 0;		
		result.Has_Showroom_Credit = allowShowroomCommissionForUser_refactored(input);
					
		//there appears to be a floor of -5% on this deduction based on looking at the invoices - ks
		result.Base_Reduction = ( result.Weighted_Discount > 20 ?  ( result.Weighted_discount < 30 ? (result.Weighted_Discount -20)/2  : 5)   :  0)/100;
		result.Base_Commission_Pct = 	0;

		if( result.Has_Showroom_Credit )
			result.Base_Commission_Pct = .125;
		else 
			result.Base_Commission_Pct = .10;

		//the base for the base commission appears to switch based on how much discount there is. i derived this from looking at actual invoices - ks
//		result.Base_Commission =  ( result.Weighted_Discount > 20 || input.Quote_Discount_Override > 0 ? input.Quote_Sub_Total : input.Total_List_Price*0.8 )  *  (result.Base_Commission_Pct - result.Base_Reduction);
//		result.Base_Commission =  ( result.Weighted_Discount > 20  ? input.Quote_Sub_Total : input.Total_List_Price*0.8 )  *  (result.Base_Commission_Pct - result.Base_Reduction);
		result.Base_Commission =  ( result.Weighted_Discount > 20 || input.Weighted_Discount > 25 ? input.Quote_Sub_Total : input.Total_List_Price*0.8 )  *  (result.Base_Commission_Pct - result.Base_Reduction);
					

		result.Overage_Commission = 0;
		result.Overage_Commission_First = result.Base_Commission;	
		result.Overage_Commission_Second = 0;						
		result.Overage_Commission_Third = 0;						
//		result.BaseOrExcess_First = (result.Weighted_Discount > 20  || input.Quote_Discount_Override > 0  ? input.Quote_Sub_Total : input.Total_List_Price*0.8 ) ;
//		result.BaseOrExcess_First = (result.Weighted_Discount > 20   ? input.Quote_Sub_Total : input.Total_List_Price*0.8 ) ;
		result.BaseOrExcess_First = (result.Weighted_Discount > 20  ||  input.Weighted_Discount > 25  ? input.Quote_Sub_Total : input.Total_List_Price*0.8 ) ;
		result.BaseOrExcess_Second = 0;
		result.BaseOrExcess_Third = 0;
					
		double wtdDiscount_multiplier = result.Weighted_Discount/100;
		if( result.Has_Showroom_Credit )
		{  
			//=IF(AND(H3,E3<=0.1),(0.1 *0.5*D3) + ( (0.2-0.1-E3) * 0.3 *D3),0) 
			result.Overage_Commission = ( wtdDiscount_multiplier >= 0 && wtdDiscount_multiplier <= .10 ? (0.1 *0.5*input.Total_List_Price) + ( (0.2-0.1-wtdDiscount_multiplier) * 0.3 * input.Total_List_Price) : 0);
						
			//+ IF( AND(H3, AND(E3 >0.1,E3<0.2)), D3*(0.2-E3) * 0.5,0) 
			result.Overage_Commission += ( wtdDiscount_multiplier > .10 && wtdDiscount_multiplier  < .20 ?  (input.Quote_Sub_Total - (input.Total_List_Price*0.8) ) *0.5: 0 );
						
			if( result.Overage_Commission < 0 )
				result.Overage_Commission += ( wtdDiscount_multiplier > .10 && wtdDiscount_multiplier  < .20 ? input.Total_List_Price*(0.2-wtdDiscount_multiplier) * 0.5: 0 );
							
		} else 
		{
			//+ IF(AND(NOT(H3),E3<0.2),0.3*(F3-(D3*0.8)),0						
			result.Overage_Commission += ( wtdDiscount_multiplier < .20 ? 0.3*(input.Quote_Sub_Total-(input.Total_List_Price*0.8)) : 0 );
		}
					
		if( wtdDiscount_multiplier < .2 )
		{ ///fills in the overage columns for ebrahim

			if(wtdDiscount_multiplier < .1 )
			{
				if( result.Has_Showroom_Credit) 
				{
					result.BaseOrExcess_Second = (input.Total_List_Price-result.BaseOrExcess_First)*.5;
					result.Overage_Commission_Second = result.BaseOrExcess_Second * .5;
				} else
				{
					result.BaseOrExcess_Second = (input.Total_List_Price-result.BaseOrExcess_First)*.5;
					result.Overage_Commission_Second = result.BaseOrExcess_Second * .3;
							
				}
				result.BaseOrExcess_Third = (0.1 - wtdDiscount_multiplier) * input.Total_List_Price;
				result.Overage_Commission_Third = result.BaseOrExcess_Third * .3;
			} else
			{
				if( result.Has_Showroom_Credit )
				{
					result.BaseOrExcess_Second = (input.Quote_Sub_Total-result.BaseOrExcess_First);
					result.Overage_Commission_Second = result.BaseOrExcess_Second * .5;
				} else 
				{
					result.BaseOrExcess_Second = (input.Quote_Sub_Total-result.BaseOrExcess_First);
					result.Overage_Commission_Second = result.BaseOrExcess_Second * .3;
				
				}
			}
						
		}					
															
		if( result.Do_Not_Give_Commission )
			result.Commission_Rate = 0;					
		else if(input.Quote_Sub_Total > 0 )
			result.Commission_Rate = ( (result.Base_Commission + result.Overage_Commission) / input.Quote_Sub_Total)*100;
					
		if( result.Commission_Rate <= 0 )
		{
			result.Overage_Commission_First = 0;
			result.Overage_Commission_Second = 0;
			result.Overage_Commission_Third = 0;
			result.Base_Commission = 0;
			result.Overage_Commission = 0;
		}
					
		return result;
	}


    class SF_TotalOrderTeamMember
    {
        public string ID {get; set; }
        public string UserID { get; set; }
        public string FirstName { get; set; } 
        public string LastName { get; set;  }
        public string TerritoryName { get; set; }
        public string Credit { get; set; }
        public string Credit1 { get; set; }
        public decimal CommissionAmt { get; set; }
        public decimal CommissionPct { get; set; }
        public boolean Allow_showroom_commission { get; set; }
    }
  
 
 	public static string showroomdebug = '';
 	
 	public static boolean allowShowroomCommissionForUser_refactored( CommissionRateInput input ) 
 	{

		boolean allow = input.Allow_Showroom_Commission;
		
		if( !input.Is_Main_Rep)
			return allow;
		
		//> If Laris territory and state of OR or HI or ID or MT then HasShowroom = false.  (HasShowroom = true only if WA)
		if(  input.User_Id == '005A0000000N1mwIAC' || input.User_Id == '005A0000000N1mw'  
		|| input.User_Id == '005A0000000MOfjIAG' || input.User_Id == '005A0000000MOfj' )
		{
			allow = false;
			if( 
				(input.Opportunity_State != null && input.Opportunity_State == 'WASHINGTON' )
				|| (input.Quote_State != null &&  input.Quote_State == 'WASHINGTON') 
			)
			{
				allow = true;
			}
			
			/*
			if( input.Opportunity_State != null && input.Opportunity_State != 'WASHINGTON' )
			{
				allow = false;
			}
			else if( input.Quote_State != null &&  input.Quote_State != 'WASHINGTON' )
			{
				allow = false;
			} else if(  input.Quote_State == null && input.Opportunity_State == null )
				allow = false;
				*/
		}
		//> If Leon* and zip between(12800,14999) (west), the HasShowroom = false.
		else if( input.User_Id == '005A0000000N1nQIAS' || input.User_Id == '005A0000000N1n' 
			|| input.User_Id == '005A0000000MOhbIAG' || input.User_Id == '005A0000000MOhb')
		{// Bill leon
			
			try
			{
				integer oppZip = ( input.Opportunity_Postal_Code != null ? integer.valueOf(input.Opportunity_Postal_Code) : 0 );
				integer quoteZip = ( input.Quote_Zip != null ? integer.valueOf(input.Quote_Zip) : 0 );
	
				
				if( 
					(input.Opportunity_Postal_Code != null && oppZip >= 12800 && oppZip <=  14999 ) //good
					|| ( input.Quote_Zip != null  && quoteZip >= 12800 && quoteZip <=  14999 ) //good
					
					|| (input.Opportunity_Postal_Code != null && oppZip >= 12400 && oppZip <=  12799 ) //good
					|| ( input.Quote_Zip != null  && quoteZip >= 12400 && quoteZip <=  12799 ) //good
					
					|| (input.Opportunity_Postal_Code != null && oppZip >= 12000 && oppZip <=  12399 ) //good
					|| ( input.Quote_Zip != null  && quoteZip >= 12000 && quoteZip <=  12399 ) //good
					
					|| (input.Opportunity_Postal_Code != null && oppZip >= 10000 && oppZip <=  11999 ) //good
					|| ( input.Quote_Zip != null  && quoteZip >= 10000 && quoteZip <=  11999 ) //good
					
					|| (input.Opportunity_Postal_Code != null && oppZip >= 8800 && oppZip <=  8999 ) //good
					|| ( input.Quote_Zip != null  && quoteZip >= 8800 && quoteZip <=  8999 ) //good
					
					|| (input.Opportunity_Postal_Code != null && oppZip >= 7800 && oppZip <=  7999 ) //good
					|| ( input.Quote_Zip != null  && quoteZip >= 7800 && quoteZip <=  7999 ) //good
					
					|| (input.Opportunity_Postal_Code != null && oppZip >= 7700 && oppZip <=  7799 ) //good
					|| ( input.Quote_Zip != null  && quoteZip >= 7700 && quoteZip <=  7799 ) // good
					
					|| (input.Opportunity_Postal_Code != null && oppZip >= 7000 && oppZip <=  7699 ) //good
					|| ( input.Quote_Zip != null  && quoteZip >= 7000 && quoteZip <=  7699 ) //good
					
				)
					allow = true;
				else if( input.Quote_Zip == null && input.Opportunity_Postal_Code == null )
					allow = false;
				else allow = false;
			} catch (Exception ex ) 
			{
				//canadian zip codes trigger this
			}		
		}
		//> If Ron Walker, only if State = Florida, HasShowroom = true.
		else if( input.User_Id == '005A0000000N1lKIAS' || input.User_Id == '005A0000000N1lK'
		|| input.User_Id == '005K0000002WCeuIAG' || input.User_Id == '005K0000002WCeu' )
		{
			allow = false;
			if( input.Quote_City == 'FREIGHT FORWARDER'  || input.Opportunity_City == 'FREIGHT FORWARDER' )
				allow = false;
			else if( input.Opportunity_State != null && input.Opportunity_State.toLowerCase() == 'florida' )
			{
				allow = true;
			}
			else if( input.Quote_State != null &&  input.Quote_State.toLowerCase() == 'florida' )
			{
				allow = true;
			}						
			
		}
		
		return allow;
 	
 	}
 	 
 	public static boolean nonShowroomCommissionState( string statename ) 
 	{
 		string state = statename.toLowerCase();
 		return ( state == 'guam' || state == 'hawaii' || state == 'puerto rico' || state == 'virgin islands' || state == 'caribbean');
 		
 	}
 

	global static string LastResult = 'INIT';
	global static boolean running = false;
    class SF_TotalOrderResult
    {
        public Opportunity  project { get; set; }
		public Contact contact { get; set; }
		public list<Quote__c> quoteList { get; set; } 
		
		public list<SF_TotalOrderTeamMember> repList { get; set; }

		public SF_TotalOrderResult ( Opportunity o, Contact c ) 
		{
			project = o;
			contact = c;
			quoteList = new list<Quote__c>();
			repList = new list<SF_TotalOrderTeamMember>();
		}

    }

	private static string cronKey = 'TotalOrderReportManager2';
	public static string getcronkey() { return cronkey; }

	global static void insertScheduler(integer nextRun) {
		
		//1. kill the currently scheduled job
		Application_Setting__c cronSetting = null;		
		try {
			cronSetting = [SELECT Setting_Name__c, Setting_Value__c FROM Application_Setting__c WHERE Setting_Name__c = :TotalOrderReportManager2.getcronKey() ];
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
		String jobID = System.schedule( TotalOrderReportManager2.getcronkey(),'0 '+nextRunTime.minute()+' * * * ?', new TotalOrderReportManager2() );
		cronSetting = new Application_Setting__c();
		cronSetting.Setting_Name__c = TotalOrderReportManager2.getcronkey();
		cronSetting.setting_value__c = jobid;
		insert cronSetting;	
	}


    global void execute(SchedulableContext SC) 
    {
    	integer firstYear = 2009;
    	integer nextYear = date.today().year(); 
    	integer nextYearSegment = 1;
		map<string, Application_Setting__c> settings = new map<string, Application_Setting__c>();

		for( Application_Setting__c appSetting : [SELECT Id, Setting_Name__c, Setting_Value__c FROM Application_Setting__c WHERE Setting_Name__c  like 'TotalOrderReport_%' ] )
		{

			if( appSetting.Setting_Name__c == 'TotalOrderReport_StartYear' )
			{
				firstYear = integer.valueOf( appSetting.Setting_Value__c);
				settings.put( appSetting.Setting_Name__c, appSetting );			
			} else if ( appSetting.Setting_Name__c == 'TotalOrderReport_LastYearSegmentProcessed') 
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
				} else 
				{
					nextYearSegment = 1;
				}
				settings.put( appSetting.Setting_Name__c, appSetting );			
				
				
			} else if(appSetting.Setting_Name__c == 'TotalOrderReport_LastYearProcessed') 
			{
				if (appSetting.Setting_Value__c == null )
					appSetting.Setting_Value__c = '2009'; 
					
				else nextYear = integer.valueOf( appSetting.Setting_Value__c)+1;
	
				settings.put( appSetting.Setting_Name__c, appSetting );			
				
			} else if(appSetting.Setting_Name__c == 'TotalOrderReport_RunLog') 
			{
				settings.put( appSetting.Setting_Name__c, appSetting );			
			}
		}		
		
		if(nextYearSegment == 2 ) //we need to do the second half of the year, so roll it back 1
			nextYear--;
		

		if( nextYear > date.today().year() )
			nextYear = firstYear; //going into the future, loop back around
		


		ActualRun( nextYear, nextYearSegment  ); 
		
		LastResult += 'Updating the cron to run again in 10 minutes.<br />\n';
		TotalOrderReportManager2.insertScheduler(10);
				
				
				
		settings.get('TotalOrderReport_LastYearProcessed').Setting_Value__c =  string.valueOf(nextYear);
		settings.get('TotalOrderReport_LastYearSegmentProcessed').Setting_Value__c =  string.valueOf(nextYearSegment);
		settings.get('TotalOrderReport_RunLog').Setting_Value__c =  LastResult;
		
		update settings.values();

    }
	
    public static void ActualRun(integer YearToRun, integer SegmentToRun) 
    {

		if( !running )
		{
			running = true;
			TotalOrderReportManager2.LastResult = 'Starting Total Order Report rebuild run at ' + datetime.now()+'<br />\n';
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
	                	endDate = Date.Parse( '4/1/' + YearToRun);
	                } else if( SegmentToRun == 2 )
	                {
	                	startDate = Date.Parse('4/1/' + YearToRun);
	                	endDate = Date.Parse( '7/1/' + YearToRun);
	                } else if( SegmentToRun == 3)
	                {
	                	startDate = Date.Parse( '7/1/' + YearToRun);
	                	endDate = Date.Parse( '10/1/' + YearToRun);
	                } else 
	                {
	                	startDate = Date.Parse('10/1/' + YearToRun);
	                	endDate = Date.Parse( '12/31/' + YearToRun);
	                }
	                
	                
					LastResult += 'TotalOrderReportManager.run() running for year ' + YearToRun +' <br />\n'; 
					run(startDate, endDate);
					
					LastResult += 'Finished running ' + YearToRun + '.<br />\n=========<br />\n';
					System.debug('finished running totalorderreportmanager');
	            }

	            catch (Exception ex)
	            {
	               LastResult += 'Caught an exeception in TotalOrderReportManager.run() for ' + YearToRun + '. ' + ex + ' on line ' + ex.getLineNumber()  +' <br />\n'; 
	            }

	        running = false;
	    }

    }
    public static void run(Date startDate, Date endDate ) 
    {

		integer quotesFetched = 0;
		set<id> oppIds = new set<id>();
        Map<string, SF_TotalOrderResult> detailsLookup = new Map<string, SF_TotalOrderResult>();
		
		integer totalQuotesWithDiscount = 0;
		
		//stage 1 - get the quotes
		for( Quote__c q : [ SELECT id, q.Zip__c,q.City__c, q.Country__c,  Quote_ID__c,  Order_Number__c,  SubTotal__c, ordered__c,  q.Opportunity__c, q.Opportunity__r.Chain_Account__c,q.Opportunity__r.OwnerID, q.Opportunity__r.Name, q.Opportunity__r.Postal_Code__c, q.Opportunity__r.Id, q.Drawing_Deposit__c, q.Deposit_Date__c, q.Balanced_Received_Date__c, q.Balance_Received__c , q.Drawing_Deposit_Amount__c, q.Discount__c, q.Commission_Showroom__c, Order_Finalized_Date__c, Invoices_Sent_Date__c, Average_Discount__c, ContactName__c, State__c,  q.Contact__r.FirstName,  q.Contact__r.LastName, q.Contact__r.Id, q.Name, q.Panel_Count__c, q.Opportunity__r.NIS__c,q.Opportunity__r.State__c,q.Opportunity__r.City__c,q.Opportunity__r.Country__c, q.Chain_Account__c,  (Select id, Model__c, Quote_Detail_ID__c, Discount__c, Price__c From Quote_Details__r )  FROM Quote__c q   WHERE q.ordered__c = true  AND ( ( order_finalized_date__c != null   AND order_finalized_date__c >= :startDate AND order_finalized_date__c <= :endDate  )  OR ( Invoices_Sent_Date__c != null   AND Invoices_Sent_Date__c >= :startDate  AND Invoices_Sent_Date__c <= :endDate ) OR ( Deposit_Date__c != null   AND Deposit_Date__c >= :startDate  AND Deposit_Date__c <= :endDate ) OR ( Balanced_Received_Date__c != null   AND Balanced_Received_Date__c >= :startDate  AND Balanced_Received_Date__c <= :endDate ) )  ] )
		{
			quotesFetched++;

            if (!detailsLookup.containsKey( q.Opportunity__c ) )
            { 
            	
                SF_TotalOrderResult res = new SF_TotalOrderResult(q.Opportunity__r, q.Contact__r);
                detailsLookup.put( q.Opportunity__c, res );
                
            }
            detailsLookup.get( q.Opportunity__c ).quoteList.add(q);			
            
            //keep the opp id for the team member lookup
            if( !oppIds.contains( q.Opportunity__c) )
            	oppIds.add( q.Opportunity__c);
		}
		
		
		//stage 2 - get the team members
		//Revenue
//		OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Commission Split'];
		OpportunitySplitType splittype = [SELECT Id FROM OpportunitySplitType WHERE MasterLabel = 'Revenue'];
		
		list<id> oppIdLookup = new list<id>( oppIds);
		map<string,double> splitAmounts = new map<string,double>();
		for( OpportunitySplit split : [SELECT Id, OpportunityId, SplitOwnerID,SplitPercentage FROM OpportunitySplit WHERE OpportunityId IN  :oppIdLookup AND  splittypeid = :splittype.id] )
    	{
			splitAmounts.put( split.OpportunityId+ '_' + split.SplitOwnerId, split.SplitPercentage);
    	}
		
        Map<string, string> userTerrLookup = new Map<string, string>(); //just a temporary hash to cut down on string processing 
		
		for( OpportunityTeamMember tm : [SELECT t.id, t.UserId, t.User.FirstName, t.User.Region__c, t.User.LastName, t.User.UserRoleName__c, t.User.Allow_showroom_commission__c, t.OpportunityId,credit__c,credit1__c   FROM OpportunityTeamMember t  WHERE t.OpportunityId IN  :oppIdLookup ] )
    	{
			if (  tm.User != null && tm.User.UserRoleName__c != null &&   tm.User.UserRoleName__c.toLowerCase().IndexOf('admin') >= 0) continue;

			SF_TotalOrderResult res = detailsLookup.get(tm.OpportunityId);

            SF_TotalOrderTeamMember member = new SF_TotalOrderTeamMember();
            member.UserID = tm.UserId;
            member.FirstName = tm.User.FirstName;
            member.LastName = tm.User.LastName;
//            member.CommissionPct = tm.Commission__c;
			if( splitAmounts.containsKey(tm.OpportunityId+'_'+ tm.UserId) )
				member.CommissionPct = splitAmounts.get(tm.OpportunityId+'_'+ tm.UserId);
			else member.CommissionPct = -1;
            member.Allow_showroom_commission = tm.User.Allow_showroom_commission__c;
            member.Credit = tm.Credit__c;
            member.Credit1 = tm.Credit1__c;
            member.ID = tm.Id;

            if (!userTerrLookup.ContainsKey(tm.UserId))
            {
            	string terrName = '';
            	if( tm.User != null && tm.User.UserRoleName__c != null )
            	{
	                string[] parts = tm.User.UserRoleName__c.Split(' ');
	                terrName = (parts.size() > 0 ? parts[0] : 'missing');
	                userTerrLookup.put( tm.UserId, terrName);
            	} else terrName = 'missing';
            }

            member.TerritoryName = userTerrLookup.get( tm.UserId );
            res.repList.add(member);
    	
    	}
    	

        /*stage 3: put all of the fetched data into IRI objects*/
        Map<string, Report_Total_Order_Report_Data_Point__c> expectedJoins = new Map<string, Report_Total_Order_Report_Data_Point__c>();
        Map<string, Report_Total_Order_Position_Data_Point__c> expectedPositionJoins = new Map<string, Report_Total_Order_Position_Data_Point__c>();
        integer totalDataPoints = 0;
        integer projects = 0;
        integer quotes = 0;
        integer teammembers = 0;

        for (string sfProjectID : detailsLookup.keySet() )
        {
            projects++;
            SF_TotalOrderResult res = detailsLookup.get(sfProjectID);
            for( Quote__c sfQuote  : res.quoteList)
            {
                quotes++;
                
                for (SF_TotalOrderTeamMember tm : res.repList)
                {
                    teammembers++;

                    Report_Total_Order_Report_Data_Point__c dataPoint = new Report_Total_Order_Report_Data_Point__c();
                    dataPoint.Unique_Key__c = sfQuote.ID + '_' + sfQuote.Order_Number__c + '_' + tm.CommissionPct + '_' + tm.UserID;
                    dataPoint.Quote__c = sfQuote.ID;
                    dataPoint.User__c = tm.UserID;
                    dataPoint.Opportunity__c = sfProjectID; 
                    dataPoint.debug_string__c = ''; 
                    dataPoint.OwnerId= tm.UserID;
                    if( res.Contact != null)
	                    dataPoint.Contact__c = res.Contact.Id;

                    dataPoint.Commission__c = (Double)(tm.CommissionPct);
                    dataPoint.Territory__c = tm.TerritoryName;
                    dataPoint.Credit__c = tm.Credit;
                    dataPoint.Credit1__c = tm.Credit1;
                    dataPoint.Project_Is_Split__c = ( res.repList.size() > 1 );
	                    
                    double TotalListPrice = 0;
                    double TotalPositionSalesPrice = 0; //this shoudl be Quote.SubTotal no ?

                    //need a position per team member --
                    integer poscount = 0; 
                    
					for( Quote_Detail__c qd : sfQuote.Quote_Details__r )
					{
						TotalPositionSalesPrice += qd.Price__c;
				
						double listPrice = qd.Price__c;
						if(qd.Discount__c >= 100)
							listPrice = 0;
						else if( qd.Discount__c > 0 )
							 listPrice = qd.Price__c / ( (100-qd.Discount__c) /100); //reconstruct hte list price from the discount 							 
						TotalListPrice += listPrice;
						
						poscount++;
						
						// add the position line
						Report_Total_Order_Position_Data_Point__c positionDataPoint = new Report_Total_Order_Position_Data_Point__c();
	                    positionDataPoint.Unique_Key__c = sfQuote.ID  + '_' + qd.Id + '_' + sfQuote.Order_Number__c + '_' + tm.CommissionPct + '_' + tm.UserID;
	                    positionDataPoint.Quote__c = sfQuote.ID;
	                    positionDataPoint.User__c = tm.UserID;
	                    positionDataPoint.Opportunity__c = sfProjectID;
	                    positionDataPoint.Quote_Detail__c = qd.Id;
	                    positionDataPoint.Commission_Rate__c =  (Double)(tm.CommissionPct);
	                    positionDataPoint.Territory__c = tm.TerritoryName;
	                    positionDataPoint.Credit__c = tm.Credit;
	                    positionDataPoint.Credit1__c = tm.Credit1;
	                    positionDataPoint.OwnerId = tm.UserId;
						//Opportunity__c
	                    if( res.Contact != null)
		                    positionDataPoint.Contact__c = res.Contact.Id;

												
                    dataPoint.Project_Is_Split__c = ( res.repList.size() > 1 );
	
	
	                    if( !expectedPositionJoins.ContainsKey( positionDataPoint.Unique_Key__c) )
    	                    expectedPositionJoins.put( positionDataPoint.Unique_Key__c, positionDataPoint);
	
					}


					datapoint.Calculated_List_Price__c = TotalListPrice;

					//override discount		
					
					// --- begin logic block 
					CommissionRateInput input = new CommissionRateInput();
					
					decimal wtddisc = ( TotalListPrice != null && TotalListPrice > 0 ?  decimal.valueOf( (1-(TotalPositionSalesPrice / TotalListPrice))*100).setScale(2) : 0 );
					input.Weighted_Discount  = Double.valueOf( wtddisc);
					input.Allow_Showroom_Commission = tm.Allow_showroom_commission;
					input.Total_List_Price = TotalListPrice;
					input.Chain_Account = (sfQuote.Chain_Account__c == 'Yes');
					input.Opportunity_Postal_Code = sfQuote.Opportunity__r.Postal_Code__c;
					input.Opportunity_State = sfQuote.Opportunity__r.State__c;
					input.Opportunity_City = sfQuote.Opportunity__r.City__c;
					input.Quote_City = sfQuote.City__c;
					input.Quote_Discount_Override = sfQuote.Discount__c;
					input.Quote_State = sfQuote.State__c;
					input.Quote_Sub_Total = sfQuote.SubTotal__c;
					input.Quote_Zip = sfQuote.Zip__c;
					input.User_Id = tm.UserID;
					input.Is_Main_Rep = ( sfQuote.Opportunity__r.OwnerID == tm.UserId );


					CommissionRateResult result = CalculateCommissionRate(input);

				/*

		public boolean Has_Showroom_Credit  { get; set; }
		public boolean Do_Not_Give_Commission { get; set; }
				
				*/
					datapoint.Weighted_Discount__c = result.Weighted_Discount;
					
					datapoint.In_WtdDisc_c__c = input.Weighted_Discount;
					datapoint.Out_WtdDisc_c__c = result.Weighted_Discount;
					
					
					

					datapoint.Base_Reduction__c = result.Base_Reduction;
					datapoint.Base_Commission_Pct__c = result.Base_Commission_Pct; 
					datapoint.Base_Commission__c = result.Base_Commission;
					datapoint.Overage_Commission__c = result.Overage_Commission;										
					
					datapoint.Overage_Commission_First__c = result.Overage_Commission_First;										
					datapoint.Overage_Commission_Second__c = result.Overage_Commission_Second;										
					datapoint.Overage_Commission_Third__c = result.Overage_Commission_Third;										
					
					datapoint.BaseOrExcess_First__c = result.BaseOrExcess_First;										
					datapoint.BaseOrExcess_Second__c = result.BaseOrExcess_Second;										
					datapoint.BaseOrExcess_Third__c = result.BaseOrExcess_Third;										
					
					dataPoint.Commission_Rate__c = result.Commission_Rate;
					dataPoint.debug_string__c = result.Debug_String;


					
                    if( !expectedJoins.ContainsKey( dataPoint.Unique_Key__c) )
                        expectedJoins.put( dataPoint.Unique_Key__c, dataPoint);
                        
                    /// --- end logic block
                        
                    totalDataPoints++;

                    
                }
            }
        }

        List<Database.upsertResult> results = Database.upsert( expectedJoins.values(), Report_Total_Order_Report_Data_Point__c.Fields.Unique_Key__c, false );	
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
		
		/* */
		//now do the positions
        results = Database.upsert( expectedPositionJoins.values(), Report_Total_Order_Position_Data_Point__c.Fields.Unique_Key__c, false );	
        i = 1;
        LastResult += results.size() + ' total position records were "upserted"<br />\n';
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
		
		if( errorSummary != '' )
			LastResult += errorSummary;
		/**/

        //stage 4.  clean up phase - look for joins that exist that according to our calculations SHOULD NOT exist and then delete them
        List<string> deletingJoins = new List<string>();

		for( Report_Total_Order_Report_Data_Point__c point : [SELECT Unique_Key__c, Id    FROM Report_Total_Order_Report_Data_Point__c  WHERE (    (  Date_Finalized__c != null  AND Date_Finalized__c >=     :startDate AND Date_Finalized__c <=   :endDate  )   OR ( Invoice_Sent_Date__c != null      AND Invoice_Sent_Date__c >=    :startDate  AND Invoice_Sent_Date__c <=  :endDate )     ) ] )
		{
			if( !expectedJoins.ContainsKey( point.Unique_Key__c ) )
			    deletingJoins.Add(point.Id);
		}
		if( deletingJoins.size() > 0 ) 
		{
			Database.delete( deletingJoins, false );
		}
        
		
		 
		//now do the position cleanup
        List<string> deletingPosJoins = new List<string>();
		/*  */
		for( Report_Total_Order_Position_Data_Point__c point : [SELECT Unique_Key__c, Id    FROM Report_Total_Order_Position_Data_Point__c  WHERE (    (  Date_Finalized__c != null  AND Date_Finalized__c >=  :startDate AND Date_Finalized__c <=   :endDate  )   OR ( Invoice_Sent_Date__c != null   AND Invoice_Sent_Date__c >=    :startDate  AND Invoice_Sent_Date__c <=  :endDate )     ) ] )
		{
			if( !expectedPositionJoins.ContainsKey( point.Unique_Key__c ) )
			    deletingPosJoins.Add(point.Id);
		}        
		if( deletingPosJoins.size() > 0 )
		{
			Database.delete( deletingPosJoins, false );
		}
/**/        
		LastResult += (' got ' +expectedJoins.keySet().size() +' joins to add and '+deletingJoins.size()+' joins to cleanup for ' +startDate.year() )+' <br />\n';
		LastResult += (' got ' +expectedPositionJoins.keySet().size() +' position joins to add and '+deletingPosJoins.size()+' pos joins to cleanup for ' +startDate.year() )+' <br />\n';
		LastResult += ('  ' +totalQuotesWithDiscount +' total quotes had a discount <br />\n');
		
		
				

    
    }    
	

}