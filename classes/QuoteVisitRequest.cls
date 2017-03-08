/*************************************************************************\
    @ Author        : Absyz Software Consulting Pvt. Ltd.
    @ Date          : 03-November-2016
    @ Test File     : 
    @ Description   : 
    @ Audit Trial   : 
    @ Last Modified Date : 03-November-2016
  
****************************************************************************/ 

global class QuoteVisitRequest {
    
      /*  
         Method Name    : CreatePreInstallation
         Purpose        : Create installation if button is clicken on quote
         Input Parameter: ID , ID , ID
         Created Date   : November 2016
         */
    
    webservice static boolean CreatePreInstallation(string QuoteID , string ProjectID , string ContactID) {
        list<Installation__c> lstInstallation = new list<Installation__c>();
        system.debug('I am here');
        system.debug('QuoteID' +QuoteID);
        system.debug('ProjectID' +ProjectID);
        system.debug('ContactID' +ContactID);
        boolean validate = true;
         List<Contact> ContactList = [SELECT Id, AccountID From Contact WHERE ID =: ContactID ] ; 
        system.debug('Value of ContactList' +ContactList);
        ID preRecordType = Schema.SObjectType.Installation__c.getRecordTypeInfosByName().get('Pre Installation Visit').getRecordTypeId() ;
        
        system.debug('Value of preRecordType' + preRecordType);
         for(Contact con : ContactList) {
            
			     system.debug('Inside for');              	
                 lstInstallation.add(new Installation__c(
                     	
                        Account__c = con.AccountId, 
                        Contact__c = con.ID,
                       // Installation_Date__c = System.today(),
                        Quote_Name__c = QuoteID, 
                     	RecordTypeID = preRecordType ,
						 Project__c = ProjectID 
                        
                 )) ; 	
            
        }
        
      try{
              system.debug('Inside try');
          	system.debug('The value of lstInstallation' + lstInstallation);
 			database.SaveResult[] srList = database.insert(lstInstallation,false);
            system.debug('The value of srList' +srList);
          for(database.SaveResult sr : srList){
              if(sr.isSuccess()){
                validate = true ;  
                  system.debug('Inside if value of validate' +validate);
              } else{
                  system.debug('Inside else ');
                validate = false;  
              }
          }
          return validate;
        }
        catch(exception e){
            system.debug('Exception is:' +e);
          validate = false;
            return validate;
        }
       
      return validate;  
    }

}