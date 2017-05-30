/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : August-2016
    @ Description   : To send quote as a pdf to Installer, associated with QuoteTrigger
    @ Audit Trial   : Added comments
    @ Test Class    : QuoteTriggerHelper_Test - QuoteTriggerHelper_Test6
    @ Last Modified Date : 
  
****************************************************************************/
public class QuoteToInstaller {
    /*  
         Method Name    : SendQuote
         Purpose        : Sends quote to Installer as a pdf
         Input Parameter: List of Quote
         Created Date   : August 2016
         */
    public static void SendQuote(List < Quote__c > newTrigger) {
       /* List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
        List < string > toAddresses = new List < string > ();
        for (Quote__c q: newTrigger) {
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Quote.pdf');
            String body;
            body = '<html><h1 style=\"text-align:center;\">Quote Information</h1><br/><br/><table align=\"center\"><tr><td>Quote Name</td><td>' + q.Name + '</td></tr><tr><td>Account Name</td><td>' + q.Account_Name__c + '</td></tr><tr><td>Contact Name</td><td>' + q.ContactName__c + '</td></tr><tr><td>Phone Number</td><td>' + q.Account_Phone__c + '</td></tr></table></html>';
            System.debug('HTML is ' + body);

            attach.Body = Blob.toPDF(body);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            toAddresses.add('aquib.javed@absyz.com');
            mail.setToAddresses(toAddresses);
            mail.setSubject('Pre order visit requested');
            mail.setHtmlBody('PFA');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {
                attach
            });
            mails.add(mail);


        }
        if (!mails.isEmpty()) {
            try {
                Messaging.SendEmail(mails);
            } catch (exception e) {
                system.debug('Exception is:' + e);
            }
        }*/
    }
    
    /*  
         Method Name    : CreateInstallation
         Purpose        : Create installation if ETA date is filled in quote
         Input Parameter: List of Quote
         Created Date   : August 2016
         */
 /*   public static void CreateInstallation(List < Quote__c > newTrigger){
        system.debug('Inside CreateInstallation ');
        system.debug('Value of newTrigger' + newTrigger);
        
                    system.debug('Inside firstRun ');
         set<id> QuoteSetIds = new set<id>();
        for(Quote__c q : newTrigger ){
            system.debug('Inside first for');
            QuoteSetIds.add(q.id);
        }
        
        List<Order> orderList = [SELECT id , Name , AccountId, Contact__c , Project__c FROM Order WHERE NanaQuote__c in: QuoteSetIds] ; 
        system.debug('Value of  orderList ' + orderList);  
      
        list<Installation__c> lstInstallation = new list<Installation__c>();


        if(orderList.size() > 0 ){
        for(order ord : orderList){
            for(Quote__c quo : newTrigger){
                system.debug('Inside for');
            
                lstInstallation.add(new Installation__c(
                        Account__c = ord.AccountId, 
                        Contact__c = ord.Contact__c,
                        Order__c = ord.id , 
                        Project__c = ord.Project__c , 
                        Installation_Date__c = quo.ETA_Jobsite__c
                   ) );
            
        }

        }
    }

    try{
            system.debug('Inside try');
           insert lstInstallation ; 
        }
        catch(exception e){
            system.debug('Exception is:' +e);
        }
    } */
   
}