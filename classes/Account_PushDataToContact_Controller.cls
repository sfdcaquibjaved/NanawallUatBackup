public with sharing class Account_PushDataToContact_Controller {
    private map<string,string> fieldmap = null;
    private map<string,string> getfieldmap() {
        if( fieldmap == null )
        {
            //any field mappings should be put in here
            //if you add it to this list it will be availabel on the UI for matching
            //map key is account field, value is contact field
            //NB: Make sure all of the account fields are looked up in teh VF front end
            fieldmap = new map<string,string>();

            fieldmap.put('phone','phone'); //otherphone, assistantphone, fax, mobilephone,homephone,office_ext__c
            fieldmap.put('fax','fax'); //otherphone, assistantphone, fax, mobilephone,homephone,office_ext__c
 
//          fieldmap.put('company_email__c','email'); 

            fieldmap.put('billingcity','mailingcity');
            fieldmap.put('shippingcity','othercity');//

//          fieldmap.put('city__c','city__c');

            //fieldmap.put('lastname','lastname');
            //fieldmap.put('firstname','firstname');

            fieldmap.put('billingpostalcode','mailingpostalcode');//
            fieldmap.put('shippingpostalcode','otherpostalcode');//
//          fieldmap.put('zip__c','zip__c');

            fieldmap.put('billingstate','mailingstate'); //
            fieldmap.put('shippingstate','otherstate');//
//          fieldmap.put('state__c','state__c');

//          fieldmap.put('country__c','country__c');
            fieldmap.put('billingcountry','mailingcountry');//
            fieldmap.put('shippingcountry','othercountry');//

//          fieldmap.put('address_1__c','address_1__c'); //address_2__c
//          fieldmap.put('address_2__c','address_2__c'); //address_2__c
            fieldmap.put('billingstreet','mailingstreet');//
            fieldmap.put('shippingstreet','otherstreet');//


            
            
        }
        return fieldmap;
    }
    private list<string> validAccountFields = null;
    private boolean IsAValidAccountField( string fieldname) {
        return this.getfieldmap().containskey(fieldname);
    }   
    
    
    public class ContactFieldMatchObj {
    
        private Contact contact = null;
        public Contact getContact() { return contact; }
        list<FieldObj> availableFields = new list<fieldObj>();
        public list<FieldObj> getAvailableFields(){ return availableFields; }
        
        public string getFirstName() { return contact.FirstName; }
        public string getLastName() { return contact.Lastname; }
        public string getID() { return contact.Id; }
        
        
        public ContactFieldMatchObj( Contact c, list<FieldObj> fields ) {
        
            contact = c;
            availablefields = fields;
        }
    }
    
    public class FieldObj {
        private string fieldName = '';
        public string getName() { return fieldName; }
        
        private boolean useField = true;
        public boolean getUseField(){ return useField; }
        public void setUseField(boolean use ){  useField = use; }
        
        private string fieldvalue = '';
        public string getValue() { return fieldvalue;   }
        
        private Schema.SObjectField fieldData = null;
        public string getLabel() {
            if( fielddata != null )
            {
                return fieldData.getDescribe().getLabel();
            } else return '';
        }
        
        private string targetfieldLabel = '';
        public string getTargetLabel() { 
            return targetfieldlabel;

        }
        

        
        public FieldObj (string Name, Schema.SObjectField Data, string Value, string TargetFieldLabel) {


            this.fieldname = Name; 
            this.fielddata = Data;
            this.fieldvalue = Value;
            this.targetFieldLabel = TargetFieldLabel;
//          if(fieldvalue == null || fieldvalue == '' ) 
//              useField = false;
            useField = true;
        }
    }
    
    private final Account a;
    public Account_PushDataToContact_Controller(ApexPages.StandardController stdController) {
        this.a = (Account)stdController.getRecord();
    }

//  private list<FieldObj> accountfields = null;
    public list<FieldObj> getaccountfields() {
//      if( accountfields == null)
//      {
             list<FieldObj> accountfields = new list<FieldObj>();
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Account.fields.getMap();
    
            SObject sA = this.a;
                            

            for( String s : M.keySet() )
            {
                if( this.IsAValidAccountField(s))
                    accountfields.add( new FieldObj( s, m.get(s),  string.valueOf(sA.get( s )), this.getfieldmap().get(s) ) );
            }
    //  }
    
        return accountfields;
    }

    private list<ContactFieldMatchObj> contacts = null;
    public list<ContactFieldMatchObj> getContacts() {
        if( contacts == null )
        {
            contacts = new list<ContactFieldMatchObj>();
//          list<FieldObj> fields = getaccountfields();
            for( Contact c : [SELECT id, FirstName, LastName FROM Contact WHERE AccountID = :a.id ] )
            {
                contacts.add( new ContactFieldMatchObj(c,getaccountfields() ) );
            }
        }
        return contacts;
    }
    string debugtext = '';
    public string getdebugtext(){ return debugtext; }
    
    
    public boolean copyfinished = false;
    public boolean getcopyfinished() { return copyfinished; }
    public pagereference CopyFields() {
        
/*
             list<FieldObj> accountfields = new list<FieldObj>();
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Contact.fields.getMap();
        debugtext = '';
            for( String s : M.keySet() )
            {
                debugtext += s + '\n';
            }


        return null;
*/      
        debugtext = '';
        map<string,string> fieldMap = getfieldmap();
        list<contact> conts = new list<contact>();
        SObject sA = this.a;
        for( ContactFieldMatchObj cfo : getContacts() )
        {
debugtext += 'Contact: ' + cfo.getFirstName()+' '+cfo.getLastName() + '\n';
            Sobject c = cfo.getContact();
            boolean addCont = false;
            for( FieldObj fo : cfo.availableFields )
            {
                if( fo.getUseField() )
                {
                    try {
                        if( sA.get( fo.getName() ) != null )
                        {
                            c.put( fieldMap.get(fo.getName()), sA.get( fo.getName() ) );
debugtext += '\t\tCopying ' + fo.getLabel() + ' ; ' + sA.get( fo.getName() )+ '\n';
                            addCont = true;
                        } else if(fo.getName() == 'Address_2__c') {
                            //a/p ticket #17077 laura wants to overwrite address 2
                            c.put( fieldMap.get(fo.getName()), '' );
                            addCont = true;
                        } else {

                                                        
debugtext += '\t\tSkipping null field '+fo.getLabel()+'.\n';                        
                        }
                    } catch( Exception ex) {
ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.ERROR, ex + ' ; ' + fo.getName() + ' ; ' + fieldMap.get(fo.getName()) + ' ; ' + sA.get( fo.getName() ) ));
                    
                    }
                }
            }
            if( addCont) conts.add( (Contact)c );
debugtext += '-----------------\n';         
        }
        
        if( conts.size() > 0 ) 
        {
            
            System.debug('$$$$$$$$$$$$' + conts);
            
            copyfinished = true;
            try{
            update conts;
            }
            Catch (Exception ex){
                ApexPages.addMessages(ex);  
                copyfinished = false;
                System.debug('EXCEPTION Message' + ex);
                return null;
            }
//ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, debugtext ));        
        } else
        {
            ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.INFO, ' No data was actually copied. Either you did not select a field or you selected fields with null values.' ));     
        }
    
    
        return null;
    }
}