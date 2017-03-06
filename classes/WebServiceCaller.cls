public class WebServiceCaller {

/*
    public static void CallAccountWebService( Id AccountID) 
    {

        Account c = [Select Id, OwnerID, Certified_Installer__c, Name, Type, Address_1__c, Address_2__c, City__c, State__c, Zip__c, Country__c, Phone, Fax, Company_Email__c, Website, Description FROM account WHERE Id = :AccountID];
        SalesforceGateway.SalesforceGatewaySoap sfgw = new SalesforceGateway.SalesforceGatewaySoap();
        SalesforceGateway.wsoCompany company  = new SalesforceGateway.wsoCompany();
        company.CompanyID = 0;
        company.Name = c.Name;   
        company.SalesForceID = c.Id;
        company.CompanyTypeName = c.Type;
        company.Address = new SalesforceGateway.wsoAddress();

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
        
        sfgw.SynchronizeCompanyFromSF( company );






        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('admin@a-stechnologies.com');   
        mail.setSenderDisplayName('Salesforce - Nana Sync Department');
        mail.setSubject('Account Service has been called' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' Webservice called for account ' + c.Id + ' ; ' + c.Name   );
        mail.setHtmlBody('Webservice called for account ' + c.Id + ' ; ' + c.Name  );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           
    }
*/


/*
    public static void CallContactWebService( Id ContactID ) 
    {

        Contact c = [Select Id, OwnerID, LastName, FirstName,OtherPhone,Source_Date__c,Interest__c,MobilePhone,HomePhone,Email,Office_Ext__c,Fax,Phone,Title,Reg_Number__c, AccountID,LeadSource,LeadType__c, Address_1__c, Address_2__c, City__c, State__c, Zip__c, Country__c,No_Tax__c, Newsletter__c, Competitor__c, Description FROM contact WHERE Id = :ContactID ];
        SalesforceGateway.SalesforceGatewaySoap sfgw = new SalesforceGateway.SalesforceGatewaySoap();
        SalesforceGateway.wsoLead lead = new SalesforceGateway.wsoLead();
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
        
        lead.AddressObj = new SalesforceGateway.wsoAddress();

        lead.AddressObj.Street1 = c.Address_1__c;
        lead.AddressObj.Street2 = c.Address_2__c;
        lead.AddressObj.City = c.City__c;
        lead.AddressObj.State = c.State__c;
        lead.AddressObj.Zip = c.Zip__c;
        lead.AddressObj.Country = c.Country__c;
        lead.RegNumber = c.Reg_Number__c;

        lead.NoTax = c.No_Tax__c;
        lead.Newsletter = c.Newsletter__c; 
        lead.Competitor = c.Competitor__c;
        lead.Notes = c.Description;


        if( c.Source_Date__c != null )
        {
            lead.SourceDate = c.Source_Date__c.format();
        }


        
        sfgw.SynchronizeLeadFromSF( lead );

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'kristian.stout@a-stechnologies.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('admin@a-stechnologies.com');   
        mail.setSenderDisplayName('Salesforce - Nana Sync Department');
        mail.setSubject('Contact Service has been called' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' Webservice called for Contact ' + c.Id + ' ; ' + c.FirstName+ ' ' + c.LastName   );
        mail.setHtmlBody('Webservice called for Contact ' + c.Id + ' ; ' + c.FirstName+ ' ' + c.LastName  );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           

    }
*/

/*
    public static void CallOpportunityWebService( Id OppID, Boolean LeadConvert ) {

//Select o.Id, (Select ContactId From OpportunityContactRoles) From Opportunity o Where o.Id = 006A0000002EB2s
    
        //Opportunity o = [select o.Id, o.Name, o.OwnerID, (Select c.ContactId, c.Role From OpportunityContactRoles c),(SELECT t.UserId FROM OpportunityTeamMembers t)   FROM Opportunity o WHERE o.Id = :OppID];
        Opportunity o = [select o.Id, o.Name, o.Application__c, o.OwnerID, Type, Site_Address__c,Address_2__c, Country__c, State__c, City__c, Postal_Code__c, Review_Code__c, StageName, Chain_Account__c, NIS__c, Description, (Select Contact__c, Role__c from nrOpportunityContactRoles__r ) ,(SELECT User__c, Commission__c FROM nrOpportunityTeamMembers__r t)   FROM Opportunity o WHERE o.Id = :OppID];
        
        SalesforceGateway.SalesforceGatewaySoap sfgw = new SalesforceGateway.SalesforceGatewaySoap();
        SalesforceGateway.wsoProject proj = new SalesforceGateway.wsoProject();
        proj.SalesforceLeadConvert = LeadConvert; //this flags whether the save is a product of a Lead conversion or a general save

        proj.ProjectName = o.Name;
        proj.SalesForceID = o.Id;
        proj.ProjectID = 0;
        proj.SalesforceOwnerID = o.OwnerId;
//        proj.ProjectTypeName = o.Type;
		proj.ProjectTypeName = o.Application__c;        
        
        
        proj.Address = new SalesforceGateway.wsoAddress();

        proj.Address.Street1 = o.Site_Address__c;
        proj.Address.Street2 = o.Address_2__c;
        proj.Address.City = o.City__c;
        proj.Address.State = o.State__c;
        proj.Address.Zip = o.Postal_Code__c;
        proj.Address.Country = o.Country__c;
        proj.ReviewCode = o.Review_Code__c;
        proj.Status= o.StageName;
        proj.ChainAccount = o.Chain_Account__c;
        proj.NIS = o.NIS__c;
        proj.Notes = o.Description;


        String contactString = '';

        proj.LeadList = new SalesforceGateway.ArrayOfWsoLead();
        proj.LeadList.wsoLead = new List<SalesforceGateway.wsoLead>();
        
        for(nrOpportunityContactRole__c ocr : o.nrOpportunityContactRoles__r ) {
contactString += 'Added lead: '+ ocr.Contact__c + ' ; ';        	
            SalesforceGateway.wsoLead wlead = new SalesforceGateway.wsoLead();
            wlead.SalesforceID = ocr.Contact__c;
            wlead.SalesForceRole = ocr.Role__c;
            wlead.LeadID = 0;
            wlead.FirstName = 'SF Proj Sync';
            wlead.LastName = 'SF Proj Sync';
            wlead.Competitor = false;
            wlead.Newsletter = false;
            wlead.NoTax = false;
            proj.LeadList.wsoLead.add(wlead);
        }
        
        proj.RepList = new SalesforceGateway.ArrayOfWsoRep();
        proj.RepList.wsoRep = new List<SalesforceGateway.wsoRep>();

        for( nrOpportunityTeamMember__c otm : o.nrOpportunityTeamMembers__r )
        {
            SalesforceGateway.wsoRep wrep = new SalesforceGateway.wsoRep();
            wrep.SalesforceID = otm.User__c;
            wrep.Commission = otm.Commission__c.intValue();
            
            proj.RepList.wsoRep.add(wrep);
        }   

        
        sfgw.SynchronizeProjectFromSF( proj );

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'stout@kristianstout.com'}; 
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('admin@a-stechnologies.com');   
        mail.setSenderDisplayName('Salesforce - Nana Sync Department');
        mail.setSubject('Oppsync has been called' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(' oppsync was called for opportunity ' + o.Id + ' ; ' + o.Name + ' ; ' + contactString + '  ;  lead list size ' + proj.LeadList.wsoLead.size()   );
        mail.setHtmlBody('oppsync was called for opportunity ' + o.Id + ' ; ' + o.Name  + ' ; ' + contactString + '  ;  lead list size ' + proj.LeadList.wsoLead.size() );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });           

    }
*/    

    
}