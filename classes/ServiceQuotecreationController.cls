public with sharing class ServiceQuotecreationController {


    public String contactId {
        get;
        set;
    }
    public String AccountId {
        get;
        set;
    }
    public contact cont {
        get;
        set;
    }

    public boolean ShowProj {
        get;
        set;
    }
    public boolean showOutputfieldToFill {
        get;
        set;
    }
    public boolean showOutputfieldToFillShipping {
        get;
        set;
    }
    public boolean createNewContact {
        get;
        set;
    }

    public boolean createNewAccount {
        get;
        set;
    }
    public boolean showconmatch {
        get;
        set;
    }
    public boolean showconmatchShipping {
        get;
        set;
    }

    public Contact con {
        get;
        set;
    }
    public
    case caseDetails {
        get;
        set;
    }
    public Account acc {
        get;
        set;
    }
    public Service_Quote__c sq {
        get;
        set;
    }
    public Service_Quote__c sqCustom {
        get;
        set;
    }

    public contact contac {
        get;
        set;
    }
    Public Quote__c Quot {
        get;
        set;
    }
    public Account Acct {
        get;
        set;
    }
    public boolean urlPass{
        get;
        set;
    }
    public boolean displayAccSelectiononContact {
    get;set;
    }
    public List < SelectOption > getContactOption() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Existing Contact', 'Existing Contact'));
        options.add(new SelectOption('New Contact', 'New Contact'));
        return options;
    }

    public List < SelectOption > getAccountOption() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Attach To Existing Account', 'Attach To Existing Account'));
        options.add(new SelectOption('New Account', 'New Account'));
        return options;
    }

    public String contactCreateOption {
        get;
        set;
    }
    public string accountCreateOption {
        get;
        set;
    }

    public String caseId {
        get;
        set;
    }
    public String UseAddress {
        get;
        set;
    }
    public String UseAddressshipping {
        get;
        set;
    }
    public Project__c pro {
        get;
        set;
    }
    public boolean disableAccountSection {
        get;
        set;
    }
    public boolean showHideSelectShip {
        get;
        set;
    }
    public boolean showHideSelectBill {
        get;
        set;
    }
    public boolean newConShowHide {
        get;
        set;
    }
    public boolean newAccShowHide {
        get;
        set;
    }
    public boolean showHideProjectDummy {
        get;
        set;
    }
    public boolean existingConMatch {
        get;
        set;
    }
    public Contact contactData;
    public EntitlementContact ec ;
    public Account accountData;
    public case caseUpdate;
    Public string contactShopifyId;
    public boolean checkAccMate;
    
    public ServiceQuotecreationController() {
        checkAccMate =true;
        displayAccSelectiononContact =true;
        urlPass=false;
        showHideProjectDummy = true;
        showHideSelectShip =true;
        showHideSelectBill =true;
        disableAccountSection = true;
        showOutputfieldToFill = false;
        showOutputfieldToFillShipping = false;
        createNewAccount = false;
        createNewContact = false;
        showconmatch = false;
        showconmatchShipping = false;
        ShowProj = false;
        newConShowHide=false;
        newAccShowHide = false;
        existingConMatch = false;
        contactCreateOption = 'Existing Contact';
        accountCreateOption = 'Attach To Existing Account';
        con = new Contact(mailingCountryCode = 'US');
        pro = new Project__C(Project_Country__c = 'United States');
        acc = new Account(billingCountryCode = 'US');
        sq = new Service_Quote__C(Ship_Too_Country__c = 'United States', Bill_To_Country__c = 'United States');
        sqCustom = new Service_Quote__C();
        contactData = new Contact(); 
        ec = new EntitlementContact();
        accountData = new Account();
        contactShopifyId ='';
        caseId = System.currentPageReference().getParameters().get('CaseId');
        
        
        caseDetails = [select id, ProjectName__c,Quote__c, Category__c,Sub_Category__c,ContactID, AccountId, CaseNumber, status, type, Responsible_Rep__c, Quote__r.id, Quote__r.Order_Number__c, EntitlementId, Entitlement.name, Entitlement.enddate, Entitlement.startdate, Entitlement.warranty__c, Quote__r.Installer__r.name, Quote__r.install_date__c, Quote__r.Name, Quote__r.Project__r.Owner.Name from
            case where id = :
                caseId
        ];
        
        
        //contac = [select id, email, Phone from contact where id =: caseDetails.ContactID];
        
        string cId = caseDetails.ContactID;
            if(cId !='' && cId !=null){
            cont = [Select Id, Name, AccountId, Account.Name, FirstName, Phone, Email, LastName, MailingCountryCode, MailingStateCode, MailingStreet, MailingCity, MailingPostalCode from Contact where Id =: caseDetails.contactId];
             
             showHideSelectBill =true;
            }
            else{
                //disableAccountSection = true;
                showHideSelectBill =false;
                showOutputfieldToFill = true;
                    
            }
        
        string aId = caseDetails.AccountId;
            if(aId !='' && aId !=null){
            Acct = [select id, Name, Company_Email__c, BillingCountryCode, Email__c, Phone, BillingStateCode, BillingPostalCode, BillingCity, BillingStreet from Account where id =: caseDetails.AccountId];
            checkAccMate =false;
            }
            else if(cId!=null && aId==null ){
                displayAccSelectiononContact = false;
                disableAccountSection =false;
                //checkAccMate =false;
                
            }
        string qId = caseDetails.Quote__c;
            if(qId !='' && qId !=null){
            Quot = [select id, Address__c,Project__c, City__c, State__c, Zip__c, Country__c, Office_Phone__c, Email__c from Quote__c where ID =: caseDetails.Quote__c];
                showHideSelectShip =true;
                
                string pId =Quot.Project__c;
               if(pId !='' && pId !=null){
                   pro = [select id, Project_Street_Address__c, Project_City__c, Project_State__c, Project_Country__c, Project_Zip_Code__c from Project__c where id =: Quot.Project__c];
                   showHideProjectDummy = true;
               }
               
            }
            else{
                showHideSelectShip = false;
                showOutputfieldToFillShipping = true;
                showHideProjectDummy =false;
        
            }
         
        // sq =[select id , Ship_Too_Street__c Bill_Too_Street__c, Ship_Too_City__c, Bill_Too_City__c, Ship_Too_State__c, Bill_Too_State__c, Ship_Too_Country__c, Bill_To_Country__c, Ship_Too_Zip__c, Bill_Too_Zip__c, Ship_Too_phone__c, Bill_To_Phone__c, Ship_Too_Email__c, Bill_Too_Email__c from Service_Quote__c];
    }
    


    public PageReference updateAddressNew() {
     if (con.MailingCountryCode != null) {
            acc.BillingCountryCode = con.MailingCountryCode;
            acc.BillingStateCode = con.MailingStateCode;
            acc.BillingStreet = con.MailingStreet;
            acc.BillingCity = con.MailingCity;
            acc.BillingPostalCode = con.MailingPostalCode;
        }
    
        return null;
    }
    public PageReference setaddress() {
        system.debug('@@@@@@@@@' + con.FirstName);
        if (UseAddress == 'Other') {
            showOutputfieldToFill = true;
            showconmatch = false;
            ShowProj = false;
        } else if (UseAddress == '-SELECT-') {
            showOutputfieldToFill = false;
            showconmatch = false;
            ShowProj = false;
        } else if (UseAddress == 'cont') {

            showOutputfieldToFill = false;
            showconmatch = true;
            ShowProj = false;
            if (contactCreateOption == 'New Contact') {
                existingConMatch =false;
            }
            else{
                existingConMatch =true;
            }

        } else if (UseAddress == 'projectDummy') {
            ShowProj = true;
            showOutputfieldToFill = false;
            showconmatch = false;


        } else {}
        return null;
    }
    public PageReference setaddressshipping() {

        if (UseAddressshipping == 'Other') {
            showOutputfieldToFillShipping = true;
            showconmatchShipping = false;
            
        } else if (UseAddressshipping == '-SELECT-') {
            showconmatchShipping = false;
            showOutputfieldToFillShipping = false;
           

        } else if (UseAddressshipping == 'cont') {
            showOutputfieldToFillShipping = false;
            showconmatchShipping = true;
            if (contactCreateOption == 'New Contact') {
                newConShowHide =true;
            }else{
                newConShowHide =false;
            }
        } else {}
        return null;

    }

    public PageReference initializeContactCreateOption() {
        if (contactCreateOption == 'New Contact') {
            createNewContact = true;
            disableAccountSection = false;
            
            newConShowHide =true;
            
            if(accountCreateOption == 'Attach To Existing Account'){
                if(cont!=null){
                string c =Cont.AccountId;
                if(c!=null){
                showHideSelectBill = true;
                }
                }
            }else{
            showHideSelectBill = true;  
            }
            existingConMatch=false;
        } else {
            newAccShowHide =false;
            existingConMatch =true;
            createNewContact = false;
            if(cont!=null){
            string c =Cont.AccountId;
            if(c!=null && (displayAccSelectiononContact == true)){
            disableAccountSection = true;
            }
            }
            
            
            accountCreateOption = 'Attach To Existing Account';
            
            createNewAccount = false;
            newConShowHide=false;

        }
        return null;
    }

    public PageReference initializeAccountCreateOption() {
        if (accountCreateOption == 'Attach To Existing Account') {
            createNewAccount = false;
            newAccShowHide =false;

        } else {
            createNewAccount = true;
            newAccShowHide= true;
            showHideSelectBill = true;
        }
        return null;
    }
    public PageReference syncContact() {
        showHideSelectBill = true;
        contactId = '';
        contactId = System.currentPageReference().getParameters().get('contactId');
        if(contactId!='' && contactId!=null){
        cont = [Select Id, Name, AccountId, Account.Name, FirstName, Phone, Email, LastName, MailingCountryCode, MailingStateCode, MailingStreet, MailingCity, MailingPostalCode from Contact where Id =: contactId];
        string accId = cont.AccountId;
            if(accId!=null){
                Acct = [select id, Name, BillingCountryCode, Company_Email__c, Email__c, Phone, BillingStateCode, BillingPostalCode, BillingCity, BillingStreet from Account where id =: cont.AccountId];
                checkAccMate =false;
            }else{
                displayAccSelectiononContact= false;
                disableAccountSection =false;
            }
        }
        return null;
        
    }
    public PageReference syncAccount() {
        AccountId = '';
        AccountId = System.currentPageReference().getParameters().get('AccountId');
        //cont = [Select Id, Name, AccountId, Account.Name, FirstName, Phone, Email, LastName, MailingCountryCode, MailingStateCode, MailingStreet, MailingCity, MailingPostalCode from Contact where Id =: contactId];
        if(AccountId!='' && AccountId!=null){
        Acct = [select id, Name, BillingCountryCode, Company_Email__c, Email__c, Phone, BillingStateCode, BillingPostalCode, BillingCity, BillingStreet from Account where id =: AccountId];
        
        }
        showHideSelectBill = true;
        
        return null;
    }
    public PageReference ShopifyServiceQuote() {
        Boolean validate = validateButtons();
        
        if (validate == false) {
        return null;
        
        }else{
        
        if(accountCreateOption == 'New Account'){
        accountData.Name = acc.Name;
        //accountData.LastName = acc.LastName;
        accountData.BillingStreet = acc.BillingStreet;
        accountData.BillingCity = acc.BillingCity;
        accountData.BillingStateCode = acc.BillingStateCode;
        accountData.BillingCountryCode = acc.BillingCountryCode;
        accountData.BillingPostalCode = acc.BillingPostalCode;
        accountData.Phone = acc.Phone;
        accountData.Company_Email__c = acc.Company_Email__c;
        
        insert accountData;
        
        }
        if(contactCreateOption == 'New Contact'){
             
             contactData.FirstName = con.FirstName;
             contactData.LastName = con.LastName;
             contactData.mailingStreet = con.mailingStreet;
             contactData.MailingCity = con.MailingCity;
             contactData.mailingStateCode = con.mailingStateCode;
             contactData.mailingCountryCode = con.mailingCountryCode;
             contactData.mailingPostalCode = con.mailingPostalCode;
             contactData.Phone = con.Phone;
             contactData.Email = con.Email;
             if(accountCreateOption == 'Attach To Existing Account'){
             
                    if(Acct!=null && (displayAccSelectiononContact == false)){
                       
                    contactData.AccountID = Acct.ID;
                    }
                    else{
                    contactData.AccountID = Cont.AccountId;
                    
                    }
             }
             else{
             contactData.AccountID = accountData.Id;
             }
             
             /*Database.SaveResult srList = Database.insert(contactData, false);
              if(srList.isSuccess()){
              sqCustom.Send_Quote_To_Email__c = con.Email;
                  if(caseDetails.EntitlementId!=null&& caseDetails.EntitlementId!=''){
                  
                        ec.ContactId = contactData.ID;
                        ec.EntitlementId =caseDetails.EntitlementId;
                        insert ec;
                  }
              }*/
              insert contactData;
              
             system.debug('contactDataRecord'+contactData.ID);
             
             string conId = contactData.ID;
             if(conId !=''&& conId !=null){
             //sqCustom.Send_Quote_To_Email__c = con.Email;
             contactShopifyId =contactData.ID;
             string entitID =caseDetails.EntitlementId;
             if(entitID !=null && entitID !=''){
                   
                        ec.ContactId = contactData.ID;
                        ec.EntitlementId =caseDetails.EntitlementId;
                        try{
                            insert ec;
                        }catch (exception e){
                            
                        }
              }
              }

        }
        else{
            
            //system.debug('contactShopifyIdCheckmark'+caseDetails.ContactID);
            if(accountCreateOption == 'Attach To Existing Account'){
                if(cont!=null){
                //concheck = cont.AccountId;
                    if(Acct!=null && (displayAccSelectiononContact == false)){
                       
                        cont.AccountID =Acct.ID;
                        try{
                        update cont;
                        }
                        catch (exception e){}
                        
                        contactShopifyId = cont.ID;   
                    }
                    else{
                     contactShopifyId = caseDetails.ContactID;
                     }
                    
                    
                }
             }else if(accountCreateOption == 'New Account'){
                 if(displayAccSelectiononContact == false){
                        cont.AccountID =accountData.ID; 
                        try{
                        update cont;
                        }
                        catch (exception e){}
                     contactShopifyId = cont.ID;   
                 }
                 else{
                     contactShopifyId = caseDetails.ContactID;
                 }
             }
             else{
             contactShopifyId = caseDetails.ContactID;
             }
             
        }
        caseUpdate =[select id,Billing_City__c,Billing_Zipcode__c,Billing_Country__c,Billing_Street_End_Customer__c,Billing_State__c,Shipping_Street_End_Customer__c,Shipping_City_EndCustomer__c,Shipping_State_End_Customer__c,Shipping_Country__c,Shipping_Zip_End_Customer__c from case where id=:caseId];
        if (UseAddressshipping == '-SELECT-') {

            caseUpdate.Shipping_Street_End_Customer__c = Quot.Address__c;
            caseUpdate.Shipping_City_EndCustomer__c = Quot.City__c;
            caseUpdate.Shipping_State_End_Customer__c = Quot.State__c;
            caseUpdate.Shipping_Country__c = Quot.Country__c;
            caseUpdate.Shipping_Zip_End_Customer__c = Quot.Zip__c;
            caseUpdate.Other_Shipping_Phone__c = Quot.Office_Phone__c;
            caseUpdate.Other_Shipping_Email__c = Quot.Email__c;
            

        } else if (UseAddressshipping == 'Other') {
           
            caseUpdate.Shipping_Street_End_Customer__c = sq.Ship_Too_Street__c;
            caseUpdate.Shipping_City_EndCustomer__c = sq.Ship_Too_City__c;
            caseUpdate.Shipping_State_End_Customer__c = sq.Ship_To_State__c;
            caseUpdate.Shipping_Country__c = sq.Ship_Too_Country__c;
            caseUpdate.Shipping_Zip_End_Customer__c = sq.Ship_Too_Zip__c;
            caseUpdate.Other_Shipping_Phone__c = sq.Ship_Too_phone__c;
            caseUpdate.Other_Shipping_Email__c = sq.Ship_Too_Email__c;

        } else if (UseAddressshipping == 'cont') {
            if(contactCreateOption != 'New Contact'){
            caseUpdate.Shipping_Street_End_Customer__c = cont.mailingStreet;
            caseUpdate.Shipping_City_EndCustomer__c = cont.MailingCity;
            caseUpdate.Shipping_State_End_Customer__c = StateCodes__c.getInstance(cont.mailingStateCode).State__c;
            caseUpdate.Shipping_Country__c = country_codes__c.getInstance(cont.mailingCountryCode).Country__c;
            caseUpdate.Shipping_Zip_End_Customer__c = cont.mailingPostalCode;
            caseUpdate.Other_Shipping_Phone__c = cont.Phone;
            caseUpdate.Other_Shipping_Email__c = cont.Email;
            }else{
            caseUpdate.Shipping_Street_End_Customer__c = con.mailingStreet;
            caseUpdate.Shipping_City_EndCustomer__c = con.MailingCity;
            caseUpdate.Shipping_State_End_Customer__c = StateCodes__c.getInstance(con.mailingStateCode).State__c;
            caseUpdate.Shipping_Country__c = country_codes__c.getInstance(con.mailingCountryCode).Country__c;
            caseUpdate.Shipping_Zip_End_Customer__c = con.mailingPostalCode;
            caseUpdate.Other_Shipping_Phone__c = con.Phone;
            caseUpdate.Other_Shipping_Email__c = con.Email; 
            }

        }


        if (UseAddress == 'Other') {
            caseUpdate.Billing_Street_End_Customer__c = sq.Bill_Too_Street__c;
            caseUpdate.Billing_City__c = sq.Bill_Too_City__c;
            caseUpdate.Billing_State__c = sq.Other_Bill_To_State__c;
            caseUpdate.Billing_Country__c = sq.Bill_To_Country__c;
            caseUpdate.Billing_Zipcode__c = sq.Bill_Too_Zip__c;
            caseUpdate.Other_Phone__c = sq.Bill_To_Phone__c;
            caseUpdate.Other_Email__c = sq.Bill_Too_Email__c;
        } else if (UseAddress == '-SELECT-') {
            if(accountCreateOption != 'New Account'){
            caseUpdate.Billing_Street_End_Customer__c = Acct.BillingStreet;
            caseUpdate.Billing_City__c = Acct.BillingCity;
            caseUpdate.Billing_State__c = StateCodes__c.getInstance(Acct.BillingStateCode).State__c;
            caseUpdate.Billing_Country__c = country_codes__c.getInstance(Acct.BillingCountryCode).Country__c;
            caseUpdate.Billing_Zipcode__c = Acct.BillingPostalCode;
            caseUpdate.Other_Phone__c = Acct.Phone;
            caseUpdate.Other_Email__c = Acct.Company_Email__c;
            }else{
            caseUpdate.Billing_Street_End_Customer__c = Acc.BillingStreet;
            caseUpdate.Billing_City__c = Acc.BillingCity;
            caseUpdate.Billing_State__c = StateCodes__c.getInstance(Acc.BillingStateCode).State__c;
            caseUpdate.Billing_Country__c = country_codes__c.getInstance(Acc.BillingCountryCode).Country__c;
            caseUpdate.Billing_Zipcode__c = Acc.BillingPostalCode;
            caseUpdate.Other_Phone__c = Acc.Phone;
            caseUpdate.Other_Email__c = Acc.Company_Email__c;   
            }
        } else if (UseAddress == 'cont') {
            if(contactCreateOption == 'New Contact'){
            caseUpdate.Billing_Street_End_Customer__c = con.mailingStreet;
            caseUpdate.Billing_City__c = con.MailingCity;
            caseUpdate.Billing_State__c = StateCodes__c.getInstance(con.mailingStateCode).State__c;
            caseUpdate.Billing_Country__c = country_codes__c.getInstance(con.mailingCountryCode).Country__c;
            caseUpdate.Billing_Zipcode__c = con.mailingPostalCode;
            caseUpdate.Other_Phone__c = con.Phone;
            caseUpdate.Other_Email__c = con.Email;
            }else{
            caseUpdate.Billing_Street_End_Customer__c = cont.mailingStreet;
            caseUpdate.Billing_City__c = cont.MailingCity;
            caseUpdate.Billing_State__c = StateCodes__c.getInstance(cont.mailingStateCode).State__c;
            caseUpdate.Billing_Country__c = country_codes__c.getInstance(cont.mailingCountryCode).Country__c;
            caseUpdate.Billing_Zipcode__c = cont.mailingPostalCode;
            caseUpdate.Other_Phone__c = cont.Phone;
            caseUpdate.Other_Email__c = cont.Email; 
            }

        } else if (UseAddress == 'projectDummy') {
            caseUpdate.Billing_Street_End_Customer__c = pro.Project_Street_Address__c;
            caseUpdate.Billing_City__c = pro.Project_City__c;
            caseUpdate.Billing_State__c = pro.Project_State__c;
            caseUpdate.Billing_Country__c = pro.Project_Country__c;
            caseUpdate.Billing_Zipcode__c = pro.Project_Zip_Code__c;
            caseUpdate.Other_Phone__c = '';
            caseUpdate.Other_Email__c = '';
        }
        //update caseUpdate;
        Database.SaveResult srList = Database.update(caseUpdate, false);
                  if(srList.isSuccess()){
                      ShopifyCustomerCreationNew.CustomerCreation(caseId,contactShopifyId);
                       urlPass =true;
                  }
              
        
        //ShopifyCustomerCreationNew.CustomerCreation(caseId,contactShopifyId);
       
       // string x = 'https://nanawall-parts-service.myshopify.com/admin/draft_orders/new' ;
        /*PageReference pg = new PageReference('https://nanawall-parts-service.myshopify.com/admin/draft_orders/new');
        pg.setRedirect(true);
        return pg;*/
        return null;
        }
        
    }


    public PageReference CustomServiceQuote() {
        //Service_Quote__c  sq = new Service_Quote__c();
         Boolean validate = validateButtons();
        
        if(validate == false) {
        return null;
        }
        else{
        if(accountCreateOption == 'New Account'){
        accountData.Name = acc.Name;
        accountData.BillingStreet = acc.BillingStreet;
        accountData.BillingCity = acc.BillingCity;
        accountData.BillingStateCode = acc.BillingStateCode;
        accountData.BillingCountryCode = acc.BillingCountryCode;
        accountData.BillingPostalCode = acc.BillingPostalCode;
        accountData.Phone = acc.Phone;
        accountData.Company_Email__c = acc.Company_Email__c;
        //accountData.RecordTypeId =Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        insert accountData;
        
        }
        if(contactCreateOption == 'New Contact'){
             
             contactData.FirstName = con.FirstName;
             contactData.LastName = con.LastName;
             contactData.mailingStreet = con.mailingStreet;
             contactData.MailingCity = con.MailingCity;
             contactData.mailingStateCode = con.mailingStatecode;
             contactData.mailingCountryCode = con.mailingCountryCode;
             contactData.mailingPostalCode = con.mailingPostalCode;
             contactData.Phone = con.Phone;
             contactData.Email = con.Email;
             if(accountCreateOption == 'Attach To Existing Account'){
                if(cont!=null){
                //concheck = cont.AccountId;
                    if(Acct!=null && (displayAccSelectiononContact == false)){
                       
                        contactData.AccountID =Acct.ID;
                    }
                    else{
                    contactData.AccountID = Cont.AccountId;
                    
                    }
                }
             }
             else if(accountCreateOption == 'New Account'){
             contactData.AccountID = accountData.Id;
             }
             
             
             /*Database.SaveResult srList = Database.insert(contactData, false);
              if(srList.isSuccess()){
              sqCustom.Send_Quote_To_Email__c = con.Email;
                  if(caseDetails.EntitlementId!=null&& caseDetails.EntitlementId!=''){
                   
                        ec.ContactId = contactData.ID;
                        ec.EntitlementId =caseDetails.EntitlementId;
                        insert ec;
                  }
              }*/
              
              
             
             insert contactData;
             system.debug('contactDataRecord'+contactData.ID);
             
             string conId = contactData.ID;
             if(conId !=''&& conId !=null){
             
             sqCustom.Send_Quote_To_Email__c = con.Email;
             sqCustom.Send_Quote_To_Contact__c = contactData.id;
            
             
             string entitID =caseDetails.EntitlementId;
             if(entitID !=null && entitID !=''){
                   
                        ec.ContactId = contactData.ID;
                        ec.EntitlementId =caseDetails.EntitlementId;
                        try{
                            insert ec;
                        }catch (exception e){
                            
                        }
                        
              }
              }
             
        }else if(contactCreateOption == 'Existing Contact'){
            sqCustom.Send_Quote_To_Email__c = cont.Email;
            sqCustom.Send_Quote_To_Contact__c = caseDetails.ContactID;
            
            if(accountCreateOption == 'Attach To Existing Account'){
                if(cont!=null){
                //concheck = cont.AccountId;
                    if(Acct!=null && (displayAccSelectiononContact == false)){
                       
                        cont.AccountID =Acct.ID;
                        try{
                        update cont;
                        }
                        catch (exception e){}
                    }
                    
                }
             }else{
                 if(displayAccSelectiononContact == false){
                        cont.AccountID =accountData.ID; 
                        try{
                        update cont;
                        }
                        catch (exception e){}
                        
                 }
             }
            
        }
        
        if (UseAddressshipping == '-SELECT-') {

            sqCustom.Ship_Too_Street__c = Quot.Address__c;
            sqCustom.Ship_Too_City__c = Quot.City__c;
            sqCustom.Ship_To_State__c = Quot.State__c;
            sqCustom.Ship_Too_Country__c = Quot.Country__c;
            sqCustom.Ship_Too_Zip__c = Quot.Zip__c;
            sqCustom.Ship_Too_phone__c = Quot.Office_Phone__c;
            sqCustom.Ship_Too_Email__c = Quot.Email__c;
            

        } else if (UseAddressshipping == 'Other') {
            system.debug('SQDTATAFROMPAGE' + sq);
            sqCustom.Ship_Too_Street__c = sq.Ship_Too_Street__c;
            sqCustom.Ship_Too_City__c = sq.Ship_Too_City__c;
            sqCustom.Ship_To_State__c = sq.Ship_To_State__c;
            sqCustom.Ship_Too_Country__c = sq.Ship_Too_Country__c;
            sqCustom.Ship_Too_Zip__c = sq.Ship_Too_Zip__c;
            sqCustom.Ship_Too_phone__c = sq.Ship_Too_phone__c;
            sqCustom.Ship_Too_Email__c = sq.Ship_Too_Email__c;

        } else if (UseAddressshipping == 'cont') {
            if(contactCreateOption != 'New Contact'){
            sqCustom.Ship_Too_Street__c = cont.mailingStreet;
            sqCustom.Ship_Too_City__c = cont.MailingCity;
            
            sqCustom.Ship_To_State__c = StateCodes__c.getInstance(cont.mailingStateCode).State__c;
            
            sqCustom.Ship_Too_Country__c = country_codes__c.getInstance(cont.mailingCountryCode).Country__c;
            sqCustom.Ship_Too_Zip__c = cont.mailingPostalCode;
            sqCustom.Ship_Too_phone__c = cont.Phone;
            sqCustom.Ship_Too_Email__c = cont.Email;
            }else{
            sqCustom.Ship_Too_Street__c = con.mailingStreet;
            sqCustom.Ship_Too_City__c = con.MailingCity;
            
            
            
            
            sqCustom.Ship_To_State__c = StateCodes__c.getInstance(con.mailingStateCode).State__c;
            
            sqCustom.Ship_Too_Country__c = country_codes__c.getInstance(con.mailingCountryCode).Country__c;
            sqCustom.Ship_Too_Zip__c = con.mailingPostalCode;
            sqCustom.Ship_Too_phone__c = con.Phone;
            sqCustom.Ship_Too_Email__c = con.Email;
            }

        }


        if (UseAddress == 'Other') {
            sqCustom.Bill_Too_Street__c = sq.Bill_Too_Street__c;
            sqCustom.Bill_Too_City__c = sq.Bill_Too_City__c;
            sqCustom.Other_Bill_To_State__c = sq.Other_Bill_To_State__c;
            sqCustom.Bill_To_Country__c = sq.Bill_To_Country__c;
            sqCustom.Bill_Too_Zip__c = sq.Bill_Too_Zip__c;
            sqCustom.Bill_To_Phone__c = sq.Bill_To_Phone__c;
            sqCustom.Bill_Too_Email__c = sq.Bill_Too_Email__c;
        } else if (UseAddress == '-SELECT-') {
            if(accountCreateOption != 'New Account'){
            sqCustom.Bill_Too_Street__c = Acct.BillingStreet;
            sqCustom.Bill_Too_City__c = Acct.BillingCity;
            sqCustom.Other_Bill_To_State__c = StateCodes__c.getInstance(Acct.BillingStateCode).State__c;
            sqCustom.Bill_To_Country__c = country_codes__c.getInstance(Acct.BillingCountryCode).Country__c;
            sqCustom.Bill_Too_Zip__c = Acct.BillingPostalCode;
            sqCustom.Bill_To_Phone__c = Acct.Phone;
            sqCustom.Bill_Too_Email__c = Acct.Company_Email__c;
            }
            else{
            sqCustom.Bill_Too_Street__c = Acc.BillingStreet;
            sqCustom.Bill_Too_City__c = Acc.BillingCity;
            sqCustom.Other_Bill_To_State__c = StateCodes__c.getInstance(Acc.BillingStateCode).State__c;
            sqCustom.Bill_To_Country__c = country_codes__c.getInstance(Acc.BillingCountryCode).Country__c;
            sqCustom.Bill_Too_Zip__c = Acc.BillingPostalCode;
            sqCustom.Bill_To_Phone__c = Acc.Phone;
            sqCustom.Bill_Too_Email__c = Acc.Company_Email__c;  
            }
            
        } else if (UseAddress == 'cont') {
            if(contactCreateOption == 'New Contact'){
            sqCustom.Bill_Too_Street__c = con.mailingStreet;
            sqCustom.Bill_Too_City__c = con.MailingCity;
            sqCustom.Other_Bill_To_State__c = StateCodes__c.getInstance(con.mailingStateCode).State__c;
            sqCustom.Bill_To_Country__c = country_codes__c.getInstance(con.mailingCountryCode).Country__c;
            sqCustom.Bill_Too_Zip__c = con.mailingPostalCode;
            sqCustom.Bill_To_Phone__c = con.Phone;
            sqCustom.Bill_Too_Email__c = con.Email;
            }else{
            sqCustom.Bill_Too_Street__c = cont.mailingStreet;
            sqCustom.Bill_Too_City__c = cont.MailingCity;
            sqCustom.Other_Bill_To_State__c = StateCodes__c.getInstance(cont.mailingStateCode).State__c;
            sqCustom.Bill_To_Country__c = country_codes__c.getInstance(cont.mailingCountryCode).Country__c;
            sqCustom.Bill_Too_Zip__c = cont.mailingPostalCode;
            sqCustom.Bill_To_Phone__c = cont.Phone;
            sqCustom.Bill_Too_Email__c = cont.Email;
            }
           

        } else if (UseAddress == 'projectDummy') {
            sqCustom.Bill_Too_Street__c = pro.Project_Street_Address__c;
            sqCustom.Bill_Too_City__c = pro.Project_City__c;
            sqCustom.Other_Bill_To_State__c = pro.Project_State__c;
            sqCustom.Bill_To_Country__c = pro.Project_Country__c;
            sqCustom.Bill_Too_Zip__c = pro.Project_Zip_Code__c;
            sqCustom.Bill_To_Phone__c = '';
            sqCustom.Bill_Too_Email__c = '';
        }
        sqCustom.Case__c = caseDetails.id;
        sqCustom.Quote__c = caseDetails.Quote__c;
        sqCustom.Category__c = caseDetails.Category__c;
        sqCustom.Sub_Category__c = caseDetails.Sub_Category__c;
            if(accountCreateOption == 'Attach To Existing Account'){
                if(cont!=null){
                 if(Acct!=null && (displayAccSelectiononContact == false)){
                        //contactData.AccountID =Acct.ID;
                        sqCustom.Ship_Too_Company_Name__c = Acct.name;
                    }
                    else{
                    //contactData.AccountID = Cont.AccountId;
                    sqCustom.Ship_Too_Company_Name__c = Cont.Account.name;
                    }
             
                }
             }
             else if(accountCreateOption == 'New Account'){
             //contactData.AccountID = accountData.Id;
             sqCustom.Ship_Too_Company_Name__c = accountData.Name;
             }

        insert sqCustom;



        String url = '/' + sqCustom.id;
        PageReference redUrl = new PageReference(url);
        redUrl.setRedirect(true);
        return redUrl;
        }

    }
     public boolean validateButtons() {
       set<string> zipsAll = new set<string>();
        set<string> conzips = new set<string>();
        boolean Validated = true;
        if (contactCreateOption != 'Existing Contact') {
            
            if(con.FirstName == null || con.FirstName == ''){
                Validated = false;
                con.FirstName.addError('You must enter a value');   
            }
            
            if(con.LastName == null || con.LastName == ''){
                Validated = false;
                con.LastName.addError('You must enter a value');    
            }
            
             if(con.Email == null || con.LastName == ''){
                Validated = false;
                con.Email.addError('You must enter a value');   
            }
            
            /*if(con.MailingPostalCode == null || con.LastName == ''){
                Validated = false;
                con.MailingPostalCode.addError('You must enter a value');   
            }*/
            
            if(con.email != null){
            list<contact> conEmailList= [ select id, email from contact where email =: con.email];
            list<Lead> ledEmailList =[select id,email, IsConverted from lead where email =:con.email AND IsConverted != true];
            system.debug('size$$$$'+ conEmailList.size() + con.email);
            if(conEmailList.size()>0){
               validated= false;
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There is already an existing contact with the same email address. Please enter a different email address or select an existing contact'));
               }
             if(ledEmailList.size()>0){
             Validated = false;
             ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There is already an existing Lead with the same email address. Please enter a different email address.'));

             }
             
            }
            if (con.MailingCountryCode == 'MX' && (con.MailingStateCode == '' || con.MailingStateCode == null)) {
                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a state for the selected Contact Country'));
            }
            
            if (con.MailingCountryCode != '' && con.MailingCountryCode != null && con.MailingPostalCode != '' && con.MailingPostalCode != null && !(validateZip(con.MailingPostalCode, con.MailingCountryCode))) {

                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a valid zip Code for Contact'));
            }
           if ((con.MailingCountryCode =='US' || con.MailingCountryCode == 'CA') && (con.MailingPostalCode =='' || con.MailingPostalCode == null)) {
            System.debug('errot'+con.MailingCountryCode);
                Validated = false;
                con.MailingPostalCode.addError('You must enter a value');
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please Enter  zip Code for Selected Country'));
           }
           
          }
          else{
            string  accCheck = caseDetails.ContactID;
            if(accCheck == null ){
              Validated = false;
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'If you are using an existing Contact you must select a Contact.'));
            }
           
        }

        if (accountCreateOption == 'Attach To Existing Account') {
            string  concheck = '';
            string  concheck2 = '';
            if(cont!=null && acct!=null){
            system.debug('Internalcheck'+cont.AccountId);
            concheck = cont.AccountId;
            concheck2 = cont.Account.Name;
            }
            else if (acct == null){
                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select an Account'));
            }
            if (concheck == '' && concheck ==null &&( disableAccountSection ==false)) {
                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select an Account'));
            }
            if(concheck2 == '' && concheck2 ==null && (displayAccSelectiononContact == true)){
                 Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select an Account'));
            }
        }
        if (accountCreateOption != null && accountCreateOption != 'Attach To Existing Account') {

            

            if (acc.BillingCountryCode == 'MX' && (acc.BillingStateCode == null || acc.BillingStateCode == '')) {
                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a state for the selcted Account Country'));
            }

            if (acc.BillingCountryCode != '' && acc.BillingCountryCode != null && acc.BillingPostalCode != '' && acc.BillingPostalCode != null && !(validateZip(acc.BillingPostalCode, acc.BillingCountryCode))) {

                Validated = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select a valid zip Code for Account'));

            }
            if ( (acc.BillingCountryCode =='US' || acc.BillingCountryCode == 'CA') && (acc.BillingPostalCode =='' || acc.BillingPostalCode == null)) {
                Validated = false;
                acc.BillingPostalCode.addError('You must enter a value');
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please Enter  zip Code for Selected Country'));
           }
           
            
        }
        if(accountCreateOption != 'Attach To Existing Account' && contactCreateOption == 'Existing Contact'){
               if(checkAccMate ==false ){
                Validated = false;
                
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You can not select new Account for the existing contact'));
                }
        }
        
         return Validated;
     }
     public boolean validateZip(String zipCode, String CountryCode) {
        string zipUS = '\\d{5}(-\\d{4})?';
        string zipCan = '((?i)[ABCEGHJKLMNPRSTVXY]\\d[A-Z]?\\s?\\d[A-Z]\\d)?';

        Boolean returnValue = false;

        if (CountryCode != null && zipCode != null && ((CountryCode == 'US' && !(pattern.matches(ZipUS, zipCode))) || (CountryCode == 'CA' && !(pattern.matches(zipCan, zipCode))))) {

            returnValue = false;
        } else {
            returnValue = true;
        }

        return returnValue;

    }


}