/**********************************************************************
Apex Class: wrapperCustomerShopify
Description: This is Wrapper Class for all shopify customer creation Classes
Created Date: 20th May,2017            
***********************************************************************/
public class wrapperCustomerShopify{
    // public class customer{
        public default_address default_address;
        public decimal orders_count;
        public string state;
        public decimal total_spent;
        public string last_order_id;
        public string note;
        public boolean verified_email;
        public string multipass_identifier;
        public boolean tax_exempt;
        public integer phone;
        public string tags;
        public string last_order_name;
        
        public String first_name;
        public String last_name;
        public String email;
        public string id;
   // }
     public class default_address{

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