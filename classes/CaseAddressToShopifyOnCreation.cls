/*****************************************
Description:- This class will be used to autofill the shopify address section on creation based on case in shopify
*******************************************/
public class CaseAddressToShopifyOnCreation {
//added by satish
//method to update bill to and ship to address on shopify and custom service quotes based on case  
    public static void SqAdrsFromCase(list < Service_Quote__c > sqlist) {
        set < id > sqCaseId = new set < id > ();
        //loop through new set of records and store the case info
        for (Service_Quote__c sq: sqlist) {
            sqCaseId.add(sq.Case__c);
        }
        //fetch the case address info based on case ids
        for (
            case c:
                [select id, Other_Phone__c, Other_Email__c, Other_Shipping_Phone__c, Other_Shipping_Email__c, Billing_Street_End_Customer__c, Shipping_Country__c, Billing_Country__c, Billing_Zipcode__c, Billing_State__c, Billing_City__c, Shipping_Address_Country__c, Shipping_Zip_End_Customer__c, Shipping_City_EndCustomer__c, Shipping_Street_End_Customer__c, Shipping_State_End_Customer__c from
                    case where id IN:
                        sqCaseId
                ]) {
            //loop through the new set of records and update the bill to and ship to address on shopify and custom service quotes based on case
            for (Service_Quote__c sq: sqlist) {
                if (sq.case__c == c.id && (sq.recordtypeid == Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId())) {

                    system.debug('WEBTOSHOPIFY' + sq.Shopify_Ship_To_City__c);
                    system.debug('WEBTOSHOPIFY2' + sq.Shopify_Bill_To_country__c);
                    system.debug('WEBTOSHOPIFY3' + sq.Shopify_Ship_To_country__c);
                    sq.Shopify_Ship_To_City__c = c.Shipping_City_EndCustomer__c;
                    sq.Shopify_Ship_To_Street__c = c.Shipping_Street_End_Customer__c;
                    sq.Shopify_Ship_To_State__c = c.Shipping_State_End_Customer__c;
                    sq.Shopify_Ship_To_country__c = c.Shipping_Country__c;
                    sq.Shopify_Ship_To_Zip__c = c.Shipping_Zip_End_Customer__c;
                    sq.Shopify_Ship_To_Phone__c = c.Other_Shipping_Phone__c;
                    sq.Shopify_Ship_To_Email__c = c.Other_Shipping_Email__c;
                    sq.Shopify_Bill_To_Street__c = c.Billing_Street_End_Customer__c;
                    sq.Shopify_Bill_To_City__c = c.Billing_City__c;
                    sq.Shopify_Bill_To_State__c = c.Billing_State__c;
                    sq.Shopify_Bill_To_country__c = c.Billing_Country__c;
                    sq.Shopify_Bill_To_Zip__c = c.Billing_Zipcode__c;
                    sq.Shopify_Bill_To_Phone__c = c.Other_Phone__c;
                    sq.Shopify_Bill_To_Email__c = c.Other_Email__c;
                }
            }
        }

    }
    //added by satish
    //method to update order on both shopify and custom service quotes
    public static void updateOrderInfoBasedOnQuote(list < Service_Quote__c > sqlist) {
        set < string > orderNo = new set < string > ();
        string str;
       // map quote and order
        map < id, string > QuoOrderMap = new map < id, string > ();
        set < id > qId = new set < id > ();
        for (Service_Quote__c c: sqlist) {
            //store Quote ids
            qId.add(c.Quote__c);
        }
        //loop through quotes and fetch order and convert to string from number and store in map
        for (Quote__c q: [select id, Order_Number__c from Quote__c where id IN: qId]) {
            if(q.Order_Number__c != 0 && q.Order_Number__c !=null ){
            str = string.valueof(q.Order_Number__c);
            orderNo.add(str);
            //map quote and order in string
            QuoOrderMap.put(q.id, str);
            }
        }
        map < string, id > mapQuoteOrder = new map < string, id > ();
       //null check if contains order
       if(orderNo.size()>0){
            for (order o: [select id, name from Order where name IN: orderNo]) {
                //check order number should not be zero
                if (o.name != '0') {
                //map order number  and storte id
                    mapQuoteOrder.put(o.Name, o.id);
                    system.debug(mapQuoteOrder);
                }
            }
        }
        //loop through new records and map orders  on both shopify and custom service quotes
            for (service_Quote__c sq: sqlist) {
               
                string strg = QuoOrderMap.get(sq.Quote__c);
                //check map conatins order string or not
                if (mapQuoteOrder.containskey(strg)) {
                    sq.Order__c = mapQuoteOrder.get(strg);

                }
                
            }

    }
    //added by satish
    //Method to update the quote on shopify service quote
    public static void updateQuoteFromCase(list < Service_Quote__c > sqlist2){
    
        set < id > cId = new set < id > ();
        for (Service_Quote__c sq: sqlist2) {
            cId.add(sq.Case__c);
        }
        //map case and quote
        map<id,string> caseQuoteOrderMap = new map<id,string>();
        //null check for case id
        
        if(cId.size()>0){
        for(case caseList : [select id, Quote__c from case where ID IN:cId]){
            //null check to check if contains quote on case 
            
            if(caseList.Quote__c!=null){
            caseQuoteOrderMap.put(caseList.id,caseList.Quote__c);
            }
        }
        //loop through the new records and update the quote on sq
        for (service_Quote__c sq: sqlist2) {
                if (caseQuoteOrderMap.containskey(sq.case__c)) {
                    sq.Quote__c= caseQuoteOrderMap.get(sq.case__c);

                } 
        }
        }
        
    }
}