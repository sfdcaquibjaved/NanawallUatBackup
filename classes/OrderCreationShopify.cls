/**********************************************************************
Apex Class: OrderCreationShopify
Description: This REST Web service class is to fetch the data from shopify 
             on Order Creation
Created Date: 18th April,2016            
***********************************************************************/
@RestResource(urlMapping = '/OrderCreation/*')
global without sharing class OrderCreationShopify {

   //Global Variables
   static string orderCreated = 'Order Created';
   static string orderPending = 'pending';
   static string orderPaid = 'Order Paid';
   static string caseOrigin = 'Web';
   static string caseStatus = 'New';
   static string casePriority = 'Medium';
   static string customer = 'End Customer';
   static string financialPaid = 'Paid';
   static string zip = '12345';
   static string shipzip = '12345';
   
   //This Method is used to Save Shopify Order in Salesforce
    @HttpPost
    global static void doPost() {
    
        // Local Variables       
        list < wrapperObjectShopify.Orders > ordList = new list < wrapperObjectShopify.Orders > ();
        string caseNo;
        string Notes;
        string orderEmail;
        list < case >caseInsert = new list < case >();
        list < service_quote__c > serviceQuoteDirectInsert = new list < service_quote__c > ();
        list < Service_Quote_detail__c > sqDetailsDirectInsert = new list < Service_Quote_detail__c > ();
        wrapperObjectShopify.Orders orderData;
        list < string > caseid = new list < string > ();
        string shopifyOrderCreationURL = label.Shopify_URL;
       
        
        //Requesting REST Service to fetch the data send by shopify to this web service class
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob body = req.requestBody;
        String bodyString = body.toString();
        /*res.addHeader('Content-Type', 'application/json');
        res.statusCode = 200;*/
        
        //In bodyString the data that is received from shopify is stored and you can see the output in the below debug
        System.debug('ordersssssssss' + bodyString);
        
        //The data in bodyString is in JSON format the below method is used to parse the json format to normal format
        JSONParser parser = JSON.createParser(bodyString);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {

                // Read entire orders object, including its array of line items.
                wrapperObjectShopify.Orders ord = (wrapperObjectShopify.Orders) parser.readValueAs(wrapperObjectShopify.Orders.class);
                String emailname = parser.getText();
                ordList.add(ord);
                caseNo = ord.note;
                Notes = ord.note;
                orderData = ord;
                String ss = JSON.serialize(ord);
                system.debug('Serialized invoice: ' + ss);

                // Skip the child start array and start object markers.
                parser.skipChildren();
            }
        }
        System.debug('#################' + caseNo);
        String sub = caseNo.substringAfter('#');
            System.debug('************' + sub);
            caseNo = sub.left(8);
             case cs;
             try{
             cs = [select id from case where CaseNumber = : caseNo];
             }catch(exception e)
             {
             }
        //If Salesrep creates an order in shopify with filling Case Number in Notes Section in Shopify
        if (cs!= NULL) {
            
            
            //The Case number enter in shopify notes section is stored in caseNo
            System.debug('&&&&&&&&&&' + caseNo);
           

            //Local Variables
            list < Service_Quote__c > sqInsert = new list < Service_Quote__c > ();
            list < Service_Quote_Detail__c > sqDetailInsert = new list < Service_Quote_Detail__c > ();
            list < Service_Quote_Detail__c > sqDetailDummyList = new list < Service_Quote_Detail__c > ();
            map < Service_Quote__c, list < Service_Quote_Detail__c >> serviceQuoteAnDetailMap = new map < Service_Quote__c, list < Service_Quote_Detail__c >> ();

            for (wrapperObjectShopify.Orders ord: ordList) {
                Service_Quote__c sq = new Service_Quote__c();
                sq.Discount__c = ord.total_discounts;
                sq.Case__c = cs.id;
                sq.shopify__c = true;
                sq.recordtypeid = Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId();
                sq.Shopify_URL__c = shopifyOrderCreationURL+ ord.id;
                if (ord.financial_status == orderPending) {
                    sq.Status__c = orderCreated;
                    sq.Financial_Status__c = orderPending;
                } else if (ord.financial_status == financialPaid) {
                    sq.Status__c = orderPaid;
                    sq.Financial_Status__c = financialPaid;
                }
                sq.Shopify_ID__c = ord.id;
                sq.Total_Amount__c = ord.total_price;
                sqInsert.add(sq);

            }
            
            //A Service Quote will be inserted to the relevant case in Salesforce
            if (sqInsert.size() > 0)
            {
                Database.saveresult[] sr = Database.insert(sqInsert, False);
                ErrorLogUtility.processErrorLogs(sr, sqInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote__c', 'Insert');
            }

            for (wrapperObjectShopify.Orders ord: ordList) {
                for (wrapperObjectShopify.line_items lt: ord.line_items) {
                    Service_Quote_Detail__c sqd = new Service_Quote_Detail__c();
                    sqd.Discount__c = lt.total_discount;
                    sqd.Quantity__c = lt.quantity;
                    sqd.Unit_Price__c = lt.price;
                    sqd.Name = lt.Name;
                    sqd.Service_Quote__c = sqInsert[0].id;
                    sqDetailInsert.add(sqd);
                }
            }
            
            //A Service Quote details will be inserted to the Service Quotes inserted Above and the product details of shoipfy order is mapped to Service Quote Details 
            if (sqDetailInsert.size() > 0)
            {
                Database.saveresult[] sr = Database.insert(sqDetailInsert, False);
                ErrorLogUtility.processErrorLogs(sr, sqDetailInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote_Detail__c', 'Insert');
            }
        }
        
        //If an order is created dirctly on shopify that order needs to be saved in salesforce by mapping to relevant objects
        else {
                for (wrapperObjectShopify.Orders ord: ordList) {
                orderEmail = ord.email;
                }

            list < contact > contactList = [select id, email from contact where email =: orderEmail];

            //if the email address of customer in shopify is having multiple contacts with same email address in salesforce
            if (contactList.size() > 1) {
            
                //A Case will be inserted without relating case to any contact and a service quote and service quote detail is inserted
                list<case> caseInsertList = new list<case>();
                case c = new case ();
                         c.Origin = caseOrigin;
                         c.Status = caseStatus;
                         c.Priority = casePriority; 
                         c.Shipping_City_EndCustomer__c = orderData.shipping_address.city;
                         c.Shipping_Street_End_Customer__c = orderData.shipping_address.address1;
                         c.Shipping_State_End_Customer__c =  orderData.shipping_address.province;
                         c.Shipping_Country__c = orderData.shipping_address.country;
                         c.Shipping_Zip_End_Customer__c = orderData.shipping_address.zip;
                         c.Other_Shipping_Phone__c = orderData.shipping_address.phone;
                         
                         c.Billing_Street_End_Customer__c = orderData.billing_address.address1;
                         c.Billing_City__c = orderData.billing_address.city;
                         c.Billing_State__c = orderData.billing_address.province;
                         c.Billing_Country__c = orderData.billing_address.country;
                         c.Billing_Zipcode__c = orderData.billing_address.zip;
                         c.Other_Phone__c = orderData.billing_address.phone;
                         
                caseInsertList.add(c);
                
                if(caseInsertList.size()>0)
                {               
                    Database.saveresult[] sr = Database.insert(caseInsertList, False);
                    ErrorLogUtility.processErrorLogs(sr, caseInsertList, 'OrderCreationShopify', 'doPost', 'case', 'Insert');
                }

                for (wrapperObjectShopify.Orders ord: ordList) {
                    Service_Quote__c sq = new Service_Quote__c();
                    sq.Discount__c = ord.total_discounts;
                    sq.Case__c = caseInsertList[0].id;
                    sq.shopify__c = true;
                    sq.recordtypeid = Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId();
                    sq.Shopify_URL__c = shopifyOrderCreationURL+ord.id;
                    if (ord.financial_status == orderPending) {
                        sq.Status__c = orderCreated;
                        sq.Financial_Status__c = orderPending;
                    } else if (ord.financial_status == financialPaid) {
                        sq.Status__c = orderPaid;
                        sq.Financial_Status__c = financialPaid;
                    }
                    sq.Shopify_ID__c = ord.id;
                    sq.Total_Amount__c = ord.total_price;
                    serviceQuoteDirectInsert.add(sq);
                }
                if (serviceQuoteDirectInsert.size() > 0)
                {
                    Database.saveresult[] sr = Database.insert(serviceQuoteDirectInsert, False);
                    ErrorLogUtility.processErrorLogs(sr, serviceQuoteDirectInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote__c', 'Insert');
                }

                for (wrapperObjectShopify.Orders ord: ordList) {
                    for (wrapperObjectShopify.line_items lt: ord.line_items) {
                        Service_Quote_Detail__c sqd = new Service_Quote_Detail__c();
                        sqd.Discount__c = lt.total_discount;
                        sqd.Quantity__c = lt.quantity;
                        sqd.Unit_Price__c = lt.price;
                        sqd.Name = lt.Name;
                        sqd.Service_Quote__c = serviceQuoteDirectInsert[0].id;
                        sqDetailsDirectInsert.add(sqd);
                    }
                }
                if (sqDetailsDirectInsert.size() > 0)
                {
                    Database.saveresult[] sr = Database.insert(sqDetailsDirectInsert, False);
                    ErrorLogUtility.processErrorLogs(sr, sqDetailsDirectInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote_Detail__c', 'Insert');
        
                }
                
                //Class for posting Case Number on Shopify Orders (This functionality is commented at present)
                    //PostingCaseNumberOnShopify.CaseNumberOnShopifyOrder(serviceQuoteDirectInsert[0].id, Notes);
            }
            
            //if there is only one contact in salesforce with shopify order email address
            else if (contactList.size() == 1) {
                list < order > orderList = [select id, contact__c from order where contact__c =: contactList[0].id];

                //If there are multiple orders or no orders for the contact
                if (orderList.size() > 1 || orderList.size() < 1) {
                    
                    //A case will be created and it is mapped to a contact and both service quote and service quote details are inserted
                    list<Case> caseOrderList = new list<Case>();
                    case c = new case ();
                    c.Origin = caseOrigin;
                    c.Status = caseStatus;
                    c.Priority = casePriority;
                    c.Contactid = contactList[0].id;
                    c.Send_Quote_To__c = customer;
                    c.Ship_To__c = customer;
                    c.Bill_To__c = customer;
                    
                         c.Shipping_City_EndCustomer__c = orderData.shipping_address.city;
                         c.Shipping_Street_End_Customer__c = orderData.shipping_address.address1;
                         c.Shipping_State_End_Customer__c =  orderData.shipping_address.province;
                         c.Shipping_Country__c = orderData.shipping_address.country;
                         c.Shipping_Zip_End_Customer__c = orderData.shipping_address.zip;
                         c.Other_Shipping_Phone__c = orderData.shipping_address.phone;
                         
                         c.Billing_Street_End_Customer__c = orderData.billing_address.address1;
                         c.Billing_City__c = orderData.billing_address.city;
                         c.Billing_State__c = orderData.billing_address.province;
                         c.Billing_Country__c = orderData.billing_address.country;
                         c.Billing_Zipcode__c = orderData.billing_address.zip;
                         c.Other_Phone__c = orderData.billing_address.phone;
                         
                    caseOrderList.add(c);
                    if(caseOrderList.size()>0)
                    {
                       Database.saveresult[] sr = Database.insert(caseOrderList, False);
                       ErrorLogUtility.processErrorLogs(sr, caseOrderList, 'OrderCreationShopify', 'doPost', 'case', 'Insert'); 
                    }
                   
                    for (wrapperObjectShopify.Orders ord: ordList) {
                        Service_Quote__c sq = new Service_Quote__c();
                        sq.Discount__c = ord.total_discounts;
                        sq.Case__c = caseOrderList[0].id;
                        sq.shopify__c = true;
                        sq.recordtypeid = Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId();
                        sq.Shopify_URL__c = shopifyOrderCreationURL + ord.id;
                        if (ord.financial_status == orderPending) {
                            sq.Status__c = orderCreated;
                            sq.Financial_Status__c = orderPending;
                        } else if (ord.financial_status == financialPaid) {
                            sq.Status__c = orderPaid;
                            sq.Financial_Status__c = financialPaid;
                        }
                        sq.Shopify_ID__c = ord.id;
                        sq.Total_Amount__c = ord.total_price;
                        serviceQuoteDirectInsert.add(sq);
                    }
                    if (serviceQuoteDirectInsert.size() > 0)
                    {
                         Database.saveresult[] sr = Database.insert(serviceQuoteDirectInsert, False);
                         ErrorLogUtility.processErrorLogs(sr, serviceQuoteDirectInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote__c', 'Insert');
                    }

                    //Class for posting Case Number on Shopify Orders (This functionality is commented at present)
                    //PostingCaseNumberOnShopify.CaseNumberOnShopifyOrder(serviceQuoteDirectInsert[0].id, Notes);

                    for (wrapperObjectShopify.Orders ord: ordList) {
                        for (wrapperObjectShopify.line_items lt: ord.line_items) {
                            Service_Quote_Detail__c sqd = new Service_Quote_Detail__c();
                            sqd.Discount__c = lt.total_discount;
                            sqd.Quantity__c = lt.quantity;
                            sqd.Unit_Price__c = lt.price;
                            sqd.Name = lt.Name;
                            sqd.Service_Quote__c = serviceQuoteDirectInsert[0].id;
                            sqDetailsDirectInsert.add(sqd);
                        }
                    }
                    if (sqDetailsDirectInsert.size() > 0)
                    {
                         Database.saveresult[] sr = Database.insert(sqDetailsDirectInsert, False);
                         ErrorLogUtility.processErrorLogs(sr, sqDetailsDirectInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote_Detail__c', 'Insert');
                    }
                }
                
                //if there is only single order for the contact
                else if (orderList.size() == 1) {
                
                //A Case will be inserted by mapping both contact and order to the case and both service quote and service quote detail is inserted
                    list<Case> caseInsertOrderList = new list<Case>();
                    case c = new case ();
                    c.Origin = caseOrigin;
                    c.Status = caseStatus;
                    c.Priority = casePriority;
                    c.Contactid = contactList[0].id;
                    c.Send_Quote_To__c = customer;
                    c.Ship_To__c = customer;
                    c.Bill_To__c = customer;
                    c.order__c = orderList[0].id;
                         c.Shipping_City_EndCustomer__c = orderData.shipping_address.city;
                         c.Shipping_Street_End_Customer__c = orderData.shipping_address.address1;
                         c.Shipping_State_End_Customer__c =  orderData.shipping_address.province;
                         c.Shipping_Country__c = orderData.shipping_address.country;
                         c.Shipping_Zip_End_Customer__c = orderData.shipping_address.zip;
                         c.Other_Shipping_Phone__c = orderData.shipping_address.phone;
                         
                         c.Billing_Street_End_Customer__c = orderData.billing_address.address1;
                         c.Billing_City__c = orderData.billing_address.city;
                         c.Billing_State__c = orderData.billing_address.province;
                         c.Billing_Country__c = orderData.billing_address.country;
                         c.Billing_Zipcode__c = orderData.billing_address.zip;
                         c.Other_Phone__c = orderData.billing_address.phone;
                    caseInsertOrderList.add(c);
                    
                    if(caseInsertOrderList.size()>0)
                    {
                         Database.saveresult[] sr = Database.insert(caseInsertOrderList, False);
                         ErrorLogUtility.processErrorLogs(sr, caseInsertOrderList, 'OrderCreationShopify', 'doPost', 'case', 'Insert');              
                    }

                    for (wrapperObjectShopify.Orders ord: ordList) {
                        Service_Quote__c sq = new Service_Quote__c();
                        sq.Discount__c = ord.total_discounts;
                        sq.Case__c = caseInsertOrderList[0].id;
                        sq.shopify__c = true;
                        sq.recordtypeid = Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId();
                        sq.Shopify_URL__c = shopifyOrderCreationURL + ord.id;
                        if (ord.financial_status == orderPending) {
                            sq.Status__c = orderCreated;
                            sq.Financial_Status__c = orderPending;
                        } else if (ord.financial_status == financialPaid) {
                            sq.Status__c = orderPaid;
                            sq.Financial_Status__c = financialPaid;
                        }
                        sq.Shopify_ID__c = ord.id;
                        sq.Total_Amount__c = ord.total_price;
                        serviceQuoteDirectInsert.add(sq);
                    }
                    if (serviceQuoteDirectInsert.size() > 0)
                    {
                         Database.saveresult[] sr = Database.insert(serviceQuoteDirectInsert, False);
                         ErrorLogUtility.processErrorLogs(sr, serviceQuoteDirectInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote__c', 'Insert');              
                    }

                    //Class for posting Case Number on Shopify Orders (This functionality is commented at present)
                   //PostingCaseNumberOnShopify.CaseNumberOnShopifyOrder(serviceQuoteDirectInsert[0].id, Notes);

                    for (wrapperObjectShopify.Orders ord: ordList) {
                        for (wrapperObjectShopify.line_items lt: ord.line_items) {
                            Service_Quote_Detail__c sqd = new Service_Quote_Detail__c();
                            sqd.Discount__c = lt.total_discount;
                            sqd.Quantity__c = lt.quantity;
                            sqd.Unit_Price__c = lt.price;
                            sqd.Name = lt.Name;
                            sqd.Service_Quote__c = serviceQuoteDirectInsert[0].id;
                            sqDetailsDirectInsert.add(sqd);
                        }
                    }
                    if (sqDetailsDirectInsert.size() > 0)
                    {
                         Database.saveresult[] sr = Database.insert(sqDetailsDirectInsert, False);
                         ErrorLogUtility.processErrorLogs(sr, sqDetailsDirectInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote_Detail__c', 'Insert');
                    }
                }
            }
            // if there is no contact present in salesforce with shopify order email address
            else {
                
                //Inserting an Account, Contact, Case and map contact to that case and insert both service quote and service quote details
                list<Account> accountInsertList = new list<Account>();
                Account a = new Account();
                a.Name = orderData.customer.first_name + ' ' + orderData.customer.last_name;
                a.Phone = orderData.shipping_address.phone;
                a.BillingState = orderData.billing_address.province;
                a.BillingCountry = orderData.billing_address.country;
                a.BillingStreet = orderData.billing_address.address1;
                a.BillingCity = orderData.billing_address.city;
                if(orderData.billing_address.zip!=NULL && orderData.billing_address.zip!='')
                {
                    a.BillingPostalCode = orderData.billing_address.zip;
                }
                else
                {
                    a.BillingPostalCode = zip;
                }
                a.ShippingState = orderData.shipping_address.province;
                a.ShippingCountry = orderData.shipping_address.country;
                if(orderData.shipping_address.zip!=NULL && orderData.shipping_address.zip!='')
                {
                    a.ShippingPostalCode = orderData.shipping_address.zip;
                }
                else
                {
                    a.ShippingPostalCode = shipzip;
                }
                a.ShippingStreet = orderData.shipping_address.address1;
                a.ShippingCity = orderData.shipping_address.city;
                accountInsertList.add(a);
                
                if(accountInsertList.size()>0)
                {
                    Database.saveresult[] sr = Database.insert(accountInsertList, False);
                    ErrorLogUtility.processErrorLogs(sr, accountInsertList, 'OrderCreationShopify', 'doPost', 'Account', 'Insert');              
                }
                list<Contact> contactInsertList =  new list<Contact>();
                contact con = new contact();
                con.FirstName = orderData.customer.first_name;
                con.LastName = orderData.customer.last_name;
                con.email = orderData.customer.email;
                con.MailingStreet = orderData.shipping_address.address1;
                con.MailingCity = orderData.shipping_address.city;
                con.Mailingstate = orderData.shipping_address.province;
                con.MailingCountry = orderData.shipping_address.country;
                con.MailingPostalCode = accountInsertList[0].ShippingPostalCode;
                con.phone = orderData.shipping_address.phone;
                con.accountid = accountInsertList[0].id;
                contactInsertList.add(con);
                if(contactInsertList.size()>0)
                {
                    Database.saveresult[] sr = Database.insert(contactInsertList, False);
                    ErrorLogUtility.processErrorLogs(sr, contactInsertList, 'OrderCreationShopify', 'doPost', 'Contact', 'Insert');
                    System.debug('contacttttttttttt'+contactInsertList+'srrrrrr'+sr); 
                }

                list<case> caseListInsert =  new list<case>();
                case c = new case ();
                c.Origin = caseOrigin;
                c.Status = caseStatus;
                c.Priority = casePriority;
                if (contactInsertList.size()>0) {
                    c.Contactid = contactInsertList[0].id;
                }
                c.Send_Quote_To__c = customer;
                c.Ship_To__c = customer;
                c.Bill_To__c = customer;
                caseListInsert.add(c);
                if(caseListInsert.size()>0)
                {
                    Database.saveresult[] sr = Database.insert(caseListInsert, False);
                    ErrorLogUtility.processErrorLogs(sr, caseListInsert, 'OrderCreationShopify', 'doPost', 'Case', 'Insert');          
                }

                for (wrapperObjectShopify.Orders ord: ordList) {
                    Service_Quote__c sq = new Service_Quote__c();
                    sq.Discount__c = ord.total_discounts;
                    sq.Case__c = caseListInsert[0].id;
                    sq.shopify__c = true;
                    sq.recordtypeid = Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId();
                    sq.Shopify_URL__c = shopifyOrderCreationURL + ord.id;
                    if (ord.financial_status == orderPending) {
                        sq.Status__c = orderCreated;
                        sq.Financial_Status__c = orderPending;
                    } else if (ord.financial_status == financialPaid) {
                        sq.Status__c = orderPaid;
                        sq.Financial_Status__c = financialPaid;
                    }
                    sq.Shopify_ID__c = ord.id;
                    sq.Total_Amount__c = ord.total_price;
                    serviceQuoteDirectInsert.add(sq);
                }

                if (serviceQuoteDirectInsert.size() > 0)
                {
                    Database.saveresult[] sr = Database.insert(serviceQuoteDirectInsert, False);
                    ErrorLogUtility.processErrorLogs(sr, serviceQuoteDirectInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote__c', 'Insert');
                }

                //Class for posting Case Number on Shopify Orders (This functionality is commented at present)
                 //PostingCaseNumberOnShopify.CaseNumberOnShopifyOrder(serviceQuoteDirectInsert[0].id, Notes);

                for (wrapperObjectShopify.Orders ord: ordList) {
                    for (wrapperObjectShopify.line_items lt: ord.line_items) {
                        Service_Quote_Detail__c sqd = new Service_Quote_Detail__c();
                        sqd.Discount__c = lt.total_discount;
                        sqd.Quantity__c = lt.quantity;
                        sqd.Unit_Price__c = lt.price;
                        sqd.Name = lt.Name;
                        sqd.Service_Quote__c = serviceQuoteDirectInsert[0].id;
                        sqDetailsDirectInsert.add(sqd);
                    }
                }
                if (sqDetailsDirectInsert.size() > 0)
                {
                    Database.saveresult[] sr = Database.insert(sqDetailsDirectInsert, False);
                    ErrorLogUtility.processErrorLogs(sr, sqDetailsDirectInsert, 'OrderCreationShopify', 'doPost', 'Service_Quote_Detail__c', 'Insert');           
                }

            }
        }

    }

}