/**********************************************************************
Apex Class: ShopifyCustomerCreation_WebService
Description: This REST Web service class is to fetch the data from shopify 
             on Customer Creation
Created Date: 18th April,2016            
***********************************************************************/
@RestResource(urlMapping = '/CustomerCreation/*')
global without sharing class ShopifyCustomerCreation_WebService {

    //Global Variables
    static string status = 'Not Engaged';
    //Method to Create Contact and Account when a customer is created in Shopify
    @HttpPost
    global static void doPost() {
        // Local Variables       
        list < String > contactEmailList= new list < String > ();
        list < wrapperCustomerShopify.Customers > CustomerList = new list < wrapperCustomerShopify.Customers > ();
        map < string, wrapperCustomerShopify.Customers > customerMap = new map < string, wrapperCustomerShopify.Customers > ();
        map < string, string > firstNameMap = new map < string, string > ();
        map < string, string > secondNameMap= new map < string, string > ();
        list < contact > contactInsert = new list < contact > ();
        list < account > accountInsert = new list < account > ();
        
        //Requesting REST Service to fetch the data send by shopify to this web service class
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob body = req.requestBody;
        String bodyString = body.toString();
        /*res.addHeader('Content-Type', 'application/json'); 
        res.statusCode = 200;*/
        
        //In bodyString the data that is received from shopify is stored and you can see the output in the below debug
        System.debug('customer' + bodyString);
        System.debug('responseee' + res);
                shopifywrapper cuss = (shopifywrapper) JSON.deserialize(bodyString, shopifywrapper.class);              
                CustomerList.add(cuss.Customers);            

        if (CustomerList.size() > 0) {
            for (wrapperCustomerShopify.Customers cus: CustomerList) {
                contactEmailList.add(cus.email);
                customerMap.put(cus.email, cus);
            }
        }

        list < contact > contactList = [select id, email from contact where email IN: contactEmailList];       
        if (contactList.size() == 0) {

            for (wrapperCustomerShopify.Customers cus: CustomerList) {

                account a = new account();
                a.Name = cus.first_name + ' ' + cus.last_name;
                a.Phone = cus.default_address.phone;
                a.BillingState = cus.default_address.province;
                if(cus.default_address.country!=NULL && cus.default_address.country!='')
                {
                    a.BillingCountry = cus.default_address.country;
                }
                else
                {
                    a.BillingCountry = 'United States';
                }
                if(cus.default_address.zip!=NULL && cus.default_address.zip!='')
                {
                    a.BillingPostalCode = cus.default_address.zip;
                }
                else
                {
                    a.BillingPostalCode = '12345';
                }
                a.BillingStreet = cus.default_address.address1;
                a.BillingCity = cus.default_address.city;
                a.Shopify_Customer_Id__c = cus.id;
                a.Company_Email__c = cus.email;
                accountInsert.add(a);
                
                firstNameMap.put(cus.id, cus.first_name);
                secondNameMap.put(cus.id, cus.last_name);

            }
            //Inserting Account
            if(accountInsert.size()>0)
            {
                  Database.saveresult[] sr = Database.insert(accountInsert, False);
                  ErrorLogUtility.processErrorLogs(sr, accountInsert, 'ShopifyCustomerCreation_WebService', 'doPost', 'account', 'Insert');
            }
            System.debug('accc' + accountInsert);

            for (account acc: accountInsert) {
                contact c = new contact();
                c.FirstName = firstNameMap.get(acc.Shopify_Customer_Id__c);
                c.accountid = acc.id;
                c.LastName = secondNameMap.get(acc.Shopify_Customer_Id__c);
                c.MailingStreet = acc.BillingStreet;
                c.MailingCity = acc.BillingCity;
                c.Mailingstate = acc.BillingState;
                c.MailingPostalCode = acc.BillingPostalCode;
                c.MailingCountry = acc.BillingCountry;
                c.email = acc.Company_Email__c;
                c.FCRM__FCR_Status__c = status;
                c.phone = acc.phone;
                c.Shopify_Customer_Id__c = acc.Shopify_Customer_Id__c;
                contactInsert.add(c);
                System.debug('connnnnnnnnnnn' + c);
            }
        }
        
        //Inserting Contact
        if (contactInsert.size() > 0)
        {
             Database.saveresult[] sr = Database.insert(contactInsert, False);
             ErrorLogUtility.processErrorLogs(sr, contactInsert, 'ShopifyCustomerCreation_WebService', 'doPost', 'contact', 'Insert');     
        }
        System.debug('inserttttttt' + contactInsert);
    }
    
    public class shopifyWrapper {
      public wrapperCustomerShopify.Customers Customers;
    }
}