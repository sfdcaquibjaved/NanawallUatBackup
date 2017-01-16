public with sharing class Rep_Commission_Summary_Controller {

	 public final static String SORT_ASC = 'ASC';
	 public final static String SORT_DESC = 'DESC';

	public class Sorter {
	 private String column;
	 public String sortDirection; 
	  
	 public Sorter(String defaultSortColumn, String defaultSortDirection){ 
		 this.column = defaultSortColumn;
		 this.sortDirection = defaultSortDirection;
	 }
	 
	 public String getSortDirection() {
	 return this.sortDirection;
	 }
	 
	 public String getColumn() {
	 return this.column;
	 }
	 
	public void setColumn(String columnName) {
	 if (column.equalsIgnoreCase(columnName)) {
	 sortDirection = (sortDirection.equals(SORT_ASC)) ? SORT_DESC : SORT_ASC;
	 } else {
	 this.sortDirection = SORT_ASC;
	 this.column = columnName;
	 }
	 }
	}


	private String defaultSortColumn = 'Quote__r.Quote_Id__c'; /** Set the default sort Column. **/
	private String sortDirection = 'ASC';
 	public Sorter thisSorter {
 		get{
 			if( thisSorter == null )
 				thisSorter = new Sorter( defaultSortColumn, sortDirection);
 				
 			return thisSorter;
 		} 
 		set;
 	} 


	public Opportunity dummyopportunity { 
		get
		{
			if( dummyOpportunity == null )
				dummyOpportunity = new Opportunity();
				
			return dummyOpportunity;
		} 
		set; 
	}


	public double Sum_NB_Showroom 
	{ 
		get 
		{
			if( Sum_NB_Showroom == null )
				Sum_NB_Showroom = 0;
				
			return Sum_NB_Showroom;
		}
		
		set;
	}
	public double Sum_NS_Showroom 
	{ 
		get 
		{
			if( Sum_NS_Showroom == null )
				Sum_NS_Showroom = 0;
				
			return Sum_NS_Showroom;
		}
		
		set;
	}
	public double Sum_NE_Showroom 
	{ 
		get 
		{
			if( Sum_NE_Showroom == null )
				Sum_NE_Showroom = 0;
				
			return Sum_NE_Showroom;
		}
		
		set;
	}

	public double Sum_NB_Showroom_Nana 
	{ 
		get 
		{
			if( Sum_NB_Showroom_Nana == null )
				Sum_NB_Showroom_Nana = 0;
				
			return Sum_NB_Showroom_Nana;
		}
		
		set;
	}
	public double Sum_NS_Showroom_Nana 
	{ 
		get 
		{
			if( Sum_NS_Showroom_Nana == null )
				Sum_NS_Showroom_Nana = 0;
				
			return Sum_NS_Showroom_Nana;
		}
		
		set;
	}
	public double Sum_NE_Showroom_Nana 
	{ 
		get 
		{
			if( Sum_NE_Showroom_Nana == null )
				Sum_NE_Showroom_Nana = 0;
				
			return Sum_NE_Showroom_Nana;
		}
		
		set;
	}

	public double Sum_NB_NoShowroom 
	{ 
		get 
		{
			if( Sum_NB_NoShowroom == null )
				Sum_NB_NoShowroom = 0;
				
			return Sum_NB_NoShowroom;
		}
		
		set;
	}
	public double Sum_NS_NoShowroom 
	{ 
		get 
		{
			if( Sum_NS_NoShowroom == null )
				Sum_NS_NoShowroom = 0;
				
			return Sum_NS_NoShowroom;
		}
		
		set;
	}
	public double Sum_NE_NoShowroom 
	{ 
		get 
		{
			if( Sum_NE_NoShowroom == null )
				Sum_NE_NoShowroom = 0;
				
			return Sum_NE_NoShowroom;
		}
		
		set;
	}

	public double Sum_NB_NoShowroom_Nana 
	{ 
		get 
		{
			if( Sum_NB_NoShowroom_Nana == null )
				Sum_NB_NoShowroom_Nana = 0;
				
			return Sum_NB_NoShowroom_Nana;
		}
		
		set;
	}
	public double Sum_NS_NoShowroom_Nana 
	{ 
		get 
		{
			if( Sum_NS_NoShowroom_Nana == null )
				Sum_NS_NoShowroom_Nana = 0;
				
			return Sum_NS_NoShowroom_Nana;
		}
		
		set;
	}
	public double Sum_NE_NoShowroom_Nana 
	{ 
		get 
		{
			if( Sum_NE_NoShowroom_Nana == null )
				Sum_NE_NoShowroom_Nana = 0;
				
			return Sum_NE_NoShowroom_Nana;
		}
		
		set;
	}


	class CommissionLine 
	{
		public integer Index{ get; set; }

		public string RepName { get; set; }
		public string RepId { get; set; }

		public double RepCommission { get; set; }
		
		public double OverageFirst_Showroom { get; set; }
		public double OverageSecond_Showroom { get; set; }
		public double OverageThird_Showroom { get; set; }
		
		public double OverageFirst_NoShowroom { get; set; }
		public double OverageSecond_NoShowroom { get; set; }
		public double OverageThird_NoShowroom { get; set; }
		
		public double NanaOverageFirst_Showroom { get; set; }
		public double NanaOverageSecond_Showroom { get; set; }
		public double NanaOverageThird_Showroom { get; set; }
		
		public double NanaOverageFirst_NoShowroom { get; set; }
		public double NanaOverageSecond_NoShowroom { get; set; }
		public double NanaOverageThird_NoShowroom { get; set; }
		
	}
		public PageReference refreshDataPoints() 
	{
	
		ret = null;
		getDataPoints();
		return null;
	}
	
    List<CommissionLine> ret = null;
	public list<CommissionLine> getDataPoints()
	{
	
	
		map<string, CommissionLine> repCommissionAggregates = new map<string, CommissionLine>();
		
		
		if( dummyopportunity.Nana_Create_Date__c == null
		||  dummyopportunity.Nana_Edit_Date__c == null )
		{
			ret = new List<CommissionLine>();
			Apexpages.addMessage(new Apexpages.Message( Apexpages.Severity.Info, 'Please select a date range to filter on'));
		} else if( ret == null )
		{
	        ret = new List<CommissionLine>();

			integer rowcount = 1;

			DateTime d1 = (Date)dummyOpportunity.Nana_Create_Date__c;
			DateTime d2 = (Date)dummyopportunity.Nana_Edit_Date__c;
			d1 = d1.addDays(1);
			d2 = d2.addDays(1);

			string soql = 'SELECT Id,Order_Number__c,Deposit_Date__c,Deposit_Commission__c,Balance_Received_Date__c,Balance_Received_Commission2__c, ';
			soql += ' Project_Stage__c, Quote__c, Quote__r.Quote_Id__c,Quote__r.Id, Project_Is_Split__c, Credit__c, Credit1__c, ';
			soql += ' Territory__c,Invoice_Sent_Date__c, Opportunity__r.Name, Opportunity__r.Id, Quote_Subtotal__c, Average_Discount__c, Commission__c,  ';
			soql += ' Commission_Total__c, Calculated_List_Price__c, Weighted_Discount__c, User__r.FirstName, User__r.LastName, User__r.Allow_Showroom_Commission__c, ';
			soql += ' Contact__r.FirstName, Contact__r.LastName, Shipping_City__c,Shipping_State__c, Subtotal_Commission__c, Date_Finalized__c, Commission_Rate__c, ';
			soql += ' Panelcount__c, Drawing_Deposit_Date__c, Drawing_Deposit_Commission__c, ';
			soql += ' Actual_Balance_Commission__c, Actual_Deposit_Commission__c, Actual_Drawing_Commission__c, Deposit_Amount__c, Balance_Amount__c, ';
			soql += ' Base_Reduction__c,  Base_Commission__c,  Overage_Commission__c, Base_Commission_Pct__c, Shipping_Zip__c, Drawing_Deposit_Amount__c, ';
			soql += ' Overage_Commission_First__c, Overage_Commission_Second__c, Overage_Commission_Third__c, BaseOrExcess_First__c, BaseOrExcess_Second__c , BaseOrExcess_Third__c   ';
			
			soql += ' FROM Report_Total_Order_Report_Data_Point__c ';
 
			soql += ' WHERE ';
			soql += '( ';
			soql += '	( Balance_Received_Date__c >= '+d1.format('yyyy-MM-dd')+'   AND Balance_Received_Date__c <= '+d2.format('yyyy-MM-dd')+'  AND Balance_Amount__c > 0  ) ';
			soql += ' 	OR ( Deposit_Date__c >= '+d1.format('yyyy-MM-dd')+'  AND Deposit_Date__c <= '+d2.format('yyyy-MM-dd')+'  AND Deposit_Amount__c > 0 )   ';
			soql += ' 	OR (Drawing_Deposit_Date__c >= '+d1.format('yyyy-MM-dd')+'  AND Drawing_Deposit_Date__c <= '+d2.format('yyyy-MM-dd')+'  AND Drawing_Deposit_Amount__c > 0 )   ';
			soql += ')    ';
System.debug('Using dates ' + dummyOpportunity.Nana_Create_Date__c+ ' until ' + dummyopportunity.Nana_Edit_Date__c + ' => ' + d1.format('yyyy-MM-dd') +' until ' + d2.format('yyyy-MM-dd') + '');

			
			soql += ' Order By ' + thisSorter.getColumn() + ' ' + thisSorter.getSortDirection() +' NULLS LAST ';
//			soql += ' LIMIT 1000 ';

System.Debug('Rep Comm SOQL: ' + soql);			
			list<Report_Total_Order_Report_Data_Point__c> points = (list<Report_Total_Order_Report_Data_Point__c>)Database.query(soql );
			for( Report_Total_Order_Report_Data_Point__c totalOrderPoint : points )
			{
				CommissionLine line = new CommissionLine();

				if( !repCommissionAggregates.containsKey(totalOrderPoint.User__c) )
				{
					line.RepName =  totalOrderPoint.User__r.FirstName+ ' ' + totalOrderPoint.User__r.LastName;
					line.OverageFirst_NoShowroom  = 0;
					line.OverageSecond_NoShowroom   = 0;
					line.OverageThird_NoShowroom   = 0;
					
					line.OverageFirst_Showroom  = 0;
					line.OverageSecond_Showroom   = 0;
					line.OverageThird_Showroom   = 0;
					
					line.NanaOverageFirst_Showroom  = 0;
					line.NanaOverageSecond_Showroom  = 0;
					line.NanaOverageThird_Showroom  = 0;
					
					line.NanaOverageFirst_NoShowroom  = 0;
					line.NanaOverageSecond_NoShowroom  = 0;
					line.NanaOverageThird_NoShowroom  = 0;
					line.RepCommission = 0;
					
					repCommissionAggregates.put( totalOrderPoint.User__c, line );
				} else line = repCommissionAggregates.get( totalOrderPoint.User__c );

				boolean hasRelevantDate = false;
				boolean hasDepositDate = false;
				boolean hasBalanceDate = false;
				boolean hasCommission = false;
				
				if( (totalOrderPoint.Deposit_Date__c >= dummyopportunity.Nana_Create_Date__c 
					&& totalOrderPoint.Deposit_Date__c <= dummyopportunity.Nana_Edit_Date__c ))
				{
					hasRelevantDate = true;

					line.RepCommission += totalOrderPoint.Deposit_Commission__c;
				
					if( totalOrderPoint.Deposit_Commission__c > 0 )
						hasCommission = true;
					
					if( totalOrderPoint.Deposit_Amount__c > 0 )
						hasDepositDate = true;
						
				}
				
				if( (totalOrderPoint.Balance_Received_Date__c >= dummyopportunity.Nana_Create_Date__c 
					&& totalOrderPoint.Balance_Received_Date__c <= dummyopportunity.Nana_Edit_Date__c ))
				{

					
					hasRelevantDate = true;

					line.RepCommission += totalOrderPoint.Balance_Received_Commission2__c;
					
					if( totalOrderPoint.Balance_Received_Commission2__c > 0 )
						hasCommission = true;
					
					if( totalOrderPOint.Balance_Amount__c > 0 )
						hasBalanceDate = true;
				}
				
				if( !hasBalanceDate && !hasDepositDate )
					continue;
				

				if( (totalOrderPoint.Drawing_Deposit_Date__c >= dummyopportunity.Nana_Create_Date__c 
					&& totalOrderPoint.Drawing_Deposit_Date__c <= dummyopportunity.Nana_Edit_Date__c ))
				{					
					hasRelevantDate = true;
					
				}

				if( !hasCommission ) 
					continue; //if it doesnt pay a commission for this period, it shouldnt show up
				
				if(!hasRelevantDate 
				|| totalOrderPoint.Commission__c == 0 ) continue;
				
				
				line.Index = rowcount++;
				
				integer multiplier = ( hasBalanceDate && hasDepositDate ? 2 : 1 ); //if this order gets both a balance date and an deposit date in the same range, need to include both.
				
				if ( totalOrderPoint.User__r.Allow_Showroom_Commission__c )
				{
					line.OverageFirst_Showroom  += ( totalOrderPoint.Overage_Commission_First__c > 0 ? totalOrderPoint.Overage_Commission_First__c : 0 ) * multiplier *(totalOrderPoint.Commission__c / 100); 
					line.OverageSecond_Showroom  += (totalOrderPoint.Overage_Commission_Second__c > 0 ? totalOrderPoint.Overage_Commission_Second__c : 0) * multiplier*(totalOrderPoint.Commission__c / 100);
					line.OverageThird_Showroom  += (totalOrderPoint.Overage_Commission_Third__c > 0 ? totalOrderPoint.Overage_Commission_Third__c : 0) * multiplier*(totalOrderPoint.Commission__c / 100);
					
					line.NanaOverageFirst_Showroom  += ( totalOrderPoint.Overage_Commission_First__c > 0 && totalOrderPoint.BaseOrExcess_First__c > 0 ? totalOrderPoint.BaseOrExcess_First__c - totalOrderPoint.Overage_Commission_First__c : 0 ) * multiplier *(totalOrderPoint.Commission__c / 100); 
					line.NanaOverageSecond_Showroom  += ( totalOrderPoint.Overage_Commission_Second__c > 0 && totalOrderPoint.BaseOrExcess_Second__c > 0 ? totalOrderPoint.BaseOrExcess_Second__c - totalOrderPoint.Overage_Commission_Second__c : 0 ) * multiplier *(totalOrderPoint.Commission__c / 100); 
					line.NanaOverageThird_Showroom  += ( totalOrderPoint.Overage_Commission_Third__c > 0 && totalOrderPoint.BaseOrExcess_Third__c > 0 ? totalOrderPoint.BaseOrExcess_Third__c - totalOrderPoint.Overage_Commission_Third__c : 0 ) * multiplier *(totalOrderPoint.Commission__c / 100); 
					
				} else
				{
					line.OverageFirst_NoShowroom  += (totalOrderPoint.Overage_Commission_First__c > 0 ? totalOrderPoint.Overage_Commission_First__c : 0) * multiplier*(totalOrderPoint.Commission__c / 100);
					line.OverageSecond_NoShowroom  += (totalOrderPoint.Overage_Commission_Second__c > 0 ? totalOrderPoint.Overage_Commission_Second__c : 0) * multiplier*(totalOrderPoint.Commission__c / 100);
					line.OverageThird_NoShowroom  += (totalOrderPoint.Overage_Commission_Third__c > 0 ? totalOrderPoint.Overage_Commission_Third__c : 0) * multiplier*(totalOrderPoint.Commission__c / 100);
					
					line.NanaOverageFirst_NoShowroom  += ( totalOrderPoint.Overage_Commission_First__c > 0 && totalOrderPoint.BaseOrExcess_First__c > 0 ? totalOrderPoint.BaseOrExcess_First__c - totalOrderPoint.Overage_Commission_First__c : 0 ) * multiplier*(totalOrderPoint.Commission__c / 100); 
					line.NanaOverageSecond_NoShowroom  += ( totalOrderPoint.Overage_Commission_Second__c > 0 && totalOrderPoint.BaseOrExcess_Second__c > 0 ? totalOrderPoint.BaseOrExcess_Second__c - totalOrderPoint.Overage_Commission_Second__c : 0 ) * multiplier*(totalOrderPoint.Commission__c / 100); 
					line.NanaOverageThird_NoShowroom  += ( totalOrderPoint.Overage_Commission_Third__c > 0 && totalOrderPoint.BaseOrExcess_Third__c > 0 ? totalOrderPoint.BaseOrExcess_Third__c - totalOrderPoint.Overage_Commission_Third__c : 0 ) * multiplier*(totalOrderPoint.Commission__c / 100); 
				}
			
			
			} 
			
			Sum_NB_Showroom = 0;
			Sum_NS_Showroom = 0; 
			Sum_NE_Showroom  = 0;
			Sum_NB_Showroom_Nana  = 0;
			Sum_NS_Showroom_Nana  = 0;
			Sum_NE_Showroom_Nana  = 0;
			Sum_NB_NoShowroom  = 0;
			Sum_NS_NoShowroom  = 0;
			Sum_NE_NoShowroom  = 0;
			Sum_NB_NoShowroom_Nana  = 0;
			Sum_NS_NoShowroom_Nana  = 0;
			Sum_NE_NoShowroom_Nana  = 0;
			
			ret = repCommissionAggregates.values();
			for(CommissionLine line : ret )
			{
				if( line.OverageFirst_NoShowroom  > 0 ) 
				{
					line.OverageFirst_NoShowroom  /= 2;
					line.NanaOverageFirst_NoShowroom = 0;
					
					Sum_NB_NoShowroom += line.OverageFirst_NoShowroom;
//					Sum_NB_NoShowroom_Nana += line.NanaOverageFirst_NoShowroom;
				}
				if( line.OverageSecond_NoShowroom  > 0 )
				{
					line.OverageSecond_NoShowroom  /= 2;
					line.NanaOverageSecond_NoShowroom  /= 2;
					Sum_NS_NoShowroom += line.OverageSecond_NoShowroom;
					Sum_NS_NoShowroom_Nana += line.NanaOverageSecond_NoShowroom;
					
				}
				if( line.OverageThird_NoShowroom  > 0 )
				{
					line.OverageThird_NoShowroom  /= 2;
					line.NanaOverageThird_NoShowroom  /= 2;
					Sum_NE_NoShowroom += line.OverageThird_NoShowroom;
					Sum_NE_NoShowroom_Nana += line.NanaOverageThird_NoShowroom;
					
				}
				
				if( line.OverageFirst_Showroom  > 0 ) 
				{
					line.OverageFirst_Showroom  /= 2;
					line.NanaOverageFirst_Showroom  = 0;
					Sum_NB_Showroom += line.OverageFirst_Showroom;
//					Sum_NB_Showroom_Nana += line.NanaOverageFirst_Showroom;
					
				}
				if( line.OverageSecond_Showroom  > 0 )
				{
					line.OverageSecond_Showroom  /= 2;
					line.NanaOverageSecond_Showroom  /= 2;
					Sum_NS_Showroom += line.OverageSecond_Showroom;
					Sum_NS_Showroom_Nana += line.NanaOverageSecond_Showroom;
					
				}
				if( line.OverageThird_Showroom  > 0 )
				{
					line.OverageThird_Showroom  /= 2;
					line.NanaOverageThird_Showroom  /= 2;
					Sum_NE_Showroom += line.OverageThird_Showroom;
					Sum_NE_Showroom_Nana += line.NanaOverageThird_Showroom;
					
				}
				if( line.RepCommission > 0 )
				{
					line.RepCommission /= 2;
				}
				
			}
			Sum_NB_NoShowroom_Nana = 0;
			Sum_NB_Showroom_Nana = 0;
		}
		
		return ret;
	}	
}