/**********************************************************************
Apex Class: wrapperObjectShopify
Description: This is Wrapper Class for all shopify Classes
Created Date: 08th June,2016            
***********************************************************************/
public class wrapperObjectShopify{

//Wrapper Class
 public class Orders {
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

        public Orders(Double price, DateTime dt, string ids, string em, List < line_items > lineItems2, Double discount, Double lineitemprice, Double weight, Double tax, String status, Double subtotal, String sub, billing_address baddress, shipping_address saddress, customer custlist, string n, list < note_attributes > na, String fullstatus, datetime cancel, string cancelreason, List < fulfillments > tdetails) {
            total_price = price;
            created_at = dt;
            ids = id;
            email = em;
            total_discounts = discount;
            total_line_items_price = lineitemprice;
            total_weight = weight;
            total_tax = tax;
            financial_status = status;
            subtotal_price = subtotal;
            note = sub;
            line_items = lineItems2.clone();
            billing_address = baddress;
            shipping_address = saddress;
            customer = custlist;
            note_attributes = na.clone();
            fulfillment_status = fullstatus;
            cancelled_at = cancel;
            cancel_reason = cancelreason;
            fulfillments = tdetails.clone();
        }
    }

    public class line_items {
        public Double price;
        public Double quantity;
        public String title;
        public Double total_discount;
        public String Name;
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
    
    public class Customers {

        public default_address default_address;
        public String first_name;
        public String last_name;
        public String email;
        public string id;

        public Customers(default_address address, string fname, string lname, string e, string i) {
            default_address = address;
            first_name = fname;
            last_name = lname;
            email = e;
            id = i;
        }

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