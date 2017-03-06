public class Async_WebServiceCaller {





    @future (callout=true)
    public static void ChangeEloquaEmailAddress(map<string,string> emails) {
        
        
        //format is a map of emails, the key is the old email, the value is the new email to change it to
        HttpRequest  req = new HttpRequest();   
        HttpResponse response = null;
        Http http = new Http();
        try 
        {
            for(string key : emails.keySet() )
            {       
                req.setEndpoint('http://now.eloqua.com/e/f2?elqSiteID=1745&elqFormName=changeEmailAddress&emailAddress='+key+'&newEmailAddress=' + emails.get(key)  );
                req.setMethod('GET') ;
                response = http.send(req);
            }
            
             /*
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'kristian.stout@gmail.com'}; 
            mail.setToAddresses( toAddresses );
            mail.setReplyTo('admin@a-stechnologies.com');   
            mail.setSenderDisplayName('Salesforce - ChangeEloquaEmailAddress ');
            mail.setSubject('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails.'  );
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails. It worked!'  );
            mail.setHtmlBody('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails. It Worked!'   );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
            */
            
        } catch(Exception ex){
            /*
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[]  toAddresses = new String[] {'kristian.stout@gmail.com'}; 
            mail.setToAddresses( toAddresses );
            mail.setReplyTo('admin@a-stechnologies.com');   
            mail.setSenderDisplayName('Salesforce - ChangeEloquaEmailAddress - EXCEPTION ');
            mail.setSubject('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails - EXCEPTION.'  );
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails.' + ex );
            mail.setHtmlBody('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails.' + ex  );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
*/      
            Utility.JimDebug(ex, 'async flush eloqua email');

        }
/*  */
        //http://now.eloqua.com/e/f2?elqSiteID=1745&elqFormName=changeEmailAddress&emailAddress=<current_email_address>&newEmailAddress=<new_email_address>
    }

    @future (callout=true)
    public static void FlushNanaCache( set<id> ListIDs, string ObjectType )
    {
        try { 
            
            SalesforceGateway_20101006.SalesforceGateway_20101006Soap sfgw = new SalesforceGateway_20101006.SalesforceGateway_20101006Soap();
            SalesforceGateway_20101006.ArrayOfString out = new SalesforceGateway_20101006.ArrayOfString();
            out.string_x = new list<string>();
            for( Id i : ListIDs )
                out.string_x.add(i);    
        
        
            if( out.string_x.size() > 0 ) sfgw.FlushCache(out, ObjectType);
        } catch( Exception ex )
        {
        
            Utility.JimDebug(ex, 'async flush ' + ObjectType);
        
        }      
    }
    

    
    @future (callout=true)
    public static void SynchronizeAccounts( set<id> accountListID )
    {
       try 
        {

            SalesforceGateway_20101006.SalesforceGateway_20101006Soap sfgw = new SalesforceGateway_20101006.SalesforceGateway_20101006Soap();
            SalesforceGateway_20101006.ArrayOfWsoCompany out = new SalesforceGateway_20101006.ArrayOfWsoCompany();
            
            out.wsoCompany  = new SalesforceGateway_20101006.wsoCompany[]{};            
            List<Account> accountList = [Select Id, OwnerID, Certified_Installer__c, Name, Type, Address_1__c, Address_2__c, City__c, State__c, Zip__c, Country__c, Phone, Fax, Company_Email__c, Website, Description FROM account WHERE Id IN :accountListID];
            for( Account c : accountList )
            {
                
                SalesforceGateway_20101006.wsoCompany company  = new SalesforceGateway_20101006.wsoCompany();
                company.CompanyID = 0;
                company.Name = c.Name;
                company.SalesForceID = c.Id;
                company.CompanyTypeName = c.Type;
                company.Address = new SalesforceGateway_20101006.wsoAddress();
        
                company.Address.Street1 = c.Address_1__c;
                company.Address.Street2 = c.Address_2__c;
                company.Address.City = c.City__c;
                company.Address.State = c.State__c;
                company.Address.Zip = c.Zip__c;
                company.Address.Country = c.Country__c;
                company.Office = c.Phone;
                company.Fax = c.Fax;
                company.Email = c.Company_Email__c;
                company.WebSite = c.Website;
                company.Notes = c.Description;
                company.CertifiedInstaller = c.Certified_Installer__c;
                system.debug( 'KDS TEST: ' + c.Name + ' ; ' + c.Certified_Installer__c + ' ; ' + c.Id );
                company.SalesforceOwnerID = c.OwnerId;
                
                out.wsoCompany.add( company);
            }
            
            if( out.wsoCompany.size() > 0 ) sfgw.SynchronizeCompanyListFromSF( out );
                //      Utility.JimDebug(null, 'synchronize accounts ' + out.wsoCompany.size());
            
                
        } catch( Exception e ) {
            
            Utility.JimDebug(e, 'async contacts');
        }
    }
    
    @future (callout=true)
    public static void SynchronizeContacts( set<id> contactListID )
    {
        integer line = 0;
        try 
        {
            
            SalesforceGateway_20101006.SalesforceGateway_20101006Soap sfgw = new SalesforceGateway_20101006.SalesforceGateway_20101006Soap();
            SalesforceGateway_20101006.ArrayOfWsoLead out = new SalesforceGateway_20101006.ArrayOfWsoLead();
            
            out.wsoLead  = new SalesforceGateway_20101006.wsoLead[]{};          
            
            List<Contact> contactList = [Select Id, Email_Newsletter__c,OwnerID, LastName, FirstName,OtherPhone,Source_Date__c,Interest__c,MobilePhone,HomePhone,Email,Office_Ext__c,Fax,Phone,Title,Reg_Number__c, AccountID,LeadSource,LeadType__c, Address_1__c, Address_2__c, City__c, State__c, Zip__c, Country__c,No_Tax__c, Newsletter__c,  Description FROM contact WHERE Id IN :contactListID ];
            for( Contact c : contactList )
            {
line = 0;               
                SalesforceGateway_20101006.wsoLead lead = new SalesforceGateway_20101006.wsoLead();
line++;             
                lead.LeadId = 0;
                lead.FirstName = c.FirstName;
                lead.LastName = c.LastName;
                lead.SalesForceID = c.Id;
                lead.CompanySalesForceID = c.AccountID;
                lead.LeadSource = c.LeadSource;
                lead.LeadType = c.LeadType__c;
                lead.SalesforceOwnerID = c.OwnerId;
                lead.Title = c.Title;
                lead.Email = c.Email;
                lead.Office = c.Phone;
                lead.Fax = c.Fax;
                lead.Office2 = c.OtherPhone;
                lead.Cell = c.MobilePhone;
                lead.OfficeExt = c.Office_Ext__c;
                lead.Home = c.HomePhone;
                lead.Interest = c.Interest__c;
line++;             
                lead.AddressObj = new SalesforceGateway_20101006.wsoAddress();
        
                lead.AddressObj.Street1 = c.Address_1__c;
                lead.AddressObj.Street2 = c.Address_2__c;
                lead.AddressObj.City = c.City__c;
                lead.AddressObj.State = c.State__c;
                lead.AddressObj.Zip = c.Zip__c;
                lead.AddressObj.Country = c.Country__c;
                lead.RegNumber = c.Reg_Number__c;
        
                lead.NoTax = c.No_Tax__c;
                //lead.Newsletter = c.Newsletter__c; 
                lead.Newsletter = c.Email_Newsletter__c;
                
                lead.Notes = c.Description;
        
line++;     

    
                out.wsoLead.add(lead);
line++;             
            }
            
            if( out.wsoLead.size() > 0 ) 
            {
line = 100;             
                sfgw.SynchronizeLeadListFromSF( out );
    
            }
        //  Utility.JimDebug(null, 'synchronize contacts ' + contactListID.size());
        } catch( Exception e ) {
 
            Utility.JimDebug(e, 'async lead');
        }
    }
}