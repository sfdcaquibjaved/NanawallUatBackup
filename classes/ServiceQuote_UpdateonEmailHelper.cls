public class ServiceQuote_UpdateonEmailHelper {
    public static void getEmails(list<service_quote__c> sqlist){
        set<String> emails = new set<String>();
        for(service_quote__c sh:sqlist){
            System.debug('I am here');
            if(sh.Shopify_Bill_To_Email__c != null && sh.Shopify_Ship_To_Email__c != null){
                emails.add(sh.Shopify_Bill_To_Email__c);
                emails.add(sh.Shopify_Ship_To_Email__c);
              }
                else if(sh.Shopify_Bill_To_Email__c != null){
                 emails.add(sh.Shopify_Bill_To_Email__c);
                 System.debug('shopify email'+sh.Shopify_Bill_To_Email__c);
                }
                else if(sh.Shopify_Ship_To_Email__c != null) {
                 emails.add(sh.Shopify_Ship_To_Email__c);
                }
                
                System.debug('Hello World');
                
               if(sh.Bill_Too_Email__c != null && sh.Ship_Too_Email__c != null){
                emails.add(sh.Bill_Too_Email__c);
                emails.add(sh.Ship_Too_Email__c);
                System.debug('custom email 1'+sh.Bill_Too_Email__c);
                System.debug('custom email 2'+sh.Ship_Too_Email__c);
                }
                else if(sh.Bill_Too_Email__c != null){         
                emails.add(sh.Bill_Too_Email__c);
                }
                else if(sh.Ship_Too_Email__c != null){
                emails.add(sh.Ship_Too_Email__c);
                }
            
          
        }
       System.debug('Email'+emails);
        list<Contact> conlist = new list<Contact>();
        try
        {
         if(emails != null && !emails.isEmpty()){
           conlist = [select id,Name,Email,accountId from Contact where Email in:emails];
        }
        }
            catch(Exception e){}
        System.debug('contact'+conlist);
       // list<service_quote__c> updatedsq = new list<service_quote__c>();
            
        for(service_quote__c sq:sqlist){
                for(contact cc:conlist){
                    if(sq.Shopify_Bill_to_Email__c == cc.Email || sq.Bill_Too_Email__c == cc.Email){
                        sq.Bill_To_Contact__c = cc.id;
                        sq.Bill_To_Company__c = cc.AccountId;
                        //updatedsq.add(sq);

                    }
                    if(sq.Shopify_Ship_to_Email__c == cc.Email || sq.Ship_Too_Email__c == cc.Email){
                        sq.Ship_To_Contact__c = cc.id;
                        sq.Ship_To_Company__c = cc.AccountId;
                        //updatedsq.add(sq);

                    }
                
                    }
                    
            }
    
            //update updatedsq;
       // System.debug('updated list'+updatedsq);
        }
      
    }