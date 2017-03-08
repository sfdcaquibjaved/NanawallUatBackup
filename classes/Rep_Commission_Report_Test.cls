@isTest(SeeAllData=true)
public with sharing class Rep_Commission_Report_Test {
	@isTest(SeeAllData=false)
    static  void RunObjectTests () {
		string temp_string = '';
		integer temp_int = 0;
		Date temp_date = null;
		double temp_double = 0;

		Rep_Commission_Report_Controller rcrcontroller = new Rep_Commission_Report_Controller();
		
		temp_double = rcrcontroller.TotalCommissionToPay;
		rcrcontroller.TotalCommissionToPay = 1.0;
		temp_double = rcrcontroller.TotalCommissionToPay;
		
		temp_double = rcrcontroller.DepositSum;
		rcrcontroller.DepositSum = 1.0;
		temp_double = rcrcontroller.DepositSum;
		
		//SubtotalSum
		temp_double = rcrcontroller.SubtotalSum;
		rcrcontroller.SubtotalSum = 1.0;
		temp_double = rcrcontroller.SubtotalSum;
		
		//BalanceSum
		temp_double = rcrcontroller.BalanceSum;
		rcrcontroller.BalanceSum = 1.0;
		temp_double = rcrcontroller.BalanceSum;
		
		//DrawingsSum
		temp_double = rcrcontroller.DrawingsSum;
		rcrcontroller.DrawingsSum = 1.0;
		temp_double = rcrcontroller.DrawingsSum;

		
		
		Rep_Commission_Report_Controller.Sorter s = new Rep_Commission_Report_Controller.Sorter('','');
		s.getColumn();
		s.getSortDirection();
		s.setColumn('Quote__r.Quote_Id__c');
		s.setColumn('Quote__r.Quote_Id__c');
		
		rcrcontroller.BalanceSum = 1;
		rcrcontroller.DepositSum = 1;
		string id = rcrcontroller.dummyopportunity.Id;
		rcrcontroller.dummyopportunity = new Opportunity();
		rcrcontroller.getDataPoints();
		
		rcrcontroller.dummyopportunity.OwnerId = '005A0000000O0zy';
		rcrcontroller.dummyopportunity.Nana_Create_Date__c = Date.today().addDays(-720);
		rcrcontroller.dummyopportunity.Nana_Edit_Date__c = Date.today().addDays(-700);
		rcrcontroller.getDataPoints();

		rcrcontroller.dummyopportunity.OwnerId = null;
		rcrcontroller.getDataPoints();
		

		rcrcontroller.refreshDataPoints();
		rcrcontroller.thisSorter.getColumn();
		
		

		Rep_Commission_Report_Controller.CommissionLine line = new Rep_Commission_Report_Controller.CommissionLine();
		line.Index = 1;
		temp_int = line.Index;
		
		line.Id  = '';
		temp_string = line.Id;
		
		line.OppID = '';
		temp_string = line.OppID;

		line.OrderNumber = '';
		temp_string = line.OrderNumber;		
		
		line.QuoteNumber = '';
		temp_string = line.QuoteNumber;
		
		line.DepositDate = Date.today();
		temp_date = line.DepositDate;
		
		line.DepositAmount = 1.0;
		temp_double = line.DepositAmount;
		
		line.DepositCommission = 1.0;
		temp_double = line.DepositCommission;
		
		line.ActualDepositCommission = 1.0;
		temp_double = line.ActualDepositCommission;
		
		line.BalanceDate = Date.today();
		temp_date = line.BalanceDate;
		 
		line.BalanceCommission = 1.0;
		temp_double = line.BalanceCommission;
		
		line.BalanceAmount = 1.0;
		temp_double = line.BalanceAmount;
		
		line.ActualBalanceCommission = 1.0;
		temp_double = line.ActualBalanceCommission;
		
		line.DrawingDepositDate = Date.today();
		temp_date = line.DrawingDepositDate;
		
		line.DrawingDepositCommission = 1.0;
		temp_double = line.DrawingDepositCommission;
		
		line.ActualDrawingDepositCommission = 1.0;
		temp_double = line.ActualDrawingDepositCommission;
		
		line.DrawingDepositAmount = 1.0;
		temp_double = line.DrawingDepositAmount;

    }
}