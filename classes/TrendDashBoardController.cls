/**********************************************************************
Apex Class: TrendDashBoardController
Description: This class is a controller for TrendDashboardPage
Created Date: 1st August,2016            
***********************************************************************/
public with sharing class TrendDashBoardController {

	//Global Variables
	public List < SelectOption > salesreps {
        get;
        set;
    }
    public string salesrepname {
        get;
        set;
    }
    public string regionname {
        get;
        set;
    }
    public string userid;
    public string username{
    	get;
    	set;
    }
    public boolean communityuser{
    	get;
    	set;
    }
    public string prevregion;
    public list < data > datalist {
        get;
        set;
    }
    public list < dataOrder > dataOrderlist {
        get;
        set;
    }
    public list < DataRolling > DataRollingList{
        get;
        set;
    }
    public string firstYearString{
    	get;
    	set;
    }
    public string secondYearString{
    	get;
    	set;
    }
    public string thirdYearString{
    	get;
    	set;
    }

    //Controller
	public TrendDashBoardController() {

		salesreps = new List < SelectOption > ();
		datalist = new list < data > ();
		dataOrderlist = new list < dataOrder > ();
        DataRollingList = new list<DataRolling>();
        salesreps.add(new SelectOption('--None--', '--None--'));
		communityuser = FALSE;
		//Local Variables
        list<AggregateResult> quoteList = new list<AggregateResult>();
        list<AggregateResult> orderList = new list<AggregateResult>(); 
        list<AggregateResult> projectList = new list<AggregateResult>();       
        integer yearval = system.today().year();
        integer startyearval = yearval-2;
        firstYearString = 'CY '+startyearval;
        secondYearString = 'CY ' +(startyearval+1);
        thirdYearString = 'CY '+yearval;

        datalist.clear();
        dataOrderlist.clear();
        DataRollingList.clear();
		//This code is used to detect whether login user is salesrep or regional manager.
		userid = userinfo.getuserid();
		user u = [select id, name, Profile.name from user where id=: userid];

		if(u.Profile.name=='NanaRepPartnerProfile' && u.Profile.name=='NanaRepPartnerProfile2')
		{
			communityuser = TRUE;
			username = u.name;	
		}

		if(communityuser == TRUE)
		{
			quoteList = [select count(id) qid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Quote__c where Project__r.Owner.name=:username AND CALENDAR_YEAR(convertTimezone(CreatedDate))>=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
            orderList = [select count(id) qid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Quote__c where Project__r.Owner.name=:username AND CALENDAR_YEAR(convertTimezone(CreatedDate))>=: startyearval AND Order_Number__c>1 GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
            projectList = [select count(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Project__c where Owner.name=:username AND CALENDAR_YEAR(convertTimezone(CreatedDate))>=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
            System.debug('listquote'+quoteList);  
            System.debug('listorder'+orderList);  
            //If the Quotelist is not empty
			if(quoteList.size()>0)
			{
				map<string, integer> monthCountMap = new map<string, integer>();				
				for(AggregateResult ar: quoteList)
				{
					string monthName = (Integer.valueof(ar.get('month'))) + ' ' + (string.valueof(ar.get('year')));
					monthCountMap.put(monthName, Integer.valueof(ar.get('qid')));
				}
								
					for(integer j=1; j<=12; j++)
					{
						//Local Variables
						integer firstYearVal;
						integer secondYearVal;
						integer thirdYearVal;
						string monthName;
						//Helper Class to calculate the trends
						list<string> outputList = TrendDashBoardHelperClass.calculateTrends(j, startyearval, monthCountMap);
					
						monthName = outputList[0];
					    firstYearVal = Integer.valueOf(outputList[1]);
						secondYearVal = Integer.valueOf(outputList[2]);
						thirdYearVal = Integer.valueOf(outputList[3]);
						
						if(firstYearVal!=NULL && secondYearVal!=NULL && thirdYearVal!=NULL)
						{
							//Adding to wrapper class
							datalist.add(new data(monthName, firstYearVal, secondYearVal, thirdYearVal));
						}

						System.debug('chartdataa'+datalist);					
						
					}				
			}
			if(orderList.size()>0)
			{
				map<string, integer> monthCountMap = new map<string, integer>();				
				for(AggregateResult ar: orderList)
				{
					string monthName = (Integer.valueof(ar.get('month'))) + ' ' + (string.valueof(ar.get('year')));
					monthCountMap.put(monthName, Integer.valueof(ar.get('qid')));
				}
								
					for(integer j=1; j<=12; j++)
					{
						//Local Variables
						integer firstYearVal;
						integer secondYearVal;
						integer thirdYearVal;
						string monthName;
						//Helper Class to calculate the trends
						list<string> outputList = TrendDashBoardHelperClass.calculateTrends(j, startyearval, monthCountMap);
					
						monthName = outputList[0];
					    firstYearVal = Integer.valueOf(outputList[1]);
						secondYearVal = Integer.valueOf(outputList[2]);
						thirdYearVal = Integer.valueOf(outputList[3]);
						
						if(firstYearVal!=NULL && secondYearVal!=NULL && thirdYearVal!=NULL)
						{
							//Adding to wrapper class
							dataOrderlist.add(new dataOrder(monthName, firstYearVal, secondYearVal, thirdYearVal));
						}

						System.debug('chartdataa'+dataOrderlist);					
						
					}				
			}

            if(projectList.size()>0)
            {
                map<string, integer> monthCountMap = new map<string, integer>();
                list<integer> countList = new list<integer>();
                list<string> monthNameList = new list<string>();
                for(AggregateResult ar: projectList)
                {
                    integer startyearrolling = Integer.valueof(ar.get('year'));
                    string mnthName = TrendDashBoardHelperClass.monthNameCalculation(Integer.valueof(ar.get('month')));
                    string monthName = mnthName+ ' ' + (string.valueof(ar.get('year')));
                    monthCountMap.put(monthName, Integer.valueof(ar.get('pid')));
                    countList.add(Integer.valueof(ar.get('pid')));
                    monthNameList.add(monthName);

                }

                for(integer i=1; i<=countList.size(); i++)
                {
                    if(i<12)
                    {
                        DataRollingList.add(new DataRolling(monthNameList[i-1], countList[i-1], 0));
                    }
                    else
                    {
                        integer rollingAmount=0;
                        integer grt = i-12;
                        for(integer j=i; j>grt; j--)
                        {
                            rollingAmount = rollingAmount+countList[j-1];
                        }

                        DataRollingList.add(new DataRolling(monthNameList[i-1], countList[i-1], rollingAmount));
                    }
                }

            }
		}

		
	}

/**********************************************************************
Apex Method: getRegionlist
Description: This method is used to fetch regions from the custom settings
Created Date: 1st August,2016            
***********************************************************************/  
    public list < selectOption > getRegionlist() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('--None--', '--None--'));
        list < TerritoryNames__c > tnlist = TerritoryNames__c.getall().values();
        for (TerritoryNames__c tn: tnlist) {
            options.add(new SelectOption(tn.name, tn.name));
        }

        return options;
    }

/**********************************************************************
Apex Method: TrendsCalculation
Description: This method is used to calculate trends based on sales rep
Created Date: 1st August,2016            
***********************************************************************/ 
    public void TrendsCalculation()
	{
        
		//Get SalesReps
        if (regionname == 'Eastern Sales') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
            list < EasternSalesReps__c > eslist = EasternSalesReps__c.getall().values();
            for (EasternSalesReps__c es: eslist) {
                salesreps.add(new SelectOption(es.name, es.name));
            }
        } else if (regionname == 'Mid Eastern Sales') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
            list < MidEasternSalesReps__c > mslist = MidEasternSalesReps__c.getall().values();
            for (MidEasternSalesReps__c es: mslist) {
                salesreps.add(new SelectOption(es.name, es.name));
            }
        } else if (regionname == 'Midwest Sales') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
            list < MidWestSalesReps__c > lslist = MidWestSalesReps__c.getall().values();
            for (MidWestSalesReps__c es: lslist) {
                salesreps.add(new SelectOption(es.name, es.name));
            }
        } else if (regionname == 'Western Sales') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
            list < WesternSalesReps__c > kslist = WesternSalesReps__c.getall().values();
            for (WesternSalesReps__c es: kslist) {
                salesreps.add(new SelectOption(es.name, es.name));
            }
        } else if (regionname == '--None--') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
        }

        //Local Variables
        list<AggregateResult> quoteList = new list<AggregateResult>();
        list<AggregateResult> orderList = new list<AggregateResult>();
        list<AggregateResult> projectList = new list<AggregateResult>();
        integer yearval = system.today().year();
        integer startyearval = yearval-2;
        firstYearString = 'CY '+startyearval;
        secondYearString = 'CY ' +(startyearval+1);
        thirdYearString = 'CY '+yearval;

        datalist.clear();
        dataOrderlist.clear();
        DataRollingList.clear();

        //If the logged in user is not a salesrep
        if(communityuser==false)
        {
        	//To make sales rep null on changing the region
            if(prevregion!=regionname)
            {
                salesrepname = NULL;
            }

        //On Selection of salesreps
        system.debug('@@@@@@@@@@@@@@@@region'+regionname);
		if(regionname!=NULL && regionname!='--None--' )
		{
            system.debug('@@@@@@@@@@@@@@@@Sales'+salesrepname);
			if (salesrepname != NULL && salesrepname != '--None--') {

				quoteList = [select count(id) qid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Quote__c where Project__r.Owner.name=:salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate))>=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
                  System.debug('listquote'+quoteList);
                orderList = [select count(id) qid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Quote__c where Project__r.Owner.name=:salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate))>=: startyearval AND Order_Number__c>1 GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
                  System.debug('listorder'+orderList);
                projectList = [select count(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Project__c where Owner.name=:salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate))>=:startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];       
			}
		}

		//If the Quotelist is not empty
			if(quoteList.size()>0)
			{	
				map<string, integer> monthCountMap = new map<string, integer>();			
				for(AggregateResult ar: quoteList)
				{
					string monthName = (Integer.valueof(ar.get('month'))) + ' ' + (string.valueof(ar.get('year')));
					monthCountMap.put(monthName, Integer.valueof(ar.get('qid')));
				}				
				
					for(integer j=1; j<=12; j++)
					{
						//Local Variables
						integer firstYearVal;
						integer secondYearVal;
						integer thirdYearVal;
						string monthName;
						//Helper Class to calculate the trends
						list<string> outputList = TrendDashBoardHelperClass.calculateTrends(j, startyearval, monthCountMap);
					
						monthName = outputList[0];
					    firstYearVal = Integer.valueOf(outputList[1]);
						secondYearVal = Integer.valueOf(outputList[2]);
						thirdYearVal = Integer.valueOf(outputList[3]);
						
						if(firstYearVal!=NULL && secondYearVal!=NULL && thirdYearVal!=NULL)
						{
							//Adding to wrapper class
							datalist.add(new data(monthName, firstYearVal, secondYearVal, thirdYearVal));
						}

						System.debug('chartdataa'+datalist);						
						
					}				
			}

			if(orderList.size()>0)
			{
				map<string, integer> monthCountMap = new map<string, integer>();				
				for(AggregateResult ar: orderList)
				{
					string monthName = (Integer.valueof(ar.get('month'))) + ' ' + (string.valueof(ar.get('year')));
					monthCountMap.put(monthName, Integer.valueof(ar.get('qid')));
				}
								
					for(integer j=1; j<=12; j++)
					{
						//Local Variables
						integer firstYearVal;
						integer secondYearVal;
						integer thirdYearVal;
						string monthName;
						//Helper Class to calculate the trends
						list<string> outputList = TrendDashBoardHelperClass.calculateTrends(j, startyearval, monthCountMap);
					
						monthName = outputList[0];
					    firstYearVal = Integer.valueOf(outputList[1]);
						secondYearVal = Integer.valueOf(outputList[2]);
						thirdYearVal = Integer.valueOf(outputList[3]);
						
						if(firstYearVal!=NULL && secondYearVal!=NULL && thirdYearVal!=NULL)
						{
							//Adding to wrapper class
							dataOrderlist.add(new dataOrder(monthName, firstYearVal, secondYearVal, thirdYearVal));
						}

						System.debug('chartdataa'+dataOrderlist);					
						
					}				
			}

            if(projectList.size()>0)
            {
                map<string, integer> monthCountMap = new map<string, integer>();
                list<integer> countList = new list<integer>();
                list<string> monthNameList = new list<string>();
                for(AggregateResult ar: projectList)
                {
                    integer startyearrolling = Integer.valueof(ar.get('year'));
                    string mnthName = TrendDashBoardHelperClass.monthNameCalculation(Integer.valueof(ar.get('month')));
                    string monthName = mnthName+ ' ' + (string.valueof(ar.get('year')));
                    monthCountMap.put(monthName, Integer.valueof(ar.get('pid')));
                    countList.add(Integer.valueof(ar.get('pid')));
                    monthNameList.add(monthName);

                }

                for(integer i=1; i<=countList.size(); i++)
                {
                    if(i<12)
                    {
                        DataRollingList.add(new DataRolling(monthNameList[i-1], countList[i-1], 0));
                    }
                    else if(i>=12)
                    {
                        integer rollingAmount=0;
                        integer grt = i-12;
                        system.debug('testss'+grt);
                        for(integer j=i; j>grt; j--)
                        {
                            rollingAmount = rollingAmount+countList[j-1];
                            System.debug('checker'+rollingAmount);
                        }
                        if(monthNameList[i-1]!=NULL && countList[i-1]!=NULL && rollingAmount!=NULL)
                        DataRollingList.add(new DataRolling(monthNameList[i-1], countList[i-1], rollingAmount));
                        System.debug('chartRollingdataa'+rollingAmount);
                    }


                    
                }



            }

			prevregion = regionname;

        }
        
     } 

     //Wrapper Classes
    public class Data {
        public String name {
            get;
            set;
        }
        public integer data1 {
            get;
            set;
        }
        public integer data2 {
            get;
            set;
        }
        public integer data3 {
            get;
            set;
        }

        public Data(String name, integer data1, integer data2, integer data3) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;

        }
    }

    public class DataOrder {
        public String name {
            get;
            set;
        }
        public integer data1 {
            get;
            set;
        }
        public integer data2 {
            get;
            set;
        }
        public integer data3 {
            get;
            set;
        }

        public DataOrder(String name, integer data1, integer data2, integer data3) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;

        }
    }

    public class DataRolling {
        public String name {
            get;
            set;
        }
        public integer data1 {
            get;
            set;
        }
        public integer data2 {
            get;
            set;
        }
        
        public DataRolling(String name, integer data1, integer data2) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
        }
    }
  
}