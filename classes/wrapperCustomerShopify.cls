/**********************************************************************
Apex Class: wrapperCustomerShopify
Description: This is Wrapper Class for all shopify customer creation Classes
Created Date: 20th May,2017            
***********************************************************************/
public class wrapperCustomerShopify{
     public class Customers {
        public default_address default_address;
        public String first_name;
        public String last_name;
        public String email;
        public string id;
    }
     public class default_address {

        public String first_name;
        public String last_name;
        public String address1;
        public String address2;
        public String phone;
        public String city;
        public String zip;
        public String province;
        public string country;
        public String company;

    }
}