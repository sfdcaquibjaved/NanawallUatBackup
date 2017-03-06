/******************************************
Class: CopyDataToContacts
Test Class:
Purpose:To display the contacts & Account fields to copy from Account to Contact on clicking on Copy Data button
*******************************************/
public class CopyDataToContacts {
     
     public list<Id> successfulContactIds=new list<Id>();
     public list<Contact> failureContacts{set;get;}
     public list<wrapContact> wrapContactList { get; set; }
     //public list<wrapAccount> wrapAccountList { get; set; }
     public list<wrapAccountDetails> wrapAccountFields{get;set;}
     public String contactsCopied{set;get;}
     public String fieldsTocopy{set;get;}
     public Integer noOfContactsSelected;
     public Integer noOfFieldsSelected;
     public String ContactsToUpdate{set;get;}
     public Boolean failures{set;get;}
     public boolean result;
     public boolean copyFinished{get;set;}
    // public boolean getcopyfinished() { return copyfinished; }
     public list<contact> updateContactList=new list<Contact>();
     public list<Account> updateAccountList = new List<Account>();
     public id accId{get;set;}
     public boolean bStreet{get;set;}
     public boolean bCity{get;set;}
     public boolean bState{get;set;}
     public boolean bPostalCode{get;set;}
     public List<Contact> contactList{get;set;}
     public string Info{get;set;}
     public list<Account> actsList;
     public Map<string,string> fieldDetails=new Map<string,string>();
     public Map<string,string> contactFieldMap=new Map<string,string>();
     Map<String, SObjectField> m = SObjectType.Account.fields.getMap();
     Map<String, SObjectField> c=SObjectType.Contact.fields.getMap();
     
