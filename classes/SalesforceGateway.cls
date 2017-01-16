public class SalesforceGateway {
    public class wsoProject {
        public String Notes;
        public Boolean NIS;
        public Boolean ChainAccount;
        public String Status;
        public String ReviewCode;
        public String ProjectTypeName;
        public SalesforceGateway.wsoAddress Address;
        public Boolean SalesforceLeadConvert;
        public String SalesforceOwnerID;
        public SalesforceGateway.ArrayOfWsoRep RepList;
        public SalesforceGateway.ArrayOfWsoLead LeadList;
        public String SalesforceLeadListString;
        public String SalesForceID;
        public Integer ProjectID;
        public String ProjectName;
        public SalesforceGateway.ArrayOfInt QuoteIDs;
        private String[] Notes_type_info = new String[]{'Notes','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] NIS_type_info = new String[]{'NIS','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] ChainAccount_type_info = new String[]{'ChainAccount','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] Status_type_info = new String[]{'Status','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ReviewCode_type_info = new String[]{'ReviewCode','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ProjectTypeName_type_info = new String[]{'ProjectTypeName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Address_type_info = new String[]{'Address','http://tempuri.org/','wsoAddress','0','1','false'};
        private String[] SalesforceLeadConvert_type_info = new String[]{'SalesforceLeadConvert','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] SalesforceOwnerID_type_info = new String[]{'SalesforceOwnerID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RepList_type_info = new String[]{'RepList','http://tempuri.org/','ArrayOfWsoRep','0','1','false'};
        private String[] LeadList_type_info = new String[]{'LeadList','http://tempuri.org/','ArrayOfWsoLead','0','1','false'};
        private String[] SalesforceLeadListString_type_info = new String[]{'SalesforceLeadListString','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SalesForceID_type_info = new String[]{'SalesForceID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ProjectID_type_info = new String[]{'ProjectID','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] ProjectName_type_info = new String[]{'ProjectName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] QuoteIDs_type_info = new String[]{'QuoteIDs','http://tempuri.org/','ArrayOfInt','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'Notes','NIS','ChainAccount','Status','ReviewCode','ProjectTypeName','Address','SalesforceLeadConvert','SalesforceOwnerID','RepList','LeadList','SalesforceLeadListString','SalesForceID','ProjectID','ProjectName','QuoteIDs'};
    }
    public class wsoAddress {
        public String Street1;
        public String Street2;
        public String City;
        public String State;
        public String Zip;
        public String Country;
        private String[] Street1_type_info = new String[]{'Street1','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Street2_type_info = new String[]{'Street2','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] City_type_info = new String[]{'City','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] State_type_info = new String[]{'State','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Zip_type_info = new String[]{'Zip','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Country_type_info = new String[]{'Country','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'Street1','Street2','City','State','Zip','Country'};
    }
    public class ArrayOfInt {
        public Integer[] int_x;
        private String[] int_x_type_info = new String[]{'int','http://www.w3.org/2001/XMLSchema','int','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'int_x'};
    }
    public class XML_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class SalesForceGatewaySoap {
        public String endpoint_x = 'http://nanareps.com/webservices/Salesforcegateway.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/', 'SalesforceGateway'};
        public void SynchronizeProjectFromSF(SalesforceGateway.wsoProject wProject) {
            SalesforceGateway.SynchronizeProjectFromSF_element request_x = new SalesforceGateway.SynchronizeProjectFromSF_element();
            SalesforceGateway.SynchronizeProjectFromSFResponse_element response_x;
            request_x.wProject = wProject;
            Map<String, SalesforceGateway.SynchronizeProjectFromSFResponse_element> response_map_x = new Map<String, SalesforceGateway.SynchronizeProjectFromSFResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/SynchronizeProjectFromSF',
              'http://tempuri.org/',
              'SynchronizeProjectFromSF',
              'http://tempuri.org/',
              'SynchronizeProjectFromSFResponse',
              'SalesforceGateway.SynchronizeProjectFromSFResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public void SynchronizeCompanyFromSF(SalesforceGateway.wsoCompany wCompany) {
            SalesforceGateway.SynchronizeCompanyFromSF_element request_x = new SalesforceGateway.SynchronizeCompanyFromSF_element();
            SalesforceGateway.SynchronizeCompanyFromSFResponse_element response_x;
            request_x.wCompany = wCompany;
            Map<String, SalesforceGateway.SynchronizeCompanyFromSFResponse_element> response_map_x = new Map<String, SalesforceGateway.SynchronizeCompanyFromSFResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/SynchronizeCompanyFromSF',
              'http://tempuri.org/',
              'SynchronizeCompanyFromSF',
              'http://tempuri.org/',
              'SynchronizeCompanyFromSFResponse',
              'SalesforceGateway.SynchronizeCompanyFromSFResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public void SynchronizeLeadFromSF(SalesforceGateway.wsoLead wLead) {
            SalesforceGateway.SynchronizeLeadFromSF_element request_x = new SalesforceGateway.SynchronizeLeadFromSF_element();
            SalesforceGateway.SynchronizeLeadFromSFResponse_element response_x;
            request_x.wLead = wLead;
            Map<String, SalesforceGateway.SynchronizeLeadFromSFResponse_element> response_map_x = new Map<String, SalesforceGateway.SynchronizeLeadFromSFResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/SynchronizeLeadFromSF',
              'http://tempuri.org/',
              'SynchronizeLeadFromSF',
              'http://tempuri.org/',
              'SynchronizeLeadFromSFResponse',
              'SalesforceGateway.SynchronizeLeadFromSFResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
    }
    public class SynchronizeCompanyFromSF_element {
        public SalesforceGateway.wsoCompany wCompany;
        private String[] wCompany_type_info = new String[]{'wCompany','http://tempuri.org/','wsoCompany','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'wCompany'};
    }
    public class SynchronizeProjectFromSF_element {
        public SalesforceGateway.wsoProject wProject;
        private String[] wProject_type_info = new String[]{'wProject','http://tempuri.org/','wsoProject','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'wProject'};
    }
    public class ArrayOfWsoRep {
        public SalesforceGateway.wsoRep[] wsoRep;
        private String[] wsoRep_type_info = new String[]{'wsoRep','http://tempuri.org/','wsoRep','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'wsoRep'};
    }
    public class SynchronizeLeadFromSFResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class wsoLead {
        public String SalesForceOwnerID;
        public String RegNumber;
        public String Title;
        public String LeadSource;
        public String SourceDate;
        public Boolean NoTax;
        public Boolean Newsletter;
        public Boolean Competitor;
        public String Notes;
        public String LeadType;
        public SalesforceGateway.wsoAddress AddressObj;
        public String CompanySalesForceID;
        public String SalesForceID;
        public String SalesForceRole;
        public Integer LeadID;
        public String Email;
        public String Interest;
        public String FirstName;
        public String LastName;
        public String Cell;
        public String Office;
        public String OfficeExt;
        public String Office2;
        public String Home;
        public String Address;
        public String City;
        public String State;
        public String Zip;
        public String Country;
        public String Fax;
        public String CompanyName;
        private String[] SalesForceOwnerID_type_info = new String[]{'SalesForceOwnerID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] RegNumber_type_info = new String[]{'RegNumber','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Title_type_info = new String[]{'Title','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] LeadSource_type_info = new String[]{'LeadSource','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SourceDate_type_info = new String[]{'SourceDate','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] NoTax_type_info = new String[]{'NoTax','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] Newsletter_type_info = new String[]{'Newsletter','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] Competitor_type_info = new String[]{'Competitor','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] Notes_type_info = new String[]{'Notes','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] LeadType_type_info = new String[]{'LeadType','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] AddressObj_type_info = new String[]{'AddressObj','http://tempuri.org/','wsoAddress','0','1','false'};
        private String[] CompanySalesForceID_type_info = new String[]{'CompanySalesForceID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SalesForceID_type_info = new String[]{'SalesForceID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SalesForceRole_type_info = new String[]{'SalesForceRole','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] LeadID_type_info = new String[]{'LeadID','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Interest_type_info = new String[]{'Interest','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] LastName_type_info = new String[]{'LastName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Cell_type_info = new String[]{'Cell','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Office_type_info = new String[]{'Office','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] OfficeExt_type_info = new String[]{'OfficeExt','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Office2_type_info = new String[]{'Office2','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Home_type_info = new String[]{'Home','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Address_type_info = new String[]{'Address','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] City_type_info = new String[]{'City','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] State_type_info = new String[]{'State','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Zip_type_info = new String[]{'Zip','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Country_type_info = new String[]{'Country','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Fax_type_info = new String[]{'Fax','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CompanyName_type_info = new String[]{'CompanyName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'SalesForceOwnerID','RegNumber','Title','LeadSource','SourceDate','NoTax','Newsletter','Competitor','Notes','LeadType','AddressObj','CompanySalesForceID','SalesForceID','SalesForceRole','LeadID','Email','Interest','FirstName','LastName','Cell','Office','OfficeExt','Office2','Home','Address','City','State','Zip','Country','Fax','CompanyName'};
    }
    public class wsoCompany {
        public String SalesforceOwnerID;
        public Boolean CertifiedInstaller;
        public String Office;
        public String Fax;
        public String Email;
        public String WebSite;
        public String Notes;
        public String CompanyTypeName;
        public SalesforceGateway.wsoAddress Address;
        public String SalesForceID;
        public String Name;
        public Integer CompanyID;
        private String[] SalesforceOwnerID_type_info = new String[]{'SalesforceOwnerID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CertifiedInstaller_type_info = new String[]{'CertifiedInstaller','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] Office_type_info = new String[]{'Office','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Fax_type_info = new String[]{'Fax','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Email_type_info = new String[]{'Email','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] WebSite_type_info = new String[]{'WebSite','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Notes_type_info = new String[]{'Notes','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CompanyTypeName_type_info = new String[]{'CompanyTypeName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Address_type_info = new String[]{'Address','http://tempuri.org/','wsoAddress','0','1','false'};
        private String[] SalesForceID_type_info = new String[]{'SalesForceID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] Name_type_info = new String[]{'Name','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CompanyID_type_info = new String[]{'CompanyID','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'SalesforceOwnerID','CertifiedInstaller','Office','Fax','Email','WebSite','Notes','CompanyTypeName','Address','SalesForceID','Name','CompanyID'};
    }
    public class ArrayOfWsoLead {
        public SalesforceGateway.wsoLead[] wsoLead;
        private String[] wsoLead_type_info = new String[]{'wsoLead','http://tempuri.org/','wsoLead','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'wsoLead'};
    }
    public class wsoRep {
        public Integer Commission;
        public String SalesforceID;
        public SalesforceGateway.XML_element XML;
        public String UserName;
        private String[] Commission_type_info = new String[]{'Commission','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] SalesforceID_type_info = new String[]{'SalesforceID','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] XML_type_info = new String[]{'XML','http://tempuri.org/','XML_element','0','1','false'};
        private String[] UserName_type_info = new String[]{'UserName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'Commission','SalesforceID','XML','UserName'};
    }
    public class SynchronizeCompanyFromSFResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class SynchronizeProjectFromSFResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class SynchronizeLeadFromSF_element {
        public SalesforceGateway.wsoLead wLead;
        private String[] wLead_type_info = new String[]{'wLead','http://tempuri.org/','wsoLead','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'wLead'};
    }
}