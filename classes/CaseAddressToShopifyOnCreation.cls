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
                [select id,Category__c,Sub_Category__c, Other_Phone__c, Other_Email__c, Other_Shipping_Phone__c, Other_Shipping_Email__c, Billing_Street_End_Customer__c, Shipping_Country__c, Billing_Country__c, Billing_Zipcode__c, Billing_State__c, Billing_City__c, Shipping_Address_Country__c, Shipping_Zip_End_Customer__c, Shipping_City_EndCustomer__c, Shipping_Street_End_Customer__c, Shipping_State_End_Customer__c from
                    case where id IN:
                        sqCaseId
                ]) {
            //loop through the new set of records and update the bill to and ship to address on shopify and custom service quotes based on case
            for (Service_Quote__c sq: sqlist) {
                if (sq.case__c == c.id && (sq.recordtypeid == Schema.SObjectType.Service_Quote__c.getRecordTypeInfosByName().get('Shopify Service Quote').getRecordTypeId())) {

                    system.debug('WEBTOSHOPIFY' + sq.Shopify_Ship_To_City__c);
                    system.debug('WEBTOSHOPIFY2' + sq.Shopify_Bill_To_country__c);
                    system.debug('WEBTOSHOPIFY3' + sq.Shopify_Ship_To_country__c);
                    sq.Category__c =c.Category__c;
                    sq.Sub_Category__c=c.Sub_Category__c;
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
                    if(sq.Freight_Tracking_Number__c==null || sq.Freight_Tracking_Number__c==''){
                    sq.Freight_Tracking_Number__c = 'Shipping from Shopify';
                    }
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
            if (q.Order_Number__c != 0 && q.Order_Number__c != null) {
                str = string.valueof(q.Order_Number__c);
                orderNo.add(str);
                //map quote and order in string
                QuoOrderMap.put(q.id, str);
            }
        }
        map < string, id > mapQuoteOrder = new map < string, id > ();
        //null check if contains order
        if (orderNo.size() > 0) {
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
    public static void updateQuoteFromCase(list < Service_Quote__c > sqlist2) {

        set < id > cId = new set < id > ();
        for (Service_Quote__c sq: sqlist2) {
            cId.add(sq.Case__c);
        }
        //map case and quote
        map < id, string > caseQuoteOrderMap = new map < id, string > ();
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
                    sq.Quote__c = caseQuoteOrderMap.get(sq.case__c);

                }
            }
        }

    }

    //Added by Harish
    //Method to avoid duplicates entries from the shopify
    public static void removeDupesFromShopify(list < Service_Quote__c > sqlist2) {
       //create instance of map to store SL order number of shopify
        map < string, Service_Quote__c > sqMap = new map < string, Service_Quote__c > ();
        set < string > setSq = new set < string > ();
        for (Service_Quote__c sq: sqlist2) {
            setSq.add(sq.Shopify_Order_NO__c);

        }
        Set < string > tempSet = new Set < string > ();
        for (Service_Quote__c dupeList: [select id, Shopify_Order_NO__c from Service_Quote__c where Shopify_Order_NO__c IN: setSq]) {

            tempSet.add(dupeList.Shopify_Order_NO__c);
        }
        //Loop through bulk service quotes and validate by checking that same key contains in existing set or not 
        for (Service_Quote__c sq: sqlist2) {

            //Check the SL order number exists in set or not,  else if already contains display error
            if (sqMap.containskey(sq.Shopify_Order_NO__c) || tempSet.contains(sq.Shopify_Order_NO__c)) {
                sq.Shopify_Order_NO__c.addError('Already service quote created');
            }
            //Throw error if Same SL order is getting created
            else {
                sqMap.put(sq.Shopify_Order_NO__c, sq);
            }

        }

    }
    /****************************************
    Method to delete Dupe SLorder ids in shopify service quote
    Added by satish    
    ****************************************/
    public static void deleteDupeSlOrder(list < Service_Quote__c > sqlist) {

        set < string > setSq = new set < string > ();
        map < string, Service_Quote__c > sqMap = new map < string, Service_Quote__c > ();

        for (service_Quote__c sq: sqlist) {
        if(sq.Shopify_Order_NO__c!=null && sq.Shopify_Order_NO__c!=''){
            setSq.add(sq.Shopify_Order_NO__c);
            }
        }
        //retrive from data base and check for dupes
        list < Service_Quote__c > sqlistMatchedSLOrder = [select id, Shopify_Order_NO__c from Service_Quote__c where Shopify_Order_NO__c IN: setSq];
        list < service_Quote__c > deletSq = new list < service_Quote__c > ();
        //Loop through the matched records and check for multiples and add to the delete list
        for (Service_Quote__c sq: sqlistMatchedSLOrder) {

            //Check the SL order number exists in set or not,  else if already contains add to delete list
            if (sqMap.containskey(sq.Shopify_Order_NO__c)) {
                deletSq.add(sq);
            } else {
                sqMap.put(sq.Shopify_Order_NO__c, sq);
            }

        }
        //null check and error log
        if (deletSq.size() > 0) {
            Database.DeleteResult[] sr = Database.delete(deletSq, False);
            ErrorLogUtility.processDeleteErrorLogs(sr, deletSq, 'CaseAddressToShopifyOnCreation', 'deleteDupeSlOrder', 'Service_Quote__c', 'Delete');

        }

    }

}