@IsTest
public class ServiceQuote_PositionList_ControllerTest {
    //public static list<Service_Quote_Detail__c> olstServiceQuoteDet;
    
    static testmethod void testmethod1() {
        // olstServiceQuoteDet=TestDataUtility.createserviceQuoteDetailTestData();
        // insert olstServiceQuoteDet;
        
        PageReference pageRef = Page.ServiceQuote_PositionList;
        Test.setCurrentPage(pageRef);
        
        
        /*Service_Quote_Detail__c sqd = new Service_Quote_Detail__c();
sqd.Discount__c = 10;
sqd.Freight__c = 20;
sqd.Unit_Price__c = 120;
sqd.Quantity__c = 1;
insert sqd;*/
        
        case c = new case ();
        
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        c.subject = 'Test';
        c.Description = 'Test Description'; 
        insert c;
        
        Service_Quote__c sq= new Service_Quote__c();
        sq.case__c=c.id;
        sq.Total_Amount__c = 134;
        sq.Discount__c = 20;
        insert sq;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sq);
        ServiceQuote_PositionList_Controller serq = new ServiceQuote_PositionList_Controller(sc);
        serq.getDetails();
        serq.deletePosition();
        
        // serq.fillInventory();
        serq.SetPositionOrders();
        serq.AddNewPosition();
        //serq.fillInventory();
    }
    static testmethod void testmethod2() {
        
        case c = new case ();
        
        c.Origin = 'Phone';
        c.Status = 'New';
        c.Priority = 'Medium';
        c.subject = 'Test';
        c.Description = 'Test Description'; 
        insert c;
        
        Service_Quote__c sq= new Service_Quote__c();
        sq.case__c=c.id;
        sq.Total_Amount__c = 134;
        sq.Discount__c = 20;
        insert sq;
        
        Service_Part__c sp = new Service_Part__c();
        sp.Number_Stocked__c=12; 
        sp.Name='testname';
        sp.Description__c='test desc'; 
        sp.Part_Name__c='test part name';
        sp.Stocked__c=true;
        insert sp;
        
        Service_Quote_Detail__c sqd = new Service_Quote_Detail__c();
        sqd.Notes__c='notes';
        sqd.Quantity__c=123;
        sqd.Service_Part__c=sp.Id;
        sqd.Service_Quote__c=sq.Id;
        sqd.ThumbnailURL__c='www.test.com';
        sqd.Ship_From_Stock__c=true;
        sqd.Position__c=124;
        sqd.Name='testquote';
        sqd.Unit_Price__c=100;
        sqd.Freight__c=200;
        sqd.discount__c=20;
        
        // sqd.Discount__c = 10;
        // sqd.Freight__c = 20;
        //sqd.Unit_Price__c = 120;
        // sqd.Quantity__c = 1;
        insert sqd;
        
        
        Service_Quote_Detail__c sqd1 = new Service_Quote_Detail__c();
        sqd1.Notes__c='notes';
        sqd1.Quantity__c=123;
        sqd1.Service_Part__c=sp.Id;
        sqd1.Service_Quote__c=sq.Id;
        sqd1.ThumbnailURL__c='www.test.com';
        sqd1.Ship_From_Stock__c=true;
        sqd1.Position__c=124;
        sqd1.Name='testquote';
        sqd1.Unit_Price__c=100;
        sqd1.Freight__c=200;
        sqd1.discount__c=20;
        insert sqd1;
        delete sqd1;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sq);
        ServiceQuote_PositionList_Controller serq = new ServiceQuote_PositionList_Controller(sc);
        
        
        //serq.fillInventory();
        serq.InventoryFill_PositionID=sqd.id;
        serq.fillInventory();
        
        
    }
}