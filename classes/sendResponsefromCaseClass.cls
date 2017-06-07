public class sendResponsefromCaseClass {
    public static void sendreplytofromCase(list<EmailMessage> newtrigger){
        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe();
        String insfprefix;
        BrandTemplate bt = [select id, name from BrandTemplate where name = 'Nana Logos New-Service' limit 1];
        emailtemplate et = [select BrandTemplateId from emailtemplate where brandtemplateId =: bt.id limit 1];
        //Getting ID of Case Object
        for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
            if(r.getName() == 'Case'){
                insfprefix = r.getKeyPrefix();
            }
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(EmailMessage e:newtrigger) {
            string myIdPrefix = String.valueOf(e.parentId).substring(0,3);
            string body = 'Dear Customer,\nThank you for contacting us.';
                body += 'The Nanawall Service team will get back to you within 24-48 hours\n' ;
                body += 'Thanks and Regards\nNanawall Service Team';
            if(myIdPrefix.equals(insfprefix)){
               Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
               //message.setTemplateId(et.id);
               message.setSubject('Service Reply');
               message.setHtmlBody(body);
               message.setToAddresses(NEW String[]{e.FromAddress});
               //message.('service@nanwall.com');
               mails.add(message);
    }
}
          Messaging.sendEmail(mails);
    } 
}