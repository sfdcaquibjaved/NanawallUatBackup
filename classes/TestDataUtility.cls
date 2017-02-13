/**
* @author       Absyz Consulting
* @date         11/04/2015
* @description  Helper class which provides test data to all test classes 
*
* @ Audit Trial   : Repeating block for each change to the code
**/


public with sharing class TestDataUtility {

    //Integer Test Data Size
    public static Integer testDataSize = 20;
    
    public static user createUser(string profile, string username) {
        username = Math.random()+ username;
        user newUser;
        
            Profile userProfile = [select Name from Profile where Name = : profile];
            newUser = new User(alias = 'test',
            email = 'one@testorg.com',
            emailencodingkey = 'UTF-8',
            lastname = profile + ' User',
            languagelocalekey = 'en_US',
            city = 'Stow',
            country = 'United States',
            localesidkey = 'en_US',
            profileid = userProfile.Id,
            timezonesidkey = 'America/Los_Angeles',
            username = username);
       
        return newUser;
    }
    
    public static list<Account> createAccountTestData(){
     
     list<Account> accountlst = new list<Account>();
     
     for (Integer i= 0 ; i < testDataSize ; i++){
        Account a = new Account();
        a.Name = 'Test Account' + i;
        a.Phone = '(123) 456-7890';
        a.Name = 'Test account';
        a.BillingState = 'New York';
        a.BillingCountryCode='US';
        a.BillingPostalCode='12345';
        a.BillingStreet = 'xyz street';
        a.BillingCity = 'new va';
        a.Type ='Competitor Firm';
        accountlst.add(a);
     }  
     return accountlst ;
    
    }
    
    public static list<Contact> createConTestData(){
        
        List<Contact> conlist = new List<Contact>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
        Contact con = new Contact();
        con.SyncInProgress__c = false;
        con.FirstName = 'foo' + i;
        con.LastName = 'bar' + i;
        con.MailingStreet = 'street';
        con.MailingCity = 'city'; 
        con.MailingstateCode = 'CA';
        con.MailingPostalCode = '08619';
        con.MailingCountryCode = 'US';
        con.Phone = '(123) 456-7890';
        conlist.add(con);  
        }
        return conlist ;
        
    }
    
    public static list<Lead> createLeadTestData(){
        
        List<Lead> leadlist = new List<Lead>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
        Lead l = new Lead();
        l.Phone = '(123) 456-7890';
        l.project_name__c = 'Test Proj';
        l.FirstName = 'testfirst' + i;
        l.LastName = 'testlast';
        l.PostalCode = '08619';
        l.CountryCode = 'US';
        l.Type_of_record__c = 'Commercial';
        l.Project_Application_Industry__c = 'Automotive';
        l.Project_Application__c = 'Dealership';
        l.Project_Site_Zip_Code__c= '94040';
        leadlist.add(l);  
        }
        return leadlist ;
        
    }
    
    public static list<OpportunityContactRole> createOppConRoleTestData(list<Opportunity> olstOpportunity , list<Contact> olstContact){
        
        List<OpportunityContactRole> oppConRolelist = new List<OpportunityContactRole>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
         OpportunityContactRole oppConRole = new OpportunityContactRole();
         oppConRole.ContactId = olstContact[i].Id ;
         oppConRole.OpportunityId = olstOpportunity[i].Id ;
         oppConRolelist.add(oppConRole);
        }
        return oppConRolelist ;
        
    }
    
    public static list<nrOpportunityContactRole__c> createOppConRTestData(list<Opportunity> olstOpportunity , list<Contact> olstContact){
        
        List<nrOpportunityContactRole__c> oppConRolelist = new List<nrOpportunityContactRole__c>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
         nrOpportunityContactRole__c oppConRole = new nrOpportunityContactRole__c();
         oppConRole.Contact__c = olstContact[i].Id ;
         oppConRole.Opportunity__c = olstOpportunity[i].Id ;
         oppConRolelist.add(oppConRole);
        }
        return oppConRolelist ;
        
    }
    
    public static list<case> createCaseTestData(){
        
        list<case> caseList =  new list<case>();
        for(integer i=0; i<testDataSize; i++){
         case c = new case ();
         c.Origin = 'Phone';
         c.Status = 'New';
         c.Priority = 'Medium';
         //c.Send_Quote_To__c = 'End Customer';
         //c.Ship_To__c = 'End Customer';
         //c.Bill_To__c = 'End Customer'; 
         c.subject = 'Test';
         c.Description = 'Test Description'; 
         caseList.add(c);             
        }
        return caseList;
    }
    
     

    public static list<Opportunity> createOppTestData(){
        
        List<Opportunity> oppslist = new List<Opportunity>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
        Opportunity o = new Opportunity();
        o.Name = 'Test Opp CompetitorHelper_Test1' + i;
        o.StageName = 'Qualification';
        o.CloseDate = Date.today();
        o.Country__c = 'USA';
        o.Postal_Code__c = 'TEST';
        oppslist.add(o);  
        }
        return oppslist ;
        
    }
    public static list<OpportunityTeamMember> createoppteammember(list<Opportunity> olstOpportunity){
        list<OpportunityTeamMember> otm =new list<OpportunityTeamMember> ();
        OpportunityTeamMember team =new OpportunityTeamMember();
        team.OpportunityId =olstOpportunity[0].Id ;
       
        otm.add(team);
        return otm;
            
        }
        
                     
    public static list<Quote__c> createQuoteRecords(list<Opportunity> olstOpportunity) {
        
        list<Quote__c> lstQuote = new list<Quote__c>();
        
        for (Integer i= 0 ; i < olstOpportunity.size() ; i++){
            Quote__c q = new Quote__c();
            q.Name = 'Test Quote' + i;
            q.Opportunity__c = olstOpportunity[i].Id;
            q.Primary_Quote__c=True;
            lstQuote.add(q);
        }
        
        return lstQuote;
    }
    
    public static list<Project__c> createProjectTestData(){
        
        list<Project__c> projlst = new list<Project__c>();
        
        for (Integer i= 0 ; i < testDataSize ; i++){
             Project__c p1 = new Project__c();
           // p1.recordtypeId='012K0000000DKP0IAO';
             p1.Name = 'Test Project CompetitorHelper_Test' + i;
             p1.Application__c = 'Automotive';
             p1.Application_2__c = 'Dealership';
             p1.Project_Zip_Code__c = '94040' ;
             
             projlst.add(p1);
        }
        return projlst ;
    }
    
    public static list<order> createOrderTestData(){
        
                
        list<Order> orderList = new list<Order>();
        
        for(integer i=0; i < testDataSize; i++){
            order o = new order();
            o.Status = 'draft';
            o.EffectiveDate = system.today();
            orderList.add(o);
        }
        return orderList;
    }
    
    public static list<Installation__c> createInsTestData(){
        
                
        list<Installation__c> insList = new list<Installation__c>();
        
        for(integer i=0; i < testDataSize; i++){
            Installation__c ins = new Installation__c();
            ins.Status__c = 'Accepted by Installer' ;
            ins.Installation_Date__c = system.today() ;
            //ins.Order__c = orderList[i].id;
            insList.add(ins);
        }
        return insList;
    }
    
    public static list<Competitor_Detail__c> createcompDetailTestData(list < Opportunity > lstOpportunity, list < Project__c > lstProject) {
        
        list<Competitor_Detail__c> compDetaillst = new list<Competitor_Detail__c>(); 
        
        for (Integer i= 0 ; i < testDataSize ; i++){
           Competitor_Detail__c cmpdt = new Competitor_Detail__c();
           cmpdt.Project__c = lstProject[i].Id;
           cmpdt.Opportunity__c = lstOpportunity[i].Id;
           compDetaillst.add(cmpdt) ;
        }
        return compDetaillst ;
    }
    
    public static list < Country_codes__c > getTestCountryCodes() {
        
     list<Country_codes__c> lstCountryCodes = new list<Country_codes__c>();
     
     Country_codes__c couCode1 = new Country_codes__c();
     couCode1.Name = 'US';
     couCode1.Country__c = 'United States';
     lstCountryCodes.add(couCode1);
     
     Country_codes__c couCode2 = new Country_codes__c();
     couCode2.Name = 'CA';
     couCode2.Country__c = 'Canada';
     lstCountryCodes.add(couCode2);
      
     Country_codes__c couCode3 = new Country_codes__c();
     couCode3.Name = 'MX';
     couCode3.Country__c = 'Mexico';
     lstCountryCodes.add(couCode3);
     
     Country_codes__c couCode4 = new Country_codes__c();
     couCode4.Name = 'IN';
     couCode4.Country__c = 'India';
     lstCountryCodes.add(couCode4);
     
     Country_codes__c couCode5 = new Country_codes__c();
     couCode5.Name = 'AF';
     couCode5.Country__c = 'Afghanistan';
     lstCountryCodes.add(couCode5);
     
        return lstCountryCodes ;
     
    }
    
     public static list < state_codes__c > getTestStateCodes() {
        
     list<state_codes__c> lstStateCodes = new list<state_codes__c>();
     
     state_codes__c statCode1 = new state_codes__c();
     statCode1.Name = 'CO';
     statCode1.States__c = 'Coahuila';
     lstStateCodes.add(statCode1);
         
     state_codes__c statcode2 = new state_codes__c();
     statCode2.Name = 'CA';
     statCode2.States__c = 'California';
     lstStateCodes.add(statcode2);
         
     return lstStateCodes ;
     
    }
    
    public static list<HardCodingUtility__c> getHardCodingUtility(){
        
        list<HardCodingUtility__c> lsthardcodeingUtil = new list<HardCodingUtility__c>();
        
        HardCodingUtility__c hcu1 = new HardCodingUtility__c();
        hcu1.Name = 'LeadClosedWonStatus';
        hcu1.Value__c = 'Closed/Won';
        lsthardcodeingUtil.add(hcu1);
        
        return lsthardcodeingUtil ;
        
    }
    
    public static list<opp_proj_stages__c> getProjectStages(){
        
        list<opp_proj_stages__c> lstProjStages = new list<opp_proj_stages__c>();
        
        opp_proj_stages__c projStage1 = new opp_proj_stages__c();
        projStage1.Name = 'Closed/Won' ;
        projStage1.Proj_Stages__c = 'Closed Won - Order Signed,Closed';
        lstProjStages.add(projStage1);
        
        opp_proj_stages__c projStage2 = new opp_proj_stages__c();
        projStage2.Name = 'Closed/Lost' ;
        projStage2.Proj_Stages__c = 'Closed Lost - Project Lost,Proje';
        lstProjStages.add(projStage2);
        
        opp_proj_stages__c projStage3 = new opp_proj_stages__c();
        projStage3.Name = 'Quote - Negotiation/Review' ;
        projStage3.Proj_Stages__c = 'Bidding,Awarded';
        lstProjStages.add(projStage3);
        
        opp_proj_stages__c projStage4 = new opp_proj_stages__c();
        projStage4.Name = 'Quote - Requested' ;
        projStage4.Proj_Stages__c = 'Quoted';
        lstProjStages.add(projStage4);
        
        return lstProjStages ;
        
    }
    
    public static list<Zip_Codes_Master__c> getTerritoryMaster(){
       
        list<Zip_Codes_Master__c> lstzipCode = new list<Zip_Codes_Master__c>();
        User testUser = TestDataUtility.createUser('System Administrator','test@testingupdate.com');
        insert testUser;
        Zip_Codes_Master__c zipCode1 = new Zip_Codes_Master__c();
        zipCode1.City__c = 'Stow';
        zipCode1.Country__c = 'United States';
        zipCode1.State__c = 'Maine';
        zipCode1.Zip_Code__c = '12345' ;
        
        Zipcode1.User__c= testuser.id;
        lstzipCode.add(zipCode1);
        
        Zip_Codes_Master__c zipCode6 = new Zip_Codes_Master__c();
        zipCode6.City__c = 'Stow';
        zipCode6.Country__c = 'United States';
        zipCode6.State__c = 'colorodo';
        zipCode6.Zip_Code__c = '08619' ;
        
        Zipcode6.User__c= testuser.id;
        lstzipCode.add(zipCode6);
        
        Zip_Codes_Master__c zipCode7 = new Zip_Codes_Master__c();
        zipCode7.City__c = 'Stow';
        zipCode7.Country__c = 'United States';
        zipCode7.State__c = 'california';
        zipCode7.Zip_Code__c = '94040' ;
        
        Zipcode7.User__c= testuser.id;
        lstzipCode.add(zipCode7);
        
         Zip_Codes_Master__c zipCode8 = new Zip_Codes_Master__c();
        zipCode8.City__c = 'Stow';
        zipCode8.Country__c = 'United States';
        zipCode8.State__c = 'california';
        zipCode8.Zip_Code__c = '94941' ;
        
        Zipcode8.User__c= testuser.id;
        lstzipCode.add(zipCode8);
        
        
        Zip_Codes_Master__c zipCode2 = new Zip_Codes_Master__c();
        zipCode2.Country__c = 'Canada';
        zipCode2.Zip_Code__c = 'V0M 9S9' ;
        zipCode2.User__c = testuser.id;
        lstzipCode.add(zipCode2);
        
        Zip_Codes_Master__c zipCode4 = new Zip_Codes_Master__c();
        zipCode4.Country__c = 'Canada';
        zipCode4.Zip_Code__c = 'V0M' ;
        zipCode4.User__c =testuser.id;
        lstzipCode.add(zipCode4);
        
        Zip_Codes_Master__c zipCode3 = new Zip_Codes_Master__c();
        zipCode3.Country__c = 'Mexico';
        zipCode3.Zip_Code__c = 'nmm' ;
        zipCode3.State__c = 'Coahuila';
        zipCode3.User__c = testuser.id;
        lstzipCode.add(zipCode3);
        return lstzipCode ;
        
        Zip_Codes_Master__c zipCode5 = new Zip_Codes_Master__c();
        zipCode5.Country__c = 'India';
        //zipCode5.Zip_Code__c = '' ;
        //zipCode5.State__c = 'Coahuila';
        zipCode5.User__c = testuser.id;
        lstzipCode.add(zipCode5);
        return lstzipCode ;
        
        
    }
    
    public static list<Service_Quote_Detail__c> createserviceQuoteDetailTestData(){
        
        List<Service_Quote_Detail__c> sqList = new List<Service_Quote_Detail__c>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
        Service_Quote_Detail__c sq = new Service_Quote_Detail__c();
        sq.Discount__c = 10;
        sq.Freight__c = 20;
        sq.Unit_Price__c = 120;
        sq.Quantity__c = 1;
        sqList.add(sq);  
        }
        return sqList ;
        
    }
    
    public static list<Service_Quote__c> createServiceQuoteTestData(){
    
        list<Service_Quote__c> sqlist =  new list<Service_Quote__c>();
        
        for(Integer i= 0 ; i < testDataSize ; i++){
        Service_Quote__c sq = new Service_Quote__c();
        sq.Total_Amount__c = 134;
        sq.Discount__c = 20;
        sqlist.add(sq);       
        }
        return sqList;   
    }
    
     public static list<Service_Part__c> createServicePartTestData(){
        
        List<Service_Part__c> spList = new List<Service_Part__c>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
        Service_Part__c spart = new Service_Part__c();
        spart.Part_Name__c = 'Handle';
        spart.Name = 'Test';
        spList.add(spart);  
        }
        return spList ;
        
    }
    
    public static list<CaseTeamRole> createCaseTeamRoleTestData(){
        
        List<CaseTeamRole> CTRList = new List<CaseTeamRole>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
        CaseTeamRole CTR = new CaseTeamRole();
        CTR.AccessLevel = 'Edit';
        CTR.Name = 'Test Case Team Role';
        CTR.PreferencesVisibleInCSP = true;  
        CTRList.add(CTR);
        }
        return CTRList ;
        
    }
    
    /*****CASE TEAM MEMBER DATA*******/
    public static list<CaseComment> createCaseCommentTestData(){
        
        List<CaseComment> caseCommentList = new List<CaseComment>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
        CaseComment cc = new CaseComment();
        cc.CommentBody = 'Hello ';
        cc.IsPublished = true;
        caseCommentList.add(cc);
        }
        return caseCommentList ;
        
    }
    /****Email Message Data****/
    public static list<EmailMessage> createEmailMessageTestData(){
        
        List<EmailMessage> emailList = new List<EmailMessage>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
        EmailMessage email = new EmailMessage();
        email.Subject = 'Testing Email';
        emailList.add(email);
        
        }
        return emailList ;
        
    }
    
    /****Email Message Data****/
    public static list<Attachment> createAttachmentTestData(){
        
        List<Attachment> attachList = new List<Attachment>();
       
        for (Integer i= 0 ; i < testDataSize ; i++){
        Attachment attach = new Attachment();
        attach.Body = Blob.valueOf('Unit Test Attachment Body');
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.Name = 'test attach';
        attachList.add(attach);
        
        }
        return attachList ;
        
    }
    
    //Creating data for Quote details
    public static list<Quote_Detail__c> createQuoteDetailData(){
        List<Quote_Detail__c> qDetail = new List<Quote_Detail__c>();
        
        for(integer i = 0; i < testDataSize ; i++){
        Quote_Detail__c qd = new Quote_Detail__c();
        qd.Model__c = 'WA63';   
        qDetail.add(qd);    
        }
        return qDetail;
    }
    
    //Creating test data for Order details 
    public static list<OrderItem> createOrderItemData(){
        List<OrderItem> OrderItemList = new List<OrderItem>();
        for(integer i = 0; i < testDataSize ; i++){
        OrderItem oItem = new OrderItem();
        oItem.UnitPrice = 1000;
        oItem.Quantity = 2;  
        OrderItemList.add(oItem);    
        }
        return OrderItemList;
    }
    //Creating test data for products
    public static list<Product2> createProductData(){
        List<Product2> prdctList = new List<Product2>();
        for(integer i = 0; i < testDataSize ; i++){
        Product2 pdt = new Product2();
        pdt.Name = 'WA67';   
        prdctList.add(pdt);    
        }
        return prdctList;
    }
    //Creating test data for Manufacturing orders
    public static list<Manufacturing_Order__c> createManufacturingOrder(){
        List<Manufacturing_Order__c> mOrderList = new List<Manufacturing_Order__c>();
        for(integer i = 0; i < testDataSize ; i++){
        Manufacturing_Order__c pdt = new Manufacturing_Order__c();
      //  pdt.Name = 'Test';
        mOrderList.add(pdt);    
        }
        return mOrderList;
    }
    public static list<Manufacturing_Order_Position__c> createManufacturingOrderPosition(){
        List<Manufacturing_Order_Position__c> mOrderPositionList = new List<Manufacturing_Order_Position__c>();
        for(integer i = 0; i < testDataSize ; i++){
        Manufacturing_Order_Position__c mPosition = new Manufacturing_Order_Position__c();
        mPosition.Name = 'Test';
        mOrderPositionList.add(mPosition);    
        }
        return mOrderPositionList;
    }
     public static list<Shipping_Order__c> createShippingOrderData(){
        List<Shipping_Order__c> sOrderList = new List<Shipping_Order__c>();
        for(integer i = 0; i < testDataSize ; i++){
        Shipping_Order__c sOrder = new Shipping_Order__c();
        //sOrder.Name = 'Test';
        sOrderList.add(sOrder);    
        }
        return sOrderList;
    }
    
    
    }