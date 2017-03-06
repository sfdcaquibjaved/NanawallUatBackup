@isTest
public with sharing class UnitTests6 {

class testexception extends Exception {}

 
    
    static  void RunTests () {
        
        //User u = [ SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        User testUser2 = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser2;
          
        list<Zip_Codes_Master__c> z= new list<Zip_Codes_Master__c>();
        z=TestDataUtility.getTerritoryMaster();
        insert z;
        
        Lead l = new Lead(firstname='New lead xi9209i0232', lastname = 'new lead j98s9dsj0jdsd', PostalCode='08619');
        insert l;
        
        Case c = new Case(responsible_rep__c = testUser2.id);
        insert c;
         
        Contact cont = new Contact();
        cont.FirstName = 'Bill';
        cont.LastName = 'Williamson';
        cont.MailingPostalCode = '08619';
        insert cont;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingPostalCode = '08619';
        insert a;
        
        Opportunity o = new Opportunity();
        o.Name = 'test opjojoijioj';
        o.StageName = 'test';
        o.CloseDate = Date.today();
        o.AccountID = a.Id;
        insert o;
        
        OpportunityTeamMember opT = new OpportunityTeamMember();
        opT.OpportunityId = o.Id;
        opT.UserId = testUser2.Id;
        insert opT;
        
        OpportunitySplit split = new OpportunitySplit();
        split.OpportunityId = o.Id;
        split.SplitOwnerId = testUser2.Id;
        insert split;
        
        delete split;
        
        
        Service_Quote__c sq = new Service_Quote__c( Case__c = c.Id, Tax_Exempt__c = false, ETA__c = Date.today().addDays(100), Nonstock_Company__c = 'teufelbeschlage');
        insert sq;
        
        Service_Quote_Detail__c sqd = new Service_Quote_Detail__c(); 
        sqd.Discount__c = 10;
        sqd.Freight__c = 100;
        sqd.Quantity__c = 10;
        sqd.Service_Quote__c = sq.Id;
        sqd.Ship_From_Stock__c = false;
        sqd.Unit_Price__c  = 5.00;
        insert sqd;
        
        sqd = new Service_Quote_Detail__c();
        sqd.Discount__c = 10;
        sqd.Freight__c = 100;
        sqd.Quantity__c = 10;
        sqd.Service_Quote__c = sq.Id;
        sqd.Ship_From_Stock__c = true;
        sqd.Unit_Price__c  = 5.00;
        insert sqd;
        
        
        //Service Quote Report Controller test      
        ServiceQuote_ReportController sqrc  = new ServiceQuote_ReportController(new Apexpages.Standardcontroller(sq));
 
        string temp_string = ''; 
        boolean temp_bool = false;
        double temp_double = 0;

        sqrc.EstimatedLeadTime = '';
        temp_string = sqrc.EstimatedLeadTime;

        sqrc.FinalPaymentMade = true;
        temp_bool = sqrc.FinalPaymentMade;

        sqrc.getFreight();
        sqrc.getinvoice_RenderAs();
        sqrc.getInvoice_ShippingMethod();
        
        Apexpages.currentPage().getParameters().put('BillTo','customer');
        sqrc.getInvoiceAddress();
        
        sqrc.getInvoiceNumber();
        sqrc.getNanaBillingAddress();
        sqrc.getOrderNumber();
        
        sqrc.getOtherBillingAddress();
        sqrc.getpackinglist_RenderAs();
        sqrc.getpackinglist_ShippingMethod();
        sqrc.getPaymentType();
        sqrc.getPOBody_Display_Rendered();
        sqrc.getPOBPositionSelector_Display_Rendered();

        Apexpages.currentPage().getParameters().put('errorReconciliation','true');
        sqrc.getpurchaseOrder_RenderAs();
        sqrc.getRichmondBillingAddress();
        sqrc.getSolarluxBillingAddress();
        sqrc.getSubTotal();
        sqrc.getTax();
        sqrc.getUPSBillingAddress();
        sqrc.getYellowBillingAddress();

        temp_bool = sqrc.Quote_renderDiscountColumn;


        sqrc.testPoVendor();

        for( ServiceQuote_ReportController.PurchaseOrder_Reconciliation_Position porp : sqrc.getPurchaseOrder_Reconciliation_Positions() )
        {
            porp.usePosition = false;
        }
        sqrc.PurchaseOrder_SelectPositions();
        for( ServiceQuote_ReportController.PurchaseOrder_Reconciliation_Position porp : sqrc.getPurchaseOrder_Reconciliation_Positions() )
        {
            porp.usePosition = true;
        }
        sqrc.PurchaseOrder_SelectPositions();
        
        sqrc.getBalanceDue();
        sqrc.getCalculatedShippingMethod();
        sqrc.getCustomerBillingAddress();
        sqrc.getDetails();
        sqrc.getDetails_NonStockItems();
        sqrc.getDetails_POItems();
        sqrc.getDetails_StockItems();
        
        //QuoteGateway test
        QuoteGateway.QuoteViewed('');
//      QuoteGateway.Get3DFormats(); 
 //     QuoteGateway.GetSolidWorksLink('');
  //    QuoteGateway.HandleQuoteRequest('');
    
        
        //webquote controller
        Web_Quote__c wq = new Web_Quote__c();
        wq.Contact__c = cont.Id;
        
        insert wq;

        CommitWebQuoteController cwqc = new CommitWebQuoteController( new Apexpages.Standardcontroller(wq)  );
        temp_string = cwqc.getwebQuoteProjectID();
        cwqc.setwebQuoteProjectID(''); 
        temp_bool = cwqc.getShowDupeBlock();
        cwqc.getExistingOpp();
        cwqc.getNewOPportunity();
        test.startTest();
        cwqc.Create();
        test.stopTest();
        Apexpages.currentPage().getParameters().put('id', o.Id);
        Apexpages.currentPage().getParameters().put('cid', cont.Id);
        cwqc.UseProject();

        try
        {       
            cwqc.Sync();
        } catch( Exception ex )
        {
            
        }
        
        cwqc.getduplicateopps();
        cwqc.SaveAnyway();
        
        
        //FindProjectForContactController
        FindProjectForContactController fpfcc = new FindProjectForContactController( new ApexPages.StandardController(cont) );
        fpfcc.SearchOpp = o;
        fpfcc.doSort();
        temp_bool = fpfcc.gethasprevious();
        temp_bool = fpfcc.gethasnext();
        fpfcc.next();
        fpfcc.previous();
        fpfcc.FindProjects();
        fpfcc.projectSelected();
        fpfcc.dummyOCR.Opportunity__c = o.Id;
        fpfcc.AddToProject();
     
        //begin order system tests
        /*Pricebook2 pb = null;
        for( Pricebook2 pb_temp : [SELECT Id FROM Pricebook2] )
        {
            pb = pb_temp;
            break;
        }
        PricebookEntry pbe = null;
        list<PricebookEntry> allpbeids = new list<PriceBookEntry>();
        for( PricebookEntry pbe_temp : [SELECT Id, Product2Id, Pricebook2Id FROM PricebookEntry WHERE IsActive = true] )
        {
            pbe = pbe_temp;
            allpbeids.add(pbe);
        }       

     
        
        
        Quote__c nq = new Quote__c();
        nq.Opportunity__c = o.Id;
        insert nq;
        
        Quote q = new Quote();
        q.Name = 'Test Quote';
        q.OpportunityId = o.Id;
        q.Pricebook2Id = pbe.Pricebook2Id;
        q.Nana_Quote__c = nq.Id;
        insert q;
        
        QuoteLineItem lineitem = new QuoteLineItem();
        lineitem.QuoteID = q.Id;
        lineitem.PricebookEntryId =  pbe.Id;
        lineitem.Quantity = 1;
        lineitem.UnitPrice = 10000;
        
        insert lineitem;


        Map<String, Object> params = new Map<String, Object>();
        params.put('QuoteID', q.Id);        
        Flow.Interview.Quote_to_Order convertFlow = new Flow.Interview.Quote_to_Order(params);
        convertFlow.start();*/

     
    }



}