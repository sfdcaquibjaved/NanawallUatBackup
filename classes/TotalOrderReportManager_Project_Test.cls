@isTest
public with sharing class TotalOrderReportManager_Project_Test {


    @isTest(SeeAllData=true)
    static  void RunTests () {
    	
        	// test TotalOrderReportManager2
//        	for( integer i = 1;i<6;i++)
//	        	TotalOrderReportManager_Project.RunYearSegment( 2009, i);
  	      	TotalOrderReportManager_Project.RunYearSegment( 2009, 1);
    	
//    		TotalOrderReportManager_Project.insertScheduler( 1);
    }

}