/**********************************************************************
Apex Class: TrendDashBoardHelperClass
Description: This class is a helper class for TrendDashBoardController
Created Date: 1st August,2016            
***********************************************************************/
public class TrendDashBoardHelperClass {

/**********************************************************************
Apex Method: calculateTrends
Description: This method is used to calculate trends based on sales reps
Created Date: 1st August,2016            
***********************************************************************/ 	
	public static list<string> calculateTrends(integer j, integer startyearval, map<string, integer> monthCountMap)
	{
		//Local Variables
		integer firstYearVal;
	    integer secondYearVal;
	    integer thirdYearVal;
		integer countval = startyearval;
	    string monthName;
	    list<string> calculateList = new list<string>();
	    
	    //Calling method to fetch the name of the month
		monthName = monthNameCalculation(j);					

		//1st Year
		string mName = j + ' ' + countval;
		firstYearVal = monthCountMap.get(mName);
		if(firstYearVal==NULL)
		{
			firstYearVal = 0;
		}

		//2nd Year					
		countval = countval+1; 
		string secndName = j + ' ' + countval;
		secondYearVal = monthCountMap.get(secndName);
		if(secondYearVal==NULL)
		{
			secondYearVal = 0;
		}

		//3rd Year
		countval = countval+1; 
		string thirdName = j + ' ' + countval;
		thirdYearVal = monthCountMap.get(thirdName);
		if(thirdYearVal==NULL)
		{
			thirdYearVal = 0;
		}
		calculateList.add(monthName);
		calculateList.add(String.valueof(firstYearVal));
		calculateList.add(String.valueof(secondYearVal));
		calculateList.add(String.valueof(thirdYearVal));

		return calculateList;
	}

/**********************************************************************
Apex Method: monthNameCalculation
Description: This method is used to find the month name
Created Date: 2nd August,2016            
***********************************************************************/ 
	public static string monthNameCalculation(integer monthNumber)
	{
		integer j = monthNumber;
		string monthName;
		if(j==1)
		{
			monthName = 'Jan';
		}
		else if(j==2)
		{
			monthName = 'Feb';
		}
		else if(j==3)
		{
			monthName = 'Mar';
		}
		else if(j==4)
		{
			monthName = 'Apr';
		}
		else if(j==5)
		{
			monthName = 'May';
		}
		else if(j==6)
		{
			monthName = 'Jun';
		}
		else if(j==7)
		{
			monthName = 'Jul';
		}
		else if(j==8)
		{
			monthName = 'Aug';
		}
		else if(j==9)
		{
			monthName = 'Sep';
		}
		else if(j==10)
		{
			monthName = 'Oct';
		}
		else if(j==11)
		{
			monthName = 'Nov';
		}
		else if(j==12)
		{
			monthName = 'Dec';
		}	

		return monthName;	
		
	}
}