<fcrinitdata>
  <objecttype fieldtype="Lead">
    <field>
      <apiname>Company</apiname>
      <label>Company</label>
      <targetvalue>fcdpl_1</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>FirstName</apiname>
      <label>First Name</label>
      <targetvalue>fcrm-first</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>PostalCode</apiname>
      <label>Zip/Postal Code</label>
      <targetvalue>98144</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>LastName</apiname>
      <label>Last Name</label>
      <targetvalue>fcrm-last</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>Country</apiname>
      <label>Country</label>
      <targetvalue>United States</targetvalue>
      <type>string</type>
    </field>
  </objecttype>
  <objecttype fieldtype="Contact">
    <field>
      <apiname>LastName</apiname>
      <label>LastName</label>
      <targetvalue>fcdpl_1</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>FirstName</apiname>
      <label>First Name</label>
      <targetvalue>fcrm-first</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>MailingPostalCode</apiname>
      <label>Mailing Zip/Postal Code</label>
      <targetvalue>98144</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>MailingCountryCode</apiname>
      <label>Mailing Country Code</label>
      <targetvalue>US</targetvalue>
      <type>picklist</type>
    </field>
  </objecttype>
  <objecttype fieldtype="Campaign">
    <field>
      <apiname>Name</apiname>
      <label>Name</label>
      <targetvalue>fcdpcp_1</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>IsActive</apiname>
      <label>IsActive</label>
      <targetvalue>true</targetvalue>
      <type>boolean</type>
    </field>
  </objecttype>
  <objecttype fieldtype="Opportunity">
    <field>
      <apiname>Name</apiname>
      <label>Name</label>
      <targetvalue>fcdpco_1</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>CloseDate</apiname>
      <label>CloseDate</label>
      <targetvalue>5</targetvalue>
      <type>date</type>
    </field>
    <field>
      <apiname>StageName</apiname>
      <label>StageName</label>
      <targetvalue>false</targetvalue>
      <type>string</type>
    </field>
  </objecttype>
  <objecttype fieldtype="Account">
    <field>
      <apiname>Name</apiname>
      <label>Name</label>
      <targetvalue>fcdpa_1</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>BillingCountryCode</apiname>
      <label>Billing Country Code</label>
      <targetvalue>US</targetvalue>
      <type>picklist</type>
    </field>
    <field>
      <apiname>BillingPostalCode</apiname>
      <label>Billing Zip/Postal Code</label>
      <targetvalue>98144</targetvalue>
      <type>string</type>
    </field>
  </objecttype>
  <objecttype fieldtype="CampaignMember" />
  <objecttype fieldtype="User">
    <field>
      <apiname>Alias</apiname>
      <label>Alias</label>
      <targetvalue>fcdpu_1</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>Email</apiname>
      <label>Email</label>
      <targetvalue>fcdpu_1@fullcirclecrm.com</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>FirstName</apiname>
      <label>FirstName</label>
      <targetvalue>fcdpu_2</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>LastName</apiname>
      <label>LastName</label>
      <targetvalue>fcdpu_3</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>TimeZoneSidKey</apiname>
      <label>TimeZoneSidKey</label>
      <targetvalue>America/Los_Angeles</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>UserName</apiname>
      <label>UserName</label>
      <targetvalue>fcdpu_3@fullcirclecrm.com</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>UserPermissionsMarketingUser</apiname>
      <label>UserPermissionsMarketingUser</label>
      <targetvalue>true</targetvalue>
      <type>boolean</type>
    </field>
    <field>
      <apiname>LocaleSidKey</apiname>
      <label>LocaleSidKey</label>
      <targetvalue>en_US</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>EmailEncodingKey</apiname>
      <label>EmailEncodingKey</label>
      <targetvalue>UTF-8</targetvalue>
      <type>string</type>
    </field>
    <field>
      <apiname>LanguageLocaleKey</apiname>
      <label>LanguageLocaleKey</label>
      <targetvalue>en_US</targetvalue>
      <type>string</type>
    </field>
  </objecttype>
  <objecttype fieldtype="OpportunityLineItem" />
  <objecttype fieldtype="Event" />
  <objecttype fieldtype="Task" />
  <addproduct></addproduct>
  <testbypass>B0-5,BV-5,BX-5,BK-12,AP,BC,BD-3,R-2,R-3,AI-2,BN,O-2,M,BM,BJ-1,BD-1</testbypass>
  <specialcodes></specialcodes>
</fcrinitdata>