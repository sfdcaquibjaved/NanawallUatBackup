/**********************************************************************
Apex Class: KPIDashboardController
Description: This class is a controller for Interactive Dashboard Vf Page
Created Date: 10thAugust,2016            
***********************************************************************/
public class KPIDashboardController {

    //Global Variables
    public String data {
        get;
        set;
    }
    public Map < string, Integer > mtotal = new Map < string, Integer > ();
    public Map < string, Integer > mtotalVolume = new Map < string, Integer > ();

    public decimal z;
    public decimal rounded;
    public string yaxis {
        get;
        set;
    }
    public string titlename {
        get;
        set;
    }
    public boolean quartertable {
        get;
        set;
    }
    public string columnname {
        get;
        set;
    }
    public string columnnamevolume {
        get;
        set;
    }
    public list < wrappertablemetrics > wrappertablemetriclist {
        get;
        set;
    }
    public list < wrappertablevolumemetrics > wrappertablevolumemetriclist {
        get;
        set;
    }
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
    public boolean metriccheck {
        get;
        set;
    }
    public boolean metriccheckdown {
        get;
        set;
    }
    public boolean metricVolumeCheck {
        get;
        set;
    }
    public boolean metricVolumeCheckdown {
        get;
        set;
    }
    public boolean metriccheckEqual {
        get;
        set;
    }
    public boolean metricVolumeCheckEqual {
        get;
        set;
    }
    public boolean metricregioncheck {
        get;
        set;
    }
    public boolean metricregioncheckdown {
        get;
        set;
    }
    public boolean metricregionVolumeCheck {
        get;
        set;
    }
    public boolean metricregionVolumeCheckdown {
        get;
        set;
    }
    public boolean metricregioncheckEqual {
        get;
        set;
    }
    public boolean metricregionVolumeCheckEqual {
        get;
        set;
    }
    public integer chartHeight {
        get;
        set;
    }
    public integer chartWeight {
        get;
        set;
    }
    public string legendName {
        get; 
        set;
    }
    public boolean salesrepcheck {
        get;
        set;
    }
    public boolean regioncheck {
        get;
        set;
    }
    public boolean metricyearcheck {
        get;
        set;
    }
    public boolean metricyearcheckdown {
        get;
        set;
    }
    public boolean metricyearcheckequal {
        get;
        set;
    }
    public boolean metricvolumeyearcheck {
        get;
        set;
    }
    public boolean metricvolumeyearcheckdown {
        get;
        set;
    }
    public boolean metricvolumeyearcheckequal {
        get;
        set;
    }
    public decimal sratioyearprev;
    public decimal sratiovolumeyearprev;
    public list < wrappertablevolumeregionmetrics > wrappertablevolumeregionmetricsList {
        get;
        set;
    }
    public list < wrappertableregionmetrics > wrappertableregionmetricsList {
        get;
        set;
    }
    public list < wrappertablevolumeyearmetrics > wrappertablevolumeyearmetricsList {
        get;
        set;
    }
    public list < wrappertableyearmetrics > wrappertableyearmetricsList {
        get;
        set;
    }
    public list < wrappertablesitevisit > wrappertablesitevisitList {
        get;
        set;
    }
    public decimal sratioregion;
    public decimal sratiovolumeregion;
    public string salesrepnameprev;
    public string regionprev;
    public boolean usedCheck {
        get;
        set;
    }
    public boolean successCheck {
        get;
        set;
    }
    public decimal sratioVolumeyear;

