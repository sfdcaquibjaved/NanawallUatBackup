public with sharing class TotalOrderReportDataManager_Controller {

	public string YearToRun{ get; set; }
	public string YearSegmentToRun{ get; set; } 

	public PageReference rebuildData() 
	{

		if( YearToRun == null || YearToRun == '' )
		{
			ApexPages.addMessage( new ApexPages.Message(  Apexpages.Severity.ERROR, 'Please provide the year to run.' ));
			return null;
		}

system.debug('starting the actualrun ... ');
		TotalOrderReportManager2.ActualRun( integer.valueOf(YearToRun), integer.valueOf(YearSegmentToRun) );
		ApexPages.addMessage( new ApexPages.Message(  Apexpages.Severity.INFO, 'Data Rebuilt.' ));
		
		return null; 
	}


	public PageReference rescheduleCron() 
	{
		

		TotalOrderReportManager2.insertScheduler(1);
		ApexPages.addMessage( new ApexPages.Message(  Apexpages.Severity.INFO, 'Cron  scheduled job "'+TotalOrderReportManager2.getcronkey()+'" ' ));
		
		        
        return null;
	}

	public string LastBuildResult { get{ return TotalOrderReportManager2.LastResult; } }

}