     //Constructor
     public CopyDataToContacts(ApexPages.StandardController controller) {
     //updateContactList.clear();
         copyFinished =false;
        Info ='';
        failures=false;
        failureContacts=new list<contact>();
        result=false;
        contactsCopied='';
        ContactsToUpdate='';
        fieldsTocopy='';
        accId = controller.getRecord().id;
        //Querying the Account fields
        actsList = [select id,Name,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Phone,Fax,BillingCountryCode,ShippingCountryCode from account where id=:accId];
        wrapAccountFields=new list<wrapAccountDetails>();
        String type='Account';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType AccountSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = AccountSchema.getDescribe().fields.getMap();

        for (String fieldName: fieldMap.keySet()) {
        System.debug('##Field API Name='+fieldName);// list of all field API name
        fieldMap.get(fieldName).getDescribe().getLabel();//It provides to get the object fields label.
        fieldDetails.put(fieldMap.get(fieldName).getDescribe().getLabel(),fieldName);
        }
        
        system.debug('The fieldDetails are:::'+fieldDetails);
        
        for(string fields:fieldDetails.keySet()){
            if(fields=='Shipping City'||fields=='Shipping Street'||fields=='Shipping Country'||fields=='Shipping Zip/Postal Code'||fields=='Shipping State/Province Code'||fields=='Billing City'||fields=='Billing Country'||fields=='Billing Zip/Postal Code'||fields=='Billing State/Province Code'||fields=='Billing Street'||fields=='Account Fax'||fields=='Account Phone'||fields=='Billing Country Code'||fields=='Shipping Country Code'){
            wrapAccountFields.add(new wrapaccountDetails(fields));
        }
        system.debug('The wrapAccountFields are:::'+wrapAccountFields);
        }
        //Querying the contact fields
        List<Contact> contactList = [select id, name,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Fax,Phone,accountiD,OtherCity,OtherCountry,OtherPostalCode,OtherState,OtherStreet,OtherCountryCode,MailingCountryCode FROM contact where Accountid =:accId];
        
        wrapcontactList =new list<wrapContact>();
          for(Contact c:contactList){
           wrapContactList.add(new wrapContact(c));
          }     
          if(wrapContactList.size() == 0){
              ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.Error, 'There are no contacts associated with this Account')); 
          }
    }
    
    //Action method for Buttonclicked
    public void buttonClicked(){
    updateContactList.clear();
    noOfContactsSelected=0;
    noOfFieldsSelected =0;
    
   
    for(wrapContact wc:wrapContactList){
        if(wc.isSelected==true){
             system.debug('immmmmmmmm');
             noOfContactsSelected++;
             for(wrapAccountDetails wa:wrapAccountFields){
                 if(wa.isSelected==true && wc.isSelected==true){
                     noOfFieldsSelected ++;
                    
                         if(wa.accn=='Shipping City'){ //use custom labels
                             wc.cons.OtherCity=actsList[0].ShippingCity;
                         }
                         if(wa.accn=='Shipping Country'){
                              wc.cons.OtherCountry=actsList[0].ShippingCountry;
                          }
                         if(wa.accn=='Shipping Street'){
                             wc.cons.OtherStreet=actsList[0].ShippingStreet;
                         }
                         if(wa.accn=='Shipping Zip/Postal Code'){
                             wc.cons.OtherPostalCode=actsList[0].ShippingPostalCode;
                         }
                         if(wa.accn=='Shipping State/Province Code'){
                             wc.cons.OtherState = actsList[0].ShippingState;
                         }
                         if(wa.accn=='Shipping Country Code'){
                             wc.cons.OtherCountryCode = actsList[0].ShippingCountryCode;
                         }
                         if(wa.accn=='Billing State/Province Code'){
                             wc.cons.MailingState = actsList[0].BillingState;
                         }
                         if(wa.accn=='Billing Country'){
                             System.debug('testtt'+actsList[0].BillingCountry);
                             wc.cons.MailingCountry = actsList[0].BillingCountry;
                         }
                         if(wa.accn=='Billing Street'){
                             wc.cons.MailingStreet = actsList[0].BillingStreet;
                         }
                         if(wa.accn=='Billing Zip/Postal Code'){
                             System.debug('testttZipp'+actsList[0].BillingPostalCode+'test');
                             wc.cons.MailingPostalCode = actsList[0].BillingPostalCode;
                         }
                         if(wa.accn=='Billing City'){
                             wc.cons.MailingCity= actsList[0].BillingCity;
                         }
                         if(wa.accn=='Billing Country Code'){
                             wc.cons.MailingCountryCode= actsList[0].BillingCountryCode;
                         }
                         
                         if(wa.accn=='Account Phone'){
                              wc.cons.Phone= actsList[0].Phone;
                         }
                         if(wa.accn=='Account Fax'){
                              wc.cons.Fax= actsList[0].Fax;
                         }
                        //updateContactList.add(wc.cons);
                   }
                   else{
                       
                       //ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.Error, ' No data was actually copied. Either you did not select a field or you selected fields with null values.'));
                   }
       
              }
             
               
               if(noOfFieldsSelected > 0){
              updateContactList.add(wc.cons); 
              }
              
               system.debug('The contacts list is:::'+updateContactList);    
            }
            else
        {
           //ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.Error, ' No data was actually copied. You did not select a contact to copy' ));     
        }
    }
    
    
    if( updateContactList.size() > 0 ) {
                  
            //copyfinished = true;
            try{
            
            Database.SaveResult[] lsr = Database.update(updateContactList, false);
            for(Database.SaveResult sr:lsr)
             {
   
              if(sr.isSuccess())
          {
              copyFinished = true;
              successfulContactIds.add(sr.getId());
          }
              else{
              copyFinished = false;
              }
       }
    
    failureContacts=[select id,FirstName,LastName from contact where id IN:updateContactList AND ID NOT IN:successfulContactIds];
    if(failureContacts.size()>0){
     failures=true;
     Info = 'The following contacts doesnt have valid zip codes or Country  not matching and are not copied,either you have missed country or zip fields to copy';
    }
    else{
    failures=false;
    }
            }
            Catch (Exception ex){
                ApexPages.addMessages(ex);  
                copyFinished = false;
                System.debug('EXCEPTION Message' + ex);
            }   
        } else
        {
           ApexPages.addMessage( new ApexPages.message(ApexPages.Severity.Error, ' No data was actually copied. Either you did not select a Contact or you selected fields with null values' ));     
        }

}
    //To display the Accounts
    public class wrapAccountDetails{
    public string accn{get;set;}
    public boolean isSelected{get;set;}
     
       public wrapaccountDetails(String a){
     
         accn=a;
         isselected=false;
       }
       }
    //Wrapper class for Contacts
    public class wrapContact{
        public Contact cons{get;set;}
        public boolean isSelected{get;set;}
       public wrapContact(Contact c){
         cons=c;
         isselected=false;
       }
  }

}