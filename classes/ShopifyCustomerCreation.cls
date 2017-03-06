/**********************************************************************
Apex Class: ShopifyCustomerCreation
Description: This callout Class is used to create customer in Shopify
Created Date: 18th April,2016            
***********************************************************************/
global class ShopifyCustomerCreation {
    
    //Global variables
    static string endcustomer = 'End Customer';
    static string callercontact = 'Caller Contact';
    static string projectadd = 'Project Site';
    static string otherDeatil = 'Other';
    
    //Method to Create Customer in Shopify Application based on details in Salesforce
    webservice static void CustomerCreation(string caseId) {
        //local variables
        contact customerCon;
        contact callerCon;
        string fullName;
        string[] name;
        string email;
        string addrs1Ship;
        string cityShip;
        string stateShip;
        string countryShip;
        string zipShip;
        string phoneShip;
        string addrs1;
        string city;
        string state;
        string country;
        string zip;
        string phone;
        case cs;
        string firstName;
        string lastName;
        string emailUser;
        string lstName;
        string frstName;
        string lstNameShip;
        string frstNameShip;
        
        //Fetching data from case
        System.debug('contactd' + caseid);
        if (caseId != NULL && caseId != '') {
            cs = [select id, Billing_address_CIty__c, City_Billing_Address_of_Caller__c, Billing_Address_Country__c, Country_Billing_Address_of_Caller__c, Billing_Address_State__c, State_Billing_Address_of_Caller__c, Billing_Address__c, Street_Billing_Address_Caller__c, Billing_Address_Z__c, Zip_Code_Billing_Address_of_Caller__c, Bill_To__c, Caller_contact__c, Contactid, Project_Site_Zip_Postal_Codes__c, Project_Site_Street_Addresses__c, Project_Site_States__c, Project_Site_Countryies__c, Project_Site_Citys__c,  Send_Quote_To__c, Shipping_Address_City__c, City_Shipping_Address_of_Caller__c, Shipping_Address_Country__c, Country_Shipping_Address_of_Caller__c, Shipping_Address_State__c, State_Shipping_Address_of_Caller__c, Shipping_Address_Street__c, Street_Shipping_address_of_caller__c, Shipping_Address_Zip_Postal_Code__c, Zip_Code_Shipping_Address_of_Caller__c, Ship_To__c, Other_Billing_City__c, Other_Billing_Country__c, Other_Billing_State__c, Other_Billing_Street__c, Other_Billing_Zip__c, Other_Shipping_City__c, Other_Shipping_Country__c, Other_Shipping_State__c, Other_Shipping_Street__c, Other_Shipping_Zip__c from case where id = :caseId];

            if (cs != NULL) {
                if (cs.ContactId != NULL) {
                    customerCon = [select id, Name, email, Phone, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode from contact where id =: cs.ContactId];
                }
                if (cs.Caller_contact__c != NULL) {
                    callerCon = [select id, Name, email, Phone, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode from contact where id =: cs.Caller_contact__c];
                }
                
                //Checking the Contact type in Case 
                if (cs.Send_Quote_To__c == endcustomer) {
                    fullName = customerCon.Name;
                    name = fullName.split(' ');
                    firstName = name[0];
                    lastName = name[1];
                    emailUser = customerCon.email;

                } else if (cs.Send_Quote_To__c == callercontact) {
                    fullName = callerCon.Name;
                    name = fullName.split(' ');
                    firstName = name[0];
                    lastName = name[1];
                    emailUser = callerCon.email;
                }

                if (cs.Bill_To__c == endcustomer) {
                    string[] n = customerCon.Name.split(' ');
                    frstName = n[0];
                    lstName = n[1];
                    addrs1 = cs.Billing_Address__c;
                    city = cs.Billing_address_CIty__c;
                    state = cs.Billing_Address_State__c;
                    country = cs.Billing_Address_Country__c;
                    zip = cs.Billing_Address_Z__c;
                    phone = customerCon.Phone;
                } else if (cs.Bill_To__c == callercontact) {
                    string[] n = callerCon.Name.split(' ');
                    frstName = n[0];
                    lstName = n[1];
                    addrs1 = callerCon.Account.BillingStreet;
                    city = callerCon.Account.BillingCity;
                    state = callerCon.Account.BillingState;
                    country = callerCon.Account.BillingCountry;
                    zip = callerCon.Account.BillingPostalCode;
                    phone = callerCon.Phone;
                } else if (cs.Bill_To__c == projectadd) {
                    frstName = firstName;
                    lstName = lastName;
                    addrs1 = cs.Project_Site_Street_Addresses__c;
                    city = cs.Project_Site_Citys__c;
                    state = cs.Project_Site_States__c;
                    country = cs.Project_Site_Countryies__c;
                    zip = cs.Project_Site_Zip_Postal_Codes__c;
                    phone = ' ';
                }
                else if(cs.Bill_To__c == otherDeatil) {
                    frstName = firstName;
                    lstName = lastName;
                    addrs1 = cs.Other_Billing_Street__c;
                    city = cs.Other_Billing_City__c;
                    state = '';
                    country = cs.Other_Billing_Country__c;
                    zip = cs.Other_Billing_Zip__c;
                    phone = ' ';
                
                }

                if (cs.Ship_To__c == endcustomer) {
                    string[] n = customerCon.Name.split(' ');
                    frstNameShip = n[0];
                    lstNameShip = n[1];
                    addrs1Ship = cs.Shipping_Address_Street__c;
                    cityShip = cs.Shipping_Address_City__c;
                    stateShip = cs.Shipping_Address_State__c;
                    countryShip = cs.Shipping_Address_Country__c;
                    zipShip = cs.Shipping_Address_Zip_Postal_Code__c;
                    phoneShip = customerCon.Phone;
                } else if (cs.Ship_To__c == callercontact) {
                    string[] n = callerCon.Name.split(' ');
                    frstNameShip = n[0];
                    lstNameShip = n[1];
                    addrs1Ship = callerCon.Account.ShippingStreet;
                    cityShip = callerCon.Account.ShippingCity;
                    stateShip = callerCon.Account.ShippingState;
                    countryShip = callercon.Account.ShippingCountry;
                    zipShip = callerCon.Account.ShippingPostalCode;
                    phoneShip = callerCon.Phone;
                } else if (cs.Ship_To__c == projectadd) {
                    frstNameShip = firstName;
                    lstNameShip = lastName;
                    addrs1Ship = cs.Project_Site_Street_Addresses__c;
                    cityShip = cs.Project_Site_Citys__c;
                    stateShip = cs.Project_Site_States__c;
                    countryShip = cs.Project_Site_Countryies__c;
                    zipShip = cs.Project_Site_Zip_Postal_Codes__c;
                    phoneShip = ' ';
                } else if (cs.Ship_To__c == otherDeatil) {
                    frstNameShip = firstName;
                    lstNameShip = lastName;
                    addrs1Ship = cs.Other_Shipping_Street__c;
                    cityShip = cs.Other_Shipping_City__c;
                    stateShip = '';
                    countryShip = cs.Other_Shipping_Country__c;
                    zipShip = cs.Other_Shipping_Zip__c;
                    phoneShip = ' ';
                }

            }

        }

        //Making HTTP Callouts for Shopify admin page
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        //Fetching Shopify Admin page URL from label
        String url = label.Shopify_Store_URL;
        string endPointValue = url + '/admin/customers';      
        req.setEndpoint(endPointValue);
        // req.setClientCertificateName('Shopify');
        
        //Fetching Shopify Admin Credentials from custom settings
        Shopify_Credentials__c ShopCred = Shopify_Credentials__c.getOrgDefaults();
        String username = ShopCred.User_Name__c;
        String password = ShopCred.Password__c;

        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('content-type', 'application/json');
        req.setHeader('Accept', 'application/json');
        
        //Adding Customer Data to the body
        string str;
        if (customerCon != NULL || callerCon != NULL) {
            if (state != NULL && stateShip != NULL) {
                str = '{"customer": {"first_name": "' +
                    firstName + '","last_name": "' +
                    lastName + '","email": "' +
                    emailUser + '","addresses": [{"address1": "' +
                    addrs1Ship + '","city": "' +
                    cityShip + '","province": "' +
                    stateShip + '","country": "' +
                    countryShip + '","zip": "' +
                    zipShip + '","last_name": "' +
                    lstNameShip + '","first_name": "' +
                    frstNameShip + '","phone": "' +
                    phoneShip + '"},{"address1": "' +
                    addrs1 + '","city": "' +
                    city + '","province": "' +
                    state + '","country": "' +
                    country + '","zip": "' +
                    zip + '","last_name": "' +
                    lstName + '","first_name": "' +
                    frstName + '","phone": "' +
                    phone + '"}]}}';
                System.debug('stringggggg' + str);
            } else {
                str = '{"customer": {"first_name": "' +
                    firstName + '","last_name": "' +
                    lastName + '","email": "' +
                    emailUser + '","addresses": [{"address1": "' +
                    addrs1Ship + '","city": "' +
                    cityShip + '","province": " ","country": "' +
                    countryShip + '","zip": "' +
                    zipShip + '","last_name": "' +
                    lstNameShip + '","first_name": "' +
                    frstNameShip + '","phone": "' +
                    phoneShip + '"},{"address1": "' +
                    addrs1 + '","city": "' +
                    city + '","province": " ","country": "' +
                    country + '","zip": "' +
                    zip + '","last_name": "' +
                    lstName + '","first_name": "' +
                    frstName + '","phone": "' +
                    phone + '"}]}}';
                System.debug('stringggggg' + str);
            }
        } else {
            str = 'test';
        }
        
        //Using POST Method to post customer record in Shopify
        req.setMethod('POST');
        req.setBody(str);
        try {
            HttpResponse res = h.send(req);
        } catch (exception e) {
            System.debug('eee' + e);
        }
    }
}