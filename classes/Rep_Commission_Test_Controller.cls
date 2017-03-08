public with sharing class Rep_Commission_Test_Controller {

	private boolean initd = false;
	public Rep_Commission_Test_Controller()  
	{
		if( !initd )
		{
			//pull up the existing test set

		}
	}


	public list<Rep_Commission_Test_Row__c> getRepCommissionTestRows ()
	{
		list<Rep_Commission_Test_Row__c> testrows = [SELECT  Opportunity_City__c, Is_Main_rep__c,Commission_Split__c,Expected_NE__c, Output_NE__c,  Expected_NS__c, Output_NS__c, Output_NB__c, Expected_NB__c, User__r.FIrstName, User__r.LastName,  Id, Name,Expected_Overage__c, Output_Overage__c, Expected_Base_Commission__c,Output_Base_Commission__c, Expected_Commission_Rate__c,Output_Commission_Rate__c, Output_Weighted_Discount__c,List_price__c, Quote_Sub_Total__c, Chain_Account__c, Weighted_Discount__c, Quote_Discount_Override__c, Allow_Showroom_Commission__c, User__c,  Opportunity_Postal_Code__c, Opportunity_State__c, Quote_Zip__c, Quote_State__c, Quote_City__c FROM Rep_Commission_Test_Row__c ORDER BY Name ];
		
		/*

		
		*/
		
		return testrows;
	}

	
	public string testMatch()
	{
		return 'foo';
	}
	
	public PageReference runtests() 
	{
	
		list<Rep_Commission_Test_Row__c> testrows = getRepCommissionTestRows();
	
		for( Rep_Commission_Test_Row__c row : testrows )
		{
			TotalOrderReportManager2.CommissionRateInput input = new TotalOrderReportManager2.CommissionRateInput();

			input.Total_List_Price = row.List_price__c;
			input.Quote_Sub_Total = row.Quote_Sub_Total__c;
			input.Chain_Account = row.Chain_Account__c;
			input.Weighted_Discount = row.Weighted_Discount__c;
			input.Quote_Discount_Override = row.Quote_Discount_Override__c;
			input.Allow_Showroom_Commission = row.Allow_Showroom_Commission__c;
			input.User_Id = row.User__c;
			input.Opportunity_Postal_Code = row.Opportunity_Postal_Code__c;
			input.Opportunity_State = row.Opportunity_State__c;
			input.Opportunity_City = row.Opportunity_City__c;
			input.Quote_Zip = row.Quote_Zip__c;
			input.Quote_State = row.Quote_State__c;
			input.Quote_City = row.Quote_City__c;
			input.Is_Main_Rep = row.Is_Main_Rep__c;
			
			
			TotalOrderReportManager2.CommissionRateResult result =   TotalOrderReportManager2.CalculateCommissionRate(input);
			
			double splitMultiplier = ( row.Commission_Split__c != null ? row.Commission_Split__c/100 : 1);
			
			row.Output_Has_Showroom_Credit__c = result.Has_Showroom_Credit;
			row.Output_Commission_Rate__c = result.Commission_Rate;
			row.Output_Base_Commission__c = result.Base_Commission * splitMultiplier;
			row.Output_Overage__c = result.Overage_Commission * splitMultiplier;
			
			row.Output_NB__c = result.Overage_Commission_First * splitMultiplier;
			row.Output_NS__c = result.Overage_Commission_Second * splitMultiplier;
			row.Output_NE__c = result.Overage_Commission_Third * splitMultiplier;

			row.Output_Weighted_Discount__c = result.Weighted_Discount;
			
/*

		public double Base_Reduction { get; set; }
		public double Base_Commission_Pct { get; set; }


		public double Overage_Commission_First { get; set; }              
		public double Overage_Commission_Second { get; set; }              
		public double Overage_Commission_Third { get; set; }                                                 

		public double Weighted_Discount  { get; set; }                                        


*/			
		}
	
	
		update testrows;

		
	
		return null;
	}
}