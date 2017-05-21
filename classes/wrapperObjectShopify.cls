/**********************************************************************
Apex Class: wrapperObjectShopify
Description: This is Wrapper Class for all shopify Classes
Created Date: 08th June,2016            
***********************************************************************/
public class wrapperObjectShopify{

//Wrapper Class
 public class Order {
        public string id;
        public string email;
        public DateTime created_at;
        public string note;
        public Double total_price;
        public Double subtotal_price;
        public Double total_weight;
        public Double total_tax;
        public String fulfillment_status;
        public datetime cancelled_at;
        public String financial_status;
        public Double total_discounts;
        public Double total_line_items_price;
        public List < line_items > line_items;
        public billing_address billing_address;
        public shipping_address shipping_address;
        public customer customer;
        public list < note_attributes > note_attributes;
        public string cancel_reason;
        public List < fulfillments > fulfillments;
        public string name;
       
    }

    public class line_items {
        public Double price;
        public Double quantity;
        public String title;
        public Double total_discount;
        public String Name;
        public string sku;
    }

    public class billing_address {
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


    public class shipping_address {
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

    public class customer {

        public default_address default_address;
        public String first_name;
        public String last_name;
        public String email;
 
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

    public class note_attributes {

        public string name;
        public string value;
    }
    
    public class fulfillments {
        public String tracking_number;
        public String tracking_company;
        public String tracking_url;
    }
    
    
 }