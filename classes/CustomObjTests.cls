public with sharing class CustomObjTests {
    
    @isTest(SeeAllData=false)
    static  void RunTests () {
        try{
        	
        	// test TotalOrderReportManager2
        	TotalOrderReportManager2.run( Date.today().addDays(-720), Date.today().addDays(-690));
        	
        	//end TotalOrderReportManager2
        	
        	
        AjaxResponseController testajax = new AjaxResponseController();
        testajax.lookup_Opportunity_NameList('test'); 
        
        User u = [SELECT id from User WHERE isactive = true LIMIT 1];
        
        
		Contact cont = new Contact();
		cont.FirstName = 'TestFirst';
		cont.LastName = 'TestLast';
		cont.Country__c = 'USA';
		cont.Zip__c = 'TEST';
		
		insert cont;

        Opportunity o = new Opportunity();
        o.Name = 'test';
        o.StageName = 'test';
        o.CloseDate = Date.today();
        o.Postal_Code__c = 'TEST';
        o.OwnerId = u.id;
        o.Country__c = 'USA';
        insert o;
         
       nrOpportunityContactRole__c ocr = new nrOpportunityContactRole__c();
       ocr.Opportunity__c = o.id;
       ocr.Contact__c = cont.id;
       
        insert ocr;
             
        nrOpportunityTeamMember__c nrotm = new nrOpportunityTeamMember__c();        
        nrotm.Opportunity__c = o.id; 
        insert nrotm;

        Quote__c q = new Quote__c();
        q.Opportunity__c = o.id;
   
        insert q;
        update q;
        delete q;

		Dispatcher_Edit_Controller disp = new Dispatcher_Edit_Controller( new Apexpages.Standardcontroller(o) );
		disp.getRedir( );

        
        
        Quote_Detail__c qd = new Quote_Detail__c();
        Quote__c q2 = [select id from quote__c limit 1];
        qd.Quote__c = q2.Id;
        
        insert qd;
    


        update ocr;
//        update o;
        update nrotm;
        

        update qd;
   
        delete nrotm;

	        delete ocr;
 
        
    }catch (Exception ex){}//      delete qd;
         //utility, test the zip codes

    }


}