    //Trend Dashboard
    public string userid;
    public boolean communityuser {
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
    public list < dataStage > dataStagelist {
        get;
        set;
    }
    public list < DataRolling > DataRollingList {
        get;
        set;
    }
    public list < DataRollingArch > DataRollingArchList {
        get;
        set;
    }
    public string firstYearString {
        get;
        set;
    }
    public string secondYearString {
        get;
        set;
    }
    public string thirdYearString {
        get;
        set;
    }
    public user u;

    //Peformance Chart
    public string yearsalesgoal {
        get;
        set;
    }
    public string ytdsalesgoal {
        get;
        set;
    }
    public string ytdsalesactual {
        get;
        set;
    }
    public decimal ytdSallesActualDecim {
        get;
        set;
    }
    public string fullyearsale {
        get;
        set;
    }
    public decimal annualgoalsmet {
        get;
        set;
    }
    public decimal ytdgoalmet {
        get;
        set;
    }
    public integer salesyear {
        get;
        set;
    }
    public boolean regionUser {
        get;
        set;
    }
    public boolean adminCheck {
        get;
        set;
    }    
    public string fname{
        get;
        set;
    }
     public string sname{
        get;
        set;
    }
    public boolean mobileCheck {
        get;
        set;
    }
    public boolean NoAccessUser {
        get;
        set;
    }
    //Controller
    public KPIDashboardController() {

        //On Loading the page the yearly chart needs to be displayed so the yearly logic is written here
        salesrepname = NULL;
        quartertable = false;
        salesrepcheck = false;
        regioncheck = false;
        communityuser = false;
        successCheck = false;
        mobileCheck = false;
        usedCheck = false;
        NoAccessUser = false;
        wrappertablemetriclist = new list < wrappertablemetrics > ();
        wrappertablevolumemetriclist = new list < wrappertablevolumemetrics > ();
        wrappertablevolumeregionmetricsList = new list < wrappertablevolumeregionmetrics > ();
        wrappertableregionmetricsList = new list < wrappertableregionmetrics > ();
        wrappertablevolumeyearmetricsList = new list < wrappertablevolumeyearmetrics > ();
        wrappertableyearmetricsList = new list < wrappertableyearmetrics > ();
        wrappertablesitevisitList = new list < wrappertablesitevisit > ();
        dataStagelist = new list < dataStage > ();
        salesreps = new List < SelectOption > ();
        salesreps.add(new SelectOption('--None--', '--None--'));
        datalist = new list < data > ();
        dataOrderlist = new list < dataOrder > ();
        DataRollingList = new list < DataRolling > ();
        DataRollingArchList = new list< DataRollingArch >();
        //Checking the device
        string themeName = UserInfo.getUiTheme();
        String userAgent = System.currentPageReference().getHeaders().get('User-Agent');
        if (themeName == 'Theme4t') {
        	if(userAgent!=null){
            if(userAgent.contains('iPad'))
            {
                chartHeight = 260;
                chartWeight = 530;
                fname = 'only Non-Architects';
                sname = 'Architects and Non-Architects';
                legendName = 'right';
                mobileCheck = false;
            }
            else
            {
                chartHeight = 260;
                chartWeight = 340;
                fname = 'only Non-Arch';
                sname = 'Arch and Non-Arch';
                legendName = 'bottom';
                mobileCheck = true;
            }
        	}
        	} else {
            chartHeight = 260;
            chartWeight = 530;
            fname = 'only Non-Architects';
            sname = 'Architects and Non-Architects';
            legendName = 'right';
            mobileCheck = false;
        }


        //Performance DashBoard
        ytdsalesgoal = '';
        ytdsalesactual = '';
        fullyearsale = '';
        annualgoalsmet = 0;
        ytdgoalmet = 0;
        yearsalesgoal = '';
        ytdSallesActualDecim =0;
        salesyear = system.today().year();
        Set < ID > projIdSet = new Set < ID > ();
        projIdSet = SuccessRatioDynamicHelperClass.projectFetching();
        integer year = system.today().year();
        integer lastYearVal = year-1;
        //Success Ratio Yearly Calaculation on Page Load

        for (AggregateResult ar: [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >=: lastYearVal AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC]) {

            mtotal.put(string.valueof(ar.get('yeardate')), Integer.Valueof(ar.get('commission')));
        }

        Map < string, decimal > maplist = new map < string, decimal > ();
        Map < string, decimal > yearsuccessmap = new map < string, decimal > ();
        Map < string, decimal > yearSuccessVolumeMap = new map < string, decimal > ();

        for (AggregateResult p: [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c in: projIdSet AND Split__c>0 AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >=: lastYearVal AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC]) {

            if (p.get('year') != null && mtotal.containsKey(string.ValueOf(p.get('year')))) {
                integer x = mtotal.get(string.ValueOf(p.get('year')));
                decimal r = decimal.valueof(x);
                system.debug('The x year values are:::::::' + x);
                object y = p.get('amount');
                integer a = integer.valueof(y);
                a=a*100;
                decimal s = decimal.valueof(a);
                system.debug('The a year values are:::::::' + a);

                if (r != NULL && r != 0 && s != NULL && s != 0) {
                    z = (r / s) * 100;
                    rounded = z.setScale(2, RoundingMode.HALF_UP);
                } else
                    rounded = 0;
                System.debug('suceesss' + z);
                if (z != null && z != 0) {
                    yearsuccessmap.put(string.valueof(p.get('year')), rounded);
                    sratioyearprev = rounded;
                }

                yaxis = 'Year';
                titlename = 'By Year';
                columnname = 'Yearly Success Ratio';
                string ss = string.valueof(p.get('year'));
                system.debug('the maplist is:::::::::::' + yearsuccessmap);
                string nm = 'CY ' + ss;
            }

        }


        
        string yearnamevalue = string.valueof(year);
        System.debug('stringyearname' + yearnamevalue);
        decimal sratio = yearsuccessmap.get(yearnamevalue);
        System.debug('successartiovalue' + sratio);
        wrappertableyearmetricsList.add(new wrappertableyearmetrics(yearnamevalue, sratio));


        //By Volume
        for (AggregateResult ar: [select COUNT(id) cid, CALENDAR_YEAR(order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >=: lastYearVal AND Split__c > 0 AND Order_Number__c > 1 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC]) {

            mtotalVolume.put(string.valueof(ar.get('yeardate')), Integer.Valueof(ar.get('cid')));
        }

        for (AggregateResult p: [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE ID in: projIdSet AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: lastYearVal AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC]) {

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

                if (rd != NULL) {
                    yearSuccessVolumeMap.put(string.valueof(p.get('year')), rd);
                    sratiovolumeyearprev = rd;
                }
                yaxis = 'Year';
                titlename = 'By Year';
                columnnamevolume = 'Yearly Success Ratio';
                string ss = string.valueof(p.get('year'));
                system.debug('the rdlistis:::::::::::' + rd);
                string nm = 'CY ' + ss;

            }
        }

        //Adding Success ratio Values 
        integer yearVolume = system.today().year();
        string yearnamevalueVolume = string.valueof(yearVolume);
        decimal sratioVolume = yearSuccessVolumeMap.get(yearnamevalueVolume);
        sratioVolumeyear = sratioVolume;
        wrappertablevolumeyearmetricsList.add(new wrappertablevolumeyearmetrics(yearnamevalueVolume, sratioVolume));

        //KPI Dashboard Access for Community Regional and Admins Logic is written here
        adminCheck = false;
        regionUser = false;
        string custName;
        userid = userinfo.getuserid();
        system.debug('iddd' + userid);
        u = [select id, name, profile.name from user where id =: userid];
        list < KPIFullAccess__c > kfList = KPIFullAccess__c.getall().values();
        for (KPIFullAccess__c kf: kfList) {
            if (kf.name == u.name) {
                adminCheck = true;
            }
        }

        if (adminCheck == false) {
            list < TerritoryNames__c > tnlist = TerritoryNames__c.getall().values();
            for (TerritoryNames__c tn: tnlist) {
                if (tn.Regional_Manager__c == u.name) {
                    custName = tn.Name;
                    regionUser = true;
                }
            }

            if (regionUser == true) {
                regionname = custName;
                system.debug('regionname' + regionname);
                ChangeReport();
            } else {
                
                list < EasternSalesReps__c > eslist = EasternSalesReps__c.getall().values();
                eslist.sort();
                for (EasternSalesReps__c es: eslist) {

                    if (es.name == u.name) {
                        communityuser = true;
                        regionname = 'Eastern Sales';
                        ChangeReport();
                        salesrepname = es.name;
                        ChangeReport();
                    }
                }

                list < MidEasternSalesReps__c > mslist = MidEasternSalesReps__c.getall().values();
                mslist.sort();
                for (MidEasternSalesReps__c ms: mslist) {

                    if (ms.name == u.name) {
                        communityuser = true;
                        regionname = 'Mid Eastern Sales';
                        ChangeReport();
                        salesrepname = ms.name;
                        ChangeReport();
                    }
                }

                list < MidWestSalesReps__c > mwslist = MidWestSalesReps__c.getall().values();
                mwslist.sort();
                for (MidWestSalesReps__c mws: mwslist) {

                    if (mws.name == u.name) {
                        communityuser = true;
                        regionname = 'Midwest Sales';
                        ChangeReport();
                        salesrepname = mws.name;
                        ChangeReport();
                    }
                }

                list < WesternSalesReps__c > wslist = WesternSalesReps__c.getall().values();
                wslist.sort();
                for (WesternSalesReps__c ws: wslist) {

                    if (ws.name == u.name) {
                        communityuser = true;
                        regionname = 'Western Sales';
                        ChangeReport();
                        salesrepname = ws.name;
                        ChangeReport();
                    }
                }
                if(communityuser==false)
                NoAccessUser =true;
            }
        }
    }

    /**********************************************************************
    Apex Method: getRegionlist
    Description: This method is used to fetch regions from the custom settings
    Created Date: 10th August,2016            
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
        Apex Method: redirectHome
        Description: This method is used to redirect to home page
        Created Date: 10thAugust,2016            
        ***********************************************************************/
    public PageReference redirectHome() {

        string urlHome = label.OrgUrl;
        if (u.profile.Name == 'NanaRepPartnerProfile2' || u.profile.Name == 'NanaRepPartnerProfile') {
            urlHome = label.RepLabel;
        } else {
            urlHome = urlHome;
        }
        PageReference pg = new PageReference(urlHome + '/home/home.jsp');
        pg.setredirect(true);
        return pg;
    }

    /**********************************************************************
    Apex Method: ChangeReport
    Description: This method is used to calculate the dashboard values
    Created Date: 10thAugust,2016            
    ***********************************************************************/ 
    public PageReference ChangeReport() {

        //Select Sales reps
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

        transient list < AggregateResult > arlist = new list < AggregateResult > ();
        transient list < AggregateResult > prlist = new list < AggregateResult > ();
        transient list < AggregateResult > arvolumelist = new list < AggregateResult > ();
        transient list < AggregateResult > prvolumelist = new list < AggregateResult > ();
        //Site Vist Count Variables
        list < Opportunity > siteVisitCountList = new list < Opportunity > ();
        list < Project__c > siteVisitList = new list < Project__c > ();
        /* Trends Dashboard code*/
        //Local Variables
        list < AggregateResult > quoteList = new list < AggregateResult > ();
        list < AggregateResult > orderList = new list < AggregateResult > ();
        list < AggregateResult > projectList = new list < AggregateResult > ();
        list < AggregateResult > projectListWithArch = new list < AggregateResult > ();
        list < AggregateResult > ProjectListOnlyArch = new list < AggregateResult > ();
        integer yearval = system.today().year();
        integer startyearval = yearval - 2;
        firstYearString = 'CY ' + startyearval;
        secondYearString = 'CY ' + (startyearval + 1);
        thirdYearString = 'CY ' + yearval;
        system.debug('listtttttttttttt' + datalist);
        system.debug('namesalessssss' + salesrepname);
        if (datalist.size() > 0)
            datalist.clear();
        system.debug('namesalessssss' + salesrepname);
        if (dataOrderlist.size() > 0)
            dataOrderlist.clear();
        if (DataRollingList.size() > 0)
            DataRollingList.clear();

        System.debug('Salesrepp' + salesrepname);
        System.debug('Salesreppprev' + salesrepnameprev);
        if (salesrepnameprev == salesrepname) {
            salesrepcheck = FALSE;
            salesrepname = '--None--';
        }
        
        integer TotalProjectsofSalesRep=0;
        Set < ID > projIdSet = new Set < ID > ();
        projIdSet = SuccessRatioDynamicHelperClass.projectFetching();
        set<Id> newArchSet = SuccessRatioDynamicHelperClass.projectArchSet;
        System.debug('newListtTestt'+newArchSet ); 
        System.debug('finalfetchset' + projIdSet);
        System.debug('regionnameeee' + regionname);
        System.debug('salesrepnamlastttt' + '' + salesrepname);
        integer thisyearValNum = system.today().year();
        integer lastYearVal = thisyearValNum-1;
        // System.debug('proowner' + [select id, name, owner.name from project__c]+'testt'+''+salesrepname);
        if (regionname != NULL && regionname != '--None--') {
            if (salesrepname != NULL && salesrepname != '--None--') {
                salesrepcheck = TRUE;
                if (Test.isRunningTest()) {
                    arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >=: lastYearVal AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                    prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c in: projIdSet AND Split__c>0 AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >=: lastYearVal AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC];

                    arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE CALENDAR_YEAR(Order_Finalized_Date__c) >=: lastYearVal AND Order_Number__c > 1 AND Order_Number__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                    prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE ID in: projIdSet AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: lastYearVal AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC];

                    //siteVisitCountList = [select id, Site_Visit_Paid__c, StageName from Opportunity];

//                    siteVisitList = [select id, Site_Visit_Paid__c, StageName from Opportunity WHERE Site_Visit_Paid__c = TRUE AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') ORDER BY CreatedDate ASC];

                    quoteList = [select count(id) qid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Quote__c where CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];

                    orderList = [select count(id) qid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Quote__c where CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval AND Order_Number__c > 1 GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];

                    projectList = [select count(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Project__c where (NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
              
                    projectListWithArch = [select count(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Project__c where ID in: projIdSet AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
              
                    ProjectListOnlyArch = [select count(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Project__c where (NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
               
                } else {
                    
                    SuccessRatioDynamicHelperClass.projectFetchingForTrends(salesrepname, projIdSet);
                    set< ID > newProjIdSiteSet = new set< ID >();
                    
                    newProjIdSiteSet = SuccessRatioDynamicHelperClass.SiteVisitCalculateHelper();
                    System.debug('testLast'+newProjIdSiteSet);
                    set< ID > newProjArchIdSet = SuccessRatioDynamicHelperClass.projectIdArchSet;
                    System.debug('new'+newProjArchIdSet );
                    set< ID > newProjOnlyArchIdSet = SuccessRatioDynamicHelperClass.projectIdOnlyArchSet;
                    System.debug('newListtt'+newProjOnlyArchIdSet );
                    
                
                    arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >=: lastYearVal AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                    prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c in: projIdSet AND Project_Rep__r.Name =: salesrepname AND Split__c>0 AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >=: lastYearVal AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC];

                    arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) >=: lastYearVal AND Order_Number__c > 1 AND Order_Number__c > 0 AND Split__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                    prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE ID in: projIdSet AND owner.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: lastYearVal AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC];

                  //  siteVisitCountList = [select id, Site_Visit_Paid__c, StageName from Opportunity WHERE owner.name =: salesrepname AND Quote_Count__c>0 AND Budget_Quote__c= FALSE AND CALENDAR_YEAR(convertTimezone(CreatedDate)) =: yearval AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') ORDER BY CreatedDate ASC];

                    siteVisitList = [select id, Stage__c, Amount__c from Project__c WHERE id IN: newProjIdSiteSet AND owner.name =: salesrepname AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') ORDER BY CreatedDate ASC];

                    quoteList = [select count(id) qid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Quote__c where Opportunity__r.RecordType.Name!= 'Influencer Opportunity' AND Project__r.Owner.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];

                    orderList = [select count(id) qid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Quote__c where Opportunity__r.RecordType.Name!= 'Influencer Opportunity' AND Project__r.Owner.name =: salesrepname AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval AND Order_Number__c > 1 GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];

                    projectList = [select count(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Project__c where ID in: newProjOnlyArchIdSet AND Owner.name =: salesrepname AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
              
                    projectListWithArch = [select count(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Project__c where ID in: newArchSet AND Owner.name =: salesrepname AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
              
                    ProjectListOnlyArch = [select count(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year, CALENDAR_MONTH(convertTimezone(CreatedDate)) month from Project__c where ID in: newProjArchIdSet AND Owner.name =: salesrepname AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: startyearval GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)), CALENDAR_MONTH(convertTimezone(CreatedDate)) ASC];
                }
            } else {
        
                regioncheck = TRUE;
                set < string > ownerNameset = new set < string > ();
                ownerNameset = FetchingSalesRepsfromTerritories.getsalesreps(regionname);
                System.debug('ownernamesssssssss' + ownerNameset);
                if (ownerNameset.size() > 0) {
                    arlist = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >=: lastYearVal AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];
                    system.debug('@@@@@arlist' + arlist);
                    prlist = [select SUM(Amount__c) amount, CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) year from Project_Split__c WHERE Project__c in: projIdSet AND Project_Rep__r.Name IN: ownerNameset AND Split__c>0 AND CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) >=: lastYearVal AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(project__r.CreatedDate)) ASC];
                    system.debug('@@@@@prlist' + prlist);
                    arvolumelist = [select COUNT(id) cid, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate, COUNT_DISTINCT(Project__c) pname from Total_Order_Report_Data_Point__c WHERE Split_Rep__c IN: ownerNameset AND CALENDAR_YEAR(Order_Finalized_Date__c) >=: lastYearVal AND Order_Number__c > 1 AND Order_Number__c > 0 AND Split__c > 0 AND(NOT Project__r.Name LIKE '%Test%') AND(NOT Project__r.Name LIKE '%TEST%') AND(NOT Project__r.Name LIKE '%test%') GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];
                    system.debug('@@@@@arvolumelist' + arvolumelist);
                    prvolumelist = [select COUNT(id) pid, CALENDAR_YEAR(convertTimezone(CreatedDate)) year from Project__c WHERE ID in: projIdSet AND owner.name IN: ownerNameset AND CALENDAR_YEAR(convertTimezone(CreatedDate)) >=: lastYearVal AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%') GROUP BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ORDER BY CALENDAR_YEAR(convertTimezone(CreatedDate)) ASC];
                    system.debug('@@@@@prvolumelist' + prvolumelist);
                }
            }
        }

        salesrepnameprev = salesrepname;

        if (arlist.size() > 0) {
            for (AggregateResult ar: arlist) {

                mtotal.put(string.valueof(ar.get('yeardate')), Integer.Valueof(ar.get('commission')));
            }
        }
        Map < string, decimal > maplist = new map < string, decimal > ();
        Map < string, decimal > yearsuccessmap = new map < string, decimal > ();
        Map < string, decimal > yearSuccessVolumeMap = new map < string, decimal > ();

        if (prlist.size() > 0) {
            for (AggregateResult p: prlist) {

                if (p.get('year') != null && mtotal.containsKey(string.ValueOf(p.get('year')))) {
                    integer x = mtotal.get(string.ValueOf(p.get('year')));                    
                    decimal r = decimal.valueof(x);
                    system.debug('The x year values are:::::::' + x);
                    object y = p.get('amount');
                    integer a = integer.valueof(y);
                    a=a*100;
                    decimal s = decimal.valueof(a);
                    system.debug('The a year values are:::::::' + a);
                    if (r != 0 && r != NULL && s != NULL && s != 0) {
                        z = (r / s) * 100;
                        rounded = z.setScale(2, RoundingMode.HALF_UP);
                    } else
                        rounded = 0;
                    System.debug('suceesss' + z);
                    if (z != null && z != 0) {
                        yearsuccessmap.put(string.valueof(p.get('year')), rounded);
                    }

                    yaxis = 'Year';
                    titlename = 'By Year';
                    columnname = 'Yearly Success Ratio';

                    string ss = string.valueof(p.get('year'));
                    system.debug('the maplist is:::::::::::' + mapList);
                    string nm = 'CY ' + ss;

                }
            }

            if (regioncheck == TRUE) {
                wrappertableregionmetricsList.clear();
                integer year = system.today().year();
                string yearnamevalue = string.valueof(year);
                System.debug('stringyearnameregionwithoutvolume' + yearnamevalue);
                decimal sratio = yearsuccessmap.get(yearnamevalue);
                sratioregion = sratio;
                wrappertableregionmetricsList.add(new wrappertableregionmetrics(yearnamevalue, sratio));
                //regioncheck = FALSE;

            }
            if (salesrepcheck == TRUE) {
                wrappertablemetriclist.clear();
                integer year = system.today().year();
                string yearnamevalue = string.valueof(year);
                System.debug('stringyearnamessss' + yearnamevalue);
                decimal sratio = yearsuccessmap.get(yearnamevalue);
                System.debug('successartiovaluessss' + sratio);
                integer prevyear = year - 1;
                string prevyearnamevalue = string.valueof(prevyear);
                System.debug('stringpreviousnamessssss' + prevyearnamevalue);
                decimal prevsratio = yearsuccessmap.get(prevyearnamevalue);
                System.debug('previoussuccessartiovaluesss' + prevsratio);
                System.debug('Sratioregionlastsaved' + sratioregion);
                if (sratioregion > sratio) {
                    metricregioncheck = FALSE;
                    metricregioncheckEqual = FALSE;
                    metricregioncheckdown = TRUE;
                } else if (sratioregion == sratio) {
                    metricregioncheckEqual = TRUE;
                    metricregioncheck = FALSE;
                    metricregioncheckdown = FALSE;
                } else if (sratioregion < sratio) {
                    metricregioncheckdown = FALSE;
                    metricregioncheckEqual = FALSE;
                    metricregioncheck = TRUE;
                }
                if (sratio > prevsratio) {
                    metriccheck = TRUE;
                    metriccheckEqual = FALSE;
                    metriccheckdown = FALSE;
                } else if (sratio == prevsratio) {
                    metriccheckEqual = TRUE;
                    metriccheck = FALSE;
                    metriccheckdown = FALSE;
                } else if (sratio < prevsratio) {
                    metriccheck = FALSE;
                    metriccheckdown = TRUE;
                    metriccheckEqual = FALSE;
                }
                if (sratioyearprev > sratio) {
                    metricyearcheck = FALSE;
                    metricyearcheckEqual = FALSE;
                    metricyearcheckdown = TRUE;
                } else if (sratioyearprev == sratio) {
                    metricyearcheck = FALSE;
                    metricyearcheckEqual = TRUE;
                    metricyearcheckdown = FALSE;
                } else if (sratioyearprev < sratio) {
                    metricyearcheck = TRUE;
                    metricyearcheckEqual = FALSE;
                    metricyearcheckdown = FALSE;
                }
                wrappertablemetriclist.add(new wrappertablemetrics(yearnamevalue, prevyearnamevalue, prevsratio, sratio));
                System.debug('Wrappermetric' + wrappertablemetriclist);
                //salesrepcheck = FALSE;
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
                    integer yearthis = system.today().year();
                    if(p.get('year')==yearthis)
                    {
                    TotalProjectsofSalesRep = ipvol;
                    }
                    decimal dpvol = decimal.valueof(ipvol);
                    decimal rd;
                    if (decvol != 0 && decvol != NULL && dpvol != NULL && dpvol != 0) {
                        decimal op = (decvol / dpvol) * 100;
                        rd = op.setScale(2, RoundingMode.HALF_UP);
                    } else
                        rd = 0;
                    if (rd != NULL) {
                        yearSuccessVolumeMap.put(string.valueof(p.get('year')), rd);
                    }
                    yaxis = 'Year';
                    titlename = 'By Year';
                    columnnamevolume = 'Yearly Success Ratio';
                    string ss = string.valueof(p.get('year'));
                    system.debug('the rdis:::::::::::' + rd);
                    string nm = 'CY ' + ss;

                }
            }

            if (regioncheck == TRUE) {
                wrappertablevolumeregionmetricsList.clear();
                integer year = system.today().year();
                string yearnamevalue = string.valueof(year);
                System.debug('stringyearnameregion' + yearnamevalue);
                decimal sratio = yearSuccessVolumeMap.get(yearnamevalue);
                sratiovolumeregion = sratio;
                wrappertablevolumeregionmetricsList.add(new wrappertablevolumeregionmetrics(yearnamevalue, sratio));
                regioncheck = FALSE;
            }
            if (salesrepcheck == TRUE) {
                wrappertablevolumemetriclist.clear();
                integer year = system.today().year();
                string yearnamevalue = string.valueof(year);
                System.debug('stringyearname' + yearnamevalue);
                decimal sratio = yearSuccessVolumeMap.get(yearnamevalue);
                System.debug('successartiovalue' + sratio);
                integer prevyear = year - 1;
                string prevyearnamevalue = string.valueof(prevyear);
                System.debug('stringpreviousname' + prevyearnamevalue);
                decimal prevsratio = yearSuccessVolumeMap.get(prevyearnamevalue);
                System.debug('previoussuccessartiovalue' + prevsratio);
                if (sratiovolumeregion > sratio) {
                    metricregionvolumecheck = FALSE;
                    metricregionvolumecheckdown = TRUE;
                    metricregionvolumecheckEqual = FALSE;
                } else if (sratiovolumeregion == sratio) {
                    metricregionvolumecheck = FALSE;
                    metricregionvolumecheckEqual = TRUE;
                    metricregionvolumecheckdown = FALSE;
                } else if (sratiovolumeregion < sratio) {
                    metricregionvolumecheck = TRUE;
                    metricregionvolumecheckEqual = FALSE;
                    metricregionvolumecheckdown = FALSE;
                }
                if (sratio > prevsratio) {
                    metricvolumecheck = TRUE;
                    metricvolumecheckdown = FALSE;
                    metricvolumecheckEqual = FALSE;
                } else if (sratio == prevsratio) {
                    metricvolumecheckEqual = TRUE;
                    metricvolumecheckdown = FALSE;
                    metricvolumecheck = FALSE;
                } else if (sratio < prevsratio) {
                    metricvolumecheck = FALSE;
                    metricvolumecheckdown = TRUE;
                    metricvolumecheckEqual = FALSE;
                }
                if (sratiovolumeyearprev > sratio) {
                    metricvolumeyearcheck = FALSE;
                    metricvolumeyearcheckEqual = FALSE;
                    metricvolumeyearcheckdown = TRUE;
                } else if (sratiovolumeyearprev == sratio) {
                    metricvolumeyearcheck = FALSE;
                    metricvolumeyearcheckEqual = TRUE;
                    metricvolumeyearcheckdown = FALSE;
                } else if (sratiovolumeyearprev < sratio) {
                    metricvolumeyearcheck = TRUE;
                    metricvolumeyearcheckEqual = FALSE;
                    metricvolumeyearcheckdown = FALSE;
                }
                wrappertablevolumemetriclist.add(new wrappertablevolumemetrics(yearnamevalue, prevyearnamevalue, prevsratio, sratio));
                System.debug('Wrappermetric' + wrappertablemetriclist);
                //salesrepcheck = FALSE;
            }

        }

        /* The logic below is used for calculating site visits for salesreps and the success ratio of 
           the site visits.
        */
        wrappertablesitevisitList.clear();
        integer siteVisitCount = 0;
        integer siteSuccessCount = 0;
        integer totalOpportunityCount = 0;
        decimal siteSuccessRatio = 0;
        decimal siteUsedRatio = 0;
        if (siteVisitList.size() > 0) {
            /*for (Opportunity opp: siteVisitCountList) {

                totalOpportunityCount = totalOpportunityCount + 1;
            }*/
            
            totalOpportunityCount = TotalProjectsofSalesRep;
            System.debug('Total Oppps' + totalOpportunityCount);
            for (Project__c pro: siteVisitList) {
                if (pro.Stage__c == 'Closed Won - Order Signed' || pro.Stage__c=='Closed Won - Order In Process' || pro.Stage__c=='Closed Complete - Ordered - Paid') {
                    siteSuccessCount = siteSuccessCount + 1;
                }
                siteVisitCount = siteVisitCount + 1;
            }
            System.debug('Used Sites' + siteVisitCount);
            System.debug('Success Sitess' + siteSuccessCount);
            decimal siteSuccessCountDecimal;
            decimal siteVisitCountDecimal;
            decimal totalOpportunityCountDecimal;
            if (siteVisitCount != NULL && siteVisitCount != 0) {
                if (siteSuccessCount != NULL && siteSuccessCount != 0) {
                    siteSuccessCountDecimal = decimal.valueof(siteSuccessCount);
                } else {
                    siteSuccessCount = 0;
                    siteSuccessCountDecimal = 0;
                }
                siteVisitCountDecimal = decimal.valueof(siteVisitCount);
                System.debug('Success ratiooo' + siteSuccessCountDecimal + 'visss' + siteVisitCountDecimal);
                siteSuccessRatio = (siteSuccessCountDecimal / siteVisitCountDecimal) * 100;
                siteSuccessRatio = siteSuccessRatio.setScale(2, RoundingMode.HALF_UP);
                System.debug('Success ratiooo final ' + siteSuccessRatio);
            } else {
                siteSuccessRatio = 0;
                siteVisitCount = 0;
                //siteSuccessCount = 0;
                siteVisitCountDecimal = 0;
            }

            if (totalOpportunityCount != NULL && totalOpportunityCount != 0) {
                totalOpportunityCountDecimal = decimal.valueof(totalOpportunityCount);
                siteUsedRatio = (siteVisitCountDecimal / totalOpportunityCountDecimal) * 100;
                siteUsedRatio = siteUsedRatio.setScale(2, RoundingMode.HALF_UP);
            } else {
                siteUsedRatio = 0;
                totalOpportunityCount = 0;
            }

            if (siteUsedRatio >= 20) {
                usedCheck = TRUE;
            } else {
                usedCheck = FALSE;
            }
            if (siteSuccessRatio > sratioVolumeyear) {
                successCheck = TRUE;
            } else {
                successCheck = FALSE;
            }
            System.debug('Success ratiooo Wrapper ' + siteSuccessRatio);
            wrappertablesitevisitList.add(new wrappertablesitevisit(siteVisitCount, siteSuccessCount, totalOpportunityCount, siteSuccessRatio, siteUsedRatio));
            System.debug('Wrapper ' + wrappertablesitevisitList);
        }
        else
        {
            usedCheck = FALSE;
            successCheck = FALSE;
            totalOpportunityCount = TotalProjectsofSalesRep;
            wrappertablesitevisitList.add(new wrappertablesitevisit(0, 0, totalOpportunityCount, 0, 0));
        }


        //If the Quotelist is not empty
        if (quoteList.size() > 0) {
            datalist.clear();
            map < string, integer > monthCountMap = new map < string, integer > ();
            for (AggregateResult ar: quoteList) {
                string monthName = (Integer.valueof(ar.get('month'))) + ' ' + (string.valueof(ar.get('year')));
                monthCountMap.put(monthName, Integer.valueof(ar.get('qid')));
            }

            for (integer j = 1; j <= 12; j++) {
                //Local Variables
                integer firstYearVal;
                integer secondYearVal;
                integer thirdYearVal;
                string monthName;
                //Helper Class to calculate the trends
                list < string > outputList = TrendDashBoardHelperClass.calculateTrends(j, startyearval, monthCountMap);

                monthName = outputList[0];
                firstYearVal = Integer.valueOf(outputList[1]);
                secondYearVal = Integer.valueOf(outputList[2]);
                thirdYearVal = Integer.valueOf(outputList[3]);

                if (firstYearVal != NULL && secondYearVal != NULL && thirdYearVal != NULL) {
                    //Adding to wrapper class
                    datalist.add(new data(monthName, firstYearVal, secondYearVal, thirdYearVal));
                }

                System.debug('chartdataa' + datalist);

            }
        }

        if (orderList.size() > 0) {
            dataOrderlist.clear();
            map < string, integer > monthCountMap = new map < string, integer > ();
            for (AggregateResult ar: orderList) {
                string monthName = (Integer.valueof(ar.get('month'))) + ' ' + (string.valueof(ar.get('year')));
                monthCountMap.put(monthName, Integer.valueof(ar.get('qid')));
            }

            for (integer j = 1; j <= 12; j++) {
                //Local Variables
                integer firstYearVal;
                integer secondYearVal;
                integer thirdYearVal;
                string monthName;
                //Helper Class to calculate the trends
                list < string > outputList = TrendDashBoardHelperClass.calculateTrends(j, startyearval, monthCountMap);

                monthName = outputList[0];
                firstYearVal = Integer.valueOf(outputList[1]);
                secondYearVal = Integer.valueOf(outputList[2]);
                thirdYearVal = Integer.valueOf(outputList[3]);

                if (firstYearVal != NULL && secondYearVal != NULL && thirdYearVal != NULL) {
                    //Adding to wrapper class
                    dataOrderlist.add(new dataOrder(monthName, firstYearVal, secondYearVal, thirdYearVal));
                }

                System.debug('chartdataa' + dataOrderlist);

            }
        }
        list < integer > countArchitectList = new list < integer > ();
        map < string, integer > monthCountArchMap = new map < string, integer > ();
        //For Project Count only Architects
        if (projectList.size() > 0) {
            DataRollingList.clear();
            integer rollingYear = (System.today().year()-2);
            for(integer i=0; i<3; i++)
            {               
                for(integer j =1; j<13; j++)
                {
                    string mnthName = TrendDashBoardHelperClass.monthNameCalculation(j);
                    string monthName = mnthName + ' ' + (string.valueof(rollingYear));
                    monthCountArchMap.put(monthName, 0);
                }
                rollingYear++;
            }
            countArchitectList.clear();
            
            list < string > monthNameList = new list < string > ();
            for (AggregateResult ar: projectList) {
                integer startyearrolling = Integer.valueof(ar.get('year'));
                string mnthName = TrendDashBoardHelperClass.monthNameCalculation(Integer.valueof(ar.get('month')));
                string monthName = mnthName + ' ' + (string.valueof(ar.get('year')));
                
                monthCountArchMap.put(monthName, Integer.valueof(ar.get('pid')));
                
            }
            countArchitectList.addAll(monthCountArchMap.values());
                monthNameList.addAll(monthCountArchMap.keyset());

            for (integer i = 1; i <= countArchitectList.size(); i++) {
                if (i < 12) {
                    DataRollingList.add(new DataRolling(monthNameList[i - 1], countArchitectList[i - 1], 0));
                } else if (i >= 12) {
                    integer rollingAmount = 0;
                    integer grt = i - 12;
                    system.debug('testss' + grt);
                    for (integer j = i; j > grt; j--) {
                        rollingAmount = rollingAmount + countArchitectList[j - 1];
                        System.debug('checker' + rollingAmount);
                    }
                    if (monthNameList[i - 1] != NULL && countArchitectList[i - 1] != NULL && rollingAmount != NULL)
                        DataRollingList.add(new DataRolling(monthNameList[i - 1], countArchitectList[i - 1], rollingAmount));
                    System.debug('chartRollingdataa' + rollingAmount);
                }

            }

        }
        
        //For Project Count with real Quotes
        if (projectListWithArch.size() > 0) {
            DataRollingArchList.clear();
            map < string, integer > monthCountMap = new map < string, integer > ();
            map < string, integer > monthCountonlyArchMap = new map < string, integer > ();
            list < integer > countList = new list < integer > ();
            list < string > monthNameList = new list < string > ();
            for (AggregateResult ar: projectListWithArch) {
                integer startyearrolling = Integer.valueof(ar.get('year'));
                string mnthName = TrendDashBoardHelperClass.monthNameCalculation(Integer.valueof(ar.get('month')));
                string monthName = mnthName + ' ' + (string.valueof(ar.get('year')));
                monthCountMap.put(monthName, Integer.valueof(ar.get('pid')));
                countList.add(Integer.valueof(ar.get('pid')));
                monthNameList.add(monthName);

            }
            System.debug('RealQuotes'+projectListWithArch);
            System.debug('ArchListonRealQuotes'+ProjectListOnlyArch);
            for(AggregateResult ar: ProjectListOnlyArch)
            {
                integer startyearrolling = Integer.valueof(ar.get('year'));
                string mnthName = TrendDashBoardHelperClass.monthNameCalculation(Integer.valueof(ar.get('month')));
                string monthName = mnthName + ' ' + (string.valueof(ar.get('year')));
                monthCountonlyArchMap.put(monthName, Integer.valueof(ar.get('pid')));               
            }
            

            for (integer i = 1; i <= countList.size(); i++) {
                if (i < 12) {
                    if(monthCountonlyArchMap.get(monthNameList[i - 1])!=NULL)
                    DataRollingArchList.add(new DataRollingArch(monthNameList[i - 1], countList[i - 1], 0, monthCountonlyArchMap.get(monthNameList[i - 1])));
                    else
                    DataRollingArchList.add(new DataRollingArch(monthNameList[i - 1], countList[i - 1], 0, 0));
                } else if (i >= 12) {
                    integer rollingAmount = 0;
                    integer grt = i - 12;
                    system.debug('testss' + grt);
                    for (integer j = i; j > grt; j--) {
                        rollingAmount = rollingAmount + countList[j - 1];
                        System.debug('checker' + rollingAmount);
                    }
                    if (monthNameList[i - 1] != NULL && countList[i - 1] != NULL && rollingAmount != NULL)
                    {
                        if(monthCountonlyArchMap.get(monthNameList[i - 1])!=NULL)
                        DataRollingArchList.add(new DataRollingArch(monthNameList[i - 1], countList[i - 1], rollingAmount, monthCountonlyArchMap.get(monthNameList[i - 1])));
                        else
                        DataRollingArchList.add(new DataRollingArch(monthNameList[i - 1], countList[i - 1], rollingAmount, 0));
                    }
                    
                        
                    System.debug('chartRollingdataa' + rollingAmount);
                }

            }

        }

        //Performance Dashboard

        //Local Variables 
        list < AggregateResult > arlist2 = new list < AggregateResult > ();
        list < Total_Order_Report_Data_Point__c > fullyearsalelist = new list < Total_Order_Report_Data_Point__c > ();
        list < user > userlist = new list < user > ();

        //Select Sales reps
        system.debug('@@@@@@@@@@@@@@@@region' + regionname);
        if (regionname != NULL && regionname != '--None--') {
            system.debug('@@@@@@@@@@@@@@@@Sales' + salesrepname);
            if (salesrepname != NULL && salesrepname != '--None--') {

                date dt = system.today();
                integer month = dt.month();
                integer day = dt.day();
                integer yearval2 = dt.year();
                salesyear = yearval2;
                integer prevyear = yearval2 - 1;
                //  integer day2 = day-1;
                date prevdate = date.newinstance(prevyear, month, day);

                arlist2 = [select SUM(Commission_Total__c) commission, CALENDAR_YEAR(Order_Finalized_Date__c) yeardate from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND CALENDAR_YEAR(Order_Finalized_Date__c) =: yearval2 AND Split__c > 0 AND Order_Number__c > 0 GROUP BY CALENDAR_YEAR(Order_Finalized_Date__c) ORDER BY CALENDAR_YEAR(Order_Finalized_Date__c) ASC];

                userlist = [select id, Sales_Goal__c from user where name =: salesrepname AND IsActive = TRUE AND profile.name != 'Gold Partner User'];

                fullyearsalelist = [select Commission_Total__c, Order_Finalized_Date__c from Total_Order_Report_Data_Point__c WHERE Split_Rep__c =: salesrepname AND Order_Finalized_Date__c >=: prevdate AND Order_Finalized_Date__c <=: dt AND Split__c > 0 AND Order_Number__c > 0 ORDER BY Order_Finalized_Date__c ASC];

            }
        }

        //Initializing variables to zero's
        yearsalesgoal = '';
        ytdsalesactual = '';
        fullyearsale = '';
        annualgoalsmet = 0;
        ytdgoalmet = 0;
        ytdsalesgoal = '';
        ytdSallesActualDecim=0;
        decimal fullYearSaledeci = 0;

        //The main calculation starts from here
        if (arlist2.size() > 0) {
            integer yearval2 = system.today().year();
            for (AggregateResult ar: arlist2) {
                if (ar.get('yeardate') == yearval2) {
                    object obj = ar.get('commission');
                     integer amt= integer.valueOf(obj);
                    ytdSallesActualDecim = decimal.valueOf(amt);
                    string frmCurr = amt.format();
                    ytdsalesactual = frmCurr;
                }
            }
        }
        decimal yearSalesInt = 0;
        if (userlist.size() > 0) {
            for (user u: userlist) {
                yearSalesInt = u.Sales_Goal__c;
                if(yearSalesInt!=NULL)
                {
                string CurrYear = yearSalesInt.format();
                yearsalesgoal = CurrYear;
                }
                else
                yearsalesgoal = NULL;
            }
        }
        //Calculating YTD Sales Goal
        if (yearsalesgoal != NULL) {
            date dt = system.today();
            integer thisYearVal = dt.year();
            date startDate = date.newInstance(thisYearVal, 01, 01);
            date endDate = date.newInstance(thisYearVal, 12, 31);
            Integer noOfDays = startDate.daysBetween(endDate);
            // noOfDays = noOfDays + 1;
            noOfDays = 365;
            decimal days = decimal.valueof(noOfDays);
            //decimal yearsales = decimal.valueof(yearsalesgoal);
            decimal ytd = yearSalesInt / days;
            integer ytdDays = startDate.daysBetween(dt);
            system.debug('how many days' + ytdDays);
            ytdDays = ytdDays + 1;
            decimal ytdSalesDeci = ytd * ytdDays;
            ytdSalesDeci = ytdSalesDeci.setScale(0, RoundingMode.HALF_UP);
            ytdsalesgoal = ytdSalesDeci.format();

            if (ytdSalesDeci != NULL && ytdSalesDeci != 0) {
                ytdgoalmet = ((1 - ((ytdSalesDeci - ytdSallesActualDecim) / ytdSalesDeci)) * 100);
                ytdgoalmet = ytdgoalmet.setScale(2, RoundingMode.HALF_UP);
            }

        }

        if (fullyearsalelist.size() > 0) {
            for (Total_Order_Report_Data_Point__c tr: fullyearsalelist) {
                fullYearSaledeci = fullYearSaledeci + tr.Commission_Total__c;
                fullyearsale = fullYearSaledeci.format();
            }
        }

        //Calculating Annual Goal
        if (yearSalesInt != NULL && yearSalesInt != 0 && ytdSallesActualDecim != NULL && ytdSallesActualDecim != 0 && fullYearSaledeci != NULL && fullYearSaledeci != 0) {
            decimal annualgoal = 0;
            annualgoal = ((1 - ((yearSalesInt - ytdSallesActualDecim) / yearSalesInt)) * 100);
            decimal rounded = annualgoal.setScale(2, RoundingMode.HALF_UP);
            annualgoalsmet = rounded;

        }

        //Funnel Chat
        if (regionname != NULL && regionname != '--None--') {
            if (salesrepname != NULL && salesrepname != '--None--') {
                dataStagelist.clear();
                //  gChartData = '';
               Set<ID> projQuoteIdSet = new Set<ID>();
               projQuoteIdSet = SuccessRatioDynamicHelperClass.projectFetchingFromQuotes();
                map < string, decimal > projTypeAmountMap = new map < string, decimal > ();
                list < string > projectTypeList = new list < string > ();
                //projIdSet = SuccessRatioDynamicHelperClass.projectFetching();
                date thisDate = system.today();
                integer thisYear = thisDate.year();
                list < Project__c > projectStageList = [select id, stage__c, Amount__c from Project__c where ID in: projQuoteIdSet AND owner.name =: salesrepname
                    AND CALENDAR_YEAR(convertTimezone(CreatedDate)) =: thisYear AND(NOT Name LIKE '%Test%') AND(NOT Name LIKE '%TEST%') AND(NOT Name LIKE '%test%')
                ];
                list < ProjectStagesFunnelChart__c > pfList = ProjectStagesFunnelChart__c.getall().values();
                pfList.sort();
                
                for (integer k= (pfList.size()-1); k>=0; k--) {
                    projectTypeList.add(pfList[k].name);
                }
                for (string type: projectTypeList) {
                    projTypeAmountMap.put(type, 0);
                }
                for (Project__c pro: projectStageList) {
                    for (string type: projectTypeList) {
                        if (type == pro.stage__c) {
                            decimal ct = projTypeAmountMap.get(type);
                            if (pro.Amount__c != NULL) {
                                decimal finalAmount = ct + pro.Amount__c;
                                finalAmount = finalAmount.setScale(2, RoundingMode.HALF_UP);
                                projTypeAmountMap.put(type, finalAmount);
                            } else {
                                ct = ct.setScale(2, RoundingMode.HALF_UP);
                                projTypeAmountMap.put(type, ct);
                            }
                        }
                        //thirdYearString = type;
                    }
                }

                for (string str: projTypeAmountMap.keySet()) {

                    dataStagelist.add(new dataStage(str, projTypeAmountMap.get(str)));
                }

                System.debug('stagefunnel' + dataStagelist);
                // gChartData = JSON.serialize(dataStagelist);

            }
        }


        return null;
    }



    //Wrapper Table
    public class wrappertablemetrics {

        public String yearname {
            get;
            set;
        }
        public String PreviousYear {
            get;
            set;
        }
        public decimal previoussuccessratio {
            get;
            set;
        }
        public decimal successratio {
            get;
            set;
        }

        public wrappertablemetrics(String yearname, string prevname, decimal psratio, decimal sratio) {
            this.yearname = yearname;
            this.PreviousYear = prevname;
            this.previoussuccessratio = psratio;
            this.successratio = sratio;
        }

    }

    public class wrappertablevolumemetrics {

        public String yearname {
            get;
            set;
        }
        public String PreviousYear {
            get;
            set;
        }
        public decimal previoussuccessratio {
            get;
            set;
        }
        public decimal successratio {
            get;
            set;
        }

        public wrappertablevolumemetrics(String yearname, string prevname, decimal psratio, decimal sratio) {
            this.yearname = yearname;
            this.PreviousYear = prevname;
            this.previoussuccessratio = psratio;
            this.successratio = sratio;
        }

    }

    public class wrappertableregionmetrics {

        public String yearname {
            get;
            set;
        }

        public decimal successratio {
            get;
            set;
        }

        public wrappertableregionmetrics(String yearname, decimal sratio) {
            this.yearname = yearname;
            this.successratio = sratio;
        }

    }
    public class wrappertablevolumeregionmetrics {

        public String yearname {
            get;
            set;
        }

        public decimal successratio {
            get;
            set;
        }

        public wrappertablevolumeregionmetrics(String yearname, decimal sratio) {
            this.yearname = yearname;
            this.successratio = sratio;
        }

    }

    public class wrappertableyearmetrics {

        public String yearname {
            get;
            set;
        }

        public decimal successratio {
            get;
            set;
        }

        public wrappertableyearmetrics(String yearname, decimal sratio) {
            this.yearname = yearname;
            this.successratio = sratio;
        }

    }
    public class wrappertablevolumeyearmetrics {

        public String yearname {
            get;
            set;
        }

        public decimal successratio {
            get;
            set;
        }

        public wrappertablevolumeyearmetrics(String yearname, decimal sratio) {
            this.yearname = yearname;
            this.successratio = sratio;
        }

    }

    public class wrappertablesitevisit {

        public integer siteVisitCount {
            get;
            set;
        }
        public integer siteSuccessCount {
            get;
            set;
        }
        public integer totalOpportunityCount {
            get;
            set;
        }
        public decimal siteSuccessRatio {
            get;
            set;
        }
        public decimal siteUsedRatio {
            get;
            set;
        }

        public wrappertablesitevisit(integer siteVisitCount, integer siteSuccessCount, integer totalOpportunityCount, decimal siteSuccessRatio, decimal siteUsedRatio) {
            this.siteVisitCount = siteVisitCount;
            this.siteSuccessCount = siteSuccessCount;
            this.totalOpportunityCount = totalOpportunityCount;
            this.siteSuccessRatio = siteSuccessRatio;
            this.siteUsedRatio = siteUsedRatio;
        }
    }


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
        public integer compareTo(Object ObjToCompare) {


            return name.CompareTo(((Data) ObjToCompare).name);

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
    
    public class DataRollingArch {
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

        public DataRollingArch(String name, integer data1, integer data2, integer data3) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
        }
    }

    public class DataStage {
        public String name {
            get;
            set;
        }
        public decimal data1 {
            get;
            set;
        }

        public DataStage(String name, decimal data1) {
            this.name = name;
            this.data1 = data1;
        }
    }
}