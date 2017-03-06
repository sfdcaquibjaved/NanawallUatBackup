public with sharing class Rep_Commission_Report_Controller {
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

    public class CommissionLine 
    {
        public integer Index{ get; set; }
        public string ID{ get; set; }
        public string OppID{ get; set; }
        public string QuoteID{ get; set; }
        public string OrderNumber{ get; set; }
        public string QuoteNumber{ get; set; }
        
        public Date DepositDate { get; set; }
        public double DepositAmount { get; set; }
        public double DepositCommission { get; set; }
        public double ActualDepositCommission { get; set; }
        
        public Date BalanceDate { get; set; }
        public double BalanceCommission { get; set; }
        public double BalanceAmount { get; set; }
        public double ActualBalanceCommission { get; set; }

        public Date DrawingDepositDate { get; set; }
        public double DrawingDepositCommission { get; set; }
        public double ActualDrawingDepositCommission { get; set; }
        public double DrawingDepositAmount { get; set; }
        
        
    

        public boolean ProjectOnHold { get; set; }
        
        public boolean IsCancelled { get; set; }
        
        public boolean HasPriceAdjustment { get; set; }
        
        // ---
        public boolean ProjectIsSplit { get; set; }
        public string Credit1 { get; set; }
        public string Credit2 { get; set; }
        public string Territory { get; set; }
        public Date DateFinalized { get; set; }
        public Date InvoiceSentDate { get; set; }
        public string ProjectName { get; set; }
        public double QuoteSubtotal { get; set; }
        public double AverageDiscount { get; set; }
        public double Commission { get; set; }
        public double CommissionTotal { get; set; }
        public double CalculatedListPrice { get; set; }
        public double WeightedDiscount { get; set; }
        public double CommissionRate { get; set; }
        public integer PanelCount{ get; set; }
        public string UserName { get; set; }
        public string ContactName { get; set; }
        public string ShippingCity { get; set; }
        public string ShippingState { get; set; }
        public string ShippingZip { get; set; }
        public double SubtotalCommission { get; set; }
        public double BasePrice { get; set; }
        public double OveragePrice { get; set; }
        
        
        public double BaseReduction {get; set; }
        public double BaseCommission  {get; set; }
        public double OverageCommission  {get; set; }

        public double BaseCommPct  {get; set; }


        public double OverageCommissionFirst {get; set; }
        public double OverageCommissionSecond {get; set; }
        public double OverageCommissionThird {get; set; }
        
        public string OverageCommissionSummary { get; set; }
        public string BaseOrExcessSummary { get; set; }
        
        public double BaseOrExcessFirst {get; set; }
        public double BaseOrExcessSecond  {get; set; }
        public double BaseOrExcessThird  {get; set; }


        public Quote__c objQuote { get; set; }
        public Opportunity Project { get; set; }

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

    public PageReference refreshDataPoints() 
    {
    
        ret = null;
        getDataPoints();
        return null;
    }
    
    public double TotalCommissionToPay  
    {
        get
        {
            if( TotalCommissionToPay == null )
                TotalCommissionToPay = 0;
            return TotalCommissionToPay;
        }
        set;
    
    }
    
    public double DepositSum 
    {
        get
        {
            if( DepositSum == null )
                DepositSum = 0;
            return DepositSum;
        }
        set;
    }
    public double SubtotalSum 
    {
        get
        {
            if( SubtotalSum == null )
                SubtotalSum = 0;
            return SubtotalSum;
        }
        set;
    }
    public double BalanceSum 
    {
        get
        {
            if( BalanceSum == null )
                BalanceSum = 0;
            return BalanceSum;
        }
        set;
    }
    
    public double DrawingsSum
    {
        get
        {
            if( DrawingsSum == null )
                DrawingsSum = 0;
            return DrawingsSum;
        }
        set;
    }
    
    
    
    List<CommissionLine> ret = null;
    public list<CommissionLine> getDataPoints()
    {
    
    
        if( dummyopportunity.Nana_Create_Date__c == null
        ||  dummyopportunity.Nana_Edit_Date__c == null )
        {
            ret = new List<CommissionLine>();
            Apexpages.addMessage(new Apexpages.Message( Apexpages.Severity.Info, 'Please select a date range to filter on'));
        } else if( ret == null )
        {
            ret = new List<CommissionLine>();
            DepositSum = 0;
            BalanceSum = 0;
            DrawingsSum = 0;
            SubtotalSum = 0;
            TotalCommissionToPay = 0;
            integer rowcount = 1;

//Quote__c q = new Quote__c();


            DateTime d1 = (Date)dummyOpportunity.Nana_Create_Date__c;
            DateTime d2 = (Date)dummyopportunity.Nana_Edit_Date__c;
            d1 = d1.addDays(1);
            d2 = d2.addDays(1);

            string soql = 'SELECT Id,Order_Number__c,Deposit_Date__c,Deposit_Commission__c,Balance_Received_Date__c,Balance_Received_Commission2__c, ';
            soql += ' Project_Stage__c, Quote__c, Quote__r.Quote_Id__c,Quote__r.Id, Project_Is_Split__c, Credit__c, Credit1__c, ';
            soql += ' Territory__c,Invoice_Sent_Date__c, Opportunity__r.Name, Opportunity__r.Id, Quote_Subtotal__c, Average_Discount__c, Commission__c,  ';
            soql += ' Commission_Total__c, Calculated_List_Price__c, Weighted_Discount__c, User__r.FirstName, User__r.LastName, ';
            soql += ' Contact__r.FirstName, Contact__r.LastName, Shipping_City__c,Shipping_State__c, Subtotal_Commission__c, Date_Finalized__c, Commission_Rate__c, ';
            soql += ' Panelcount__c, Drawing_Deposit_Date__c, Drawing_Deposit_Commission__c, ';
            soql += '  Quote__r.Taha_Review__c, ';
            soql += ' Actual_Balance_Commission__c, Actual_Deposit_Commission__c, Actual_Drawing_Commission__c, Deposit_Amount__c, Balance_Amount__c, ';
            soql += ' Base_Reduction__c,  Base_Commission__c,  Overage_Commission__c, Base_Commission_Pct__c, Shipping_Zip__c, Drawing_Deposit_Amount__c, ';
            soql += ' Overage_Commission_First__c, Overage_Commission_Second__c, Overage_Commission_Third__c, BaseOrExcess_First__c, BaseOrExcess_Second__c , BaseOrExcess_Third__c,   ';
            soql += ' Out_WtdDisc_c__c, In_WtdDisc_c__c ';
            soql += ' FROM Report_Total_Order_Report_Data_Point__c ';
 
            soql += ' WHERE ';
            soql += '( ';
            soql += '   ( Balance_Received_Date__c >= '+d1.format('yyyy-MM-dd')+'   AND Balance_Received_Date__c <= '+d2.format('yyyy-MM-dd')+'  AND Balance_Amount__c > 0  ) ';
            soql += '   OR ( Deposit_Date__c >= '+d1.format('yyyy-MM-dd')+'  AND Deposit_Date__c <= '+d2.format('yyyy-MM-dd')+'  AND Deposit_Amount__c > 0 )   ';
//          soql += '   OR (Drawing_Deposit_Date__c >= '+d1.format('yyyy-MM-dd')+'  AND Drawing_Deposit_Date__c <= '+d2.format('yyyy-MM-dd')+'  AND Drawing_Deposit_Amount__c > 0 )   ';
            soql += ')    ';
System.debug('Using dates ' + dummyOpportunity.Nana_Create_Date__c+ ' until ' + dummyopportunity.Nana_Edit_Date__c + ' => ' + d1.format('yyyy-MM-dd') +' until ' + d2.format('yyyy-MM-dd') + '');
            
            
            if( dummyOpportunity.OwnerID != null )
            {
                if( dummyOpportunity.OwnerID == '005A0000000N1ljIAC' || dummyOpportunity.OwnerID == '005A0000000N1lj'
                || dummyopportunity.OwnerID == '005A0000000MOi1IAG' || dummyopportunity.OwnerID == '005A0000000MOi1'
                || dummyopportunity.OwnerID == '005A0000001CDfTIAW' || dummyopportunity.OwnerID == '005A0000001CDfT'
                || dummyopportunity.OwnerID == '005A0000000O0zyIAC' || dummyopportunity.OwnerID == '005A0000000O0zy'
                
                 
                ) { //need to group all the larry verniers together
                    soql += ' AND ( User__c = \'005A0000000N1ljIAC\' OR  User__c = \'005A0000000MOi1IAG\' OR  User__c = \'005A0000001CDfTIAW\' OR  User__c = \'005A0000000O0zyIAC\' )';                 
                } else
                {
                    soql += ' AND User__c = \''+dummyOpportunity.OwnerID+'\' ';
                }
            }
            
            soql += ' Order By ' + thisSorter.getColumn() + ' ' + thisSorter.getSortDirection() +' NULLS LAST ';
            soql += ' LIMIT 1000 ';

System.Debug('Rep Comm SOQL: ' + soql);         
            list<Report_Total_Order_Report_Data_Point__c> points = (list<Report_Total_Order_Report_Data_Point__c>)Database.query(soql );
            for( Report_Total_Order_Report_Data_Point__c totalOrderPoint : points )
            {
                CommissionLine line = new CommissionLine();
                line.OrderNumber = totalOrderPoint.Order_Number__c;
                line.QuoteNumber = string.valueof(totalOrderPoint.Quote__r.Quote_ID__c);
                line.QuoteID = string.valueof(totalOrderPoint.Quote__r.Id);
                line.Id = totalOrderPoint.Id;
                line.OppID = totalOrderPoint.Opportunity__r.Id;

                line.objQuote = totalOrderPoint.Quote__r;
                line.Project = totalOrderPoint.Opportunity__r;

                line.ProjectOnHold = (totalOrderPoint.Project_Stage__c == 'Project On Hold');
                
                boolean hasRelevantDate = false;
    
                /*
                From Yuriy: 
                if the Dep. Amount and Bal.Amount contains "0" or nothing, then this project shouldn't be showing in the report for this month.
                */          
                boolean hasDepositDate = false;
                boolean hasBalanceDate = false;
                boolean divideAsPartialAmounts = true;

                if( (totalOrderPoint.Deposit_Amount__c != null && totalOrderPoint.Deposit_Amount__c >= totalOrderPoint.Quote_Subtotal__c) 
                || (totalOrderPoint.Balance_Amount__c != null && totalOrderPoint.Balance_Amount__c >= totalOrderPoint.Quote_Subtotal__c) )
                    divideAsPartialAmounts = false;
                                
                if( (totalOrderPoint.Deposit_Date__c >= dummyopportunity.Nana_Create_Date__c 
                    && totalOrderPoint.Deposit_Date__c <= dummyopportunity.Nana_Edit_Date__c ))
                {
                    line.DepositAmount      = totalOrderPoint.Deposit_Amount__c;
                    line.DepositDate            = totalOrderPoint.Deposit_Date__c;
                    line.DepositCommission      = totalOrderPoint.Deposit_Commission__c;
                    line.ActualDepositCommission        = totalOrderPoint.Actual_Deposit_Commission__c;
                    
                    if (
                    line != null   
                    && line.DepositCommission != null
                    && line.DepositAmount != null
                    && line.QuoteSubtotal != null
                    && line.DepositAmount / line.QuoteSubtotal <= .35  )
                    {
                        line.DepositCommission = 0;
                    } else if(divideAsPartialAmounts )
                    {
                        line.DepositCommission /= 2;
                    }
                    
                    if( line != null && line.DepositCommission != null)
                        DepositSum += line.DepositCommission;
                    hasRelevantDate = true;
                    
                    if( !dummyOpportunity.NIS__c )
                        hasDepositDate = true; //only do the filter if its unchecked
                    else if( line.DepositAmount > 0 )
                        hasDepositDate = true;
                }
                
                if( (totalOrderPoint.Balance_Received_Date__c >= dummyopportunity.Nana_Create_Date__c 
                    && totalOrderPoint.Balance_Received_Date__c <= dummyopportunity.Nana_Edit_Date__c ))
                {
                    line.BalanceDate            = totalOrderPoint.Balance_Received_Date__c;
                    line.BalanceCommission      = totalOrderPoint.Balance_Received_Commission2__c;
                    line.BalanceAmount          = totalOrderPOint.Balance_Amount__c;
                    line.ActualBalanceCommission = totalOrderPoint.Actual_Balance_Commission__c;
                    
                    if(divideAsPartialAmounts && line.BalanceCommission != null)
                    {
                        line.BalanceCommission /= 2;
                    }
                    
                    if( line != null && line.BalanceCommission != null)
                    {
                        BalanceSum += line.BalanceCommission;
                    }
                    
                    hasRelevantDate = true;
                    
                    if( !dummyOpportunity.NIS__c )
                        hasDepositDate = true; //only do the filter if its unchecked
                    else if( line.BalanceAmount > 0 )
                        hasBalanceDate = true;
                }
                
                if( !hasBalanceDate && !hasDepositDate )
                    continue;
                
                if( (totalOrderPoint.Drawing_Deposit_Date__c >= dummyopportunity.Nana_Create_Date__c 
                    && totalOrderPoint.Drawing_Deposit_Date__c <= dummyopportunity.Nana_Edit_Date__c ))
                {
                    
                    /*
                    From Yuriy: 2. If the project has drawing deposit which less the 30% then the project should not be showing, 
                    but in case more then 30% then should be showing with exclamation sign. 
                    
                    */
                    if( totalOrderPoint.Quote_Subtotal__c > 0 
                    &&  (totalOrderPoint.Drawing_Deposit_Amount__c / totalOrderPoint.Quote_Subtotal__c) < .3 )
                    { //this was f'n up stuff
//                      continue;
                    }
                    
                    
                    line.DrawingDepositDate         = totalOrderPoint.Drawing_Deposit_Date__c;
                    line.DrawingDepositCommission       = totalOrderPoint.Drawing_Deposit_Commission__c;
                    line.ActualDrawingDepositCommission = totalOrderPoint.Actual_Drawing_Commission__c;
                    line.DrawingDepositAmount   = totalOrderPoint.Drawing_Deposit_Amount__c;
                    if( line != null && line.DrawingDepositCommission != null)
                        DrawingsSum += line.DrawingDepositCommission;
                    hasRelevantDate = true;
                    
                }
                
                //Drawing_Deposit_Date__c
                
                if(!hasRelevantDate 
                || totalOrderPoint.Commission__c == 0 ) continue;
                
                line.Index = rowcount++;
                
                
                line.ProjectIsSplit = totalOrderPoint.Project_Is_Split__c;
                line.Credit1 = totalOrderPoint.Credit__c;
                line.Credit2 = totalOrderPoint.Credit1__c;
                line.Territory = totalOrderPoint.Territory__c;
                line.DateFinalized = totalOrderPoint.Date_Finalized__c;
                line.InvoiceSentDate = totalOrderPoint.Invoice_Sent_Date__c;
                line.ProjectName = totalOrderPoint.Opportunity__r.Name;
                line.QuoteSubtotal = totalOrderPoint.Quote_Subtotal__c;
                line.AverageDiscount = totalOrderPoint.Average_Discount__c;
                line.Commission = totalOrderPoint.Commission__c;
                line.CommissionTotal = totalOrderPoint.Commission_Total__c;
                line.CalculatedListPrice = totalOrderPoint.Calculated_List_Price__c;
                try{
                    line.BasePrice = totalOrderPoint.Calculated_List_Price__c*.8;
                } catch (Exception ex )
                {
                    line.BasePrice = -1;
                }
                //ebrahim: The Overage should be the difference between the Subtotal and Base, not between List and Base
                //this was incorrect, the overage is the difference between list and sale based on reverse engineering the order
//              line.OveragePrice = ( totalOrderPoint.Weighted_Discount__c < 20 ?   totalOrderPoint.Calculated_List_Price__c-totalOrderPoint.Quote_Subtotal__c : 0 );]
                
                line.BaseReduction = totalOrderPoint.Base_Reduction__c;
                line.BaseCommission =  totalOrderPoint.Base_Commission__c;
                line.OverageCommission = totalOrderPoint.Overage_Commission__c;


                line.OverageCommissionFirst = totalOrderPoint.Overage_Commission_First__c;
                line.OverageCommissionSecond = totalOrderPoint.Overage_Commission_Second__c;
                line.OverageCommissionThird = totalOrderPoint.Overage_Commission_Third__c;
                
                line.BaseOrExcessFirst = totalOrderPoint.BaseOrExcess_First__c;
                line.BaseOrExcessSecond = (totalOrderPoint.BaseOrExcess_Second__c > 0 ? totalOrderPoint.BaseOrExcess_Second__c : 0);
                line.BaseOrExcessThird = (totalOrderPoint.BaseOrExcess_Third__c > 0 ? totalOrderPoint.BaseOrExcess_Third__c : 0);


                if( totalOrderPoint.Base_Commission_Pct__c != null )
                    line.BaseCommPct  = totalOrderPoint.Base_Commission_Pct__c*100;
//              line.WeightedDiscount = totalOrderPoint.Weighted_Discount__c;
                line.WeightedDiscount = totalOrderPoint.Out_WtdDisc_c__c;
                //
                line.CommissionRate = totalOrderPoint.Commission_Rate__c;
                line.PanelCount = integer.valueOf(totalOrderPoint.Panelcount__c);
                line.UserName = totalOrderPoint.User__r.FirstName+' '+ totalOrderPoint.User__r.LastName;
                line.ContactName = totalOrderPoint.Contact__r.FirstName + ' ' + totalOrderPoint.Contact__r.LastName;
                line.ShippingCity = totalOrderPoint.Shipping_City__c;
                line.ShippingState = totalOrderPoint.Shipping_State__c;
                line.ShippingZip = totalOrderPoint.Shipping_Zip__c;
                line.SubtotalCommission = totalOrderPoint.Subtotal_Commission__c;
                
                //ebrahim's request: Divide List, Base, Overage and Subtotal by two
                
                if(divideAsPartialAmounts)
                {
                    try {
                    line.CalculatedListPrice /= 2;
                    } catch( Exception ex )
                    {}
                }
                if( line.BaseCommission > 0 )
                {
                    line.BaseCommission *= (line.Commission / 100);
                    if(divideAsPartialAmounts)
                        line.BaseCommission /= 2;
                }   
                if( line.OverageCommission > 0 )
                {
                    line.OverageCommission *= (line.Commission / 100);
                    if(divideAsPartialAmounts)
                        line.OverageCommission /= 2;
                }
                if( line.OverageCommissionFirst > 0 )
                {
                    line.OverageCommissionFirst *= (line.Commission / 100);
                    if(divideAsPartialAmounts)
                        line.OverageCommissionFirst /= 2;
                }
                if( line.OverageCommissionSecond > 0 )
                {
                    line.OverageCommissionSecond *= (line.Commission / 100);
                    if(divideAsPartialAmounts)
                        line.OverageCommissionSecond /= 2;
                }
                if( line.OverageCommissionThird > 0 )
                {
                    line.OverageCommissionThird *= (line.Commission / 100);
                    if(divideAsPartialAmounts)
                        line.OverageCommissionThird /= 2;
                }
                if( line.BaseOrExcessFirst > 0 ) 
                {
                    if(divideAsPartialAmounts)
                        line.BaseOrExcessFirst /= 2;
                }
                if( line.BaseOrExcessSecond > 0 )
                {
                    if(divideAsPartialAmounts)
                        line.BaseOrExcessSecond /= 2;
                }
                if( line.BaseOrExcessThird > 0 )
                {
                    if(divideAsPartialAmounts)
                        line.BaseOrExcessThird /= 2;
                }
                

                List<String> args = new String[]{'0','number','###,###,###,###.00'};
                if( line.BaseOrExcessFirst != null )
                {
                    line.BaseOrExcessSummary = 'NB $' + String.format( Decimal.valueOf(line.BaseOrExcessFirst).setScale(2).format() , args)
                    + ( line.BaseOrExcessSecond >= 1 ? '<br>NS $' + + String.format(   Decimal.valueOf(line.BaseOrExcessSecond).setScale(2).format(), args) : '' )
                    + ( line.BaseOrExcessThird >= 1 ? '<br>NE $' + + String.format( Decimal.valueOf(line.BaseOrExcessThird).setScale(2).format(), args) : '' );
                }
                
                if( line.OverageCommissionFirst != null )
                {
                    line.OverageCommissionSummary = 'NB $' + String.format( Decimal.valueOf(line.OverageCommissionFirst).setScale(2).format(), args)
                    + ( line.OverageCommissionSecond >= 1 ? '<br>NS $' + + String.format( Decimal.valueOf(line.OverageCommissionSecond).setScale(2).format(), args) : '' )
                    + ( line.OverageCommissionThird >= 1 ? '<br>NE $' + + String.format(  Decimal.valueOf(line.OverageCommissionThird).setScale(2).format(), args) : '' );
                }



                if(divideAsPartialAmounts)
                {
                    
                    line.BasePrice /= 2;
                    if( line.OveragePrice != null)
                        line.OveragePrice /= 2;
                    line.QuoteSubtotal /= 2;
                }
                
                SubtotalSum += line.QuoteSubtotal;
                
                ret.add(line);
            
            } 
        
            TotalCommissionToPay = BalanceSum + DepositSum;
        
            if(ret.size() >= 1000 )
                Apexpages.addMessage(new Apexpages.Message( Apexpages.Severity.Info, 'Warning! Only 1,000 records can be shown. Try limiting your date filter for less date.'));

        }
        
        return ret;
    }

    public Rep_Commission_Report_Controller(){
        
    }

}