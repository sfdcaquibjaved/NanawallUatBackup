public with sharing class ServiceQuote_ReportController {
    
    public boolean servicepartcheck {get; set;}
    //quote specific
    
    /*public Contact getShipToContact(){
        set<id> shipCon = new set<id>(); 
        if(sq2.Ship_To_Contact__c  != null){
            shipCon.add(sq2.Ship_To_Contact__c);
        }
        Contact cc = [select id,firstname,lastname from contact where id in:shipCon limit 1];
        return cc;
    }*/
    
    public string getCalculatedShippingMethod () 
    {
        //somehow it makes sense to fork the displayed shipping type when both the 
        // stock and non-stock are filled in. I am convinced this is an error, but hey .. im not
        //paid to think.
        
        if(sq2.Shipping_Method__c  != null )  
        {
            return sq2.Shipping_Method__c;
        } else if( sq2.NonStock_Shipping_Method__c != null)
        {
            return sq2.NonStock_Shipping_Method__c;
        } else return '';
    }
    
    public boolean Quote_renderDiscountColumn {
        get {
    //      for( Service_Quote_Detail__c sqd : getDetails() )
        //  {
    //          if( sqd.Discount__c != null && sqd.Discount__c > 0 )
        //          return true;
    //      }
            return false;
        } 
    }
    public string EstimatedLeadTime {
        get{
            //stock eta, non-stock eta
            //use the greater one
            // either less than a week or its so many week
            
            Date Eta1 = (sq2.ETA__c == null ? Date.today() : sq2.ETA__c );
            Date Eta2 = (sq2.NonStock_ETA__c == null ? Date.today() : sq2.NonStock_ETA__c );
             
            Date d = ( Eta1 > Eta2 ? Eta1 : Eta2);
            Date now = Date.today();
            
            if( d == now ) return '';
            
            integer weeks = Math.round(now.daysBetween(d) /7);

            if(  weeks >= 1 ) return weeks + ( (  Math.mod(now.daysBetween(d),7) != 0) ? '-' + (weeks+1) : '' )+ ' week' + (now.daysBetween(d) == 7 ? '' : 's');
            else return 'Less than a week';
            
        }
        set; 
    }

    
    //purchase order specific methods
    public class PurchaseOrder_Reconciliation_Position
    {
        public Service_Quote_Detail__c detail {get; set; }
        public boolean usePosition {get; set; }
    }

    private string po_ShippingType = null;
    public pagereference PurchaseOrder_SelectPositions() 
    {

        string idList = '';
        for( PurchaseOrder_Reconciliation_Position pos : PurchaseOrder_Reconciliation_Positions )
        {
            if( pos.usePosition)
            {
                idList += pos.detail.Id+';';
            }
        }
        
        //3. create the stock order
        Stock_Order__c so = new Stock_Order__c();
        so.Care_Of__c = sq2.Care_Of__c;
        so.Company__c = sq2.Nonstock_Company__c;
        so.Complaint_Note__c = '(Missing Part)';
        so.Order_Number__c = 'SQ Re-Order ' + sq2.Name;
        so.Service_Quote__c = sq2.Id;
        so.Responsibility__c = sq2.Responsibility__c;
        insert so;

        list<Stock_Order_Detail__c> detailsToInsert = new list<Stock_Order_Detail__c>();
        list<Service_Quote_Detail__c> sqdsToUpdate = new list<Service_Quote_Detail__c>();
        integer posnum = 1;
        for( PurchaseOrder_Reconciliation_Position pos : PurchaseOrder_Reconciliation_Positions )
        {
            if( pos.usePosition)
            {
                Stock_Order_Detail__c det = new Stock_Order_Detail__c();
                det.Checked_In_Quantity__c = 0;
                det.Position__c  = posnum++;
                det.Quantity__c = pos.detail.Quantity__c;
                det.Service_Part__c = pos.detail.Service_Part__c;
                det.Stock_Order__c = so.Id;
                det.Unit_Price__c = pos.detail.Unit_Price__c;
                det.discount__c = 0;
                
                detailsToInsert.add(det);
                
                
                Service_Quote_Detail__c sqd = pos.detail;
                sqd.Unit_Price__c = 0;
                sqdsToUpdate.add(sqd);
            }
        }
        
        update sqdsToUpdate;
        insert detailsToInsert; 
        
                
        Pagereference ref  = new PageReference('/apex/ServiceQuote_PurchaseOrder?id='+Apexpages.currentPage().getParameters().get('id')+'&reconciliationmode=true&PO_PositionFilter='+idList+'&ShippingType='+po_ShippingType+'&scontrolCaching=1');
        ref.setRedirect(true);
        
        return ref;
    }
    
    list<PurchaseOrder_Reconciliation_Position> PurchaseOrder_Reconciliation_Positions = null;
    public list<PurchaseOrder_Reconciliation_Position> getPurchaseOrder_Reconciliation_Positions() 
    {
        if(PurchaseOrder_Reconciliation_Positions == null )
        {
            PurchaseOrder_Reconciliation_Positions = new list<PurchaseOrder_Reconciliation_Position>();
            for( Service_Quote_Detail__c det : getDetails() )
            {
                PurchaseOrder_Reconciliation_Position porp = new PurchaseOrder_Reconciliation_Position();
                porp.detail = det;
                porp.usePosition = false;
                
                PurchaseOrder_Reconciliation_Positions.add( porp );
            }   
        }
        
        return PurchaseOrder_Reconciliation_Positions;
    }
    
    boolean po_errorReconciliation = null;
    boolean po_errorReconciliation_PositionsSelected = false;
    public string getpurchaseOrder_RenderAs() {
    
        if(po_errorReconciliation == null )
            po_errorReconciliation = (Apexpages.currentPage().getParameters().get('errorReconciliation') == 'true');
    
    
        if(po_errorReconciliation && !po_errorReconciliation_PositionsSelected ) return 'html';
        else return 'pdf';
    }
    
    public boolean getPOBody_Display_Rendered() 
    {
        if(po_errorReconciliation == null )
            po_errorReconciliation = (Apexpages.currentPage().getParameters().get('errorReconciliation') == 'true');
    
        return !(po_errorReconciliation  && !po_errorReconciliation_PositionsSelected);
    
    }
    
    public boolean getPOBPositionSelector_Display_Rendered() 
    {
        if(po_errorReconciliation == null )
            po_errorReconciliation = (Apexpages.currentPage().getParameters().get('errorReconciliation') == 'true');
    
        return (po_errorReconciliation  && !po_errorReconciliation_PositionsSelected);
    
    }
    
    public string displayPurchaseOrder {
        get {
            
            return  (getDetails_POItems().size() > 0 ? 'block' : 'none');           
        }
    }
    
    public string PO_Shipmethod{
        get {
            return ApexPages.currentPage().getParameters().get('ShippingType');
        }
    }
    
    public void testPoVendor()
    { //need this in order to pass unit tests

        this.sq2.Nonstock_Company__c =  ('teufelbeschlage');
        Lead l = this.getPOVendor();
        this.sq2.Nonstock_Company__c =  ('nanawall (mill valley)'); 
        l = this.getPOVendor();
        this.sq2.Nonstock_Company__c =  ('solarlux (bissendorf)');
        l = this.getPOVendor();
        this.sq2.Nonstock_Company__c =  ('solarlux (richmond)');         
        l = this.getPOVendor();

    }
     


    public Lead getPOVendor() {
    
        {
            Lead l = new Lead();


            if( this.sq2.Nonstock_Company__c == null ) return l;
                
            string company = this.sq2.Nonstock_Company__c.toLowerCase();
//          string company = '';
            
            if( company == 'teufelbeschlage')
            {
                l.FirstName = 'Teufelbeschlag GmbH';
                l.Company = 'Teufelbeschlag GmbH';
                l.Address_1__c = 'Am brand 8';
                l.nrCity__c = 'Tuerkenfeld';
                l.nrState__c = 'Germany';
                l.Zip__c = 'D-82299';
                l.Phone = '0049 8193 9393 924';
                l.Fax = '0049 8193 93 93 99 ';
                l.Email = 'a.teichmann@teufelbeschlag.de';
                
                l.nrCountry__c  = '';
                
            } else if( company == 'nanawall (mill valley)' )
            {
                l.FirstName = 'Nana Wall Systems Inc';
                l.Company = 'Nana Wall Systems Inc';
                l.Address_1__c = '100 Meadowcreek Drive Suite 250'; 
                l.nrCity__c = 'Corte Madera';
                l.nrState__c = 'CA';
                l.Zip__c = '94925';
                l.Phone = '800-873-5673 x256';
                l.Fax = '415-383-0312';
                l.Email = '';
                
            } else if( company == 'solarlux (bissendorf)' )
            {//dev = 003A0000005hE6l  prod  = 003A0000005hE6l

                if( GlobalStrings.HostName() == 'cs9.salesforce.com' )
                { //dev
                    
                    Contact c = [SELECT FirstName, Phone, Fax, LastName,Email, Account.BillingStreet, Account.BillingCity, Account.BillingState,Account.BillingPostalCode, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000005hE6l' ];
                    l.FirstName = c.FirstName;
                    l.LastName = c.LastName;
                    l.Company = c.Account.Name;
                    l.Address_1__c = c.Account.BillingStreet;
                    l.nrCity__c = c.Account.BillingCity;
                    l.nrState__c = c.Account.BillingState; 
                    l.Zip__c = c.Account.BillingPostalCode;
                    l.Email = c.Email;
                    l.Phone = c.Phone;
                    l.Fax = c.Fax;
                } else if(GlobalStrings.HostName() == 'na7.salesforce.com' )
                {
                    Contact c = [SELECT FirstName, LastName,Email,Phone, Fax,Account.BillingStreet, Account.BillingCity, Account.BillingState,Account.BillingPostalCode,  Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000005hE6l' ];
                    l.FirstName = c.FirstName;
                    l.LastName = c.LastName;
                    l.Company = c.Account.Name;
                    l.Address_1__c = c.Account.BillingStreet;
                    l.nrCity__c = c.Account.BillingCity;
                    l.nrState__c = c.Account.BillingState;
                    l.Zip__c = c.Account.BillingPostalCode;
                    l.Email = c.Email;
                    l.Phone = c.Phone;
                    l.Fax = c.Fax;
                } else 
                {       
                    l  = new Lead(  
                            Company = 'Solarlux Aluminium Systeme GmbH', FirstName = 'Michael', LastName = 'Schmidt', 
                            Address_1__c = 'Gewerbepark 9-11', nrCity__c = 'Bissendorf', nrState__c = '', Zip__c = '49143', 
                            nrCountry__c = 'Germany',
                            Phone = '+49-5402-400-0');
                }
            } else if ( company == 'solarlux (richmond)')
            {// dev = 003A0000005hFwk  prod = 003A0000005hFwk
                if( GlobalStrings.HostName() == 'cs9.salesforce.com' )
                { //dev
                    Contact c = [SELECT FirstName,Phone,Fax, LastName,Email,Account.BillingStreet, Account.BillingCity, Account.BillingState,Account.BillingPostalCode, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000005hFwk' ];
                    l.FirstName = c.FirstName;
                    l.LastName = c.LastName;
                    l.Company = c.Account.Name;
                    l.Address_1__c = c.Account.BillingStreet;
                    l.nrCity__c = c.Account.BillingCity;
                    l.nrState__c = c.Account.BillingState;
                    l.Zip__c = c.Account.BillingPostalCode;
                    l.Email = c.Email;
                    l.Phone = c.Phone;
                    l.Fax = c.Fax;
                } else if(GlobalStrings.HostName() == 'na7.salesforce.com' )
                {
                    Contact c = [SELECT FirstName, Phone,LastName,Fax,Email,Account.BillingStreet, Account.BillingCity, Account.BillingState,Account.BillingPostalCode, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000005hFwk' ];
                    l.FirstName = c.FirstName;
                    l.LastName = c.LastName;
                    l.Company = c.Account.Name;
                    l.Address_1__c = c.Account.BillingStreet;
                    l.nrCity__c = c.Account.BillingCity;
                    l.nrState__c = c.Account.BillingState;
                    l.Zip__c = c.Account.BillingPostalCode;
                    l.Email = c.Email;
                    l.Phone = c.Phone;
                    l.Fax = c.Fax;
                } else 
                {       
                    l  = new Lead(  
                            Company = 'Solarlux (Richmond)', FirstName = 'Derek', LastName = 'Lee', 
                            Address_1__c = '50 West Ohio', nrCity__c = 'Richmond', nrState__c = 'CA', Zip__c = '94804', 
                            Phone = '510-231-0800', nrCountry__c = 'United States' );
                }
                
            }
            
            return l;
        }
         
    }
    
    //invoice specific methods
    public string getinvoice_RenderAs() {
    
        return 'pdf';
    }
    
    public string getInvoice_ShippingMethod() {
    
        return ApexPages.currentPage().getParameters().get('ShippingType');
    }
    
    //tlkpservicebillto
    public Lead getOtherBillingAddress() {
        Lead l  = new Lead();
        l.firstname = sq.other_bill_to_first_name__c;
        l.lastname = sq.other_bill_to_last_name__c;
        l.Company = sq.Other_Bill_To_Company__c;
        l.Address_1__c = sq.Other_Bill_To_Address__c;
        l.Address_2__c = sq.Other_Bill_To_Address_2__c;
        l.nrCity__c = sq.Other_Bill_To_City__c;
        l.nrState__c = sq.Other_Bill_To_State__c;
        l.Zip__c = sq.Other_Bill_To_Zip__c;
        l.Phone = sq.Other_Bill_To_Phone__c;
        l.Fax = sq.Other_Bill_To_Fax__c;
        l.Email = sq.Other_Bill_To_Email__c;
        l.nrCountry__c = sq.other_bill_to_country__c;
        
        return l;
    }
    
    public Lead getNanaBillingAddress() {
        Lead l  = new Lead( FirstName = 'Nana', LastName = '' );
        return l;
    }
    
    public Lead getUPSBillingAddress() {

        //dev = 003Q000000Z79yFIAR
        // prod = 003A0000013vBBmIAM
        
        Lead l = new Lead();
        //oh won't you take me to, hacky town ? 
        if( GlobalStrings.HostName() == 'cs9.salesforce.com' )
        { //dev
            Contact c = [SELECT FirstName, LastName, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000013vBBmIAM' ];
            l.Company = c.Account.Name;
            l.Address_1__c = c.Account.Address_1__c;
            l.nrCity__c = c.Account.City__c;
            l.nrState__c = c.Account.State__c;
            l.Zip__c = c.Account.Zip__c;
            
        } else if(GlobalStrings.HostName() == 'na7.salesforce.com' )
        {
            Contact c = [SELECT FirstName, LastName, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000013vBBmIAM' ];
            l.Company = c.Account.Name;
            l.Address_1__c = c.Account.Address_1__c;
            l.nrCity__c = c.Account.City__c;
            l.nrState__c = c.Account.State__c;
            l.Zip__c = c.Account.Zip__c;
        
        } else l  = new Lead(   Company = 'UPS remit address', Address_1__c = 'PO BOX 894820',nrCity__c = 'LOS ANGELES', nrState__c = 'CA', Zip__c = '90189-4820' );
        
        return l;

    }
    
    public Lead getCustomerBillingAddress() {
        Lead l  = new Lead();
        if(sq2.recordtypeid != Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId()){
        l.FirstName =   sq2.Send_Quote_To_Contact__r.FirstName;
        l.LastName  = sq2.Send_Quote_To_Contact__r.LastName;
        l.Company = sq2.Other_Bill_To_Company__c;
        l.Address_1__c = sq2.Bill_Too_Street__c;
        l.Address_2__c = sq2.Other_Bill_To_Address_2__c;
        l.nrCity__c = sq2.Bill_Too_City__c;
        l.nrState__c = sq2.Other_Bill_To_State__c;
        l.Zip__c = sq2.Bill_Too_Zip__c;
        l.Phone = sq2.Bill_To_Phone__c;
        l.nrCountry__c = sq2.Bill_To_Country__c;
        
      l.Fax = sq.Ship_To_Fax__c;
        l.Email = sq2.Bill_Too_Email__c;
        }else{
        l.FirstName =   sq2.Send_Quote_To_Contact__r.FirstName;
        l.LastName  = sq2.Send_Quote_To_Contact__r.LastName;
        l.Company = sq2.Other_Bill_To_Company__c;
        l.Address_1__c = sq2.Shopify_Bill_To_Street__c;
        //l.Address_2__c = sq2.Other_Bill_To_Address_2__c;
        l.nrCity__c = sq2.Shopify_Bill_To_City__c;
        l.nrState__c = sq2.Shopify_Bill_To_State__c;
        l.nrCountry__c = sq2.Shopify_Bill_To_country__c;
        l.Zip__c = sq2.Shopify_Bill_To_Zip__c;
        l.Phone = sq2.Shopify_Bill_To_Phone__c;
      l.Fax = sq.Ship_To_Fax__c;
        l.Email = sq2.Shopify_Bill_To_Email__c;  
        }
        

        return l;       
    }
    
    public Lead getSolarluxBillingAddress() {
        Lead l  = new Lead( 
                        Company = 'Solarlux Aluminium Systeme GmbH', FirstName = 'Michael', LastName = 'Schmidt', 
                        Address_1__c = 'Gewerbepark 9-11', nrCity__c = 'Bissendorf', nrState__c = '', Zip__c = '49143', 
                        nrCountry__c = 'Germany',
                        Phone = '+49-5402-400-0');

        return l;       
    }
    
    public Lead getRichmondBillingAddress() {
        Lead l  = new Lead( 
                        Company = 'Solarlux (Richmond)', FirstName = 'Derek', LastName = 'Lee', 
                        Address_1__c = '50 West Ohio', nrCity__c = 'Richmond', nrState__c = 'CA', Zip__c = '94804', 
                        Phone = '510-231-0800', nrCountry__c = 'United States' );
        return l;       
    }
    
    public Lead getYellowBillingAddress() {
        
        //dev = 003Q000000Z79khIAB
        // prod = 003A0000013vB5wIAE
        
        Lead l = new Lead();
        //oh won't you take me to, hacky town ? 
        if( GlobalStrings.HostName() == 'cs9.salesforce.com' )
        { //dev
            Contact c = [SELECT FirstName, LastName, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000013vB5wIAE' ];
            l.Company = c.Account.Name;
            l.Address_1__c = c.Account.Address_1__c;
            l.nrCity__c = c.Account.City__c;
            l.nrState__c = c.Account.State__c;
            l.Zip__c = c.Account.Zip__c;
            
        } else if(GlobalStrings.HostName() == 'na7.salesforce.com' )
        {
            Contact c = [SELECT FirstName, LastName, Account.Name, Account.Address_1__c, Account.City__c, account.State__c, Account.Zip__c FROM Contact WHERE id = '003A0000013vB5wIAE' ];
            l.Company = c.Account.Name;
            l.Address_1__c = c.Account.Address_1__c;
            l.nrCity__c = c.Account.City__c;
            l.nrState__c = c.Account.State__c;
            l.Zip__c = c.Account.Zip__c;
        
        } else l  = new Lead(   Company = 'YRC FREIGHT', Address_1__c = 'PO BOX 7914',nrCity__c = 'OVERLAND PARK', nrState__c = 'KS', Zip__c = '66207' );
        
        return l;       
    }
    
    public decimal getBalanceDue() {
        decimal balance = 0;
        balance += getTotal();
        if( sq2.Final_Payment_Amount__c != null)
            balance -= sq2.Final_Payment_Amount__c;
        if(sq2.Deposit_Amount__c != null )
            balance -= sq2.Deposit_Amount__c;
    
        return balance;

            
    }
    
    public string getInvoiceNumber() {
        //=Parameters!OrderNumber.Value & "-" & Parameters!ServiceQuoteID.Value &"-" & Parameters!BillToLabel.Value 
        string invoicenumber = '';
        invoicenumber += sq2.quote__r.Order_Number__c; // + ' - ' + sq2.Name;
        
        return invoicenumber;
    }
    
    public boolean FinalPaymentMade {
        get {
            return (sq2.Final_Payment_Date__c != null);      
        }
        
        set{}
    }
    
    public string getPaymentType() {
    
        if(!FinalPaymentMade ) return '';
    
        string pmtType = 'Paid by '+sq2.Final_Payment_Type__c;
        if( sq2.LastFourDigitsOfPaymentMedium__c != '' )
            pmtType += ' ending in ' +sq2.Final_Last_4_Digits__c ;
         return pmtType;
    }
    
    public Lead getInvoiceAddress() {
        string billType = Apexpages.currentPage().getParameters().get('BillTo').toLowerCase();
        
        if( billType == 'customer')
            return getCustomerBillingAddress();
        else if( billType == 'yellow' )
            return getYellowBillingAddress();
        else if( billType == 'richmond')
            return getRichmondBillingAddress();
        else if( billType == 'solarlux')
            return getSolarluxBillingAddress();
        else if( billType == 'other')
            return getOtherBillingAddress();
        else if( billType == 'nana')
            return getNanaBillingAddress();
        else if( billType == 'ups' )
            return getUPSBillingAddress();
        else if( billType == 'customer' )
            return getCustomerBillingAddress();
        else return null;
            
    }
    //packinglist specific methods
    public string getpackinglist_RenderAs() {
    
        return 'pdf';
    }
    
    public string getpackinglist_ShippingMethod() {
    
        return ApexPages.currentPage().getParameters().get('ShippingType');
    }
    
    //end specific methods


    public string getOrderNumber() {
    
    
        if( sq2.quote__r.SL_Order_Number__c != null )   
        {
            return sq2.quote__r.Order_Number__c + ' / SL#' + sq2.quote__r.SL_Order_Number__c;
        } else return sq2.quote__r.Order_Number__c + '';

    }


    private list<Service_Quote_detail__c> details = null;
    public list<Service_Quote_detail__c> getDetails() {
        if( details == null )
        {
            details =  [SELECT Id,Quantity__c,Position__c,Discount_Unit_Price__c, ThumbnailURL__c,Ship_From_Stock__c,Name, Service_Part__r.Description__c, Service_Part__r.Name,Service_Part__r.Part_Name__c,Notes__c,Service_Part__r.Stocked__c,Unit_Price__c,Freight__c,subtotal__c, discount__c FROM Service_Quote_Detail__c WHERE Service_Quote__c = :sq.id ORDER BY Position__c];
            set<Id> partIds_set = new set<Id>();
            
            for(Service_Quote_Detail__c sqd : details )
            {
                if( sqd.Service_Part__c != null && !partIds_set.contains(sqd.Service_Part__c) )
                {
                    partIds_set.add(sqd.Service_Part__c);
                }
            }
            list<Id> partIds = new list<Id>(partIds_set);
            map<Id, Attachment> partImageMap = new map<Id,Attachment>();
            
            for( Attachment a :[SELECT Body,BodyLength,Id,ParentId FROM Attachment WHERE ParentID IN :partIds] )
            {
                if( !partImageMap.containsKey(a.ParentId) )
                    partImageMap.put( a.ParentID, a );
            }
            for(Service_Quote_Detail__c sqd : details )
            { //now go back over hte details and set the part thumb URL where appropriate
                if( partImageMap.containsKey(sqd.Service_Part__c) )
                    sqd.ThumbnailURL__c = '/servlet/servlet.FileDownload?file='+partImageMap.get(sqd.Service_Part__c).Id;
            }
        }
        return details; 
    }


    public list<Service_Quote_Detail__c> getDetails_StockItems() {
    
        list<Service_Quote_Detail__c> sqds = new list<Service_Quote_Detail__c>();
        for( Service_Quote_Detail__c sqd : getDetails( ))
        {
//          if( sqd.Service_Part__r.Stocked__c )
            if( sqd.Ship_From_Stock__c )
            {
                sqds.add(sqd);
            }
        }
        
        return sqds;
    }
    public list<Service_Quote_Detail__c> getDetails_POItems() {
        list<Service_Quote_Detail__c> sqds = new list<Service_Quote_Detail__c>();
                
        string PO_PositionFilter = ApexPages.currentPage().getParameters().get('PO_PositionFilter');
        if(PO_PositionFilter != null && PO_PositionFilter != '' )
        {
            set<string> posFilter = new set<string>();
            for( string s : PO_PositionFilter.split(';') )
            {
                if( s != null && s != '')
                    posFilter.add(s);
            }
            for( Service_Quote_Detail__c sqd : getDetails() )
            {
//              if( !sqd.Ship_From_Stock__c  && posFilter.contains(sqd.id) )
                if( posFilter.contains(sqd.id) )
                {
                    sqd.Unit_price__c = 0;
                    sqds.add(sqd);
                }
                System.debug('testing'+sqd.Service_Part__c);
                if(sqd.Service_Part__c!=NULL)
                {
                    servicepartcheck = TRUE;
                }
            }
        } else
        {
        
            for( Service_Quote_Detail__c sqd : getDetails() )
            {
                if( !sqd.Ship_From_Stock__c  )
                {
                    sqds.add(sqd);
                }
                
                System.debug('testing'+sqd.Service_Part__c);
                if(sqd.Service_Part__c!=NULL)
                {
                    servicepartcheck = TRUE;
                }
            }
        }
        return sqds;
    }
    public list<Service_Quote_Detail__c> getDetails_NonStockItems() {
    
        list<Service_Quote_Detail__c> sqds = new list<Service_Quote_Detail__c>();
        
        for( Service_Quote_Detail__c sqd : getDetails( ))
        {
            if( !sqd.Service_Part__r.Stocked__c )
            {
                sqds.add(sqd);
            }
        }
        
        return sqds;
    }

    public decimal getTax() { 
        if( sq2.Tax_Exempt__c) return 0;
        
        decimal tax = 0;
        if( sq2.Tax__c != null )
            tax = sq2.Tax__c;
    //  for( Service_Quote_Detail__c sqd : getDetails() )
    //  {
    //      if( sqd.tax__c != null )
    //          tax += sqd.Tax__c;
    //  }

        return tax;
    }
    public decimal getTotal() { 

        decimal total = 0;
        
        decimal test = getTax();
        test += getFreight();
        test += getSubtotal();
        
        return test;    
//      return getTax() + getFreight() + getSubtotal();
    }

    public decimal getFreight() {

        decimal freight = 0;
    //  for( Service_Quote_Detail__c sqd : getDetails() )
    //  {
    //      if( sqd.Freight__c != null )
    //          freight += sqd.Freight__c;
    //  }
        if( sq.Freight__c != null)
            freight = sq.freight__c;
        return freight;

    }

    public decimal getSubTotal() {
        
        decimal subtotal = 0;
        if( sq.subtotal__c != null)
            subtotal = sq.subtotal__c;
    //  for( Service_Quote_Detail__c sqd : getDetails() )
    //  {
    //      if( sqd.SubTotal__c != null)
    //          subtotal += sqd.SubTotal__c;
    //  }
        
        return subtotal;
    }
    
    public string ResponsibleRep {
        get {
            return  serviceQuoteCase.Responsible_Rep__c;
        }
    }
    
    public string ResponsibleRepInitials {
        get {
            if( servicequotecase.responsible_rep__c == null ) return '';


            string[] names = serviceQuoteCase.Responsible_Rep__c.split(' ');            

                    
            string initials = '';
            
            try {
                initials = names[0].substring(0,1) + ' ' + names[1].substring(0,1);
            } catch( Exception ex ) 
            {
            }

            return initials;
        }
    }
    



    private Case serviceQuoteCase;
    private final Service_Quote__c sq;
    private Service_Quote__c sq2;
    public ServiceQuote_ReportController(ApexPages.StandardController stdController) {
        
        servicepartcheck = false;
        this.sq = (Service_Quote__c)stdController.getRecord();

        sq2 = [SELECT Id,Bill_To_Country__c,Final_Payment_Amount__c,Ship_To_Contact__c,Bill_To_Contact__c,Ship_To_Company__c,Bill_To_Company__c,Deposit_Amount__c,Bill_To_countryy__c,LastFourDigitsOfPaymentMedium__c,Final_Payment_Date__c,Final_Payment_Type__c,Tax_Exempt__c,Tax__c,Final_Last_4_Digits__c,recordtypeid,Shopify_Ship_To_City__c,Shopify_Bill_To_State__c,Shopify_Bill_To_Phone__c,Shopify_Bill_To_Email__c, Shopify_Bill_To_City__c,Shopify_Bill_To_Street__c,Shopify_Bill_To_Zip__c,SubTotal__c ,Send_Quote_To_Contact__r.FirstName ,Nonstock_Company__c,Send_Quote_To_Contact__c, Other_Bill_To_Company__c, Other_Bill_To_Address_2__c  ,Send_Quote_To_Contact__r.LastName,Bill_Tooo__c,Other_Bill_To_Email__c, Bill_Too_City__c,Other_Bill_To_State__c,Bill_Too_Zip__c, Bill_To_Phone__c,Bill_Too_Email__c ,Bill_Too_Street__c ,Care_Of__c,Responsibility__c, quote__r.SL_Order_number__c,ETA__c, NonStock_ETA__c, quote__r.Order_number__c, Name,Case__c, Shipping_Method__c, Shopify_Bill_To_country__c, NonStock_Shipping_Method__c FROM Service_Quote__c WHERE id = :sq.id];


        string reconciliationmode = ApexPages.currentPage().getParameters().get('reconciliationmode');
        if(reconciliationmode != null && reconciliationmode != '' )
        {
            sq.NonStock_Responsibility__c = 'Production';
//          sq.Complaint_Note__c = '(Missing Part)';
//          sq.Complaint__c = true;
//          sq.Nonstock_Company__c = 'NanaWall (Mill Valley)';

            sq2.NonStock_Responsibility__c = 'Production';
//          sq2.Complaint_Note__c = '(Missing Part)';
//          sq2.Complaint__c = true;
//          sq2.Nonstock_Company__c = 'NanaWall (Mill Valley)';
            
        }
        
        serviceQuoteCase = [SELECT id,Responsible_Rep__c FROM Case WHERE id = :sq2.Case__c ];

        if(po_ShippingType == null )
            po_ShippingType = Apexpages.currentPage().getParameters().get('ShippingType');


    }



}