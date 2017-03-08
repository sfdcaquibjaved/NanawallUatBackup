/**********************************************************************
Apex Class: SuccessRatioDynamicController
Description: This class is a controller for successRatioDynamicVFPage
Created Date: 10thJuly,2016            
***********************************************************************/
public with sharing class SuccessRatioDynamicController {

    //Global Variables
    public String data {
        get;
        set;
    }
    public String ProjectChoice {
        get;
        set;
    }
    public Map < string, Integer > mtotal = new Map < string, Integer > ();
    public Map < string, Integer > mtotalQuarter = new Map < string, Integer > ();
    public Map < string, Integer > mtotalHalf = new Map < string, Integer > ();
    public Map < string, Integer > projtotalHalf = new Map < string, Integer > ();
    public Map < string, Integer > mtotalVolumeQuarter = new Map < string, Integer > ();
    public Map < string, Integer > mtotalVolumeHalf = new Map < string, Integer > ();
    public Map < string, Integer > mtotalVolume = new Map < string, Integer > ();
    public list < data > datalist {
        get;
        set;
    }
    public decimal successDecimal;
    public list < data > dataVolumelist {
        get;
        set;
    }
    public decimal rounded;
    public string yaxis {
        get;
        set;
    }
    public string titlename {
        get;
        set;
    }
    public boolean quarterTable {
        get;
        set;
    }
    public list < wrappertable > wrappperTableList {
        get;
        set;
    }
    public string columnName {
        get;
        set;
    }
    public string columnNameVolume {
        get;
        set;
    }
    public list < wrappertablevolume > wrapperTableVolumeList {
        get;
        set;
    }

    public List < SelectOption > salesreps {
        get;
        set;
    }
    public string projecttype {
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
    public string salesRepNamePrev;
    public string projectTypePrev;
    public string ProjectChoicePrev;
    //public set<id> projIdSet;

    //Controller
    public SuccessRatioDynamicController() {

        //On Loading the page the yearly chart needs o be displayed so the yearly logic is written here
        ProjectChoice = 'By Year';
        quarterTable = false;
        datalist = new list < data > ();
        dataVolumelist = new list < data > ();
        wrappperTableList = new list < wrappertable > ();
        wrapperTableVolumeList = new list < wrappertablevolume > ();
        salesreps = new List < SelectOption > ();
        salesreps.add(new SelectOption('--None--', '--None--'));
        Set<ID> projIdSet = new Set<ID>();
        projIdSet = SuccessRatioDynamicHelperClass.projectFetching();

        //By Amount
        for (AggregateResult ar: [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC]) {

            mtotal.put(string.valueof(ar.get('yeardate')), Integer.Valueof(ar.get('commission')));
        }
       
        for (AggregateResult p: [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC]) {

            if (p.get('year') != null && mtotal.containsKey(string.ValueOf(p.get('year')))) {
                integer yearval = mtotal.get(string.ValueOf(p.get('year')));
                decimal decimalval = decimal.valueof(yearval);
                system.debug('The x year values are:::::::' + decimalval );
                object obj = p.get('amount');
                integer projval = 100*integer.valueof(obj);
                decimal decimalProj = decimal.valueof(projval );
                system.debug('The a year values are:::::::' + decimalProj);

                if (decimalval != NULL && decimalval != 0 && decimalProj != NULL && decimalProj != 0) {
                    successDecimal = (decimalval / decimalProj) * 100;
                    rounded = successDecimal.setScale(2, RoundingMode.HALF_UP);
                } else
                    rounded = 0;
                System.debug('suceesss' + successDecimal);
                
                yaxis = 'Year';
                titlename = 'By Year';
                columnName = 'Yearly Success Ratio';
                string yearName = string.valueof(p.get('year'));
                dataList.add(new Data(yearName, rounded));
                string fullName = 'CY ' + yearName;
                wrappperTableList.add(new wrappertable(fullName, yearval, projval, rounded));

            }

        }

        //By Volume
        for (AggregateResult ar: [select COUNT(id) cid, CALENDAR_YEAR(order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC]) {

            mtotalVolume.put(string.valueof(ar.get('yeardate')), Integer.Valueof(ar.get('cid')));
        }

        for (AggregateResult p: [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE Id In: projIdSet AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC]) {

            if (p.get('year') != null && mtotalVolume.containsKey(string.ValueOf(p.get('year')))) {
                integer fullvol = mtotalVolume.get(string.ValueOf(p.get('year')));
                decimal decvol = decimal.valueof(fullvol);
                object obj = p.get('pid');
                integer ipvol = integer.valueof(obj);
                decimal dpvol = decimal.valueof(ipvol);
                decimal rd;
                if (decvol != NULL && decvol != 0 && dpvol != NULL && dpvol != 0) {
                    decimal op = (decvol / dpvol) * 100;
                    rd = op.setScale(2, RoundingMode.HALF_UP);
                } else
                    rd = 0;
                yaxis = 'Year';
                titlename = 'By Year';
                columnNameVolume = 'Yearly Success Ratio';
                string yearName = string.valueof(p.get('year'));
                system.debug('the rdlistis:::::::::::' + rd);
                dataVolumelist.add(new Data(yearName, rd));
                string fullName = 'CY ' + yearName;
                wrapperTableVolumeList.add(new wrappertablevolume(fullName, fullvol, ipvol, rd));

            }
        }


    }
    
/**********************************************************************
Apex Method: getRegionlist
Description: This method is used to fetch regions from the custom settings
Created Date: 10thJuly,2016            
***********************************************************************/ 
    public list < selectOption > getRegionlist() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('--None--', '--None--'));
        list < TerritoryNames__c > tnlist = TerritoryNames__c.getall().values();
        tnlist.sort();
        for (TerritoryNames__c tn: tnlist) {
            options.add(new SelectOption(tn.name, tn.name));
        }

        return options;
    }

/**********************************************************************
Apex Method: ChangeReport
Description: This method is used to calculate success ratio 
Created Date: 10thJuly,2016            
***********************************************************************/
    //The Main Functionality is Started from here    
    public PageReference ChangeReport() {

        //Select Sales reps based on regions
        if (regionname == 'Eastern Sales') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
            list < EasternSalesReps__c > eslist = EasternSalesReps__c.getall().values();
            eslist.sort();
            for (EasternSalesReps__c es: eslist) {
                salesreps.add(new SelectOption(es.name, es.name));
            }
        } else if (regionname == 'Mid Eastern Sales') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
            list < MidEasternSalesReps__c > mslist = MidEasternSalesReps__c.getall().values();
            mslist.sort();
            for (MidEasternSalesReps__c es: mslist) {
                salesreps.add(new SelectOption(es.name, es.name));
            }
        } else if (regionname == 'Midwest Sales') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
            list < MidWestSalesReps__c > lslist = MidWestSalesReps__c.getall().values();
            lslist.sort();
            for (MidWestSalesReps__c es: lslist) {
                salesreps.add(new SelectOption(es.name, es.name));
            }
        } else if (regionname == 'Western Sales') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
            list < WesternSalesReps__c > kslist = WesternSalesReps__c.getall().values();
            kslist.sort();
            for (WesternSalesReps__c es: kslist) {
                salesreps.add(new SelectOption(es.name, es.name));
            }
        } else if (regionname == '--None--') {
            salesreps.clear();
            salesreps.add(new SelectOption('--None--', '--None--'));
        }

        Set<ID> projIdSet = new Set<ID>();
        projIdSet = SuccessRatioDynamicHelperClass.projectFetching();
        //If the Filter is selected for Quarterly Basis.    
        if (ProjectChoice == 'By Quarter') {
            list < AggregateResult > arlist = new list < AggregateResult > ();
            list < AggregateResult > prlist = new list < AggregateResult > ();
            list < AggregateResult > arvolumelist = new list < AggregateResult > ();
            list < AggregateResult > prvolumelist = new list < AggregateResult > ();
            if (salesrepname == salesRepNamePrev && projectTypePrev == projecttype && ProjectChoicePrev == ProjectChoice) {
                salesrepname = NULL;
            }
            dataList.clear();
            dataVolumelist.clear();
            wrappperTableList.clear();
            wrapperTableVolumeList.clear();
            mtotalVolumeQuarter.clear();
            mtotalQuarter.clear();
            quarterTable = true;
            
            //If the project type is filled
            if (projecttype != NULL && projecttype != '--None--') {
                System.debug('regionnameeee' + regionname);
                
                //If the region is filled
                if (regionname != NULL && regionname != '--None--') {
                
                    //If the Salesrep is filled
                    if (salesrepname != NULL && salesrepname != '--None--') {

                        
                        arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                            AND Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                        ];

                        prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project__r.RecordType.Name =: projecttype
                            AND Project_Rep__r.Name =: salesrepname AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC
                        ];

                        arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                            AND Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                        ];

                        prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND RecordType.Name =: projecttype
                            AND owner.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC
                        ];
                    } 
                    //If the salesrep is not filled
                    else {
                        set < string > ownerNameset = new set < string > ();
                        ownerNameset = FetchingSalesRepsfromTerritories.getsalesreps(regionname);

                        System.debug('ownernamesssssssss' + ownerNameset);
                        if (ownerNameset.size() > 0) {
                            arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                                AND Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                            ];

                            prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project__r.RecordType.Name =: projecttype
                                AND Project_Rep__r.Name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC
                            ];

                            arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                                AND Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                            ];

                            prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND RecordType.Name =: projecttype
                                AND owner.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC
                            ];

                        }
                    }
                } 
                //If Region is not filled
                else {
                    arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                        AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                    ];

                    prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project__r.RecordType.Name =: projecttype
                        AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC
                    ];

                    arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                        AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                    ];

                    prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND RecordType.Name =: projecttype
                        AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC
                    ];

                }
            } 
            //If project Type is not filled
            else {
                System.debug('regionnameeee' + regionname);
                if (regionname != NULL && regionname != '--None--') {
                    //If the region is filled
                    if (salesrepname != NULL && salesrepname != '--None--') {
                        //If the salesrep is filled
                        arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                        prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project_Rep__r.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC];

                        arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                        prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND owner.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC];
                    } 
                    //If the salesrep is not filled
                    else {
                        set < string > ownerNameset = new set < string > ();
                        ownerNameset = FetchingSalesRepsfromTerritories.getsalesreps(regionname);
                        System.debug('ownernamesssssssss' + ownerNameset);
                        if (ownerNameset.size() > 0) {
                            arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                            prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project_Rep__r.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC];

                            arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                            prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND owner.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC];

                        }
                    }
                } 
                //If the region is not filled
                else {
                    system.debug('projecttypeeeeeeeee' + projecttype);
                    arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                    prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC];

                    //By Volume
                    arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                    prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC];


                }
            }
            
            //If list size is not null
            if (arlist.size() > 0) {
                for (AggregateResult ar: arlist) {
                    string Qyear = (Integer.valueof(ar.get('quarter'))) + ' ' + (string.valueof(ar.get('yeardate')));
                    mtotalQuarter.put(Qyear, Integer.Valueof(ar.get('commission')));

                }
            }

            if (prlist.size() > 0) {
                for (AggregateResult p: prlist) {
                    system.debug('projectcountttttt' + prlist);
                    String PQYear = (Integer.valueof(p.get('projectquarter'))) + ' ' + (string.valueof(p.get('year')));

                    if (PQYear != null && mtotalQuarter.containsKey(PQYear)) {
                        integer yearVal = mtotalQuarter.get(PQYear);
                        decimal decimalVal = decimal.valueof(yearVal);
                        system.debug('The x year values are:::::::' + decimalVal);
                        object obj = p.get('amount');
                        integer projVal = integer.valueof(obj);
                        projVal = projVal*100;
                        decimal projDec = decimal.valueof(projVal);
                        system.debug('The a year values are:::::::' + projVal);
                        if (decimalVal != NULL && decimalVal != 0 && projDec != NULL && projDec != 0) {
                            successDecimal = (decimalVal / projDec) * 100;
                            rounded = successDecimal.setScale(2, RoundingMode.HALF_UP);
                        } else
                            rounded = 0;
                        
                        yaxis = 'Quarter Year';
                        titlename = 'By Quarter';
                        columnName = 'Quarterly Success Ratio';
                        string yearName = 'Q' + Integer.valueof(p.get('projectquarter')) + ' ' + string.valueof(p.get('year'));
                        string fullName = 'CY ' + yearName;
                        dataList.add(new Data(yearName, rounded));
                        wrappperTableList.add(new wrappertable(fullName, yearVal, projVal, rounded));
                        System.debug('tableeeeeee' + wrappperTableList);
                    }
                }
            }

            list < data > dataNewListQuarter1 = new list < data > ();
            list < data > dataNewListQuarter2 = new list < data > ();
            list < data > dataNewListQuarter3 = new list < data > ();
            list < data > dataNewListQuarter4 = new list < data > ();
            for (data d: dataList) {

                if (d.name.contains('Q1')) {
                    dataNewListQuarter1.add(new Data(d.name, d.data1));
                } else if (d.name.contains('Q2')) {
                    dataNewListQuarter2.add(new Data(d.name, d.data1));
                } else if (d.name.contains('Q3')) {
                    dataNewListQuarter3.add(new Data(d.name, d.data1));
                } else if (d.name.contains('Q4')) {
                    dataNewListQuarter4.add(new Data(d.name, d.data1));
                }

            }

            dataList.clear();
            dataList.addAll(dataNewListQuarter1);
            dataList.addAll(dataNewListQuarter2);
            dataList.addAll(dataNewListQuarter3);
            dataList.addAll(dataNewListQuarter4);

            //By Volume

            for (AggregateResult ar: arvolumelist) {

                string Qyear = (Integer.valueof(ar.get('quarter'))) + ' ' + (string.valueof(ar.get('yeardate')));
                mtotalVolumeQuarter.put(Qyear, Integer.Valueof(ar.get('cid')));
                system.debug('quotetotalcal' + mtotalVolumeQuarter);
            }

            if (prvolumelist.size() > 0) {
                for (AggregateResult p: prvolumelist) {

                    String PQYear = (Integer.valueof(p.get('projectquarter'))) + ' ' + (string.valueof(p.get('year')));

                    if (PQYear != null && mtotalVolumeQuarter.containsKey(PQYear)) {
                        integer tvol = mtotalVolumeQuarter.get(PQYear);
                        decimal dvol = decimal.valueof(tvol);
                        object obj = p.get('pid');
                        integer ipvol = integer.valueof(obj);
                        decimal pvol = decimal.valueof(ipvol);
                        decimal rd;
                        system.debug('volumeQuartercal' + prvolumelist);
                        if (dvol != NULL && dvol != 0 && pvol != NULL && pvol != 0) {
                            decimal op = (dvol / pvol) * 100;
                            rd = op.setScale(2, RoundingMode.HALF_UP);
                        } else
                            rd = 0;
                        yaxis = 'Quarter Year';
                        titlename = 'By Quarter';
                        columnNameVolume = 'Quarterly Success Ratio';
                        string yearName = 'Q' + Integer.valueof(p.get('projectquarter')) + ' ' + string.valueof(p.get('year'));
                        dataVolumelist.add(new Data(yearName, rd));
                        string fullName = 'CY ' + yearName;
                        wrapperTableVolumeList.add(new wrappertablevolume(fullName, tvol, ipvol, rd));

                    }

                }

                list < data > dataVolumeNewListQuarter1 = new list < data > ();
                list < data > dataVolumeNewListQuarter2 = new list < data > ();
                list < data > dataVolumeNewListQuarter3 = new list < data > ();
                list < data > dataVolumeNewListQuarter4 = new list < data > ();
                for (data d: dataVolumelist) {

                    if (d.name.contains('Q1')) {
                        dataVolumeNewListQuarter1.add(new Data(d.name, d.data1));
                    } else if (d.name.contains('Q2')) {
                        dataVolumeNewListQuarter2.add(new Data(d.name, d.data1));
                    } else if (d.name.contains('Q3')) {
                        dataVolumeNewListQuarter3.add(new Data(d.name, d.data1));
                    } else if (d.name.contains('Q4')) {
                        dataVolumeNewListQuarter4.add(new Data(d.name, d.data1));
                    }

                }

                dataVolumelist.clear();
                dataVolumelist.addAll(dataVolumeNewListQuarter1);
                dataVolumelist.addAll(dataVolumeNewListQuarter2);
                dataVolumelist.addAll(dataVolumeNewListQuarter3);
                dataVolumelist.addAll(dataVolumeNewListQuarter4);
            }
            salesRepNamePrev = salesrepname;
            projectTypePrev = projecttype;
            ProjectChoicePrev = ProjectChoice;

        } 
        //If the filter type is Halferly
        else if (ProjectChoice == 'By Halfyear') {
            list < AggregateResult > arlist = new list < AggregateResult > ();
            list < AggregateResult > prlist = new list < AggregateResult > ();
            list < AggregateResult > arvolumelist = new list < AggregateResult > ();
            list < AggregateResult > prvolumelist = new list < AggregateResult > ();
            if (salesrepname == salesRepNamePrev && projectTypePrev == projecttype && ProjectChoicePrev == ProjectChoice) {
                salesrepname = NULL;
            }
            dataList.clear();
            dataVolumelist.clear();
            wrappperTableList.clear();
            wrapperTableVolumeList.clear();
            mtotalVolumeHalf.clear();
            mtotalHalf.clear();
            
            //If the project type is filled
            if (projecttype != NULL && projecttype != '--None--') {
                System.debug('regionnameeee' + regionname);
                if (regionname != NULL && regionname != '--None--') {
                    //If the region is filled
                    if (salesrepname != NULL && salesrepname != '--None--') {
                        //If the salesrep is filled
                        arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                            AND Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                        ];
						System.debug('totalorderreportdata '+arlist);
                        prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project__r.RecordType.Name =: projecttype
                            AND Project_Rep__r.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC
                        ];

                        arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                            AND Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                        ];

                        prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND RecordType.Name =: projecttype
                            AND owner.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC
                        ];
                    } 
                    //If the salesrep is not filled
                    else {
                        set < string > ownerNameset = new set < string > ();
                        ownerNameset = FetchingSalesRepsfromTerritories.getsalesreps(regionname);
                        System.debug('ownernamesssssssss' + ownerNameset);
                        if (ownerNameset.size() > 0) {
                            arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                                AND Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                            ];

                            prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project__r.RecordType.Name =: projecttype
                                AND Project_Rep__r.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC
                            ];

                            arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                                AND Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                            ];

                            prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND RecordType.Name =: projecttype
                                AND owner.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC
                            ];

                        }
                    }
                } 
                //If the region is not filled
                else {
                    arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                        AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                    ];

                    prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project__r.RecordType.Name =: projecttype
                        AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC
                    ];

                    arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                        AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC
                    ];

                    prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND RecordType.Name =: projecttype
                        AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC
                    ];

                }
            } 
            //If the project type is not filled
            else {
                System.debug('regionnameeee' + regionname);
                //If the region is filled
                if (regionname != NULL && regionname != '--None--') {
                    //If the salesrep is filled
                    if (salesrepname != NULL && salesrepname != '--None--') {
                        arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                        prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project_Rep__r.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC];

                        arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                        prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND owner.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC];
                    } 
                    //If the salesrep is not filled
                    else {
                        set < string > ownerNameset = new set < string > ();
                        ownerNameset = FetchingSalesRepsfromTerritories.getsalesreps(regionname);
                        System.debug('ownernamesssssssss' + ownerNameset);
                        if (ownerNameset.size() > 0) {
                            arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                            prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project_Rep__r.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC];

                            arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                            prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND owner.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC];

                        }
                    }
                } 
                //If the region is not filled
                else {

                    arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                    prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) projectquarter from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)), CALENDAR_QUARTER(convertTimezone(project__r.CreatedDate)) ASC];

                    //By Volume

                    arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, CALENDAR_QUARTER(Order_Finalized_Date__c) quarter, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c), CALENDAR_QUARTER(Order_Finalized_Date__c) ASC];

                    prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_QUARTER(convertTimezone(CreatedDate)) projectquarter from Project__c WHERE Id In: projIdSet AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_QUARTER(convertTimezone(CreatedDate)) ASC];

                }
            }
            integer amt1 = 0;
            integer amt2 = 0;
            integer amt3 = 0;
            integer amt4 = 0;
            
            //if list size is not equal to null
          
          if (arlist.size() > 0) {
                for (AggregateResult ar: arlist) {
                    
                    if (Integer.valueof(ar.get('quarter')) == 1) {
                        object comObj = ar.get('commission');
                        if (comObj != NULL && comObj != 0)
                            amt1 = Integer.Valueof(comObj);
                        else
                            amt1 = 0;
                    } else if (Integer.valueof(ar.get('quarter')) == 2) {
                        integer ct;
                        object comObj = ar.get('commission');
                        if (comObj != NULL && comObj != 0)
                            amt2 = amt1 + Integer.Valueof(comObj);
                        else
                            amt2 = 0;
                        ct = 1;
                        string Qyear = (ct + ' ' + (string.valueof(ar.get('yeardate'))));
                        mtotalHalf.put(Qyear, amt2);
                        amt1 = 0;
                        amt2 = 0;
                    } else if (Integer.valueof(ar.get('quarter')) == 3) {
                        object comObj = ar.get('commission');
                        if (comObj != NULL && comObj != 0)
                            amt3 = Integer.Valueof(ar.get('commission'));
                        else
                            amt3 = 0;
                    } else if (Integer.valueof(ar.get('quarter')) == 4) {
                        integer ct;
                        object comObj = ar.get('commission');
                        if (comObj != NULL && comObj != 0)
                            amt4 = amt3 + Integer.Valueof(ar.get('commission'));
                        else
                            amt4 = 0;
                        ct = 2;
                        string Qyear = (ct + ' ' + (string.valueof(ar.get('yeardate'))));
                        mtotalHalf.put(Qyear, amt4);
                        amt3 = 0;
                        amt4 = 0;
                    }

                }
            }
            Map < string, decimal > maplist = new map < string, decimal > ();
            if (prlist.size() > 0) {
                integer projamt1 = 0;
                integer projamt2 = 0;
                integer projamt3 = 0;
                integer projamt4 = 0;

                for (AggregateResult p: prlist) {

                    if (Integer.valueof(p.get('projectquarter')) == 1) {
                        object comObj = p.get('amount');
                        if (comObj != NULL && comObj != 0)
                            projamt1 = 100*Integer.Valueof(comObj);
                        else
                            projamt1 = 0;
                    } else if (Integer.valueof(p.get('projectquarter')) == 2) {
                        integer ct;
                        system.debug('projectamouynttttttttt' + p.get('amount'));
                        object comObj = p.get('amount');
                        if (comObj != NULL && comObj != 0)
                            projamt2 = projamt1 + (100*Integer.Valueof(comObj));
                        else
                            projamt2 = 0;
                        ct = 1;
                        string Qyear = (ct + ' ' + (string.valueof(p.get('year'))));

                        integer mamount = mtotalHalf.get(Qyear);
                        decimal mamtdec = decimal.valueof(mamount);
                        decimal projdec = decimal.valueof(projamt2);
                        decimal rou;
                        if (mamtdec != NULL && mamtdec != 0 && projdec != NULL && projdec != 0) {
                            decimal op = (mamtdec / projdec) * 100;
                            rou = op.setScale(2, RoundingMode.HALF_UP);
                        } else
                            rou = 0;
                        yaxis = 'Half Year';
                        titlename = 'By Half Year';
                        columnName = 'Halferly Success Ratio';

                        string ss = 'H' + Qyear;
                        string nm = 'CY ' + ss;
                        wrappperTableList.add(new wrappertable(nm, mamount, projamt2, rou));
                        dataList.add(new Data(ss, rou));
                        projtotalHalf.put(Qyear, projamt2);
                        amt1 = 0;
                        amt2 = 0;
                    } else if (Integer.valueof(p.get('projectquarter')) == 3) {
                        object comObj = p.get('amount');
                        if (comObj != NULL && comObj != 0)
                            projamt3 = 100*Integer.Valueof(comObj);
                        else
                            projamt3 = 0;
                    } else if (Integer.valueof(p.get('projectquarter')) == 4) {
                        integer ct;
                        object comObj = p.get('amount');
                        if (comObj != NULL && comObj != 0)
                            projamt4 = projamt3 + (100*Integer.Valueof(comObj));
                        else
                            projamt4 = 0;
                        ct = 2;
                        string Qyear = (ct + ' ' + (string.valueof(p.get('year'))));
                        integer mamount = mtotalHalf.get(Qyear);
                        decimal mamtdec = decimal.valueof(mamount);
                        decimal projdec = decimal.valueof(projamt4);
                        decimal rou;
                        if (mamtdec != NULL && mamtdec != 0 && projdec != NULL && projdec != 0) {
                            decimal op = (mamtdec / projdec) * 100;
                            rou = op.setScale(2, RoundingMode.HALF_UP);
                        } else
                            rou = 0;
                        yaxis = 'Half Year';
                        titlename = 'By Half Year';
                        columnName = 'Halferly Success Ratio';
                        string ss = 'H' + Qyear;
                        string nm = 'CY ' + ss;
                        wrappperTableList.add(new wrappertable(nm, mamount, projamt4, rou));
                        dataList.add(new Data(ss, rou));

                        projtotalHalf.put(Qyear, projamt4);
                        amt3 = 0;
                        amt4 = 0;
                    }

                }
            }

            list < data > dataNewListHalf1 = new list < data > ();
            list < data > dataNewListHalf2 = new list < data > ();

            for (data d: dataList) {

                if (d.name.contains('H1')) {
                    dataNewListHalf1.add(new Data(d.name, d.data1));
                } else if (d.name.contains('H2')) {
                    dataNewListHalf2.add(new Data(d.name, d.data1));
                }

            }

            dataList.clear();
            dataList.addAll(dataNewListHalf1);
            dataList.addAll(dataNewListHalf2);
            
            //By Volume

            integer vol1 = 0;
            integer vol2 = 0;
            integer vol3 = 0;
            integer vol4 = 0;
            if (arvolumelist.size() > 0) {
                for (AggregateResult ar: arvolumelist) {


                    if (Integer.valueof(ar.get('quarter')) == 1) {
                        object comObj = ar.get('cid');
                        if (comObj != NULL && comObj != 0)
                            vol1 = Integer.Valueof(comObj);
                        else
                            vol1 = 0;
                    } else if (Integer.valueof(ar.get('quarter')) == 2) {
                        integer ct;
                        object comObj = ar.get('cid');
                        if (comObj != NULL && comObj != 0)
                            vol2 = vol1 + Integer.Valueof(comObj);
                        else
                            vol2 = 0;
                        ct = 1;
                        string Qyear = (ct + ' ' + (string.valueof(ar.get('yeardate'))));
                        mtotalVolumeHalf.put(Qyear, vol2);
                        vol1 = 0;
                        vol2 = 0;
                    } else if (Integer.valueof(ar.get('quarter')) == 3) {
                        object comObj = ar.get('cid');
                        if (comObj != NULL && comObj != 0)
                            vol3 = Integer.Valueof(comObj);
                        else
                            vol3 = 0;
                    } else if (Integer.valueof(ar.get('quarter')) == 4) {
                        integer ct;
                        object comObj = ar.get('cid');
                        if (comObj != NULL && comObj != 0)
                            vol4 = vol3 + Integer.Valueof(comObj);
                        else
                            vol4 = 0;
                        ct = 2;
                        string Qyear = (ct + ' ' + (string.valueof(ar.get('yeardate'))));
                        mtotalVolumeHalf.put(Qyear, vol4);
                        vol3 = 0;
                        vol4 = 0;
                    }
                }
            }
            if (prvolumelist.size() > 0) {
                integer projvol1 = 0;
                integer projvol2 = 0;
                integer projvol3 = 0;
                integer projvol4 = 0;

                for (AggregateResult p: prvolumelist) {

                    if (Integer.valueof(p.get('projectquarter')) == 1) {
                        object comObj = p.get('pid');
                        if (comObj != NULL && comObj != 0)
                            projvol1 = Integer.Valueof(comObj);
                        else
                            projvol1 = 0;
                    } else if (Integer.valueof(p.get('projectquarter')) == 2) {
                        integer ct;
                        object comObj = p.get('pid');
                        if (comObj != NULL && comObj != 0)
                            projvol2 = projvol1 + Integer.Valueof(comObj);
                        else
                            projvol2 = 0;
                        ct = 1;
                        string Qyear = (ct + ' ' + (string.valueof(p.get('year'))));

                        integer mamount = mtotalVolumeHalf.get(Qyear);
                        decimal mamtdec = decimal.valueof(mamount);
                        decimal projdec = decimal.valueof(projvol2);
                        decimal rou;
                        if (mamtdec != NULL && mamtdec != 0 && projdec != NULL && projdec != 0) {
                            decimal op = (mamtdec / projdec) * 100;
                            rou = op.setScale(2, RoundingMode.HALF_UP);
                        } else
                            rou = 0;
                        yaxis = 'Half Year';
                        titlename = 'By Half Year';
                        columnNameVolume = 'Halferly Success Ratio';
                        string ss = 'H' + Qyear;
                        dataVolumelist.add(new Data(ss, rou));
                        string nm = 'CY ' + ss;
                        wrapperTableVolumeList.add(new wrappertablevolume(nm, mamount, projvol2, rou));
                        //projtotalHalf.put(Qyear, projvol1);                    
                        projvol1 = 0;
                        projvol2 = 0;
                    } else if (Integer.valueof(p.get('projectquarter')) == 3) {
                        object comObj = p.get('pid');
                        if (comObj != NULL && comObj != 0)
                            projvol3 = Integer.Valueof(comObj);
                        else
                            projvol3 = 0;
                    } else if (Integer.valueof(p.get('projectquarter')) == 4) {
                        integer ct;
                        object comObj = p.get('pid');
                        if (comObj != NULL && comObj != 0)
                            projvol4 = projvol3 + Integer.Valueof(comObj);
                        else
                            projvol4 = 0;
                        ct = 2;
                        string Qyear = (ct + ' ' + (string.valueof(p.get('year'))));
                        integer mamount = mtotalVolumeHalf.get(Qyear);
                        decimal mamtdec = decimal.valueof(mamount);
                        decimal projdec = decimal.valueof(projvol4);
                        decimal rou;
                        if (mamtdec != NULL && mamtdec != 0 && projdec != NULL && projdec != 0) {
                            decimal op = (mamtdec / projdec) * 100;
                            rou = op.setScale(2, RoundingMode.HALF_UP);
                        } else
                            rou = 0;
                        yaxis = 'Half Year';
                        titlename = 'By Half Year';
                        columnNameVolume = 'Halferly Success Ratio';
                        string ss = 'H' + Qyear;
                        dataVolumelist.add(new Data(ss, rou));
                        string nm = 'CY ' + ss;
                        wrapperTableVolumeList.add(new wrappertablevolume(nm, mamount, projvol4, rou));
                        //projtotalHalf.put(Qyear, projamt4);                    
                        projvol3 = 0;
                        projvol4 = 0;
                    }

                }

                list < data > dataVolumeNewListHalf1 = new list < data > ();
                list < data > dataVolumeNewListHalf2 = new list < data > ();

                for (data d: dataVolumelist) {

                    if (d.name.contains('H1')) {
                        dataVolumeNewListHalf1.add(new Data(d.name, d.data1));
                    } else if (d.name.contains('H2')) {
                        dataVolumeNewListHalf2.add(new Data(d.name, d.data1));
                    }

                }

                dataVolumelist.clear();
                dataVolumelist.addAll(dataVolumeNewListHalf1);
                dataVolumelist.addAll(dataVolumeNewListHalf2);
            }
            salesRepNamePrev = salesrepname;
            projectTypePrev = projecttype;
            ProjectChoicePrev = ProjectChoice;

        }
        //If the Prpject Choice is By Yearly
         else if (ProjectChoice == 'By Year') {
            System.debug('ProjectChoiceeee' + ProjectChoice);
            System.debug('ProjectTypeeee' + projecttype);
            System.debug('regionnameeee' + regionname);
            System.debug('SalesRepspresent' + salesrepname);
            if (salesrepname == salesRepNamePrev && projectTypePrev == projecttype && ProjectChoicePrev == ProjectChoice) {
                salesrepname = NULL;
            }

            dataList.clear();
            dataVolumelist.clear();
            wrappperTableList.clear();
            wrapperTableVolumeList.clear();
            mtotal.clear();
            mtotalVolume.clear();
            list < AggregateResult > arlist = new list < AggregateResult > ();
            list < AggregateResult > prlist = new list < AggregateResult > ();
            list < AggregateResult > arvolumelist = new list < AggregateResult > ();
            list < AggregateResult > prvolumelist = new list < AggregateResult > ();
            
            //If the project type is filled
            if (projecttype != NULL && projecttype != '--None--') {
                System.debug('regionnameeee' + regionname);
                //If the region is filled
                if (regionname != NULL && regionname != '--None--') {
                    //If the salesrep is filled
                    if (salesrepname != NULL && salesrepname != '--None--') {

                        arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                            AND Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC
                        ];

                        prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c IN: projIdSet AND Split__c>0 AND Project__r.RecordType.Name =: projecttype
                            AND Project_Rep__r.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC
                        ];

                        arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                            AND Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC
                        ];

                        prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE Id IN: projIdSet AND RecordType.Name =: projecttype
                            AND owner.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC
                        ];
                    }
                    //If the salesrep is not filled
                    else {
                        set < string > ownerNameset = new set < string > ();
                        ownerNameset = FetchingSalesRepsfromTerritories.getsalesreps(regionname);
                        System.debug('ownernamesssssssss' + ownerNameset);
                        if (ownerNameset.size() > 0) {
                            arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                                AND Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC
                            ];

                            prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project__r.RecordType.Name =: projecttype
                                AND Project_Rep__r.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC
                            ];

                            arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                                AND Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC
                            ];

                            prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE Id In: projIdSet AND RecordType.Name =: projecttype
                                AND owner.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC
                            ];

                        }
                    }
                } 
                //If the region is not filled
                else {
                    arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                        AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC
                    ];

                    prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project__r.RecordType.Name =: projecttype
                        AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC
                    ];

                    arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Project_Type__c =: projecttype
                        AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC
                    ];

                    prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE Id In: projIdSet AND RecordType.Name =: projecttype
                        AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC
                    ];

                }
            } 
            //If the project type is not filled
            else {
                System.debug('regionnameeee' + regionname);
                //If the region is filled
                if (regionname != NULL && regionname != '--None--') {
                    //If the salesrep is filled
                    if (salesrepname != NULL && salesrepname != '--None--') {
                        arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                        prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c IN: projIdSet AND Split__c>0 AND Project_Rep__r.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC];

                        arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND Order_Number__c > 1 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                        prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE ID IN: projIdSet AND owner.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC];
                    } 
                    //If the salesrep is not filled
                    else {
                        set < string > ownerNameset = new set < string > ();
                        ownerNameset = FetchingSalesRepsfromTerritories.getsalesreps(regionname);
                        System.debug('ownernamesssssssss' + ownerNameset);
                        if (ownerNameset.size() > 0) {
                            arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                            prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND Project_Rep__r.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC];

                            arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                            prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE Id In: projIdSet AND owner.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC];

                        }
                    }
                }
                //If the region is not filled
                else {

                    arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                    prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c In: projIdSet AND Split__c>0 AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >= 2012 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC];

                    //By Volume

                    arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >= 2012 AND Split__c > 0 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                    prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE Id In: projIdSet AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >= 2012 AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC];

                }
            }
            
            //If list is Greater than zero
            //By Amount
            if (arlist.size() > 0) {
                for (AggregateResult ar: arlist) {

                    mtotal.put(string.valueof(ar.get('yeardate')), Integer.Valueof(ar.get('commission')));
                }
            }

            if (prlist.size() > 0) {
                for (AggregateResult p: prlist) {

                    if (p.get('year') != null && mtotal.containsKey(string.ValueOf(p.get('year')))) {
                        integer yearVal = mtotal.get(string.ValueOf(p.get('year')));
                        decimal decimalVal = decimal.valueof(yearVal);
                        system.debug('The x year values are:::::::' +decimalVal);
                        object obj = p.get('amount');
                        integer projVal = 100*integer.valueof(obj);
                        decimal projDec = decimal.valueof(projVal);
                        system.debug('The a year values are:::::::' + projVal);
                        if (decimalVal != 0 && decimalVal != NULL && projDec != NULL && projDec != 0) {
                            successDecimal = (decimalVal / projDec) * 100;
                            rounded = successDecimal.setScale(2, RoundingMode.HALF_UP);
                        } else
                            rounded = 0;                       

                        yaxis = 'Year';
                        titlename = 'By Year';
                        columnName = 'Yearly Success Ratio';
                        string yearName = string.valueof(p.get('year'));
                        dataList.add(new Data(yearName, rounded));
                        string fullName = 'CY ' + yearName;
                        wrappperTableList.add(new wrappertable(fullName, yearVal, projVal, rounded));

                    }
                }
            }


            //By Volume

            if (arvolumelist.size() > 0) {
                for (AggregateResult ar: arvolumelist) {

                    mtotalVolume.put(string.valueof(ar.get('yeardate')), Integer.Valueof(ar.get('cid')));
                }
            }

            if (prvolumelist.size() > 0) {
                for (AggregateResult p: prvolumelist) {

                    if (p.get('year') != null && mtotalVolume.containsKey(string.ValueOf(p.get('year')))) {
                        integer fullvol = mtotalVolume.get(string.ValueOf(p.get('year')));
                        decimal decvol = decimal.valueof(fullvol);
                        object obj = p.get('pid');
                        integer ipvol = integer.valueof(obj);
                        decimal dpvol = decimal.valueof(ipvol);
                        decimal rd;
                        if (decvol != 0 && decvol != NULL && dpvol != NULL && dpvol != 0) {
                            decimal op = (decvol / dpvol) * 100;
                            rd = op.setScale(2, RoundingMode.HALF_UP);
                        } else
                            rd = 0;
                        yaxis = 'Year';
                        titlename = 'By Year';
                        columnNameVolume = 'Yearly Success Ratio';
                        string ss = string.valueof(p.get('year'));
                        system.debug('the rdis:::::::::::' + rd);
                        dataVolumelist.add(new Data(ss, rd));
                        string nm = 'CY ' + ss;
                        wrapperTableVolumeList.add(new wrappertablevolume(nm, fullvol, ipvol, rd));

                    }
                }
            }

            salesRepNamePrev = salesrepname;
            projectTypePrev = projecttype;
            ProjectChoicePrev = ProjectChoice;
        } else {
            dataList.clear();
            dataVolumelist.clear();
            wrapperTableVolumeList.clear();
            wrappperTableList.clear();
        }

        return null;
    }

    //Wrapper Classes
    public class Data {
        public String name {
            get;
            set;
        }
        public decimal data1 {
            get;
            set;
        }


        public Data(String name, decimal data1) {
            this.name = name;
            this.data1 = data1;

        }
    }

    public class wrappertable {

        public String yearname {
            get;
            set;
        }
        public integer totalOrderamount {
            get;
            set;
        }
        public integer projectamount {
            get;
            set;
        }
        public decimal successratio {
            get;
            set;
        }

        public wrappertable(String yearname, integer tamount, integer pamount, decimal sratio) {
            this.yearname = yearname;
            this.totalOrderamount = tamount;
            this.projectamount = pamount;
            this.successratio = sratio;
        }

    }

    public class wrappertablevolume {

        public String yearname {
            get;
            set;
        }
        public integer totalOrdervolume {
            get;
            set;
        }
        public integer projectvolume {
            get;
            set;
        }
        public decimal successratio {
            get;
            set;
        }

        public wrappertablevolume(String yearname, integer tvol, integer pvol, decimal sratio) {
            this.yearname = yearname;
            this.totalOrdervolume = tvol;
            this.projectvolume = pvol;
            this.successratio = sratio;
        }
    }

}